/PROG  B_KEREN2
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "1PA005";
PROG_SIZE	= 2569;
CREATE		= DATE 19-04-01  TIME 22:52:30;
MODIFIED	= DATE 19-04-03  TIME 22:28:02;
FILE_NAME	= B_KEREN;
VERSION		= 0;
LINE_COUNT	= 96;
MEMORY_SIZE	= 3073;
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
   1:  UFRAME_NUM=1 ;
   2:  IF DI[16:Magazijnklep dicht]=OFF,JMP LBL[540] ;
   3:   ;
   4:  !CONTROLE KEERUNIT LEEG ;
   5:  IF DI[71:Keerunit leeg]=ON,JMP LBL[500] ;
   6:   ;
   7:  LBL[10:KEREN PLATE 005] ;
   8:  IF DI[73:Keerunit op rust]=OFF,JMP LBL[530] ;
   9:   ;
  10:  LBL[20:CONTROLE] ;
  11:J P[14:Naar keerunit] 85% CNT100    ;
  12:J P[2:Voor keerunit ] 85% CNT100    ;
  13:   ;
  14:L P[7:Boven los] 1250mm/sec CNT5 Tool_Offset,PR[62:Offs voor los0]    ;
  15:L P[7:Boven los] 800mm/sec FINE Tool_Offset,PR[63:Voor los005]    ;
  16:   ;
  17:L P[7:Boven los] 200mm/sec FINE    ;
  18:L P[3:Los] 200mm/sec CNT5    ;
  19:  !GRIPPERS OPEN ;
  20:  WAIT    .25(sec) ;
  21:  Open hand 1    ;
  22:  Open hand 2    ;
  23:  WAIT    .25(sec) ;
  24:L P[3:Los] 1500mm/sec CNT10 Tool_Offset,PR[64:Na los ker A1]    ;
  25:   ;
  26:  !KEERUNIT NAAR ACTIE ;
  27:  DO[41:Keerunit rust]=OFF ;
  28:  DO[42:Keerunit actie]=ON ;
  29:   ;
  30:  WAIT DI[74:Keerunit actie]=ON    ;
  31:  !CONTROLE GRYPER OPEN ;
  32:  IF RI[1:Bek B Open]=OFF OR RI[3:Bek A Open]=OFF,JMP LBL[510] ;
  33:   ;
  34:  !Pak producten ;
  35:J P[8:Pakpos] 75% CNT100 Tool_Offset,PR[69:Voor pak ker A]    ;
  36:L P[8:Pakpos] 300mm/sec FINE    ;
  37:  WAIT    .25(sec) ;
  38:  Close hand 1    ;
  39:  Close hand 2    ;
  40:  WAIT    .25(sec) ;
  41:L P[8:Pakpos] 250mm/sec FINE Tool_Offset,PR[70:Na pak ker A1]    ;
  42:L P[9:TOOL X plus] 300mm/sec FINE    ;
  43:J P[10:TOOL Z min] 90% CNT100    ;
  44:   ;
  45:J P[13:Na keren] 90% CNT100    ;
  46:   ;
  47:  !KEERUNIT NAAR RUST ;
  48:  DO[42:Keerunit actie]=OFF ;
  49:  DO[41:Keerunit rust]=ON ;
  50:   ;
  51:  !GRIJPCONTROLE ;
  52:   ;
  53:  LBL[40:UITNAME CONTROLE] ;
  54:  IF RI[1:Bek B Open]=OFF AND RI[2:Bek B product aanwezig]=ON AND RI[3:Bek A Open]=OFF AND RI[4:Bek A product aanwezig]=ON,JMP LBL[50] ;
  55:  IF R[100:Product controle]>1,JMP LBL[520] ;
  56:  WAIT    .01(sec) ;
  57:  R[100:Product controle]=R[100:Product controle]+.01    ;
  58:  JMP LBL[40] ;
  59:   ;
  60:  LBL[50:UITNAME OK ] ;
  61:  R[100:Product controle]=0    ;
  62:  END ;
  63:   ;
  64:  !--------------------------- ;
  65:  !FOUTMELDINGEN ;
  66:   ;
  67:  LBL[500:KERUNIT NIET VRY] ;
  68:J P[1:Rustpositie] 50% CNT50    ;
  69:  R[81:Kerunit niet vry]=1    ;
  70:  END ;
  71:   ;
  72:  LBL[510:KERUNIT NIET VRY] ;
  73:L P[5:VOOR CONTROLE] 500mm/sec CNT50    ;
  74:J P[6] 25% CNT50    ;
  75:  R[82:Grijper open]=1    ;
  76:  END ;
  77:   ;
  78:  LBL[520:GRYPCONTR KEREN] ;
  79:J P[6] 50% CNT50    ;
  80:  R[83:Grijpcontr keren]=1    ;
  81:  END ;
  82:   ;
  83:  LBL[530:KEERUNIT RUST] ;
  84:  !KEERUNIT NAAR RUST ;
  85:  DO[42:Keerunit actie]=OFF ;
  86:  DO[41:Keerunit rust]=ON ;
  87:   ;
  88:  WAIT DI[73:Keerunit op rust]=ON    ;
  89:  WAIT   1.00(sec) ;
  90:  JMP LBL[10] ;
  91:   ;
  92:  LBL[540:GEEN LUCHT AANW.] ;
  93:J P[1:Rustpositie] 50% CNT50    ;
  94:  R[84:Lucht keerunit]=1    ;
  95:  END ;
  96:   ;
