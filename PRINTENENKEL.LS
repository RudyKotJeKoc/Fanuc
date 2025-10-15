/PROG  PRINTENENKEL
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "Grijper rood";
PROG_SIZE	= 4268;
CREATE		= DATE 19-06-03  TIME 16:39:00;
MODIFIED	= DATE 19-06-03  TIME 16:39:00;
FILE_NAME	= PRINTEN;
VERSION		= 0;
LINE_COUNT	= 140;
MEMORY_SIZE	= 4732;
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
   1:  IF R[21:Grijper 1-voudig]=1,JMP LBL[600] ;
   2:   ;
   3:  LBL[1] ;
   4:  OVERRIDE=100% ;
   5:  UFRAME_NUM=2 ;
   6:J P[10:Naar hoogtesenso] 50% CNT100    ;
   7:   ;
   8:  IF DI[42:Printer alarm]=OFF,JMP LBL[5] ;
   9:   ;
  10:L P[810:Weg van printer] 500mm/sec CNT25    ;
  11:  CALL TEKST(820) ;
  12:  WAIT DI[42:Printer alarm]=OFF    ;
  13:  CALL TEKST(3) ;
  14:J P[10:Naar hoogtesenso] 25% CNT100    ;
  15:   ;
  16:  LBL[5] ;
  17:  UFRAME_NUM=2 ;
  18:   ;
  19:  !CHECK HOOGTE X Y Z ;
  20:  R[103:Z-PR[38]]=PR[38,3:Offset print 1]    ;
  21:  R[105:X-PR[38]]=PR[38,1:Offset print 1]    ;
  22:  R[107:Y-PR[38]]=PR[38,2:Offset print 1]    ;
  23:   ;
  24:  IF R[103:Z-PR[38]]=0 AND R[105:X-PR[38]]>(-5) AND R[105:X-PR[38]]<5 AND R[107:Y-PR[38]]>(-5) AND R[107:Y-PR[38]]<5,JMP LBL[10] ;
  25:   ;
  26:  CALL TEKST(810) ;
  27:J P[810:Weg van printer] 10% FINE    ;
  28:J P[101:rust pos] 30% FINE    ;
  29:  ABORT ;
  30:   ;
  31:   ;
  32:  LBL[10] ;
  33:  !Vrygave naar printer. ;
  34:  DO[15:Vrijgave printer]=PULSE,1.0sec ;
  35:   ;
  36:  !Wacht ivm ionisatie ;
  37:  WAIT   1.00(sec) ;
  38:   ;
  39:  !Controle hoogte ;
  40:L P[90:Print 1 hoogte 1] 800mm/sec FINE Offset,PR[38:Offset print 1]    ;
  41:  IF DI[77:Controle inlooph]=ON,JMP LBL[500] ;
  42:   ;
  43:  WAIT    .10(sec) ;
  44:L P[91:Print 1 hoogte 2] 800mm/sec FINE Offset,PR[38:Offset print 1]    ;
  45:   ;
  46:  IF DI[77:Controle inlooph]=ON,JMP LBL[500] ;
  47:   ;
  48:L P[40:Pos voor print 1] 500mm/sec CNT25 Offset,PR[38:Offset print 1]    ;
  49:   ;
  50:L P[41:Pos na print 1] R[72:Snelheid LED]mm/sec FINE Offset,PR[38:Offset print 1]    ;
  51:   ;
  52:  !Bij stapelprogramma naar afleg   ;
  53:   ;
  54:  IF RO[1:Bek A dicht]=OFF AND RO[2:Bek A open]=ON AND RI[3:Bek A Open]=ON AND RI[4:Bek A product aanwezig]=OFF,JMP LBL[100] ;
  55:   ;
  56:   ;
  57:L P[20:Naar beneden] 1000mm/sec CNT50    ;
  58:L P[21:Draaien] 1000mm/sec CNT100    ;
  59:L P[22:Naar  2e bedruk] 1000mm/sec CNT50    ;
  60:   ;
  61:  !2e drukcyclus ;
  62:  LBL[20] ;
  63:  OVERRIDE=100% ;
  64:  UFRAME_NUM=2 ;
  65:   ;
  66:  !Check printer alarm ;
  67:  IF DI[42:Printer alarm]=OFF,JMP LBL[29] ;
  68:   ;
  69:L P[811:Veilig terug] 500mm/sec FINE    ;
  70:  CALL TEKST(820) ;
  71:  WAIT DI[42:Printer alarm]=OFF    ;
  72:  CALL TEKST(3) ;
  73:L P[22:Naar  2e bedruk] 500mm/sec CNT50    ;
  74:   ;
  75:  LBL[29:Check hoogte reg] ;
  76:  R[104:Z-PR[39]]=PR[39,3:Offset print 2]    ;
  77:  R[106:X-PR[39]]=PR[39,1:Offset print 2]    ;
  78:  R[108:Y-PR[39]]=PR[39,2:Offset print 2]    ;
  79:   ;
  80:  IF R[104:Z-PR[39]]=0 AND R[106:X-PR[39]]>(-5) AND R[106:X-PR[39]]<5 AND R[108:Y-PR[39]]>(-5) AND R[108:Y-PR[39]]<5,JMP LBL[30] ;
  81:   ;
  82:  CALL TEKST(810) ;
  83:L P[811:Veilig terug] 200mm/sec FINE    ;
  84:J P[101:rust pos] 30% FINE    ;
  85:  ABORT ;
  86:   ;
  87:   ;
  88:  LBL[30] ;
  89:  !Vrygave naar printer. ;
  90:  DO[15:Vrijgave printer]=PULSE,1.0sec ;
  91:   ;
  92:  !Wacht ivm ionisatie ;
  93:  WAIT   1.00(sec) ;
  94:   ;
  95:  !Controle hoogte ;
  96:L P[92:Prnt 2  hoogte 1] 800mm/sec FINE Offset,PR[39:Offset print 2]    ;
  97:  IF DI[77:Controle inlooph]=ON,JMP LBL[501] ;
  98:   ;
  99:  WAIT    .10(sec) ;
 100:L P[93:Prnt 2  hoogte 2] 800mm/sec FINE Offset,PR[39:Offset print 2]    ;
 101:  IF DI[77:Controle inlooph]=ON,JMP LBL[501] ;
 102:   ;
 103:L P[42:Voor print 2] 500mm/sec CNT25 Offset,PR[39:Offset print 2]    ;
 104:   ;
 105:L P[43:Na print 2] R[72:Snelheid LED]mm/sec FINE Offset,PR[39:Offset print 2]    ;
 106:   ;
 107:J P[1:Na print 2 ] 75% CNT100    ;
 108:  UFRAME_NUM=1 ;
 109:  END ;
 110:   ;
 111:   ;
 112:  LBL[100:naar afleg] ;
 113:L P[100] 1000mm/sec CNT60    ;
 114:  UFRAME_NUM=1 ;
 115:  END ;
 116:   ;
 117:   ;
 118:  LBL[500:hoogte product] ;
 119:L P[2:Naar beneden] 100mm/sec FINE    ;
 120:L P[810:Weg van printer] 250mm/sec CNT100    ;
 121:J P[101:rust pos] 30% CNT50    ;
 122:   ;
 123:  R[38:Hoogte fout]=1    ;
 124:  UFRAME_NUM=1 ;
 125:  END ;
 126:   ;
 127:  LBL[501:hoogte product] ;
 128:L P[4:Omlaag printer] 100mm/sec FINE    ;
 129:L P[5] 100mm/sec FINE    ;
 130:J P[101:rust pos] 30% CNT50    ;
 131:   ;
 132:  R[38:Hoogte fout]=1    ;
 133:  UFRAME_NUM=1 ;
 134:  END ;
 135:   ;
 136:  LBL[600:181 draaien] ;
 137:  UFRAME_NUM=2 ;
 138:J P[22:Naar  2e bedruk] 20% CNT30    ;
 139:  JMP LBL[20] ;
 140:   ;
