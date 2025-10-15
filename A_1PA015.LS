/PROG  A_1PA015
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "Plate b";
PROG_SIZE	= 10385;
CREATE		= DATE 19-05-03  TIME 20:08:00;
MODIFIED	= DATE 19-05-03  TIME 20:21:56;
FILE_NAME	= Z_1PA015;
VERSION		= 0;
LINE_COUNT	= 520;
MEMORY_SIZE	= 11201;
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
   4:  !PLATE B MATRIJS  ;
   5:  !INCL. STAPELMALLEN ;
   6:   ;
   7:  PAYLOAD[1] ;
   8:  UFRAME_NUM=1 ;
   9:  UTOOL_NUM=1 ;
  10:   ;
  11:  IF R[90:Program gestart]=0,JMP LBL[1000] ;
  12:   ;
  13:  !START PROGRAMMA AFLOOP ;
  14:   ;
  15:  OVERRIDE=100% ;
  16:  CALL TEKST(3) ;
  17:  UFRAME_NUM=1 ;
  18:  UTOOL_NUM=1 ;
  19:J P[1:rust positie] 20% CNT100    ;
  20:   ;
  21:  !Grijpers open ;
  22:  RO[5:Vacuum 1]=OFF ;
  23:  RO[6:Vacuum 2]=OFF ;
  24:   ;
  25:  LBL[10:NAAR INDUIK] ;
  26:  IF DI[7:Automaat]=OFF,JMP LBL[530] ;
  27:  IF DI[6:Matrijs dicht]=ON,JMP LBL[15] ;
  28:  JMP LBL[10] ;
  29:   ;
  30:  LBL[15] ;
  31:  !Uitstoter terug ;
  32:  DO[11017]=OFF ;
  33:J P[3:naar SGM] 30% CNT100    ;
  34:J P[6:induik] 30% CNT100    ;
  35:   ;
  36:  !GRIJPERS OPEN ;
  37:  RO[5:Vacuum 1]=OFF ;
  38:  RO[6:Vacuum 2]=OFF ;
  39:   ;
  40:  LBL[20:Cyclusteller] ;
  41:  DO[10:Vacuumpomp]=ON ;
  42:  R[1:Cyclustijd]=TIMER[1]    ;
  43:   ;
  44:  LBL[25] ;
  45:  !Controle induikvoorwaarde ;
  46:  IF RI[5:Vacuum 1]=ON OR RI[6:Vacuum 2]=ON,JMP LBL[570] ;
  47:   ;
  48:  !Wacht op matrijs open ;
  49:  IF DO[11033]=ON,JMP LBL[30] ;
  50:   ;
  51:  !Check machine in automaat ;
  52:  IF DI[7:Automaat]=OFF,JMP LBL[530] ;
  53:  JMP LBL[25] ;
  54:   ;
  55:  LBL[30:UITNAME] ;
  56:  OVERRIDE=100% ;
  57:  TIMER[1]=RESET ;
  58:   ;
  59:  !UITNEMEN PRODUCT ;
  60:L P[9:voor pak] 1500mm/sec CNT10    ;
  61:L P[10:pak pos] 500mm/sec FINE    ;
  62:  RO[5:Vacuum 1]=ON ;
  63:  RO[6:Vacuum 2]=ON ;
  64:   ;
  65:  !Uitstoter naar voren ;
  66:  DO[11017]=PULSE,0.2sec ;
  67:   ;
  68:  WAIT    .20(sec) ;
  69:L P[11:voor pak] 500mm/sec CNT10    ;
  70:  !Uitstoter terug ;
  71:  DO[11017]=OFF ;
  72:L P[15:buiten SGM] 1500mm/sec CNT10    ;
  73:   ;
  74:  !% Snelheid = register 49 ;
  75:  OVERRIDE=R[49:Snelheid] ;
  76:   ;
  77:  LBL[40:UITNAME CONTROLE] ;
  78:  IF RI[5:Vacuum 1]=ON AND RI[6:Vacuum 2]=ON,JMP LBL[50] ;
  79:  IF R[100:Product controle]>1,JMP LBL[500] ;
  80:  WAIT    .01(sec) ;
  81:  R[100:Product controle]=R[100:Product controle]+.01    ;
  82:  JMP LBL[40] ;
  83:   ;
  84:  LBL[50:UITNAME OK ] ;
  85:  R[100:Product controle]=0    ;
  86:   ;
  87:  !Spuitgietmachine sluiten ;
  88:  DO[11025]=PULSE,0.5sec ;
  89:  R[2:Induiktijd]=TIMER[1]    ;
  90:  IF DI[10:Fout product]=ON,JMP LBL[510] ;
  91:J P[50:deurpos] 100% CNT80    ;
  92:   ;
  93:  LBL[60:OPSTART AFKEUR] ;
  94:  IF R[10:Opstart aantal]=0,JMP LBL[598] ;
  95:  IF R[29:Start afleg]=0,JMP LBL[510] ;
  96:   ;
  97:  !AFLEGGEN OP  BAND ;
  98:  LBL[598] ;
  99:  CALL B_DUMP1    ;
 100:  JMP LBL[490] ;
 101:   ;
 102:  !AFKOELEN  ;
 103:  LBL[599] ;
 104:  DO[51:IONblower Corona]=ON ;
 105:  DO[52:IONblower witband]=ON ;
 106:J P[4:Naar witte band] 95% CNT100    ;
 107:J P[5:Boven band] 95% CNT95    ;
 108:   ;
 109:  IF R[140:Afleg 1]=0,JMP LBL[600] ;
 110:  IF R[141:Afleg 2]=0,JMP LBL[601] ;
 111:  IF R[142:Afleg 3]=0,JMP LBL[602] ;
 112:  IF R[143:Afleg 4]=0,JMP LBL[603] ;
 113:   ;
 114:  LBL[600:Afleg 1] ;
 115:L P[7:Afleg 1] 1000mm/sec CNT100 Offset,PR[82:Boven afleg]    ;
 116:L P[7:Afleg 1] 300mm/sec FINE    ;
 117:  WAIT    .25(sec) ;
 118:  RO[5:Vacuum 1]=OFF ;
 119:  RO[6:Vacuum 2]=OFF ;
 120:  WAIT    .50(sec) ;
 121:L P[7:Afleg 1] 1000mm/sec CNT100 Offset,PR[82:Boven afleg]    ;
 122:  R[140:Afleg 1]=1    ;
 123:  JMP LBL[605] ;
 124:   ;
 125:  LBL[601:Afleg 2] ;
 126:L P[8:Afleg 2] 1000mm/sec CNT100 Offset,PR[82:Boven afleg]    ;
 127:L P[8:Afleg 2] 300mm/sec FINE    ;
 128:  WAIT    .25(sec) ;
 129:  RO[5:Vacuum 1]=OFF ;
 130:  RO[6:Vacuum 2]=OFF ;
 131:  WAIT    .50(sec) ;
 132:L P[8:Afleg 2] 1000mm/sec CNT100 Offset,PR[82:Boven afleg]    ;
 133:  R[141:Afleg 2]=1    ;
 134:  JMP LBL[605] ;
 135:   ;
 136:  LBL[602:Afleg 3] ;
 137:L P[12:Afleg 3] 1000mm/sec CNT100 Offset,PR[82:Boven afleg]    ;
 138:L P[12:Afleg 3] 300mm/sec FINE    ;
 139:  WAIT    .25(sec) ;
 140:  RO[5:Vacuum 1]=OFF ;
 141:  RO[6:Vacuum 2]=OFF ;
 142:  WAIT    .50(sec) ;
 143:L P[12:Afleg 3] 1000mm/sec CNT100 Offset,PR[82:Boven afleg]    ;
 144:  R[142:Afleg 3]=1    ;
 145:  JMP LBL[605] ;
 146:   ;
 147:  LBL[603:Afleg 4] ;
 148:L P[16:Afleg 4] 1000mm/sec CNT100 Offset,PR[82:Boven afleg]    ;
 149:L P[16:Afleg 4] 300mm/sec FINE    ;
 150:  WAIT    .25(sec) ;
 151:  RO[5:Vacuum 1]=OFF ;
 152:  RO[6:Vacuum 2]=OFF ;
 153:  WAIT    .50(sec) ;
 154:L P[16:Afleg 4] 1000mm/sec CNT100 Offset,PR[82:Boven afleg]    ;
 155:  R[143:Afleg 4]=1    ;
 156:  JMP LBL[605] ;
 157:   ;
 158:  LBL[605:Na vacuum los] ;
 159:   ;
 160:  IF R[144:Teller afleg]>0,JMP LBL[610] ;
 161:  IF R[143:Afleg 4]=1,JMP LBL[609] ;
 162:   ;
 163:  !Terug naar basisafloop ;
 164:L P[5:Boven band] 1500mm/sec CNT100    ;
 165:J P[4:Naar witte band] 95% CNT100    ;
 166:  JMP LBL[490] ;
 167:   ;
 168:  LBL[609:Pakken van band ] ;
 169:  R[144:Teller afleg]=1    ;
 170:   ;
 171:  LBL[610:Pakken van band ] ;
 172:  IF R[144:Teller afleg]=1,JMP LBL[620] ;
 173:  IF R[144:Teller afleg]=2,JMP LBL[621] ;
 174:  IF R[144:Teller afleg]=3,JMP LBL[622] ;
 175:  IF R[144:Teller afleg]=4,JMP LBL[623] ;
 176:   ;
 177:   ;
 178:  LBL[620:Afleg 1] ;
 179:L P[7:Afleg 1] 1000mm/sec CNT100 Offset,PR[82:Boven afleg]    ;
 180:  !Vacuum aan tijdens naar beneden ;
 181:  !bewegen ;
 182:  RO[5:Vacuum 1]=ON ;
 183:  RO[6:Vacuum 2]=ON ;
 184:L P[7:Afleg 1] 300mm/sec FINE    ;
 185:L P[7:Afleg 1] 1000mm/sec CNT100 Offset,PR[82:Boven afleg]    ;
 186:  R[140:Afleg 1]=0    ;
 187:  R[144:Teller afleg]=2    ;
 188:  JMP LBL[625] ;
 189:   ;
 190:  LBL[621:Afleg 2] ;
 191:L P[8:Afleg 2] 1000mm/sec CNT100 Offset,PR[82:Boven afleg]    ;
 192:  !Vacuum aan tijdens naar beneden ;
 193:  !bewegen ;
 194:  RO[5:Vacuum 1]=ON ;
 195:  RO[6:Vacuum 2]=ON ;
 196:L P[8:Afleg 2] 300mm/sec FINE    ;
 197:L P[8:Afleg 2] 1000mm/sec CNT100 Offset,PR[82:Boven afleg]    ;
 198:  R[141:Afleg 2]=0    ;
 199:  R[144:Teller afleg]=3    ;
 200:  JMP LBL[625] ;
 201:   ;
 202:  LBL[622:Afleg 3] ;
 203:L P[12:Afleg 3] 100mm/sec CNT100 Offset,PR[82:Boven afleg]    ;
 204:  !Vacuum aan tijdens naar beneden ;
 205:  !bewegen ;
 206:  RO[5:Vacuum 1]=ON ;
 207:  RO[6:Vacuum 2]=ON ;
 208:L P[12:Afleg 3] 300mm/sec FINE    ;
 209:L P[12:Afleg 3] 1000mm/sec CNT100 Offset,PR[82:Boven afleg]    ;
 210:  R[142:Afleg 3]=0    ;
 211:  R[144:Teller afleg]=4    ;
 212:  JMP LBL[625] ;
 213:   ;
 214:  LBL[623:Afleg 4] ;
 215:L P[16:Afleg 4] 1000mm/sec CNT100 Offset,PR[82:Boven afleg]    ;
 216:  !Vacuum aan tijdens naar beneden ;
 217:  !bewegen ;
 218:  RO[5:Vacuum 1]=ON ;
 219:  RO[6:Vacuum 2]=ON ;
 220:L P[16:Afleg 4] 300mm/sec FINE    ;
 221:L P[16:Afleg 4] 1000mm/sec CNT100 Offset,PR[82:Boven afleg]    ;
 222:  R[143:Afleg 4]=0    ;
 223:  R[144:Teller afleg]=1    ;
 224:  JMP LBL[625] ;
 225:   ;
 226:  LBL[625:Na pak] ;
 227:J P[14] 100% CNT100    ;
 228:J P[13] 85% CNT100    ;
 229:   ;
 230:  !AFLEGGEN IN MALLEN ;
 231:  LBL[200:Afleggen in mal] ;
 232:  CALL B_AFLG_B_TEST    ;
 233:  UFRAME_NUM=1 ;
 234:   ;
 235:  IF R[132:Mallen niet vrij]=1,JMP LBL[830] ;
 236:  IF R[134:Geen vel pos 0]=1,JMP LBL[850] ;
 237:  IF R[135:Geen vel p 2_50]=1,JMP LBL[850] ;
 238:   ;
 239:  !Velletje pakken ;
 240:  LBL[210:Velletje pakken] ;
 241:  CALL B_VELLEN    ;
 242:   ;
 243:  UFRAME_NUM=1 ;
 244:  IF R[131:Vacuumfout]=1,JMP LBL[840] ;
 245:  IF R[132:Mallen niet vrij]=1,JMP LBL[830] ;
 246:   ;
 247:  !Stapelpuls naar unitronics  ;
 248:  DO[23:Aflegpuls uni]=PULSE,1.0sec ;
 249:   ;
 250:  WAIT    .50(sec) ;
 251:   ;
 252:  IF DI[82:System gereed uni]=OFF,JMP LBL[495] ;
 253:   ;
 254:  !Naar begin programma ;
 255:  LBL[490] ;
 256:  UFRAME_NUM=1 ;
 257:J P[50:deurpos] 90% CNT60    ;
 258:   ;
 259:  RO[5:Vacuum 1]=OFF ;
 260:  RO[5:Vacuum 1]=OFF ;
 261:   ;
 262:J P[3:naar SGM] 100% CNT60    ;
 263:J P[6:induik] 90% CNT100    ;
 264:  JMP LBL[20] ;
 265:   ;
 266:  LBL[495:1ste afleg vel] ;
 267:J P[2:Naar magazyn] 85% CNT100    ;
 268:  CALL B_VELLEN    ;
 269:   ;
 270:  UFRAME_NUM=1 ;
 271:  IF R[131:Vacuumfout]=1,JMP LBL[840] ;
 272:  IF R[132:Mallen niet vrij]=1,JMP LBL[830] ;
 273:   ;
 274:  !Terug naar basisafloop ;
 275:  JMP LBL[490] ;
 276:   ;
 277:  !******STORINGEN****** ;
 278:   ;
 279:  LBL[500:UITNAME FOUT] ;
 280:  CALL TEKST(500) ;
 281:  R[100:Product controle]=0    ;
 282:J P[1:rust positie] 30% FINE    ;
 283:  !Dumpen in bak op de vloer ;
 284:  CALL B_DUMP2    ;
 285:  WAIT DI[7:Automaat]=OFF    ;
 286:   ;
 287:  !Lamp USER 2 AAN op fanuc kast ;
 288:  DO[54:User2]=ON ;
 289:  WAIT DI[45:USER 2]=ON    ;
 290:   ;
 291:  !Lamp USER 2 AAN op fanuc kast ;
 292:  DO[54:User2]=OFF ;
 293:  END ;
 294:   ;
 295:  LBL[510:DUMPEN PRODUCTEN] ;
 296:  !Dumpen in bak op de vloer ;
 297:  CALL B_DUMP2    ;
 298:  R[28:Act dump]=R[28:Act dump]+1    ;
 299:J P[3:naar SGM] 30% FINE    ;
 300:J P[6:induik] 30% FINE    ;
 301:  IF R[28:Act dump]>=R[10:Opstart aantal],JMP LBL[520] ;
 302:  JMP LBL[20] ;
 303:  LBL[520] ;
 304:  R[29:Start afleg]=1    ;
 305:  JMP LBL[20] ;
 306:   ;
 307:  LBL[530:SGM UIT AUTOMAAT] ;
 308:  R[100:Product controle]=0    ;
 309:J P[1:rust positie] 30% FINE    ;
 310:   ;
 311:  !DO :Blower corona uit ;
 312:  DO[51:IONblower Corona]=OFF ;
 313:  DO[52:IONblower witband]=OFF ;
 314:  END ;
 315:   ;
 316:  LBL[570:Grijpfout induik] ;
 317:J P[3:naar SGM] 65% CNT100    ;
 318:   ;
 319:  LBL[580:Gryprfout induik] ;
 320:  CALL TEKST(581) ;
 321:J P[1:rust positie] 30% FINE    ;
 322:   ;
 323:  !Dumpen in bak op de vloer ;
 324:  CALL B_DUMP2    ;
 325:   ;
 326:  WAIT DI[7:Automaat]=OFF    ;
 327:   ;
 328:  !Lamp USER 2 AAN op fanuc kast ;
 329:  DO[54:User2]=ON ;
 330:  WAIT DI[45:USER 2]=ON    ;
 331:   ;
 332:  !Lamp USER 2 AAN op fanuc kast ;
 333:  DO[54:User2]=OFF ;
 334:  END ;
 335:   ;
 336:  LBL[830:MALLEN FOUT] ;
 337:  CALL TEKST(830) ;
 338:J P[2:Naar magazyn] 100% CNT100    ;
 339:J P[1:rust positie] 30% FINE    ;
 340:  CALL B_DUMP1    ;
 341:  WAIT DI[7:Automaat]=OFF    ;
 342:   ;
 343:  !Lamp USER 2 AAN op fanuc kast ;
 344:  DO[54:User2]=ON ;
 345:  WAIT DI[45:USER 2]=ON    ;
 346:   ;
 347:  !Lamp USER 2 AAN op fanuc kast ;
 348:  DO[54:User2]=OFF ;
 349:   ;
 350:  LBL[831:Cntle positi vry] ;
 351:  IF DI[82:System gereed uni]=ON,JMP LBL[832] ;
 352:   ;
 353:  CALL TEKST(735) ;
 354:   ;
 355:  !Lamp USER 2 AAN op fanuc kast ;
 356:  DO[54:User2]=ON ;
 357:  WAIT DI[45:USER 2]=ON    ;
 358:   ;
 359:  !Lamp USER 2 AAN op fanuc kast ;
 360:  DO[54:User2]=OFF ;
 361:  JMP LBL[831] ;
 362:   ;
 363:  LBL[832] ;
 364:  END ;
 365:   ;
 366:  LBL[840:Geen vel gepakt] ;
 367:  CALL TEKST(840) ;
 368:  R[131:Vacuumfout]=0    ;
 369:J P[2:Naar magazyn] 25% CNT100    ;
 370:J P[1:rust positie] 30% FINE    ;
 371:   ;
 372:  !Dumpen in bak op de vloer ;
 373:  CALL B_DUMP2    ;
 374:  WAIT DI[7:Automaat]=OFF    ;
 375:   ;
 376:  !Lamp USER 2 AAN op fanuc kast ;
 377:  DO[54:User2]=ON ;
 378:  WAIT DI[45:USER 2]=ON    ;
 379:   ;
 380:  !Lamp USER 2 AAN op fanuc kast ;
 381:  DO[54:User2]=OFF ;
 382:  R[133:Vel ingelegd]=1    ;
 383:  END ;
 384:   ;
 385:  LBL[850:Geen vel ingelgd] ;
 386:  CALL TEKST(850) ;
 387:J P[1:rust positie] 30% FINE    ;
 388:   ;
 389:  !Dumpen in bak op de vloer ;
 390:  CALL B_DUMP2    ;
 391:   ;
 392:  IF R[136:Vel niet geplaat]>1,JMP LBL[851] ;
 393:  CALL TEKST(3) ;
 394:   ;
 395:   ;
 396:  LBL[851] ;
 397:  CALL TEKST(851) ;
 398:  R[134:Geen vel pos 0]=0    ;
 399:  R[135:Geen vel p 2_50]=0    ;
 400:  R[136:Vel niet geplaat]=0    ;
 401:J P[1:rust positie] 30% FINE    ;
 402:  WAIT DI[7:Automaat]=OFF    ;
 403:   ;
 404:  !Lamp USER 2 AAN op fanuc kast ;
 405:  DO[54:User2]=ON ;
 406:  WAIT DI[45:USER 2]=ON    ;
 407:   ;
 408:  !Lamp USER 2 AAN op fanuc kast ;
 409:  DO[54:User2]=OFF ;
 410:  END ;
 411:   ;
 412:  !******HOME ZOEKEN****** ;
 413:  LBL[1000:HOME ZOEKEN] ;
 414:  CALL TEKST(1000) ;
 415:  PAYLOAD[1] ;
 416:  OVERRIDE=25% ;
 417:  PR[100:Home Lpos]=LPOS    ;
 418:  R[200:Homezoek X]=PR[100,1:Home Lpos]    ;
 419:  R[199:Homezoek Y]=PR[100,2:Home Lpos]    ;
 420:  R[198:Homezoek Z]=PR[100,3:Home Lpos]    ;
 421:   ;
 422:  PR[99:Home Jpos]=JPOS    ;
 423:  R[193:J4]=PR[99,4:Home Jpos]    ;
 424:  R[194:J6]=PR[99,6:Home Jpos]    ;
 425:   ;
 426:  R[189:Act Uframe]=$MNUFRAMENUM[1] ;
 427:  R[188:Act Utool]=$MNUTOOLNUM[1] ;
 428:   ;
 429:  PR[97:P6]=P[6:induik]    ;
 430:  R[192:P6-Y]=PR[97,2:P6]    ;
 431:  R[192:P6-Y]=R[192:P6-Y]+10    ;
 432:  PR[96:P11]=P[11:voor pak]    ;
 433:  R[191:P11-X]=PR[96,1:P11]    ;
 434:   ;
 435:  IF DO[100:Robot op reference]=ON,JMP LBL[1100] ;
 436:   ;
 437:  !--------------- ;
 438:  !--- ;
 439:  IF R[199:Homezoek Y]<500,JMP LBL[1010] ;
 440:  !--------------- ;
 441:   ;
 442:   ;
 443:   ;
 444:  IF R[199:Homezoek Y]<R[192:P6-Y],JMP LBL[1006] ;
 445:   ;
 446:  IF DI[1:Matrijs open]=ON,JMP LBL[1001] ;
 447:  CALL TEKST(1001) ;
 448:  WAIT DI[1:Matrijs open]=ON AND DI[3:Uitw. terug]=ON    ;
 449:   ;
 450:  LBL[1001] ;
 451:  PR[100,1:Home Lpos]=R[191:P11-X]    ;
 452:L PR[100:Home Lpos] 100mm/sec CNT20    ;
 453:  LBL[1005] ;
 454:  UTOOL_NUM=1 ;
 455:L P[6:induik] 300mm/sec FINE    ;
 456:   ;
 457:   ;
 458:  LBL[1006:Buiten SGM] ;
 459:L P[15:buiten SGM] 300mm/sec FINE    ;
 460:J P[3:naar SGM] 15% FINE    ;
 461:  JMP LBL[1100] ;
 462:   ;
 463:   ;
 464:  !---------------- ;
 465:  !--- ;
 466:  LBL[1010] ;
 467:  CALL HOMEN    ;
 468:  JMP LBL[1100] ;
 469:  !--------------- ;
 470:   ;
 471:  LBL[1100] ;
 472:  R[90:Program gestart]=1    ;
 473:  UFRAME_NUM=1 ;
 474:  UTOOL_NUM=1 ;
 475:J P[1:rust positie] 30% CNT100    ;
 476:  R[7:Steekhoogte]=1.5    ;
 477:  R[9:Act R8]=0    ;
 478:  R[21:Grijper 1-voudig]=0    ;
 479:  R[35:Vertrag. induik]=1.2    ;
 480:  R[38:Hoogte fout]=0    ;
 481:  R[39:Buffer niet vrij]=0    ;
 482:  R[40:Grijpfout centre]=0    ;
 483:  R[41:Geen vrijg  slot]=0    ;
 484:  R[42:Grijpfout bufffe]=0    ;
 485:  R[43:Bufferstapel vol]=0    ;
 486:  R[45:Teller ontstapel]=0    ;
 487:  R[46:Cyclusteller]=0    ;
 488:  R[47:Centrer niet vri]=0    ;
 489:  R[49:Snelheid]=75    ;
 490:  R[140:Afleg 1]=0    ;
 491:  R[141:Afleg 2]=0    ;
 492:  R[142:Afleg 3]=0    ;
 493:  R[143:Afleg 4]=0    ;
 494:  R[144:Teller afleg]=0    ;
 495:   ;
 496:  !Aansturen bandje afkeur ;
 497:  DO[14321]=PULSE,12.0sec ;
 498:   ;
 499:  DO[10:Vacuumpomp]=ON ;
 500:  DO[49:Buzzer hek]=OFF ;
 501:  DO[50:Rode lamp hek]=OFF ;
 502:  DO[51:IONblower Corona]=ON ;
 503:  DO[52:IONblower witband]=ON ;
 504:   ;
 505:  !AANSTURING SNAARBANDJE--- JA ;
 506:  !AANSTURING CORONA-------- NEE ;
 507:  !AANSTURING ANTI STATIC--- JA ;
 508:  !AANSTURING WHITE STRIPE-- NEE ;
 509:  DO[15020]=OFF ;
 510:  DO[15021]=ON ;
 511:  DO[15022]=OFF ;
 512:  DO[15023]=OFF ;
 513:  DO[15024]=OFF ;
 514:  DO[15025]=OFF ;
 515:  DO[15026]=OFF ;
 516:   ;
 517:  !Reset tafel vol ;
 518:  DO[14419]=OFF ;
 519:  END ;
 520:   ;
