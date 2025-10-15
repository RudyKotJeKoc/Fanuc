/PROG  POSITIE4
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "Enkelvoudig dksl";
PROG_SIZE	= 1416;
CREATE		= DATE 15-08-19  TIME 07:59:42;
MODIFIED	= DATE 19-05-17  TIME 16:45:06;
FILE_NAME	= POSITIE2;
VERSION		= 0;
LINE_COUNT	= 41;
MEMORY_SIZE	= 1884;
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
   1:  !2019-01-19 ;
   2:  !FANUC M20iA ;
   3:  !ENKELVOUDIGE DEKSEL ;
   4:   ;
   5:  UFRAME_NUM=1 ;
   6:  UTOOL_NUM=1 ;
   7:   ;
   8:  !Naar centreerpositie ;
   9:   ;
  10:  IF DI[23:Positioneer vrij]=ON,JMP LBL[510] ;
  11:J P[10:Naar centreer] 85% CNT80    ;
  12:J P[20:centreer pos] 60% CNT30 Tool_Offset,PR[23:Bvn centreren]    ;
  13:L P[20:centreer pos] 500mm/sec FINE    ;
  14:  WAIT    .10(sec) ;
  15:  Open hand 1    ;
  16:  Open hand 2    ;
  17:  WAIT    .40(sec) ;
  18:L P[30:pak pos] 100mm/sec FINE    ;
  19:  WAIT    .30(sec) ;
  20:  Close hand 2    ;
  21:  WAIT    .30(sec) ;
  22:L P[30:pak pos] 600mm/sec CNT50 Offset,PR[24:Bvn centreren1]    ;
  23:L P[40] 1600mm/sec CNT100    ;
  24:   ;
  25:  LBL[40:GRIJP CONTROLE] ;
  26:  IF RI[3:Bek A Open]=OFF AND RI[4:Bek A product aanwezig]=ON,JMP LBL[50] ;
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
P[10:"Naar centreer"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   436.885  mm,	Y =  -495.497  mm,	Z =    78.289  mm,
	W =  -176.913 deg,	P =   -44.802 deg,	R =   -91.229 deg
};
P[20:"centreer pos"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   446.897  mm,	Y =  -677.000  mm,	Z =  -106.000  mm,
	W =  -176.913 deg,	P =   -44.802 deg,	R =   -91.229 deg
};
P[30:"pak pos"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   446.986  mm,	Y =  -676.426  mm,	Z =  -107.515  mm,
	W =  -176.913 deg,	P =   -44.802 deg,	R =   -91.229 deg
};
P[40]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   436.228  mm,	Y =      .013  mm,	Z =   420.764  mm,
	W =   179.900 deg,	P =     -.000 deg,	R =   -90.100 deg
};
/END