/POS
P[1:"Na print 2 "]{
   GP1:
	UF : 2, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =   750.001  mm,	Y =  -878.055  mm,	Z =   368.120  mm,
	W =   -89.916 deg,	P =     1.000 deg,	R =  -179.749 deg
};
P[2:"Naar beneden"]{
   GP1:
	UF : 2, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =  -129.999  mm,	Y = -1152.005  mm,	Z =   290.037  mm,
	W =    90.086 deg,	P =     -.711 deg,	R =     -.248 deg
};
P[4:"Omlaag printer"]{
   GP1:
	UF : 2, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =  -143.925  mm,	Y = -1135.104  mm,	Z =   289.357  mm,
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
	X =  -360.952  mm,	Y = -1151.996  mm,	Z =   400.676  mm,
	W =    90.086 deg,	P =     -.711 deg,	R =     -.247 deg
};
P[20:"Naar beneden"]{
   GP1:
	UF : 2, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =   749.953  mm,	Y = -1152.036  mm,	Z =   335.000  mm,
	W =    90.088 deg,	P =     -.710 deg,	R =     -.251 deg
};
P[21:"Draaien"]{
   GP1:
	UF : 2, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =   439.872  mm,	Y = -1152.032  mm,	Z =   335.000  mm,
	W =    90.328 deg,	P =   -44.068 deg,	R =     -.349 deg
};
P[22:"Naar  2e bedruk"]{
   GP1:
	UF : 2, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =  -237.565  mm,	Y = -1152.070  mm,	Z =   357.465  mm,
	W =   -89.918 deg,	P =     1.000 deg,	R =  -179.752 deg
};
P[40:"Pos voor print 1"]{
   GP1:
	UF : 2, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =  -115.000  mm,	Y = -1152.000  mm,	Z =   409.500  mm,
	W =    90.086 deg,	P =     -.711 deg,	R =     -.248 deg
};
P[41:"Pos na print 1"]{
   GP1:
	UF : 2, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =   750.000  mm,	Y = -1152.000  mm,	Z =   408.000  mm,
	W =    90.086 deg,	P =     -.711 deg,	R =     -.248 deg
};
P[42:"Voor print 2"]{
   GP1:
	UF : 2, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =  -115.000  mm,	Y = -1152.018  mm,	Z =   408.500  mm,
	W =   -89.916 deg,	P =     1.000 deg,	R =  -179.749 deg
};
P[43:"Na print 2"]{
   GP1:
	UF : 2, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =   750.000  mm,	Y = -1152.018  mm,	Z =   407.000  mm,
	W =   -89.916 deg,	P =     1.000 deg,	R =  -179.749 deg
};
P[90:"Print 1 hoogte 1"]{
   GP1:
	UF : 2, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =  -230.000  mm,	Y = -1152.000  mm,	Z =   409.500  mm,
	W =    90.086 deg,	P =     -.711 deg,	R =     -.248 deg
};
P[91:"Print 1 hoogte 2"]{
   GP1:
	UF : 2, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =  -130.000  mm,	Y = -1152.000  mm,	Z =   409.500  mm,
	W =    90.086 deg,	P =     -.711 deg,	R =     -.248 deg
};
P[92:"Prnt 2  hoogte 1"]{
   GP1:
	UF : 2, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =  -235.000  mm,	Y = -1152.017  mm,	Z =   407.800  mm,
	W =   -89.916 deg,	P =     1.000 deg,	R =  -179.749 deg
};
P[93:"Prnt 2  hoogte 2"]{
   GP1:
	UF : 2, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =  -135.000  mm,	Y = -1152.017  mm,	Z =   407.800  mm,
	W =   -89.916 deg,	P =     1.000 deg,	R =  -179.749 deg
};
P[100]{
   GP1:
	UF : 2, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =   795.477  mm,	Y =  -895.599  mm,	Z =   345.370  mm,
	W =    90.087 deg,	P =     -.710 deg,	R =     -.250 deg
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
	X =  -360.952  mm,	Y =  -408.955  mm,	Z =   409.500  mm,
	W =    90.086 deg,	P =     -.711 deg,	R =     -.247 deg
};
P[811:"Veilig terug"]{
   GP1:
	UF : 2, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =  -300.000  mm,	Y =  -482.423  mm,	Z =   335.000  mm,
	W =   -89.915 deg,	P =      .081 deg,	R =  -179.749 deg
};
/END
