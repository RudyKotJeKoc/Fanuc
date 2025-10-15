#!/usr/bin/env python3
"""
FANUC Flow Analyzer
Advanced flow analysis for FANUC programs including:
- Control flow diagrams
- State machine analysis
- Cycle flow tracking
- Homing procedure analysis
"""

import re
import sys
from pathlib import Path
from collections import defaultdict, deque
from typing import Dict, List, Set, Tuple


class FlowNode:
    """Represents a node in the control flow"""
    
    def __init__(self, label_num: int, label_name: str = ""):
        self.label_num = label_num
        self.label_name = label_name
        self.instructions = []
        self.successors = []  # List of label numbers this jumps to
        self.conditions = []  # Conditions for conditional jumps
        
    def __repr__(self):
        name_str = f":{self.label_name}" if self.label_name else ""
        return f"LBL[{self.label_num}{name_str}]"


class FANUCFlowAnalyzer:
    """Analyzes control flow in FANUC programs"""
    
    def __init__(self, program_file: str):
        self.program_file = program_file
        self.program_name = Path(program_file).stem
        self.flow_nodes = {}  # label_num -> FlowNode
        self.entry_point = None
        self.error_nodes = []
        self.main_cycle_labels = []
        
    def parse_program(self):
        """Parse the program and build flow graph"""
        with open(self.program_file, 'r', encoding='latin-1', errors='ignore') as f:
            content = f.read()
        
        # Extract /MN section
        mn_match = re.search(r'/MN(.*?)/(?:POS|END)', content, re.DOTALL)
        if not mn_match:
            return
        
        code_text = mn_match.group(1)
        lines = code_text.split('\n')
        
        current_node = None
        
        for line_num, line in enumerate(lines):
            line = line.strip()
            
            # Skip comments and empty lines
            if not line or line.startswith('!'):
                continue
            
            # Parse label definitions
            label_match = re.search(r'LBL\[(\d+)(?::([^\]]+))?\]', line)
            if label_match:
                label_num = int(label_match.group(1))
                label_name = label_match.group(2).strip() if label_match.group(2) else ""
                
                current_node = FlowNode(label_num, label_name)
                self.flow_nodes[label_num] = current_node
                
                # Identify special labels
                if label_num == 10 or label_num == 20:
                    self.main_cycle_labels.append(label_num)
                elif 500 <= label_num < 800:
                    self.error_nodes.append(label_num)
                
                continue
            
            # If we have a current node, add instructions
            if current_node:
                current_node.instructions.append(line)
                
                # Parse jumps
                jump_match = re.search(r'JMP\s+LBL\[(\d+)', line)
                if jump_match:
                    target = int(jump_match.group(1))
                    current_node.successors.append(target)
                    
                    # Check if conditional
                    if_match = re.search(r'IF\s+(.+?),JMP', line)
                    if if_match:
                        current_node.conditions.append(if_match.group(1))
                
                # END statement terminates flow
                if re.search(r'\bEND\b', line):
                    current_node = None
    
    def identify_cycle_flow(self) -> List[Tuple[int, str]]:
        """Identify the main production cycle flow"""
        cycle = []
        
        # Common cycle labels in order
        cycle_patterns = [
            (10, "NAAR INDUIK / Wait for mold"),
            (20, "Cyclusteller / Main cycle"),
            (25, "Pre-checks"),
            (30, "UITNAME / Take product"),
            (35, "Product check"),
            (40, "UITNAME CONTROLE / Grip control"),
            (130, "KEREN / Turn 1"),
            (140, "KEREN / Turn 2"),
            (150, "PRINTEN / Print"),
            (160, "AFLEGGEN / Place"),
            (170, "FOLIE / Film handling"),
            (200, "Return to cycle")
        ]
        
        for label_num, description in cycle_patterns:
            if label_num in self.flow_nodes:
                node = self.flow_nodes[label_num]
                cycle.append((label_num, node.label_name or description))
        
        return cycle
    
    def identify_error_handling(self) -> List[Tuple[int, str, List[str]]]:
        """Identify error handling procedures"""
        errors = []
        
        for label_num in sorted(self.error_nodes):
            node = self.flow_nodes[label_num]
            
            # Extract key actions
            actions = []
            for instr in node.instructions:
                if 'CALL TEKST' in instr:
                    actions.append("Display error message")
                elif 'Open hand' in instr:
                    actions.append("Open gripper")
                elif 'P[1:rust positie]' in instr:
                    actions.append("Move to safe position")
                elif 'WAIT' in instr and 'USER' in instr:
                    actions.append("Wait for operator confirmation")
                elif 'ABORT' in instr:
                    actions.append("Abort program")
            
            errors.append((label_num, node.label_name, actions))
        
        return errors
    
    def analyze_homing_procedure(self) -> Dict[str, any]:
        """Analyze the home-seeking procedure"""
        homing_info = {
            'has_homing': False,
            'label': None,
            'zones': [],
            'checks': []
        }
        
        # Look for LBL[1000] or similar homing labels
        for label_num, node in self.flow_nodes.items():
            if 1000 <= label_num < 1100 or 'HOME' in node.label_name.upper():
                homing_info['has_homing'] = True
                homing_info['label'] = label_num
                
                # Analyze instructions
                for instr in node.instructions:
                    # Zone checks
                    if 'R[200' in instr or 'R[199' in instr or 'R[198' in instr:
                        homing_info['checks'].append(instr)
                    
                    # Position checks
                    if 'IF' in instr and 'JMP' in instr:
                        zone_match = re.search(r'!.*?(vorm|keerunit|printer|buffer|tafel)', instr, re.IGNORECASE)
                        if zone_match:
                            homing_info['zones'].append(zone_match.group(1))
        
        return homing_info
    
    def generate_flow_diagram(self, output_file: str):
        """Generate a text-based flow diagram"""
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write("=" * 80 + "\n")
            f.write(f"FLOW ANALYSIS: {self.program_name}\n")
            f.write("=" * 80 + "\n\n")
            
            # Main cycle flow
            f.write("MAIN PRODUCTION CYCLE:\n")
            f.write("-" * 40 + "\n")
            cycle = self.identify_cycle_flow()
            for i, (label_num, description) in enumerate(cycle):
                f.write(f"  {i+1}. LBL[{label_num}]: {description}\n")
                if label_num in self.flow_nodes:
                    node = self.flow_nodes[label_num]
                    if node.successors:
                        f.write(f"     → Jumps to: {node.successors}\n")
            f.write("\n")
            
            # Error handling
            f.write("ERROR HANDLING PROCEDURES:\n")
            f.write("-" * 40 + "\n")
            errors = self.identify_error_handling()
            for label_num, name, actions in errors:
                f.write(f"  LBL[{label_num}]: {name}\n")
                if actions:
                    for action in actions:
                        f.write(f"    - {action}\n")
                f.write("\n")
            
            # Homing procedure
            f.write("HOMING PROCEDURE:\n")
            f.write("-" * 40 + "\n")
            homing = self.analyze_homing_procedure()
            if homing['has_homing']:
                f.write(f"  Label: LBL[{homing['label']}]\n")
                if homing['zones']:
                    f.write(f"  Zones checked: {', '.join(set(homing['zones']))}\n")
                f.write(f"  Total checks: {len(homing['checks'])}\n")
            else:
                f.write("  No homing procedure found\n")
            f.write("\n")
            
            # Control flow graph
            f.write("CONTROL FLOW GRAPH:\n")
            f.write("-" * 40 + "\n")
            for label_num in sorted(self.flow_nodes.keys())[:30]:  # First 30
                node = self.flow_nodes[label_num]
                f.write(f"  {node}\n")
                if node.conditions:
                    f.write(f"    Conditions: {node.conditions[0][:60]}...\n")
                if node.successors:
                    f.write(f"    → {', '.join(f'LBL[{s}]' for s in node.successors)}\n")
            
            if len(self.flow_nodes) > 30:
                f.write(f"  ... and {len(self.flow_nodes) - 30} more labels\n")
    
    def generate_state_diagram(self, output_file: str):
        """Generate a state machine diagram"""
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write("=" * 80 + "\n")
            f.write(f"STATE MACHINE DIAGRAM: {self.program_name}\n")
            f.write("=" * 80 + "\n\n")
            
            # Map labels to states
            state_map = {
                10: "IDLE / WAIT_MOLD_CLOSED",
                20: "CYCLE_START",
                30: "TAKE_PRODUCT",
                35: "CHECK_PRODUCT",
                40: "CHECK_GRIP",
                130: "TURN_1",
                140: "TURN_2", 
                150: "PRINT",
                160: "PLACE",
                170: "GET_FILM",
                200: "RETURN",
            }
            
            f.write("STATE TRANSITIONS:\n")
            f.write("-" * 40 + "\n\n")
            
            for label_num in sorted(state_map.keys()):
                if label_num in self.flow_nodes:
                    node = self.flow_nodes[label_num]
                    state = state_map[label_num]
                    
                    f.write(f"State: {state}\n")
                    f.write(f"  Label: LBL[{label_num}]: {node.label_name}\n")
                    
                    # Entry conditions
                    f.write("  Entry: Previous state completed\n")
                    
                    # Actions (first 3 significant instructions)
                    actions = [i for i in node.instructions if not i.startswith('!') and i][:3]
                    if actions:
                        f.write("  Actions:\n")
                        for action in actions:
                            f.write(f"    - {action[:70]}\n")
                    
                    # Exit conditions
                    if node.successors:
                        f.write(f"  Exit: Jump to {node.successors}\n")
                    
                    f.write("\n")


