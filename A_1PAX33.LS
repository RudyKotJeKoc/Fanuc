/PROG  A_1PAX33
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "DIGITAL PRINT140";
PROG_SIZE	= 11124;
CREATE		= DATE 19-01-23  TIME 18:45:02;
MODIFIED	= DATE 19-01-23  TIME 19:19:04;
FILE_NAME	= A_1PAX09;
VERSION		= 0;
LINE_COUNT	= 546;
MEMORY_SIZE	= 11964;
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
  74:  !UITNEMEN PRODUCT ;
  75:  LBL[32:Pak product] ;
  76:  WAIT R[13] ;
  77:L P[9:Voor pak] 500mm/sec CNT10    ;
  78:L P[10:Pakpos] 500mm/sec FINE    ;
  79:   ;
  80:  !Grijpers dicht ;
  81:  Close hand 1    ;
  82:   ;
  83:  !Paktijd vertraging  ;
  84:  WAIT R[5] ;
  85:L P[11:Na pak] 500mm/sec CNT10    ;
  86:  !Uitstoter terug ;
  87:  DO[11017]=OFF ;
  88:   ;
  89:L P[15:Buiten SGM] 1500mm/sec CNT50    ;
  90:   ;
  91:  !% Snelheid = register 49 ;
  92:  OVERRIDE=R[49:Snelheid] ;
  93:   ;
  94:  LBL[40:UITNAME CONTROLE] ;
  95:  IF RI[1:Bek B Open]=ON AND RI[2:Bek B product aanwezig]=OFF AND RI[3:Bek A Open]=OFF AND RI[4:Bek A product aanwezig]=ON,JMP LBL[50] ;
  96:  IF R[100:Product controle]>1,JMP LBL[500] ;
  97:  WAIT    .01(sec) ;
  98:  R[100:Product controle]=R[100:Product controle]+.01    ;
  99:  JMP LBL[40] ;
 100:   ;
 101:  LBL[50:UITNAME OK ] ;
 102:  R[100:Product controle]=0    ;
 103:   ;
 104:  !Spuitgietmachine sluiten ;
 105:  DO[11025]=PULSE,0.5sec ;
 106:  R[2:Induiktijd]=TIMER[1]    ;
 107:  IF DI[10:Fout product]=ON,JMP LBL[510] ;
 108:J P[50:deurpos] 60% CNT80    ;
 109:   ;
 110:  LBL[60:OPSTART AFKEUR] ;
 111:  IF R[10:Opstart aantal]=0,JMP LBL[200] ;
 112:  IF R[29:Start afleg]=0,JMP LBL[510] ;
 113:   ;
 114:  !TUSSENPOSITIONEREN ;
 115:  LBL[200:Tussenpositioner] ;
 116:  CALL POSITIE5    ;
 117:   ;
 118:  !Controle fouten na centreren ;
 119:  IF R[40:Grijpfout centre]=1,JMP LBL[505] ;
 120:  IF R[47:Centrer niet vri]=1,JMP LBL[735] ;
 121:   ;
 122:  !PRINTEN BERGSTEIN ;
 123:  LBL[210:Printen] ;
 124:   ;
 125:  !Controle lekbak/magneet aanwezig ;
 126:  IF DI[72:Afdekkap aanwzg]=OFF,JMP LBL[211] ;
 127:  CALL TEKST(800) ;
 128:   ;
 129:  !Robot veilig bewegen van printer ;
 130:J P[51:Weg van  printer] 25% CNT100    ;
 131:   ;
 132:  WAIT DI[72:Afdekkap aanwzg]=OFF    ;
 133:J P[52:Terug naar print] 25% CNT100    ;
 134:   ;
 135:  CALL TEKST(3) ;
 136:   ;
 137:  LBL[211:Start printen] ;
 138:  CALL PRINTEN    ;
 139:  UFRAME_NUM=1 ;
 140:   ;
 141:  !% Snelheid = register 49 ;
 142:  OVERRIDE=R[49:Snelheid] ;
 143:   ;
 144:  !Controle fouten na printen ;
 145:  IF R[38:Hoogte fout]=1,JMP LBL[720] ;
 146:   ;
 147:  !AFLEGGEN OP CORONA BAND ;
 148:  LBL[230:Afleggen] ;
 149:  CALL B_AFLEG    ;
 150:   ;
 151:  UFRAME_NUM=1 ;
 152:   ;
 153:  !Controle fouten na afleggen ;
 154:  IF R[42:Grijpfout bufffe]=1,JMP LBL[730] ;
 155:  IF R[43:Bufferstapel vol]=1,JMP LBL[740] ;
 156:  IF R[39:Buffer niet vrij]=1,JMP LBL[750] ;
 157:   ;
 158:  !Naar begin programma ;
 159:  LBL[490] ;
 160:  UFRAME_NUM=1 ;
 161:J P[50:deurpos] 75% CNT60    ;
 162:  Open hand 1    ;
 163:  Open hand 2    ;
 164:J P[3:naar SGM] 85% CNT60    ;
 165:J P[6:Voor induik] 85% CNT100    ;
 166:  JMP LBL[20] ;
 167:   ;
 168:   ;
 169:  !******STORINGEN****** ;
 170:   ;
 171:  LBL[500:UITNAME FOUT] ;
 172:  CALL TEKST(500) ;
 173:  R[100:Product controle]=0    ;
 174:J P[1:rust positie] 30% FINE    ;
 175:  CALL DUMPEN    ;
 176:  WAIT DI[7:Automaat]=OFF    ;
 177:   ;
 178:  !Lamp USER 2 AAN op fanuc kast ;
 179:  DO[54:User2]=ON ;
 180:  WAIT DI[45:USER 2]=ON    ;
 181:   ;
 182:  !Lamp USER 2 AAN op fanuc kast ;
 183:  DO[54:User2]=OFF ;
 184:  END ;
 185:   ;
 186:  LBL[505:GRIJPFOUT CNTRER] ;
 187:  CALL TEKST(510) ;
 188:  R[100:Product controle]=0    ;
 189:  R[40:Grijpfout centre]=0    ;
 190:J P[1:rust positie] 30% FINE    ;
 191:  CALL DUMPEN    ;
 192:  WAIT DI[7:Automaat]=OFF    ;
 193:   ;
 194:  !Lamp USER 2 AAN op fanuc kast ;
 195:  DO[54:User2]=ON ;
 196:  WAIT DI[45:USER 2]=ON    ;
 197:   ;
 198:  !Lamp USER 2 AAN op fanuc kast ;
 199:  DO[54:User2]=OFF ;
 200:   ;
 201:  LBL[506:Cntle positi vry] ;
 202:  IF DI[23:Positioneer vrij]=OFF,JMP LBL[507] ;
 203:   ;
 204:  CALL TEKST(735) ;
 205:   ;
 206:  !Lamp USER 2 AAN op fanuc kast ;
 207:  DO[54:User2]=ON ;
 208:  WAIT DI[45:USER 2]=ON    ;
 209:   ;
 210:  !Lamp USER 2 AAN op fanuc kast ;
 211:  DO[54:User2]=OFF ;
 212:  JMP LBL[506] ;
 213:   ;
 214:  LBL[507:Positioneer vry] ;
 215:  END ;
 216:   ;
 217:  LBL[510:DUMPEN PRODUCTEN] ;
 218:  CALL DUMPEN    ;
 219:  R[28:Act dump]=R[28:Act dump]+1    ;
 220:J P[3:naar SGM] 30% FINE    ;
 221:J P[6:Voor induik] 30% FINE    ;
 222:  IF R[28:Act dump]>=R[10:Opstart aantal],JMP LBL[520] ;
 223:  JMP LBL[20] ;
 224:   ;
 225:  LBL[520:Aantal bereikt] ;
 226:  R[29:Start afleg]=1    ;
 227:  JMP LBL[20] ;
 228:   ;
 229:  LBL[530:SGM UIT AUTOMAAT] ;
 230:  R[100:Product controle]=0    ;
 231:J P[1:rust positie] 30% FINE    ;
 232:   ;
 233:  !DO :Blower corona uit ;
 234:  DO[51:IONblower Corona]=OFF ;
 235:  END ;
 236:   ;
 237:  LBL[570:Grijpfout induik] ;
 238:J P[3:naar SGM] 65% CNT100    ;
 239:   ;
 240:  LBL[580:Gryprfout induik] ;
 241:  CALL TEKST(581) ;
 242:J P[1:rust positie] 30% FINE    ;
 243:  CALL DUMPEN    ;
 244:  WAIT DI[7:Automaat]=OFF    ;
 245:   ;
 246:  !Lamp USER 2 AAN op fanuc kast ;
 247:  DO[54:User2]=ON ;
 248:  WAIT DI[45:USER 2]=ON    ;
 249:   ;
 250:  !Lamp USER 2 AAN op fanuc kast ;
 251:  DO[54:User2]=OFF ;
 252:  END ;
 253:   ;
 254:  LBL[720:HOOGTE FOUT PRNT] ;
 255:  CALL TEKST(725) ;
 256:  R[100:Product controle]=0    ;
 257:  R[38:Hoogte fout]=0    ;
 258:J P[1:rust positie] 30% FINE    ;
 259:   ;
 260:  CALL DUMPEN    ;
 261:  WAIT DI[7:Automaat]=OFF    ;
 262:   ;
 263:  !Lamp USER 2 AAN op fanuc kast ;
 264:  DO[54:User2]=ON ;
 265:  WAIT DI[45:USER 2]=ON    ;
 266:   ;
 267:  !Lamp USER 2 AAN op fanuc kast ;
 268:  DO[54:User2]=OFF ;
 269:  END ;
 270:   ;
 271:  LBL[730:GRIJPER FOUT BUF] ;
 272:  CALL TEKST(730) ;
 273:  R[100:Product controle]=0    ;
 274:  R[42:Grijpfout bufffe]=0    ;
 275:  R[9:Act R8]=0    ;
 276:J P[1:rust positie] 30% FINE    ;
 277:   ;
 278:  CALL DUMPEN    ;
 279:  WAIT DI[7:Automaat]=OFF    ;
 280:   ;
 281:  !Lamp USER 2 AAN op fanuc kast ;
 282:  DO[54:User2]=ON ;
 283:  WAIT DI[45:USER 2]=ON    ;
 284:   ;
 285:  !Lamp USER 2 AAN op fanuc kast ;
 286:  DO[54:User2]=OFF ;
 287:   ;
 288:  LBL[731:Contrle buf leeg] ;
 289:  IF DI[22:Buffer vrij]=ON,JMP LBL[732] ;
 290:   ;
 291:  CALL TEKST(1200) ;
 292:  !Lamp USER 2 AAN op fanuc kast ;
 293:  DO[54:User2]=ON ;
 294:  WAIT DI[45:USER 2]=ON    ;
 295:   ;
 296:  !Lamp USER 2 AAN op fanuc kast ;
 297:  DO[54:User2]=OFF ;
 298:  JMP LBL[7311] ;
 299:   ;
 300:  LBL[732:Buffer is vrij] ;
 301:   ;
 302:  !DO :RODE LAMP/BUZZER  UIT ;
 303:  DO[49:Buzzer hek]=OFF ;
 304:  DO[50:Rode lamp hek]=OFF ;
 305:  END ;
 306:   ;
 307:  LBL[735:Centrer niet vry] ;
 308:  CALL TEKST(735) ;
 309:  R[47:Centrer niet vri]=0    ;
 310:J P[1:rust positie] 30% FINE    ;
 311:  CALL DUMPEN    ;
 312:  WAIT DI[7:Automaat]=OFF    ;
 313:   ;
 314:  !Lamp USER 2 AAN op fanuc kast ;
 315:  DO[54:User2]=ON ;
 316:  WAIT DI[45:USER 2]=ON    ;
 317:   ;
 318:  !Lamp USER 2 AAN op fanuc kast ;
 319:  DO[54:User2]=OFF ;
 320:   ;
 321:  LBL[736:Cntle positi vry] ;
 322:  IF DI[70:Herpositie 2 FC]=OFF,JMP LBL[737] ;
 323:   ;
 324:  CALL TEKST(735) ;
 325:  !Lamp USER 2 AAN op fanuc kast ;
 326:  DO[54:User2]=ON ;
 327:  WAIT DI[45:USER 2]=ON    ;
 328:   ;
 329:  !Lamp USER 2 AAN op fanuc kast ;
 330:  DO[54:User2]=OFF ;
 331:  JMP LBL[736] ;
 332:   ;
 333:  LBL[737:Positioneer vry] ;
 334:  END ;
 335:   ;
 336:  LBL[740:BUFFER VOL] ;
 337:  CALL TEKST(740) ;
 338:J P[1:rust positie] 30% FINE    ;
 339:  R[9:Act R8]=0    ;
 340:  R[43:Bufferstapel vol]=0    ;
 341:  CALL DUMPEN    ;
 342:  WAIT DI[7:Automaat]=OFF    ;
 343:   ;
 344:  !Lamp USER 2 AAN op fanuc kast ;
 345:  DO[54:User2]=ON ;
 346:  WAIT DI[45:USER 2]=ON    ;
 347:   ;
 348:  !Lamp USER 2 AAN op fanuc kast ;
 349:  DO[54:User2]=OFF ;
 350:   ;
 351:  LBL[741:Contrle buf leeg] ;
 352:  IF DI[22:Buffer vrij]=ON,JMP LBL[742] ;
 353:   ;
 354:  CALL TEKST(1200) ;
 355:  !Lamp USER 2 AAN op fanuc kast ;
 356:  DO[54:User2]=ON ;
 357:  WAIT DI[45:USER 2]=ON    ;
 358:   ;
 359:  !Lamp USER 2 AAN op fanuc kast ;
 360:  DO[54:User2]=OFF ;
 361:  JMP LBL[741] ;
 362:   ;
 363:  LBL[742:Buffer vrij] ;
 364:  !DO :RODE LAMP UIT ;
 365:  DO[49:Buzzer hek]=OFF ;
 366:  DO[50:Rode lamp hek]=OFF ;
 367:  END ;
 368:   ;
 369:  LBL[750:BUFFER NIET VRY] ;
 370:  CALL TEKST(1200) ;
 371:J P[1:rust positie] 30% FINE    ;
 372:  R[9:Act R8]=0    ;
 373:  R[39:Buffer niet vrij]=0    ;
 374:   ;
 375:  CALL DUMPEN    ;
 376:   ;
 377:  WAIT DI[7:Automaat]=OFF    ;
 378:   ;
 379:  !Lamp USER 2 AAN op fanuc kast ;
 380:  DO[54:User2]=ON ;
 381:  WAIT DI[45:USER 2]=ON    ;
 382:   ;
 383:  !Lamp USER 2 AAN op fanuc kast ;
 384:  DO[54:User2]=OFF ;
 385:   ;
 386:  LBL[751:Contrle buf leeg] ;
 387:  IF DI[22:Buffer vrij]=ON,JMP LBL[752] ;
 388:   ;
 389:  CALL TEKST(1200) ;
 390:  !Lamp USER 2 AAN op fanuc kast ;
 391:  DO[54:User2]=ON ;
 392:  WAIT DI[45:USER 2]=ON    ;
 393:   ;
 394:  !Lamp USER 2 AAN op fanuc kast ;
 395:  DO[54:User2]=OFF ;
 396:  JMP LBL[751] ;
 397:   ;
 398:  LBL[752:Buffer vry] ;
 399:  !DO :RODE LAMP UIT ;
 400:  DO[49:Buzzer hek]=OFF ;
 401:  DO[50:Rode lamp hek]=OFF ;
 402:  END ;
 403:   ;
 404:  !******HOME ZOEKEN****** ;
 405:  LBL[1000:HOME ZOEKEN] ;
 406:  CALL TEKST(1000) ;
 407:  PAYLOAD[1] ;
 408:  OVERRIDE=25% ;
 409:  PR[100:Home Lpos]=LPOS    ;
 410:  R[200:Homezoek X]=PR[100,1:Home Lpos]    ;
 411:  R[199:Homezoek Y]=PR[100,2:Home Lpos]    ;
 412:  R[198:Homezoek Z]=PR[100,3:Home Lpos]    ;
 413:   ;
 414:  PR[99:Home Jpos]=JPOS    ;
 415:  R[193:J4]=PR[99,4:Home Jpos]    ;
 416:  R[194:J6]=PR[99,6:Home Jpos]    ;
 417:   ;
 418:  R[189:Act Uframe]=$MNUFRAMENUM[1] ;
 419:  R[188:Act Utool]=$MNUTOOLNUM[1] ;
 420:   ;
 421:  PR[97:P6]=P[6:Voor induik]    ;
 422:  R[192:P6-Y]=PR[97,2:P6]    ;
 423:  R[192:P6-Y]=R[192:P6-Y]+10    ;
 424:  PR[96:P11]=P[11:Na pak]    ;
 425:  R[191:P11-X]=PR[96,1:P11]    ;
 426:   ;
 427:  IF DO[100:Robot op reference]=ON,JMP LBL[1100] ;
 428:   ;
 429:  !--------------- ;
 430:  !--- ;
 431:  IF R[199:Homezoek Y]<500,JMP LBL[1010] ;
 432:  !--------------- ;
 433:   ;
 434:  IF R[199:Homezoek Y]<R[192:P6-Y],JMP LBL[1006] ;
 435:   ;
 436:  IF DI[1:Matrijs open]=ON,JMP LBL[1001] ;
 437:  CALL TEKST(1001) ;
 438:  WAIT DI[1:Matrijs open]=ON AND DI[3:Uitw. terug]=ON    ;
 439:   ;
 440:  LBL[1001] ;
 441:  Open hand 1    ;
 442:  Open hand 2    ;
 443:  PR[100,1:Home Lpos]=R[191:P11-X]    ;
 444:L PR[100:Home Lpos] 100mm/sec CNT20    ;
 445:  LBL[1005] ;
 446:  UTOOL_NUM=1 ;
 447:L P[15:Buiten SGM] 300mm/sec FINE    ;
 448:   ;
 449:  LBL[1006:Buiten SGM] ;
 450:L P[15:Buiten SGM] 300mm/sec FINE    ;
 451:J P[3:naar SGM] 15% FINE    ;
 452:  JMP LBL[1100] ;
 453:   ;
 454:  !---------------- ;
 455:  !--- ;
 456:  LBL[1010] ;
 457:  CALL HOMEN    ;
 458:  JMP LBL[1100] ;
 459:  !--------------- ;
 460:   ;
 461:  LBL[1100] ;
 462:  R[90:Program gestart]=1    ;
 463:  UFRAME_NUM=1 ;
 464:  UTOOL_NUM=1 ;
 465:J P[1:rust positie] 30% CNT100    ;
 466:   ;
 467:  !Grijpers open ;
 468:  Open hand 1    ;
 469:  Open hand 2    ;
 470:   ;
 471:  R[7:Steekhoogte]=13.1    ;
 472:  R[9:Act R8]=0    ;
 473:  R[13:Induikvertraging]=1.7    ;
 474:  R[21:Grijper 1-voudig]=1    ;
 475:  R[35:Vertrag. induik]=1.2    ;
 476:  R[38:Hoogte fout]=0    ;
 477:  R[39:Buffer niet vrij]=0    ;
 478:  R[40:Grijpfout centre]=0    ;
 479:  R[41:Geen vrijg  slot]=0    ;
 480:  R[42:Grijpfout bufffe]=0    ;
 481:  R[43:Bufferstapel vol]=0    ;
 482:  R[45:Teller ontstapel]=0    ;
 483:  R[46:Cyclusteller]=0    ;
 484:  R[47:Centrer niet vri]=0    ;
 485:  R[49:Snelheid]=50    ;
 486:   ;
 487:  !PRINTER AFSTELING ;
 488:  !Waardes ophalen uit positie ;
 489:  PR[38:Offset print 1]=P[201]    ;
 490:  PR[39:Offset print 2]=P[202]    ;
 491:   ;
 492:  DO[52:IONblower witband]=ON ;
 493:  DO[49:Buzzer hek]=OFF ;
 494:  DO[50:Rode lamp hek]=OFF ;
 495:   ;
 496:  !Controle centreer leeg ;
 497:  LBL[2000] ;
 498:  IF DI[23:Positioneer vrij]=ON,JMP LBL[2100] ;
 499:   ;
 500:  !Controle buffer leeg ;
 501:  LBL[2001] ;
 502:  IF DI[22:Buffer vrij]=OFF,JMP LBL[2101] ;
 503:   ;
 504:  !AANSTURING SNAARBANDJE--- JA ;
 505:  !AANSTURING CORONA-------- NEE ;
 506:  !AANSTURING ANTI STATIC--- JA ;
 507:  !AANSTURING WHITE STRIPE-- NEE ;
 508:  DO[15020]=OFF ;
 509:  DO[15021]=ON ;
 510:  DO[15022]=OFF ;
 511:  DO[15023]=OFF ;
 512:  DO[15024]=OFF ;
 513:  DO[15025]=OFF ;
 514:  DO[15026]=OFF ;
 515:   ;
 516:  !Reset tafel vol ;
 517:  DO[14419]=OFF ;
 518:  END ;
 519:   ;
 520:  LBL[2100:Opstart controle] ;
 521:  CALL TEKST(1300) ;
 522:  !Lamp USER 2 AAN op fanuc kast ;
 523:  DO[54:User2]=ON ;
 524:  WAIT DI[45:USER 2]=ON    ;
 525:   ;
 526:  !Lamp USER 2 AAN op fanuc kast ;
 527:  DO[54:User2]=OFF ;
 528:  JMP LBL[2000] ;
 529:   ;
 530:  LBL[2101:Opstart controle] ;
 531:  CALL TEKST(1200) ;
 532:  !Lamp USER 2 AAN op fanuc kast ;
 533:  DO[54:User2]=ON ;
 534:  WAIT DI[45:USER 2]=ON    ;
 535:   ;
 536:  !Lamp USER 2 AAN op fanuc kast ;
 537:  DO[54:User2]=OFF ;
 538:  JMP LBL[2001] ;
 539:   ;
 540:  END ;
 541:  !-------------------------------- ;
 542:  !Offset registers voor printer ;
 543:  !Offset waarden opslaan ;
 544:J P[201] 1% FINE    ;
 545:J P[202] 1% FINE    ;
 546:  !-------------------------------- ;
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
	X =   290.000  mm,	Y =   700.000  mm,	Z =   610.000  mm,
	W =   -83.262 deg,	P =   -89.285 deg,	R =   -96.679 deg
};
P[9:"Voor pak"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   290.000  mm,	Y =  1406.500  mm,	Z =   610.350  mm,
	W =   -83.304 deg,	P =   -89.284 deg,	R =   -96.638 deg
};
P[10:"Pakpos"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   328.000  mm,	Y =  1406.500  mm,	Z =   610.350  mm,
	W =   -83.304 deg,	P =   -89.284 deg,	R =   -96.638 deg
};
P[11:"Na pak"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   290.000  mm,	Y =  1406.500  mm,	Z =   610.350  mm,
	W =   -83.304 deg,	P =   -89.284 deg,	R =   -96.638 deg
};
P[15:"Buiten SGM"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   290.000  mm,	Y =   650.000  mm,	Z =   610.350  mm,
	W =   -83.304 deg,	P =   -89.285 deg,	R =   -96.638 deg
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
