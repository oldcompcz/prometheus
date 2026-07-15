# Kapitola 17: FIND, REPLACE, COPY, DELETE a PRINT

Větší příkazy editoru mohou při pohledu z klávesnice působit, jako by spolu nijak nesouvisely.

- FIND vyhledává text.
- REPLACE jej přepisuje.
- COPY duplikuje záznamy zdroje.
- DELETE odstraňuje vybranou oblast.
- PRINT posílá zdroj do externího kanálu.

Uvnitř PROMETHEA jsou však všechny tyto příkazy vystavěny z malé společné sady myšlenek:

- rozbalit komprimované záznamy do `lineBuffer`;
- procházet záznamy scannerem s vyměnitelným callbackem;
- reprezentovat blok dvěma ukazateli na záznamy;
- převést inkluzivní blok na exkluzivní rozsah bajtů;
- znovu použít běžný parser místo ručního upravování komprimovaných záznamů;
- nechat společný mechanismus vkládání a mazání, aby přesunul paměť.

Tato kapitola sleduje uvedené příkazy jako *aplikace* mechanismů editoru, kterým už rozumíme.

## Vybraný blok jsou dva zapamatované záznamy

Kapitola 15 představila:

```asm
varcSelectedBlockStart:
    ld hl,sourceBufferAccessLine
varcSelectedBlockEnd:
    ld de,sourceBufferAccessLine
```

Uživatel může hranice označit v libovolném pořadí. `getSelectedBlock` uložené adresy porovná a v případě potřeby je prohodí, takže vrátí normalizovanou dvojici:

```text
HL = začátek nižšího záznamu
DE = začátek vyššího záznamu
```

Rozsah je inkluzivní. Do bloku patří oba označené záznamy.

Do samotných komprimovaných záznamů se nic nezapisuje. COPY, DELETE, PRINT i FIND omezený na blok používají stejné dva externí ukazatele.

## FIND je pokračující rozhovor

Moderní vyhledávací dialog mívá samostatná tlačítka „Najít první“ a „Najít další“. PROMETHEUS používá jediný příkaz, jehož přesná podoba určuje, který stav se nahradí a který se znovu použije.

Podporovány jsou tyto formy:

```text
FIND s:text     prohledej celý zdroj od začátku
FIND b:text     prohledej vybraný blok od začátku
FIND :text      použij nový text, začni na aktuální pozici a zachovej předchozí rozsah
FIND            znovu použij uložený text i rozsah a pokračuj
```

Při běžném zadávání příkazů nezáleží na velikosti písmen. Ve zdroji se po tokenizaci a normalizaci vstupního bufferu testují velká `S`, `B` a dvojtečka.

Mezi příkazy přetrvávají dvě části stavu:

```asm
varcFindScanPosition:
    ld hl,sourceBufferAccessLine

varcFindRestrictToBlock:
    ld a,000h
```

První immediate operand si pamatuje naposledy zkoumaný komprimovaný záznam. Druhý si pamatuje, zda kandidáti musí ležet uvnitř vybraného bloku.

Samostatný pracovní prostor ukládá aktuální vzor ve tvaru:

```text
jednobajtová viditelná délka
bajty vzoru převedené na malá písmena
```

Samotné FIND tedy nepotřebuje žádný nový text. Může pokračovat od zapamatovaného záznamu se zapamatovaným vzorem i rozsahem.

## Začít před prvním záznamem

Při hledání od začátku PROMETHEUS uloží do scanovacího kurzoru `sourceBufferPreviousLine`, nikoli první skutečný záznam zdroje.

Důvodem je, že obecná smyčka postupuje *před* zpracováním:

```asm
varcFindScanPosition:
    ld hl,sourceBufferAccessLine
    call getNextSourceRecord
    ld (varcFindScanPosition+1),hl
```

Začne-li na zvláštním předchozím záznamu, první posun dopadne přesně na první prohledávatelný záznam.

