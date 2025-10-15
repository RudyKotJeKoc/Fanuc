/PROG  AFLG_WIT
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "Afleg witte band";
PROG_SIZE	= 1639;
CREATE		= DATE 15-11-23  TIME 18:58:04;
MODIFIED	= DATE 15-11-23  TIME 18:58:04;
FILE_NAME	= AFLEGGEN;
VERSION		= 0;
LINE_COUNT	= 48;
MEMORY_SIZE	= 2127;
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
  11:  !Veranderen in rode lamp ;
  12:  DO[14:Vrij printer]=OFF ;
  13:   ;
  14:J P[101] 80% CNT30    ;
  15:  LBL[101] ;
  16:J P[110:AFLEG 2] 80% CNT50 Offset,PR[82:Boven afleg]    ;
  17:L P[110:AFLEG 2] 1000mm/sec FINE    ;
  18:  Open hand 1    ;
  19:  WAIT    .25(sec) ;
  20:L P[110:AFLEG 2] 1000mm/sec CNT50 Offset,PR[82:Boven afleg]    ;
  21:L P[111:draaien] 800mm/sec CNT100    ;
  22:   ;
  23:L P[120:AFLEG 1] 600mm/sec CNT50 Offset,PR[82:Boven afleg]    ;
  24:L P[120:AFLEG 1] 250mm/sec FINE    ;
  25:  Open hand 2    ;
  26:  WAIT    .25(sec) ;
  27:L P[120:AFLEG 1] 1000mm/sec CNT100 Offset,PR[82:Boven afleg]    ;
  28:J P[150] 80% CNT100    ;
  29:   ;
  30:  IF R[9:Act R8]=0,JMP LBL[110] ;
  31:  IF R[9:Act R8]>=1 AND R[45:Teller ontstapel]=0,JMP LBL[210] ;
  32:   ;
  33:  $WAITTMOUT=100 ;
  34:  WAIT DI[6:Matrijs dicht]=ON TIMEOUT,LBL[110] ;
  35:  JMP LBL[210] ;
  36:   ;
  37:  LBL[200:Buffer stapelen] ;
  38:  CALL BUF_STPL    ;
  39:  END ;
  40:   ;
  41:  LBL[210:Buffer leegmaken] ;
  42:  CALL BUF_ONTS    ;
  43:  IF R[42:Grijpfout bufffe]=1,JMP LBL[110] ;
  44:  JMP LBL[100] ;
  45:   ;
  46:  LBL[110:Einde programma] ;
  47:  R[45:Teller ontstapel]=0    ;
  48:  END ;
/POS
P[101]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, -1',
	X =   607.412  mm,	Y =  -890.000  mm,	Z =   536.920  mm,
	W =   179.945 deg,	P =      .011 deg,	R =    88.245 deg
};
P[110:"AFLEG 2"]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, -1',
	X =   785.289  mm,	Y =  -865.000  mm,	Z =   242.000  mm,
	W =   179.751 deg,	P =      .170 deg,	R =    89.667 deg
};
P[111:"draaien"]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   694.387  mm,	Y =  -890.000  mm,	Z =   308.439  mm,
	W =   179.945 deg,	P =      .011 deg,	R =   136.025 deg
};
P[120:"AFLEG 1"]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   658.575  mm,	Y =  -865.000  mm,	Z =   242.000  mm,
	W =  -179.290 deg,	P =     -.183 deg,	R =   -90.724 deg
};
P[150]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   627.979  mm,	Y =  -603.054  mm,	Z =   506.715  mm,
	W =   179.224 deg,	P =     1.130 deg,	R =  -150.251 deg
};
/END
