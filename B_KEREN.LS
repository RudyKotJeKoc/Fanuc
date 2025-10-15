/PROG  B_KEREN
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "1PA008";
PROG_SIZE	= 2588;
CREATE		= DATE 16-04-15  TIME 13:01:38;
MODIFIED	= DATE 17-08-08  TIME 11:37:22;
FILE_NAME	= ;
VERSION		= 0;
LINE_COUNT	= 101;
MEMORY_SIZE	= 3072;
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
   1:  UFRAME_NUM=1 ;
   2:   ;
   3:  LBL[10:KEREN PLATE A] ;
   4:J P[1] 100% CNT100    ;
   5:   ;
   6:  IF DI[73:Keerunit op rust]=OFF,JMP LBL[530] ;
   7:   ;
   8:  LBL[20:CONTROLE] ;
   9:  !CONTROLE KEERUNIT LEEG ;
  10:  IF DI[71:Keerunit leeg]=ON,JMP LBL[500] ;
  11:   ;
  12:J P[2] 100% CNT100    ;
  13:   ;
  14:L P[7] 800mm/sec CNT10 Tool_Offset,PR[67:offs voor los ]    ;
  15:L P[7] 500mm/sec CNT10 Tool_Offset,PR[66:Voor los ker A]    ;
  16:L P[7] 100mm/sec FINE    ;
  17:  !GRIPPERS OPEN ;
  18:  Open hand 1    ;
  19:  Open hand 2    ;
  20:  WAIT    .25(sec) ;
  21:L PR[65:Los ker A1] 300mm/sec FINE    ;
  22:L P[3] 200mm/sec CNT20    ;
  23:L PR[65:Los ker A1] 1500mm/sec CNT10 Tool_Offset,PR[64:Na los ker A1]    ;
  24:   ;
  25:  !KEERUNIT NAAR ACTIE ;
  26:  DO[41:Keerunit rust]=OFF ;
  27:  DO[42:Keerunit actie]=ON ;
  28:   ;
  29:  WAIT DI[74:Keerunit actie]=ON    ;
  30:  !CONTROLE GRYPER OPEN ;
  31:  IF RI[1:Bek B Open]=OFF OR RI[3:Bek A Open]=OFF,JMP LBL[510] ;
  32:   ;
  33:   ;
  34:  !Pak product 1 ;
  35:J P[8:Pakpos1] 80% CNT100 Tool_Offset,PR[69:Voor pak ker A]    ;
  36:L P[8:Pakpos1] 300mm/sec FINE    ;
  37:  WAIT    .20(sec) ;
  38:  Close hand 1    ;
  39:  WAIT    .20(sec) ;
  40:L P[8:Pakpos1] 200mm/sec FINE Tool_Offset,PR[70:Na pak ker A1]    ;
  41:L P[9:TOOL X plus] 300mm/sec FINE    ;
  42:J P[10:TOOL Z min] 80% CNT100    ;
  43:   ;
  44:   ;
  45:  !Pak product 2 ;
  46:J P[11:Pakpos 2] 70% CNT100 Tool_Offset,PR[69:Voor pak ker A]    ;
  47:L P[11:Pakpos 2] 300mm/sec FINE    ;
  48:  WAIT    .20(sec) ;
  49:  Close hand 2    ;
  50:  WAIT    .20(sec) ;
  51:L P[11:Pakpos 2] 250mm/sec FINE Tool_Offset,PR[70:Na pak ker A1]    ;
  52:L P[12:TOOL Xplus] 300mm/sec FINE    ;
  53:L P[13] 1500mm/sec FINE    ;
  54:   ;
  55:  !KEERUNIT NAAR RUST ;
  56:  DO[42:Keerunit actie]=OFF ;
  57:  DO[41:Keerunit rust]=ON ;
  58:   ;
  59:  !GRIJPCONTROLE ;
  60:   ;
  61:  LBL[40:UITNAME CONTROLE] ;
  62:  IF RI[1:Bek B Open]=OFF AND RI[2:Bek B product aanwezig]=ON AND RI[3:Bek A Open]=OFF AND RI[4:Bek A product aanwezig]=ON,JMP LBL[50] ;
  63:  IF R[100:Product controle]>1,JMP LBL[520] ;
  64:  WAIT    .01(sec) ;
  65:  R[100:Product controle]=R[100:Product controle]+.01    ;
  66:  JMP LBL[40] ;
  67:   ;
  68:  LBL[50:UITNAME OK ] ;
  69:  R[100:Product controle]=0    ;
  70:  END ;
  71:   ;
  72:  !--------------------------- ;
  73:  !FOUTMELDINGEN ;
  74:   ;
  75:  LBL[500:KERUNIT NIET VRY] ;
  76:J P[6] 50% CNT50    ;
  77:  R[81:Kerunit niet vry]=1    ;
  78:  END ;
  79:   ;
  80:  LBL[510:KERUNIT NIET VRY] ;
  81:L P[5:VOOR CONTROLE] 500mm/sec CNT50    ;
  82:J P[6] 25% CNT50    ;
  83:  R[82:Grijper open]=1    ;
  84:  END ;
  85:   ;
  86:  LBL[520:GRYPCONTR KEREN] ;
  87:J P[6] 50% CNT50    ;
  88:  R[83:Grijpcontr keren]=1    ;
  89:  END ;
  90:   ;
  91:  LBL[530:KEERUNIT RUST] ;
  92:   ;
  93:  !KEERUNIT NAAR RUST ;
  94:  DO[42:Keerunit actie]=OFF ;
  95:  DO[41:Keerunit rust]=ON ;
  96:   ;
  97:  WAIT DI[73:Keerunit op rust]=ON    ;
  98:  WAIT   1.00(sec) ;
  99:  JMP LBL[20] ;
 100:   ;
 101:   ;
