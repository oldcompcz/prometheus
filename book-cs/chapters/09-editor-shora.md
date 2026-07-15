# Kapitola 9: Editor shora

Nyní jsme připraveni podrobně vstoupit do prvního velkého subsystému.

Editor zdrojového textu je dobrým místem, kde začít, protože jeho účel je viditelný. Uživatel vidí řádky zdroje, aktivní řádek, samostatný editační řádek, stavovou zprávu a okamžitý pohyb v reakci na klávesy. Za tímto jednoduchým povrchem PROMETHEUS koordinuje několik velmi odlišných reprezentací:

- komprimované záznamy zdroje v paměti;
- jeden rozvinutý 32znakový řádek displeje;
- jeden editovatelný vstupní buffer obsahující značku kurzoru a tokeny;
- hranice vybraného bloku uložené jako adresy;
- bitmapové řádky obrazovky a atributy;
- pohyblivou hranici mezi zdrojem a symboly;
- samomodifikované ukazatele, které si pamatují aktuální stav editoru.

Tato kapitola popisuje tuto koordinaci shora. Zatím nebudeme dekódovat každou klávesu ani každý bajt záznamu zdroje. Tyto podrobnosti patří do několika následujících kapitol. Naším cílem je pochopit **tok** editoru: jak se spouští, co dělá jeho hlavní smyčka, které operace vyvolají úplné překreslení a které používají rychlejší cesty.

## Editor není běžný celoobrazovkový textový soubor

Běžný editor by mohl uchovávat celý dokument jako jedno pole znaků a uvnitř něj kreslit kurzor.

PROMETHEUS místo toho odděluje tři věci:

```text
trvalý zdroj       komprimované záznamy
viditelný zdroj    rozvinuté řádky nakreslené na obrazovce
aktuální editace   dočasný buffer tokenů a znaků
```

Výpis zdroje nelze přímo upravovat na místě. Chce-li uživatel změnit řádek, PROMETHEUS rozvine jeden komprimovaný záznam do editačního bufferu. Uživatel změní tuto dočasnou reprezentaci. Po stisku ENTER se znovu parsuje a nahradí nebo vloží komprimovaný záznam.

Tento zpáteční převod je ústřední:

```text
komprimovaný záznam
    → rozvinutý editovatelný text
    → změny uživatele
    → parser
    → nový komprimovaný záznam
```

Trvalý zdroj díky tomu zůstává kompaktní, zatímco uživatel pracuje s čitelným textem.

## Viditelné rozložení má několik různých úkolů

Obrazovku editoru si můžeme představit jako několik vodorovných pásem.

### Okno zdroje

Kolem aktivního přístupového řádku se rozvine a zobrazí dvacet záznamů zdroje. Aktivní řádek nemusí být prvním ani posledním viditelným záznamem. PROMETHEUS se snaží zachovat kontext nad ním i pod ním.

### Přístupový neboli editační řádek

Dolní řádek editoru obsahuje `inputBufferStart`, vykreslený s pohyblivou značkou kurzoru. Zde se skládá nový zdrojový řádek nebo příkaz.

### Stavový řádek

Stavový řádek zobrazuje:

- zprávu, například copyright, chybu nebo „Wait please“;
- režim insert/overwrite;
- aktuální horní konec zdroje a symbolů;
- `U-TOP`;
- čísla v právě zvoleném desítkovém nebo šestnáctkovém tvaru.

### Označení výběru

Řádek zdroje uvnitř zapamatovaného bloku dostane zvláštní značku. Kreslí se znakem s kódem `$03`, jehož glyph na původní 48K ROM vypadá jako plný blok, protože ukazuje do oblasti ROM vyplněné bajty `$FF`. Je to chytré, ale závislé na hardwaru; jiná ROM může zobrazit jiný tvar.

Tato pásma sdílejí nízkoúrovňový vykreslovací kód, ale mají odlišný stav a pravidla barev.

## Do stejného editoru vedou dva vstupní body

Úplná instalace má vstup na `ENTRY_POINT_WITH_MONITOR`. Suffix obsahující pouze assembler začíná na `ENTRY_POINT_WITHOUT_MONITOR`.

Vstup assembler-only je velmi malý:

```asm
ENTRY_POINT_WITHOUT_MONITOR:
    jp startPrometheus
```

Také úplný monitor může opustit své rozhraní a vrátit se do `startPrometheus`.

Studený rezidentní vstup editoru je tedy společný:

