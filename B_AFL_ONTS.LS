/PROG  B_AFL_ONTS
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "Afleg op corona";
PROG_SIZE	= 2081;
CREATE		= DATE 19-02-28  TIME 19:42:14;
MODIFIED	= DATE 19-03-22  TIME 01:13:44;
FILE_NAME	= AFLEGGEN;
VERSION		= 0;
LINE_COUNT	= 55;
MEMORY_SIZE	= 2493;
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
/MN
   1:  DO[51:IONblower Corona]=ON ;
   2:   ;
   3:  UFRAME_NUM=1 ;
   4:  !Producten afleggen ;
   5:  !Wacht op afleg corona vry ;
   6:  WAIT DI[20:Afl 1 vrij Corona]=ON    ;
   7:   ;
   8:  !Chck schakelaar vorksnsr aan/uit ;
   9:  IF DI[78:Vorksensor aan/uit]=OFF,JMP LBL[100] ;
  10:   ;
  11:  IF DI[76:Ontstapel zonder print]=ON,JMP LBL[91] ;
  12:   ;
  13:  LBL[90:Controle plate b] ;
  14:J P[90:Naar vork] 80% CNT30    ;
  15:L P[91:Controle pos] 500mm/sec FINE    ;
  16:  WAIT    .50(sec) ;
  17:  JMP LBL[92] ;
  18:   ;
  19:  LBL[91:Controle plate b] ;
  20:J P[90:Naar vork] 80% CNT30    ;
  21:L P[92] 500mm/sec FINE    ;
  22:  WAIT    .50(sec) ;
  23:   ;
  24:  LBL[92:Controle] ;
  25:  !Controle plate b aanwezig ;
  26:  IF DI[75:Vorksensor corona]=ON,JMP LBL[94] ;
  27:  WAIT    .10(sec) ;
  28:   ;
  29:  LBL[93:Plate b n_aanwez] ;
  30:  JMP LBL[500] ;
  31:   ;
  32:  LBL[94:Plate b aanwezig] ;
  33:  !Naar afleggen ;
  34:  JMP LBL[100] ;
  35:   ;
  36:  LBL[100:Voor afleg] ;
  37:J P[101:Naar afleg 1] 80% CNT30    ;
  38:  JMP LBL[101] ;
  39:   ;
  40:  LBL[101:Afleggen] ;
  41:J P[110:AFLEG 2] 80% CNT60 Offset,PR[82:Boven afleg]    ;
  42:L P[110:AFLEG 2] 1000mm/sec FINE    ;
  43:  Open hand 2    ;
  44:  WAIT    .25(sec) ;
  45:L P[110:AFLEG 2] 1000mm/sec CNT60 Offset,PR[82:Boven afleg]    ;
  46:   ;
  47:J P[150] 80% CNT80    ;
  48:  R[93:Cyclusteller]=R[93:Cyclusteller]+1    ;
  49:  END ;
  50:   ;
  51:  LBL[500:Plate b n_aanwe] ;
  52:  R[26:Geen plate b]=1    ;
  53:L P[91:Controle pos] 500mm/sec CNT50 Offset,PR[94:Offset vork]    ;
  54:J P[1:Rust] 65% CNT50    ;
  55:   ;
/POS
P[1:"Rust"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   451.199  mm,	Y =      .039  mm,	Z =   354.128  mm,
	W =   179.900 deg,	P =      .000 deg,	R =   -90.100 deg
};
P[90:"Naar vork"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  1001.229  mm,	Y = -1008.615  mm,	Z =   375.000  mm,
	W =   179.662 deg,	P =      .062 deg,	R =    88.499 deg
};
P[91:"Controle pos"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  1072.785  mm,	Y =  -839.837  mm,	Z =   315.000  mm,
	W =   179.663 deg,	P =      .061 deg,	R =    88.499 deg
};
P[92]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  1068.071  mm,	Y =  -839.882  mm,	Z =   314.956  mm,
	W =   179.664 deg,	P =      .059 deg,	R =    88.500 deg
};
P[101:"Naar afleg 1"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  1001.229  mm,	Y = -1008.615  mm,	Z =   375.000  mm,
	W =   179.662 deg,	P =      .062 deg,	R =    88.499 deg
};
P[110:"AFLEG 2"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  1001.227  mm,	Y = -1008.615  mm,	Z =   227.547  mm,
	W =   179.662 deg,	P =      .062 deg,	R =    88.499 deg
};
P[150]{
   GP1:
	UF : 1, UT : 1,	
	J1=   -32.212 deg,	J2=    -5.303 deg,	J3=   -14.753 deg,
	J4=      .489 deg,	J5=   -75.141 deg,	J6=    30.997 deg
};
/END