/POS
P[1]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  -411.616  mm,	Y =  -268.461  mm,	Z =   492.690  mm,
	W =   178.788 deg,	P =    -1.189 deg,	R =  -139.886 deg
};
P[2]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  -803.942  mm,	Y =  -597.236  mm,	Z =   301.456  mm,
	W =   -94.111 deg,	P =   -62.569 deg,	R =  -175.033 deg
};
P[3]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X = -1223.345  mm,	Y =  -639.367  mm,	Z =    88.392  mm,
	W =   -87.923 deg,	P =   -63.874 deg,	R =   177.747 deg
};
P[5:"VOOR CONTROLE"]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  -747.747  mm,	Y =  -500.247  mm,	Z =   528.389  mm,
	W =   -86.384 deg,	P =   -63.765 deg,	R =   176.788 deg
};
P[6]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  -102.539  mm,	Y =  -491.039  mm,	Z =   473.719  mm,
	W =  -177.945 deg,	P =      .486 deg,	R =   171.341 deg
};
P[7]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X = -1249.674  mm,	Y =  -726.757  mm,	Z =   142.311  mm,
	W =   -87.923 deg,	P =   -63.874 deg,	R =   177.747 deg
};
P[8:"Pakpos1"]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X = -1041.568  mm,	Y =  -717.855  mm,	Z =   177.927  mm,
	W =   -87.961 deg,	P =   -63.344 deg,	R =   177.743 deg
};
P[9:"TOOL X plus"]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X = -1108.671  mm,	Y =  -715.171  mm,	Z =   313.934  mm,
	W =   -87.961 deg,	P =   -63.344 deg,	R =   177.743 deg
};
P[10:"TOOL Z min"]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X = -1113.006  mm,	Y =  -575.975  mm,	Z =   316.303  mm,
	W =   -87.284 deg,	P =   -63.580 deg,	R =   177.538 deg
};
P[11:"Pakpos 2"]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X = -1410.307  mm,	Y =  -724.804  mm,	Z =     3.167  mm,
	W =   -86.543 deg,	P =   -63.779 deg,	R =   177.376 deg
};
P[12:"TOOL Xplus"]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X = -1473.718  mm,	Y =  -722.276  mm,	Z =   136.603  mm,
	W =   -86.542 deg,	P =   -63.779 deg,	R =   177.375 deg
};
P[13]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  -732.730  mm,	Y =  -535.202  mm,	Z =   532.168  mm,
	W =   -86.914 deg,	P =   -63.779 deg,	R =   177.375 deg
};
/END
