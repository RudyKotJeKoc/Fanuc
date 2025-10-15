/PROG  B_AFLG_B
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "Stapel plate b";
PROG_SIZE	= 2269;
CREATE		= DATE 18-02-08  TIME 09:22:08;
MODIFIED	= DATE 19-05-02  TIME 23:21:20;
FILE_NAME	= BUF_STPL;
VERSION		= 0;
LINE_COUNT	= 74;
MEMORY_SIZE	= 2765;
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
   4:  UFRAME_NUM=1 ;
   5:   ;
   6:  DO[51:IONblower Corona]=ON ;
   7:  DO[52:IONblower witband]=ON ;
   8:   ;
   9:  !Afleg in gouden mallen ;
  10:   ;
  11:  !Controle mallen vrijgegeven  ;
  12:  !Signaal vanuit unitronics PLC ;
  13:  $WAITTMOUT=500 ;
  14:  WAIT DI[82:System gereed uni]=ON TIMEOUT,LBL[500] ;
  15:   ;
  16:  !Controle of er een vel ligt ;
  17:  !Op de eerste afleg ;
  18:  IF DI[83:1e afleg uni]=ON AND R[130:1e afleg b]=0,JMP LBL[510] ;
  19:   ;
  20:  IF R[133:Vel ingelegd]=0,JMP LBL[520] ;
  21:   ;
  22:J P[2] 95% CNT50    ;
  23:J P[1] 95% CNT10    ;
  24:  WAIT R[115] ;
  25:J P[2] 95% CNT50    ;
  26:   ;
  27:  LBL[200:START AFLEGGEN ] ;
  28:J P[250:Boven mallen] 80% CNT100    ;
  29:   ;
  30:  !Controle eerste afleg ;
  31:  IF DI[83:1e afleg uni]=OFF,JMP LBL[210] ;
  32:   ;
  33:  !EERSTE AFLEG BUFFERSTAPEL    ;
  34:J P[210:bvn 1e bufferpos] 50% CNT100    ;
  35:L P[200:1e afleg buffer] 600mm/sec CNT50 Offset,PR[72:Offset afleg B]    ;
  36:L P[200:1e afleg buffer] 100mm/sec FINE ACC50    ;
  37:  PR[71:Afleg plate B]=P[200:1e afleg buffer]    ;
  38:  PR[71,3:Afleg plate B]=PR[71,3:Afleg plate B]+R[7:Steekhoogte]    ;
  39:  JMP LBL[220] ;
  40:   ;
  41:  LBL[210:STAPELEN] ;
  42:L PR[71:Afleg plate B] 500mm/sec CNT50 Offset,PR[72:Offset afleg B]    ;
  43:L PR[71:Afleg plate B] 100mm/sec FINE ACC50    ;
  44:  PR[71,3:Afleg plate B]=PR[71,3:Afleg plate B]+R[7:Steekhoogte]    ;
  45:  JMP LBL[220] ;
  46:   ;
  47:  LBL[220:OPENEN GRIJPERS] ;
  48:  PR[78:Actuele afleg]=LPOS    ;
  49:  WAIT    .50(sec) ;
  50:  RO[5:Vacuum 1]=OFF ;
  51:  RO[6:Vacuum 2]=OFF ;
  52:  WAIT    .50(sec) ;
  53:   ;
  54:L PR[78:Actuele afleg] 250mm/sec CNT50 Offset,PR[72:Offset afleg B]    ;
  55:L P[250:Boven mallen] 1000mm/sec CNT100    ;
  56:   ;
  57:  R[133:Vel ingelegd]=0    ;
  58:  END ;
  59:   ;
  60:  LBL[500:STAPELMAL NI VRY] ;
  61:  R[132:Mallen niet vrij]=1    ;
  62:  END ;
  63:   ;
  64:  LBL[510:GEEN VEL INGELGD] ;
  65:  !Geen vel op pos 1 ;
  66:  R[134:Geen vel pos 0]=1    ;
  67:  R[136:Vel niet geplaat]=R[136:Vel niet geplaat]+1    ;
  68:  END ;
  69:   ;
  70:  LBL[520:GEEN VEL INGELGD] ;
  71:  !Geen vel op pos 2 tm 50 ;
  72:  R[135:Geen vel p 2_50]=1    ;
  73:  R[136:Vel niet geplaat]=R[136:Vel niet geplaat]+1    ;
  74:  END ;
/POS
P[1]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  1087.837  mm,	Y =   463.172  mm,	Z =   573.380  mm,
	W =  -113.020 deg,	P =      .853 deg,	R =   -90.362 deg
};
P[2]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   689.265  mm,	Y =   150.675  mm,	Z =   505.001  mm,
	W =   179.964 deg,	P =     -.985 deg,	R =     -.836 deg
};
P[200:"1e afleg buffer"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  1072.664  mm,	Y =  -161.925  mm,	Z =   200.668  mm,
	W =   179.964 deg,	P =     -.985 deg,	R =     -.837 deg
};
P[210:"bvn 1e bufferpos"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  1072.658  mm,	Y =  -161.925  mm,	Z =   407.628  mm,
	W =   179.964 deg,	P =     -.985 deg,	R =     -.836 deg
};
P[250:"Boven mallen"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  1072.664  mm,	Y =  -161.925  mm,	Z =   505.000  mm,
	W =   179.964 deg,	P =     -.985 deg,	R =     -.837 deg
};
/END