```text
úplná instalace → volba monitor/editor → startPrometheus
assembler-only instalace              → startPrometheus
návrat z monitoru                      → startPrometheus
```

Installer opraví několik adres pro assembler-only režim, samotný editor však nepotřebuje druhou implementaci.

## Cold start vymaže displej vlastněný programem

Editor začíná:

```asm
startPrometheus:
    di
    ld e,SEPARATOR_CHARCODE
    call clearDisplay
```

Přerušení jsou zakázána a celá obrazovka se vyplní prostřednictvím interního vykreslovače znaků.

Oddělovacím znakem je `~`, nikoli obyčejná mezera. V nakonfigurovaném fontu a rozhraní tím vznikne počáteční vizuální pozadí editoru. `invokeRun` později před předáním řízení sestavenému uživatelskému kódu používá `clearDisplayToSpaces`.

Po inicializaci displeje vykonávání přímo propadne do `prometheusWarmStart`.

Není zde `CALL`. Labely označují postupně teplejší restartovací body uvnitř jediné souvislé rutiny.

## Tři úrovně warm startu

PROMETHEUS má několik vstupních labelů, protože různé operace chtějí zachovat různé množství stavu.

### `prometheusWarmStart`

Jde o nejúplnější reset editoru, který ještě neznamená novou instalaci programu.

Provede:

- obnovení zvýrazněných atributů přístupového řádku;
- výběr výchozí stavové zprávy;
- vymazání sdílených pracovních bufferů;
- znovuvytvoření značky kurzoru a ochranného bajtu v editačním bufferu;
- reset interního zásobníku;
- překreslení viditelného zdroje;
- vstup do klávesové smyčky.

### `prometheusWarmStartWithMessage`

Tento vstup začíná se zprávou již vybranou v `A`.

Chyba nebo dokončená operace tedy může zobrazit konkrétní stav, a přitom stále vymazat přechodné buffery editoru a znovu sestavit obrazovku.

### `prometheusWarmStartWithCurrentBuffers`

Tento vstup zachová aktuální editační a pracovní buffery. Resetuje zásobník, překreslí zdroj a pokračuje ve vstupní smyčce.

Navigace používá právě tuto teplejší cestu. Pohyb nahoru nebo dolů nemá nutně zničit rozepsaný vstupní řádek.

Tři labely tvoří užitečnou hierarchii:

```text
warm start
    reset zprávy, atributů, bufferů, zásobníku a výpisu

warm start se zprávou
    zachovej vybranou zprávu; reset bufferů, zásobníku a výpisu

warm start s aktuálními buffery
    zachovej buffery; reset zásobníku a výpisu
```

Je to menší než tři oddělené rutiny, protože pozdější vstupní body jsou jednoduše labely umístěné dále v téže posloupnosti instrukcí.

## Proč každý warm start resetuje zásobník

V `prometheusWarmStartWithCurrentBuffers`:

```asm
ld sp,internalStackTop
call renderVisibleSourceRecords
```

Nastavení `SP` zahodí celý vnitřní řetězec volání, který k warm startu vedl.

Mnoho handlerů na každé přerušovací cestě pečlivě nerozbaluje všechny dočasné položky zásobníku. Místo toho skočí na známý restartovací label. Znovunastavení `SP` činí takový postup bezpečným.

Připomíná to restart malé event loop po výjimce:

```text
zapomeň rozpracovanou vnořenou operaci
obnov známý zásobník nejvyšší úrovně
překresli konzistentní rozhraní
přijmi další příkaz
```

Proto jsou warm-start labely důležitými cíli toku řízení, nikoli obyčejnými podprogramy.

Rutina, která na ně skočí, nesmí očekávat návrat.

## Aktivní řádek zdroje je operand instrukce

Záznam zdroje, kolem něhož se výpis vykresluje, je zapamatován zde:

```asm
varcSourceBufferActiveLine:
    ld hl,sourceBufferAccessLine
```

Změna aktivního řádku znamená přepsat bezprostřední word instrukce `LD HL,...`:

```asm
ld (varcSourceBufferActiveLine+1),hl
```

Aktivní řádek je tedy zároveň trvalým stavem editoru a spustitelným kódem, jak jsme viděli v kapitole 5.

Počáteční hodnota ukazuje na `sourceBufferAccessLine`, trvalou nízko položenou kotvu uvnitř oblasti zdroje.

Přímá navigace, výběr bloku, mazání, kopírování, import zdroje i handlery příkazů tento ukazatel čtou nebo mění.

