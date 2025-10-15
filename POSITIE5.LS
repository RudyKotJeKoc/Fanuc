/PROG  POSITIE5
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "Centreren Nieuw";
PROG_SIZE	= 2057;
CREATE		= DATE 15-11-23  TIME 09:51:26;
MODIFIED	= DATE 19-01-23  TIME 18:58:40;
FILE_NAME	= POSITIE;
VERSION		= 0;
LINE_COUNT	= 63;
MEMORY_SIZE	= 2437;
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
   9:   ;
  10:J P[10:Naar centreer] 80% CNT100    ;
  11:J P[11:Voor centreer] 80% CNT100    ;
  12:   ;
  13:J P[20:Lospositie] 80% CNT30 Tool_Offset,PR[17:Bvn centrn 3 N]    ;
  14:L P[20:Lospositie] 300mm/sec CNT30 Tool_Offset,PR[18:Bvn centrn 2 N]    ;
  15:L P[20:Lospositie] 500mm/sec CNT20 Tool_Offset,PR[19:Bvn centrn 1 N]    ;
  16:L P[20:Lospositie] 600mm/sec CNT10    ;
  17:  Open hand 1    ;
  18:  Open hand 2    ;
  19:  WAIT    .90(sec) ;
  20:L P[30:pak pos] 50mm/sec FINE    ;
  21:   ;
  22:  WAIT    .10(sec) ;
  23:  Close hand 1    ;
  24:  Close hand 2    ;
  25:  WAIT    .30(sec) ;
  26:   ;
  27:  LBL[30:Na pak] ;
  28:L P[30:pak pos] 200mm/sec CNT20 Tool_Offset,PR[19:Bvn centrn 1 N]    ;
  29:L P[30:pak pos] 500mm/sec CNT20 Tool_Offset,PR[18:Bvn centrn 2 N]    ;
  30:L P[30:pak pos] 500mm/sec CNT20 Tool_Offset,PR[17:Bvn centrn 3 N]    ;
  31:L P[39] 850mm/sec CNT100    ;
  32:J P[40:Na centreer] 100% CNT100    ;
  33:J P[50:Naar printer] 100% CNT100    ;
  34:   ;
  35:  IF R[21:Grijper 1-voudig]=1,JMP LBL[45] ;
  36:   ;
  37:  LBL[40:GRIJP CONTROLE] ;
  38:  IF RI[1:Bek B Open]=OFF AND RI[2:Bek B product aanwezig]=ON AND RI[3:Bek A Open]=OFF AND RI[4:Bek A product aanwezig]=ON,JMP LBL[50] ;
  39:  IF R[100:Product controle]>1,JMP LBL[500] ;
  40:  WAIT    .01(sec) ;
  41:  R[100:Product controle]=R[100:Product controle]+.01    ;
  42:  JMP LBL[40] ;
  43:   ;
  44:  LBL[45:GRIJP CONTROLE] ;
  45:  IF RI[1:Bek B Open]=OFF AND RI[2:Bek B product aanwezig]=OFF AND RI[3:Bek A Open]=OFF AND RI[4:Bek A product aanwezig]=ON,JMP LBL[50] ;
  46:  IF R[100:Product controle]>1,JMP LBL[500] ;
  47:  WAIT    .01(sec) ;
  48:  R[100:Product controle]=R[100:Product controle]+.01    ;
  49:  JMP LBL[45] ;
  50:   ;
  51:  LBL[50:UITNAME OK ] ;
  52:  R[100:Product controle]=0    ;
  53:  END ;
  54:   ;
  55:  LBL[500:GRIJPFOUT] ;
  56:  R[40:Grijpfout centre]=1    ;
  57:J P[2:Naar rust] 30% CNT50    ;
  58:J P[1:Rust pos] 40% CNT50    ;
  59:  END ;
  60:   ;
  61:  LBL[510:Centrer niet vry] ;
  62:  R[47:Centrer niet vri]=1    ;
  63:  END ;
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
P[10:"Naar centreer"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  -205.807  mm,	Y =  -635.431  mm,	Z =   440.720  mm,
	W =  -179.885 deg,	P =    -9.987 deg,	R =   -90.080 deg
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
	X = -1163.878  mm,	Y = -1049.419  mm,	Z =   121.535  mm,
	W =   108.626 deg,	P =    -1.588 deg,	R =   -90.454 deg
};
P[30:"pak pos"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X = -1163.070  mm,	Y = -1049.493  mm,	Z =   119.134  mm,
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
