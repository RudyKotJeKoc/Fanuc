/PROG  PRINTEN2
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "Grijper paars";
PROG_SIZE	= 4016;
CREATE		= DATE 19-04-01  TIME 22:41:22;
MODIFIED	= DATE 19-04-23  TIME 23:10:38;
FILE_NAME	= PRINTEN;
VERSION		= 0;
LINE_COUNT	= 123;
MEMORY_SIZE	= 4420;
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
   3:  UFRAME_NUM=2 ;
   4:J P[10:Naar hoogtesenso] 85% CNT100    ;
   5:   ;
   6:  IF DI[42:Printer alarm]=OFF,JMP LBL[5] ;
   7:   ;
   8:L P[810:Weg van printer] 500mm/sec CNT25    ;
   9:  CALL TEKST(820) ;
  10:  WAIT DI[42:Printer alarm]=OFF    ;
  11:  CALL TEKST(3) ;
  12:J P[10:Naar hoogtesenso] 25% CNT100    ;
  13:   ;
  14:  LBL[5] ;
  15:  UFRAME_NUM=2 ;
  16:   ;
  17:  !CHECK HOOGTE X Y Z ;
  18:  R[103:Z-PR[38]]=PR[38,3:Offset print 1]    ;
  19:  R[105:X-PR[38]]=PR[38,1:Offset print 1]    ;
  20:  R[107:Y-PR[38]]=PR[38,2:Offset print 1]    ;
  21:   ;
  22:  IF R[103:Z-PR[38]]=0 AND R[105:X-PR[38]]>(-5) AND R[105:X-PR[38]]<5 AND R[107:Y-PR[38]]>(-5) AND R[107:Y-PR[38]]<5,JMP LBL[10] ;
  23:   ;
  24:  CALL TEKST(810) ;
  25:L P[810:Weg van printer] 200mm/sec FINE    ;
  26:J P[101:rust pos] 30% FINE    ;
  27:  ABORT ;
  28:   ;
  29:  LBL[10] ;
  30:  !Vrygave naar printer. ;
  31:  DO[15:Vrijgave printer]=PULSE,1.0sec ;
  32:   ;
  33:  !Wacht ivm ionisatie ;
  34:  WAIT    .80(sec) ;
  35:   ;
  36:  !Controle hoogte ;
  37:L P[90:Print 1 hoogte 1] 800mm/sec FINE Offset,PR[38:Offset print 1]    ;
  38:  IF DI[77:Controle inlooph]=ON,JMP LBL[500] ;
  39:   ;
  40:  !Wacht ivm ionisatie ;
  41:  WAIT    .80(sec) ;
  42:   ;
  43:L P[91:Print 1 hoogte 2] 800mm/sec FINE Offset,PR[38:Offset print 1]    ;
  44:   ;
  45:  IF DI[77:Controle inlooph]=ON,JMP LBL[500] ;
  46:   ;
  47:L P[40:Pos voor print 1] 500mm/sec CNT25 Offset,PR[38:Offset print 1]    ;
  48:   ;
  49:L P[41:Pos na print 1] R[72:Snelheid LED]mm/sec FINE Offset,PR[38:Offset print 1]    ;
  50:   ;
  51:L P[20:Naar beneden] 1250mm/sec CNT50    ;
  52:L P[21:Draaien] 1500mm/sec CNT100    ;
  53:L P[23:Voor P22] 1500mm/sec CNT100    ;
  54:L P[22:Naar  2e bedruk] 1500mm/sec CNT75    ;
  55:   ;
  56:  !2e drukcyclus ;
  57:  LBL[20] ;
  58:  OVERRIDE=100% ;
  59:  UFRAME_NUM=2 ;
  60:   ;
  61:  !Check printer alarm ;
  62:  IF DI[42:Printer alarm]=OFF,JMP LBL[29] ;
  63:   ;
  64:L P[811:Veilig terug] 500mm/sec FINE    ;
  65:  CALL TEKST(820) ;
  66:  WAIT DI[42:Printer alarm]=OFF    ;
  67:  CALL TEKST(3) ;
  68:L P[22:Naar  2e bedruk] 500mm/sec CNT50    ;
  69:   ;
  70:  LBL[29:Check hoogte reg] ;
  71:  R[104:Z-PR[39]]=PR[39,3:Offset print 2]    ;
  72:  R[106:X-PR[39]]=PR[39,1:Offset print 2]    ;
  73:  R[108:Y-PR[39]]=PR[39,2:Offset print 2]    ;
  74:   ;
  75:  IF R[104:Z-PR[39]]=0 AND R[106:X-PR[39]]>(-5) AND R[106:X-PR[39]]<5 AND R[108:Y-PR[39]]>(-5) AND R[108:Y-PR[39]]<5,JMP LBL[30] ;
  76:   ;
  77:  CALL TEKST(810) ;
  78:L P[811:Veilig terug] 200mm/sec FINE    ;
  79:J P[101:rust pos] 30% FINE    ;
  80:  ABORT ;
  81:   ;
  82:   ;
  83:  LBL[30] ;
  84:  !Vrygave naar printer. ;
  85:  DO[15:Vrijgave printer]=PULSE,1.0sec ;
  86:   ;
  87:   ;
  88:  !Controle hoogte ;
  89:L P[92:Prnt 2  hoogte 1] 800mm/sec FINE Offset,PR[39:Offset print 2]    ;
  90:  IF DI[77:Controle inlooph]=ON,JMP LBL[501] ;
  91:   ;
  92:  !Wacht ivm ionisatie ;
  93:  WAIT    .80(sec) ;
  94:   ;
  95:L P[93:Prnt 2  hoogte 2] 800mm/sec FINE Offset,PR[39:Offset print 2]    ;
  96:  IF DI[77:Controle inlooph]=ON,JMP LBL[501] ;
  97:   ;
  98:L P[42:Voor print 2] 500mm/sec CNT25 Offset,PR[39:Offset print 2]    ;
  99:   ;
 100:L P[43:Na print 2] R[72:Snelheid LED]mm/sec FINE Offset,PR[39:Offset print 2]    ;
 101:   ;
 102:J P[1:Na print 2 ] 75% CNT100    ;
 103:  UFRAME_NUM=1 ;
 104:  END ;
 105:   ;
 106:  LBL[500:hoogte product] ;
 107:L P[2:Naar beneden] 100mm/sec FINE    ;
 108:L P[810:Weg van printer] 250mm/sec CNT100    ;
 109:J P[101:rust pos] 30% CNT50    ;
 110:   ;
 111:  R[38:Hoogte fout]=1    ;
 112:  UFRAME_NUM=1 ;
 113:  END ;
 114:   ;
 115:  LBL[501:hoogte product] ;
 116:L P[4:Omlaag printer] 100mm/sec FINE    ;
 117:L P[5] 100mm/sec FINE    ;
 118:J P[101:rust pos] 30% CNT50    ;
 119:   ;
 120:  R[38:Hoogte fout]=1    ;
 121:  UFRAME_NUM=1 ;
 122:  END ;
 123:   ;