Tato technika „pozice před prvním“ odstraňuje zvláštní případ pro první iteraci. V řetězci záznamů odpovídá zahájení smyčky nad polem na indexu `-1`, jestliže smyčka nejprve index zvětší a teprve potom čte.

## Jeden scanner, různé úkoly

Jádro procházení zdroje je řízeno callbackem.

FIND instaluje:

```asm
ld hl,findTextInLineBuffer
```

PRINT instaluje:

```asm
ld hl,printLineBufferToChannel3
```

Adresa se zapíše do samomodifikovaného volání:

```asm
varcLineScanCallback:
    call findTextInLineBuffer
```

Samotný scanner neví, zda hledá, nebo tiskne. Umí pouze:

1. přejít k následujícímu komprimovanému záznamu;
2. zastavit se na konci zdroje;
3. volitelně odmítnout záznamy mimo vybraný blok;
4. rozbalit záznam do `lineBuffer`;
5. zavolat nakonfigurovanou rutinu pro jeden řádek;
6. podle carry pokračovat, nebo skončit.

V pseudokódu:

```text
repeat:
    record = next(savedScanPosition)
    savedScanPosition = record

    if record je na konci zdroje:
        return nenalezeno / hotovo

    if blockOnly and record leží mimo vybraný blok:
        continue

    rozbal record do lineBuffer

    if callback(lineBuffer) vrátí carry:
        activeLine = record
        return úspěch
```

Je to malý interní framework. FIND a PRINT se liší hlavně callbackem a způsobem, jak vyhodnotí dokončení.

## Porovnávání viditelného textu, ne formátovacích bajtů

Rozbalený řádek obsahuje oddělovače polí `$01`. Pomáhají při vykreslování a navigaci v editoru, nejsou však viditelnými znaky zdroje.

`matchSearchTextAtDE` je přeskočí, aniž by spotřeboval znak vzoru:

```asm
.matchReadNextSourceCharacter:
    ld a,(de)
    inc de
    dec a
    jr z,.matchReadNextSourceCharacter
    inc a
    ret z
```

`DEC` dočasně převede `$01` na nulu, aby jej bylo možné levně rozpoznat. `INC` ostatní bajty obnoví a skutečný terminátor řádku `$00` současně převede na nulu pro následující test.

Samotné porovnání nerozlišuje velikost písmen:

```asm
xor (hl)
and 0dfh
ret nz
```

Velká a malá písmena ASCII se liší bitem 5. XOR odhalí rozdílné bity; AND `$DF` bit 5 ignoruje. Pokud se všechny zbývající bity shodují, považují se písmena za stejná.

Matcher tedy porovnává to, co čte člověk:

```text
label mnemonic operandy
```

nikoli neviditelné hranice polí editoru.

## Hledání na každé možné počáteční pozici

`findTextInLineBuffer` zkouší uložený vzor na každé viditelné pozici:

```text
position = začátek řádku

while není konec řádku:
    if vzor odpovídá zde:
        return carry nastaveno
    position++

return carry vynulováno
```

Matcher rozlišuje dva druhy neúspěchu:

- obyčejnou neshodu: zkus další pozici;
- terminátor řádku: žádná pozdější pozice už odpovídat nemůže.

Při úspěchu obecný scanner nastaví aktuální komprimovaný záznam jako aktivní. Obrazovka se kolem něj později znovu sestaví běžnou cestou warm startu.

FIND neukládá kurzor znaku uvnitř záznamu zdroje. Jeho pokračovací stav pracuje po záznamech. REPLACE rozbalený aktivní řádek znovu prohledá, když potřebuje přesné pozice znaků.

## Neúspěch ponechá aktivní řádek beze změny

Scanovací kurzor se při zkoumání záznamů posouvá, ukazatel aktivního řádku se však změní pouze tehdy, když callback ohlásí carry.

Dojde-li scan na konec zdroje, `findNextOccurrence` se vrátí, aniž by uložil nový aktivní řádek.

Toto oddělení poskytuje užitečné chování:

```text
stav postupu hledání se může posunout
viditelná pozice editoru se změní pouze při úspěchu
```

