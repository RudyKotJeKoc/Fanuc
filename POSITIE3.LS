/PROG  POSITIE3
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "Centreren 1PA006";
PROG_SIZE	= 1444;
CREATE		= DATE 15-07-15  TIME 10:43:02;
MODIFIED	= DATE 15-08-31  TIME 09:57:58;
FILE_NAME	= POSITIE;
VERSION		= 0;
LINE_COUNT	= 47;
MEMORY_SIZE	= 1888;
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
   3:  OVERRIDE=80% ;
   4:  !Naar centreerpositie ;
   5:   ;
   6:J P[10] 100% CNT80    ;
   7:   ;
   8:  IF DI[23:Positioneer vrij]=ON,JMP LBL[510] ;
   9:   ;
  10:J P[20:centreer pos] 90% CNT30 Tool_Offset,PR[23:Bvn centreren]    ;
  11:L P[20:centreer pos] 600mm/sec CNT10    ;
  12:  Open hand 1    ;
  13:  Open hand 2    ;
  14:  WAIT    .30(sec) ;
  15:L P[30:pak pos] 200mm/sec FINE    ;
  16:  Close hand 1    ;
  17:  Close hand 2    ;
  18:  WAIT    .30(sec) ;
  19:  Open hand 1    ;
  20:  Open hand 2    ;
  21:  WAIT    .30(sec) ;
  22:  Close hand 1    ;
  23:  Close hand 2    ;
  24:  WAIT    .30(sec) ;
  25:   ;
  26:L P[30:pak pos] 800mm/sec CNT50 Offset,PR[24:Bvn centreren1]    ;
  27:J P[40] 80% CNT100    ;
  28:   ;
  29:  LBL[40:GRIJP CONTROLE] ;
  30:  IF RI[1:Bek B Open]=OFF AND RI[2:Bek B product aanwezig]=ON AND RI[3:Bek A Open]=OFF AND RI[4:Bek A product aanwezig]=ON,JMP LBL[50] ;
  31:  IF R[100:Product controle]>1,JMP LBL[500] ;
  32:  WAIT    .01(sec) ;
  33:  R[100:Product controle]=R[100:Product controle]+.01    ;
  34:  JMP LBL[40] ;
  35:   ;
  36:  LBL[50:UITNAME OK ] ;
  37:  R[100:Product controle]=0    ;
  38:  OVERRIDE=R[49:Snelheid] ;
  39:  END ;
  40:   ;
  41:  LBL[500:GRIJPFOUT] ;
  42:  R[40:Grijpfout centre]=1    ;
  43:  OVERRIDE=R[49:Snelheid] ;
  44:  END ;
  45:   ;
  46:  LBL[510:Centrer niet vry] ;
  47:  R[47:Centrer niet vri]=1    ;
/POS
P[10]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  -204.666  mm,	Y =  -636.591  mm,	Z =   594.060  mm,
	W =  -179.783 deg,	P =    -9.987 deg,	R =   -89.998 deg
};
P[20:"centreer pos"]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  -236.293  mm,	Y =  -791.972  mm,	Z =   175.367  mm,
	W =  -179.613 deg,	P =   -45.475 deg,	R =   -88.714 deg
};
P[30:"pak pos"]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  -237.336  mm,	Y =  -787.661  mm,	Z =   161.432  mm,
	W =  -179.613 deg,	P =   -45.475 deg,	R =   -88.786 deg
};
P[40]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  -263.483  mm,	Y =  -646.742  mm,	Z =   637.482  mm,
	W =  -179.792 deg,	P =   -41.797 deg,	R =   -90.665 deg
};
/END
