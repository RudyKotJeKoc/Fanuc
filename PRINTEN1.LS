/PROG  PRINTEN1
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "1PA008 -PLATE A";
PROG_SIZE	= 3186;
CREATE		= DATE 16-04-15  TIME 13:41:32;
MODIFIED	= DATE 17-12-02  TIME 13:49:22;
FILE_NAME	= PRINTEN;
VERSION		= 0;
LINE_COUNT	= 114;
MEMORY_SIZE	= 3626;
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
   1:  LBL[1] ;
   2:  OVERRIDE=100% ;
   3:J P[10] 80% CNT100    ;
   4:   ;
   5:  IF DI[42:Printer alarm]=OFF,JMP LBL[5] ;
   6:  CALL TEKST(820) ;
   7:  WAIT DI[42:Printer alarm]=OFF    ;
   8:  CALL TEKST(3) ;
   9:   ;
  10:  LBL[5] ;
  11:  UFRAME_NUM=2 ;
  12:   ;
  13:  !CHECK HOOGTE X Y Z ;
  14:  R[120:Z-PR[88]]=PR[88,3:Offs print 1A]    ;
  15:  R[122:X-PR[88]]=PR[88,1:Offs print 1A]    ;
  16:  R[124:Y-PR[88]]=PR[88,2:Offs print 1A]    ;
  17:   ;
  18:  IF R[120:Z-PR[88]]=0 AND R[122:X-PR[88]]>(-5) AND R[122:X-PR[88]]<5 AND R[124:Y-PR[88]]>(-5) AND R[124:Y-PR[88]]<5,JMP LBL[10] ;
  19:   ;
  20:  CALL TEKST(810) ;
  21:L P[810] 200mm/sec FINE    ;
  22:J P[101:rust pos] 30% FINE    ;
  23:  ABORT ;
  24:   ;
  25:   ;
  26:  LBL[10] ;
  27:  !Vrygave naar printer. ;
  28:  DO[15:Vrijgave printer]=PULSE,1.0sec ;
  29:   ;
  30:  !Controle hoogte ;
  31:L PR[47:Controle H1 P1 A] 800mm/sec FINE    ;
  32:  IF DI[77:Controle inlooph]=ON,JMP LBL[500] ;
  33:   ;
  34:L PR[48:Controle H2 P1 A] 800mm/sec FINE    ;
  35:   ;
  36:  IF DI[77:Controle inlooph]=ON,JMP LBL[500] ;
  37:   ;
  38:L PR[49:Voor print P1 A] 500mm/sec FINE Offset,PR[88:Offs print 1A]    ;
  39:   ;
  40:L PR[50:Voor LED P1 A] R[71:Snelheid print]mm/sec FINE Offset,PR[88:Offs print 1A]    ;
  41:L PR[51:Na print P1 A] R[72:Snelheid LED]mm/sec FINE Offset,PR[88:Offs print 1A]    ;
  42:   ;
  43:  !DRAAIEN 180 ;
  44:L P[7] 2000mm/sec CNT20    ;
  45:L P[21] 1500mm/sec CNT100    ;
  46:L P[22] 1500mm/sec CNT50    ;
  47:L P[8] 2000mm/sec CNT20    ;
  48:   ;
  49:  !Check printer alarm ;
  50:  IF DI[42:Printer alarm]=OFF,JMP LBL[29] ;
  51:  CALL TEKST(820) ;
  52:  WAIT DI[42:Printer alarm]=OFF    ;
  53:  CALL TEKST(3) ;
  54:   ;
  55:  LBL[29:Check hoogte reg] ;
  56:  R[121:Z-PR[89] ]=PR[89,3:Offs print 2A]    ;
  57:  R[123:X-PR[89]]=PR[89,1:Offs print 2A]    ;
  58:  R[125:Y-PR[89]]=PR[89,2:Offs print 2A]    ;
  59:   ;
  60:  IF R[121:Z-PR[89] ]=0 AND R[123:X-PR[89]]>(-5) AND R[123:X-PR[89]]<5 AND R[125:Y-PR[89]]>(-5) AND R[125:Y-PR[89]]<5,JMP LBL[30] ;
  61:   ;
  62:   ;
  63:  CALL TEKST(810) ;
  64:L P[811] 200mm/sec FINE    ;
  65:J P[101:rust pos] 30% FINE    ;
  66:  ABORT ;
  67:   ;
  68:   ;
  69:  LBL[30] ;
  70:  !Vrygave naar printer. ;
  71:  DO[15:Vrijgave printer]=PULSE,1.0sec ;
  72:   ;
  73:  !Controle hoogte ;
  74:L PR[52:Controle H1 P2 A] 800mm/sec FINE    ;
  75:  IF DI[77:Controle inlooph]=ON,JMP LBL[501] ;
  76:   ;
  77:L PR[53:Controle H2 P2 A] 800mm/sec FINE    ;
  78:  IF DI[77:Controle inlooph]=ON,JMP LBL[501] ;
  79:   ;
  80:L PR[54:Voor print P2 A] 500mm/sec FINE Offset,PR[89:Offs print 2A]    ;
  81:   ;
  82:L PR[55:Voor LED P2 A] R[71:Snelheid print]mm/sec FINE Offset,PR[89:Offs print 2A]    ;
  83:   ;
  84:L PR[56:Na print P2 A] R[72:Snelheid LED]mm/sec FINE Offset,PR[89:Offs print 2A]    ;
  85:   ;
  86:J P[1] 80% CNT100    ;
  87:J P[9] 100% CNT100    ;
  88:  UFRAME_NUM=1 ;
  89:  END ;
  90:   ;
  91:   ;
  92:  LBL[100:naar afleg] ;
  93:L P[100] 1000mm/sec CNT60    ;
  94:  UFRAME_NUM=1 ;
  95:  END ;
  96:   ;
  97:   ;
  98:  LBL[500:hoogte product 1] ;
  99:L P[2] 100mm/sec FINE    ;
 100:L P[3] 100mm/sec CNT100    ;
 101:J P[6] 30% CNT50    ;
 102:   ;
 103:  R[38:Hoogte fout]=1    ;
 104:  UFRAME_NUM=1 ;
 105:  END ;
 106:   ;
 107:  LBL[501:hoogte product 2] ;
 108:L P[4] 100mm/sec FINE    ;
 109:L P[5] 100mm/sec FINE    ;
 110:J P[6] 30% CNT50    ;
 111:   ;
 112:  R[38:Hoogte fout]=1    ;
 113:  UFRAME_NUM=1 ;
 114:  END ;
