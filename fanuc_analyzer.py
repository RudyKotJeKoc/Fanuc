#!/usr/bin/env python3
"""
FANUC Robot Program Analyzer
Analyzes FANUC M-20iA robot programs (.LS files) for IML production line with printing.

This tool parses, analyzes, and generates reports on FANUC robot programs including:
- Program classification and metadata
- Code flow analysis (labels, jumps, conditions)
- Call graph generation
- Register and IO mapping
- Error handling procedures
- Position data extraction
"""

import os
import re
import json
import sys
from datetime import datetime
from pathlib import Path
from collections import defaultdict, Counter
from typing import Dict, List, Tuple, Set, Optional, Any


class FANUCProgram:
    """Represents a single FANUC robot program"""
    
    def __init__(self, filename: str):
        self.filename = filename
        self.name = ""
        self.attributes = {}
        self.labels = []  # List of (label_num, label_name, line_num)
        self.positions = []  # List of position definitions
        self.registers_used = set()  # Set of R[X] used
        self.digital_inputs = set()  # Set of DI[X] used
        self.digital_outputs = set()  # Set of DO[X] used
        self.register_inputs = set()  # Set of RI[X] used
        self.register_outputs = set()  # Set of RO[X] used
        self.calls = []  # List of (subprogram_name, line_num)
        self.jumps = []  # List of (target_label, line_num)
        self.code_lines = []  # Raw code lines from /MN section
        self.position_registers = []  # PR[X] position registers
        self.errors = []  # Error labels (LBL[500-799])
        self.program_type = "unknown"
        self.product_code = None
        self.has_iml = False
        self.statistics = {}
        
    def classify_program(self):
        """Classify program type based on name and content"""
        name = self.name
        
        # Main programs
        if re.match(r'A_1PA\d{3}', name):
            self.program_type = "main"
            # Extract product code if present
            for line in self.code_lines:
                if 'IML' in line.upper() or 'FOLIE' in line.upper():
                    self.has_iml = True
                    break
            
        # Subprograms
        elif any(prefix in name for prefix in ['KER1_', 'KER2_', 'AFLG_', 'PRINTEN', 'BUF_']):
            self.program_type = "subprogram"
            # Extract product code
            match = re.search(r'_(384|096|1536CC|005|017|140|180)', name)
            if match:
                self.product_code = match.group(1)
                
        # Utility programs
        elif name in ['HOMING', 'HOMEN', 'HOMEN1', 'TEKST', 'FOLIE', 'DUMPEN', 'RUST']:
            self.program_type = "utility"
            
        # System programs
        elif name.startswith('ERR') or name in ['LOGBOOK', 'PMC']:
            self.program_type = "system"
            
        else:
            self.program_type = "other"
    
    def calculate_statistics(self):
        """Calculate various statistics about the program"""
        self.statistics = {
            'total_lines': len(self.code_lines),
            'label_count': len(self.labels),
            'call_count': len(self.calls),
            'jump_count': len(self.jumps),
            'position_count': len(self.positions),
            'register_count': len(self.registers_used),
            'di_count': len(self.digital_inputs),
            'do_count': len(self.digital_outputs),
            'ri_count': len(self.register_inputs),
            'ro_count': len(self.register_outputs),
            'error_labels': len(self.errors)
        }