/POS
P[1:"Rustpositie"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   450.666  mm,	Y =      .032  mm,	Z =   356.945  mm,
	W =   179.902 deg,	P =      .001 deg,	R =   -90.102 deg
};
P[2:"Voor keerunit "]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  -714.367  mm,	Y =  -625.000  mm,	Z =   282.176  mm,
	W =   -87.528 deg,	P =   -64.282 deg,	R =   178.242 deg
};
P[3:"Los"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X = -1222.473  mm,	Y =  -730.608  mm,	Z =    94.978  mm,
	W =   -87.869 deg,	P =   -64.197 deg,	R =   178.423 deg
};
P[5:"VOOR CONTROLE"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  -748.763  mm,	Y =  -498.140  mm,	Z =   375.997  mm,
	W =   -86.371 deg,	P =   -63.865 deg,	R =   176.676 deg
};
P[6]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  -103.635  mm,	Y =  -490.058  mm,	Z =   320.200  mm,
	W =  -177.929 deg,	P =      .387 deg,	R =   171.241 deg
};
P[7:"Boven los"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X = -1243.149  mm,	Y =  -729.956  mm,	Z =   140.824  mm,
	W =   -87.869 deg,	P =   -64.195 deg,	R =   178.422 deg
};
P[8:"Pakpos"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X = -1221.611  mm,	Y =  -728.929  mm,	Z =    92.804  mm,
	W =   -87.116 deg,	P =   -64.282 deg,	R =   178.240 deg
};
P[9:"TOOL X plus"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X = -1299.911  mm,	Y =  -726.480  mm,	Z =   257.526  mm,
	W =   -87.116 deg,	P =   -64.282 deg,	R =   178.239 deg
};
P[10:"TOOL Z min"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X = -1301.889  mm,	Y =  -591.405  mm,	Z =   254.577  mm,
	W =   -87.116 deg,	P =   -64.282 deg,	R =   178.239 deg
};
P[13:"Na keren"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  -667.845  mm,	Y =  -579.556  mm,	Z =   372.208  mm,
	W =   -87.115 deg,	P =   -64.282 deg,	R =   178.239 deg
};
P[14:"Naar keerunit"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  -519.325  mm,	Y =  -565.939  mm,	Z =   221.161  mm,
	W =  -147.109 deg,	P =   -45.268 deg,	R =  -130.755 deg
};
/END