Neúspěšné FIND tedy uživatele neočekávaně nepřesune na jiný řádek. Pozdější příkaz se stále může rozhodnout, zda má hledání restartovat, nebo znovu použít uložený scanovací stav.

## FIND omezený na blok znovu používá běžné testování výběru

Je-li `varcFindRestrictToBlock` nenulové, projde každý kandidátní záznam před rozbalením rutinou `testSourceRecordOutsideSelectedBlock`.

Záznamy mimo blok se zcela přeskočí. Matcher nemusí rozumět hranicím bloku a bloková logika nemusí rozumět textu.

Jde o opakující se styl návrhu PROMETHEA:

> Každá kompaktní rutina má znát jednu reprezentaci a s ostatními se propojuje malými kontrakty.

Scanner zná záznamy. Pomocná bloková rutina zná adresy. Expander zná komprimovaný zdroj. Matcher zná viditelné znaky.

## REPLACE ukládá druhý trvalý řetězec

Text FIND a náhradní text jsou nezávislé.

Nová náhrada za dvojtečkou se normalizuje na malá písmena a uloží jako další sekvence s prefixem délky. Příkaz REPLACE bez nového argumentu znovu použije předchozí náhradu, stejně jako samotné FIND používá předchozí vyhledávací vzor.

Pracovní prostor náhrady je vložen do bajtů, které při disassemblování jinak vypadají jako nečinné instrukce. Je to další případ úložiště ve tvaru kódu, představeného v kapitole 5.

## REPLACE neupravuje komprimované bajty přímo

Bylo by možné vyhledat zakódované části výrazů a opravit je na místě — takový postup by však byl nebezpečně složitý.

Textová náhrada může:

- změnit mnemonic;
- překročit hranici pole;
- vytvořit nebo odstranit symbol;
- změnit délku záznamu;
- změnit descriptor v tabulce instrukcí;
- proměnit platný řádek v chybný;
- vyžadovat jiný způsob kódování pseudo-operace.

PROMETHEUS volí bezpečnější cestu:

```text
komprimovaný aktivní záznam
    ↓ rozbalení
kanonický text v lineBuffer
    ↓ aplikování náhrady
běžný text v inputBuffer
    ↓ normální parser
nový komprimovaný záznam
    ↓ commit v režimu OVERWRITE
zdroj
```

REPLACE tak znovu používá oba směry okružní cesty popsané v kapitolách 13 a 14.

## Opětovné sestavení editovatelného řádku

REPLACE rozbalí aktivní záznam a potom vytvoří nový obsah `inputBufferStart`. Začne zápisem běžné značky kurzoru `$01` a nastavením kapacity 31 viditelných znaků.

Na každé pozici zdroje se ptá, zda zde odpovídá uložený vzor FIND.

Existují tři případy.

### Případ 1: shoda

Uložené bajty náhrady se připojí k novému vstupnímu řádku. Ukazatel zdroje potom přeskočí počet *viditelných* znaků odpovídajícího vzoru.

Pomocná rutina `atHLorNextIfOne` při spotřebovávání těchto viditelných znaků průhledně přechází přes interní oddělovače polí `$01`.

### Případ 2: bez shody

Jeden viditelný znak zdroje se beze změny zkopíruje. Formátovací oddělovače se opět přeskočí, místo aby byly kopírovány jako text uživatele.

### Případ 3: konec řádku

Nový řádek se zakončí značkou kurzoru, nepoužitý konec vstupního bufferu se vynuluje a řádek se odešle běžnému parseru.

V pseudokódu:

```text
output = cursorMarker
source = expandedLine

while není end(source):
    if findPattern odpovídá na source:
        připoj replacementText k output
        posuň source o visibleLength(findPattern)
    else:
        připoj další viditelný znak source k output

připoj cursorMarker / podobu terminátoru
vynuluj nepoužitý konec vstupu
odešli v režimu OVERWRITE
```

Smyčka po shodě pokračuje, takže příkaz nahradí všechny nepřekrývající se výskyty v aktuálním rozbaleném řádku.

