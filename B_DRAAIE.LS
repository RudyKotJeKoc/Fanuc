/PROG  B_DRAAIE
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "ONTSTAPELEN ";
PROG_SIZE	= 1254;
CREATE		= DATE 16-03-19  TIME 10:50:18;
MODIFIED	= DATE 19-02-28  TIME 22:07:52;
FILE_NAME	= ;
VERSION		= 0;
LINE_COUNT	= 24;
MEMORY_SIZE	= 1662;
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
   1:  IF DI[22:Buffer vrij]=OFF,JMP LBL[500] ;
   2:   ;
   3:J P[6:Naar buffertafel] 80% CNT100    ;
   4:J P[11:Boven buffertafl] 80% CNT100    ;
   5:L P[1:Lospositie] 600mm/sec FINE    ;
   6:  WAIT    .25(sec) ;
   7:  Open hand 2    ;
   8:  WAIT    .25(sec) ;
   9:L P[2:Na los Z+] 500mm/sec CNT100    ;
  10:J P[3:Draaien] 50% CNT100    ;
  11:J P[8:180 draaien 1] 50% CNT100    ;
  12:L P[9:Boven pak] 500mm/sec CNT100    ;
  13:L P[10:180 pak] 250mm/sec FINE    ;
  14:  WAIT    .25(sec) ;
  15:  Close hand 2    ;
  16:  WAIT    .25(sec) ;
  17:L P[4:Na pak] 750mm/sec CNT100    ;
  18:   ;
  19:J P[6:Naar buffertafel] 80% CNT100    ;
  20:J P[7:P10] 80% CNT100    ;
  21:  END ;
  22:   ;
  23:  LBL[500:AFLEG NIET VRY] ;
  24:  R[37:Draaien buffer]=1    ;
/POS
P[1:"Lospositie"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   835.402  mm,	Y =  -558.657  mm,	Z =  -105.341  mm,
	W =  -179.999 deg,	P =     -.455 deg,	R =     -.000 deg
};
P[2:"Na los Z+"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   835.403  mm,	Y =  -558.657  mm,	Z =     8.706  mm,
	W =  -179.999 deg,	P =     -.455 deg,	R =     -.000 deg
};
P[3:"Draaien"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   835.404  mm,	Y =  -558.652  mm,	Z =     8.701  mm,
	W =  -179.906 deg,	P =     -.031 deg,	R =   -70.515 deg
};
P[4:"Na pak"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   835.403  mm,	Y =  -707.390  mm,	Z =    20.000  mm,
	W =  -179.999 deg,	P =     -.455 deg,	R =   180.000 deg
};
P[6:"Naar buffertafel"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   451.200  mm,	Y =  -530.960  mm,	Z =   354.127  mm,
	W =  -180.000 deg,	P =     -.000 deg,	R =     -.000 deg
};
P[7:"P10"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  -246.623  mm,	Y =  -487.365  mm,	Z =   332.938  mm,
	W =   179.907 deg,	P =     -.038 deg,	R =  -123.154 deg
};
P[8:"180 draaien 1"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   835.403  mm,	Y =  -558.657  mm,	Z =     8.706  mm,
	W =  -179.999 deg,	P =     -.455 deg,	R =   180.000 deg
};
P[9:"Boven pak"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   835.403  mm,	Y =  -708.657  mm,	Z =     8.706  mm,
	W =  -179.999 deg,	P =     -.455 deg,	R =  -180.000 deg
};
P[10:"180 pak"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   835.403  mm,	Y =  -707.390  mm,	Z =  -106.500  mm,
	W =  -179.999 deg,	P =     -.455 deg,	R =   180.000 deg
};
P[11:"Boven buffertafl"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   750.000  mm,	Y =  -530.961  mm,	Z =   354.128  mm,
	W =  -180.000 deg,	P =      .000 deg,	R =      .000 deg
};
/END
