# FANUC Robot Program Analyzer

Comprehensive analysis tools for FANUC M-20iA robot programs in IML production line with printing.

## Overview

This repository contains ~100 FANUC robot programs (.LS files) for an IML (In-Mold Labeling) production line with a FANUC M-20iA robot. The analyzer tools parse, analyze, and generate comprehensive reports on these programs.

## Tools

### 1. `fanuc_analyzer.py` - Main Program Analyzer

Comprehensive parser and analyzer for FANUC programs.

**Features:**
- Parses all FANUC .LS files in a directory
- Extracts metadata from /ATTR section (owner, dates, sizes, etc.)
- Analyzes program logic from /MN section
- Extracts position data from /POS section
- Classifies programs by type (main, subprogram, utility, system)
- Builds call graphs showing program dependencies
- Maps all registers (R[X]) with their names and usage
- Maps all I/O signals (DI, DO, RI, RO)
- Identifies error handling procedures (LBL[500-799])
- Generates comprehensive analysis report

**Usage:**
```bash
# Analyze all programs in current directory
python3 fanuc_analyzer.py

# Analyze specific directory
python3 fanuc_analyzer.py -d /path/to/programs

# Specify output file
python3 fanuc_analyzer.py -d . -o my_report.txt

# Verbose mode
python3 fanuc_analyzer.py -d . -v
```

**Output:**
- Executive summary (program counts, dates, products)
- Program classification (main, subprogram, utility, system)
- Call graph analysis (program dependencies)
- Register map (R[X] with names and usage counts)
- I/O mapping (DI, DO, RI, RO with descriptions)
- Error handling analysis (error labels and procedures)
- Detailed program analysis (metadata, statistics, labels, calls, positions)

### 2. `fanuc_flow_analyzer.py` - Flow Analysis Tool

Advanced control flow and state machine analyzer.

**Features:**
- Builds control flow graphs
- Identifies main production cycle flow
- Analyzes error handling procedures
- Examines homing procedures
- Generates state machine diagrams

**Usage:**
```bash
# Analyze single program with both outputs
python3 fanuc_flow_analyzer.py A_1PA005.LS -f flow.txt -s state.txt

# Flow diagram only
python3 fanuc_flow_analyzer.py A_1PA005.LS -f flow.txt

# State diagram only
python3 fanuc_flow_analyzer.py A_1PA005.LS -s state.txt

# Display to screen
python3 fanuc_flow_analyzer.py A_1PA005.LS
```

**Output:**
- Main production cycle identification
- Error handling procedures with actions
- Homing procedure analysis
- Control flow graph
- State machine transitions

## Program Structure

### File Format
FANUC programs follow this structure:
```
/PROG  PROGRAM_NAME
/ATTR
  OWNER = MNEDITOR;
  COMMENT = "Description";
  PROG_SIZE = 13354;
  CREATE = DATE 19-04-01 TIME 18:06:44;
  MODIFIED = DATE 19-04-03 TIME 22:49:32;
  LINE_COUNT = 681;
/APPL
/MN
  [Program code with labels, jumps, calls, etc.]
/POS
  [Position definitions]
/END
```

### Program Types

#### Main Programs (A_1PA0XX)
- Full production cycle programs
- 15000-17000 bytes
- 600-700 lines of code
- Examples: A_1PA005, A_1PA015

#### Subprograms
- **KER1_XXX, KER2_XXX** - Turning unit operations
- **PRINTEN, PRINTEN1, PRINTEN2** - Printing operations
- **AFLG_XXX** - Placement operations
- **BUF_XXX** - Buffer operations
- **FOLIE** - Film handling

#### Utility Programs
- **HOMEN, HOMEN1** - Homing/reference finding
- **TEKST** - Message display
- **DUMPEN** - Reject handling
- **RUST** - Rest position

#### System Programs
- **ERR*** - Error handling
- **PMC** - PMC interface
- **LOGBOOK** - Event logging

### Production Cycle Flow

Typical main program flow:
1. **Initialization** - Check R[90:Prog gestart], jump to LBL[1000] if needed
2. **Wait for Mold** - LBL[10]: Wait for DI[6:Matrijs dicht]
3. **Lay Film (IML)** - LBL[30]: Place film in mold (if IML program)
4. **Take Product** - LBL[35]: Grab product from mold
5. **Check Grip** - LBL[40]: Verify grip sensors
6. **Turn 1** - LBL[130]: CALL KER1_XXX
7. **Turn 2** - LBL[140]: CALL KER2_XXX
8. **Print** - LBL[150]: CALL PRINTEN
9. **Place** - LBL[160]: CALL AFLG_XXX
10. **Get Film** - LBL[170]: CALL FOLIE
11. **Return** - LBL[200]: Back to cycle start

### Error Handling

