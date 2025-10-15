/PROG  BG_LOGIC
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "";
PROG_SIZE	= 276;
CREATE		= DATE 15-01-12  TIME 22:12:18;
MODIFIED	= DATE 18-03-12  TIME 08:42:16;
FILE_NAME	= ;
VERSION		= 0;
LINE_COUNT	= 6;
MEMORY_SIZE	= 656;
PROTECT		= READ_WRITE;
TCD:  STACK_SIZE	= 0,
      TASK_PRIORITY	= 50,
      TIME_SLICE	= 0,
      BUSY_LAMP_OFF	= 0,
      ABORT_REQUEST	= 0,
      PAUSE_REQUEST	= 0;
DEFAULT_GROUP	= *,*,*,*,*;
CONTROL_CODE	= 00000000 00000000;
/MN
   1:  !Opstart tekst oproepen ;
   2:  F[1]=(DO[11077]) ;
   3:   ;
   4:  !Spacegebied 1 ingang type. ;
   5:  $RSPACE1[1].$DIN_TYPE=2 ;
   6:   ;
/POS
/END
