/PROG  B_VELLEN
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "Stapel vellen";
PROG_SIZE	= 2494;
CREATE		= DATE 18-02-08  TIME 09:56:38;
MODIFIED	= DATE 19-05-03  TIME 19:54:26;
FILE_NAME	= B_AFLG_B;
VERSION		= 0;
LINE_COUNT	= 88;
MEMORY_SIZE	= 2934;
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
   3:   ;
   4:  !Velletje pakken ;
   5:  !Afleg in gouden mallen ;
   6:   ;
   7:  UFRAME_NUM=1 ;
   8:J P[1:Boven pakpos] 90% CNT100    ;
   9:   ;
  10:  !Vacuum aan tijdens naar beneden ;
  11:  !bewegen ;
  12:   ;
  13:  RO[5:Vacuum 1]=ON ;
  14:  RO[6:Vacuum 2]=ON ;
  15:   ;
  16:L P[2:Pakpos vellen] 500mm/sec FINE    ;
  17:   ;
  18:L P[3:Na pak] 100mm/sec FINE ACC25    ;
  19:L P[1:Boven pakpos] 1000mm/sec CNT10    ;
  20:   ;
  21:  !Controle 2x vel ;
  22:  LBL[40:UITNAME CONTROLE] ;
  23:  IF RI[5:Vacuum 1]=OFF OR RI[6:Vacuum 2]=OFF,JMP LBL[530] ;
  24:   ;
  25:  !Controle mallen vrijgegeven  ;
  26:  !Signaal vanuit unitronics PLC ;
  27:  $WAITTMOUT=500 ;
  28:  WAIT DI[82:System gereed uni]=ON TIMEOUT,LBL[500] ;
  29:   ;
  30:  LBL[200:START AFLEGGEN ] ;
  31:J P[250:Boven mallen] 80% CNT100    ;
  32:   ;
  33:  !Controle eerste afleg ;
  34:  IF DI[83:1e afleg uni]=OFF,JMP LBL[210] ;
  35:   ;
  36:  !EERSTE AFLEG BUFFERSTAPEL    ;
  37:J P[210:bvn 1e bufferpos] 75% CNT100    ;
  38:L P[200:1e afleg buffer] 600mm/sec CNT50 Offset,PR[72:Offset afleg B]    ;
  39:L P[200:1e afleg buffer] 100mm/sec FINE ACC50    ;
  40:  JMP LBL[220] ;
  41:   ;
  42:  LBL[210:STAPELEN] ;
  43:L PR[71:Afleg plate B] 500mm/sec CNT50 Offset,PR[72:Offset afleg B]    ;
  44:L PR[71:Afleg plate B] 100mm/sec FINE ACC50    ;
  45:  JMP LBL[220] ;
  46:   ;
  47:  LBL[220:VACUUM LOS] ;
  48:  PR[78:Actuele afleg]=LPOS    ;
  49:  WAIT    .20(sec) ;
  50:  RO[5:Vacuum 1]=OFF ;
  51:  RO[6:Vacuum 2]=OFF ;
  52:  WAIT    .10(sec) ;
  53:   ;
  54:  !Puls blaaslucht ;
  55:  Close hand 1    ;
  56:  Close hand 2    ;
  57:  WAIT    .15(sec) ;
  58:  Open hand 1    ;
  59:  Open hand 2    ;
  60:   ;
  61:L PR[78:Actuele afleg] 250mm/sec CNT50 Offset,PR[72:Offset afleg B]    ;
  62:L P[250:Boven mallen] 1000mm/sec CNT100    ;
  63:   ;
  64:  R[133:Vel ingelegd]=1    ;
  65:  R[136:Vel niet geplaat]=0    ;
  66:   ;
  67:  !Registers 1ste vel zetten ;
  68:  IF DI[83:1e afleg uni]=ON,JMP LBL[600] ;
  69:   ;
  70:  IF DI[83:1e afleg uni]=OFF AND R[130:1e afleg b]=1,JMP LBL[610] ;
  71:   ;
  72:  END ;
  73:   ;
  74:  LBL[500:STAPELMAL NI VRY] ;
  75:  R[132:Mallen niet vrij]=1    ;
  76:  END ;
  77:   ;
  78:  LBL[530:GEEN VEL GEPAKT] ;
  79:  R[131:Vacuumfout]=1    ;
  80:  END ;
  81:   ;
  82:  LBL[600:Eerste afleg] ;
  83:  R[130:1e afleg b]=1    ;
  84:  END ;
  85:   ;
  86:  LBL[610:Reset 1ste afleg] ;
  87:  R[130:1e afleg b]=0    ;
  88:  END ;
/POS
P[1:"Boven pakpos"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  1073.376  mm,	Y =  -435.900  mm,	Z =   356.985  mm,
	W =   179.965 deg,	P =     -.164 deg,	R =     -.838 deg
};
P[2:"Pakpos vellen"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  1073.371  mm,	Y =  -435.900  mm,	Z =   189.000  mm,
	W =   179.965 deg,	P =     -.164 deg,	R =     -.838 deg
};
P[3:"Na pak"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  1073.367  mm,	Y =  -435.925  mm,	Z =   225.186  mm,
	W =   179.966 deg,	P =     -.163 deg,	R =     -.839 deg
};
P[200:"1e afleg buffer"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  1072.663  mm,	Y =  -161.925  mm,	Z =   200.668  mm,
	W =   179.964 deg,	P =     -.985 deg,	R =     -.836 deg
};
P[210:"bvn 1e bufferpos"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  1072.663  mm,	Y =  -161.925  mm,	Z =   410.000  mm,
	W =   179.964 deg,	P =     -.985 deg,	R =     -.836 deg
};
P[250:"Boven mallen"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  1072.663  mm,	Y =  -161.925  mm,	Z =   505.000  mm,
	W =   179.964 deg,	P =     -.985 deg,	R =     -.836 deg
};
/END
