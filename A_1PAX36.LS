/PROG  A_1PAX36
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "Deksel steek 135";
PROG_SIZE	= 7064;
CREATE		= DATE 19-05-10  TIME 17:48:34;
MODIFIED	= DATE 19-05-15  TIME 19:35:04;
FILE_NAME	= A_1PAX36;
VERSION		= 0;
LINE_COUNT	= 355;
MEMORY_SIZE	= 7752;
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
   7:  IF R[90:Program gestart]=0,JMP LBL[1000] ;
   8:   ;
   9:  !START PROGRAMMA AFLOOP ;
  10:   ;
  11:  OVERRIDE=100% ;
  12:  CALL TEKST(3) ;
  13:  UFRAME_NUM=1 ;
  14:  UTOOL_NUM=1 ;
  15:J P[1:rust positie] 20% CNT100    ;
  16:   ;
  17:  !Grijpers open ;
  18:  Open hand 1    ;
  19:  Open hand 2    ;
  20:   ;
  21:  LBL[10:NAAR INDUIK] ;
  22:  IF DI[7:Automaat]=OFF,JMP LBL[530] ;
  23:  IF DI[6:Matrijs dicht]=ON,JMP LBL[15] ;
  24:  JMP LBL[10] ;
  25:   ;
  26:  LBL[15] ;
  27:  !Uitstoter terug ;
  28:  DO[11017]=OFF ;
  29:   ;
  30:J P[3:naar SGM] 30% CNT100    ;
  31:J P[6:induik] 30% CNT100    ;
  32:   ;
  33:  !GRIJPERS OPEN ;
  34:  Open hand 1    ;
  35:  Open hand 2    ;
  36:   ;
  37:  LBL[20:Cyclusteller] ;
  38:  R[46:Cyclusteller]=R[46:Cyclusteller]+1    ;
  39:   ;
  40:  $WAITTMOUT=500 ;
  41:  !Controle induikvoorwaarde ;
  42:  WAIT DO[11161]=ON TIMEOUT,LBL[570] ;
  43:  R[1:Cyclustijd]=TIMER[1]    ;
  44:   ;
  45:  LBL[25:Controle induik] ;
  46:  !Controle grijpers open ;
  47:  IF RI[1:Bek B Open]=OFF OR RI[3:Bek A Open]=OFF,JMP LBL[570] ;
  48:   ;
  49:  !Controle induikvoorwaarde ;
  50:  IF DO[11161]=OFF,JMP LBL[570] ;
  51:   ;
  52:  !Wacht op matrijs open ;
  53:  IF DO[11033]=ON,JMP LBL[30] ;
  54:   ;
  55:  !Check machine in automaat ;
  56:  IF DI[7:Automaat]=OFF,JMP LBL[530] ;
  57:  JMP LBL[25] ;
  58:   ;
  59:  LBL[30:UITNAME] ;
  60:  OVERRIDE=100% ;
  61:   ;
  62:  LBL[31] ;
  63:  TIMER[1]=RESET ;
  64:  !Uitstoter naar voren ;
  65:  DO[11017]=PULSE,0.2sec ;
  66:L P[9:voor pak] 2000mm/sec CNT10    ;
  67:   ;
  68:  !Tak weg drukken ;
  69:L P[2:Takpos ] 1000mm/sec FINE    ;
  70:L P[9:voor pak] 500mm/sec CNT10    ;
  71:   ;
  72:L P[10:pak pos] 500mm/sec FINE    ;
  73:   ;
  74:  !Grijpers dicht ;
  75:  Close hand 2    ;
  76:   ;
  77:  !Paktijd vertraging  ;
  78:  WAIT R[5] ;
  79:L P[11:na pak] 250mm/sec CNT30    ;
  80:   ;
  81:  !Uitstoter terug ;
  82:  DO[11017]=OFF ;
  83:   ;
  84:  !TAK WEGPAKKEN ;
  85:   ;
  86:L P[15:buiten SGM] 2000mm/sec CNT100    ;
  87:   ;
  88:  !% Snelheid = register 49 ;
  89:  OVERRIDE=R[49:Snelheid] ;
  90:   ;
  91:  LBL[40:UITNAME CONTROLE] ;
  92:  IF RI[3:Bek A Open]=OFF AND RI[4:Bek A product aanwezig]=ON,JMP LBL[50] ;
  93:  IF R[100:Product controle]>1,JMP LBL[500] ;
  94:  WAIT    .01(sec) ;
  95:  R[100:Product controle]=R[100:Product controle]+.01    ;
  96:  JMP LBL[40] ;
  97:   ;
  98:  LBL[50:UITNAME OK ] ;
  99:  R[100:Product controle]=0    ;
 100:   ;
 101:  !Spuitgietmachine sluiten ;
 102:  DO[11025]=PULSE,0.5sec ;
 103:  R[2:Induiktijd]=TIMER[1]    ;
 104:  IF DI[10:Fout product]=ON,JMP LBL[510] ;
 105:J P[50:deurpos] 80% CNT80    ;
 106:   ;
 107:  LBL[60:OPSTART AFKEUR] ;
 108:  IF R[10:Opstart aantal]=0,JMP LBL[200] ;
 109:  IF R[29:Start afleg]=0,JMP LBL[510] ;
 110:   ;
 111:  !TUSSEPOSITIONEREN ;
 112:  LBL[200] ;
 113:  CALL POSITIE4    ;
 114:   ;
 115:  !Controle fouten na centreren ;
 116:  IF R[40:Grijpfout centre]=1,JMP LBL[505] ;
 117:  IF R[47:Centrer niet vri]=1,JMP LBL[735] ;
 118:   ;
 119:  !STAPELEN DEKSELS ;
 120:  LBL[310] ;
 121:  CALL STAPELEN    ;
 122:  UFRAME_NUM=1 ;
 123:   ;
 124:  !Controle fouten na stapelen ;
 125:  IF R[44:Transportbnd vol]=1,JMP LBL[760] ;
 126:   ;
 127:  !Naar begin programma ;
 128:  LBL[490] ;
 129:  UFRAME_NUM=1 ;
 130:   ;
 131:J P[50:deurpos] 70% CNT60    ;
 132:  Open hand 1    ;
 133:  Open hand 2    ;
 134:J P[3:naar SGM] 70% CNT60    ;
 135:J P[6:induik] 60% CNT100    ;
 136:  JMP LBL[20] ;
 137:   ;
 138:   ;
 139:  !******STORINGEN****** ;
 140:   ;
 141:  LBL[500:UITNAME FOUT] ;
 142:  CALL TEKST(500) ;
 143:  R[100:Product controle]=0    ;
 144:J P[1:rust positie] 30% FINE    ;
 145:  Open hand 1    ;
 146:  Open hand 2    ;
 147:  WAIT DI[7:Automaat]=OFF    ;
 148:   ;
 149:  !Lamp USER 2 AAN op fanuc kast ;
 150:  DO[54:User2]=ON ;
 151:  WAIT DI[45:USER 2]=ON    ;
 152:   ;
 153:  !Lamp USER 2 AAN op fanuc kast ;
 154:  DO[54:User2]=OFF ;
 155:  END ;
 156:   ;
 157:  LBL[505:GRIJPFOUT CNTRER] ;
 158:  CALL TEKST(510) ;
 159:  R[100:Product controle]=0    ;
 160:  R[40:Grijpfout centre]=0    ;
 161:J P[1:rust positie] 30% FINE    ;
 162:  Open hand 1    ;
 163:  Open hand 2    ;
 164:  WAIT DI[7:Automaat]=OFF    ;
 165:   ;
 166:  !Lamp USER 2 AAN op fanuc kast ;
 167:  DO[54:User2]=ON ;
 168:  WAIT DI[45:USER 2]=ON    ;
 169:   ;
 170:  !Lamp USER 2 AAN op fanuc kast ;
 171:  DO[54:User2]=OFF ;
 172:  END ;
 173:   ;
 174:  LBL[510:DUMPEN PRODUCTEN] ;
 175:J P[50:deurpos] 65% CNT50    ;
 176:L P[35:dump producten] 600mm/sec CNT5    ;
 177:  Open hand 1    ;
 178:  Open hand 2    ;
 179:  R[28:Act dump]=R[28:Act dump]+1    ;
 180:  WAIT    .50(sec) ;
 181:L P[1:rust positie] 600mm/sec CNT100    ;
 182:J P[3:naar SGM] 30% FINE    ;
 183:J P[6:induik] 30% FINE    ;
 184:  IF R[28:Act dump]>=R[10:Opstart aantal],JMP LBL[520] ;
 185:  JMP LBL[20] ;
 186:  LBL[520] ;
 187:  R[29:Start afleg]=1    ;
 188:  JMP LBL[20] ;
 189:   ;
 190:  LBL[530:SGM UIT AUTOMAAT] ;
 191:  R[100:Product controle]=0    ;
 192:J P[1:rust positie] 30% FINE    ;
 193:  DO[52:IONblower witband]=OFF ;
 194:  END ;
 195:   ;
 196:  LBL[570] ;
 197:J P[3:naar SGM] 65% CNT100    ;
 198:   ;
 199:  LBL[580:Gryprfout induik] ;
 200:  CALL TEKST(581) ;
 201:J P[1:rust positie] 30% FINE    ;
 202:  Open hand 1    ;
 203:  Open hand 2    ;
 204:   ;
 205:  WAIT DI[7:Automaat]=OFF    ;
 206:  !Lamp USER 2 AAN op fanuc kast ;
 207:  DO[54:User2]=ON ;
 208:  WAIT DI[45:USER 2]=ON    ;
 209:   ;
 210:  !Lamp USER 2 AAN op fanuc kast ;
 211:  DO[54:User2]=OFF ;
 212:  END ;
 213:   ;
 214:  LBL[735:Centrer niet vry] ;
 215:  CALL TEKST(735) ;
 216:  R[47:Centrer niet vri]=0    ;
 217:J P[1:rust positie] 30% FINE    ;
 218:  Open hand 1    ;
 219:  Open hand 2    ;
 220:  WAIT    .50(sec) ;
 221:  WAIT DI[7:Automaat]=OFF    ;
 222:   ;
 223:  !Lamp USER 2 AAN op fanuc kast ;
 224:  DO[54:User2]=ON ;
 225:  WAIT DI[45:USER 2]=ON    ;
 226:   ;
 227:  !Lamp USER 2 AAN op fanuc kast ;
 228:  DO[54:User2]=OFF ;
 229:  END ;
 230:   ;
 231:  LBL[760:Band vol] ;
 232:  CALL TEKST(760) ;
 233:J P[1:rust positie] 30% FINE    ;
 234:  Open hand 1    ;
 235:  Open hand 2    ;
 236:  R[44:Transportbnd vol]=0    ;
 237:   ;
 238:  WAIT DI[7:Automaat]=OFF    ;
 239:   ;
 240:  !Lamp USER 2 AAN op fanuc kast ;
 241:  DO[54:User2]=ON ;
 242:  WAIT DI[45:USER 2]=ON    ;
 243:   ;
 244:  !Lamp USER 2 AAN op fanuc kast ;
 245:  DO[54:User2]=OFF ;
 246:  END ;
 247:   ;
 248:  !******HOME ZOEKEN****** ;
 249:  LBL[1000:HOME ZOEKEN] ;
 250:  CALL TEKST(1000) ;
 251:  PAYLOAD[1] ;
 252:  OVERRIDE=25% ;
 253:  PR[100:Home Lpos]=LPOS    ;
 254:  R[200:Homezoek X]=PR[100,1:Home Lpos]    ;
 255:  R[199:Homezoek Y]=PR[100,2:Home Lpos]    ;
 256:  R[198:Homezoek Z]=PR[100,3:Home Lpos]    ;
 257:   ;
 258:  PR[99:Home Jpos]=JPOS    ;
 259:  R[193:J4]=PR[99,4:Home Jpos]    ;
 260:  R[194:J6]=PR[99,6:Home Jpos]    ;
 261:   ;
 262:  R[189:Act Uframe]=$MNUFRAMENUM[1] ;
 263:  R[188:Act Utool]=$MNUTOOLNUM[1] ;
 264:   ;
 265:  PR[97:P6]=P[6:induik]    ;
 266:  R[192:P6-Y]=PR[97,2:P6]    ;
 267:  R[192:P6-Y]=R[192:P6-Y]+10    ;
 268:  PR[96:P11]=P[11:na pak]    ;
 269:  R[191:P11-X]=PR[96,1:P11]    ;
 270:   ;
 271:  IF DO[100:Robot op reference]=ON,JMP LBL[1100] ;
 272:   ;
 273:  !--------------- ;
 274:  !--- ;
 275:  IF R[199:Homezoek Y]<500,JMP LBL[1010] ;
 276:  !--------------- ;
 277:   ;
 278:   ;
 279:   ;
 280:  IF R[199:Homezoek Y]<R[192:P6-Y],JMP LBL[1006] ;
 281:   ;
 282:  IF DI[1:Matrijs open]=ON,JMP LBL[1001] ;
 283:  CALL TEKST(1001) ;
 284:  WAIT DI[1:Matrijs open]=ON AND DI[3:Uitw. terug]=ON    ;
 285:   ;
 286:  LBL[1001] ;
 287:  PR[100,1:Home Lpos]=R[191:P11-X]    ;
 288:L PR[100:Home Lpos] 100mm/sec CNT20    ;
 289:  LBL[1005] ;
 290:  UTOOL_NUM=1 ;
 291:L P[15:buiten SGM] 300mm/sec FINE    ;
 292:   ;
 293:  LBL[1006:Buiten SGM] ;
 294:L P[15:buiten SGM] 300mm/sec FINE    ;
 295:J P[3:naar SGM] 15% FINE    ;
 296:  JMP LBL[1100] ;
 297:   ;
 298:  !---------------- ;
 299:  !--- ;
 300:  LBL[1010] ;
 301:  CALL HOMEN    ;
 302:  JMP LBL[1100] ;
 303:  !--------------- ;
 304:   ;
 305:   ;
 306:  LBL[1100] ;
 307:  R[90:Program gestart]=1    ;
 308:  UFRAME_NUM=1 ;
 309:  UTOOL_NUM=1 ;
 310:J P[1:rust positie] 30% CNT100    ;
 311:   ;
 312:  !Grijpers open ;
 313:  Open hand 1    ;
 314:  Open hand 2    ;
 315:   ;
 316:  R[4:Vertr pakken]=.5    ;
 317:  R[6:Aantal in hoogte]=25    ;
 318:  R[7:Steekhoogte]=8.15    ;
 319:  R[20:Act R6]=0    ;
 320:  R[40:Grijpfout centre]=0    ;
 321:  R[44:Transportbnd vol]=0    ;
 322:  R[46:Cyclusteller]=0    ;
 323:  R[47:Centrer niet vri]=0    ;
 324:  R[49:Snelheid]=60    ;
 325:   ;
 326:  DO[49:Buzzer hek]=OFF ;
 327:  DO[50:Rode lamp hek]=OFF ;
 328:   ;
 329:  DO[14321]=PULSE,6.0sec ;
 330:   ;
 331:  LBL[2000:Controle pos vry] ;
 332:  IF DI[23:Positioneer vrij]=ON,JMP LBL[2100] ;
 333:   ;
 334:  !AANSTURING SNAARBANDJE--- JA ;
 335:  !AANSTURING CORONA-------- JA ;
 336:  !AANSTURING ANTI STATIC--- JA ;
 337:  !AANSTURING WHITE STRIPE-- NEE ;
 338:  DO[15020]=ON ;
 339:  DO[15021]=OFF ;
 340:  DO[15022]=OFF ;
 341:  DO[15023]=OFF ;
 342:  DO[15024]=OFF ;
 343:  DO[15025]=OFF ;
 344:  DO[15026]=OFF ;
 345:  END ;
 346:   ;
 347:  LBL[2100:Opstart controle] ;
 348:  CALL TEKST(1300) ;
 349:  !Lamp USER 2 AAN op fanuc kast ;
 350:  DO[54:User2]=ON ;
 351:  WAIT DI[45:USER 2]=ON    ;
 352:   ;
 353:  !Lamp USER 2 AAN op fanuc kast ;
 354:  DO[54:User2]=OFF ;
 355:  JMP LBL[2000] ;