def main():
    """Main entry point"""
    import argparse
    
    parser = argparse.ArgumentParser(
        description='FANUC Flow Analyzer - Advanced flow analysis',
        formatter_class=argparse.RawDescriptionHelpFormatter
    )
    
    parser.add_argument('program', help='FANUC program file (.LS)')
    parser.add_argument('-f', '--flow', help='Output flow diagram file')
    parser.add_argument('-s', '--state', help='Output state diagram file')
    
    args = parser.parse_args()
    
    if not Path(args.program).exists():
        print(f"Error: File not found: {args.program}")
        sys.exit(1)
    
    # Create analyzer
    analyzer = FANUCFlowAnalyzer(args.program)
    
    # Parse program
    print(f"Analyzing: {args.program}")
    analyzer.parse_program()
    
    # Generate outputs
    if args.flow:
        analyzer.generate_flow_diagram(args.flow)
        print(f"Flow diagram saved to: {args.flow}")
    
    if args.state:
        analyzer.generate_state_diagram(args.state)
        print(f"State diagram saved to: {args.state}")
    
    if not args.flow and not args.state:
        # Default: output to screen
        analyzer.generate_flow_diagram('/tmp/flow.txt')
        with open('/tmp/flow.txt', 'r') as f:
            print(f.read())


if __name__ == '__main__':
    main()
