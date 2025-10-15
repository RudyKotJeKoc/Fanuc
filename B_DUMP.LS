/PROG  B_DUMP
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "Afkeur 1PA008";
PROG_SIZE	= 726;
CREATE		= DATE 16-05-23  TIME 13:07:48;
MODIFIED	= DATE 16-05-23  TIME 13:11:12;
FILE_NAME	= DUMPEN;
VERSION		= 0;
LINE_COUNT	= 14;
MEMORY_SIZE	= 1042;
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
   1:  !MET NIEUWE CENTREERPLAAT EN ;
   2:  !PRINTER ;
   3:   ;
   4:  UFRAME_NUM=1 ;
   5:  UTOOL_NUM=1 ;
   6:   ;
   7:J P[1:Rustpositie] 30% CNT20    ;
   8:J P[2:DUMPPOSITIE] 15% CNT100    ;
   9:   ;
  10:  Open hand 1    ;
  11:  Open hand 2    ;
  12:  WAIT    .50(sec) ;
  13:   ;
  14:J P[1:Rustpositie] 30% CNT100    ;
/POS
P[1:"Rustpositie"]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   426.452  mm,	Y =     -.967  mm,	Z =   423.772  mm,
	W =  -179.900 deg,	P =      .000 deg,	R =   -90.130 deg
};
P[2:"DUMPPOSITIE"]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   566.268  mm,	Y =  -135.685  mm,	Z =  -213.427  mm,
	W =  -179.900 deg,	P =      .000 deg,	R =   -90.130 deg
};
/END
