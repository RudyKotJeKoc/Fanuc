/PROG  BUF_S008
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "bufferen 1PA008";
PROG_SIZE	= 1543;
CREATE		= DATE 16-04-18  TIME 14:23:36;
MODIFIED	= DATE 16-05-23  TIME 16:42:54;
FILE_NAME	= BUF_STPL;
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
   1:  UFRAME_NUM=0 ;
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
  31:  WAIT    .20(sec) ;
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
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  1047.738  mm,	Y =  -508.275  mm,	Z =  -103.938  mm,
	W =   179.705 deg,	P =     -.494 deg,	R =    -1.037 deg
};
P[210:"bvn 1e bufferpos"]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  1047.738  mm,	Y =  -508.274  mm,	Z =   285.532  mm,
	W =   179.705 deg,	P =     -.494 deg,	R =    -1.037 deg
};
P[250]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   800.537  mm,	Y =  -506.314  mm,	Z =   512.687  mm,
	W =   179.540 deg,	P =      .152 deg,	R =    -1.091 deg
};
/END