class FANUCParser:
    """Parser for FANUC .LS program files"""
    
    def __init__(self):
        self.programs = {}
        
    def parse_file(self, filepath: str) -> FANUCProgram:
        """Parse a single FANUC .LS file"""
        program = FANUCProgram(os.path.basename(filepath))
        
        with open(filepath, 'r', encoding='latin-1', errors='ignore') as f:
            content = f.read()
        
        # Parse sections
        self._parse_header(program, content)
        self._parse_attributes(program, content)
        self._parse_code(program, content)
        self._parse_positions(program, content)
        
        # Classify and calculate statistics
        program.classify_program()
        program.calculate_statistics()
        
        return program
    
    def _parse_header(self, program: FANUCProgram, content: str):
        """Parse /PROG header"""
        match = re.search(r'/PROG\s+(\w+)', content)
        if match:
            program.name = match.group(1)
    
    def _parse_attributes(self, program: FANUCProgram, content: str):
        """Parse /ATTR section"""
        attr_section = re.search(r'/ATTR(.*?)/(?:APPL|MN)', content, re.DOTALL)
        if not attr_section:
            return
        
        attr_text = attr_section.group(1)
        
        # Parse key attributes
        patterns = {
            'OWNER': r'OWNER\s*=\s*([^;]+);',
            'COMMENT': r'COMMENT\s*=\s*"([^"]+)"',
            'PROG_SIZE': r'PROG_SIZE\s*=\s*(\d+)',
            'CREATE': r'CREATE\s*=\s*DATE\s+([\d-]+)\s+TIME\s+([\d:]+)',
            'MODIFIED': r'MODIFIED\s*=\s*DATE\s+([\d-]+)\s+TIME\s+([\d:]+)',
            'LINE_COUNT': r'LINE_COUNT\s*=\s*(\d+)',
            'MEMORY_SIZE': r'MEMORY_SIZE\s*=\s*(\d+)',
            'PROTECT': r'PROTECT\s*=\s*([^;]+);',
        }
        
        for key, pattern in patterns.items():
            match = re.search(pattern, attr_text)
            if match:
                if key in ['CREATE', 'MODIFIED']:
                    program.attributes[key] = f"{match.group(1)} {match.group(2)}"
                else:
                    program.attributes[key] = match.group(1).strip()
    
    def _parse_code(self, program: FANUCProgram, content: str):
        """Parse /MN section (main code)"""
        mn_section = re.search(r'/MN(.*?)/(?:POS|END)', content, re.DOTALL)
        if not mn_section:
            return
        
        code_text = mn_section.group(1)
        lines = code_text.split('\n')
        
        for i, line in enumerate(lines):
            line = line.strip()
            if not line or line.startswith('!'):
                continue
            
            program.code_lines.append(line)
            
            # Parse labels
            label_match = re.search(r'LBL\[(\d+)(?::([^\]]+))?\]', line)
            if label_match:
                label_num = int(label_match.group(1))
                label_name = label_match.group(2) if label_match.group(2) else ""
                program.labels.append((label_num, label_name, i))
                
                # Identify error labels (500-799)
                if 500 <= label_num < 800:
                    program.errors.append((label_num, label_name))
            
            # Parse jumps
            jump_match = re.search(r'JMP\s+LBL\[(\d+)', line)
            if jump_match:
                program.jumps.append((int(jump_match.group(1)), i))
            
            # Parse CALL statements
            call_match = re.search(r'CALL\s+(\w+)', line)
            if call_match:
                program.calls.append((call_match.group(1), i))
            
            # Parse registers R[X]
            for reg_match in re.finditer(r'R\[(\d+)(?::([^\]]+))?\]', line):
                reg_num = int(reg_match.group(1))
                reg_name = reg_match.group(2) if reg_match.group(2) else ""
                program.registers_used.add((reg_num, reg_name))
            
            # Parse Digital Inputs DI[X]
            for di_match in re.finditer(r'DI\[(\d+)(?::([^\]]+))?\]', line):
                di_num = int(di_match.group(1))
                di_name = di_match.group(2) if di_match.group(2) else ""
                program.digital_inputs.add((di_num, di_name))
            
            # Parse Digital Outputs DO[X]
            for do_match in re.finditer(r'DO\[(\d+)(?::([^\]]+))?\]', line):
                do_num = int(do_match.group(1))
                do_name = do_match.group(2) if do_match.group(2) else ""
                program.digital_outputs.add((do_num, do_name))
            
            # Parse Register Inputs RI[X]
            for ri_match in re.finditer(r'RI\[(\d+)(?::([^\]]+))?\]', line):
                ri_num = int(ri_match.group(1))
                ri_name = ri_match.group(2) if ri_match.group(2) else ""
                program.register_inputs.add((ri_num, ri_name))
            
            # Parse Register Outputs RO[X]
            for ro_match in re.finditer(r'RO\[(\d+)(?::([^\]]+))?\]', line):
                ro_num = int(ro_match.group(1))
                ro_name = ro_match.group(2) if ro_match.group(2) else ""
                program.register_outputs.add((ro_num, ro_name))
            
            # Parse Position Registers PR[X]
            for pr_match in re.finditer(r'PR\[(\d+)(?::([^\]]+))?\]', line):
                pr_num = int(pr_match.group(1))
                pr_name = pr_match.group(2) if pr_match.group(2) else ""
                if (pr_num, pr_name) not in program.position_registers:
                    program.position_registers.append((pr_num, pr_name))
    
    def _parse_positions(self, program: FANUCProgram, content: str):
        """Parse /POS section"""
        pos_section = re.search(r'/POS(.*?)/END', content, re.DOTALL)
        if not pos_section:
            return
        
        pos_text = pos_section.group(1)
        
        # Parse position definitions P[X:"name"]
        for pos_match in re.finditer(r'P\[(\d+)(?::"([^"]+)")?\]', pos_text):
            pos_num = int(pos_match.group(1))
            pos_name = pos_match.group(2) if pos_match.group(2) else ""
            program.positions.append((pos_num, pos_name))


