/PROG  HOMEN
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "Automatisch home";
PROG_SIZE	= 3278;
CREATE		= DATE 16-03-02  TIME 13:31:00;
MODIFIED	= DATE 19-04-02  TIME 00:30:18;
FILE_NAME	= ONTSTPL;
VERSION		= 0;
LINE_COUNT	= 116;
MEMORY_SIZE	= 3742;
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
   1:  !******************************** ;
   2:  !HOME ZOEKEN ;
   3:  !******************************** ;
   4:   ;
   5:  LBL[1000] ;
   6:  CALL TEKST(1000) ;
   7:  PAYLOAD[1] ;
   8:  OVERRIDE=25% ;
   9:  PR[100:Home Lpos]=LPOS    ;
  10:  R[200:Homezoek X]=PR[100,1:Home Lpos]    ;
  11:  R[199:Homezoek Y]=PR[100,2:Home Lpos]    ;
  12:  R[198:Homezoek Z]=PR[100,3:Home Lpos]    ;
  13:   ;
  14:  PR[99:Home Jpos]=JPOS    ;
  15:  R[193:J4]=PR[99,4:Home Jpos]    ;
  16:  R[194:J6]=PR[99,6:Home Jpos]    ;
  17:   ;
  18:  R[189:Act Uframe]=$MNUFRAMENUM[1] ;
  19:  R[188:Act Utool]=$MNUTOOLNUM[1] ;
  20:   ;
  21:  IF DO[100:Robot op reference]=ON,JMP LBL[1100] ;
  22:   ;
  23:  !Keerunit  ;
  24:  IF R[200:Homezoek X]<(-900) AND R[199:Homezoek Y]>(-900),JMP LBL[1095] ;
  25:  !Positioneren ;
  26:  IF R[200:Homezoek X]<(-900),JMP LBL[1090] ;
  27:  !Ontstapelaar ;
  28:  IF R[200:Homezoek X]<(-250),JMP LBL[1080] ;
  29:  !Printen ;
  30:  IF R[200:Homezoek X]<790 AND R[200:Homezoek X]>(-250) AND R[199:Homezoek Y]<(-1000),JMP LBL[1030] ;
  31:  !Afleggen ;
  32:  IF R[200:Homezoek X]>760 AND R[199:Homezoek Y]<(-700),JMP LBL[1040] ;
  33:  !Buiten SGM ;
  34:  IF R[200:Homezoek X]>0 AND R[199:Homezoek Y]<500 AND R[199:Homezoek Y]>(-800),JMP LBL[1010] ;
  35:   ;
  36:   ;
  37:   ;
  38:  LBL[1010:Buiten SGM] ;
  39:  PR[100,3:Home Lpos]=500    ;
  40:L PR[100:Home Lpos] 100mm/sec CNT10    ;
  41:  PR[100,1:Home Lpos]=350    ;
  42:L PR[100:Home Lpos] 100mm/sec CNT10    ;
  43:  JMP LBL[1100] ;
  44:   ;
  45:  LBL[1030:Printen] ;
  46:  PR[100,3:Home Lpos]=330    ;
  47:L PR[100:Home Lpos] 100mm/sec CNT10    ;
  48:  PR[100,2:Home Lpos]=(-750)    ;
  49:L PR[100:Home Lpos] 100mm/sec CNT10    ;
  50:  JMP LBL[1100] ;
  51:   ;
  52:  LBL[1040:Afleggen] ;
  53:  IF R[200:Homezoek X]<1050,JMP LBL[1041] ;
  54:  PR[100,1:Home Lpos]=PR[100,1:Home Lpos]-100    ;
  55:L PR[100:Home Lpos] 100mm/sec CNT10    ;
  56:   ;
  57:  LBL[1041] ;
  58:  PR[100,3:Home Lpos]=PR[100,3:Home Lpos]+100    ;
  59:L PR[100:Home Lpos] 100mm/sec CNT10    ;
  60:  PR[100,2:Home Lpos]=(-600)    ;
  61:L PR[100:Home Lpos] 300mm/sec CNT10    ;
  62:  PR[100,1:Home Lpos]=500    ;
  63:L PR[100:Home Lpos] 300mm/sec CNT10    ;
  64:  JMP LBL[1100] ;
  65:   ;
  66:  LBL[1080:Ontstapelaar] ;
  67:  UFRAME_NUM=1 ;
  68:  IF R[199:Homezoek Y]>(-900),JMP LBL[1081] ;
  69:  PR[100,3:Home Lpos]=150    ;
  70:L PR[100:Home Lpos] 100mm/sec CNT10    ;
  71:  LBL[1081] ;
  72:   ;
  73:J P[1080] 10% CNT10    ;
  74:J P[1081] 20% CNT100    ;
  75:  JMP LBL[1100] ;
  76:   ;
  77:  LBL[1090:POSITIONEREN] ;
  78:   ;
  79:  LBL[1091] ;
  80:L P[1091] 200mm/sec CNT20    ;
  81:L P[1092] 400mm/sec CNT100    ;
  82:J P[1093] 25% CNT100    ;
  83:J P[1094] 25% CNT100    ;
  84:  JMP LBL[1100] ;
  85:   ;
  86:  LBL[1095:Keerunit] ;
  87:  UFRAME_NUM=1 ;
  88:  IF R[199:Homezoek Y]>(-710),JMP LBL[1096] ;
  89:   ;
  90:  IF R[199:Homezoek Y]<(-740) AND R[199:Homezoek Y]<(-710),JMP LBL[1097] ;
  91:   ;
  92:  LBL[1096] ;
  93:  PR[100,2:Home Lpos]=(-550)    ;
  94:L PR[100:Home Lpos] 100mm/sec CNT10    ;
  95:L P[2] 250mm/sec CNT100    ;
  96:   ;
  97:  JMP LBL[1100] ;
  98:   ;
  99:  LBL[1097] ;
 100:  MESSAGE[ROBOT STAAT IN KEERUNIT] ;
 101:  MESSAGE[...] ;
 102:  MESSAGE[BEL ETS OM ROBOT ] ;
 103:  MESSAGE[HANDMATIG WEG TE BEWEGE] ;
 104:  MESSAGE[...] ;
 105:  MESSAGE[DAARNA RESETTEN D.M.V.] ;
 106:  MESSAGE[BLAUWE KNOP IN TE HOUDE] ;
 107:  MESSAGE[...] ;
 108:  WAIT R[94:Wait forever]=999999    ;
 109:   ;
 110:  JMP LBL[1100] ;
 111:   ;
 112:  LBL[1100] ;
 113:  UFRAME_NUM=1 ;
 114:  UTOOL_NUM=1 ;
 115:J P[1:rust positie] 30% CNT100    ;
 116:   ;
