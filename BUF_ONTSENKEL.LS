/PROG  BUF_ONTSENKEL
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "Ontstaplen plate";
PROG_SIZE	= 1826;
CREATE		= DATE 19-06-03  TIME 17:32:46;
MODIFIED	= DATE 19-06-03  TIME 17:36:54;
FILE_NAME	= BUF_ONTS;
VERSION		= 0;
LINE_COUNT	= 64;
MEMORY_SIZE	= 2362;
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
   5:  R[45:Teller ontstapel]=R[45:Teller ontstapel]+1    ;
   6:   ;
   7:  LBL[250:ONTSTAPEL BUFFER] ;
   8:  $WAITTMOUT=500 ;
   9:  WAIT DI[20:Afl 1 vrij Corona]=ON AND DI[21:Afl 2 vrij Corona]=ON TIMEOUT,LBL[300] ;
  10:   ;
  11:J P[250] 50% CNT100    ;
  12:  IF R[9:Act R8]=1,JMP LBL[251] ;
  13:   ;
  14:  PR[76,3:Afleg buffer 1]=PR[76,3:Afleg buffer 1]-R[7:Steekhoogte]    ;
  15:   ;
  16:J PR[76:Afleg buffer 1] 40% CNT25 Offset,PR[75:Offset buffer]    ;
  17:L PR[76:Afleg buffer 1] 100mm/sec FINE    ;
  18:  JMP LBL[260] ;
  19:   ;
  20:  LBL[251] ;
  21:L P[200:1e afleg buffer] 400mm/sec CNT25 Offset,PR[75:Offset buffer]    ;
  22:L P[200:1e afleg buffer] 100mm/sec FINE    ;
  23:  JMP LBL[260] ;
  24:   ;
  25:  LBL[260:GRIJP PRODUCTEN] ;
  26:  PR[78:Actuele afleg]=LPOS    ;
  27:   ;
  28:  Close hand 2    ;
  29:  WAIT    .50(sec) ;
  30:  JMP LBL[20] ;
  31:   ;
  32:  LBL[20:Na sluiten bek] ;
  33:L PR[78:Actuele afleg] 200mm/sec CNT50 Offset,PR[75:Offset buffer]    ;
  34:J P[250] 30% CNT100    ;
  35:   ;
  36:  IF R[21:Grijper 1-voudig]=1,JMP LBL[41] ;
  37:   ;
  38:  LBL[40:Grijp controle] ;
  39:  IF RI[1:Bek B Open]=OFF AND RI[2:Bek B product aanwezig]=ON AND RI[3:Bek A Open]=ON AND RI[4:Bek A product aanwezig]=OFF,JMP LBL[50] ;
  40:  IF R[100:Product controle]>1,JMP LBL[310] ;
  41:  WAIT    .01(sec) ;
  42:  R[100:Product controle]=R[100:Product controle]+.01    ;
  43:  JMP LBL[40] ;
  44:   ;
  45:  LBL[41:Grijp controle] ;
  46:  IF RI[1:Bek B Open]=OFF AND RI[2:Bek B product aanwezig]=ON AND RI[3:Bek A Open]=ON AND RI[4:Bek A product aanwezig]=OFF,JMP LBL[50] ;
  47:  IF R[100:Product controle]>1,JMP LBL[310] ;
  48:  WAIT    .01(sec) ;
  49:  R[100:Product controle]=R[100:Product controle]+.01    ;
  50:  JMP LBL[41] ;
  51:   ;
  52:  LBL[50:UITNAME OK ] ;
  53:  R[100:Product controle]=0    ;
  54:  R[9:Act R8]=R[9:Act R8]-1    ;
  55:  WAIT   4.00(sec) ;
  56:  END ;
  57:   ;
  58:  LBL[300:Afleg niet vrij ] ;
  59:  END ;
  60:   ;
  61:  LBL[310:Grijp fout buffr] ;
  62:  R[100:Product controle]=0    ;
  63:  R[42:Grijpfout bufffe]=1    ;
  64:  R[45:Teller ontstapel]=0    ;
/POS
P[200:"1e afleg buffer"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   834.069  mm,	Y =  -550.353  mm,	Z =  -109.844  mm,
	W =   179.896 deg,	P =      .068 deg,	R =    -1.155 deg
};
P[250]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   834.070  mm,	Y =  -550.351  mm,	Z =   425.000  mm,
	W =   179.896 deg,	P =      .068 deg,	R =    -1.155 deg
};
/END