## Vykreslení viditelného okna zdroje

`renderVisibleSourceRecords` začne aktivním řádkem, projde o třináct záznamů zpět a poté vykresluje dopředu, dokud není okno plné.

První kroky jsou:

```asm
varcSourceBufferActiveLine:
    ld hl,sourceBufferAccessLine
    ld b,LINES_BEFORE_ACCESS_LINE
.findTopVisibleSourceRecordLoop:
    call getPreviousSourceRecord
    djnz .findTopVisibleSourceRecordLoop
```

Formát zdroje umožňuje pohyb zpět v konstantním čase, protože proměnný záznam končí značkou obsahující svou proměnnou délku. Kapitola 15 tento formát vysvětlí podrobně.

Jakmile je nalezen nejvyšší viditelný záznam, rutina nastaví první bitmapový řádek a opakuje:

```text
vymaž cílový řádek
rozviň a vykresli aktuální záznam
přejdi na další záznam
přejdi o jeden textový řádek na obrazovce
```

Smyčka skončí po dvaceti záznamech.

Aktivní řádek zůstává pojmovým středem. Horní ukazatel je pouze dočasným kurzorem vykreslování.

## Vykreslování nemění komprimovaný zdroj

Pro každý záznam jej `renderSourceRecord` rozvine do `lineBuffer`.

Pokud záznam patří do vybraného bloku, vloží bajt značky `$03` na `lineBufferMarkerPosition`.

Potom `printExpandedSourceLineWithRoutine` prochází rozvinutý řádek a posílá viditelné znaky callbacku.

Callbackem je obvykle `displayCharacterSafely`, stejný scanner však lze přesměrovat na:

- výstup tiskárny;
- zpracování FIND;
- jiné konzumenty řádku.

Samotný záznam zdroje zůstává nezměněn.

Vzniká tak užitečná pipeline:

```text
komprimovaný záznam zdroje
    ↓
lineBuffer s interními oddělovači
    ↓
sdílený scanner
    ↓
zvolený výstupní callback
```

Displej editoru je pouze jedním z možných cílů.

## Oddělovače polí nejsou viditelné znaky

Rozvinutý zdroj obsahuje mezi formátovanými poli interní bajt `$01`. Výstupní scanner jej přeskočí:

```asm
ld a,(hl)
inc hl
dec a
jr z,.readNextExpandedSourceCharacter
inc a
ret z
```

První `DEC A` převede `$01` na nulu. V takovém případě scanner pokračuje smyčkou bez výstupu.

Následující `INC A` vrátí skutečný nulový terminátor zpět na nulu, což řádek ukončí.

Tato kompaktní dvojice rozlišuje:

```text
$01 → formátovací oddělovač, přeskočit
$00 → terminátor řádku, skončit
jiné → viditelný znak, pokračovat
```

Oddělovač umožňuje expanznímu kódu zachovat strukturu polí, aniž by zobrazoval další řídicí symboly.

## Velikost písmen se mění pouze mimo uvozovky

PROMETHEUS může zobrazovat zdroj v nakonfigurovaných velkých nebo malých písmenech, text uvnitř uvozovek však musí zůstat nezměněn.

Sdílený scanner počítá uvozovky v `C` a testuje jeho nejnižší bit:

```text
sudý počet nalezených uvozovek → mimo citovaný literál
lichý počet nalezených uvozovek → uvnitř citovaného literálu
```

Mimo uvozovky procházejí písmena nakonfigurovanou instrukcí transformace velikosti. Uvnitř uvozovek jdou přímo na výstup.

Je to malý, ale důležitý detail správnosti. Zdroj:

```asm
DEFM "Hello"
```

může zobrazit `DEFM` ve zvolené velikosti písmen zdroje, zatímco `Hello` zůstane literálem zadaným programátorem.

## Hlavní smyčka má stálý tep

Po vykreslení okna zdroje vstoupí PROMETHEUS do `.readInputLineLoop`:

```asm
.readInputLineLoop:
    call repaintEditLine
    call setBorderColor
    call processKey
    push af
    ld a,MESSAGE_COPYRIGHT
    call printStatusBar
    ...
    pop af
```

Rytmus je následující:

```text
1. překresli editační řádek
2. obnov normální rámeček
3. počkej na jednu normalizovanou klávesu
4. obnov stavový řádek
5. proveď dispatch klávesy
6. opakuj nebo proveď warm start
```

Přijatá klávesa je při kreslení stavového řádku zachována na zásobníku.