/POS
P[1:"rust positie"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   451.205  mm,	Y =      .013  mm,	Z =   354.127  mm,
	W =   179.900 deg,	P =     -.000 deg,	R =   -90.100 deg
};
P[2:"Naar magazyn"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   717.216  mm,	Y =  -435.901  mm,	Z =   356.986  mm,
	W =   179.965 deg,	P =     -.164 deg,	R =     -.838 deg
};
P[3:"naar SGM"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   283.767  mm,	Y =   428.124  mm,	Z =   590.831  mm,
	W =  -162.543 deg,	P =   -19.573 deg,	R =   -49.015 deg
};
P[4:"Naar witte band"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   644.307  mm,	Y =   415.154  mm,	Z =   420.764  mm,
	W =   179.900 deg,	P =     -.000 deg,	R =   -90.100 deg
};
P[5:"Boven band"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   944.187  mm,	Y =   415.154  mm,	Z =   303.463  mm,
	W =   179.900 deg,	P =     -.000 deg,	R =   -90.100 deg
};
P[6:"induik"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, -1',
	X =   425.000  mm,	Y =   700.000  mm,	Z =   475.546  mm,
	W =   -89.630 deg,	P =      .531 deg,	R =   -90.034 deg
};
P[7:"Afleg 1"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  1200.000  mm,	Y =   415.117  mm,	Z =   200.869  mm,
	W =   179.899 deg,	P =      .000 deg,	R =   -90.100 deg
};
P[8:"Afleg 2"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  1080.000  mm,	Y =   415.169  mm,	Z =   200.851  mm,
	W =   179.898 deg,	P =      .001 deg,	R =   -90.102 deg
};
P[9:"voor pak"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, -1',
	X =   425.000  mm,	Y =  1405.811  mm,	Z =   475.546  mm,
	W =   -89.630 deg,	P =      .531 deg,	R =   -90.034 deg
};
P[10:"pak pos"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, -1',
	X =   441.735  mm,	Y =  1405.810  mm,	Z =   475.545  mm,
	W =   -89.630 deg,	P =      .531 deg,	R =   -90.034 deg
};
P[11:"voor pak"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, -1',
	X =   420.000  mm,	Y =  1405.811  mm,	Z =   475.546  mm,
	W =   -89.630 deg,	P =      .531 deg,	R =   -90.034 deg
};
P[12:"Afleg 3"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   960.000  mm,	Y =   415.170  mm,	Z =   200.851  mm,
	W =   179.898 deg,	P =      .001 deg,	R =   -90.102 deg
};
P[13]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   878.858  mm,	Y =   118.274  mm,	Z =   505.001  mm,
	W =   179.964 deg,	P =     -.985 deg,	R =   -52.174 deg
};
P[14]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   944.187  mm,	Y =   415.155  mm,	Z =   505.000  mm,
	W =   179.900 deg,	P =     -.000 deg,	R =   -90.100 deg
};
P[15:"buiten SGM"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, -1',
	X =   420.000  mm,	Y =   650.000  mm,	Z =   475.546  mm,
	W =   -89.630 deg,	P =      .531 deg,	R =   -90.034 deg
};
P[16:"Afleg 4"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   838.000  mm,	Y =   415.169  mm,	Z =   200.851  mm,
	W =   179.898 deg,	P =      .001 deg,	R =   -90.102 deg
};
P[50:"deurpos"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   436.228  mm,	Y =      .013  mm,	Z =   420.765  mm,
	W =   179.900 deg,	P =     -.000 deg,	R =   -90.100 deg
};
/END
