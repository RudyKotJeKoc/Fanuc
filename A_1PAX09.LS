/PROG  A_1PAX09
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "DIGITAL PRINT140";
PROG_SIZE	= 11614;
CREATE		= DATE 16-03-09  TIME 13:45:14;
MODIFIED	= DATE 19-01-22  TIME 18:50:42;
FILE_NAME	= A_1PAX04;
VERSION		= 0;
LINE_COUNT	= 558;
MEMORY_SIZE	= 12406;
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
   4:  !MET NIEUWE CENTREERPLAAT EN ;
   5:  !PRINTER ;
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
  22:  Open hand 1    ;
  23:  Open hand 2    ;
  24:   ;
  25:  LBL[10:NAAR INDUIK] ;
  26:  IF DI[7:Automaat]=OFF,JMP LBL[530] ;
  27:  IF DI[6:Matrijs dicht]=ON,JMP LBL[15] ;
  28:  JMP LBL[10] ;
  29:   ;
  30:  LBL[15] ;
  31:  !Uitstoter terug ;
  32:  DO[11017]=OFF ;
  33:   ;
  34:J P[3:naar SGM] 75% CNT100    ;
  35:J P[6:Voor induik] 75% CNT85    ;
  36:   ;
  37:  !GRIJPERS OPEN ;
  38:  Open hand 1    ;
  39:  Open hand 2    ;
  40:   ;
  41:  LBL[20:Cyclusteller] ;
  42:  R[46:Cyclusteller]=R[46:Cyclusteller]+1    ;
  43:   ;
  44:  $WAITTMOUT=500 ;
  45:  !Controle induikvoorwaarde ;
  46:  WAIT DO[11161]=ON TIMEOUT,LBL[570] ;
  47:  R[1:Cyclustijd]=TIMER[1]    ;
  48:   ;
  49:  LBL[25:Controle induik] ;
  50:  !Controle grijpers open ;
  51:  IF RI[1:Bek B Open]=OFF OR RI[3:Bek A Open]=OFF,JMP LBL[570] ;
  52:   ;
  53:  !Controle induikvoorwaarde ;
  54:  IF DO[11161]=OFF,JMP LBL[570] ;
  55:   ;
  56:  !Wacht op matrijs open ;
  57:  IF DO[11033]=ON,JMP LBL[30] ;
  58:   ;
  59:  !Check machine in automaat ;
  60:  IF DI[7:Automaat]=OFF,JMP LBL[530] ;
  61:  JMP LBL[25] ;
  62:   ;
  63:  LBL[30:UITNAME] ;
  64:  IF R[46:Cyclusteller]<2,JMP LBL[31] ;
  65:   ;
  66:  !% Snelheid naar 100% ;
  67:  OVERRIDE=100% ;
  68:   ;
  69:  LBL[31] ;
  70:  !Uitstoter naar voren ;
  71:  DO[11017]=PULSE,0.2sec ;
  72:  TIMER[1]=RESET ;
  73:   ;
  74:  !TAK WEGPAKKEN ;
  75:L P[19:Na induik] 800mm/sec CNT100    ;
  76:L P[20:Na induik 1] 900mm/sec CNT100    ;
  77:L P[21:Pakpos voor tak] 750mm/sec CNT100    ;
  78:L P[22:Pakpos tak] 500mm/sec CNT100    ;
  79:  WAIT    .25(sec) ;
  80:  RO[7:Grijper tak]=ON ;
  81:  WAIT    .20(sec) ;
  82:L P[23:Na pak tak] 500mm/sec CNT10    ;
  83:L P[24:Tak los pos] 500mm/sec CNT10    ;
  84:  RO[7:Grijper tak]=OFF ;
  85:  WAIT    .50(sec) ;
  86:   ;
  87:  !UITNEMEN PRODUCT ;
  88:  LBL[32:Pak product] ;
  89:L P[9:Voor pak] 500mm/sec CNT10    ;
  90:L P[10:Pakpos] 500mm/sec FINE    ;
  91:   ;
  92:  !Grijpers dicht ;
  93:  Close hand 1    ;
  94:  Close hand 2    ;
  95:   ;
  96:  !Paktijd vertraging  ;
  97:  WAIT R[5] ;
  98:L P[11:Na pak] 500mm/sec CNT10    ;
  99:  !Uitstoter terug ;
 100:  DO[11017]=OFF ;
 101:   ;
 102:L P[15:Buiten SGM] 1500mm/sec CNT50    ;
 103:   ;
 104:  !% Snelheid = register 49 ;
 105:  OVERRIDE=R[49:Snelheid] ;
 106:   ;
 107:  LBL[40:UITNAME CONTROLE] ;
 108:  IF RI[1:Bek B Open]=OFF AND RI[2:Bek B product aanwezig]=ON AND RI[3:Bek A Open]=OFF AND RI[4:Bek A product aanwezig]=ON,JMP LBL[50] ;
 109:  IF R[100:Product controle]>1,JMP LBL[500] ;
 110:  WAIT    .01(sec) ;
 111:  R[100:Product controle]=R[100:Product controle]+.01    ;
 112:  JMP LBL[40] ;
 113:   ;
 114:  LBL[50:UITNAME OK ] ;
 115:  R[100:Product controle]=0    ;
 116:   ;
 117:  !Spuitgietmachine sluiten ;
 118:  DO[11025]=PULSE,0.5sec ;
 119:  R[2:Induiktijd]=TIMER[1]    ;
 120:  IF DI[10:Fout product]=ON,JMP LBL[510] ;
 121:J P[50:deurpos] 60% CNT80    ;
 122:   ;
 123:  LBL[60:OPSTART AFKEUR] ;
 124:  IF R[10:Opstart aantal]=0,JMP LBL[200] ;
 125:  IF R[29:Start afleg]=0,JMP LBL[510] ;
 126:   ;
 127:  !TUSSENPOSITIONEREN ;
 128:  LBL[200:Tussenpositioner] ;
 129:  CALL POSITIE5    ;
 130:   ;
 131:  !Controle fouten na centreren ;
 132:  IF R[40:Grijpfout centre]=1,JMP LBL[505] ;
 133:  IF R[47:Centrer niet vri]=1,JMP LBL[735] ;
 134:   ;
 135:  !PRINTEN BERGSTEIN ;
 136:  LBL[210:Printen] ;
 137:   ;
 138:  !Controle lekbak/magneet aanwezig ;
 139:  IF DI[72:Afdekkap aanwzg]=OFF,JMP LBL[211] ;
 140:  CALL TEKST(800) ;
 141:   ;
 142:  !Robot veilig bewegen van printer ;
 143:J P[51:Weg van  printer] 25% CNT100    ;
 144:   ;
 145:  WAIT DI[72:Afdekkap aanwzg]=OFF    ;
 146:J P[52:Terug naar print] 25% CNT100    ;
 147:   ;
 148:  CALL TEKST(3) ;
 149:   ;
 150:  LBL[211:Start printen] ;
 151:  CALL PRINTEN    ;
 152:  UFRAME_NUM=1 ;
 153:   ;
 154:  !% Snelheid = register 49 ;
 155:  OVERRIDE=R[49:Snelheid] ;
 156:   ;
 157:  !Controle fouten na printen ;
 158:  IF R[38:Hoogte fout]=1,JMP LBL[720] ;
 159:   ;
 160:  !AFLEGGEN OP CORONA BAND ;
 161:  LBL[230:Afleggen] ;
 162:  CALL B_AFLEG    ;
 163:   ;
 164:  UFRAME_NUM=1 ;
 165:   ;
 166:  !Controle fouten na afleggen ;
 167:  IF R[42:Grijpfout bufffe]=1,JMP LBL[730] ;
 168:  IF R[43:Bufferstapel vol]=1,JMP LBL[740] ;
 169:  IF R[39:Buffer niet vrij]=1,JMP LBL[750] ;
 170:   ;
 171:  !Naar begin programma ;
 172:  LBL[490] ;
 173:  UFRAME_NUM=1 ;
 174:J P[50:deurpos] 75% CNT60    ;
 175:  Open hand 1    ;
 176:  Open hand 2    ;
 177:J P[3:naar SGM] 85% CNT60    ;
 178:J P[6:Voor induik] 85% CNT100    ;
 179:  JMP LBL[20] ;
 180:   ;
 181:   ;
 182:  !******STORINGEN****** ;
 183:   ;
 184:  LBL[500:UITNAME FOUT] ;
 185:  CALL TEKST(500) ;
 186:  R[100:Product controle]=0    ;
 187:J P[1:rust positie] 30% FINE    ;
 188:  CALL DUMPEN    ;
 189:  WAIT DI[7:Automaat]=OFF    ;
 190:   ;
 191:  !Lamp USER 2 AAN op fanuc kast ;
 192:  DO[54:User2]=ON ;
 193:  WAIT DI[45:USER 2]=ON    ;
 194:   ;
 195:  !Lamp USER 2 AAN op fanuc kast ;
 196:  DO[54:User2]=OFF ;
 197:  END ;
 198:   ;
 199:  LBL[505:GRIJPFOUT CNTRER] ;
 200:  CALL TEKST(510) ;
 201:  R[100:Product controle]=0    ;
 202:  R[40:Grijpfout centre]=0    ;
 203:J P[1:rust positie] 30% FINE    ;
 204:  CALL DUMPEN    ;
 205:  WAIT DI[7:Automaat]=OFF    ;
 206:   ;
 207:  !Lamp USER 2 AAN op fanuc kast ;
 208:  DO[54:User2]=ON ;
 209:  WAIT DI[45:USER 2]=ON    ;
 210:   ;
 211:  !Lamp USER 2 AAN op fanuc kast ;
 212:  DO[54:User2]=OFF ;
 213:   ;
 214:  LBL[506:Cntle positi vry] ;
 215:  IF DI[23:Positioneer vrij]=OFF,JMP LBL[507] ;
 216:   ;
 217:  CALL TEKST(735) ;
 218:   ;
 219:  !Lamp USER 2 AAN op fanuc kast ;
 220:  DO[54:User2]=ON ;
 221:  WAIT DI[45:USER 2]=ON    ;
 222:   ;
 223:  !Lamp USER 2 AAN op fanuc kast ;
 224:  DO[54:User2]=OFF ;
 225:  JMP LBL[506] ;
 226:   ;
 227:  LBL[507:Positioneer vry] ;
 228:  END ;
 229:   ;
 230:  LBL[510:DUMPEN PRODUCTEN] ;
 231:  CALL DUMPEN    ;
 232:  R[28:Act dump]=R[28:Act dump]+1    ;
 233:J P[3:naar SGM] 30% FINE    ;
 234:J P[6:Voor induik] 30% FINE    ;
 235:  IF R[28:Act dump]>=R[10:Opstart aantal],JMP LBL[520] ;
 236:  JMP LBL[20] ;
 237:   ;
 238:  LBL[520:Aantal bereikt] ;
 239:  R[29:Start afleg]=1    ;
 240:  JMP LBL[20] ;
 241:   ;
 242:  LBL[530:SGM UIT AUTOMAAT] ;
 243:  R[100:Product controle]=0    ;
 244:J P[1:rust positie] 30% FINE    ;
 245:   ;
 246:  !DO :Blower corona uit ;
 247:  DO[51:IONblower Corona]=OFF ;
 248:  END ;
 249:   ;
 250:  LBL[570:Grijpfout induik] ;
 251:J P[3:naar SGM] 65% CNT100    ;
 252:   ;
 253:  LBL[580:Gryprfout induik] ;
 254:  CALL TEKST(581) ;
 255:J P[1:rust positie] 30% FINE    ;
 256:  CALL DUMPEN    ;
 257:  WAIT DI[7:Automaat]=OFF    ;
 258:   ;
 259:  !Lamp USER 2 AAN op fanuc kast ;
 260:  DO[54:User2]=ON ;
 261:  WAIT DI[45:USER 2]=ON    ;
 262:   ;
 263:  !Lamp USER 2 AAN op fanuc kast ;
 264:  DO[54:User2]=OFF ;
 265:  END ;
 266:   ;
 267:  LBL[720:HOOGTE FOUT PRNT] ;
 268:  CALL TEKST(725) ;
 269:  R[100:Product controle]=0    ;
 270:  R[38:Hoogte fout]=0    ;
 271:J P[1:rust positie] 30% FINE    ;
 272:   ;
 273:  CALL DUMPEN    ;
 274:  WAIT DI[7:Automaat]=OFF    ;
 275:   ;
 276:  !Lamp USER 2 AAN op fanuc kast ;
 277:  DO[54:User2]=ON ;
 278:  WAIT DI[45:USER 2]=ON    ;
 279:   ;
 280:  !Lamp USER 2 AAN op fanuc kast ;
 281:  DO[54:User2]=OFF ;
 282:  END ;
 283:   ;
 284:  LBL[730:GRIJPER FOUT BUF] ;
 285:  CALL TEKST(730) ;
 286:  R[100:Product controle]=0    ;
 287:  R[42:Grijpfout bufffe]=0    ;
 288:  R[9:Act R8]=0    ;
 289:J P[1:rust positie] 30% FINE    ;
 290:   ;
 291:  CALL DUMPEN    ;
 292:  WAIT DI[7:Automaat]=OFF    ;
 293:   ;
 294:  !Lamp USER 2 AAN op fanuc kast ;
 295:  DO[54:User2]=ON ;
 296:  WAIT DI[45:USER 2]=ON    ;
 297:   ;
 298:  !Lamp USER 2 AAN op fanuc kast ;
 299:  DO[54:User2]=OFF ;
 300:   ;
 301:  LBL[731:Contrle buf leeg] ;
 302:  IF DI[22:Buffer vrij]=ON,JMP LBL[732] ;
 303:   ;
 304:  CALL TEKST(1200) ;
 305:  !Lamp USER 2 AAN op fanuc kast ;
 306:  DO[54:User2]=ON ;
 307:  WAIT DI[45:USER 2]=ON    ;
 308:   ;
 309:  !Lamp USER 2 AAN op fanuc kast ;
 310:  DO[54:User2]=OFF ;
 311:  JMP LBL[7311] ;
 312:   ;
 313:  LBL[732:Buffer is vrij] ;
 314:   ;
 315:  !DO :RODE LAMP/BUZZER  UIT ;
 316:  DO[49:Buzzer hek]=OFF ;
 317:  DO[50:Rode lamp hek]=OFF ;
 318:  END ;
 319:   ;
 320:  LBL[735:Centrer niet vry] ;
 321:  CALL TEKST(735) ;
 322:  R[47:Centrer niet vri]=0    ;
 323:J P[1:rust positie] 30% FINE    ;
 324:  CALL DUMPEN    ;
 325:  WAIT DI[7:Automaat]=OFF    ;
 326:   ;
 327:  !Lamp USER 2 AAN op fanuc kast ;
 328:  DO[54:User2]=ON ;
 329:  WAIT DI[45:USER 2]=ON    ;
 330:   ;
 331:  !Lamp USER 2 AAN op fanuc kast ;
 332:  DO[54:User2]=OFF ;
 333:   ;
 334:  LBL[736:Cntle positi vry] ;
 335:  IF DI[70:Herpositie 2 FC]=OFF,JMP LBL[737] ;
 336:   ;
 337:  CALL TEKST(735) ;
 338:  !Lamp USER 2 AAN op fanuc kast ;
 339:  DO[54:User2]=ON ;
 340:  WAIT DI[45:USER 2]=ON    ;
 341:   ;
 342:  !Lamp USER 2 AAN op fanuc kast ;
 343:  DO[54:User2]=OFF ;
 344:  JMP LBL[736] ;
 345:   ;
 346:  LBL[737:Positioneer vry] ;
 347:  END ;
 348:   ;
 349:  LBL[740:BUFFER VOL] ;
 350:  CALL TEKST(740) ;
 351:J P[1:rust positie] 30% FINE    ;
 352:  R[9:Act R8]=0    ;
 353:  R[43:Bufferstapel vol]=0    ;
 354:  CALL DUMPEN    ;
 355:  WAIT DI[7:Automaat]=OFF    ;
 356:   ;
 357:  !Lamp USER 2 AAN op fanuc kast ;
 358:  DO[54:User2]=ON ;
 359:  WAIT DI[45:USER 2]=ON    ;
 360:   ;
 361:  !Lamp USER 2 AAN op fanuc kast ;
 362:  DO[54:User2]=OFF ;
 363:   ;
 364:  LBL[741:Contrle buf leeg] ;
 365:  IF DI[22:Buffer vrij]=ON,JMP LBL[742] ;
 366:   ;
 367:  CALL TEKST(1200) ;
 368:  !Lamp USER 2 AAN op fanuc kast ;
 369:  DO[54:User2]=ON ;
 370:  WAIT DI[45:USER 2]=ON    ;
 371:   ;
 372:  !Lamp USER 2 AAN op fanuc kast ;
 373:  DO[54:User2]=OFF ;
 374:  JMP LBL[741] ;
 375:   ;
 376:  LBL[742:Buffer vrij] ;
 377:  !DO :RODE LAMP UIT ;
 378:  DO[49:Buzzer hek]=OFF ;
 379:  DO[50:Rode lamp hek]=OFF ;
 380:  END ;
 381:   ;
 382:  LBL[750:BUFFER NIET VRY] ;
 383:  CALL TEKST(1200) ;
 384:J P[1:rust positie] 30% FINE    ;
 385:  R[9:Act R8]=0    ;
 386:  R[39:Buffer niet vrij]=0    ;
 387:   ;
 388:  CALL DUMPEN    ;
 389:   ;
 390:  WAIT DI[7:Automaat]=OFF    ;
 391:   ;
 392:  !Lamp USER 2 AAN op fanuc kast ;
 393:  DO[54:User2]=ON ;
 394:  WAIT DI[45:USER 2]=ON    ;
 395:   ;
 396:  !Lamp USER 2 AAN op fanuc kast ;
 397:  DO[54:User2]=OFF ;
 398:   ;
 399:  LBL[751:Contrle buf leeg] ;
 400:  IF DI[22:Buffer vrij]=ON,JMP LBL[752] ;
 401:   ;
 402:  CALL TEKST(1200) ;
 403:  !Lamp USER 2 AAN op fanuc kast ;
 404:  DO[54:User2]=ON ;
 405:  WAIT DI[45:USER 2]=ON    ;
 406:   ;
 407:  !Lamp USER 2 AAN op fanuc kast ;
 408:  DO[54:User2]=OFF ;
 409:  JMP LBL[751] ;
 410:   ;
 411:  LBL[752:Buffer vry] ;
 412:  !DO :RODE LAMP UIT ;
 413:  DO[49:Buzzer hek]=OFF ;
 414:  DO[50:Rode lamp hek]=OFF ;
 415:  END ;
 416:   ;
 417:  !******HOME ZOEKEN****** ;
 418:  LBL[1000:HOME ZOEKEN] ;
 419:  CALL TEKST(1000) ;
 420:  PAYLOAD[1] ;
 421:  OVERRIDE=25% ;
 422:  PR[100:Home Lpos]=LPOS    ;
 423:  R[200:Homezoek X]=PR[100,1:Home Lpos]    ;
 424:  R[199:Homezoek Y]=PR[100,2:Home Lpos]    ;
 425:  R[198:Homezoek Z]=PR[100,3:Home Lpos]    ;
 426:   ;
 427:  PR[99:Home Jpos]=JPOS    ;
 428:  R[193:J4]=PR[99,4:Home Jpos]    ;
 429:  R[194:J6]=PR[99,6:Home Jpos]    ;
 430:   ;
 431:  R[189:Act Uframe]=$MNUFRAMENUM[1] ;
 432:  R[188:Act Utool]=$MNUTOOLNUM[1] ;
 433:   ;
 434:  PR[97:P6]=P[6:Voor induik]    ;
 435:  R[192:P6-Y]=PR[97,2:P6]    ;
 436:  R[192:P6-Y]=R[192:P6-Y]+10    ;
 437:  PR[96:P11]=P[11:Na pak]    ;
 438:  R[191:P11-X]=PR[96,1:P11]    ;
 439:   ;
 440:  IF DO[100:Robot op reference]=ON,JMP LBL[1100] ;
 441:   ;
 442:  !--------------- ;
 443:  !--- ;
 444:  IF R[199:Homezoek Y]<500,JMP LBL[1010] ;
 445:  !--------------- ;
 446:   ;
 447:  IF R[199:Homezoek Y]<R[192:P6-Y],JMP LBL[1006] ;
 448:   ;
 449:  IF DI[1:Matrijs open]=ON,JMP LBL[1001] ;
 450:  CALL TEKST(1001) ;
 451:  WAIT DI[1:Matrijs open]=ON AND DI[3:Uitw. terug]=ON    ;
 452:   ;
 453:  LBL[1001] ;
 454:  Open hand 1    ;
 455:  Open hand 2    ;
 456:  PR[100,1:Home Lpos]=R[191:P11-X]    ;
 457:L PR[100:Home Lpos] 100mm/sec CNT20    ;
 458:  LBL[1005] ;
 459:  UTOOL_NUM=1 ;
 460:L P[15:Buiten SGM] 300mm/sec FINE    ;
 461:   ;
 462:  LBL[1006:Buiten SGM] ;
 463:L P[15:Buiten SGM] 300mm/sec FINE    ;
 464:J P[3:naar SGM] 15% FINE    ;
 465:  JMP LBL[1100] ;
 466:   ;
 467:  !---------------- ;
 468:  !--- ;
 469:  LBL[1010] ;
 470:  CALL HOMEN    ;
 471:  JMP LBL[1100] ;
 472:  !--------------- ;
 473:   ;
 474:  LBL[1100] ;
 475:  R[90:Program gestart]=1    ;
 476:  UFRAME_NUM=1 ;
 477:  UTOOL_NUM=1 ;
 478:J P[1:rust positie] 30% CNT100    ;
 479:   ;
 480:  !Grijpers open ;
 481:  Open hand 1    ;
 482:  Open hand 2    ;
 483:   ;
 484:  R[7:Steekhoogte]=13.1    ;
 485:  R[9:Act R8]=0    ;
 486:  R[21:Grijper 1-voudig]=0    ;
 487:  R[35:Vertrag. induik]=1.2    ;
 488:  R[38:Hoogte fout]=0    ;
 489:  R[39:Buffer niet vrij]=0    ;
 490:  R[40:Grijpfout centre]=0    ;
 491:  R[41:Geen vrijg  slot]=0    ;
 492:  R[42:Grijpfout bufffe]=0    ;
 493:  R[43:Bufferstapel vol]=0    ;
 494:  R[45:Teller ontstapel]=0    ;
 495:  R[46:Cyclusteller]=0    ;
 496:  R[47:Centrer niet vri]=0    ;
 497:  R[49:Snelheid]=60    ;
 498:   ;
 499:  !PRINTER AFSTELING ;
 500:  !Waardes ophalen uit positie ;
 501:  PR[38:Offset print 1]=P[201]    ;
 502:  PR[39:Offset print 2]=P[202]    ;
 503:   ;
 504:  DO[52:IONblower witband]=ON ;
 505:  DO[49:Buzzer hek]=OFF ;
 506:  DO[50:Rode lamp hek]=OFF ;
 507:   ;
 508:  !Controle centreer leeg ;
 509:  LBL[2000] ;
 510:  IF DI[23:Positioneer vrij]=ON,JMP LBL[2100] ;
 511:   ;
 512:  !Controle buffer leeg ;
 513:  LBL[2001] ;
 514:  IF DI[22:Buffer vrij]=OFF,JMP LBL[2101] ;
 515:   ;
 516:  !AANSTURING SNAARBANDJE--- JA ;
 517:  !AANSTURING CORONA-------- NEE ;
 518:  !AANSTURING ANTI STATIC--- JA ;
 519:  !AANSTURING WHITE STRIPE-- NEE ;
 520:  DO[15020]=OFF ;
 521:  DO[15021]=ON ;
 522:  DO[15022]=OFF ;
 523:  DO[15023]=OFF ;
 524:  DO[15024]=OFF ;
 525:  DO[15025]=OFF ;
 526:  DO[15026]=OFF ;
 527:   ;
 528:  !Reset tafel vol ;
 529:  DO[14419]=OFF ;
 530:  END ;
 531:   ;
 532:  LBL[2100:Opstart controle] ;
 533:  CALL TEKST(1300) ;
 534:  !Lamp USER 2 AAN op fanuc kast ;
 535:  DO[54:User2]=ON ;
 536:  WAIT DI[45:USER 2]=ON    ;
 537:   ;
 538:  !Lamp USER 2 AAN op fanuc kast ;
 539:  DO[54:User2]=OFF ;
 540:  JMP LBL[2000] ;
 541:   ;
 542:  LBL[2101:Opstart controle] ;
 543:  CALL TEKST(1200) ;
 544:  !Lamp USER 2 AAN op fanuc kast ;
 545:  DO[54:User2]=ON ;
 546:  WAIT DI[45:USER 2]=ON    ;
 547:   ;
 548:  !Lamp USER 2 AAN op fanuc kast ;
 549:  DO[54:User2]=OFF ;
 550:  JMP LBL[2001] ;
 551:   ;
 552:  END ;
 553:  !-------------------------------- ;
 554:  !Offset registers voor printer ;
 555:  !Offset waarden opslaan ;
 556:J P[201] 1% FINE    ;
 557:J P[202] 1% FINE    ;
 558:  !-------------------------------- ;
