/PROG  B_AFLEGENKEL
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "Afleg op corona";
PROG_SIZE	= 2197;
CREATE		= DATE 19-06-03  TIME 16:45:44;
MODIFIED	= DATE 19-06-03  TIME 17:33:00;
FILE_NAME	= B_AFLEG;
VERSION		= 0;
LINE_COUNT	= 70;
MEMORY_SIZE	= 2725;
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
   6:   ;
   7:  LBL[100:Start afleggen] ;
   8:  LBL[88:Draaien nar aflg] ;
   9:J P[1:Naar corona] 75% CNT50    ;
  10:J P[2:Boven corona] 75% CNT50    ;
  11:   ;
  12:  LBL[89] ;
  13:  !CHECK STORINGEN ;
  14:   ;
  15:  $WAITTMOUT=500 ;
  16:  WAIT DI[20:Afl 1 vrij Corona]=ON AND DI[21:Afl 2 vrij Corona]=ON TIMEOUT,LBL[200] ;
  17:   ;
  18:  IF DI[14:Tamponeren]=ON,JMP LBL[90] ;
  19:   ;
  20:  !Skinetta storing  ;
  21:  WAIT DI[93:FC uitloop vrij]=OFF TIMEOUT,LBL[200] ;
  22:   ;
  23:  !Pouch machine storing ;
  24:  WAIT DI[93:FC uitloop vrij]=OFF TIMEOUT,LBL[200] ;
  25:   ;
  26:  LBL[90] ;
  27:  DO[49:Buzzer hek]=OFF ;
  28:  DO[50:Rode lamp hek]=OFF ;
  29:   ;
  30:  JMP LBL[50] ;
  31:J P[101:Boven afleg ] 100% CNT30    ;
  32:  LBL[101] ;
  33:J P[110:AFLEG 2] 75% CNT50 Offset,PR[82:Boven afleg]    ;
  34:L P[110:AFLEG 2] 500mm/sec FINE    ;
  35:  Open hand 1    ;
  36:  WAIT    .25(sec) ;
  37:L P[110:AFLEG 2] 1000mm/sec CNT50 Offset,PR[82:Boven afleg]    ;
  38:   ;
  39:  IF R[21:Grijper 1-voudig]=1,JMP LBL[20] ;
  40:   ;
  41:  LBL[50] ;
  42:   ;
  43:J P[111:draaien] 75% CNT100 ACC50    ;
  44:L P[120:AFLEG 1] 1000mm/sec CNT50 Offset,PR[82:Boven afleg]    ;
  45:L P[120:AFLEG 1] 500mm/sec FINE    ;
  46:  Open hand 2    ;
  47:  WAIT    .25(sec) ;
  48:L P[120:AFLEG 1] 650mm/sec CNT100 Offset,PR[82:Boven afleg]    ;
  49:   ;
  50:  LBL[20:1-VOUDIG] ;
  51:J P[150] 75% CNT100    ;
  52:   ;
  53:  IF R[9:Act R8]=0,JMP LBL[110] ;
  54:  IF R[9:Act R8]>=1 AND R[45:Teller ontstapel]=0,JMP LBL[210] ;
  55:   ;
  56:  JMP LBL[110] ;
  57:   ;
  58:  LBL[200:Buffer stapelen] ;
  59:  CALL BUF_STPLENKEL    ;
  60:  END ;
  61:   ;
  62:  LBL[210:Buffer leegmaken] ;
  63:  CALL BUF_ONTSENKEL    ;
  64:  IF R[42:Grijpfout bufffe]=1,JMP LBL[110] ;
  65:  JMP LBL[89] ;
  66:   ;
  67:  LBL[110:Einde programma] ;
  68:  R[45:Teller ontstapel]=0    ;
  69:  END ;
  70:   ;
/POS
P[1:"Naar corona"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =   825.000  mm,	Y = -1000.000  mm,	Z =   450.000  mm,
	W =   -89.000 deg,	P =      .505 deg,	R =   179.664 deg
};
P[2:"Boven corona"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  1040.000  mm,	Y = -1000.000  mm,	Z =   400.000  mm,
	W =   179.747 deg,	P =     -.806 deg,	R =   -92.046 deg
};
P[101:"Boven afleg "]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  1064.127  mm,	Y = -1008.616  mm,	Z =   362.822  mm,
	W =   179.662 deg,	P =      .062 deg,	R =   -92.024 deg
};
P[110:"AFLEG 2"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  1124.607  mm,	Y = -1008.616  mm,	Z =   222.966  mm,
	W =   179.662 deg,	P =      .062 deg,	R =   -92.024 deg
};
P[111:"draaien"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  1065.855  mm,	Y = -1008.615  mm,	Z =   332.485  mm,
	W =   179.662 deg,	P =      .062 deg,	R =   -38.430 deg
};
P[120:"AFLEG 1"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  1001.227  mm,	Y = -1008.615  mm,	Z =   223.676  mm,
	W =   179.662 deg,	P =      .062 deg,	R =    88.499 deg
};
P[150]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   799.479  mm,	Y =  -506.909  mm,	Z =   357.592  mm,
	W =   179.538 deg,	P =      .252 deg,	R =    -1.191 deg
};
/END
