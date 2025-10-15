/PROG  A_1PAX08
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "Deksel steek 135";
PROG_SIZE	= 6909;
CREATE		= DATE 19-05-17  TIME 15:13:38;
MODIFIED	= DATE 19-05-17  TIME 19:39:04;
FILE_NAME	= A_1PAX36;
VERSION		= 0;
LINE_COUNT	= 348;
MEMORY_SIZE	= 7497;
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
  67:L P[10:pak pos] 500mm/sec FINE    ;
  68:   ;
  69:  !Grijpers dicht ;
  70:  Close hand 2    ;
  71:   ;
  72:  !Paktijd vertraging  ;
  73:  WAIT R[5] ;
  74:L P[11:na pak] 250mm/sec CNT30    ;
  75:   ;
  76:  !Uitstoter terug ;
  77:  DO[11017]=OFF ;
  78:   ;
  79:L P[15:buiten SGM] 2000mm/sec CNT100    ;
  80:   ;
  81:  !% Snelheid = register 49 ;
  82:  OVERRIDE=R[49:Snelheid] ;
  83:   ;
  84:  LBL[40:UITNAME CONTROLE] ;
  85:  IF RI[3:Bek A Open]=OFF AND RI[4:Bek A product aanwezig]=ON,JMP LBL[50] ;
  86:  IF R[100:Product controle]>1,JMP LBL[500] ;
  87:  WAIT    .01(sec) ;
  88:  R[100:Product controle]=R[100:Product controle]+.01    ;
  89:  JMP LBL[40] ;
  90:   ;
  91:  LBL[50:UITNAME OK ] ;
  92:  R[100:Product controle]=0    ;
  93:   ;
  94:  !Spuitgietmachine sluiten ;
  95:  DO[11025]=PULSE,0.5sec ;
  96:  R[2:Induiktijd]=TIMER[1]    ;
  97:  IF DI[10:Fout product]=ON,JMP LBL[510] ;
  98:J P[50:deurpos] 80% CNT80    ;
  99:   ;
 100:  LBL[60:OPSTART AFKEUR] ;
 101:  IF R[10:Opstart aantal]=0,JMP LBL[200] ;
 102:  IF R[29:Start afleg]=0,JMP LBL[510] ;
 103:   ;
 104:  !TUSSEPOSITIONEREN ;
 105:  LBL[200] ;
 106:  CALL POSITIE4    ;
 107:   ;
 108:  !Controle fouten na centreren ;
 109:  IF R[40:Grijpfout centre]=1,JMP LBL[505] ;
 110:  IF R[47:Centrer niet vri]=1,JMP LBL[735] ;
 111:   ;
 112:  !STAPELEN DEKSELS ;
 113:  LBL[310] ;
 114:  CALL STAPELEN    ;
 115:  UFRAME_NUM=1 ;
 116:   ;
 117:  !Controle fouten na stapelen ;
 118:  IF R[44:Transportbnd vol]=1,JMP LBL[760] ;
 119:   ;
 120:  !Naar begin programma ;
 121:  LBL[490] ;
 122:  UFRAME_NUM=1 ;
 123:   ;
 124:J P[50:deurpos] 70% CNT60    ;
 125:  Open hand 1    ;
 126:  Open hand 2    ;
 127:J P[3:naar SGM] 70% CNT60    ;
 128:J P[6:induik] 60% CNT100    ;
 129:  JMP LBL[20] ;
 130:   ;
 131:   ;
 132:  !******STORINGEN****** ;
 133:   ;
 134:  LBL[500:UITNAME FOUT] ;
 135:  CALL TEKST(500) ;
 136:  R[100:Product controle]=0    ;
 137:J P[1:rust positie] 30% FINE    ;
 138:  Open hand 1    ;
 139:  Open hand 2    ;
 140:  WAIT DI[7:Automaat]=OFF    ;
 141:   ;
 142:  !Lamp USER 2 AAN op fanuc kast ;
 143:  DO[54:User2]=ON ;
 144:  WAIT DI[45:USER 2]=ON    ;
 145:   ;
 146:  !Lamp USER 2 AAN op fanuc kast ;
 147:  DO[54:User2]=OFF ;
 148:  END ;
 149:   ;
 150:  LBL[505:GRIJPFOUT CNTRER] ;
 151:  CALL TEKST(510) ;
 152:  R[100:Product controle]=0    ;
 153:  R[40:Grijpfout centre]=0    ;
 154:J P[1:rust positie] 30% FINE    ;
 155:  Open hand 1    ;
 156:  Open hand 2    ;
 157:  WAIT DI[7:Automaat]=OFF    ;
 158:   ;
 159:  !Lamp USER 2 AAN op fanuc kast ;
 160:  DO[54:User2]=ON ;
 161:  WAIT DI[45:USER 2]=ON    ;
 162:   ;
 163:  !Lamp USER 2 AAN op fanuc kast ;
 164:  DO[54:User2]=OFF ;
 165:  END ;
 166:   ;
 167:  LBL[510:DUMPEN PRODUCTEN] ;
 168:J P[50:deurpos] 65% CNT50    ;
 169:L P[35:dump producten] 600mm/sec CNT5    ;
 170:  Open hand 1    ;
 171:  Open hand 2    ;
 172:  R[28:Act dump]=R[28:Act dump]+1    ;
 173:  WAIT    .50(sec) ;
 174:L P[1:rust positie] 600mm/sec CNT100    ;
 175:J P[3:naar SGM] 30% FINE    ;
 176:J P[6:induik] 30% FINE    ;
 177:  IF R[28:Act dump]>=R[10:Opstart aantal],JMP LBL[520] ;
 178:  JMP LBL[20] ;
 179:  LBL[520] ;
 180:  R[29:Start afleg]=1    ;
 181:  JMP LBL[20] ;
 182:   ;
 183:  LBL[530:SGM UIT AUTOMAAT] ;
 184:  R[100:Product controle]=0    ;
 185:J P[1:rust positie] 30% FINE    ;
 186:  DO[52:IONblower witband]=OFF ;
 187:  END ;
 188:   ;
 189:  LBL[570] ;
 190:J P[3:naar SGM] 65% CNT100    ;
 191:   ;
 192:  LBL[580:Gryprfout induik] ;
 193:  CALL TEKST(581) ;
 194:J P[1:rust positie] 30% FINE    ;
 195:  Open hand 1    ;
 196:  Open hand 2    ;
 197:   ;
 198:  WAIT DI[7:Automaat]=OFF    ;
 199:  !Lamp USER 2 AAN op fanuc kast ;
 200:  DO[54:User2]=ON ;
 201:  WAIT DI[45:USER 2]=ON    ;
 202:   ;
 203:  !Lamp USER 2 AAN op fanuc kast ;
 204:  DO[54:User2]=OFF ;
 205:  END ;
 206:   ;
 207:  LBL[735:Centrer niet vry] ;
 208:  CALL TEKST(735) ;
 209:  R[47:Centrer niet vri]=0    ;
 210:J P[1:rust positie] 30% FINE    ;
 211:  Open hand 1    ;
 212:  Open hand 2    ;
 213:  WAIT    .50(sec) ;
 214:  WAIT DI[7:Automaat]=OFF    ;
 215:   ;
 216:  !Lamp USER 2 AAN op fanuc kast ;
 217:  DO[54:User2]=ON ;
 218:  WAIT DI[45:USER 2]=ON    ;
 219:   ;
 220:  !Lamp USER 2 AAN op fanuc kast ;
 221:  DO[54:User2]=OFF ;
 222:  END ;
 223:   ;
 224:  LBL[760:Band vol] ;
 225:  CALL TEKST(760) ;
 226:J P[1:rust positie] 30% FINE    ;
 227:  Open hand 1    ;
 228:  Open hand 2    ;
 229:  R[44:Transportbnd vol]=0    ;
 230:   ;
 231:  WAIT DI[7:Automaat]=OFF    ;
 232:   ;
 233:  !Lamp USER 2 AAN op fanuc kast ;
 234:  DO[54:User2]=ON ;
 235:  WAIT DI[45:USER 2]=ON    ;
 236:   ;
 237:  !Lamp USER 2 AAN op fanuc kast ;
 238:  DO[54:User2]=OFF ;
 239:  END ;
 240:   ;
 241:  !******HOME ZOEKEN****** ;
 242:  LBL[1000:HOME ZOEKEN] ;
 243:  CALL TEKST(1000) ;
 244:  PAYLOAD[1] ;
 245:  OVERRIDE=25% ;
 246:  PR[100:Home Lpos]=LPOS    ;
 247:  R[200:Homezoek X]=PR[100,1:Home Lpos]    ;
 248:  R[199:Homezoek Y]=PR[100,2:Home Lpos]    ;
 249:  R[198:Homezoek Z]=PR[100,3:Home Lpos]    ;
 250:   ;
 251:  PR[99:Home Jpos]=JPOS    ;
 252:  R[193:J4]=PR[99,4:Home Jpos]    ;
 253:  R[194:J6]=PR[99,6:Home Jpos]    ;
 254:   ;
 255:  R[189:Act Uframe]=$MNUFRAMENUM[1] ;
 256:  R[188:Act Utool]=$MNUTOOLNUM[1] ;
 257:   ;
 258:  PR[97:P6]=P[6:induik]    ;
 259:  R[192:P6-Y]=PR[97,2:P6]    ;
 260:  R[192:P6-Y]=R[192:P6-Y]+10    ;
 261:  PR[96:P11]=P[11:na pak]    ;
 262:  R[191:P11-X]=PR[96,1:P11]    ;
 263:   ;
 264:  IF DO[100:Robot op reference]=ON,JMP LBL[1100] ;
 265:   ;
 266:  !--------------- ;
 267:  !--- ;
 268:  IF R[199:Homezoek Y]<500,JMP LBL[1010] ;
 269:  !--------------- ;
 270:   ;
 271:   ;
 272:   ;
 273:  IF R[199:Homezoek Y]<R[192:P6-Y],JMP LBL[1006] ;
 274:   ;
 275:  IF DI[1:Matrijs open]=ON,JMP LBL[1001] ;
 276:  CALL TEKST(1001) ;
 277:  WAIT DI[1:Matrijs open]=ON AND DI[3:Uitw. terug]=ON    ;
 278:   ;
 279:  LBL[1001] ;
 280:  PR[100,1:Home Lpos]=R[191:P11-X]    ;
 281:L PR[100:Home Lpos] 100mm/sec CNT20    ;
 282:  LBL[1005] ;
 283:  UTOOL_NUM=1 ;
 284:L P[15:buiten SGM] 300mm/sec FINE    ;
 285:   ;
 286:  LBL[1006:Buiten SGM] ;
 287:L P[15:buiten SGM] 300mm/sec FINE    ;
 288:J P[3:naar SGM] 15% FINE    ;
 289:  JMP LBL[1100] ;
 290:   ;
 291:  !---------------- ;
 292:  !--- ;
 293:  LBL[1010] ;
 294:  CALL HOMEN    ;
 295:  JMP LBL[1100] ;
 296:  !--------------- ;
 297:   ;
 298:   ;
 299:  LBL[1100] ;
 300:  R[90:Program gestart]=1    ;
 301:  UFRAME_NUM=1 ;
 302:  UTOOL_NUM=1 ;
 303:J P[1:rust positie] 30% CNT100    ;
 304:   ;
 305:  !Grijpers open ;
 306:  Open hand 1    ;
 307:  Open hand 2    ;
 308:   ;
 309:  R[4:Vertr pakken]=.5    ;
 310:  R[6:Aantal in hoogte]=20    ;
 311:  R[7:Steekhoogte]=12    ;
 312:  R[20:Act R6]=0    ;
 313:  R[40:Grijpfout centre]=0    ;
 314:  R[44:Transportbnd vol]=0    ;
 315:  R[46:Cyclusteller]=0    ;
 316:  R[47:Centrer niet vri]=0    ;
 317:  R[49:Snelheid]=60    ;
 318:   ;
 319:  DO[49:Buzzer hek]=OFF ;
 320:  DO[50:Rode lamp hek]=OFF ;
 321:   ;
 322:  DO[14321]=PULSE,6.0sec ;
 323:   ;
 324:  LBL[2000:Controle pos vry] ;
 325:  IF DI[23:Positioneer vrij]=ON,JMP LBL[2100] ;
 326:   ;
 327:  !AANSTURING SNAARBANDJE--- JA ;
 328:  !AANSTURING CORONA-------- JA ;
 329:  !AANSTURING ANTI STATIC--- JA ;
 330:  !AANSTURING WHITE STRIPE-- NEE ;
 331:  DO[15020]=ON ;
 332:  DO[15021]=OFF ;
 333:  DO[15022]=OFF ;
 334:  DO[15023]=OFF ;
 335:  DO[15024]=OFF ;
 336:  DO[15025]=OFF ;
 337:  DO[15026]=OFF ;
 338:  END ;
 339:   ;
 340:  LBL[2100:Opstart controle] ;
 341:  CALL TEKST(1300) ;
 342:  !Lamp USER 2 AAN op fanuc kast ;
 343:  DO[54:User2]=ON ;
 344:  WAIT DI[45:USER 2]=ON    ;
 345:   ;
 346:  !Lamp USER 2 AAN op fanuc kast ;
 347:  DO[54:User2]=OFF ;
 348:  JMP LBL[2000] ;
/POS
P[1:"rust positie"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   451.205  mm,	Y =      .013  mm,	Z =   354.127  mm,
	W =   179.900 deg,	P =     -.000 deg,	R =   -90.100 deg
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
	X =   250.000  mm,	Y =   650.000  mm,	Z =   610.350  mm,
	W =   -83.262 deg,	P =   -89.285 deg,	R =   -96.679 deg
};
P[9:"voor pak"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   250.000  mm,	Y =  1253.810  mm,	Z =   610.185  mm,
	W =   -83.614 deg,	P =   -89.291 deg,	R =   -96.327 deg
};
P[10:"pak pos"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   278.418  mm,	Y =  1253.837  mm,	Z =   610.144  mm,
	W =   -83.726 deg,	P =   -89.289 deg,	R =   -96.215 deg
};
P[11:"na pak"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   250.000  mm,	Y =  1253.810  mm,	Z =   610.185  mm,
	W =   -83.612 deg,	P =   -89.291 deg,	R =   -96.329 deg
};
P[15:"buiten SGM"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   250.000  mm,	Y =   700.000  mm,	Z =   610.185  mm,
	W =   -83.612 deg,	P =   -89.291 deg,	R =   -96.329 deg
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
