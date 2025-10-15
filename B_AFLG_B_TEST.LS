/PROG  B_AFLG_B_TEST
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "Stapel plate b";
PROG_SIZE	= 1989;
CREATE		= DATE 19-05-03  TIME 16:40:50;
MODIFIED	= DATE 19-05-03  TIME 18:18:26;
FILE_NAME	= B_AFLG_B;
VERSION		= 0;
LINE_COUNT	= 69;
MEMORY_SIZE	= 2505;
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
  22:  LBL[200:START AFLEGGEN ] ;
  23:J P[250:Boven mallen] 95% CNT100    ;
  24:   ;
  25:  !Controle eerste afleg ;
  26:  IF DI[83:1e afleg uni]=OFF,JMP LBL[210] ;
  27:   ;
  28:  !EERSTE AFLEG BUFFERSTAPEL    ;
  29:J P[210:bvn 1e bufferpos] 85% CNT100    ;
  30:L P[200:1e afleg buffer] 850mm/sec CNT50 Offset,PR[72:Offset afleg B]    ;
  31:L P[200:1e afleg buffer] 100mm/sec FINE ACC50    ;
  32:  PR[71:Afleg plate B]=P[200:1e afleg buffer]    ;
  33:  PR[71,3:Afleg plate B]=PR[71,3:Afleg plate B]+R[7:Steekhoogte]    ;
  34:  JMP LBL[220] ;
  35:   ;
  36:  LBL[210:STAPELEN] ;
  37:L PR[71:Afleg plate B] 500mm/sec CNT50 Offset,PR[72:Offset afleg B]    ;
  38:L PR[71:Afleg plate B] 100mm/sec FINE ACC50    ;
  39:  PR[71,3:Afleg plate B]=PR[71,3:Afleg plate B]+R[7:Steekhoogte]    ;
  40:  JMP LBL[220] ;
  41:   ;
  42:  LBL[220:OPENEN GRIJPERS] ;
  43:  PR[78:Actuele afleg]=LPOS    ;
  44:  WAIT    .50(sec) ;
  45:  RO[5:Vacuum 1]=OFF ;
  46:  RO[6:Vacuum 2]=OFF ;
  47:  WAIT    .50(sec) ;
  48:   ;
  49:L PR[78:Actuele afleg] 250mm/sec CNT50 Offset,PR[72:Offset afleg B]    ;
  50:L P[250:Boven mallen] 1000mm/sec CNT100    ;
  51:   ;
  52:  R[133:Vel ingelegd]=0    ;
  53:  END ;
  54:   ;
  55:  LBL[500:STAPELMAL NI VRY] ;
  56:  R[132:Mallen niet vrij]=1    ;
  57:  END ;
  58:   ;
  59:  LBL[510:GEEN VEL INGELGD] ;
  60:  !Geen vel op pos 1 ;
  61:  R[134:Geen vel pos 0]=1    ;
  62:  R[136:Vel niet geplaat]=R[136:Vel niet geplaat]+1    ;
  63:  END ;
  64:   ;
  65:  LBL[520:GEEN VEL INGELGD] ;
  66:  !Geen vel op pos 2 tm 50 ;
  67:  R[135:Geen vel p 2_50]=1    ;
  68:  R[136:Vel niet geplaat]=R[136:Vel niet geplaat]+1    ;
  69:  END ;
/POS
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
