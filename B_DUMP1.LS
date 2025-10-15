/PROG  B_DUMP1
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "Afkeur b band";
PROG_SIZE	= 1045;
CREATE		= DATE 18-02-08  TIME 10:53:26;
MODIFIED	= DATE 19-05-03  TIME 20:11:14;
FILE_NAME	= DUMPEN;
VERSION		= 0;
LINE_COUNT	= 25;
MEMORY_SIZE	= 1449;
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
   7:  !Aansturen bandje afkeur ;
   8:  JMP LBL[1] ;
   9:  DO[14321]=R[80:Witte band] ;
  10:   ;
  11:  LBL[1] ;
  12:  DO[14321]=PULSE,5.0sec ;
  13:   ;
  14:J P[6:aanloop] 100% CNT50    ;
  15:J P[1:Naar dump produc] 30% CNT20    ;
  16:L P[2:Dump] 300mm/sec CNT100    ;
  17:   ;
  18:  RO[5:Vacuum 1]=OFF ;
  19:  RO[6:Vacuum 2]=OFF ;
  20:  WAIT    .50(sec) ;
  21:   ;
  22:L P[3:Na dump] 100mm/sec CNT100    ;
  23:L P[1:Naar dump produc] 200mm/sec CNT100    ;
  24:L P[6:aanloop] 500mm/sec CNT100    ;
  25:J P[4:rust positie] 30% CNT100    ;
/POS
P[1:"Naar dump produc"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   671.306  mm,	Y =   424.335  mm,	Z =   202.257  mm,
	W =   179.900 deg,	P =     -.000 deg,	R =   -90.100 deg
};
P[2:"Dump"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   889.107  mm,	Y =   424.335  mm,	Z =   202.258  mm,
	W =   179.900 deg,	P =     -.000 deg,	R =   -90.100 deg
};
P[3:"Na dump"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   889.107  mm,	Y =   424.335  mm,	Z =   212.158  mm,
	W =   179.900 deg,	P =     -.000 deg,	R =   -90.100 deg
};
P[4:"rust positie"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   451.205  mm,	Y =      .013  mm,	Z =   354.127  mm,
	W =   179.900 deg,	P =     -.000 deg,	R =   -90.100 deg
};
P[6:"aanloop"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   436.227  mm,	Y =   424.333  mm,	Z =   420.764  mm,
	W =   179.900 deg,	P =     -.000 deg,	R =   -90.100 deg
};
/END
