/PROG  HOMEN1
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "homen ontstapele";
PROG_SIZE	= 2729;
CREATE		= DATE 19-02-28  TIME 22:39:58;
MODIFIED	= DATE 19-03-22  TIME 18:45:34;
FILE_NAME	= HOMEN;
VERSION		= 0;
LINE_COUNT	= 89;
MEMORY_SIZE	= 3173;
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
  23:  !Positioneren ;
  24:  IF R[200:Homezoek X]<(-900),JMP LBL[1090] ;
  25:  !Ontstapelaar ;
  26:  IF R[200:Homezoek X]<(-250),JMP LBL[1080] ;
  27:  !Printen ;
  28:  IF R[200:Homezoek X]<790 AND R[200:Homezoek X]>(-250) AND R[199:Homezoek Y]<(-1000),JMP LBL[1030] ;
  29:  !Afleggen ;
  30:  IF R[200:Homezoek X]>760 AND R[199:Homezoek Y]<(-700),JMP LBL[1040] ;
  31:  !Buiten SGM ;
  32:  IF R[200:Homezoek X]>0 AND R[199:Homezoek Y]<500 AND R[199:Homezoek Y]>(-800),JMP LBL[1010] ;
  33:   ;
  34:   ;
  35:   ;
  36:  LBL[1010:Buiten SGM] ;
  37:  PR[100,3:Home Lpos]=500    ;
  38:L PR[100:Home Lpos] 100mm/sec CNT10    ;
  39:  PR[100,1:Home Lpos]=350    ;
  40:L PR[100:Home Lpos] 100mm/sec CNT10    ;
  41:  JMP LBL[1100] ;
  42:   ;
  43:  LBL[1030:Printen] ;
  44:  PR[100,3:Home Lpos]=330    ;
  45:L PR[100:Home Lpos] 100mm/sec CNT10    ;
  46:  PR[100,2:Home Lpos]=(-750)    ;
  47:L PR[100:Home Lpos] 100mm/sec CNT10    ;
  48:  JMP LBL[1100] ;
  49:   ;
  50:  LBL[1040:Afleggen] ;
  51:  IF R[200:Homezoek X]<1050,JMP LBL[1041] ;
  52:  PR[100,1:Home Lpos]=PR[100,1:Home Lpos]-100    ;
  53:L PR[100:Home Lpos] 100mm/sec CNT10    ;
  54:   ;
  55:   ;
  56:  LBL[1041] ;
  57:  PR[100,3:Home Lpos]=PR[100,3:Home Lpos]+100    ;
  58:L PR[100:Home Lpos] 100mm/sec CNT10    ;
  59:  PR[100,2:Home Lpos]=(-600)    ;
  60:L PR[100:Home Lpos] 300mm/sec CNT10    ;
  61:  PR[100,1:Home Lpos]=500    ;
  62:L PR[100:Home Lpos] 300mm/sec CNT10    ;
  63:  JMP LBL[1100] ;
  64:   ;
  65:  LBL[1080:Ontstapelaar] ;
  66:  UFRAME_NUM=1 ;
  67:  IF R[199:Homezoek Y]>(-900),JMP LBL[1081] ;
  68:  PR[100,3:Home Lpos]=200    ;
  69:L PR[100:Home Lpos] 100mm/sec CNT10    ;
  70:  LBL[1081] ;
  71:   ;
  72:J P[1080] 10% CNT10    ;
  73:J P[1081] 20% CNT100    ;
  74:  JMP LBL[1100] ;
  75:   ;
  76:  LBL[1090:POSITIONEREN] ;
  77:   ;
  78:  LBL[1091] ;
  79:L P[1091] 200mm/sec CNT20    ;
  80:L P[1092] 400mm/sec CNT100    ;
  81:J P[1093] 25% CNT100    ;
  82:J P[1094] 25% CNT100    ;
  83:  JMP LBL[1100] ;
  84:   ;
  85:  LBL[1100] ;
  86:  UFRAME_NUM=1 ;
  87:  UTOOL_NUM=1 ;
  88:J P[1:rust positie] 30% CNT100    ;
  89:   ;
/POS
P[1:"rust positie"]{
   GP1:
	UF : 0, UT : 1,	
	J1=     -.130 deg,	J2=   -46.859 deg,	J3=      .122 deg,
	J4=     -.000 deg,	J5=   -90.022 deg,	J6=   -90.000 deg
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
	X = -1165.601  mm,	Y = -1049.002  mm,	Z =   136.111  mm,
	W =   108.626 deg,	P =    -1.588 deg,	R =   -90.453 deg
};
P[1092]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  -911.866  mm,	Y = -1048.639  mm,	Z =   221.594  mm,
	W =   108.626 deg,	P =    -1.588 deg,	R =   -90.453 deg
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
