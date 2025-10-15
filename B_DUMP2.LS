/PROG  B_DUMP2
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "Afkeur 1PA008";
PROG_SIZE	= 893;
CREATE		= DATE 18-02-08  TIME 11:14:30;
MODIFIED	= DATE 19-05-03  TIME 17:30:52;
FILE_NAME	= B_DUMP;
VERSION		= 0;
LINE_COUNT	= 23;
MEMORY_SIZE	= 1173;
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
   5:  UTOOL_NUM=1 ;
   6:   ;
   7:J P[1:Rustpositie] 75% CNT20    ;
   8:J P[2:DUMPPOSITIE] 75% CNT100    ;
   9:L P[3:Lospositie] 1750mm/sec CNT100    ;
  10:   ;
  11:  RO[5:Vacuum 1]=OFF ;
  12:  RO[6:Vacuum 2]=OFF ;
  13:  WAIT    .50(sec) ;
  14:   ;
  15:  !Puls blaaslucht ;
  16:  Close hand 1    ;
  17:  Close hand 2    ;
  18:  WAIT    .25(sec) ;
  19:  Open hand 1    ;
  20:  Open hand 2    ;
  21:   ;
  22:L P[2:DUMPPOSITIE] 1750mm/sec CNT100    ;
  23:J P[1:Rustpositie] 30% CNT100    ;
/POS
P[1:"Rustpositie"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   451.205  mm,	Y =      .013  mm,	Z =   354.127  mm,
	W =   179.900 deg,	P =     -.000 deg,	R =   -90.100 deg
};
P[2:"DUMPPOSITIE"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   451.202  mm,	Y =  -152.960  mm,	Z =   197.227  mm,
	W =   179.900 deg,	P =      .001 deg,	R =   -90.099 deg
};
P[3:"Lospositie"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   451.203  mm,	Y =  -152.960  mm,	Z =  -340.072  mm,
	W =   179.900 deg,	P =      .001 deg,	R =   -90.099 deg
};
/END
