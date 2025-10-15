/PROG  Z_1PA003
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "Deksel steek 135";
PROG_SIZE	= 6857;
CREATE		= DATE 19-01-23  TIME 18:43:10;
MODIFIED	= DATE 19-01-23  TIME 18:43:10;
FILE_NAME	= A_1PAX02;
VERSION		= 0;
LINE_COUNT	= 321;
MEMORY_SIZE	= 7545;
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
   1:  !PROGRAMMA GEBLOKKEERT,  ;
   2:  !NOG AANPASSEN OP NIEUWE ROBOT ;
   3:  END ;
   4:   ;
   5:  UFRAME_NUM=1 ;
   6:  UTOOL_NUM=1 ;
   7:   ;
   8:  IF R[90:Program gestart]=0,JMP LBL[1000] ;
   9:   ;
  10:  !START PROGRAMMA AFLOOP ;
  11:   ;
  12:  OVERRIDE=80% ;
  13:  CALL TEKST(3) ;
  14:  UFRAME_NUM=1 ;
  15:  UTOOL_NUM=1 ;
  16:J P[1:rust positie] 20% CNT100    ;
  17:   ;
  18:  !Grijpers open ;
  19:  Open hand 1    ;
  20:  Open hand 2    ;
  21:   ;
  22:  LBL[10:NAAR INDUIK] ;
  23:  IF DI[7:Automaat]=OFF,JMP LBL[530] ;
  24:  IF DI[6:Matrijs dicht]=ON,JMP LBL[15] ;
  25:  JMP LBL[10] ;
  26:   ;
  27:  LBL[15] ;
  28:  DO[11017]=OFF ;
  29:J P[3:naar SGM] 30% CNT100    ;
  30:J P[6:induik] 30% CNT100    ;
  31:  Open hand 1    ;
  32:  Open hand 2    ;
  33:   ;
  34:  LBL[20:Cyclusteller] ;
  35:  R[46:Cyclusteller]=R[46:Cyclusteller]+1    ;
  36:   ;
  37:  $WAITTMOUT=500 ;
  38:  WAIT DO[11161]=ON TIMEOUT,LBL[570] ;
  39:  R[1:Cyclustijd]=TIMER[1]    ;
  40:   ;
  41:  LBL[25] ;
  42:  IF RI[1:Bek B Open]=OFF OR RI[3:Bek A Open]=OFF,JMP LBL[570] ;
  43:  IF DO[11161]=OFF,JMP LBL[570] ;
  44:  IF DO[11033]=ON,JMP LBL[30] ;
  45:  IF DI[7:Automaat]=OFF,JMP LBL[530] ;
  46:  JMP LBL[25] ;
  47:   ;
  48:  LBL[30:UITNAME] ;
  49:  IF R[46:Cyclusteller]<2,JMP LBL[31] ;
  50:   ;
  51:  OVERRIDE=100% ;
  52:   ;
  53:  LBL[31] ;
  54:  TIMER[1]=RESET ;
  55:L P[9:voor pak] 2000mm/sec CNT10    ;
  56:L P[10:pak pos] 500mm/sec CNT20    ;
  57:  DO[11017]=PULSE,0.2sec ;
  58:  WAIT R[4] ;
  59:  Close hand 1    ;
  60:  Close hand 2    ;
  61:  WAIT R[5] ;
  62:L P[11:na pak] 250mm/sec CNT30    ;
  63:  DO[11017]=OFF ;
  64:L P[15:buiten SGM] 2000mm/sec CNT100    ;
  65:   ;
  66:  OVERRIDE=R[49:Snelheid] ;
  67:   ;
  68:  LBL[40:UITNAME CONTROLE] ;
  69:  IF RI[1:Bek B Open]=OFF AND RI[2:Bek B product aanwezig]=ON AND RI[3:Bek A Open]=OFF AND RI[4:Bek A product aanwezig]=ON,JMP LBL[50] ;
  70:  IF R[100:Product controle]>1,JMP LBL[500] ;
  71:  WAIT    .01(sec) ;
  72:  R[100:Product controle]=R[100:Product controle]+.01    ;
  73:  JMP LBL[40] ;
  74:   ;
  75:  LBL[50:UITNAME OK ] ;
  76:  R[100:Product controle]=0    ;
  77:  DO[11025]=PULSE,0.5sec ;
  78:  R[2:Induiktijd]=TIMER[1]    ;
  79:  IF DI[10:Fout product]=ON,JMP LBL[510] ;
  80:L P[2] 1500mm/sec CNT80    ;
  81:J P[50:deurpos] 80% CNT80    ;
  82:   ;
  83:  LBL[60:OPSTART AFKEUR] ;
  84:  IF R[10:Opstart aantal]=0,JMP LBL[200] ;
  85:  IF R[29:Start afleg]=0,JMP LBL[510] ;
  86:   ;
  87:  !TUSSEPOSITIONEREN ;
  88:  LBL[200] ;
  89:  CALL POSITIE2    ;
  90:   ;
  91:  IF R[40:Grijpfout centre]=1,JMP LBL[505] ;
  92:  IF R[47:Centrer niet vri]=1,JMP LBL[735] ;
  93:   ;
  94:  !STAPELEN DEKSELS ;
  95:  LBL[310] ;
  96:  CALL STAPELEN    ;
  97:  UFRAME_NUM=1 ;
  98:   ;
  99:  IF R[44:Transportbnd vol]=1,JMP LBL[760] ;
 100:   ;
 101:  !Naar begin programma ;
 102:  LBL[490] ;
 103:  UFRAME_NUM=1 ;
 104:   ;
 105:J P[50:deurpos] 70% CNT60    ;
 106:  Open hand 1    ;
 107:  Open hand 2    ;
 108:J P[3:naar SGM] 70% CNT60    ;
 109:J P[6:induik] 60% CNT100    ;
 110:  JMP LBL[20] ;
 111:   ;
 112:   ;
 113:  !******STORINGEN****** ;
 114:   ;
 115:  LBL[500:UITNAME FOUT] ;
 116:  CALL TEKST(500) ;
 117:  R[100:Product controle]=0    ;
 118:L P[4] 300mm/sec CNT80    ;
 119:J P[1:rust positie] 30% FINE    ;
 120:  Open hand 1    ;
 121:  Open hand 2    ;
 122:  WAIT DI[7:Automaat]=OFF    ;
 123:   ;
 124:  SO[6]=ON ;
 125:  WAIT SI[5]=ON    ;
 126:  SO[6]=OFF ;
 127:  END ;
 128:   ;
 129:  LBL[505:GRIJPFOUT CNTRER] ;
 130:  CALL TEKST(510) ;
 131:  R[100:Product controle]=0    ;
 132:  R[40:Grijpfout centre]=0    ;
 133:J P[1:rust positie] 30% FINE    ;
 134:  Open hand 1    ;
 135:  Open hand 2    ;
 136:  WAIT DI[7:Automaat]=OFF    ;
 137:   ;
 138:  SO[6]=ON ;
 139:  WAIT SI[5]=ON    ;
 140:  SO[6]=OFF ;
 141:  END ;
 142:   ;
 143:  LBL[510:DUMPEN PRODUCTEN] ;
 144:L P[4] 500mm/sec CNT100    ;
 145:J P[35:dump producten] 30% CNT5    ;
 146:  Open hand 1    ;
 147:  Open hand 2    ;
 148:  R[28:Act dump]=R[28:Act dump]+1    ;
 149:  WAIT    .50(sec) ;
 150:J P[1:rust positie] 30% CNT100    ;
 151:J P[3:naar SGM] 30% FINE    ;
 152:J P[6:induik] 30% FINE    ;
 153:  IF R[28:Act dump]>=R[10:Opstart aantal],JMP LBL[520] ;
 154:  JMP LBL[20] ;
 155:  LBL[520] ;
 156:  R[29:Start afleg]=1    ;
 157:  JMP LBL[20] ;
 158:   ;
 159:  LBL[530:SGM UIT AUTOMAAT] ;
 160:  R[100:Product controle]=0    ;
 161:L P[4] 500mm/sec CNT80    ;
 162:J P[1:rust positie] 30% FINE    ;
 163:  DO[51:IONblower Corona]=OFF ;
 164:  END ;
 165:   ;
 166:  LBL[570] ;
 167:J P[3:naar SGM] 65% CNT100    ;
 168:   ;
 169:  LBL[580:Gryprfout induik] ;
 170:  CALL TEKST(581) ;
 171:J P[1:rust positie] 30% FINE    ;
 172:  Open hand 1    ;
 173:  Open hand 2    ;
 174:   ;
 175:  WAIT DI[7:Automaat]=OFF    ;
 176:  SO[6]=ON ;
 177:  WAIT SI[5]=ON    ;
 178:  SO[6]=OFF ;
 179:  END ;
 180:   ;
 181:  LBL[735:Centrer niet vry] ;
 182:  CALL TEKST(735) ;
 183:  R[47:Centrer niet vri]=0    ;
 184:J P[1:rust positie] 30% FINE    ;
 185:  Open hand 1    ;
 186:  Open hand 2    ;
 187:  WAIT    .50(sec) ;
 188:  WAIT DI[7:Automaat]=OFF    ;
 189:   ;
 190:  SO[6]=ON ;
 191:  WAIT SI[5]=ON    ;
 192:  SO[6]=OFF ;
 193:  END ;
 194:   ;
 195:  LBL[760:Band vol] ;
 196:  CALL TEKST(760) ;
 197:J P[1:rust positie] 30% FINE    ;
 198:  Open hand 1    ;
 199:  Open hand 2    ;
 200:  R[44:Transportbnd vol]=0    ;
 201:   ;
 202:  WAIT DI[7:Automaat]=OFF    ;
 203:   ;
 204:  SO[6]=ON ;
 205:  WAIT SI[5]=ON    ;
 206:  SO[6]=OFF ;
 207:  DO[50:Rode lamp hek]=OFF ;
 208:  END ;
 209:   ;
 210:  LBL[1000:HOME ZOEKEN] ;
 211:  CALL TEKST(1000) ;
 212:  PAYLOAD[1] ;
 213:  OVERRIDE=25% ;
 214:   ;
 215:  R[4:Vertr pakken]=.5    ;
 216:   ;
 217:  PR[100:Home Lpos]=LPOS    ;
 218:  R[200:Homezoek X]=PR[100,1:Home Lpos]    ;
 219:  R[199:Homezoek Y]=PR[100,2:Home Lpos]    ;
 220:  R[198:Homezoek Z]=PR[100,3:Home Lpos]    ;
 221:   ;
 222:  PR[99:Home Jpos]=JPOS    ;
 223:  R[193:J4]=PR[99,4:Home Jpos]    ;
 224:  R[194:J6]=PR[99,6:Home Jpos]    ;
 225:   ;
 226:  R[189:Act Uframe]=$MNUFRAMENUM[1] ;
 227:  R[188:Act Utool]=$MNUTOOLNUM[1] ;
 228:   ;
 229:  PR[97:P6]=P[6:induik]    ;
 230:  R[192:P6-Y]=PR[97,2:P6]    ;
 231:  R[192:P6-Y]=R[192:P6-Y]+10    ;
 232:  PR[96:P11]=P[11:na pak]    ;
 233:  R[191:P11-X]=PR[96,1:P11]    ;
 234:   ;
 235:  IF DO[100:Robot op reference]=ON,JMP LBL[1100] ;
 236:   ;
 237:  IF R[200:Homezoek X]>(-400) AND R[199:Homezoek Y]<(-1050),JMP LBL[1020] ;
 238:  IF R[200:Homezoek X]>0 AND R[200:Homezoek X]<400 AND R[199:Homezoek Y]<(-700),JMP LBL[1030] ;
 239:  IF R[200:Homezoek X]>500 AND R[199:Homezoek Y]<(-700),JMP LBL[1040] ;
 240:  IF R[199:Homezoek Y]<500,JMP LBL[1100] ;
 241:   ;
 242:  IF R[199:Homezoek Y]<R[192:P6-Y],JMP LBL[1006] ;
 243:   ;
 244:  IF DI[1:Matrijs open]=ON,JMP LBL[1001] ;
 245:  CALL TEKST(1001) ;
 246:  WAIT DI[1:Matrijs open]=ON AND DI[3:Uitw. terug]=ON    ;
 247:   ;
 248:  LBL[1001] ;
 249:  PR[100,1:Home Lpos]=R[191:P11-X]    ;
 250:L PR[100:Home Lpos] 100mm/sec CNT20    ;
 251:  LBL[1005] ;
 252:  UTOOL_NUM=1 ;
 253:L P[6:induik] 300mm/sec FINE    ;
 254:  JMP LBL[1100] ;
 255:   ;
 256:   ;
 257:  LBL[1006:Buiten SGM] ;
 258:L P[15:buiten SGM] 300mm/sec FINE    ;
 259:J P[3:naar SGM] 15% FINE    ;
 260:  JMP LBL[1100] ;
 261:   ;
 262:  LBL[1020:Bedrukken] ;
 263:  PR[100,1:Home Lpos]=PR[100,1:Home Lpos]-50    ;
 264:L PR[100:Home Lpos] 100mm/sec FINE    ;
 265:J P[1020] 10% FINE    ;
 266:J P[1021] 30% CNT100    ;
 267:  JMP LBL[1100] ;
 268:   ;
 269:  LBL[1030:Bufferen] ;
 270:  PR[100,3:Home Lpos]=PR[100,3:Home Lpos]+50    ;
 271:L PR[100:Home Lpos] 100mm/sec CNT10    ;
 272:J P[1030] 20% CNT20    ;
 273:  JMP LBL[1100] ;
 274:   ;
 275:  LBL[1040:Afleggen] ;
 276:  PR[100,3:Home Lpos]=PR[100,3:Home Lpos]+100    ;
 277:L PR[100:Home Lpos] 100mm/sec CNT10    ;
 278:J P[1040] 20% CNT20    ;
 279:  JMP LBL[1100] ;
 280:   ;
 281:  LBL[1100] ;
 282:  R[90:Program gestart]=1    ;
 283:  UFRAME_NUM=1 ;
 284:  UTOOL_NUM=1 ;
 285:J P[1:rust positie] 30% CNT100    ;
 286:  R[6:Aantal in hoogte]=25    ;
 287:  R[7:Steekhoogte]=6.9    ;
 288:  R[20:Act R6]=0    ;
 289:  R[40:Grijpfout centre]=0    ;
 290:  R[44:Transportbnd vol]=0    ;
 291:  R[46:Cyclusteller]=0    ;
 292:  R[47:Centrer niet vri]=0    ;
 293:  R[49:Snelheid]=90    ;
 294:   ;
 295:  DO[50:Rode lamp hek]=OFF ;
 296:  DO[51:IONblower Corona]=OFF ;
 297:   ;
 298:  DO[14321]=PULSE,6.0sec ;
 299:   ;
 300:  LBL[2000:Controle pos vry] ;
 301:  IF DI[23:Positioneer vrij]=ON,JMP LBL[2100] ;
 302:   ;
 303:  !AANSTURING SNAARBANDJE--- JA ;
 304:  !AANSTURING CORONA-------- JA ;
 305:  !AANSTURING ANTI STATIC--- JA ;
 306:  !AANSTURING WHITE STRIPE-- NEE ;
 307:  DO[15020]=ON ;
 308:  DO[15021]=OFF ;
 309:  DO[15022]=OFF ;
 310:  DO[15023]=OFF ;
 311:  DO[15024]=OFF ;
 312:  DO[15025]=OFF ;
 313:  DO[15026]=OFF ;
 314:  END ;
 315:   ;
 316:  LBL[2100:Opstart controle] ;
 317:  CALL TEKST(1300) ;
 318:  SO[6]=ON ;
 319:  WAIT SI[5]=ON    ;
 320:  SO[6]=OFF ;
 321:  JMP LBL[2000] ;