/POS
P[1:"Na print 2 "]{
   GP1:
	UF : 2, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =   750.001  mm,	Y =  -878.055  mm,	Z =   355.000  mm,
	W =   -89.916 deg,	P =      .990 deg,	R =   179.200 deg
};
P[2:"Naar beneden"]{
   GP1:
	UF : 2, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =  -129.999  mm,	Y = -1152.005  mm,	Z =   315.000  mm,
	W =    90.086 deg,	P =     -.711 deg,	R =     -.248 deg
};
P[4:"Omlaag printer"]{
   GP1:
	UF : 2, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =  -143.925  mm,	Y = -1135.104  mm,	Z =   315.000  mm,
	W =   -89.915 deg,	P =      .740 deg,	R =   179.457 deg
};
P[5]{
   GP1:
	UF : 2, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =  -143.926  mm,	Y =  -519.504  mm,	Z =   289.357  mm,
	W =   -89.915 deg,	P =      .740 deg,	R =   179.457 deg
};
P[10:"Naar hoogtesenso"]{
   GP1:
	UF : 2, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =  -285.000  mm,	Y = -1151.996  mm,	Z =   380.000  mm,
	W =    90.086 deg,	P =     -.867 deg,	R =    -1.900 deg
};
P[20:"Naar beneden"]{
   GP1:
	UF : 2, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =   749.953  mm,	Y =  -920.000  mm,	Z =   355.000  mm,
	W =    90.088 deg,	P =     -.867 deg,	R =    -1.900 deg
};
P[21:"Draaien"]{
   GP1:
	UF : 2, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =   439.872  mm,	Y =  -920.000  mm,	Z =   355.000  mm,
	W =    90.328 deg,	P =   -44.068 deg,	R =     -.349 deg
};
P[22:"Naar  2e bedruk"]{
   GP1:
	UF : 2, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =  -310.001  mm,	Y = -1152.000  mm,	Z =   355.000  mm,
	W =   -89.918 deg,	P =      .990 deg,	R =   179.200 deg
};
P[23:"Voor P22"]{
   GP1:
	UF : 2, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =  -310.000  mm,	Y =  -920.000  mm,	Z =   355.000  mm,
	W =   -89.918 deg,	P =     1.000 deg,	R =  -179.752 deg
};
P[40:"Pos voor print 1"]{
   GP1:
	UF : 2, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =  -115.000  mm,	Y = -1155.000  mm,	Z =   390.500  mm,
	W =    90.086 deg,	P =     -.867 deg,	R =    -1.900 deg
};
P[41:"Pos na print 1"]{
   GP1:
	UF : 2, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =   750.000  mm,	Y = -1155.000  mm,	Z =   388.500  mm,
	W =    90.086 deg,	P =    -1.000 deg,	R =     -.248 deg
};
P[42:"Voor print 2"]{
   GP1:
	UF : 2, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =  -115.000  mm,	Y = -1155.000  mm,	Z =   389.500  mm,
	W =   -89.916 deg,	P =      .990 deg,	R =   179.200 deg
};
P[43:"Na print 2"]{
   GP1:
	UF : 2, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =   750.000  mm,	Y = -1155.000  mm,	Z =   387.800  mm,
	W =   -89.916 deg,	P =      .990 deg,	R =   179.200 deg
};
P[90:"Print 1 hoogte 1"]{
   GP1:
	UF : 2, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =  -230.000  mm,	Y = -1148.800  mm,	Z =   390.000  mm,
	W =    90.086 deg,	P =     -.867 deg,	R =    -1.900 deg
};
P[91:"Print 1 hoogte 2"]{
   GP1:
	UF : 2, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =  -130.000  mm,	Y = -1148.800  mm,	Z =   390.000  mm,
	W =    90.086 deg,	P =     -.867 deg,	R =    -1.900 deg
};
P[92:"Prnt 2  hoogte 1"]{
   GP1:
	UF : 2, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =  -235.000  mm,	Y = -1149.500  mm,	Z =   389.500  mm,
	W =   -89.916 deg,	P =      .990 deg,	R =   179.200 deg
};
P[93:"Prnt 2  hoogte 2"]{
   GP1:
	UF : 2, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =  -135.000  mm,	Y = -1149.500  mm,	Z =   389.500  mm,
	W =   -89.916 deg,	P =      .990 deg,	R =   179.200 deg
};
P[101:"rust pos"]{
   GP1:
	UF : 2, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   486.893  mm,	Y =   -10.486  mm,	Z =   354.765  mm,
	W =   179.900 deg,	P =     -.002 deg,	R =   -91.200 deg
};
P[810:"Weg van printer"]{
   GP1:
	UF : 2, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =  -360.952  mm,	Y =  -408.955  mm,	Z =   390.000  mm,
	W =    90.086 deg,	P =     -.711 deg,	R =     -.247 deg
};
P[811:"Veilig terug"]{
   GP1:
	UF : 2, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =  -300.000  mm,	Y =  -482.423  mm,	Z =   320.000  mm,
	W =   -89.915 deg,	P =      .081 deg,	R =  -179.749 deg
};
/END
