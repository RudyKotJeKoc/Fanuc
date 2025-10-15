/PROG  BUF_STPL
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "bufferen plates";
PROG_SIZE	= 1543;
CREATE		= DATE 14-08-12  TIME 09:42:48;
MODIFIED	= DATE 19-01-21  TIME 00:07:24;
FILE_NAME	= J_BEDRUK;
VERSION		= 0;
LINE_COUNT	= 50;
MEMORY_SIZE	= 1975;
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
   2:  !Afleg niet vrij ;
   3:  !Robot gaat bufferen ;
   4:   ;
   5:  DO[49:Buzzer hek]=PULSE,10.0sec ;
   6:  DO[50:Rode lamp hek]=ON ;
   7:   ;
   8:  LBL[200:AFLEG NIET VRIJ] ;
   9:J P[250] 80% CNT100    ;
  10:   ;
  11:  IF R[9:Act R8]>=1,JMP LBL[210] ;
  12:   ;
  13:  IF DI[22:Buffer vrij]=OFF,JMP LBL[510] ;
  14:   ;
  15:  !EERSTE AFLEG BUFFERSTAPEL    ;
  16:J P[210:bvn 1e bufferpos] 50% CNT100    ;
  17:L P[200:1e afleg buffer] 600mm/sec CNT50 Offset,PR[75:Offset buffer]    ;
  18:L P[200:1e afleg buffer] 100mm/sec FINE ACC50    ;
  19:  PR[76:Afleg buffer 1]=P[200:1e afleg buffer]    ;
  20:  PR[76,3:Afleg buffer 1]=PR[76,3:Afleg buffer 1]+R[7:Steekhoogte]    ;
  21:  JMP LBL[220] ;
  22:   ;
  23:  LBL[210:1e BUFFERSTAPEL] ;
  24:L PR[76:Afleg buffer 1] 500mm/sec CNT50 Offset,PR[75:Offset buffer]    ;
  25:L PR[76:Afleg buffer 1] 100mm/sec FINE ACC50    ;
  26:  PR[76,3:Afleg buffer 1]=PR[76,3:Afleg buffer 1]+R[7:Steekhoogte]    ;
  27:  JMP LBL[220] ;
  28:   ;
  29:  LBL[220:OPENEN GRIJPERS] ;
  30:  PR[78:Actuele afleg]=LPOS    ;
  31:  WAIT    .50(sec) ;
  32:  Open hand 1    ;
  33:  Open hand 2    ;
  34:  WAIT    .50(sec) ;
  35:   ;
  36:L PR[78:Actuele afleg] 250mm/sec CNT50 Offset,PR[75:Offset buffer]    ;
  37:L P[250] 1000mm/sec CNT100    ;
  38:   ;
  39:  R[9:Act R8]=R[9:Act R8]+1    ;
  40:  IF R[9:Act R8]>=R[8:Buffer aantal],JMP LBL[500] ;
  41:   ;
  42:  END ;
  43:   ;
  44:  LBL[500:BUFFERSTAPEL VOL] ;
  45:  R[43:Bufferstapel vol]=1    ;
  46:  END ;
  47:   ;
  48:  LBL[510:BUFFER NIET VRY] ;
  49:  R[39:Buffer niet vrij]=1    ;
  50:  END ;
/POS
P[200:"1e afleg buffer"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   834.069  mm,	Y =  -550.353  mm,	Z =  -109.844  mm,
	W =   179.896 deg,	P =      .068 deg,	R =    -1.155 deg
};
P[210:"bvn 1e bufferpos"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   834.069  mm,	Y =  -550.351  mm,	Z =   250.000  mm,
	W =   179.896 deg,	P =      .068 deg,	R =    -1.155 deg
};
P[250]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   834.069  mm,	Y =  -550.351  mm,	Z =   425.000  mm,
	W =   179.896 deg,	P =      .068 deg,	R =    -1.155 deg
};
/END