`varcLastStatusBarMessage` si pamatuje, kterou zprávu použít. Po běžném vstupu se vrátí výchozí copyright, takže chyba nebo zvláštní stav nezůstane na obrazovce navždy.

Tato hlavní smyčka je vrcholným řídicím centrem editoru.

## Některé klávesy jednají okamžitě

Klávesa nemusí vždy vstoupit do editačního bufferu.

Hlavní smyčka nejprve testuje několik ovládacích akcí editoru:

- vymazání aktuálního editačního řádku;
- rozvinutí aktivního záznamu zdroje pro editaci;
- přepnutí režimu insert/overwrite;
- pohyb o jednu stránku;
- pohyb o jeden řádek;
- smazání aktivního řádku;
- nastavení hranice bloku.

Teprve pokud nic z toho neodpovídá, předá klávesu do `updateInputBuffer`.

Na pořadí záleží. Šipky, EDIT, značky bloku a stránkový pohyb jsou akce editoru, nikoli textové znaky.

Příkaz jako `ASSEMBLY` je jiný. Zadá se do editačního řádku jako token a provede se až po ENTER.

Existují tedy dvě příkazové vrstvy:

```text
okamžité řídicí klávesy
    zpracuje je přímo hlavní smyčka

zapsaný příkazový řádek
    tokenizuje se ve vstupním bufferu a odešle klávesou ENTER
```

## Editace aktivního záznamu

Zkratka EDIT vybere aktuální komprimovaný záznam a rozvine jej do `inputBufferStart`:

```asm
ld ix,(varcSourceBufferActiveLine+1)
ld hl,inputBufferStart
...
call expandSourceRecordToHL
ld a,001h
ld (varcInsertMode+1),a
```

Buffer se nejprve vymaže. Expander vytvoří čitelný zdrojový text a vloží značku kurzoru do editovatelné reprezentace.

Příznak režimu insert se nastaví na hodnotu používanou při náhradě. Když uživatel řádek později odešle, starý komprimovaný záznam se smaže a nahradí nově zakódovaným.

Proto mohou „editovat existující řádek“ a „zadat nový řádek“ používat tentýž textový parser. Liší se režimem vložení a vybraným cílem.

## Insert a overwrite jsou politiky editoru

`varcInsertMode` uchovává aktuální politiku odeslání v operandu instrukce.

Stavový řádek zobrazuje buď:

```text
I   insert
O   overwrite
```

Po odeslání `restoreInsertModeAndContinue` vymaže příznak zpět na výchozí hodnotu.

Přesná číselná konvence je méně důležitá než význam rozdílu:

- insert ponechá existující aktivní záznam a přidá nový záznam za něj;
- overwrite odstraní odpovídající starý záznam jako součást náhrady editovaného řádku.

Pozdější kapitoly budou přesně sledovat volání parseru a vkládání.

## Pohyb po stránkách znovu používá pohyb po řádcích

Pro stránkový příkaz nastaví editor `B` na dvacet a opakovaně volá rutinu pohybu o jeden záznam:

```asm
ld b,014h
.nextPageAdvanceLoop:
    call moveActiveLineToNextSourceRecord
    djnz .nextPageAdvanceLoop
```

Jde o jednoduchý návrh. Neexistuje zvláštní algoritmus „najdi záznam o dvacet řádků dál“.

Obsluha hranic zůstává soustředěna v `moveActiveLineToNextSourceRecord` a `moveActiveLineToPreviousSourceRecord`.

Pokud pohyb dosáhne neplatné pozice, pomocná rutina přesměruje řízení na teplé překreslení, aniž by chybný ukazatel potvrdila.

Stránková smyčka tedy skládá ověřenou menší operaci.

## Pohyb o jeden řádek má rychlou vizuální cestu

Nově přijatá šipka dolů nejprve posune aktivní záznam. Potom scrolluje existující řádky bitmapy a nakreslí pouze nový spodní řádek zdroje.

Zdrojová rutina přibližně provede:

```text
posuň aktivní ukazatel o jeden záznam dolů
zkopíruj viditelné řádky bitmapy vzhůru
vymaž nový spodní řádek
procházej šest záznamů pod aktivním řádkem
vykresli tento záznam dole
přečti stav fyzické klávesy dolů
repeat, dokud je držena
```

Šipka nahoru provádí zrcadlovou operaci.

Proč se od aktivního řádku prochází šest nebo třináct záznamů? Přístupový řádek je uvnitř viditelného okna zdroje umístěn asymetricky. Vykreslovač a rychlý scroller se musí shodnout, který záznam patří do nově odkrytého krajního řádku.

