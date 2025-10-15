/PROG  RUST
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "rust positie";
PROG_SIZE	= 697;
CREATE		= DATE 06-03-24  TIME 21:28:14;
MODIFIED	= DATE 19-03-22  TIME 18:09:40;
FILE_NAME	= ;
VERSION		= 0;
LINE_COUNT	= 36;
MEMORY_SIZE	= 1209;
PROTECT		= READ_WRITE;
TCD:  STACK_SIZE	= 0,
      TASK_PRIORITY	= 50,
      TIME_SLICE	= 0,
      BUSY_LAMP_OFF	= 0,
      ABORT_REQUEST	= 0,
      PAUSE_REQUEST	= 0;
DEFAULT_GROUP	= 1,*,*,*,*;
CONTROL_CODE	= 00000000 00000000;
/APPL

LINE_TRACK;
  LINE_TRACK_SCHEDULE_NUMBER      : 0;
  LINE_TRACK_BOUNDARY_NUMBER      : 0;
  CONTINUE_TRACK_AT_PROG_END      : TRUE;

/MN
   1:  TIMER[1]=START ;
   2:  LBL[5] ;
   3:  WAIT    .50(sec) ;
   4:  CALL TEKST(4) ;
   5:  Open hand 1    ;
   6:  Open hand 2    ;
   7:  R[28:Act dump]=0    ;
   8:  R[29:Start afleg]=0    ;
   9:   ;
  10:  LBL[6] ;
  11:  DO[51:IONblower Corona]=OFF ;
  12:  DO[52:IONblower witband]=OFF ;
  13:  IF DI[7:Automaat]=ON,JMP LBL[8] ;
  14:  IF SI[4]=ON,CALL OMBOUW ;
  15:  JMP LBL[6] ;
  16:   ;
  17:  LBL[8] ;
  18:  DO[11025]=PULSE,0.5sec ;
  19:  CALL TEKST(6) ;
  20:   ;
  21:  LBL[10] ;
  22:  IF DI[7:Automaat]=OFF,JMP LBL[5] ;
  23:  IF DI[6:Matrijs dicht]=ON,JMP LBL[20] ;
  24:  JMP LBL[10] ;
  25:   ;
  26:  LBL[20] ;
  27:  CALL A_KEUZE    ;
  28:  R[46:Cyclusteller]=0    ;
  29:  DO[51:IONblower Corona]=OFF ;
  30:  DO[52:IONblower witband]=OFF ;
  31:  DO[10:Vacuumpomp]=OFF ;
  32:   ;
  33:  !Aansturen bandje afkeur ;
  34:  DO[14321]=OFF ;
  35:   ;
  36:  JMP LBL[5] ;
/POS
/END
