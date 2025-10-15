/PROG  AFLG_006
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "Afleg 1pa006";
PROG_SIZE	= 1375;
CREATE		= DATE 15-07-15  TIME 10:23:28;
MODIFIED	= DATE 15-07-15  TIME 10:40:34;
FILE_NAME	= AFLEGGEN;
VERSION		= 0;
LINE_COUNT	= 41;
MEMORY_SIZE	= 1891;
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
   1:  UFRAME_NUM=0 ;
   2:  !Producten afleggen ;
   3:  !Wacht op afleg vry ;
   4:   ;
   5:  LBL[100:Start afleggen] ;
   6:   ;
   7:  $WAITTMOUT=500 ;
   8:  WAIT DI[20:Afl 1 vrij Corona]=ON AND DI[21:Afl 2 vrij Corona]=ON TIMEOUT,LBL[200] ;
   9:  WAIT DI[26:Transpbnd vol]=OFF TIMEOUT,LBL[200] ;
  10:   ;
  11:  DO[14:Vrij printer]=OFF ;
  12:   ;
  13:J P[101] 80% CNT30    ;
  14:  LBL[101] ;
  15:J P[110:AFLEG 2] 80% CNT50 Offset,PR[82:Boven afleg]    ;
  16:L P[110:AFLEG 2] 1000mm/sec FINE    ;
  17:  Open hand 1    ;
  18:  Open hand 2    ;
  19:  WAIT    .25(sec) ;
  20:L P[110:AFLEG 2] 1000mm/sec CNT50 Offset,PR[82:Boven afleg]    ;
  21:J P[150] 80% CNT100    ;
  22:   ;
  23:  IF R[9:Act R8]=0,JMP LBL[110] ;
  24:  IF R[9:Act R8]>=1 AND R[45:Teller ontstapel]=0,JMP LBL[210] ;
  25:   ;
  26:  JMP LBL[110] ;
  27:   ;
  28:  LBL[200:Buffer stapelen] ;
  29:  CALL BUF_S006    ;
  30:  END ;
  31:   ;
  32:  LBL[210:Buffer leegmaken] ;
  33:  CALL BUF_O006    ;
  34:  IF R[42:Grijpfout bufffe]=1,JMP LBL[110] ;
  35:  JMP LBL[100] ;
  36:   ;
  37:  LBL[110:Einde programma] ;
  38:  R[45:Teller ontstapel]=0    ;
  39:  END ;
  40:   ;
  41:   ;
/POS
P[101]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   829.940  mm,	Y =  -886.858  mm,	Z =   470.000  mm,
	W =  -179.960 deg,	P =     -.386 deg,	R =   -91.695 deg
};
P[110:"AFLEG 2"]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   830.309  mm,	Y =  -886.858  mm,	Z =   258.114  mm,
	W =  -179.960 deg,	P =     -.386 deg,	R =   -91.695 deg
};
P[150]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   628.070  mm,	Y =  -527.020  mm,	Z =   554.714  mm,
	W =   179.224 deg,	P =     1.130 deg,	R =  -150.251 deg
};
/END