/POS
P[1:"rust positie"]{
   GP1:
	UF : 0, UT : 1,	
	J1=     -.130 deg,	J2=   -46.859 deg,	J3=      .122 deg,
	J4=     -.000 deg,	J5=   -90.022 deg,	J6=   -90.000 deg
};
P[2]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  -608.615  mm,	Y =  -534.574  mm,	Z =   387.394  mm,
	W =   -87.115 deg,	P =   -64.282 deg,	R =   178.240 deg
};
P[1080]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  -641.999  mm,	Y = -1045.000  mm,	Z =   160.498  mm,
	W =   179.940 deg,	P =     -.669 deg,	R =   -91.002 deg
};
P[1081]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  -508.389  mm,	Y =  -602.298  mm,	Z =   162.242  mm,
	W =   179.924 deg,	P =     -.166 deg,	R =  -130.101 deg
};
P[1091]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X = -1168.263  mm,	Y = -1048.996  mm,	Z =   135.489  mm,
	W =   108.626 deg,	P =    -1.588 deg,	R =   -90.453 deg
};
P[1092]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  -911.448  mm,	Y = -1048.208  mm,	Z =   236.701  mm,
	W =   108.626 deg,	P =    -1.588 deg,	R =   -90.454 deg
};
P[1093]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  -603.401  mm,	Y =  -858.434  mm,	Z =   197.523  mm,
	W =  -179.895 deg,	P =     -.540 deg,	R =   -91.030 deg
};
P[1094]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  -508.389  mm,	Y =  -602.298  mm,	Z =   162.242  mm,
	W =   179.924 deg,	P =     -.166 deg,	R =  -130.101 deg
};
/END