## Limit 31 znaků stále platí

`appendReplacementCharacterOrAbort` vynucuje stejnou kapacitu viditelného řádku jako ruční editace.

To je důležité, protože krátký zdrojový řádek se může náhradami dramaticky prodloužit. Několikanásobná výměna jednoho znaku za deset znaků by mohla překročit vstupní buffer editoru.

PROMETHEUS nedovolí příkazu REPLACE vytvořit řádek, který by běžný editor nedokázal uchovat. Místo poškození následujícího pracovního prostoru vyvolá obvyklou chybovou cestu.

## Dočasné vynucení OVERWRITE

Po dokončení rekonstrukce zapíše REPLACE nenulovou hodnotu do immediate operandu `varcInsertMode`.

Běžná cesta odeslání potom:

1. naparsuje znovu sestavený text;
2. vloží nový zakódovaný záznam;
3. smaže starý aktivní záznam;
4. vrátí nový záznam na původní pozici.

REPLACE nepotřebuje vlastní rutinu pro commit do paměti zdroje.

## Pokračování po návratu parseru

Běžné odeslání zdroje končí přes:

```asm
varcPostCommandContinuationJump:
    jp prometheusWarmStart
```

REPLACE tento skok dočasně přesměruje na `replaceCommitContinuation`.

Jakmile běžný parser řádek uloží, continuation:

1. obnoví cíl skoku na `prometheusWarmStart`;
2. zavolá `findNextOccurrence`;
3. obnoví běžný režim insert;
4. dokončí operaci standardní cestou editoru.

Vznikne tak interaktivní rytmus:

```text
FIND       přejdi na další odpovídající řádek bez změny
REPLACE    nahraď shody na tomto řádku a přejdi na další odpovídající řádek
FIND       tento výskyt přeskoč
REPLACE    přijmi zde náhradu a pokračuj
```

Continuation hook dovoluje workflow vyšší úrovně vypůjčit si běžný parser bez duplikování jeho dokončovací logiky.

## PRINT je scanner FIND s jiným callbackem

PRINT začíná na začátku zdroje. S volbou `B` nastaví stejný příznak omezení na blok, který používá FIND. Potom jako callback pro jeden řádek nainstaluje `printLineBufferToChannel3`.

Pro každý rozbalený záznam callback:

1. ověří, zda SPACE/BREAK nežádá zrušení;
2. otevře kanál 3 Spectra;
3. vypíše rozbalený řádek;
4. odešle carriage return 13;
5. vrátí vynulované carry, aby scan pokračoval.

Scanner přirozeně skončí na konci zdroje.

V pseudokódu:

```text
scope = celý zdroj nebo vybraný blok
scan od začátku

for každý record v scope:
    rozbal do lineBuffer
    if je stisknut SPACE:
        abort
    vytiskni lineBuffer do kanálu 3
    vytiskni nový řádek
```

Konkrétní zařízení připojené ke kanálu 3 patří do kanálového systému Spectra. PROMETHEUS potřebuje pouze standardní výstupní cestu.

## Proč PRINT rozbaluje záznamy místo tisku uložených bajtů

Komprimované záznamy obsahují:

- indexy instrukcí místo zapsaných mnemoniců;
- pořadová čísla symbolů místo jejich jmen;
- kompaktní značky výrazů;
- bity hlavičky;
- koncové bajty a zpětné odkazy.

Poslat tyto bajty na tiskárnu by nedávalo smysl.

PRINT používá stejnou kanonickou expanzi jako výpis na obrazovce, takže vytištěný zdroj odráží aktuální názvy symbolů i nakonfigurovanou velikost písmen zdroje. Znamená to také, že jediná implementace formátování slouží pro:

- zobrazení v editoru;
- editaci existujícího řádku;
- FIND;
- REPLACE;
- PRINT;
- pozdější importní a exportní cesty.

## COPY převádí inkluzivní blok na bajty

COPY začíná s normalizovaným blokem:

```text
low  = první vybraný záznam
high = poslední vybraný záznam
```

