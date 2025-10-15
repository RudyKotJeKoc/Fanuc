/PROG  BUF_S006
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "bufferen plates";
PROG_SIZE	= 1833;
CREATE		= DATE 15-07-15  TIME 10:38:22;
MODIFIED	= DATE 15-08-31  TIME 09:25:06;
FILE_NAME	= BUF_STPL;
VERSION		= 0;
LINE_COUNT	= 63;
MEMORY_SIZE	= 2221;
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
   1:  UFRAME_NUM=0 ;
   2:  !Afleg niet vrij ;
   3:  !Robot gaat bufferen ;
   4:   ;
   5:  DO[14:Vrij printer]=ON ;
   6:  DO[15:Vrijgave printer]=PULSE,10.0sec ;
   7:   ;
   8:  IF R[9:Act R8]>=R[8:Buffer aantal],JMP LBL[500] ;
   9:   ;
  10:  !TUSSENPOSITIONEREN ;
  11:  CALL POSITIE3    ;
  12:  IF R[40:Grijpfout centre]=1,JMP LBL[520] ;
  13:  IF R[47:Centrer niet vri]=1,JMP LBL[520] ;
  14:   ;
  15:  LBL[200:AFLEG NIET VRIJ] ;
  16:J P[250] 80% CNT100    ;
  17:   ;
  18:  IF R[9:Act R8]=1,JMP LBL[210] ;
  19:  IF R[9:Act R8]=2,JMP LBL[211] ;
  20:   ;
  21:  IF DI[22:Buffer vrij]=ON,JMP LBL[510] ;
  22:   ;
  23:  !EERSTE AFLEG BUFFERSTAPEL    ;
  24:J P[210:bvn 1e bufferpos] 50% CNT100    ;
  25:L P[200:1e afleg buffer] 600mm/sec CNT50 Offset,PR[75:Offset buffer]    ;
  26:L P[200:1e afleg buffer] 100mm/sec FINE ACC50    ;
  27:  JMP LBL[220] ;
  28:   ;
  29:  LBL[210:2e BUFFER] ;
  30:J P[210:bvn 1e bufferpos] 50% CNT100    ;
  31:L P[201] 600mm/sec CNT50 Offset,PR[75:Offset buffer]    ;
  32:L P[201] 100mm/sec FINE ACC50    ;
  33:  JMP LBL[220] ;
  34:   ;
  35:  LBL[211:3e BUFFER] ;
  36:J P[210:bvn 1e bufferpos] 50% CNT100    ;
  37:L P[202] 600mm/sec CNT50 Offset,PR[75:Offset buffer]    ;
  38:L P[202] 100mm/sec FINE ACC50    ;
  39:  JMP LBL[220] ;
  40:   ;
  41:  LBL[220:OPENEN GRIJPERS] ;
  42:  PR[78:Actuele afleg]=LPOS    ;
  43:  Open hand 1    ;
  44:  Open hand 2    ;
  45:  WAIT    .50(sec) ;
  46:   ;
  47:L PR[78:Actuele afleg] 250mm/sec CNT50 Offset,PR[75:Offset buffer]    ;
  48:L P[250] 1000mm/sec CNT100    ;
  49:   ;
  50:  R[9:Act R8]=R[9:Act R8]+1    ;
  51:   ;
  52:  END ;
  53:   ;
  54:  LBL[500:BUFFERSTAPEL VOL] ;
  55:  R[43:Bufferstapel vol]=1    ;
  56:  END ;
  57:   ;
  58:  LBL[510:BUFFER NIET VRY] ;
  59:  R[39:Buffer niet vrij]=1    ;
  60:  END ;
  61:   ;
  62:  LBL[520:POSITIONEER FOUT] ;
  63:  END ;
/POS
P[200:"1e afleg buffer"]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   227.469  mm,	Y = -1006.315  mm,	Z =   253.351  mm,
	W =   179.797 deg,	P =     -.483 deg,	R =   -88.919 deg
};
P[201]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   227.775  mm,	Y =  -870.864  mm,	Z =   253.347  mm,
	W =   179.797 deg,	P =     -.483 deg,	R =   -88.919 deg
};
P[202]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   228.095  mm,	Y =  -729.554  mm,	Z =   253.346  mm,
	W =   179.797 deg,	P =     -.483 deg,	R =   -88.919 deg
};
P[210:"bvn 1e bufferpos"]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   222.121  mm,	Y =  -824.961  mm,	Z =   490.000  mm,
	W =   179.632 deg,	P =     -.321 deg,	R =   -90.762 deg
};
P[250]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   222.121  mm,	Y =  -824.961  mm,	Z =   600.000  mm,
	W =   179.632 deg,	P =     -.321 deg,	R =   -90.762 deg
};
/END
