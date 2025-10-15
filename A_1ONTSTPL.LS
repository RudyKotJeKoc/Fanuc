/PROG  A_1ONTSTPL
/ATTR
OWNER		= MNEDITOR;
COMMENT		= "Ontstapelmagazyn";
PROG_SIZE	= 13532;
CREATE		= DATE 19-02-23  TIME 21:21:52;
MODIFIED	= DATE 19-04-01  TIME 17:33:34;
FILE_NAME	= ONTSTPL;
VERSION		= 0;
LINE_COUNT	= 655;
MEMORY_SIZE	= 14328;
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
   4:  !MET ONTSTAPELMAGAZYN EN ;
   5:  !PRINTER ;
   6:   ;
   7:  UFRAME_NUM=1 ;
   8:  UTOOL_NUM=1 ;
   9:   ;
  10:  IF R[90:Program gestart]=0,JMP LBL[1000] ;
  11:   ;
  12:  !START PROGRAMMA AFLOOP ;
  13:   ;
  14:  OVERRIDE=100% ;
  15:  CALL TEKST(3) ;
  16:  UFRAME_NUM=1 ;
  17:  UTOOL_NUM=1 ;
  18:J P[1:rust positie] 20% CNT100    ;
  19:   ;
  20:  !Grijpers open ;
  21:  Open hand 1    ;
  22:  Open hand 2    ;
  23:   ;
  24:  LBL[10:naar magazyn] ;
  25:J P[10:Naar magazijn] 70% CNT100    ;
  26:   ;
  27:  !Controleer robot stop ;
  28:  !Dit is de schakelaar by de witte ;
  29:  !Balk machine ;
  30:  WAIT DI[89:Robot stop ontst]=OFF    ;
  31:   ;
  32:  IF DI[20:Afl 1 vrij Corona]=OFF,JMP LBL[520] ;
  33:   ;
  34:  $WAITTMOUT=500 ;
  35:  !Skinetta storing  ;
  36:  WAIT DI[93:FC uitloop vrij]=OFF TIMEOUT,LBL[522] ;
  37:   ;
  38:  !_________________________    ;
  39:  !FOUTMELDING SCHIB WERKT NIET ;
  40:  JMP LBL[20] ;
  41:  !_________________________    ;
  42:   ;
  43:  !Pouch machine storing ;
  44:  WAIT DI[43:Alarm schib]=OFF TIMEOUT,LBL[521] ;
  45:   ;
  46:  !Controle magazyn OK ;
  47:  LBL[20] ;
  48:  IF DI[56:Magazijn niveau ok]=ON,JMP LBL[21] ;
  49:  CALL TEKST(511) ;
  50:   ;
  51:  !Controleer schakelaar ;
  52:  IF DI[79:Magazijn leegmaak]=OFF,JMP LBL[24] ;
  53:  JMP LBL[25] ;
  54:   ;
  55:  LBL[21:Magazyn nivo OK] ;
  56:  DO[49:Buzzer hek]=OFF ;
  57:  DO[50:Rode lamp hek]=OFF ;
  58:  CALL TEKST(3) ;
  59:  JMP LBL[25] ;
  60:   ;
  61:  LBL[24:W8 OP MAGZYN VOL] ;
  62:  DO[49:Buzzer hek]=PULSE,10.0sec ;
  63:  DO[50:Rode lamp hek]=ON ;
  64:  WAIT DI[56:Magazijn niveau ok]=ON    ;
  65:  JMP LBL[21] ;
  66:   ;
  67:  LBL[25] ;
  68:  !Controleer storingen magazijn ;
  69:  IF DI[16:Magazijnklep dicht]=OFF OR DO[44:Perslucht ontsta]=OFF,JMP LBL[500] ;
  70:   ;
  71:  IF DI[58:Slede op overname]=ON AND DO[15810]=OFF AND DO[15811]=OFF,JMP LBL[30] ;
  72:   ;
  73:  $WAITTMOUT=2000 ;
  74:  !DO15810 = Storing ontstapelaar ;
  75:  WAIT DO[15810]=OFF TIMEOUT,LBL[510] ;
  76:   ;
  77:  IF DO[15811]=OFF,JMP LBL[30] ;
  78:  IF DI[55:Magazijn is leeg]=ON,JMP LBL[515] ;
  79:  IF R[112:Act start]>2,JMP LBL[515] ;
  80:   ;
  81:  !Ontstapel 1x  ;
  82:  !DO 15809 = Ontstapelpuls ;
  83:  DO[15809]=PULSE,1.0sec ;
  84:  R[110:Act magazijn]=1    ;
  85:  R[112:Act start]=R[112:Act start]+1    ;
  86:  WAIT    .50(sec) ;
  87:  JMP LBL[20] ;
  88:   ;
  89:  !Afvragen welke gereed ligt ;
  90:  LBL[30:Product pakken] ;
  91:  R[111:Pos fout]=0    ;
  92:  R[112:Act start]=0    ;
  93:  IF R[110:Act magazijn]=1 AND DI[59:Ligging 1.1]=ON AND DI[60:Ligging 1.2]=OFF,JMP LBL[51] ;
  94:  IF R[110:Act magazijn]=1 AND DI[59:Ligging 1.1]=OFF AND DI[60:Ligging 1.2]=ON,JMP LBL[52] ;
  95:  IF R[110:Act magazijn]=2 AND DI[61:Ligging 2.1]=ON AND DI[62:Ligging 2.2]=OFF,JMP LBL[53] ;
  96:  IF R[110:Act magazijn]=2 AND DI[61:Ligging 2.1]=OFF AND DI[62:Ligging 2.2]=ON,JMP LBL[54] ;
  97:  IF R[110:Act magazijn]=3 AND DI[63:Ligging 3.1]=ON AND DI[64:Ligging 3.2]=OFF,JMP LBL[55] ;
  98:  IF R[110:Act magazijn]=3 AND DI[63:Ligging 3.1]=OFF AND DI[64:Ligging 3.2]=ON,JMP LBL[56] ;
  99:  IF R[110:Act magazijn]=4 AND DI[65:Ligging 4.1]=ON AND DI[66:Ligging 4.2]=OFF,JMP LBL[57] ;
 100:  IF R[110:Act magazijn]=4 AND DI[65:Ligging 4.1]=OFF AND DI[66:Ligging 4.2]=ON,JMP LBL[58] ;
 101:  IF R[110:Act magazijn]=5 AND DI[67:Ligging 5.1]=ON AND DI[68:Ligging 5.2]=OFF,JMP LBL[59] ;
 102:  IF R[110:Act magazijn]=5 AND DI[67:Ligging 5.1]=OFF AND DI[68:Ligging 5.2]=ON,JMP LBL[60] ;
 103:  R[110:Act magazijn]=R[110:Act magazijn]+1    ;
 104:  IF R[110:Act magazijn]>5,JMP LBL[31] ;
 105:  JMP LBL[30] ;
 106:   ;
 107:  LBL[31] ;
 108:  R[110:Act magazijn]=1    ;
 109:  JMP LBL[30] ;
 110:   ;
 111:   ;
 112:  !Afstellen pakposities ;
 113:   ;
 114:  !Positie mag 1 ;
 115:J P[101:1-0'] 10% FINE    ;
 116:J P[102:1-180'] 10% FINE    ;
 117:   ;
 118:  !Positie mag 2 ;
 119:J P[103:2-0'] 10% FINE    ;
 120:J P[104:2-180'] 10% FINE    ;
 121:   ;
 122:  !Positie mag 3 ;
 123:J P[105:3-0'] 10% FINE    ;
 124:J P[106:3-180'] 10% FINE    ;
 125:   ;
 126:  !Positie mag 4 ;
 127:J P[107:4-0'] 10% FINE    ;
 128:J P[108:4-180'] 10% FINE    ;
 129:   ;
 130:  !Positie mag 5 ;
 131:  !Deze pos zijn gelijk en product ;
 132:  !wordt op buffertafel gedraaid ;
 133:J P[109:5-0'] 10% FINE    ;
 134:J P[110:5-180'] 15% FINE    ;
 135:   ;
 136:  !Inlezen pakpositie ;
 137:   ;
 138:  LBL[51:Pakpos lezen] ;
 139:  PR[83:Pak mg]=P[101:1-0']    ;
 140:  JMP LBL[70] ;
 141:  LBL[52] ;
 142:  PR[83:Pak mg]=P[102:1-180']    ;
 143:  JMP LBL[70] ;
 144:  LBL[53] ;
 145:  PR[83:Pak mg]=P[103:2-0']    ;
 146:  JMP LBL[70] ;
 147:  LBL[54] ;
 148:  PR[83:Pak mg]=P[104:2-180']    ;
 149:  JMP LBL[70] ;
 150:  LBL[55] ;
 151:  PR[83:Pak mg]=P[105:3-0']    ;
 152:  JMP LBL[70] ;
 153:  LBL[56] ;
 154:  PR[83:Pak mg]=P[106:3-180']    ;
 155:  JMP LBL[70] ;
 156:  LBL[57] ;
 157:  PR[83:Pak mg]=P[107:4-0']    ;
 158:  JMP LBL[70] ;
 159:  LBL[58] ;
 160:  PR[83:Pak mg]=P[108:4-180']    ;
 161:  JMP LBL[70] ;
 162:  LBL[59] ;
 163:  PR[83:Pak mg]=P[109:5-0']    ;
 164:  JMP LBL[70] ;
 165:  LBL[60] ;
 166:  PR[83:Pak mg]=P[110:5-180']    ;
 167:  R[111:Pos fout]=1    ;
 168:  JMP LBL[70] ;
 169:   ;
 170:   ;
 171:  !Producten pakken ;
 172:  LBL[70:Naar pak] ;
 173:J P[70:voor magazyn] 70% CNT100    ;
 174:   ;
 175:  !Controle bekjes open ;
 176:  IF RI[1:Bek B Open]=OFF OR RI[3:Bek A Open]=OFF,JMP LBL[503] ;
 177:   ;
 178:J PR[83:Pak mg] 80% CNT100 Offset,PR[85:Boven mag 2]    ;
 179:L PR[83:Pak mg] 800mm/sec CNT100 Offset,PR[84:Boven mag 1]    ;
 180:L PR[83:Pak mg] 100mm/sec FINE    ;
 181:   ;
 182:  Close hand 2    ;
 183:  WAIT    .50(sec) ;
 184:   ;
 185:L PR[83:Pak mg] 50mm/sec CNT100 Offset,PR[84:Boven mag 1]    ;
 186:L PR[83:Pak mg] 800mm/sec CNT100 Offset,PR[85:Boven mag 2]    ;
 187:J P[90:na magazyn] 70% CNT100    ;
 188:   ;
 189:  !Nagaan of magazyn leeg is ;
 190:  IF DI[58:Slede op overname]=ON AND DO[15810]=OFF AND DO[15811]=OFF,JMP LBL[200] ;
 191:   ;
 192:  !Ontstapel 1x ;
 193:  DO[15809]=PULSE,0.2sec ;
 194:  R[110:Act magazijn]=1    ;
 195:   ;
 196:  IF R[111:Pos fout]=1,JMP LBL[501] ;
 197:   ;
 198:  !TUSSENPOSITIONEREN ;
 199:  LBL[200] ;
 200:   ;
 201:  !Controle zonder bedrukking ;
 202:  IF DI[76:Ontstapel zonder print]=ON,JMP LBL[502] ;
 203:   ;
 204:  CALL POSITIE6    ;
 205:  IF R[40:Grijpfout centre]=1,JMP LBL[505] ;
 206:  IF R[47:Centrer niet vri]=1,JMP LBL[735] ;
 207:   ;
 208:  PR[38:Offset print 1]=P[201]    ;
 209:  PR[39:Offset print 2]=P[202]    ;
 210:  JMP LBL[210] ;
 211:   ;
 212:   ;
 213:  !-------------------------------- ;
 214:  !Offset waarden opslaan ;
 215:J P[201] 10% FINE    ;
 216:J P[202] 10% FINE    ;
 217:  !-------------------------------- ;
 218:   ;
 219:   ;
 220:  !Printen ;
 221:  LBL[210:Printen] ;
 222:  IF DI[72:Afdekkap aanwzg]=OFF,JMP LBL[211] ;
 223:  CALL TEKST(800) ;
 224:   ;
 225:  !Robot veilig bewegen van printer ;
 226:J P[5:Weg van  printer] 25% CNT100    ;
 227:   ;
 228:  WAIT DI[72:Afdekkap aanwzg]=OFF    ;
 229:J P[7:Terug naar print] 25% CNT100    ;
 230:  CALL TEKST(3) ;
 231:   ;
 232:  LBL[211:Start printen] ;
 233:  CALL PRINTEN    ;
 234:   ;
 235:  OVERRIDE=R[49:Snelheid] ;
 236:   ;
 237:  IF R[38:Hoogte fout]=1,JMP LBL[720] ;
 238:   ;
 239:  !AFLEGGEN OP BAND ;
 240:  LBL[230:Afleg op corona] ;
 241:  CALL B_AFL_ONTS    ;
 242:   ;
 243:  IF R[26:Geen plate b]=1,JMP LBL[511] ;
 244:   ;
 245:  !Naar begin programma ;
 246:J P[250] 65% CNT100    ;
 247:J P[10:Naar magazijn] 65% CNT100    ;
 248:  Open hand 1    ;
 249:  Open hand 2    ;
 250:  JMP LBL[10] ;
 251:   ;
 252:   ;
 253:   ;
 254:  !**********STORINGEN********** ;
 255:  LBL[500] ;
 256:  MESSAGE[GEEN PERSLUCHT AANWEZIG] ;
 257:  MESSAGE[KLEP NIET DICHT] ;
 258:  MESSAGE[...] ;
 259:  MESSAGE[-DI 16 OFF] ;
 260:  MESSAGE[-DO 44 OFF] ;
 261:  MESSAGE[-Sluit de klep] ;
 262:  MESSAGE[...] ;
 263:  MESSAGE[-Storing verholpen--)] ;
 264:  MESSAGE[ Robot start door.] ;
 265:J P[1:rust positie] 40% FINE    ;
 266:  WAIT DI[16:Magazijnklep dicht]=ON AND DO[44:Perslucht ontsta]=ON    ;
 267:  CALL TEKST(3) ;
 268:  JMP LBL[10] ;
 269:   ;
 270:  LBL[501:POSITIEFOUT MAG] ;
 271:  R[111:Pos fout]=0    ;
 272:J P[10:Naar magazijn] 80% CNT100    ;
 273:J P[1:rust positie] 80% FINE    ;
 274:   ;
 275:  !Product 180 graden draaien ;
 276:  CALL B_DRAAIE    ;
 277:  IF R[37:Draaien buffer]=1,JMP LBL[506] ;
 278:   ;
 279:J P[90:na magazyn] 50% CNT100    ;
 280:  JMP LBL[200] ;
 281:   ;
 282:  LBL[503:GRIJPER NIET OPE] ;
 283:  CALL TEKST(503) ;
 284:J P[1:rust positie] 30% FINE    ;
 285:  CALL B_DUMPEN    ;
 286:   ;
 287:  !Lamp USER 2 AAN op fanuc kast ;
 288:  DO[54:User2]=ON ;
 289:  WAIT DI[45:USER 2]=ON    ;
 290:   ;
 291:  !Lamp USER 2 UIT op fanuc kast ;
 292:  DO[54:User2]=OFF ;
 293:   ;
 294:  CALL TEKST(3) ;
 295:  END ;
 296:   ;
 297:  LBL[502:Zonder print] ;
 298:J P[3:Voor prnter door] 80% CNT100    ;
 299:J P[2:Tussen move] 80% CNT100    ;
 300:J P[4:Naar afleg] 80% CNT100    ;
 301:  JMP LBL[230] ;
 302:   ;
 303:  LBL[505:GRIJPFOUT CNTRER] ;
 304:  CALL TEKST(510) ;
 305:  R[100:Product controle]=0    ;
 306:  R[40:Grijpfout centre]=0    ;
 307:J P[1:rust positie] 30% FINE    ;
 308:  CALL B_DUMPEN    ;
 309:   ;
 310:  !Lamp USER 2 AAN op fanuc kast ;
 311:  DO[54:User2]=ON ;
 312:  WAIT DI[45:USER 2]=ON    ;
 313:   ;
 314:  !Lamp USER 2 UIT op fanuc kast ;
 315:  DO[54:User2]=OFF ;
 316:   ;
 317:  CALL TEKST(3) ;
 318:  JMP LBL[10] ;
 319:   ;
 320:  LBL[506:DRAAIEN NIET VRY] ;
 321:  CALL TEKST(509) ;
 322:  R[100:Product controle]=0    ;
 323:  R[37:Draaien buffer]=0    ;
 324:J P[1:rust positie] 30% FINE    ;
 325:  CALL B_DUMPEN    ;
 326:   ;
 327:  !Lamp USER 2 AAN op fanuc kast ;
 328:  DO[54:User2]=ON ;
 329:  WAIT DI[45:USER 2]=ON    ;
 330:   ;
 331:  !Lamp USER 2 UIT op fanuc kast ;
 332:  DO[54:User2]=OFF ;
 333:   ;
 334:  CALL TEKST(3) ;
 335:  JMP LBL[10] ;
 336:   ;
 337:  LBL[510] ;
 338:  MESSAGE[*STORING ONTSTAPELAAR*] ;
 339:  MESSAGE[...] ;
 340:  MESSAGE[-Controleer unit] ;
 341:  MESSAGE[-Druk RESET knop] ;
 342:  MESSAGE[...] ;
 343:  MESSAGE[-Storing verholpen--)] ;
 344:  MESSAGE[ Robot start door.] ;
 345:  MESSAGE[...] ;
 346:  MESSAGE[...] ;
 347:J P[1:rust positie] 40% FINE    ;
 348:   ;
 349:  DO[49:Buzzer hek]=PULSE,15.0sec ;
 350:  DO[50:Rode lamp hek]=ON ;
 351:   ;
 352:  DO[15801]=ON ;
 353:  DO[15809]=PULSE,0.2sec ;
 354:  WAIT DO[15810]=OFF    ;
 355:  JMP LBL[10] ;
 356:   ;
 357:  LBL[511:Geen plate b] ;
 358:  R[26:Geen plate b]=0    ;
 359:  R[92:Aantal fout]=R[92:Aantal fout]+1    ;
 360:  R[93:Cyclusteller]=R[93:Cyclusteller]+1    ;
 361:  CALL B_DUMPEN    ;
 362:J P[1:rust positie] 40% FINE    ;
 363:   ;
 364:  IF R[92:Aantal fout]>=2,JMP LBL[513] ;
 365:   ;
 366:  LBL[512:Naar magazyn] ;
 367:  JMP LBL[10] ;
 368:   ;
 369:  LBL[513:Teveel fout] ;
 370:  R[92:Aantal fout]=0    ;
 371:  R[93:Cyclusteller]=0    ;
 372:   ;
 373:  MESSAGE[*PLATE B TE VAAK NIET] ;
 374:  MESSAGE[GEDETECTEERD*] ;
 375:  MESSAGE[...] ;
 376:  MESSAGE[Controleer:] ;
 377:  MESSAGE[   - Werking vorksensor] ;
 378:  MESSAGE[   - Afkeur in bak/band] ;
 379:  MESSAGE[...] ;
 380:  MESSAGE[-Druk USER2 knop] ;
 381:  MESSAGE[Robot start door] ;
 382:  MESSAGE[...] ;
 383:  MESSAGE[...] ;
 384:   ;
 385:  DO[49:Buzzer hek]=PULSE,15.0sec ;
 386:  DO[50:Rode lamp hek]=ON ;
 387:   ;
 388:  !Lamp USER 2 AAN op fanuc kast ;
 389:  DO[54:User2]=ON ;
 390:  WAIT DI[45:USER 2]=ON    ;
 391:   ;
 392:  !Lamp USER 2 UIT op fanuc kast ;
 393:  DO[54:User2]=OFF ;
 394:  DO[49:Buzzer hek]=OFF ;
 395:  DO[50:Rode lamp hek]=OFF ;
 396:   ;
 397:  JMP LBL[10] ;
 398:   ;
 399:  LBL[515] ;
 400:  R[112:Act start]=0    ;
 401:  MESSAGE[*ONTSTAPELAAR IS LEEG*] ;
 402:  MESSAGE[...] ;
 403:  MESSAGE[-Druk USER2 knop] ;
 404:  MESSAGE[Robot gaat naar HOME] ;
 405:  MESSAGE[...] ;
 406:  MESSAGE[...] ;
 407:  MESSAGE[...] ;
 408:  MESSAGE[...] ;
 409:  MESSAGE[...] ;
 410:   ;
 411:  DO[49:Buzzer hek]=PULSE,15.0sec ;
 412:  DO[50:Rode lamp hek]=ON ;
 413:   ;
 414:  LBL[516] ;
 415:  !Lamp USER 2 AAN op fanuc kast ;
 416:  DO[54:User2]=ON ;
 417:  WAIT    .20(sec) ;
 418:  !Lamp USER 2 UIT op fanuc kast ;
 419:  DO[54:User2]=OFF ;
 420:  WAIT    .20(sec) ;
 421:   ;
 422:  IF DI[45:USER 2]=ON,JMP LBL[517] ;
 423:  JMP LBL[516] ;
 424:   ;
 425:  LBL[517] ;
 426:  DO[49:Buzzer hek]=OFF ;
 427:  DO[50:Rode lamp hek]=OFF ;
 428:J P[1:rust positie] 30% CNT30    ;
 429:   ;
 430:  MESSAGE[*ONTSTAPELAAR IS LEEG*] ;
 431:  MESSAGE[...] ;
 432:  MESSAGE[-Controleer unit] ;
 433:  MESSAGE[-Vul het magazyn...] ;
 434:  MESSAGE[...] ;
 435:  MESSAGE[-Magazijn vol--)] ;
 436:  MESSAGE[-Druk USER2 knop] ;
 437:  MESSAGE[...] ;
 438:  MESSAGE[...] ;
 439:   ;
 440:  !Lamp USER 2 AAN op fanuc kast ;
 441:  DO[54:User2]=ON ;
 442:  WAIT DI[45:USER 2]=ON    ;
 443:   ;
 444:  !Lamp USER 2 UIT op fanuc kast ;
 445:  DO[54:User2]=OFF ;
 446:   ;
 447:  CALL TEKST(3) ;
 448:J P[10:Naar magazijn] 40% CNT100    ;
 449:  DO[15801]=ON ;
 450:  DO[15809]=PULSE,0.2sec ;
 451:  WAIT DO[15810]=OFF    ;
 452:  JMP LBL[10] ;
 453:   ;
 454:  LBL[520] ;
 455:  MESSAGE[*AFLEG NIET VRIJ*] ;
 456:  MESSAGE[...] ;
 457:  MESSAGE[-Controleer aflegband] ;
 458:  MESSAGE[...] ;
 459:  MESSAGE[-Storing verholpen--)] ;
 460:  MESSAGE[ Robot start door.] ;
 461:  MESSAGE[...] ;
 462:  MESSAGE[...] ;
 463:  MESSAGE[...] ;
 464:   ;
 465:  DO[49:Buzzer hek]=PULSE,10.0sec ;
 466:  DO[50:Rode lamp hek]=ON ;
 467:   ;
 468:J P[1:rust positie] 40% FINE    ;
 469:  WAIT DI[20:Afl 1 vrij Corona]=ON    ;
 470:   ;
 471:  DO[49:Buzzer hek]=OFF ;
 472:  DO[50:Rode lamp hek]=OFF ;
 473:  JMP LBL[10] ;
 474:   ;
 475:  LBL[521] ;
 476:  MESSAGE[*AFLEG NIET VRIJ*] ;
 477:  MESSAGE[...] ;
 478:  MESSAGE[-Controleer POUCH ] ;
 479:  MESSAGE[...] ;
 480:  MESSAGE[-Storing verholpen--)] ;
 481:  MESSAGE[ Robot start door.] ;
 482:  MESSAGE[...] ;
 483:  MESSAGE[...] ;
 484:  MESSAGE[...] ;
 485:J P[1:rust positie] 40% FINE    ;
 486:  WAIT DI[43:Alarm schib]=OFF    ;
 487:  JMP LBL[10] ;
 488:   ;
 489:  LBL[522] ;
 490:  MESSAGE[*AFLEG NIET VRIJ*] ;
 491:  MESSAGE[...] ;
 492:  MESSAGE[-Controleer CHIST] ;
 493:  MESSAGE[...] ;
 494:  MESSAGE[-Storing verholpen--)] ;
 495:  MESSAGE[ Robot start door.] ;
 496:  MESSAGE[...] ;
 497:  MESSAGE[...] ;
 498:  MESSAGE[...] ;
 499:   ;
 500:  DO[49:Buzzer hek]=PULSE,10.0sec ;
 501:  DO[50:Rode lamp hek]=ON ;
 502:   ;
 503:J P[1:rust positie] 40% FINE    ;
 504:  WAIT DI[93:FC uitloop vrij]=OFF    ;
 505:   ;
 506:  DO[49:Buzzer hek]=OFF ;
 507:  DO[50:Rode lamp hek]=OFF ;
 508:  JMP LBL[10] ;
 509:   ;
 510:  LBL[720:HOOGTE FOUT] ;
 511:  CALL TEKST(725) ;
 512:  R[100:Product controle]=0    ;
 513:  R[38:Hoogte fout]=0    ;
 514:J P[1:rust positie] 30% FINE    ;
 515:   ;
 516:  CALL B_DUMPEN    ;
 517:   ;
 518:  WAIT DI[7:Automaat]=OFF    ;
 519:   ;
 520:  !Lamp USER 2 AAN op fanuc kast ;
 521:  DO[54:User2]=ON ;
 522:  WAIT DI[45:USER 2]=ON    ;
 523:   ;
 524:  !Lamp USER 2 UIT op fanuc kast ;
 525:  DO[54:User2]=OFF ;
 526:   ;
 527:  END ;
 528:   ;
 529:  LBL[735:Centrer niet vry] ;
 530:  CALL TEKST(735) ;
 531:  R[47:Centrer niet vri]=0    ;
 532:J P[1:rust positie] 30% FINE    ;
 533:  CALL B_DUMPEN    ;
 534:   ;
 535:  !Lamp USER 2 AAN op fanuc kast ;
 536:  DO[54:User2]=ON ;
 537:  WAIT DI[45:USER 2]=ON    ;
 538:   ;
 539:  !Lamp USER 2 UIT op fanuc kast ;
 540:  DO[54:User2]=OFF ;
 541:   ;
 542:  JMP LBL[10] ;
 543:   ;
 544:   ;
 545:  !******************************** ;
 546:   ;
 547:  LBL[1000:HOME ZOEKEN] ;
 548:  CALL TEKST(1000) ;
 549:  PAYLOAD[1] ;
 550:  OVERRIDE=25% ;
 551:  PR[100:Home Lpos]=LPOS    ;
 552:  R[200:Homezoek X]=PR[100,1:Home Lpos]    ;
 553:  R[199:Homezoek Y]=PR[100,2:Home Lpos]    ;
 554:  R[198:Homezoek Z]=PR[100,3:Home Lpos]    ;
 555:   ;
 556:  PR[99:Home Jpos]=JPOS    ;
 557:  R[193:J4]=PR[99,4:Home Jpos]    ;
 558:  R[194:J6]=PR[99,6:Home Jpos]    ;
 559:   ;
 560:  R[189:Act Uframe]=$MNUFRAMENUM[1] ;
 561:  R[188:Act Utool]=$MNUTOOLNUM[1] ;
 562:   ;
 563:  IF DO[100:Robot op reference]=ON,JMP LBL[1100] ;
 564:   ;
 565:  CALL HOMEN1    ;
 566:  JMP LBL[1100] ;
 567:   ;
 568:  LBL[1100] ;
 569:  UFRAME_NUM=1 ;
 570:  UTOOL_NUM=1 ;
 571:   ;
 572:  !Grijpers open ;
 573:  Open hand 1    ;
 574:  Open hand 2    ;
 575:   ;
 576:J P[1:rust positie] 30% CNT100    ;
 577:  R[7:Steekhoogte]=13.1    ;
 578:  R[9:Act R8]=0    ;
 579:  R[21:Grijper 1-voudig]=0    ;
 580:  R[26:Geen plate b]=0    ;
 581:  R[37:Draaien buffer]=0    ;
 582:  R[38:Hoogte fout]=0    ;
 583:  R[39:Buffer niet vrij]=0    ;
 584:  R[40:Grijpfout centre]=0    ;
 585:  R[41:Geen vrijg  slot]=0    ;
 586:  R[42:Grijpfout bufffe]=0    ;
 587:  R[43:Bufferstapel vol]=0    ;
 588:  R[45:Teller ontstapel]=0    ;
 589:  R[46:Cyclusteller]=0    ;
 590:  R[47:Centrer niet vri]=0    ;
 591:  R[49:Snelheid]=100    ;
 592:  R[90:Program gestart]=1    ;
 593:  R[92:Aantal fout]=0    ;
 594:  R[93:Cyclusteller]=0    ;
 595:  R[110:Act magazijn]=0    ;
 596:  R[112:Act start]=0    ;
 597:   ;
 598:  DO[52:IONblower witband]=ON ;
 599:  DO[49:Buzzer hek]=OFF ;
 600:  DO[50:Rode lamp hek]=OFF ;
 601:   ;
 602:  LBL[2000] ;
 603:  IF DI[23:Positioneer vrij]=ON,JMP LBL[2100] ;
 604:   ;
 605:  LBL[2001] ;
 606:  IF DI[22:Buffer vrij]=OFF,JMP LBL[2101] ;
 607:   ;
 608:  !AANSTURING SNAARBANDJE--- JA ;
 609:  !AANSTURING CORONA-------- NEE ;
 610:  !AANSTURING ANTI STATIC--- JA ;
 611:  !AANSTURING WHITE STRIPE-- NEE ;
 612:  DO[15020]=OFF ;
 613:  DO[15021]=ON ;
 614:  DO[15022]=OFF ;
 615:  DO[15023]=OFF ;
 616:  DO[15024]=OFF ;
 617:  DO[15025]=OFF ;
 618:  DO[15026]=OFF ;
 619:   ;
 620:  !ONTSTAPELMAGAZYN AKTIVEREN ;
 621:  DO[15801]=ON ;
 622:  R[91:Ontstapelmagazyn]=1    ;
 623:   ;
 624:  IF DO[15811]=OFF,JMP LBL[2010] ;
 625:   ;
 626:  !Ontstapel 1x ;
 627:  DO[15809]=PULSE,0.2sec ;
 628:   ;
 629:   ;
 630:  !Reset tafel vol ;
 631:  LBL[2010] ;
 632:  DO[14419]=OFF ;
 633:  END ;
 634:   ;
 635:  LBL[2100:Opstart controle] ;
 636:  CALL TEKST(1300) ;
 637:  !Lamp USER 2 AAN op fanuc kast ;
 638:  DO[54:User2]=ON ;
 639:  WAIT DI[45:USER 2]=ON    ;
 640:   ;
 641:  !Lamp USER 2 UIT op fanuc kast ;
 642:  DO[54:User2]=OFF ;
 643:   ;
 644:  JMP LBL[2000] ;
 645:   ;
 646:  LBL[2101:Opstart controle] ;
 647:  CALL TEKST(1200) ;
 648:  !Lamp USER 2 AAN op fanuc kast ;
 649:  DO[54:User2]=ON ;
 650:  WAIT DI[45:USER 2]=ON    ;
 651:   ;
 652:  !Lamp USER 2 UIT op fanuc kast ;
 653:  DO[54:User2]=OFF ;
 654:   ;
 655:  JMP LBL[2001] ;
/POS
P[1:"rust positie"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   451.199  mm,	Y =      .039  mm,	Z =   354.128  mm,
	W =   179.901 deg,	P =      .000 deg,	R =   -90.100 deg
};
P[2:"Tussen move"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   243.866  mm,	Y =  -558.225  mm,	Z =   306.071  mm,
	W =   179.940 deg,	P =     -.648 deg,	R =   -51.434 deg
};
P[3:"Voor prnter door"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  -423.119  mm,	Y =  -694.121  mm,	Z =   160.498  mm,
	W =   179.940 deg,	P =     -.669 deg,	R =   -91.002 deg
};
P[4:"Naar afleg"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   751.920  mm,	Y =  -694.119  mm,	Z =   376.979  mm,
	W =   179.940 deg,	P =     -.668 deg,	R =    20.879 deg
};
P[5:"Weg van  printer"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =  -231.108  mm,	Y =  -581.487  mm,	Z =   347.114  mm,
	W =    88.716 deg,	P =    -1.964 deg,	R =      .752 deg
};
P[7:"Terug naar print"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =  -470.234  mm,	Y = -1090.372  mm,	Z =   347.113  mm,
	W =    88.716 deg,	P =    -1.964 deg,	R =      .752 deg
};
P[10:"Naar magazijn"]{
   GP1:
	UF : 1, UT : 1,	
	J1=  -116.680 deg,	J2=   -36.905 deg,	J3=    -6.315 deg,
	J4=      .007 deg,	J5=   -83.703 deg,	J6=    -6.374 deg
};
P[70:"voor magazyn"]{
   GP1:
	UF : 0, UT : 1,	
	J1=  -130.001 deg,	J2=   -13.098 deg,	J3=   -24.238 deg,
	J4=     -.000 deg,	J5=   -65.660 deg,	J6=      .000 deg
};
P[90:"na magazyn"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  -641.999  mm,	Y = -1045.000  mm,	Z =   160.498  mm,
	W =   179.940 deg,	P =     -.669 deg,	R =   -91.002 deg
};
P[101:"1-0'"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  -262.800  mm,	Y = -1160.200  mm,	Z =   -14.500  mm,
	W =   179.940 deg,	P =     -.669 deg,	R =   -91.002 deg
};
P[102:"1-180'"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  -411.750  mm,	Y = -1159.300  mm,	Z =   -14.500  mm,
	W =   179.915 deg,	P =      .696 deg,	R =    88.964 deg
};
P[103:"2-0'"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  -412.600  mm,	Y = -1160.200  mm,	Z =   -14.500  mm,
	W =   179.941 deg,	P =     -.667 deg,	R =   -91.100 deg
};
P[104:"2-180'"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  -561.750  mm,	Y = -1159.200  mm,	Z =   -14.500  mm,
	W =   179.915 deg,	P =      .696 deg,	R =    89.200 deg
};
P[105:"3-0'"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  -563.000  mm,	Y = -1159.600  mm,	Z =   -14.500  mm,
	W =   179.941 deg,	P =     -.666 deg,	R =   -91.200 deg
};
P[106:"3-180'"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  -711.850  mm,	Y = -1159.100  mm,	Z =   -14.500  mm,
	W =   179.915 deg,	P =      .696 deg,	R =    89.200 deg
};
P[107:"4-0'"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  -713.100  mm,	Y = -1159.600  mm,	Z =   -14.500  mm,
	W =   179.941 deg,	P =     -.666 deg,	R =   -91.000 deg
};
P[108:"4-180'"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  -861.850  mm,	Y = -1158.700  mm,	Z =   -14.500  mm,
	W =   179.915 deg,	P =      .696 deg,	R =    89.200 deg
};
P[109:"5-0'"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  -863.100  mm,	Y = -1159.000  mm,	Z =   -14.500  mm,
	W =   179.942 deg,	P =     -.664 deg,	R =   -91.007 deg
};
P[110:"5-180'"]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =  -863.100  mm,	Y = -1159.000  mm,	Z =   -14.500  mm,
	W =   179.942 deg,	P =     -.664 deg,	R =   -91.007 deg
};
P[201]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =     0.000  mm,	Y =     3.000  mm,	Z =     0.000  mm,
	W =     0.000 deg,	P =     0.000 deg,	R =     0.000 deg
};
P[202]{
   GP1:
	UF : 0, UT : 1,		CONFIG : 'F U T, 0, 0, 0',
	X =     0.000  mm,	Y =     3.000  mm,	Z =     0.000  mm,
	W =     0.000 deg,	P =     0.000 deg,	R =     0.000 deg
};
P[250]{
   GP1:
	UF : 1, UT : 1,		CONFIG : 'N U T, 0, 0, 0',
	X =   303.419  mm,	Y =  -501.677  mm,	Z =   341.331  mm,
	W =   179.897 deg,	P =     -.031 deg,	R =   -93.885 deg
};
/END
