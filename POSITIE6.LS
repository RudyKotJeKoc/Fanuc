/PROG  POSITIE6
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "Centrern Ontstpl";
PROG_SIZE	= 1852;
CREATE		= DATE 19-02-28  TIME 19:03:32;
MODIFIED	= DATE 19-02-28  TIME 23:01:16;
FILE_NAME	= POSITIE5;
VERSION		= 0;
LINE_COUNT	= 55;
MEMORY_SIZE	= 2264;
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
   2:  UTOOL_NUM=1 ;
   3:  R[40:Grijpfout centre]=0    ;
   4:  R[47:Centrer niet vri]=0    ;
   5:   ;
   6:  !Naar centreerpositie ;
   7:   ;
   8:  IF DI[70:Herpositie 2 FC]=ON,JMP LBL[510] ;
   9:J P[11:Voor centreer] 80% CNT100    ;
  10:   ;
  11:J P[20:Lospositie] 80% CNT30 Tool_Offset,PR[17:Bvn centrn 3 N]    ;
  12:L P[20:Lospositie] 300mm/sec CNT30 Tool_Offset,PR[18:Bvn centrn 2 N]    ;
  13:L P[20:Lospositie] 500mm/sec CNT20 Tool_Offset,PR[19:Bvn centrn 1 N]    ;
  14:L P[20:Lospositie] 600mm/sec FINE    ;
  15:  WAIT    .20(sec) ;
  16:  Open hand 1    ;
  17:  Open hand 2    ;
  18:  WAIT    .80(sec) ;
  19:L P[30:pak pos] 50mm/sec FINE    ;
  20:   ;
  21:  WAIT    .25(sec) ;
  22:  Close hand 2    ;
  23:  WAIT    .30(sec) ;
  24:   ;
  25:  LBL[30:Na pak] ;
  26:L P[30:pak pos] 200mm/sec CNT20 Tool_Offset,PR[19:Bvn centrn 1 N]    ;
  27:L P[30:pak pos] 500mm/sec CNT20 Tool_Offset,PR[18:Bvn centrn 2 N]    ;
  28:L P[30:pak pos] 500mm/sec CNT20 Tool_Offset,PR[17:Bvn centrn 3 N]    ;
  29:  !Kabel over steun keerunit ;
  30:L P[39] 850mm/sec CNT100    ;
  31:J P[40:Na centreer] 100% CNT100    ;
  32:J P[50:Naar printer] 100% CNT100    ;
  33:   ;
  34:  LBL[40:GRIJP CONTROLE] ;
  35:  IF RI[1:Bek B Open]=OFF AND RI[2:Bek B product aanwezig]=ON,JMP LBL[50] ;
  36:  IF R[100:Product controle]>1,JMP LBL[500] ;
  37:  WAIT    .01(sec) ;
  38:  R[100:Product controle]=R[100:Product controle]+.01    ;
  39:  JMP LBL[40] ;
  40:   ;
  41:  LBL[50:UITNAME OK ] ;
  42:  R[100:Product controle]=0    ;
  43:  END ;
  44:   ;
  45:  LBL[500:GRIJPFOUT] ;
  46:  R[40:Grijpfout centre]=1    ;
  47:J P[2:Naar rust] 30% CNT50    ;
  48:J P[1:Rust pos] 40% CNT50    ;
  49:  END ;
  50:   ;
  51:  LBL[510:Centrer niet vry] ;
  52:  R[47:Centrer niet vri]=1    ;
  53:J P[2:Naar rust] 30% CNT50    ;
  54:J P[1:Rust pos] 40% CNT50    ;
  55:  END ;
/POS
P[1:"Rust pos"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   451.199  mm,	Y =      .007  mm,	Z =   354.129  mm,
	W =   179.901 deg,	P =      .000 deg,	R =   -90.099 deg
};
P[2:"Naar rust"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =  -470.233  mm,	Y =  -560.852  mm,	Z =   347.110  mm,
	W =    88.716 deg,	P =    -1.964 deg,	R =      .752 deg
};
P[11:"Voor centreer"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  -975.398  mm,	Y = -1042.891  mm,	Z =   247.919  mm,
	W =   111.207 deg,	P =    -3.482 deg,	R =   -90.453 deg
};
P[20:"Lospositie"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X = -1160.662  mm,	Y = -1049.473  mm,	Z =   120.510  mm,
	W =   108.626 deg,	P =    -1.588 deg,	R =   -90.453 deg
};
P[30:"pak pos"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X = -1160.227  mm,	Y = -1049.489  mm,	Z =   120.092  mm,
	W =   108.626 deg,	P =    -1.588 deg,	R =   -90.454 deg
};
P[39]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X = -1053.031  mm,	Y = -1045.139  mm,	Z =   307.680  mm,
	W =   108.626 deg,	P =    -1.588 deg,	R =   -90.453 deg
};
P[40:"Na centreer"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  -951.168  mm,	Y = -1047.875  mm,	Z =   237.989  mm,
	W =   108.626 deg,	P =    -1.588 deg,	R =   -90.454 deg
};
P[50:"Naar printer"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =  -470.188  mm,	Y = -1090.391  mm,	Z =   347.121  mm,
	W =    88.715 deg,	P =    -1.964 deg,	R =      .755 deg
};
/END