Pro výpočet délky v bajtech jednou postoupí z `high`:

```text
exclusiveEnd = next(high)
byteCount = exclusiveEnd - low
```

Jde o standardní převod inkluzivního rozsahu záznamů na polootevřený rozsah bajtů:

```text
[low, high včetně záznamu]
        se změní na
[low, exclusiveEnd)
```

Polootevřené rozsahy se snadno měří, protože jejich délku přímo dává odečtení.

## Kam COPY vkládá

Mezera se otevře na aktivním záznamu. Duplikovaný blok se tedy objeví bezprostředně před aktivním řádkem.

Aktivní ukazatel ležící přísně uvnitř vybraného rozsahu je odmítnut. Operace by jinak mohla otevřít mezeru uprostřed bajtů, které se právě snaží použít jako jediný souvislý zdrojový blok.

Samotná dolní hranice je povolena, protože bod vložení leží *před* tímto záznamem. Otevření mezery v takovém případě posune původní blok vzhůru a zdrojový ukazatel se opraví tak, aby jej následoval.

Uživatelská představa zůstává jednoduchá:

```text
označ blok
přesuň aktivní řádek na cíl
COPY
```

Implementace musí rozlišovat adresu cílového záznamu od adresy, na které se před ním vkládají nové bajty.

## COPY zdroj nedekóduje ani znovu nekóduje

COPY duplikuje komprimovaný rozsah bajtů přesně.

To znamená:

- descriptory instrukcí zůstanou totožné;
- pořadová čísla symbolů zůstanou totožná;
- komentáře a kódování výrazů zůstanou totožné;
- hranice záznamů se zachovají jako celek;
- během kopírování nemůže vzniknout chyba parseru.

Tabulka symbolů nepotřebuje nové položky, protože zkopírované záznamy odkazují na stejná existující pořadová čísla.

Je to rychlejší a věrnější než rozbalit každý vybraný řádek do textu a znovu jej odeslat parseru.

## DELETE počítá záznamy inkluzivně

DELETE rovněž začíná normalizovanými konci bloku. Za dolní záznam započítá jedničku a potom postupuje, dokud nedosáhne horní hranice.

Výsledný počet záznamů předá společnému mechanismu mazání z kapitoly 16.

Po zhutnění příkaz zvolí nejbližšího platného přeživšího a uloží jej jako:

```text
aktivní řádek
začátek bloku
konec bloku
```

Původní vybraný rozsah přestal existovat, takže zúžení výběru na jediný přeživší záznam je jediným jednoznačným výsledkem.

## COPY a DELETE sdílejí výběr, nikoli význam

Oba příkazy používají stejné dva blokové ukazatele a stejnou normalizační rutinu, se stavem editoru však zacházejí odlišně.

COPY zachovává původní vybrané záznamy. Protože společná vkládací rutina opravuje blokové ukazatele na mezeře nebo nad ní, výběr při přesunu nadále sleduje původní blok.

DELETE vybrané záznamy zničí. Jeho volající proto nahradí blokové ukazatele ukazatelem na přeživší záznam.

Je to další příklad oddělení fyzické a sémantické vrstvy:

```text
vkládací mechanismus:
    sleduj bajty, které se přesunuly

význam COPY:
    výběr stále popisuje původní bajty

význam DELETE:
    starý výběr zmizel; zvol nový jednořádkový výběr
```

## Jeden scanner, jedna reprezentace bloku, dvě transformace paměti

Nyní je vidět úspornost příkazové vrstvy editoru.

### FIND

```text
scanner záznamů + expander + textový matcher
```

### PRINT

```text
stejný scanner záznamů + expander + výstupní callback
```

### REPLACE

```text
expander + matcher + editační buffer + běžný parser + změna overwrite
```

### COPY

```text
hranice bloku + průchod záznamy + vkládací transformace
```

### DELETE

```text
hranice bloku + průchod záznamy + mazací transformace
```

Příkazy nejsou pěti nezávislými programy. Jsou pěti skladbami společných mechanismů.

