/PROG  B_STAPEL
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "Plate.A stapelen";
PROG_SIZE	= 1988;
CREATE		= DATE 16-08-30  TIME 08:46:50;
MODIFIED	= DATE 16-09-09  TIME 12:17:42;
FILE_NAME	= STAPELEN;
VERSION		= 0;
LINE_COUNT	= 74;
MEMORY_SIZE	= 2484;
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
   7:J P[1] 80% CNT50    ;
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
  49:   ;
  50:J P[2] 100% CNT100    ;
  51:  END ;
  52:   ;
  53:  !Stapel vol ;
  54:  LBL[100] ;
  55:  R[20:Act R6]=0    ;
  56:  IF DI[26:Transpbnd vol]=ON,JMP LBL[120] ;
  57:  DO[14321]=PULSE,6.0sec ;
  58:  IF DI[26:Transpbnd vol]=ON,JMP LBL[120] ;
  59:  END ;
  60:   ;
  61:  LBL[110:Afleg niet vrij] ;
  62:  R[20:Act R6]=0    ;
  63:  DO[14321]=PULSE,6.0sec ;
  64:  WAIT   6.00(sec) ;
  65:  IF DI[26:Transpbnd vol]=ON,JMP LBL[120] ;
  66:  JMP LBL[10] ;
  67:   ;
  68:  LBL[120:Transprtband vol] ;
  69:  DO[50:Rode lamp hek]=ON ;
  70:  DO[49:Buzzer hek]=PULSE,10.0sec ;
  71:  R[44:Transportbnd vol]=1    ;
  72:J P[2] 30% CNT100    ;
  73:  END ;
  74:   ;
/POS
P[1]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   490.019  mm,	Y =    -1.159  mm,	Z =   491.483  mm,
	W =  -178.689 deg,	P =    -1.079 deg,	R =   -89.277 deg
};
P[2]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   490.019  mm,	Y =    -1.159  mm,	Z =   491.483  mm,
	W =  -178.689 deg,	P =    -1.079 deg,	R =   -89.277 deg
};
P[300:"boven stapel"]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, -1',
	X =  1020.000  mm,	Y =   438.462  mm,	Z =   573.665  mm,
	W =  -179.666 deg,	P =     -.206 deg,	R =   179.261 deg
};
P[310:"1e afleg stapel"]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, -1',
	X =  1020.000  mm,	Y =   422.335  mm,	Z =   229.304  mm,
	W =  -179.880 deg,	P =      .129 deg,	R =   179.259 deg
};
/END
