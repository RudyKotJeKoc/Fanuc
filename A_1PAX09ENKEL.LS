/PROG  A_1PAX09ENKEL
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "DIGITAL PRINT140";
PROG_SIZE	= 11578;
CREATE		= DATE 19-06-03  TIME 15:47:34;
MODIFIED	= DATE 19-06-06  TIME 21:25:58;
FILE_NAME	= A_1PAX09;
VERSION		= 0;
LINE_COUNT	= 556;
MEMORY_SIZE	= 12378;
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
  53:  IF DO[11161]=OFF,JMP LBL[570] ;
  54:   ;
  55:  !Wacht op matrijs open ;
  56:  IF DO[11033]=ON,JMP LBL[30] ;
  57:   ;
  58:  !Check machine in automaat ;
  59:  IF DI[7:Automaat]=OFF,JMP LBL[530] ;
  60:  JMP LBL[25] ;
  61:   ;
  62:  LBL[30:UITNAME] ;
  63:  IF R[46:Cyclusteller]<2,JMP LBL[31] ;
  64:   ;
  65:  !% Snelheid naar 100% ;
  66:  OVERRIDE=100% ;
  67:   ;
  68:  LBL[31] ;
  69:  !Uitstoter naar voren ;
  70:  DO[11017]=PULSE,0.2sec ;
  71:  TIMER[1]=RESET ;
  72:   ;
  73:  !TAK WEGPAKKEN ;
  74:L P[19:Na induik] 800mm/sec CNT100    ;
  75:L P[20:Na induik 1] 900mm/sec CNT100    ;
  76:L P[21:Pakpos voor tak] 750mm/sec CNT100    ;
  77:L P[22:Pakpos tak] 500mm/sec CNT100    ;
  78:  WAIT    .25(sec) ;
  79:  RO[7:Grijper tak]=ON ;
  80:  WAIT    .20(sec) ;
  81:L P[23:Na pak tak] 500mm/sec CNT10    ;
  82:L P[24:Tak los pos] 500mm/sec CNT10    ;
  83:  RO[7:Grijper tak]=OFF ;
  84:  WAIT    .50(sec) ;
  85:   ;
  86:  !UITNEMEN PRODUCT ;
  87:  LBL[32:Pak product] ;
  88:L P[9:Voor pak] 500mm/sec CNT10    ;
  89:L P[10:Pakpos] 500mm/sec FINE    ;
  90:   ;
  91:  !Grijpers dicht ;
  92:  Close hand 2    ;
  93:   ;
  94:  !Paktijd vertraging  ;
  95:  WAIT R[5] ;
  96:L P[11:Na pak] 500mm/sec CNT10    ;
  97:  !Uitstoter terug ;
  98:  DO[11017]=OFF ;
  99:   ;
 100:L P[15:Buiten SGM] 1500mm/sec CNT50    ;
 101:   ;
 102:  !% Snelheid = register 49 ;
 103:  OVERRIDE=R[49:Snelheid] ;
 104:   ;
 105:  LBL[40:UITNAME CONTROLE] ;
 106:  IF RI[1:Bek B Open]=OFF AND RI[2:Bek B product aanwezig]=ON AND RI[3:Bek A Open]=ON AND RI[4:Bek A product aanwezig]=OFF,JMP LBL[50] ;
 107:  IF R[100:Product controle]>1,JMP LBL[500] ;
 108:  WAIT    .01(sec) ;
 109:  R[100:Product controle]=R[100:Product controle]+.01    ;
 110:  JMP LBL[40] ;
 111:   ;
 112:  LBL[50:UITNAME OK ] ;
 113:  R[100:Product controle]=0    ;
 114:   ;
 115:  !Spuitgietmachine sluiten ;
 116:  DO[11025]=PULSE,0.5sec ;
 117:  R[2:Induiktijd]=TIMER[1]    ;
 118:  IF DI[10:Fout product]=ON,JMP LBL[510] ;
 119:J P[50:deurpos] 60% CNT80    ;
 120:   ;
 121:  LBL[60:OPSTART AFKEUR] ;
 122:  IF R[10:Opstart aantal]=0,JMP LBL[200] ;
 123:  IF R[29:Start afleg]=0,JMP LBL[510] ;
 124:   ;
 125:  !TUSSENPOSITIONEREN ;
 126:  LBL[200:Tussenpositioner] ;
 127:  CALL POSITIE7    ;
 128:   ;
 129:  !Controle fouten na centreren ;
 130:  IF R[40:Grijpfout centre]=1,JMP LBL[505] ;
 131:  IF R[47:Centrer niet vri]=1,JMP LBL[735] ;
 132:   ;
 133:  !PRINTEN BERGSTEIN ;
 134:  LBL[210:Printen] ;
 135:   ;
 136:  !Controle lekbak/magneet aanwezig ;
 137:  IF DI[72:Afdekkap aanwzg]=OFF,JMP LBL[211] ;
 138:  CALL TEKST(800) ;
 139:   ;
 140:  !Robot veilig bewegen van printer ;
 141:J P[51:Weg van  printer] 25% CNT100    ;
 142:   ;
 143:  WAIT DI[72:Afdekkap aanwzg]=OFF    ;
 144:J P[52:Terug naar print] 25% CNT100    ;
 145:   ;
 146:  CALL TEKST(3) ;
 147:   ;
 148:  LBL[211:Start printen] ;
 149:  CALL PRINTENENKEL    ;
 150:  UFRAME_NUM=1 ;
 151:   ;
 152:  !% Snelheid = register 49 ;
 153:  OVERRIDE=R[49:Snelheid] ;
 154:   ;
 155:  !Controle fouten na printen ;
 156:  IF R[38:Hoogte fout]=1,JMP LBL[720] ;
 157:   ;
 158:  !AFLEGGEN OP CORONA BAND ;
 159:  LBL[230:Afleggen] ;
 160:  CALL B_AFLEGENKEL    ;
 161:   ;
 162:  UFRAME_NUM=1 ;
 163:   ;
 164:  !Controle fouten na afleggen ;
 165:  IF R[42:Grijpfout bufffe]=1,JMP LBL[730] ;
 166:  IF R[43:Bufferstapel vol]=1,JMP LBL[740] ;
 167:  IF R[39:Buffer niet vrij]=1,JMP LBL[750] ;
 168:   ;
 169:  !Naar begin programma ;
 170:  LBL[490] ;
 171:  UFRAME_NUM=1 ;
 172:J P[50:deurpos] 75% CNT60    ;
 173:  Open hand 1    ;
 174:  Open hand 2    ;
 175:J P[3:naar SGM] 85% CNT60    ;
 176:J P[6:Voor induik] 85% CNT100    ;
 177:  JMP LBL[20] ;
 178:   ;
 179:   ;
 180:  !******STORINGEN****** ;
 181:   ;
 182:  LBL[500:UITNAME FOUT] ;
 183:  CALL TEKST(500) ;
 184:  R[100:Product controle]=0    ;
 185:J P[1:rust positie] 30% FINE    ;
 186:  CALL DUMPEN    ;
 187:  WAIT DI[7:Automaat]=OFF    ;
 188:   ;
 189:  !Lamp USER 2 AAN op fanuc kast ;
 190:  DO[54:User2]=ON ;
 191:  WAIT DI[45:USER 2]=ON    ;
 192:   ;
 193:  !Lamp USER 2 AAN op fanuc kast ;
 194:  DO[54:User2]=OFF ;
 195:  END ;
 196:   ;
 197:  LBL[505:GRIJPFOUT CNTRER] ;
 198:  CALL TEKST(510) ;
 199:  R[100:Product controle]=0    ;
 200:  R[40:Grijpfout centre]=0    ;
 201:J P[1:rust positie] 30% FINE    ;
 202:  CALL DUMPEN    ;
 203:  WAIT DI[7:Automaat]=OFF    ;
 204:   ;
 205:  !Lamp USER 2 AAN op fanuc kast ;
 206:  DO[54:User2]=ON ;
 207:  WAIT DI[45:USER 2]=ON    ;
 208:   ;
 209:  !Lamp USER 2 AAN op fanuc kast ;
 210:  DO[54:User2]=OFF ;
 211:   ;
 212:  LBL[506:Cntle positi vry] ;
 213:  IF DI[23:Positioneer vrij]=OFF,JMP LBL[507] ;
 214:   ;
 215:  CALL TEKST(735) ;
 216:   ;
 217:  !Lamp USER 2 AAN op fanuc kast ;
 218:  DO[54:User2]=ON ;
 219:  WAIT DI[45:USER 2]=ON    ;
 220:   ;
 221:  !Lamp USER 2 AAN op fanuc kast ;
 222:  DO[54:User2]=OFF ;
 223:  JMP LBL[506] ;
 224:   ;
 225:  LBL[507:Positioneer vry] ;
 226:  END ;
 227:   ;
 228:  LBL[510:DUMPEN PRODUCTEN] ;
 229:  CALL DUMPEN    ;
 230:  R[28:Act dump]=R[28:Act dump]+1    ;
 231:J P[3:naar SGM] 30% FINE    ;
 232:J P[6:Voor induik] 30% FINE    ;
 233:  IF R[28:Act dump]>=R[10:Opstart aantal],JMP LBL[520] ;
 234:  JMP LBL[20] ;
 235:   ;
 236:  LBL[520:Aantal bereikt] ;
 237:  R[29:Start afleg]=1    ;
 238:  JMP LBL[20] ;
 239:   ;
 240:  LBL[530:SGM UIT AUTOMAAT] ;
 241:  R[100:Product controle]=0    ;
 242:J P[1:rust positie] 30% FINE    ;
 243:   ;
 244:  !DO :Blower corona uit ;
 245:  DO[51:IONblower Corona]=OFF ;
 246:  END ;
 247:   ;
 248:  LBL[570:Grijpfout induik] ;
 249:J P[3:naar SGM] 65% CNT100    ;
 250:   ;
 251:  LBL[580:Gryprfout induik] ;
 252:  CALL TEKST(581) ;
 253:J P[1:rust positie] 30% FINE    ;
 254:  CALL DUMPEN    ;
 255:  WAIT DI[7:Automaat]=OFF    ;
 256:   ;
 257:  !Lamp USER 2 AAN op fanuc kast ;
 258:  DO[54:User2]=ON ;
 259:  WAIT DI[45:USER 2]=ON    ;
 260:   ;
 261:  !Lamp USER 2 AAN op fanuc kast ;
 262:  DO[54:User2]=OFF ;
 263:  END ;
 264:   ;
 265:  LBL[720:HOOGTE FOUT PRNT] ;
 266:  CALL TEKST(725) ;
 267:  R[100:Product controle]=0    ;
 268:  R[38:Hoogte fout]=0    ;
 269:J P[1:rust positie] 30% FINE    ;
 270:   ;
 271:  CALL DUMPEN    ;
 272:  WAIT DI[7:Automaat]=OFF    ;
 273:   ;
 274:  !Lamp USER 2 AAN op fanuc kast ;
 275:  DO[54:User2]=ON ;
 276:  WAIT DI[45:USER 2]=ON    ;
 277:   ;
 278:  !Lamp USER 2 AAN op fanuc kast ;
 279:  DO[54:User2]=OFF ;
 280:  END ;
 281:   ;
 282:  LBL[730:GRIJPER FOUT BUF] ;
 283:  CALL TEKST(730) ;
 284:  R[100:Product controle]=0    ;
 285:  R[42:Grijpfout bufffe]=0    ;
 286:  R[9:Act R8]=0    ;
 287:J P[1:rust positie] 30% FINE    ;
 288:   ;
 289:  CALL DUMPEN    ;
 290:  WAIT DI[7:Automaat]=OFF    ;
 291:   ;
 292:  !Lamp USER 2 AAN op fanuc kast ;
 293:  DO[54:User2]=ON ;
 294:  WAIT DI[45:USER 2]=ON    ;
 295:   ;
 296:  !Lamp USER 2 AAN op fanuc kast ;
 297:  DO[54:User2]=OFF ;
 298:   ;
 299:  LBL[731:Contrle buf leeg] ;
 300:  IF DI[22:Buffer vrij]=ON,JMP LBL[732] ;
 301:   ;
 302:  CALL TEKST(1200) ;
 303:  !Lamp USER 2 AAN op fanuc kast ;
 304:  DO[54:User2]=ON ;
 305:  WAIT DI[45:USER 2]=ON    ;
 306:   ;
 307:  !Lamp USER 2 AAN op fanuc kast ;
 308:  DO[54:User2]=OFF ;
 309:  JMP LBL[7311] ;
 310:   ;
 311:  LBL[732:Buffer is vrij] ;
 312:   ;
 313:  !DO :RODE LAMP/BUZZER  UIT ;
 314:  DO[49:Buzzer hek]=OFF ;
 315:  DO[50:Rode lamp hek]=OFF ;
 316:  END ;
 317:   ;
 318:  LBL[735:Centrer niet vry] ;
 319:  CALL TEKST(735) ;
 320:  R[47:Centrer niet vri]=0    ;
 321:J P[1:rust positie] 30% FINE    ;
 322:  CALL DUMPEN    ;
 323:  WAIT DI[7:Automaat]=OFF    ;
 324:   ;
 325:  !Lamp USER 2 AAN op fanuc kast ;
 326:  DO[54:User2]=ON ;
 327:  WAIT DI[45:USER 2]=ON    ;
 328:   ;
 329:  !Lamp USER 2 AAN op fanuc kast ;
 330:  DO[54:User2]=OFF ;
 331:   ;
 332:  LBL[736:Cntle positi vry] ;
 333:  IF DI[70:Herpositie 2 FC]=OFF,JMP LBL[737] ;
 334:   ;
 335:  CALL TEKST(735) ;
 336:  !Lamp USER 2 AAN op fanuc kast ;
 337:  DO[54:User2]=ON ;
 338:  WAIT DI[45:USER 2]=ON    ;
 339:   ;
 340:  !Lamp USER 2 AAN op fanuc kast ;
 341:  DO[54:User2]=OFF ;
 342:  JMP LBL[736] ;
 343:   ;
 344:  LBL[737:Positioneer vry] ;
 345:  END ;
 346:   ;
 347:  LBL[740:BUFFER VOL] ;
 348:  CALL TEKST(740) ;
 349:J P[1:rust positie] 30% FINE    ;
 350:  R[9:Act R8]=0    ;
 351:  R[43:Bufferstapel vol]=0    ;
 352:  CALL DUMPEN    ;
 353:  WAIT DI[7:Automaat]=OFF    ;
 354:   ;
 355:  !Lamp USER 2 AAN op fanuc kast ;
 356:  DO[54:User2]=ON ;
 357:  WAIT DI[45:USER 2]=ON    ;
 358:   ;
 359:  !Lamp USER 2 AAN op fanuc kast ;
 360:  DO[54:User2]=OFF ;
 361:   ;
 362:  LBL[741:Contrle buf leeg] ;
 363:  IF DI[22:Buffer vrij]=ON,JMP LBL[742] ;
 364:   ;
 365:  CALL TEKST(1200) ;
 366:  !Lamp USER 2 AAN op fanuc kast ;
 367:  DO[54:User2]=ON ;
 368:  WAIT DI[45:USER 2]=ON    ;
 369:   ;
 370:  !Lamp USER 2 AAN op fanuc kast ;
 371:  DO[54:User2]=OFF ;
 372:  JMP LBL[741] ;
 373:   ;
 374:  LBL[742:Buffer vrij] ;
 375:  !DO :RODE LAMP UIT ;
 376:  DO[49:Buzzer hek]=OFF ;
 377:  DO[50:Rode lamp hek]=OFF ;
 378:  END ;
 379:   ;
 380:  LBL[750:BUFFER NIET VRY] ;
 381:  CALL TEKST(1200) ;
 382:J P[1:rust positie] 30% FINE    ;
 383:  R[9:Act R8]=0    ;
 384:  R[39:Buffer niet vrij]=0    ;
 385:   ;
 386:  CALL DUMPEN    ;
 387:   ;
 388:  WAIT DI[7:Automaat]=OFF    ;
 389:   ;
 390:  !Lamp USER 2 AAN op fanuc kast ;
 391:  DO[54:User2]=ON ;
 392:  WAIT DI[45:USER 2]=ON    ;
 393:   ;
 394:  !Lamp USER 2 AAN op fanuc kast ;
 395:  DO[54:User2]=OFF ;
 396:   ;
 397:  LBL[751:Contrle buf leeg] ;
 398:  IF DI[22:Buffer vrij]=ON,JMP LBL[752] ;
 399:   ;
 400:  CALL TEKST(1200) ;
 401:  !Lamp USER 2 AAN op fanuc kast ;
 402:  DO[54:User2]=ON ;
 403:  WAIT DI[45:USER 2]=ON    ;
 404:   ;
 405:  !Lamp USER 2 AAN op fanuc kast ;
 406:  DO[54:User2]=OFF ;
 407:  JMP LBL[751] ;
 408:   ;
 409:  LBL[752:Buffer vry] ;
 410:  !DO :RODE LAMP UIT ;
 411:  DO[49:Buzzer hek]=OFF ;
 412:  DO[50:Rode lamp hek]=OFF ;
 413:  END ;
 414:   ;
 415:  !******HOME ZOEKEN****** ;
 416:  LBL[1000:HOME ZOEKEN] ;
 417:  CALL TEKST(1000) ;
 418:  PAYLOAD[1] ;
 419:  OVERRIDE=25% ;
 420:  PR[100:Home Lpos]=LPOS    ;
 421:  R[200:Homezoek X]=PR[100,1:Home Lpos]    ;
 422:  R[199:Homezoek Y]=PR[100,2:Home Lpos]    ;
 423:  R[198:Homezoek Z]=PR[100,3:Home Lpos]    ;
 424:   ;
 425:  PR[99:Home Jpos]=JPOS    ;
 426:  R[193:J4]=PR[99,4:Home Jpos]    ;
 427:  R[194:J6]=PR[99,6:Home Jpos]    ;
 428:   ;
 429:  R[189:Act Uframe]=$MNUFRAMENUM[1] ;
 430:  R[188:Act Utool]=$MNUTOOLNUM[1] ;
 431:   ;
 432:  PR[97:P6]=P[6:Voor induik]    ;
 433:  R[192:P6-Y]=PR[97,2:P6]    ;
 434:  R[192:P6-Y]=R[192:P6-Y]+10    ;
 435:  PR[96:P11]=P[11:Na pak]    ;
 436:  R[191:P11-X]=PR[96,1:P11]    ;
 437:   ;
 438:  IF DO[100:Robot op reference]=ON,JMP LBL[1100] ;
 439:   ;
 440:  !--------------- ;
 441:  !--- ;
 442:  IF R[199:Homezoek Y]<500,JMP LBL[1010] ;
 443:  !--------------- ;
 444:   ;
 445:  IF R[199:Homezoek Y]<R[192:P6-Y],JMP LBL[1006] ;
 446:   ;
 447:  IF DI[1:Matrijs open]=ON,JMP LBL[1001] ;
 448:  CALL TEKST(1001) ;
 449:  WAIT DI[1:Matrijs open]=ON AND DI[3:Uitw. terug]=ON    ;
 450:   ;
 451:  LBL[1001] ;
 452:  Open hand 1    ;
 453:  Open hand 2    ;
 454:  PR[100,1:Home Lpos]=R[191:P11-X]    ;
 455:L PR[100:Home Lpos] 100mm/sec CNT20    ;
 456:  LBL[1005] ;
 457:  UTOOL_NUM=1 ;
 458:L P[15:Buiten SGM] 300mm/sec FINE    ;
 459:   ;
 460:  LBL[1006:Buiten SGM] ;
 461:L P[15:Buiten SGM] 300mm/sec FINE    ;
 462:J P[3:naar SGM] 15% FINE    ;
 463:  JMP LBL[1100] ;
 464:   ;
 465:  !---------------- ;
 466:  !--- ;
 467:  LBL[1010] ;
 468:  CALL HOMEN    ;
 469:  JMP LBL[1100] ;
 470:  !--------------- ;
 471:   ;
 472:  LBL[1100] ;
 473:  R[90:Program gestart]=1    ;
 474:  UFRAME_NUM=1 ;
 475:  UTOOL_NUM=1 ;
 476:J P[1:rust positie] 30% CNT100    ;
 477:   ;
 478:  !Grijpers open ;
 479:  Open hand 1    ;
 480:  Open hand 2    ;
 481:   ;
 482:  R[7:Steekhoogte]=13.1    ;
 483:  R[9:Act R8]=0    ;
 484:  R[21:Grijper 1-voudig]=0    ;
 485:  R[35:Vertrag. induik]=1.2    ;
 486:  R[38:Hoogte fout]=0    ;
 487:  R[39:Buffer niet vrij]=0    ;
 488:  R[40:Grijpfout centre]=0    ;
 489:  R[41:Geen vrijg  slot]=0    ;
 490:  R[42:Grijpfout bufffe]=0    ;
 491:  R[43:Bufferstapel vol]=0    ;
 492:  R[45:Teller ontstapel]=0    ;
 493:  R[46:Cyclusteller]=0    ;
 494:  R[47:Centrer niet vri]=0    ;
 495:  R[49:Snelheid]=60    ;
 496:   ;
 497:  !PRINTER AFSTELING ;
 498:  !Waardes ophalen uit positie ;
 499:  PR[38:Offset print 1]=P[201]    ;
 500:  PR[39:Offset print 2]=P[202]    ;
 501:   ;
 502:  DO[52:IONblower witband]=ON ;
 503:  DO[49:Buzzer hek]=OFF ;
 504:  DO[50:Rode lamp hek]=OFF ;
 505:   ;
 506:  !Controle centreer leeg ;
 507:  LBL[2000] ;
 508:  IF DI[23:Positioneer vrij]=ON,JMP LBL[2100] ;
 509:   ;
 510:  !Controle buffer leeg ;
 511:  LBL[2001] ;
 512:  IF DI[22:Buffer vrij]=OFF,JMP LBL[2101] ;
 513:   ;
 514:  !AANSTURING SNAARBANDJE--- JA ;
 515:  !AANSTURING CORONA-------- NEE ;
 516:  !AANSTURING ANTI STATIC--- JA ;
 517:  !AANSTURING WHITE STRIPE-- NEE ;
 518:  DO[15020]=OFF ;
 519:  DO[15021]=ON ;
 520:  DO[15022]=OFF ;
 521:  DO[15023]=OFF ;
 522:  DO[15024]=OFF ;
 523:  DO[15025]=OFF ;
 524:  DO[15026]=OFF ;
 525:   ;
 526:  !Reset tafel vol ;
 527:  DO[14419]=OFF ;
 528:  END ;
 529:   ;
 530:  LBL[2100:Opstart controle] ;
 531:  CALL TEKST(1300) ;
 532:  !Lamp USER 2 AAN op fanuc kast ;
 533:  DO[54:User2]=ON ;
 534:  WAIT DI[45:USER 2]=ON    ;
 535:   ;
 536:  !Lamp USER 2 AAN op fanuc kast ;
 537:  DO[54:User2]=OFF ;
 538:  JMP LBL[2000] ;
 539:   ;
 540:  LBL[2101:Opstart controle] ;
 541:  CALL TEKST(1200) ;
 542:  !Lamp USER 2 AAN op fanuc kast ;
 543:  DO[54:User2]=ON ;
 544:  WAIT DI[45:USER 2]=ON    ;
 545:   ;
 546:  !Lamp USER 2 AAN op fanuc kast ;
 547:  DO[54:User2]=OFF ;
 548:  JMP LBL[2001] ;
 549:   ;
 550:  END ;
 551:  !-------------------------------- ;
 552:  !Offset registers voor printer ;
 553:  !Offset waarden opslaan ;
 554:J P[201] 1% FINE    ;
 555:J P[202] 1% FINE    ;
 556:  !-------------------------------- ;
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