/POS
P[1:"rust positie"]{
   GP1:
	UF : 1, UT : 1,	
	J1=     0.000 deg,	J2=   -45.000 deg,	J3=     0.000 deg,
	J4=     0.000 deg,	J5=   -90.000 deg,	J6=   -90.000 deg
};
P[3:"naar SGM"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   279.404  mm,	Y =   418.185  mm,	Z =   527.595  mm,
	W =   179.916 deg,	P =   -27.516 deg,	R =     1.768 deg
};
P[6:"Voor induik"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   310.000  mm,	Y =   700.000  mm,	Z =   610.000  mm,
	W =   -83.262 deg,	P =   -89.285 deg,	R =   -96.679 deg
};
P[9:"Voor pak"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   295.000  mm,	Y =  1406.500  mm,	Z =   610.350  mm,
	W =   -83.304 deg,	P =   -89.284 deg,	R =   -96.638 deg
};
P[10:"Pakpos"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   327.000  mm,	Y =  1406.500  mm,	Z =   610.350  mm,
	W =   -83.304 deg,	P =   -89.284 deg,	R =   -96.638 deg
};
P[11:"Na pak"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   295.000  mm,	Y =  1406.500  mm,	Z =   610.350  mm,
	W =   -83.304 deg,	P =   -89.284 deg,	R =   -96.638 deg
};
P[15:"Buiten SGM"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   295.000  mm,	Y =   650.000  mm,	Z =   610.350  mm,
	W =   -83.304 deg,	P =   -89.285 deg,	R =   -96.638 deg
};
P[19:"Na induik"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   310.000  mm,	Y =  1185.000  mm,	Z =   575.000  mm,
	W =   -83.288 deg,	P =   -89.286 deg,	R =   -96.660 deg
};
P[20:"Na induik 1"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   310.000  mm,	Y =  1290.000  mm,	Z =   520.000  mm,
	W =   -83.296 deg,	P =   -89.286 deg,	R =   -96.651 deg
};
P[21:"Pakpos voor tak"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   310.000  mm,	Y =  1404.500  mm,	Z =   520.000  mm,
	W =   -83.260 deg,	P =   -89.286 deg,	R =   -96.687 deg
};
P[22:"Pakpos tak"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   310.000  mm,	Y =  1404.500  mm,	Z =   544.500  mm,
	W =   -83.257 deg,	P =   -89.286 deg,	R =   -96.690 deg
};
P[23:"Na pak tak"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   283.248  mm,	Y =  1404.500  mm,	Z =   544.501  mm,
	W =   -83.299 deg,	P =   -89.286 deg,	R =   -96.648 deg
};
P[24:"Tak los pos"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   200.448  mm,	Y =  1405.497  mm,	Z =   510.442  mm,
	W =  -177.884 deg,	P =   -37.670 deg,	R =    -2.908 deg
};
P[50:"deurpos"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   436.228  mm,	Y =      .013  mm,	Z =   420.765  mm,
	W =   179.900 deg,	P =     -.000 deg,	R =   -90.100 deg
};
P[51:"Weg van  printer"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =  -231.108  mm,	Y =  -581.487  mm,	Z =   347.114  mm,
	W =    88.716 deg,	P =    -1.964 deg,	R =      .752 deg
};
P[52:"Terug naar print"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =  -470.234  mm,	Y = -1090.372  mm,	Z =   347.113  mm,
	W =    88.716 deg,	P =    -1.964 deg,	R =      .752 deg
};
P[201]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =     0.000  mm,	Y =     0.000  mm,	Z =     0.000  mm,
	W =     0.000 deg,	P =     0.000 deg,	R =     0.000 deg
};
P[202]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =     0.000  mm,	Y =     0.000  mm,	Z =     0.000  mm,
	W =     0.000 deg,	P =     0.000 deg,	R =     0.000 deg
};
/END
