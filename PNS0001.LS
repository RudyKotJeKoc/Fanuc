/PROG  PNS0001
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "";
PROG_SIZE	= 482;
CREATE		= DATE 14-08-20  TIME 10:24:10;
MODIFIED	= DATE 19-03-22  TIME 18:10:04;
FILE_NAME	= ;
VERSION		= 0;
LINE_COUNT	= 25;
MEMORY_SIZE	= 918;
PROTECT		= READ_WRITE;
TCD:  STACK_SIZE	= 0,
      TASK_PRIORITY	= 50,
      TIME_SLICE	= 0,
      BUSY_LAMP_OFF	= 0,
      ABORT_REQUEST	= 0,
      PAUSE_REQUEST	= 0;
DEFAULT_GROUP	= *,*,*,*,*;
CONTROL_CODE	= 00000000 00000000;
/MN
   1:  R[90:Program gestart]=0    ;
   2:  R[91:Ontstapelmagazyn]=0    ;
   3:  CALL A_KEUZE    ;
   4:  WAIT    .50(sec) ;
   5:   ;
   6:  DO[53:User1]=OFF ;
   7:  DO[54:User2]=OFF ;
   8:  CALL TEKST(2) ;
   9:   ;
  10:  LBL[1] ;
  11:  SO[1:Cycle start]=ON ;
  12:  IF SI[6:Cycle start]=ON,JMP LBL[2] ;
  13:  WAIT    .20(sec) ;
  14:  SO[1:Cycle start]=OFF ;
  15:  WAIT    .20(sec) ;
  16:  JMP LBL[1] ;
  17:   ;
  18:  LBL[2] ;
  19:  IF R[91:Ontstapelmagazyn]=0,JMP LBL[10] ;
  20:   ;
  21:  CALL A_1ONTSTPL    ;
  22:  ABORT ;
  23:   ;
  24:  LBL[10] ;
  25:  CALL RUST    ;
/POS
/END
