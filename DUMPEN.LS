/PROG  DUMPEN
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "Afkeur op band";
PROG_SIZE	= 846;
CREATE		= DATE 15-11-25  TIME 08:57:38;
MODIFIED	= DATE 19-03-22  TIME 18:24:12;
FILE_NAME	= ;
VERSION		= 0;
LINE_COUNT	= 18;
MEMORY_SIZE	= 1146;
PROTECT		= READ_WRITE;
TCD:  STACK_SIZE	= 0,
      TASK_PRIORITY	= 50,
      TIME_SLICE	= 0,
      BUSY_LAMP_OFF	= 0,
      ABORT_REQUEST	= 0,
      PAUSE_REQUEST	= 0;
DEFAULT_GROUP	= 1,*,*,*,*;
CONTROL_CODE	= 00000000 00000000;
/MN
   1:  !MET NIEUWE CENTREERPLAAT EN ;
   2:  !PRINTER ;
   3:   ;
   4:  UFRAME_NUM=1 ;
   5:  UTOOL_NUM=1 ;
   6:   ;
   7:  !Aansturen bandje afkeur ;
   8:  DO[14321]=R[80:Witte band] ;
   9:   ;
  10:J P[1:dump producten] 30% CNT20    ;
  11:L P[2] 300mm/sec CNT100    ;
  12:   ;
  13:  Open hand 1    ;
  14:  Open hand 2    ;
  15:  WAIT    .50(sec) ;
  16:   ;
  17:L P[3] 200mm/sec CNT100    ;
  18:J P[4:rust positie] 30% CNT100    ;
/POS
P[1:"dump producten"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   645.395  mm,	Y =   420.922  mm,	Z =   236.217  mm,
	W =   179.593 deg,	P =     -.085 deg,	R =   -91.508 deg
};
P[2]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  1047.157  mm,	Y =   420.922  mm,	Z =   236.217  mm,
	W =   179.593 deg,	P =     -.085 deg,	R =   -91.508 deg
};
P[3]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   470.003  mm,	Y =   420.923  mm,	Z =   236.218  mm,
	W =   179.593 deg,	P =     -.085 deg,	R =   -91.508 deg
};
P[4:"rust positie"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   451.205  mm,	Y =      .013  mm,	Z =   354.127  mm,
	W =   179.900 deg,	P =     -.000 deg,	R =   -90.100 deg
};
/END
