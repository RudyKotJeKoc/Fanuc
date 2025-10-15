/PROG  BUF_O008
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "Ontstplen 1PA008";
PROG_SIZE	= 1602;
CREATE		= DATE 16-04-18  TIME 14:24:30;
MODIFIED	= DATE 16-04-18  TIME 14:24:30;
FILE_NAME	= BUF_ONTS;
VERSION		= 0;
LINE_COUNT	= 53;
MEMORY_SIZE	= 2054;
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
  27:  Close hand 1    ;
  28:  Close hand 2    ;
  29:  WAIT    .50(sec) ;
  30:L PR[78:Actuele afleg] 200mm/sec CNT50 Offset,PR[75:Offset buffer]    ;
  31:J P[250] 30% CNT100    ;
  32:   ;
  33:  LBL[40:Grijp controle] ;
  34:  IF RI[1:Bek B Open]=OFF AND RI[2:Bek B product aanwezig]=ON AND RI[3:Bek A Open]=OFF AND RI[4:Bek A product aanwezig]=ON,JMP LBL[50] ;
  35:  IF R[100:Product controle]>1,JMP LBL[310] ;
  36:  WAIT    .01(sec) ;
  37:  R[100:Product controle]=R[100:Product controle]+.01    ;
  38:  JMP LBL[40] ;
  39:   ;
  40:  LBL[50:UITNAME OK ] ;
  41:  R[100:Product controle]=0    ;
  42:   ;
  43:  R[9:Act R8]=R[9:Act R8]-1    ;
  44:  WAIT   4.00(sec) ;
  45:  END ;
  46:   ;
  47:  LBL[300:Afleg niet vrij ] ;
  48:  END ;
  49:   ;
  50:  LBL[310:Grijp fout buffr] ;
  51:  R[100:Product controle]=0    ;
  52:  R[42:Grijpfout bufffe]=1    ;
  53:  R[45:Teller ontstapel]=0    ;
/POS
P[200:"1e afleg buffer"]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  1047.738  mm,	Y =  -508.275  mm,	Z =  -106.916  mm,
	W =   179.705 deg,	P =     -.494 deg,	R =    -1.037 deg
};
P[250]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   800.537  mm,	Y =  -506.314  mm,	Z =   512.687  mm,
	W =   179.540 deg,	P =      .152 deg,	R =    -1.091 deg
};
/END
