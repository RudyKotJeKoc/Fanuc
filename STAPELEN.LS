/PROG  STAPELEN
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "Deksels stapelen";
PROG_SIZE	= 1915;
CREATE		= DATE 14-12-24  TIME 09:11:32;
MODIFIED	= DATE 19-05-10  TIME 20:59:06;
FILE_NAME	= J_STAPEL;
VERSION		= 0;
LINE_COUNT	= 71;
MEMORY_SIZE	= 2423;
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
   2:   ;
   3:  DO[52:IONblower witband]=ON ;
   4:   ;
   5:  UFRAME_NUM=0 ;
   6:  UTOOL_NUM=1 ;
   7:J P[1:Naar band] 80% CNT50    ;
   8:   ;
   9:  LBL[10:Eerste afleg] ;
  10:J P[300:boven stapel] 80% CNT30    ;
  11:   ;
  12:  !CONTROLEREN EERSTE AFLEG ;
  13:  IF R[20:Act R6]>=1,JMP LBL[20] ;
  14:   ;
  15:  !Controleren afleg vrij ;
  16:  $WAITTMOUT=200 ;
  17:  WAIT DI[27:Afleg 1 is vrij]=ON AND DI[28:Afleg 2 is vrij]=ON TIMEOUT,LBL[110] ;
  18:   ;
  19:  !EERSTE AFLEG POSITIE ;
  20:J P[310:1e afleg stapel] 30% CNT60 Offset,PR[34:Voor afleg]    ;
  21:L P[310:1e afleg stapel] 100mm/sec FINE ACC50    ;
  22:   ;
  23:  PR[32:Act afleg]=P[310:1e afleg stapel]    ;
  24:  PR[32,3:Act afleg]=PR[32,3:Act afleg]+R[7:Steekhoogte]    ;
  25:   ;
  26:  JMP LBL[50] ;
  27:   ;
  28:  LBL[20:Stapelen] ;
  29:  !Controleren product op band ;
  30:  IF DI[27:Afleg 1 is vrij]=ON AND DI[28:Afleg 2 is vrij]=ON AND R[20:Act R6]>=1,JMP LBL[110] ;
  31:   ;
  32:L PR[32:Act afleg] 1000mm/sec CNT50 Offset,PR[34:Voor afleg]    ;
  33:L PR[32:Act afleg] 80mm/sec FINE ACC50    ;
  34:  PR[32,3:Act afleg]=PR[32,3:Act afleg]+R[7:Steekhoogte]    ;
  35:   ;
  36:  JMP LBL[50] ;
  37:   ;
  38:  LBL[50:Openen grijpers] ;
  39:  PR[33:Na afleg]=LPOS    ;
  40:   ;
  41:  Open hand 1    ;
  42:  Open hand 2    ;
  43:  WAIT    .50(sec) ;
  44:L PR[33:Na afleg] 500mm/sec CNT50 Offset,PR[34:Voor afleg]    ;
  45:L P[300:boven stapel] 1000mm/sec CNT100    ;
  46:   ;
  47:  R[20:Act R6]=R[20:Act R6]+1    ;
  48:  IF R[20:Act R6]>=R[6:Aantal in hoogte],JMP LBL[100] ;
  49:  END ;
  50:   ;
  51:  !Stapel vol ;
  52:  LBL[100] ;
  53:  R[20:Act R6]=0    ;
  54:  IF DI[26:Transpbnd vol]=ON,JMP LBL[120] ;
  55:  DO[14321]=PULSE,6.0sec ;
  56:  IF DI[26:Transpbnd vol]=ON,JMP LBL[120] ;
  57:  END ;
  58:   ;
  59:  LBL[110:Afleg niet vrij] ;
  60:  R[20:Act R6]=0    ;
  61:  DO[14321]=PULSE,6.0sec ;
  62:  WAIT   5.00(sec) ;
  63:  IF DI[26:Transpbnd vol]=ON,JMP LBL[120] ;
  64:  JMP LBL[10] ;
  65:   ;
  66:  LBL[120:Transprtband vol] ;
  67:  DO[50:Rode lamp hek]=ON ;
  68:  DO[49:Buzzer hek]=PULSE,10.0sec ;
  69:  R[44:Transportbnd vol]=1    ;
  70:  END ;
  71:   ;
/POS
P[1:"Naar band"]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   660.905  mm,	Y =   438.001  mm,	Z =   575.225  mm,
	W =   180.000 deg,	P =     -.000 deg,	R =     -.886 deg
};
P[300:"boven stapel"]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  1003.516  mm,	Y =   423.300  mm,	Z =   684.965  mm,
	W =   179.859 deg,	P =     -.425 deg,	R =    -1.094 deg
};
P[310:"1e afleg stapel"]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  1004.043  mm,	Y =   423.300  mm,	Z =   384.185  mm,
	W =   179.859 deg,	P =     -.425 deg,	R =    -1.094 deg
};
/END