## Úplný příklad FIND

Předpokládejme, že zdroj obsahuje:

```asm
START   LD B,5
LOOP    DJNZ LOOP
        RET
```

Uživatel zadá:

```text
FIND s:loop
```

Cesta je následující:

```text
1. parser příkazu rozpozná rozsah S
2. scanovací kurzor se nastaví na sourceBufferPreviousLine
3. příznak omezení na blok se vynuluje
4. uložený vzor dostane délku 4 a bajty "loop"
5. scanner přejde k prvnímu záznamu zdroje
6. záznam se rozbalí do lineBuffer
7. matcher vyzkouší každou viditelnou pozici a přeskakuje oddělovače $01
8. scanner opakuje postup, dokud neodpovídá "LOOP"
9. odpovídající komprimovaný záznam se stane aktivním
10. překreslení warm startu umístí tento záznam na přístupový řádek
```

Shoda uspěje bez ohledu na to, zda výpis zobrazuje `LOOP`, `loop` nebo kombinaci velikostí písmen, protože porovnání ignoruje bit 5 ASCII.

## Úplný příklad REPLACE

Na řádku obsahujícím:

```asm
START   LD B,5
```

předpokládejme uložený vzor FIND `5` a uživatel zadá:

```text
REPLACE :8
```

PROMETHEUS:

```text
rozbalí komprimovaný záznam
zkopíruje "START LD B," do vstupního bufferu
najde shodu "5"
připojí "8"
dokončí editovatelný řádek
vynutí OVERWRITE
odešle řádek běžnému parseru
vloží nový záznam
odstraní starý záznam
obnoví běžnou continuation
vyhledá další uložený vzor
```

Kdyby změněný text nebyl platným assemblerem, běžný parser by ohlásil svou obvyklou chybu. REPLACE získává validaci zdarma tím, že používá zavedenou cestu pro zadávání zdroje.

## Úplný příklad blokového COPY

Předpokládejme, že vybrané hranice obepínají:

```asm
LOOP    DJNZ LOOP
        RET
```

a aktivním řádkem je pozdější záznam `ENT START`.

COPY vypočítá rozsah bajtů od začátku `LOOP` po bajt před `ENT START`, otevře mezeru na záznamu `ENT` a zkopíruje do ní přesné komprimované bajty.

Žádný text se znovu nesestavuje. Duplikované záznamy se objeví před `ENT START` a odkazují na stejná pořadová čísla symbolů jako originály.

Zda je duplikovaný zdroj logicky smysluplný, je odpovědností programátora. Editor kopíruje záznamy; nepřejmenovává labely ani se nepokouší zabránit duplicitním definicím. Sémantické problémy později diagnostikuje assembler.

## Úplný příklad blokového DELETE

Se stejným dvouřádkovým výběrem DELETE:

```text
normalizuje hranice
spočítá 2 záznamy
najde adresu bajtu za RET
přesune veškerý pozdější zdroj i tabulku symbolů dolů
vyčistí starý konec
opraví hranice oblastí
v případě potřeby obnoví výplň prázdného zdroje
zvolí nejbližší přeživší záznam
zúží na něj výběr i aktivní řádek
```

Okno zdroje se potom z opraveného řetězce znovu sestaví.

## Zpět k editoru jako celku

Tyto příkazy působí rozsáhle, protože zasahují mnoho řádků nebo provádějí dlouhé hledání. Každý z nich však stojí na reprezentacích vytvořených už pro obyčejnou editaci.

FIND neprohledává komprimované opcodes. Rozbaluje záznamy běžnou cestou výpisu. REPLACE nevynalézá druhý parser. Znovu sestaví běžný editovatelný řádek. PRINT nemá vlastní iterátor zdroje. Pouze vymění callback FIND. COPY nerozumí assembleru. Duplikuje platný rozsah záznamů. DELETE nemusí předem znát délku každého záznamu. Prochází stejný řetězec jako pohyb kurzoru.

