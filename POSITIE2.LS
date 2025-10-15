/PROG  POSITIE2
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "2voudig  deksel";
PROG_SIZE	= 1406;
CREATE		= DATE 16-01-13  TIME 08:10:04;
MODIFIED	= DATE 16-01-13  TIME 08:13:04;
FILE_NAME	= POSITIE4;
VERSION		= 0;
LINE_COUNT	= 41;
MEMORY_SIZE	= 1874;
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
   1:  !NA OMBOUW LIJN2 ;
   2:  !2_VOUDIGE DEKSEL ;
   3:   ;
   4:  UFRAME_NUM=1 ;
   5:  UTOOL_NUM=1 ;
   6:   ;
   7:  !Naar centreerpositie ;
   8:   ;
   9:  IF DI[23:Positioneer vrij]=ON,JMP LBL[510] ;
  10:   ;
  11:J P[10] 90% CNT100    ;
  12:J P[20:centreer pos] 60% CNT30 Tool_Offset,PR[23:Bvn centreren]    ;
  13:L P[20:centreer pos] 500mm/sec CNT10    ;
  14:  Open hand 1    ;
  15:  Open hand 2    ;
  16:  WAIT    .40(sec) ;
  17:L P[30:pak pos] 100mm/sec FINE    ;
  18:  WAIT    .30(sec) ;
  19:  Close hand 1    ;
  20:  Close hand 2    ;
  21:  WAIT    .30(sec) ;
  22:L P[30:pak pos] 600mm/sec CNT50 Offset,PR[24:Bvn centreren1]    ;
  23:J P[40] 80% CNT100    ;
  24:   ;
  25:  LBL[40:GRIJP CONTROLE] ;
  26:  IF RI[1:Bek B Open]=OFF AND RI[2:Bek B product aanwezig]=ON AND RI[3:Bek A Open]=OFF AND RI[4:Bek A product aanwezig]=ON,JMP LBL[50] ;
  27:  IF R[100:Product controle]>1,JMP LBL[500] ;
  28:  WAIT    .01(sec) ;
  29:  R[100:Product controle]=R[100:Product controle]+.01    ;
  30:  JMP LBL[40] ;
  31:   ;
  32:  LBL[50:UITNAME OK ] ;
  33:  R[100:Product controle]=0    ;
  34:  END ;
  35:   ;
  36:  LBL[500:GRIJPFOUT] ;
  37:  R[40:Grijpfout centre]=1    ;
  38:  END ;
  39:   ;
  40:  LBL[510:Centrer niet vry] ;
  41:  R[47:Centrer niet vri]=1    ;
/POS
P[10]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   673.130  mm,	Y =  -347.006  mm,	Z =   257.882  mm,
	W =  -179.445 deg,	P =   -37.976 deg,	R =   -89.319 deg
};
P[20:"centreer pos"]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   648.174  mm,	Y =  -632.686  mm,	Z =   -96.424  mm,
	W =  -177.661 deg,	P =   -44.325 deg,	R =   -90.853 deg
};
P[30:"pak pos"]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   648.428  mm,	Y =  -624.150  mm,	Z =  -109.003  mm,
	W =  -177.660 deg,	P =   -44.324 deg,	R =   -90.853 deg
};
P[40]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   659.838  mm,	Y =  -210.897  mm,	Z =   491.349  mm,
	W =  -179.956 deg,	P =      .650 deg,	R =   -92.411 deg
};
/END