Přesné konstanty jsou znalostí rozložení. Jejich účelem je ponechat aktivní záznam na stejné vizuální pozici, zatímco se kolem něj pohybuje kontext.

## Rychlý scrolling obchází běžné opakování hlavní smyčky

`processKey` už implementuje obecný autorepeat kláves. Handlery šipek však přidávají ještě rychlejší cestu pro scrolling zdroje.

Po posunutí a vykreslení jednoho řádku přímo přečtou příslušný řádek klávesnicové matice. Dokud zůstává fyzická šipka držena, provedou další pohyb ve zdroji a posun bitmapy bez návratu přes úplné překreslení editačního řádku a zpracování statusu.

Jde o optimalizaci operace, na níž je zpoždění nejvíce vidět.

Po uvolnění klávesy se řízení vrátí do `.readInputLineLoop`, kde se obnoví celé rozhraní.

## Mazání aktivního řádku

Okamžitá zkratka delete požádá o smazání jednoho komprimovaného záznamu:

```asm
ld bc,00001h
ld hl,(varcSourceBufferActiveLine+1)
call deleteSourceLinesAndRestoreTailPadding
```

Po smazání se editor pokusí vybrat předchozí přeživší záznam, pokud smazaný záznam neležel na trvalém začátku zdroje.

Potom tento záznam potvrdí jako aktivní a překreslí obrazovku.

Nízkoúrovňová mazací rutina z kapitoly 7 přesouvá bajty a opravuje ukazatele úložiště. Kód na úrovni editoru rozhoduje, co má uživatel následně vidět.

Toto rozdělení stojí za zapamatování:

```text
rutina úložiště → zachová strukturu paměti
handler editoru → zachová srozumitelnou interakci
```

## Výběr bloku si pamatuje dvě adresy zdroje

Klávesa hranice bloku přesune předchozí horní hranici do dolní a poté uloží aktivní řádek jako novou horní hranici:

```asm
ld hl,(varcSelectedBlockEnd+1)
ld (varcSelectedBlockStart+1),hl
ld hl,(varcSourceBufferActiveLine+1)
ld (varcSelectedBlockEnd+1),hl
```

Uživatel tedy může postupně označit dvě pozice.

`getSelectedBlock` je později normalizuje, aby příkazům nezáleželo na pořadí, v němž byly vybrány.

Vybraný rozsah je reprezentován adresami záznamů, nikoli čísly řádků. Když vložení nebo smazání posune bajty zdroje, mechanismus oprav ukazatelů z kapitoly 7 udrží tyto hranice spojené se zamýšlenými záznamy.

## Běžné klávesy mění editační buffer

Klávesy, které nebyly zpracovány okamžitě, vstoupí do `updateInputBuffer`.

Jeho návratová konvence záměrně používá zero flag:

```text
Z nastaven   → byl stisknut ENTER; odešli řádek
Z vynulován → buffer se změnil nebo byla klávesa ignorována; překresli a pokračuj
```

Hlavní smyčka provádí:

```asm
call updateInputBuffer
jr nz,.repeatInputLineLoopFar
```

Pokud nebyl odeslán úplný řádek, vrátí se k překreslení editačního řádku.

Pokud ENTER vytvořil nulu, vykonávání propadne do `submitInputLineOrDispatchCommand`.

Kapitola 11 vysvětlí pohyb kurzoru, vkládání, mazání, tabulaci a řetězec výměn bajtů uvnitř `updateInputBuffer`.

## Odeslání nejprve skryje editační řádek

Před parsováním PROMETHEUS vyplní atributy editačního řádku nakonfigurovanou hodnotou, která nastaví stejnou barvu inkoustu a papíru:

```asm
ld hl,LEFT_BOTTOM_ATTRIBUTE_ADDRESS
ld bc,0203fh
call atHLrepeatBTimesC
```

Pixely zůstanou, ale řádek vizuálně zmizí.

Tím se zabrání zobrazení částečně transformovaného vstupu, zatímco parser, handler příkazu nebo vložení zdroje mění sdílené buffery.

Jde o elegantní použití oddělené atributové paměti Spectra: třicet dva buněk se skryje třiceti dvěma zápisy bajtu.

## První bajt rozhodne mezi příkazem a zdrojem

Po případném přeskočení značky kurzoru PROMETHEUS prozkoumá první významový bajt vstupu.