/POS
P[1:"rust positie"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   451.205  mm,	Y =      .013  mm,	Z =   354.127  mm,
	W =   179.900 deg,	P =     -.000 deg,	R =   -90.100 deg
};
P[2:"Takpos "]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   260.351  mm,	Y =  1318.402  mm,	Z =   610.281  mm,
	W =   -83.486 deg,	P =   -89.287 deg,	R =   -96.455 deg
};
P[3:"naar SGM"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   279.404  mm,	Y =   418.185  mm,	Z =   527.595  mm,
	W =   179.916 deg,	P =   -27.516 deg,	R =     1.768 deg
};
P[6:"induik"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   260.000  mm,	Y =   650.000  mm,	Z =   610.350  mm,
	W =   -83.262 deg,	P =   -89.285 deg,	R =   -96.679 deg
};
P[9:"voor pak"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   260.000  mm,	Y =  1272.700  mm,	Z =   610.300  mm,
	W =   -83.419 deg,	P =   -89.287 deg,	R =   -96.521 deg
};
P[10:"pak pos"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   285.932  mm,	Y =  1272.700  mm,	Z =   610.300  mm,
	W =   -83.421 deg,	P =   -89.287 deg,	R =   -96.520 deg
};
P[11:"na pak"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   250.000  mm,	Y =  1272.699  mm,	Z =   610.300  mm,
	W =   -83.418 deg,	P =   -89.287 deg,	R =   -96.523 deg
};
P[15:"buiten SGM"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   250.000  mm,	Y =   700.000  mm,	Z =   610.300  mm,
	W =   -83.418 deg,	P =   -89.287 deg,	R =   -96.523 deg
};
P[35:"dump producten"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   558.628  mm,	Y =  -145.606  mm,	Z =  -189.436  mm,
	W =   179.900 deg,	P =     -.000 deg,	R =   -90.100 deg
};
P[50:"deurpos"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   436.228  mm,	Y =      .013  mm,	Z =   420.765  mm,
	W =   179.900 deg,	P =     -.000 deg,	R =   -90.100 deg
};
/END
