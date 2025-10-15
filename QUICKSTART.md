# FANUC Program Analyzer - Quick Start Guide

## Installation

No installation required! Just Python 3.6+ with standard library.

## Quick Start - 5 Minutes

### 1. Analyze All Programs (2 minutes)

Generate a comprehensive report of all FANUC programs:

```bash
python3 fanuc_analyzer.py
```

This creates `fanuc_analysis_report.txt` with:
- 84 programs analyzed
- Complete call graphs
- Register and I/O mappings
- Error handling procedures
- Program classifications

### 2. Analyze Specific Program Flow (1 minute)

Examine the control flow of a main program:

```bash
python3 fanuc_flow_analyzer.py A_1PA005.LS -f flow.txt -s state.txt
```

Creates:
- `flow.txt` - Production cycle flow and error handling
- `state.txt` - State machine diagram

### 3. View Results (2 minutes)

```bash
# View main report
less fanuc_analysis_report.txt

# Or use your favorite text editor
nano fanuc_analysis_report.txt
```

## Common Use Cases

### Finding All Programs That Use a Specific Register

```bash
# Generate report
python3 fanuc_analyzer.py

# Search for register
grep "R\[90" fanuc_analysis_report.txt
```

### Understanding Program Dependencies

```bash
# Generate report
python3 fanuc_analyzer.py

# Look at CALL GRAPH ANALYSIS section
# Shows which programs call which subprograms
```

### Identifying Error Handlers

```bash
# Generate report  
python3 fanuc_analyzer.py

# Look at ERROR HANDLING ANALYSIS section
# Lists all LBL[500-799] with descriptions
```

### Analyzing Production Cycle

```bash
# Analyze main program
python3 fanuc_flow_analyzer.py A_1PA005.LS -f flow.txt

# View cycle flow
cat flow.txt
```

### Finding I/O Signal Usage

```bash
# Generate report
python3 fanuc_analyzer.py

# Look at IO MAPPING section
# Lists all DI/DO/RI/RO with names
```

## Example Outputs

### Sample Call Graph

```
A_1PA005
  ├── B_AFLEG2
    ├── BUF_ONTS2
    ├── BUF_STPL2
  ├── B_KEREN2
  ├── DUMPEN
  ├── HOMEN
    ├── TEKST
  ├── PRINTEN2
    ├── TEKST
  ├── TEKST
```

### Sample Register Map

```
Reg    Name                                     Usage Count
------------------------------------------------------------
R[1  ] Cyclustijd                               23
R[7  ] Steekhoogte                              26
R[21 ] Grijper 1-voudig                         17
R[46 ] Cyclusteller                             11
R[90 ] Program gestart                          11
R[100] Product controle                         25
```

### Sample I/O Mapping

```
DI[1  ] Matrijs open
DI[6  ] Matrijs dicht
DI[7  ] Automaat
DO[11017] Uitstoter
DO[54 ] User2
```

### Sample Flow Analysis

```
MAIN PRODUCTION CYCLE:
----------------------------------------
  1. LBL[10]: NAAR INDUIK / Wait for mold
  2. LBL[20]: Cyclusteller / Main cycle
  3. LBL[30]: UITNAME / Take product
  4. LBL[40]: UITNAME CONTROLE / Grip control
  5. LBL[200]: Keren / Turn
```

## Pro Tips

### 1. Redirect Output for Easy Searching

```bash
python3 fanuc_analyzer.py > analysis.txt 2>&1
grep -i "error" analysis.txt
```

### 2. Compare Programs

```bash
# Analyze two programs
python3 fanuc_flow_analyzer.py A_1PA005.LS -f prog1_flow.txt
python3 fanuc_flow_analyzer.py A_1PA015.LS -f prog2_flow.txt

# Compare with diff
diff prog1_flow.txt prog2_flow.txt
```

### 3. Find All Calls to a Specific Subprogram

```bash
python3 fanuc_analyzer.py
grep "CALL TEKST" fanuc_analysis_report.txt
```

### 4. Get Program Statistics

```bash
python3 fanuc_analyzer.py
# Look at EXECUTIVE SUMMARY and PROGRAM CLASSIFICATION sections
```

### 5. Understand Product Variants

```bash
# Programs with product codes: _384, _096, _1536CC, _005, _017
ls -1 *_384.LS *_096.LS *_005.LS
```

## Troubleshooting

### Script Won't Run

```bash
# Check Python version
python3 --version  # Should be 3.6+

# Try with full path
/usr/bin/python3 fanuc_analyzer.py
```

### No Programs Found

```bash
# Make sure you're in the right directory
ls *.LS | wc -l  # Should show ~100 files

# Or specify directory
python3 fanuc_analyzer.py -d /path/to/programs
```

### Output File Permissions

```bash
# Make sure you can write to current directory
touch test.txt && rm test.txt

# Or specify different output location
python3 fanuc_analyzer.py -o /tmp/report.txt
```

## Advanced Usage

### Analyze Only Main Programs

```bash
# Use grep to filter
python3 fanuc_analyzer.py > full_report.txt
grep -A 50 "MAIN PROGRAMS" full_report.txt
```

### Custom Analysis Script

```python
#!/usr/bin/env python3
from fanuc_analyzer import FANUCParser, FANUCAnalyzer

parser = FANUCParser()
analyzer = FANUCAnalyzer(parser)

# Analyze all programs
analyzer.analyze_all('.')

# Custom analysis
for name, prog in parser.programs.items():
    if prog.program_type == 'main':
        print(f"{name}: {len(prog.calls)} subprogram calls")
```

### Batch Processing

```bash
# Analyze all main programs
for prog in A_1PA*.LS; do
    echo "Analyzing $prog..."
    python3 fanuc_flow_analyzer.py "$prog" -f "${prog%.LS}_flow.txt"
done
```

## What to Look For

### In Main Programs (A_1PA0XX)
- Production cycle flow (LBL[10-200])
- Error handlers (LBL[500-799])
- Homing procedure (LBL[1000])
- Subprogram calls (CALL statements)

### In Subprograms
- Position sequences
- Sensor checks
- Error conditions
- Return points

### In Error Handlers
- Error message (CALL TEKST)
- Safe position moves
- Operator wait points
- Recovery procedures

## Getting Help

```bash
# Show help for main analyzer
python3 fanuc_analyzer.py --help

# Show help for flow analyzer
python3 fanuc_flow_analyzer.py --help
```

## Next Steps

1. **Read the full README.md** for detailed documentation
2. **Explore the generated reports** to understand the system
3. **Analyze specific programs** that interest you
4. **Compare variants** (e.g., PRINTEN vs PRINTEN1)
5. **Map product flows** using call graphs

## Summary

```bash
# Full analysis in 3 commands:
python3 fanuc_analyzer.py                                      # All programs
python3 fanuc_flow_analyzer.py A_1PA005.LS -f flow.txt       # Main program flow
less fanuc_analysis_report.txt                                 # View results
```

That's it! You now have a complete analysis of 100 FANUC robot programs.
