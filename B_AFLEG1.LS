/PROG  B_AFLEG1
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "Afleg 1PA008";
PROG_SIZE	= 2090;
CREATE		= DATE 16-04-18  TIME 14:22:38;
MODIFIED	= DATE 16-05-24  TIME 15:04:34;
FILE_NAME	= B_AFLEG;
VERSION		= 0;
LINE_COUNT	= 65;
MEMORY_SIZE	= 2638;
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
   1:  DO[52:IONblower witband]=ON ;
   2:   ;
   3:  UFRAME_NUM=0 ;
   4:  !Producten afleggen ;
   5:  !Wacht op afleg corona vry ;
   6:   ;
   7:  LBL[100:Start afleggen] ;
   8:   ;
   9:  LBL[88] ;
  10:J P[1] 100% CNT50    ;
  11:J P[2] 100% CNT100    ;
  12:   ;
  13:  LBL[89] ;
  14:  !CHECK STORINGEN ;
  15:   ;
  16:  $WAITTMOUT=500 ;
  17:  WAIT DI[27:Afleg 1 is vrij]=ON AND DI[28:Afleg 2 is vrij]=ON TIMEOUT,LBL[220] ;
  18:   ;
  19:  LBL[90] ;
  20:  $WAITTMOUT=500 ;
  21:  WAIT DI[27:Afleg 1 is vrij]=ON AND DI[28:Afleg 2 is vrij]=ON TIMEOUT,LBL[200] ;
  22:   ;
  23:  DO[49:Buzzer hek]=OFF ;
  24:  DO[50:Rode lamp hek]=OFF ;
  25:   ;
  26:J P[101] 100% CNT30    ;
  27:  LBL[101] ;
  28:J P[110:AFLEG 2] 100% CNT50 Offset,PR[82:Boven afleg]    ;
  29:L P[110:AFLEG 2] 1000mm/sec FINE    ;
  30:  Open hand 1    ;
  31:  WAIT    .25(sec) ;
  32:L P[110:AFLEG 2] 1200mm/sec CNT50 Offset,PR[82:Boven afleg]    ;
  33:J P[111:draaien] 60% CNT100    ;
  34:   ;
  35:L P[120:AFLEG 1] 600mm/sec CNT50 Offset,PR[82:Boven afleg]    ;
  36:L P[120:AFLEG 1] 400mm/sec FINE    ;
  37:  Open hand 2    ;
  38:  WAIT    .25(sec) ;
  39:  DO[14321]=PULSE,6.0sec ;
  40:L P[120:AFLEG 1] 1000mm/sec CNT100 Offset,PR[82:Boven afleg]    ;
  41:L P[3] 1000mm/sec CNT100    ;
  42:J P[150] 90% CNT100    ;
  43:   ;
  44:  IF R[9:Act R8]=0,JMP LBL[110] ;
  45:  IF R[9:Act R8]>=1 AND R[45:Teller ontstapel]=0,JMP LBL[210] ;
  46:   ;
  47:  JMP LBL[110] ;
  48:   ;
  49:  LBL[200:Buffer stapelen] ;
  50:  CALL BUF_S008    ;
  51:  END ;
  52:   ;
  53:  LBL[210:Buffer leegmaken] ;
  54:  CALL BUF_O008    ;
  55:  IF R[42:Grijpfout bufffe]=1,JMP LBL[110] ;
  56:  JMP LBL[89] ;
  57:   ;
  58:  LBL[220] ;
  59:  DO[14321]=PULSE,6.0sec ;
  60:  WAIT   6.00(sec) ;
  61:  JMP LBL[90] ;
  62:   ;
  63:  LBL[110:Einde programma] ;
  64:  R[45:Teller ontstapel]=0    ;
  65:  END ;
/POS
P[1]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =   814.992  mm,	Y =  -781.003  mm,	Z =   480.572  mm,
	W =   -89.916 deg,	P =      .605 deg,	R =   179.764 deg
};
P[2]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   490.019  mm,	Y =    -1.159  mm,	Z =   491.483  mm,
	W =  -178.689 deg,	P =    -1.079 deg,	R =   -89.277 deg
};
P[3]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   884.425  mm,	Y =   426.007  mm,	Z =   432.881  mm,
	W =  -179.843 deg,	P =      .800 deg,	R =    88.193 deg
};
P[101]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   800.000  mm,	Y =   455.000  mm,	Z =   443.139  mm,
	W =   179.845 deg,	P =     -.800 deg,	R =   -91.950 deg
};
P[110:"AFLEG 2"]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  1033.378  mm,	Y =   425.671  mm,	Z =   235.417  mm,
	W =   179.845 deg,	P =     -.800 deg,	R =   -91.951 deg
};
P[111:"draaien"]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   920.009  mm,	Y =   425.927  mm,	Z =   285.218  mm,
	W =   179.185 deg,	P =      .009 deg,	R =   -12.247 deg
};
P[120:"AFLEG 1"]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   884.765  mm,	Y =   426.007  mm,	Z =   235.812  mm,
	W =  -179.843 deg,	P =      .800 deg,	R =    88.194 deg
};
P[150]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   490.019  mm,	Y =    -1.159  mm,	Z =   491.483  mm,
	W =  -178.689 deg,	P =    -1.079 deg,	R =   -89.277 deg
};
/END