Error labels (LBL[500-799]):
- **LBL[500]** - Grip error (UITNAME FOUT)
- **LBL[510]** - Dump products (DUMPEN PRODUCTEN)
- **LBL[530]** - Machine not in auto (SGM UIT AUTOMAAT)
- **LBL[580]** - Grip error in mold (Grijpfout induik)
- **LBL[700]** - Film error (STORING FOLIE)
- **LBL[720]** - Height error (HOOGTE FOUT)
- **LBL[730]** - Buffer grip error (GRIJPER FOUT BUF)
- **LBL[740]** - Buffer full (BUFFER VOL)

Standard error procedure:
```
LBL[XXX]:
  CALL TEKST(XXX)           # Display error message
  R[XX]=0                   # Reset registers
  J P[1:rust positie] 30%   # Safe position
  Open hand 1/2             # Open grippers
  WAIT DI[7:Automaat]=OFF   # Wait for stop
  DO[15:Led user 2]=ON      # Signal operator
  WAIT DI[31:Druk user 2]=ON # Wait for acknowledgment
  DO[15:Led user 2]=OFF
  END
```

### Key Registers (R[X])

| Register | Name | Purpose |
|----------|------|---------|
| R[1] | Cyclustijd | Cycle time |
| R[2] | Induiktijd | In-mold time |
| R[7] | Steekhoogte | Stack height |
| R[21] | Grijper 1-voudig | Single gripper mode |
| R[46] | Cyclusteller | Cycle counter |
| R[49] | Snelheid | Speed |
| R[90] | Program gestart | Program started flag |
| R[100] | Product controle | Product check timer |
| R[188] | Act Utool | Active user tool |
| R[189] | Act Uframe | Active user frame |

### Key I/O Signals

**Digital Inputs (DI):**
- DI[1] - Matrijs open (Mold open)
- DI[3] - Uitw. terug (Ejector back)
- DI[6] - Matrijs dicht (Mold closed)
- DI[7] - Automaat (Auto mode)
- DI[42] - Printer alarm
- DI[45] - USER 2 (Operator button)

**Digital Outputs (DO):**
- DO[11017] - Uitstoter (Ejector)
- DO[11161] - Induikvoorw (Mold entry condition)
- DO[33] - Vrygave printer (Printer enable)
- DO[34] - Trigger printer (Print trigger)
- DO[54] - User2 (User LED)

**Register Inputs (RI):**
- RI[1-4] - Bek sensors (Gripper jaw sensors)
- RI[5-6] - Vacuum sensors

**Register Outputs (RO):**
- RO[1-2] - Bek A open/dicht (Gripper A control)
- RO[5-6] - Vacuum control

## Analysis Report Contents

### Executive Summary
- Program distribution by type
- Total lines of code
- Date range of programs
- Products supported

### Program Classification
- Detailed listing of all programs by type
- Size, line count, and comments for each
- IML flags and product codes

### Call Graph Analysis
- Hierarchical call tree for each main program
- Shows all subprogram dependencies

### Register Map
- Complete list of R[X] registers with names
- Usage count across all programs
- Identifies common vs. program-specific registers

### I/O Mapping
- All DI, DO, RI, RO signals with descriptions
- Identifies naming variants

### Error Handling Analysis
- All error labels with descriptions
- Programs using each error handler

### Detailed Program Analysis
- Per-program breakdown with:
  - Metadata (create date, modified date, size)
  - Statistics (line count, label count, call count)
  - Labels and their names
  - Called subprograms
  - Position definitions

## Products Supported

The programs support multiple product types:
- **384** - Product code 384
- **096** - Product code 096
- **1536CC** - Product code 1536CC
- **005** - Product code 005/140
- **017** - Product code 017/180

Each product has specific subprograms (KER1_XXX, KER2_XXX, AFLG_XXX, etc.)

## Requirements

- Python 3.6 or higher
- No external dependencies (uses only Python standard library)

## Examples

### Analyze All Programs
```bash
python3 fanuc_analyzer.py -d . -o complete_analysis.txt
```

### Analyze Specific Main Program Flow
```bash
python3 fanuc_flow_analyzer.py A_1PA005.LS -f A_1PA005_flow.txt
```

### Quick Analysis
```bash
# Just run the analyzer in the program directory
python3 fanuc_analyzer.py
```

## File Structure

```
.
├── fanuc_analyzer.py          # Main analyzer tool
├── fanuc_flow_analyzer.py     # Flow analysis tool
├── README.md                   # This file
├── A_1PA005.LS                # Main program example
├── A_1PA015.LS                # Main program example
├── PRINTEN.LS                 # Subprogram example
├── PRINTEN1.LS                # Subprogram variant
├── HOMEN.LS                   # Utility program
├── TEKST.LS                   # Utility program
└── [~94 other .LS files]      # Other programs
```

## Notes

- Programs use Dutch naming conventions
- Comments are in Dutch
- Some programs have variants (e.g., PRINTEN, PRINTEN1, PRINTEN2)
- Error handling is standardized across programs
- Homing procedures (LBL[1000]) are critical for safe operation

## License

This is proprietary robot control software. Analysis tools are provided for documentation and maintenance purposes.

## Author

FANUC Program Analysis Tools
Generated: 2025-10-15