/POS
P[1]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =   814.992  mm,	Y = -1008.811  mm,	Z =   411.356  mm,
	W =   -89.916 deg,	P =      .605 deg,	R =   179.764 deg
};
P[2]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =  -209.499  mm,	Y = -1121.501  mm,	Z =   233.856  mm,
	W =    90.083 deg,	P =     -.587 deg,	R =     -.810 deg
};
P[3]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =  -146.128  mm,	Y =  -621.463  mm,	Z =   312.365  mm,
	W =    90.083 deg,	P =     -.587 deg,	R =     -.810 deg
};
P[4]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =  -163.615  mm,	Y = -1122.454  mm,	Z =   214.448  mm,
	W =   -89.916 deg,	P =      .605 deg,	R =   179.940 deg
};
P[5]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =  -159.030  mm,	Y =  -653.321  mm,	Z =   214.448  mm,
	W =   -89.915 deg,	P =      .605 deg,	R =   179.940 deg
};
P[6]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   725.468  mm,	Y =    -8.019  mm,	Z =   708.964  mm,
	W =  -101.697 deg,	P =   -43.907 deg,	R =   -81.967 deg
};
P[7]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =   765.000  mm,	Y =  -735.000  mm,	Z =   380.000  mm,
	W =    89.575 deg,	P =     -.480 deg,	R =     -.250 deg
};
P[8]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =  -363.715  mm,	Y = -1119.934  mm,	Z =   362.926  mm,
	W =   -89.680 deg,	P =      .435 deg,	R =   179.765 deg
};
P[9]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =   814.992  mm,	Y =  -781.003  mm,	Z =   480.572  mm,
	W =   -89.916 deg,	P =      .605 deg,	R =   179.764 deg
};
P[10]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =  -332.903  mm,	Y = -1123.000  mm,	Z =   348.461  mm,
	W =    89.575 deg,	P =     -.480 deg,	R =     -.250 deg
};
P[21]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =   200.000  mm,	Y =  -735.000  mm,	Z =   380.000  mm,
	W =  -107.251 deg,	P =   -88.910 deg,	R =  -163.226 deg
};
P[22]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =  -300.000  mm,	Y =  -735.000  mm,	Z =   380.000  mm,
	W =   -89.915 deg,	P =      .810 deg,	R =   179.765 deg
};
P[100]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =   814.992  mm,	Y = -1008.811  mm,	Z =   411.356  mm,
	W =    90.081 deg,	P =     -.101 deg,	R =     -.883 deg
};
P[101:"rust pos"]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   426.452  mm,	Y =     -.967  mm,	Z =   423.772  mm,
	W =  -179.900 deg,	P =      .000 deg,	R =   -90.130 deg
};
P[810]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =   -14.236  mm,	Y =  -786.318  mm,	Z =   300.000  mm,
	W =    90.084 deg,	P =     -.586 deg,	R =     -.884 deg
};
P[811]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =  -332.283  mm,	Y =  -806.969  mm,	Z =   404.045  mm,
	W =    90.084 deg,	P =     -.745 deg,	R =     -.884 deg
};
/END