```text
bajt pod $80     → obyčejný zdrojový text
bajt od $80 výše → tokenizovaný příkaz
```

Větev je:

```asm
cp 080h
jr c,parseAndInsertSourceLine
```

Proto může příkaz zadaný pomocí SYMBOL SHIFT a písmene zabírat jediný bajt. Překladač kláves může místo vypsání názvu příkazu vytvořit token v rozsahu `$C1-$DA`.

Tentýž vstupní řádek tedy může nést dva jazyky:

- editovatelný text assembleru;
- jednobajtové příkazové tokeny editoru následované argumenty.

## Příkazové tokeny skáčou přes tabulku

Příkazový token se zdvojnásobí a použije jako index do tabulky šestnáctibitových adres handlerů:

```asm
ld de,commandHandlerTable-(0xc1*2)
add hl,hl
add hl,de
ld a,(hl)
inc hl
ld h,(hl)
ld l,a
jp (hl)
```

Pojmově:

```text
index = token - $C1
handler = commandHandlerTable[index]
jump handler
```

Posun je zahrnut do aritmetiky základní adresy tabulky, takže není třeba explicitní odečítání.

Handlery zahrnují:

- assembly;
- BASIC;
- copy;
- delete;
- find;
- import;
- load/save/verify;
- monitor;
- print;
- run;
- symbol table;
- `U-TOP`;
- clear a replace.

Několik tokenových pozic záměrně sdílí handlery, protože historická tabulka příkazů obsahuje aliasy.

## Vložená adresa warm startu funguje jako společný návratový cíl

Před dispatch příkazu PROMETHEUS připraví:

```asm
ld hl,prometheusWarmStart
ld (varcPostCommandContinuationJump+1),hl
push hl
```

Jednoduchý handler příkazu proto může skončit instrukcí `RET` a dorazit do `prometheusWarmStart`, přestože dispatcher použil `JP (HL)`, nikoli `CALL`.

Zásobník je připraven tak, jako by byl příkaz zavolán z adresy warm startu.

Jde o další použití zásobníku jako dat toku řízení.

Některé vícestupňové příkazy dočasně přepíší `varcPostCommandContinuationJump` na jinou continuation. Běžný command dispatch nejprve obnoví cíl warm startu, aby starý zvláštní stav neunikl do dalšího příkazu.

## Odeslání zdroje vstupuje do parseru

Pokud je první bajt obyčejný text, `parseAndInsertSourceLine` zavolá:

```asm
call encodeInputLineToSourceRecord
call getRecordAfterActiveLine
```

Parser vytvoří komprimovaný záznam v dočasné pracovní oblasti. Cílem je obvykle místo za aktivním záznamem.

Vkládací engine otevře mezeru a záznam zkopíruje. V režimu overwrite/edit se odstraní také starý záznam.

Po úspěšném odeslání:

- stavová zpráva se vrátí na výchozí;
- obnoví se režim insert;
- continuation jump se vrátí k běžnému warm startu;
- viditelný zdroj se znovu sestaví z komprimovaných záznamů.

Kapitoly 12–14 vysvětlí, co přesně zakódovaný záznam obsahuje a jak funguje cesta tam a zpět.

## Stavový řádek je součástí řídicí smyčky

`printStatusBar` nejprve zobrazí vybranou zprávu. Potom přepíše sdílený tiskový kurzor na pozici režimu, vytiskne `I` nebo `O` a naformátuje dvě adresy:

```text
aktuální konec kódu/zdroje a symbolů
aktuální U-TOP
```

Formátovač čísel respektuje desítkový nebo šestnáctkový režim zobrazení.

Uživatel tak dostává průběžnou informaci o tlaku na paměť. Jak zdroj a symboly rostou, zobrazená horní adresa se blíží k `U-TOP`.

Editor omezení paměti stroje neskrývá. Činí z nich součást běžné práce.

## Chybové cesty se vracejí přes stejné vizuální centrum

Parser a příkazy hlásí chyby prostřednictvím `signalError` a souvisejících zprávových rutin. Tyto cesty nakonec znovu vstoupí do struktury warm startu s odpovídající stavovou zprávou.

Protože warm start:

- resetuje interní zásobník;
- vymaže přechodné buffery na příslušné úrovni;
- překreslí zdroj;
- znovu sestaví editační řádek;

nemusí každá hluboká rutina vracet zpět každý částečný zásah do displeje.

Architektura zotavení editoru je:

