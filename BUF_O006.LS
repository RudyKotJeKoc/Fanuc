/PROG  BUF_O006
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "Ontstaplen plate";
PROG_SIZE	= 1897;
CREATE		= DATE 15-07-15  TIME 10:38:04;
MODIFIED	= DATE 15-08-31  TIME 09:30:32;
FILE_NAME	= BUF_ONTS;
VERSION		= 0;
LINE_COUNT	= 60;
MEMORY_SIZE	= 2321;
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
   1:  !Buffer bevat producten ;
   2:  !EN afleg is vrij ;
   3:  !Robot gaat buffer ontstapelen ;
   4:   ;
   5:  LBL[250:ONTSTAPEL BUFFER] ;
   6:  $WAITTMOUT=500 ;
   7:  WAIT DI[21:Afl 2 vrij Corona]=ON TIMEOUT,LBL[300] ;
   8:   ;
   9:J P[250] 50% CNT100    ;
  10:  IF R[9:Act R8]=3,JMP LBL[211] ;
  11:  IF R[9:Act R8]=2,JMP LBL[210] ;
  12:   ;
  13:  !EERSTE AFLEG BUFFERSTAPEL    ;
  14:J P[1:bvn 1e bufferpos] 50% CNT100    ;
  15:L P[3:1e afleg buffer] 600mm/sec CNT50 Offset,PR[75:Offset buffer]    ;
  16:L P[3:1e afleg buffer] 100mm/sec FINE ACC50    ;
  17:  JMP LBL[260] ;
  18:   ;
  19:  LBL[210:2e BUFFER] ;
  20:J P[1:bvn 1e bufferpos] 50% CNT100    ;
  21:L P[6] 600mm/sec CNT50 Offset,PR[75:Offset buffer]    ;
  22:L P[6] 100mm/sec FINE ACC50    ;
  23:  JMP LBL[260] ;
  24:   ;
  25:  LBL[211:3e BUFFER] ;
  26:J P[1:bvn 1e bufferpos] 50% CNT100    ;
  27:L P[9] 600mm/sec CNT50 Offset,PR[75:Offset buffer]    ;
  28:L P[9] 100mm/sec FINE ACC50    ;
  29:  JMP LBL[260] ;
  30:   ;
  31:  LBL[260:GRIJP PRODUCTEN] ;
  32:  PR[78:Actuele afleg]=LPOS    ;
  33:  Close hand 1    ;
  34:  Close hand 2    ;
  35:  WAIT    .50(sec) ;
  36:L PR[78:Actuele afleg] 200mm/sec CNT50 Offset,PR[75:Offset buffer]    ;
  37:J P[250] 50% CNT100    ;
  38:   ;
  39:  LBL[40:Grijp controle] ;
  40:  IF RI[1:Bek B Open]=OFF AND RI[2:Bek B product aanwezig]=ON AND RI[3:Bek A Open]=OFF AND RI[4:Bek A product aanwezig]=ON,JMP LBL[50] ;
  41:  IF R[100:Product controle]>1,JMP LBL[310] ;
  42:  WAIT    .01(sec) ;
  43:  R[100:Product controle]=R[100:Product controle]+.01    ;
  44:  JMP LBL[40] ;
  45:   ;
  46:  LBL[50:UITNAME OK ] ;
  47:  R[100:Product controle]=0    ;
  48:  R[45:Teller ontstapel]=1    ;
  49:   ;
  50:  R[9:Act R8]=R[9:Act R8]-1    ;
  51:  WAIT   3.00(sec) ;
  52:  END ;
  53:   ;
  54:  LBL[300:Afleg niet vrij ] ;
  55:  END ;
  56:   ;
  57:  LBL[310:Grijp fout buffr] ;
  58:  R[100:Product controle]=0    ;
  59:  R[42:Grijpfout bufffe]=1    ;
  60:  R[45:Teller ontstapel]=0    ;
/POS
P[1:"bvn 1e bufferpos"]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   222.121  mm,	Y =  -824.961  mm,	Z =   490.000  mm,
	W =   179.632 deg,	P =     -.321 deg,	R =   -90.762 deg
};
P[3:"1e afleg buffer"]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   227.469  mm,	Y = -1006.315  mm,	Z =   253.351  mm,
	W =   179.797 deg,	P =     -.483 deg,	R =   -88.919 deg
};
P[6]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   227.775  mm,	Y =  -870.864  mm,	Z =   253.347  mm,
	W =   179.797 deg,	P =     -.483 deg,	R =   -88.919 deg
};
P[9]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   228.095  mm,	Y =  -729.554  mm,	Z =   253.346  mm,
	W =   179.797 deg,	P =     -.483 deg,	R =   -88.919 deg
};
P[250]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   222.121  mm,	Y =  -824.961  mm,	Z =   600.000  mm,
	W =   179.632 deg,	P =     -.321 deg,	R =   -90.762 deg
};
/END
