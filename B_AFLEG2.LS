/PROG  B_AFLEG2
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "Grijper paars";
PROG_SIZE	= 1910;
CREATE		= DATE 19-04-01  TIME 22:40:56;
MODIFIED	= DATE 19-04-03  TIME 22:52:32;
FILE_NAME	= B_AFLEG;
VERSION		= 0;
LINE_COUNT	= 62;
MEMORY_SIZE	= 2342;
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
   9:J P[1:Naar corona] 85% CNT50    ;
  10:J P[2:Boven corona] 85% CNT50    ;
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
  30:J P[101:Boven afleg ] 100% CNT30    ;
  31:  LBL[101] ;
  32:J P[110:AFLEG 2] 85% CNT50 Offset,PR[82:Boven afleg]    ;
  33:L P[110:AFLEG 2] 500mm/sec FINE    ;
  34:  Open hand 1    ;
  35:  WAIT    .25(sec) ;
  36:L P[110:AFLEG 2] 1000mm/sec CNT50 Offset,PR[82:Boven afleg]    ;
  37:   ;
  38:J P[111:draaien] 90% CNT100 ACC50    ;
  39:L P[120:AFLEG 1] 1750mm/sec CNT50 Offset,PR[82:Boven afleg]    ;
  40:L P[120:AFLEG 1] 500mm/sec FINE    ;
  41:  Open hand 2    ;
  42:  WAIT    .25(sec) ;
  43:L P[120:AFLEG 1] 750mm/sec CNT100 Offset,PR[82:Boven afleg]    ;
  44:   ;
  45:  IF R[9:Act R8]=0,JMP LBL[110] ;
  46:  IF R[9:Act R8]>=1 AND R[45:Teller ontstapel]=0,JMP LBL[210] ;
  47:   ;
  48:  JMP LBL[110] ;
  49:   ;
  50:  LBL[200:Buffer stapelen] ;
  51:  CALL BUF_STPL2    ;
  52:  END ;
  53:   ;
  54:  LBL[210:Buffer leegmaken] ;
  55:  CALL BUF_ONTS2    ;
  56:  IF R[42:Grijpfout bufffe]=1,JMP LBL[110] ;
  57:  JMP LBL[89] ;
  58:   ;
  59:  LBL[110:Einde programma] ;
  60:  R[45:Teller ontstapel]=0    ;
  61:  END ;
  62:   ;
/POS
P[1:"Naar corona"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =   825.000  mm,	Y = -1000.000  mm,	Z =   450.000  mm,
	W =   -89.915 deg,	P =      .505 deg,	R =   179.664 deg
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
	X =  1100.000  mm,	Y = -1008.616  mm,	Z =   225.000  mm,
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
	X =   980.000  mm,	Y = -1008.615  mm,	Z =   225.000  mm,
	W =   179.662 deg,	P =      .062 deg,	R =    88.499 deg
};
/END
