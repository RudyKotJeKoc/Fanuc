/PROG  B_CORONA
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "";
PROG_SIZE	= 2455;
CREATE		= DATE 16-05-23  TIME 08:45:26;
MODIFIED	= DATE 16-05-23  TIME 15:31:46;
FILE_NAME	= ;
VERSION		= 0;
LINE_COUNT	= 92;
MEMORY_SIZE	= 2879;
PROTECT		= READ_WRITE;
TCD:  STACK_SIZE	= 0,
      TASK_PRIORITY	= 50,
      TIME_SLICE	= 0,
      BUSY_LAMP_OFF	= 0,
      ABORT_REQUEST	= 0,
      PAUSE_REQUEST	= 0;
DEFAULT_GROUP	= 1,*,*,*,*;
CONTROL_CODE	= 00000000 00000000;
/MN
   1:  !PRODUCT NAAR CORONA ;
   2:   ;
   3:  DO[51:IONblower Corona]=ON ;
   4:   ;
   5:  UFRAME_NUM=0 ;
   6:  !Producten afleggen ;
   7:  !Wacht op afleg corona vry ;
   8:   ;
   9:  !CHECK STORINGEN ;
  10:   ;
  11:  $WAITTMOUT=500 ;
  12:  WAIT DI[20:Afl 1 vrij Corona]=ON AND DI[21:Afl 2 vrij Corona]=ON TIMEOUT,LBL[200] ;
  13:   ;
  14:  !Skinetta storing  ;
  15:  WAIT DI[93:FC uitloop vrij]=OFF TIMEOUT,LBL[200] ;
  16:   ;
  17:  !Pouch machine storing ;
  18:  WAIT DI[93:FC uitloop vrij]=OFF TIMEOUT,LBL[200] ;
  19:   ;
  20:  DO[49:Buzzer hek]=OFF ;
  21:  DO[50:Rode lamp hek]=OFF ;
  22:   ;
  23:  LBL[10:Product pakken] ;
  24:  !Ceck orientatie  ;
  25:  R[34:Orientatie mask]=0    ;
  26:   ;
  27:  IF DI[83:1e afleg uni]=ON,JMP LBL[11] ;
  28:  JMP LBL[12] ;
  29:   ;
  30:  LBL[11] ;
  31:  R[34:Orientatie mask]=1    ;
  32:  JMP LBL[12] ;
  33:   ;
  34:  LBL[12:Product pakken] ;
  35:J P[2] 80% CNT25    ;
  36:J P[1:PAKPOS MASKER] 50% CNT50 Offset,PR[82:Boven afleg]    ;
  37:   ;
  38:L P[1:PAKPOS MASKER] 250mm/sec CNT25    ;
  39:  Close hand 1    ;
  40:  WAIT    .25(sec) ;
  41:L P[3:NA PAK] 250mm/sec CNT25    ;
  42:   ;
  43:  !Check grijper ;
  44:  IF RI[4:Bek A product aanwezig]=ON AND RI[3:Bek A Open]=OFF,JMP LBL[20] ;
  45:  JMP LBL[210] ;
  46:   ;
  47:  LBL[20:Afleg op corona] ;
  48:J P[4] 50% CNT100    ;
  49:   ;
  50:  IF R[34:Orientatie mask]=0,JMP LBL[22] ;
  51:   ;
  52:  LBL[21:Afleg 0'] ;
  53:L P[11] 100mm/sec CNT100    ;
  54:L P[10] 800mm/sec CNT100 Offset,PR[82:Boven afleg]    ;
  55:L P[10] 500mm/sec CNT100    ;
  56:   ;
  57:  Open hand 1    ;
  58:  WAIT    .25(sec) ;
  59:   ;
  60:L P[10] 800mm/sec CNT60 Offset,PR[82:Boven afleg]    ;
  61:L P[11] 800mm/sec CNT100    ;
  62:J P[50:Deuppos] 100% CNT80    ;
  63:   ;
  64:  JMP LBL[110] ;
  65:   ;
  66:  LBL[22:Afleg-180'] ;
  67:J P[5] 50% CNT80    ;
  68:L P[6] 800mm/sec CNT100 Offset,PR[82:Boven afleg]    ;
  69:L P[6] 500mm/sec CNT100    ;
  70:   ;
  71:L P[9] 250mm/sec CNT20    ;
  72:  Open hand 1    ;
  73:  WAIT    .25(sec) ;
  74:   ;
  75:L P[6] 250mm/sec CNT10    ;
  76:L P[6] 800mm/sec CNT60 Offset,PR[82:Boven afleg]    ;
  77:L P[7] 800mm/sec CNT100    ;
  78:J P[50:Deuppos] 100% CNT80    ;
  79:   ;
  80:  JMP LBL[110] ;
  81:   ;
  82:  LBL[110:Einde programma] ;
  83:  END ;
  84:   ;
  85:  LBL[200:Lijn storing] ;
  86:  DO[49:Buzzer hek]=PULSE,10.0sec ;
  87:  DO[50:Rode lamp hek]=ON ;
  88:  END ;
  89:   ;
  90:  LBL[210:Grijpfout masker] ;
  91:  R[36:Grijpfout masker]=1    ;
  92:  END ;
/POS
P[1:"PAKPOS MASKER"]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  1108.696  mm,	Y =  -175.627  mm,	Z =   233.209  mm,
	W =  -179.214 deg,	P =     -.353 deg,	R =     -.987 deg
};
P[2]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   729.496  mm,	Y =  -175.627  mm,	Z =   525.128  mm,
	W =  -179.214 deg,	P =     -.353 deg,	R =     -.987 deg
};
P[3:"NA PAK"]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  1108.696  mm,	Y =  -175.627  mm,	Z =   388.808  mm,
	W =  -179.214 deg,	P =     -.353 deg,	R =     -.987 deg
};
P[4]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   819.543  mm,	Y =  -446.347  mm,	Z =   388.808  mm,
	W =  -179.214 deg,	P =     -.353 deg,	R =     -.987 deg
};
P[5]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  1074.095  mm,	Y = -1012.910  mm,	Z =   364.834  mm,
	W =   179.962 deg,	P =      .002 deg,	R =    89.955 deg
};
P[6]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  1074.095  mm,	Y = -1012.910  mm,	Z =   229.586  mm,
	W =   179.962 deg,	P =      .002 deg,	R =    89.955 deg
};
P[7]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   803.375  mm,	Y =  -537.134  mm,	Z =   442.019  mm,
	W =   179.962 deg,	P =      .001 deg,	R =    89.955 deg
};
P[9]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  1155.596  mm,	Y = -1012.910  mm,	Z =   229.586  mm,
	W =   179.962 deg,	P =      .002 deg,	R =    89.955 deg
};
P[10]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  1007.317  mm,	Y = -1011.982  mm,	Z =   229.850  mm,
	W =  -179.905 deg,	P =      .560 deg,	R =   -90.723 deg
};
P[11]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  1007.316  mm,	Y = -1011.982  mm,	Z =   421.546  mm,
	W =  -179.905 deg,	P =      .560 deg,	R =   -90.723 deg
};
P[50:"Deuppos"]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   490.019  mm,	Y =    -1.159  mm,	Z =   491.483  mm,
	W =  -178.689 deg,	P =    -1.079 deg,	R =   -89.277 deg
};
/END