class FANUCAnalyzer:
    """Analyzer for FANUC robot programs"""
    
    def __init__(self, parser: FANUCParser):
        self.parser = parser
        self.call_graph = defaultdict(list)
        self.register_map = defaultdict(set)
        self.io_map = {
            'DI': defaultdict(set),
            'DO': defaultdict(set),
            'RI': defaultdict(set),
            'RO': defaultdict(set)
        }
        
    def analyze_all(self, directory: str):
        """Analyze all .LS files in directory"""
        ls_files = list(Path(directory).glob('*.LS'))
        
        print(f"Found {len(ls_files)} FANUC program files")
        
        for filepath in sorted(ls_files):
            try:
                program = self.parser.parse_file(str(filepath))
                self.parser.programs[program.name] = program
            except Exception as e:
                print(f"Error parsing {filepath}: {e}")
        
        self._build_call_graph()
        self._build_register_map()
        self._build_io_map()
        
    def _build_call_graph(self):
        """Build call graph from all programs"""
        for prog_name, program in self.parser.programs.items():
            for called_prog, _ in program.calls:
                self.call_graph[prog_name].append(called_prog)
    
    def _build_register_map(self):
        """Build comprehensive register map"""
        for program in self.parser.programs.values():
            for reg_num, reg_name in program.registers_used:
                if reg_name:
                    self.register_map[reg_num].add(reg_name)
    
    def _build_io_map(self):
        """Build comprehensive IO map"""
        for program in self.parser.programs.values():
            for di_num, di_name in program.digital_inputs:
                if di_name:
                    self.io_map['DI'][di_num].add(di_name)
            for do_num, do_name in program.digital_outputs:
                if do_name:
                    self.io_map['DO'][do_num].add(do_name)
            for ri_num, ri_name in program.register_inputs:
                if ri_name:
                    self.io_map['RI'][ri_num].add(ri_name)
            for ro_num, ro_name in program.register_outputs:
                if ro_name:
                    self.io_map['RO'][ro_num].add(ro_name)
    
    def generate_report(self, output_file: str):
        """Generate comprehensive analysis report"""
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write("=" * 80 + "\n")
            f.write("FANUC ROBOT PROGRAM ANALYSIS REPORT\n")
            f.write("=" * 80 + "\n\n")
            f.write(f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
            f.write(f"Total Programs: {len(self.parser.programs)}\n\n")
            
            # Executive Summary
            self._write_executive_summary(f)
            
            # Program Classification
            self._write_program_classification(f)
            
            # Call Graph
            self._write_call_graph(f)
            
            # Register Map
            self._write_register_map(f)
            
            # IO Map
            self._write_io_map(f)
            
            # Error Handling
            self._write_error_analysis(f)
            
            # Detailed Program Analysis
            self._write_program_details(f)
    
    def _write_executive_summary(self, f):
        """Write executive summary section"""
        f.write("=" * 80 + "\n")
        f.write("EXECUTIVE SUMMARY\n")
        f.write("=" * 80 + "\n\n")
        
        # Count by type
        type_counts = Counter(p.program_type for p in self.parser.programs.values())
        
        f.write("Program Distribution:\n")
        for ptype, count in sorted(type_counts.items()):
            f.write(f"  {ptype.capitalize()}: {count}\n")
        f.write("\n")
        
        # Total lines of code
        total_lines = sum(p.statistics.get('total_lines', 0) for p in self.parser.programs.values())
        f.write(f"Total Lines of Code: {total_lines}\n\n")
        
        # Date range
        dates = []
        for p in self.parser.programs.values():
            if 'CREATE' in p.attributes:
                dates.append(p.attributes['CREATE'])
            if 'MODIFIED' in p.attributes:
                dates.append(p.attributes['MODIFIED'])
        
        if dates:
            f.write(f"Oldest Program: {min(dates)}\n")
            f.write(f"Newest Program: {max(dates)}\n\n")
        
        # Products supported
        products = set()
        for p in self.parser.programs.values():
            if p.product_code:
                products.add(p.product_code)
        
        if products:
            f.write(f"Products Supported: {', '.join(sorted(products))}\n\n")
    
    def _write_program_classification(self, f):
        """Write program classification section"""
        f.write("=" * 80 + "\n")
        f.write("PROGRAM CLASSIFICATION\n")
        f.write("=" * 80 + "\n\n")
        
        # Group by type
        by_type = defaultdict(list)
        for name, prog in sorted(self.parser.programs.items()):
            by_type[prog.program_type].append((name, prog))
        
        for ptype in ['main', 'subprogram', 'utility', 'system', 'other']:
            if ptype not in by_type:
                continue
            
            f.write(f"{ptype.upper()} PROGRAMS ({len(by_type[ptype])}):\n")
            f.write("-" * 40 + "\n")
            
            for name, prog in sorted(by_type[ptype]):
                size = prog.attributes.get('PROG_SIZE', 'N/A')
                lines = prog.attributes.get('LINE_COUNT', 'N/A')
                comment = prog.attributes.get('COMMENT', '')
                
                f.write(f"  {name:<20} Size: {size:>6}  Lines: {lines:>4}  {comment}\n")
                
                if prog.has_iml:
                    f.write(f"    - Has IML (In-Mold Labeling)\n")
                if prog.product_code:
                    f.write(f"    - Product: {prog.product_code}\n")
            
            f.write("\n")
    
    def _write_call_graph(self, f):
        """Write call graph section"""
        f.write("=" * 80 + "\n")
        f.write("CALL GRAPH ANALYSIS\n")
        f.write("=" * 80 + "\n\n")
        
        # Find main programs
        main_programs = [name for name, prog in self.parser.programs.items() 
                        if prog.program_type == 'main']
        
        for main_prog in sorted(main_programs):
            f.write(f"{main_prog}\n")
            self._write_call_tree(f, main_prog, indent=1, visited=set())
            f.write("\n")
    
    def _write_call_tree(self, f, prog_name: str, indent: int, visited: Set[str]):
        """Recursively write call tree"""
        if prog_name in visited:
            return
        visited.add(prog_name)
        
        if prog_name in self.call_graph:
            for called in sorted(set(self.call_graph[prog_name])):
                f.write("  " * indent + f"├── {called}\n")
                self._write_call_tree(f, called, indent + 1, visited)
    
    def _write_register_map(self, f):
        """Write register map section"""
        f.write("=" * 80 + "\n")
        f.write("REGISTER MAP (R[X])\n")
        f.write("=" * 80 + "\n\n")
        
        f.write(f"{'Reg':<6} {'Name':<40} {'Usage Count'}\n")
        f.write("-" * 60 + "\n")
        
        for reg_num in sorted(self.register_map.keys()):
            names = list(self.register_map[reg_num])
            # Count usage across all programs
            usage = sum(1 for p in self.parser.programs.values() 
                       if any(r[0] == reg_num for r in p.registers_used))
            
            if names:
                name = names[0] if len(names) == 1 else f"{names[0]} (+{len(names)-1} variants)"
                f.write(f"R[{reg_num:<3}] {name:<40} {usage}\n")
        
        f.write("\n")
    
    def _write_io_map(self, f):
        """Write IO map section"""
        f.write("=" * 80 + "\n")
        f.write("IO MAPPING\n")
        f.write("=" * 80 + "\n\n")
        
        for io_type in ['DI', 'DO', 'RI', 'RO']:
            f.write(f"{io_type} (Digital/Register {'Input' if io_type[1] == 'I' else 'Output'}):\n")
            f.write("-" * 60 + "\n")
            
            if self.io_map[io_type]:
                f.write(f"{'Num':<6} {'Name':<50}\n")
                for num in sorted(self.io_map[io_type].keys()):
                    names = list(self.io_map[io_type][num])
                    name = names[0] if len(names) == 1 else f"{names[0]} (+{len(names)-1} variants)"
                    f.write(f"{io_type}[{num:<3}] {name}\n")
            else:
                f.write("  None found\n")
            
            f.write("\n")
    
    def _write_error_analysis(self, f):
        """Write error handling analysis"""
        f.write("=" * 80 + "\n")
        f.write("ERROR HANDLING ANALYSIS\n")
        f.write("=" * 80 + "\n\n")
        
        # Collect all error labels
        all_errors = []
        for prog_name, prog in self.parser.programs.items():
            for err_num, err_name in prog.errors:
                all_errors.append((err_num, err_name, prog_name))
        
        if all_errors:
            f.write(f"{'Label':<12} {'Description':<40} {'Program'}\n")
            f.write("-" * 80 + "\n")
            
            for err_num, err_name, prog_name in sorted(all_errors):
                f.write(f"LBL[{err_num:<4}] {err_name:<40} {prog_name}\n")
        else:
            f.write("No error labels found\n")
        
        f.write("\n")
    
    def _write_program_details(self, f):
        """Write detailed program analysis"""
        f.write("=" * 80 + "\n")
        f.write("DETAILED PROGRAM ANALYSIS\n")
        f.write("=" * 80 + "\n\n")
        
        for name, prog in sorted(self.parser.programs.items()):
            f.write(f"Program: {name}\n")
            f.write("-" * 40 + "\n")
            
            # Attributes
            if prog.attributes:
                f.write("Attributes:\n")
                for key, value in sorted(prog.attributes.items()):
                    f.write(f"  {key}: {value}\n")
            
            # Statistics
            if prog.statistics:
                f.write("\nStatistics:\n")
                for key, value in sorted(prog.statistics.items()):
                    f.write(f"  {key}: {value}\n")
            
            # Labels
            if prog.labels:
                f.write(f"\nLabels ({len(prog.labels)}):\n")
                for lbl_num, lbl_name, _ in sorted(prog.labels)[:20]:  # First 20
                    f.write(f"  LBL[{lbl_num}]: {lbl_name}\n")
                if len(prog.labels) > 20:
                    f.write(f"  ... and {len(prog.labels) - 20} more\n")
            
            # Calls
            if prog.calls:
                calls_set = set(call[0] for call in prog.calls)
                f.write(f"\nCalls ({len(calls_set)}):\n")
                for call in sorted(calls_set):
                    f.write(f"  CALL {call}\n")
            
            # Positions
            if prog.positions:
                f.write(f"\nPositions ({len(prog.positions)}):\n")
                for pos_num, pos_name in sorted(prog.positions)[:10]:  # First 10
                    f.write(f"  P[{pos_num}]: {pos_name}\n")
                if len(prog.positions) > 10:
                    f.write(f"  ... and {len(prog.positions) - 10} more\n")
            
            f.write("\n" + "=" * 80 + "\n\n")


def main():
    """Main entry point"""
    import argparse
    
    parser = argparse.ArgumentParser(
        description='FANUC Robot Program Analyzer',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s -d /path/to/programs -o report.txt
  %(prog)s -d . -o analysis.txt
  %(prog)s --directory ./programs --output full_report.txt
        """
    )
    
    parser.add_argument('-d', '--directory', default='.',
                       help='Directory containing .LS files (default: current directory)')
    parser.add_argument('-o', '--output', default='fanuc_analysis_report.txt',
                       help='Output report filename (default: fanuc_analysis_report.txt)')
    parser.add_argument('-v', '--verbose', action='store_true',
                       help='Verbose output')
    
    args = parser.parse_args()
    
    # Create parser and analyzer
    fanuc_parser = FANUCParser()
    analyzer = FANUCAnalyzer(fanuc_parser)
    
    # Analyze all programs
    print(f"Analyzing FANUC programs in: {args.directory}")
    analyzer.analyze_all(args.directory)
    
    # Generate report
    print(f"Generating report: {args.output}")
    analyzer.generate_report(args.output)
    
    print(f"\nAnalysis complete! Report saved to: {args.output}")
    print(f"Total programs analyzed: {len(fanuc_parser.programs)}")


if __name__ == '__main__':
    main()