/POS
P[1:"rust positie"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   451.386  mm,	Y =     0.000  mm,	Z =   508.614  mm,
	W =   180.000 deg,	P =     -.000 deg,	R =   -90.000 deg
};
P[2]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   360.000  mm,	Y =   546.337  mm,	Z =   608.781  mm,
	W =   -92.208 deg,	P =   -89.784 deg,	R =   -87.705 deg
};
P[3:"naar SGM"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   279.404  mm,	Y =   418.185  mm,	Z =   527.595  mm,
	W =   179.916 deg,	P =   -27.516 deg,	R =     1.768 deg
};
P[4]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   360.000  mm,	Y =   546.337  mm,	Z =   608.781  mm,
	W =   -92.208 deg,	P =   -89.784 deg,	R =   -87.705 deg
};
P[6:"induik"]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   359.497  mm,	Y =   620.000  mm,	Z =   608.715  mm,
	W =   -92.553 deg,	P =   -89.788 deg,	R =   -87.360 deg
};
P[9:"voor pak"]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   360.000  mm,	Y =  1406.753  mm,	Z =   608.941  mm,
	W =   -92.666 deg,	P =   -89.786 deg,	R =   -87.243 deg
};
P[10:"pak pos"]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   397.207  mm,	Y =  1406.662  mm,	Z =   609.011  mm,
	W =   -92.662 deg,	P =   -89.786 deg,	R =   -87.247 deg
};
P[11:"na pak"]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   360.000  mm,	Y =  1406.753  mm,	Z =   608.941  mm,
	W =   -92.663 deg,	P =   -89.786 deg,	R =   -87.246 deg
};
P[15:"buiten SGM"]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   359.497  mm,	Y =   620.000  mm,	Z =   608.715  mm,
	W =   -92.553 deg,	P =   -89.788 deg,	R =   -87.360 deg
};
P[35:"dump producten"]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   549.400  mm,	Y =  -132.794  mm,	Z =   -13.417  mm,
	W =  -178.674 deg,	P =      .924 deg,	R =   -89.255 deg
};
P[50:"deurpos"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   490.878  mm,	Y =     -.047  mm,	Z =   490.627  mm,
	W =  -178.789 deg,	P =    -1.077 deg,	R =   -89.145 deg
};
P[1020]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =  -296.704  mm,	Y = -1115.888  mm,	Z =   458.703  mm,
	W =   104.187 deg,	P =   -88.533 deg,	R =   -13.993 deg
};
P[1021]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  -233.610  mm,	Y =  -852.463  mm,	Z =   572.444  mm,
	W =   179.176 deg,	P =     1.049 deg,	R =    90.938 deg
};
P[1030]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, -1',
	X =   246.757  mm,	Y =  -860.950  mm,	Z =   572.488  mm,
	W =  -179.824 deg,	P =      .482 deg,	R =    91.473 deg
};
P[1040]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   697.588  mm,	Y =  -751.315  mm,	Z =   576.336  mm,
	W =  -179.229 deg,	P =     3.619 deg,	R =   -89.301 deg
};
/END