Editor získává sílu nikoli hromaděním nesouvisejícího jednoúčelového kódu, ale tím, že jeho kompaktní části lze znovu skládat.

## Co se změnilo v paměti nebo na obrazovce?

Po úspěšném FIND:

- uložená scanovací pozice se posunula;
- ukazatel aktivního řádku označuje odpovídající záznam;
- komprimovaný zdroj se nezměnil;
- okno zdroje se překreslilo kolem nalezeného místa.

Po REPLACE:

- aktuální komprimovaný záznam byl nahrazen běžným parse/commit postupem;
- délka zdroje se mohla zvětšit nebo zmenšit;
- odkazy na symboly se mohly prostřednictvím parseru změnit;
- obnovil se běžný režim INSERT a běžná continuation;
- stav FIND postoupil směrem k dalšímu výskytu.

Po COPY:

- přesný komprimovaný rozsah bajtů byl vložen před aktivní záznam;
- zdroj a úložiště symbolů nad mezerou se posunuly vzhůru;
- původní vybrané záznamy zůstaly a ukazatele výběru je následovaly;
- duplikát může zavést duplicitní labely na úrovni assembleru, což není starostí editoru.

Po DELETE:

- inkluzivně vybrané záznamy byly odstraněny;
- pozdější bajty zdroje a symbolů se posunuly dolů;
- výběr se zúžil na přeživší záznam;
- aktivní řádek označuje stejného přeživšího;
- znovu existují požadované prázdné koncové záznamy.

Během PRINT:

- komprimovaný zdroj zůstává beze změny;
- `lineBuffer` se znovu sestaví pro každý záznam;
- kanál 3 dostává kanonický rozbalený zdroj a carriage returns;
- SPACE může scan přerušit.

## Důležité myšlenky pro další kapitoly

- stav FIND přetrvává v samomodifikovaných operandech scanovací pozice a rozsahu;
- kurzor „před prvním záznamem“ zjednodušuje restartované prohledávání;
- FIND a PRINT sdílejí jediný scanner záznamů řízený callbackem;
- hledání porovnává viditelný rozbalený text, nikoli komprimované bajty;
- matching i replacement ignorují oddělovače polí `$01`;
- porovnání bez ohledu na velikost písmen maskuje bit 5 ASCII;
- REPLACE znovu sestavuje běžný editovatelný řádek a používá standardní parser;
- REPLACE může bezpečně změnit velikost záznamu i odkazy na symboly;
- continuation hook po příkazu vytváří vícestupňová workflow;
- inkluzivní blok se posunem za horní záznam převádí na polootevřený rozsah bajtů;
- COPY duplikuje komprimované bajty přesně;
- DELETE zničí význam výběru, a proto resetuje stav bloku;
- příkazy editoru skládají existující mechanismy místo jejich duplikování.

## Vysvětlené zdrojové kotvy

- `invokeFind`
- `.initializeFindScopeAndRestartAtSourceBeginning`
- `.checkFindBlockScopePrefix`
- `findNextOccurrence`
- `.configureLineScanAndStart`
- `varcFindScanPosition`
- `varcFindRestrictToBlock`
- `varcLineScanCallback`
- `storeLowercaseCommandArgument`
- `findTextInLineBuffer`
- `matchSearchTextAtDE`
- `searchTextLength`
- `searchTextCharacters`
- `invokeReplace`
- `.replaceScanLoop`
- `.replaceCopyReplacementLoop`
- `.replaceSkipMatchedTextLoop`
- `.replaceCopyUnmatchedCharacter`
- `.replaceFinalizeInputLine`
- `replaceCommitContinuation`
- `replacementTextStorageBaseMinusOne`
- `appendReplacementCharacterOrAbort`
- `varcPostCommandContinuationJump` na úrovni workflow
- `invokePrint`
- `printLineBufferToChannel3`
- `outputLineBufferToChannel3`
- `getSelectedBlock` na úrovni příkazu
- `testSourceRecordOutsideSelectedBlock` na úrovni příkazu
- `invokeCopy`
- `invokeDelete`