```text
po běžném dokončení → return nebo jump do warm startu
při chybě            → zvol zprávu a jump do warm startu
při navigaci         → teplejší překreslení zachovávající buffery
```

Rodina warm startů je tedy stejně důležitá jako hlavní klávesová smyčka.

## Editor jako pseudokód

Na nejvyšší užitečné úrovni se editor chová takto:

```text
startEditor:
    zakaž přerušení
    inicializuj displej

warmStart:
    obnov atributy přístupového řádku
    zvol stavovou zprávu
    vymaž přechodné buffery
    vytvoř prázdný editační řádek s kurzorem

warmStartWithCurrentBuffers:
    resetuj soukromý zásobník
    vykresli okno zdroje kolem aktivního záznamu

mainLoop:
    vykresli editační buffer
    obnov rámeček
    key = readNormalizedKey()
    vykresli stavový řádek

    if key je okamžité ovládání editoru:
        proveď navigaci/editaci/akci bloku
        přejdi na odpovídající warm start

    submitted = mutateEditBuffer(key)

    if not submitted:
        přejdi na mainLoop

    skryj editační řádek

    if první vstupní bajt je příkazový token:
        proveď dispatch handleru příkazu
    else:
        rozparsuj řádek na komprimovaný záznam
        vlož nebo nahraď záznam zdroje

    přejdi na warmStart
```

Pseudokód vynechává důležité podrobnosti, ale zachycuje tvar editoru.

## Cesta jednoho nového řádku zdroje

Předpokládejme, že aktivní záznam zdroje je prázdný řádek a uživatel zadá:

```asm
LOOP    DJNZ LOOP
```

Na této přehledové úrovni proběhne cesta takto:

```text
1. processKey vrací normalizované znaky a ovládací kódy.
2. updateInputBuffer udržuje dočasný řádek a značku kurzoru.
3. repaintEditLine rozvíjí tokeny a kreslí aktuální editační řádek.
4. ENTER způsobí, že updateInputBuffer vrátí nulu.
5. submitInputLineOrDispatchCommand nalezne obyčejný text pod $80.
6. encodeInputLineToSourceRecord parsuje pole a vytvoří kompaktní záznam.
7. insertByteRangeAtHLFromDE otevře místo za aktivním záznamem.
8. komprimované bajty se zkopírují do trvalého zdroje.
9. warm start vymaže dočasný stav a překreslí okno zdroje.
10. renderSourceRecord rozvine nový záznam zpět do čitelného textu.
```

Řádek se zobrazí téměř ve stejné podobě, v jaké jej uživatel zadal, trvalé bajty však již nejsou prostým textovým řetězcem.

## Cesta jednoho příkazu

Předpokládejme nyní, že vstupní řádek začíná tokenem pro `ASSEMBLY`.

```text
1. Vstup příkazu přes SYMBOL SHIFT vytvoří token $C1.
2. repaintEditLine rozvine token na viditelné slovo.
3. ENTER odešle řádek.
4. První bajt je alespoň $80, takže se přeskočí parsování zdroje.
5. Příkazový token indexuje commandHandlerTable.
6. Řízení skočí do invokeAssembly.
7. Vložená adresa warm startu funguje jako běžný návratový cíl.
8. Překlad oznámí stav a editor se překreslí.
```

Viditelné slovo a uložený vstupní bajt jsou různými reprezentacemi, stejně jako komprimovaný a viditelný zdroj.

## Cesta jedné šipky dolů

```text
1. processKey vrátí okamžitý ovládací kód dolů.
2. Hlavní smyčka zavolá moveActiveLineToNextSourceRecord.
3. Pomocná rutina hranice odmítne pohyb za konec zdroje.
4. Viditelné řádky bitmapy se posunou vzhůru.
5. Jeden nový spodní záznam se rozvine a vykreslí.
6. Přímý test klávesnicového portu zjistí, zda je šipka dolů stále držena.
7. Opakuj rychlou cestu, nebo se vrať do běžné hlavní smyčky.
```

Bajty zdroje se nepohnou. Změní se pouze aktivní ukazatel a obraz obrazovky.

Na tomto rozdílu záleží:

```text
navigace mění stav pohledu
editace mění trvalou strukturu zdroje
```

## Co editor zatím neví

Na této nejvyšší úrovni editor zachází s několika složitými subsystémy jako se službami:

- `processKey` dodá jednu normalizovanou klávesu;
- `updateInputBuffer` udržuje reprezentaci editačního řádku;
- `encodeInputLineToSourceRecord` parsuje a komprimuje zdroj;
- `expandSourceRecordToLineBuffer` rekonstruuje čitelný zdroj;
- `getNextSourceRecord` a `getPreviousSourceRecord` procházejí proměnné záznamy;
- handlery příkazů implementují assembly, tape, search, monitor a další funkce.

Následující kapitoly otevřou tyto černé skříňky jednu po druhé.

Toto pořadí je úmyslné. Nejprve potřebujeme vědět, proč rutina existuje a kam její výsledek směřuje. Teprve potom její nízkoúrovňové triky vytvoří souvislý příběh.

## Zpět k celému stroji

Editor je uzlem, který spojuje téměř každý subsystém.

Vytváří komprimovaný zdroj spotřebovávaný assemblerem.

Zobrazuje hranice symbolů a paměti.

Spouští monitor a přijímá disassemblované řádky zpět do zdroje.

Ukládá a načítá balíky zdroje prostřednictvím kazety.

Spouští program vybraný pomocí `ENT`.

Po chybách a dlouhých operacích opravuje svůj pohled pomocí malé rodiny warm startů.

Při pohledu shora není editor sbírkou nesouvisejících handlerů kláves. Je to opakovaný transformační cyklus:

```text
trvalé struktury
    → viditelná reprezentace
    → jedna akce uživatele
    → změněný pohled nebo změněná struktura
    → znovu viditelná reprezentace
```

Zbytek části II sestoupí do mechanismů, které umožňují každý z těchto kroků.

## Co se změnilo v paměti?

Při běžné navigaci:

- mění se `varcSourceBufferActiveLine`;
- bitmapové řádky mohou být zkopírovány a jeden krajní řádek znovu vykreslen;
- trvalý komprimovaný zdroj zůstává nezměněn.

Při psaní do editačního řádku:

- bajty v `inputBufferStart` se přesouvají kolem značky kurzoru;
- obnovuje se `varcInputBufferPosition` a stav kurzoru displeje;
- komprimovaný zdroj zůstává nezměněn až do ENTER.

Při odeslání zdroje:

- vytvoří se dočasný komprimovaný záznam;
- paměť zdroje a symbolů se může posunout;
- mohou se změnit ukazatele konce kódu a tabulky symbolů;
- warm start resetuje vstupní buffer.

Při dispatch příkazu:

- na zásobník se vloží návratová adresa warm startu;
- handler může změnit continuation state;
- příkaz může ovlivnit zdroj, symboly, displej, kazetu, monitor nebo sestavený výstup.

## Důležité myšlenky pro pozdější kapitoly

- Trvalý zdroj, viditelný zdroj a editovatelný text jsou oddělené reprezentace.
- Warm-start labely jsou úrovně zotavení a překreslení, nikoli jen spouštěcí kód.
- Aktivní řádek zdroje je samomodifikovaný bezprostřední ukazatel.
- Viditelný zdroj se rekonstruuje; nikdy se neupravuje přímo v bitmapové paměti.
- Okamžité řídicí klávesy a odeslané příkazové tokeny používají odlišné dispatch cesty.
- Rychlý scrolling mění pohled bez změny zdroje.
- Handlery příkazů mohou pomocí `RET` dorazit na připravenou adresu warm startu, přestože dispatch použil nepřímý skok.
- Zero flag z `updateInputBuffer` znamená „nyní odeslat“.

## Orientační labely zdroje vysvětlené na přehledové úrovni

- `ENTRY_POINT_WITHOUT_MONITOR`
- `startPrometheus`
- `prometheusWarmStart`
- `prometheusWarmStartWithMessage`
- `prometheusWarmStartWithCurrentBuffers`
- `.readInputLineLoop`
- `varcLastStatusBarMessage`
- `varcSourceBufferActiveLine`
- `renderVisibleSourceRecords`
- `renderSourceRecord`
- `printExpandedSourceLineWithRoutine`
- `varcExpandedSourceCharacterRendererCall`
- `moveActiveLineToPreviousSourceRecord`
- `moveActiveLineToNextSourceRecord`
- `writeLineOfCodeAndTestKeyboard`
- `varcSelectedBlockStart`
- `varcSelectedBlockEnd`
- `updateInputBuffer` na úrovni rozhraní
- `submitInputLineOrDispatchCommand`
- `commandHandlerTable`
- `parseAndInsertSourceLine` na přehledové úrovni
- `varcInsertMode`
- `varcPostCommandContinuationJump`
- `printStatusBar`
