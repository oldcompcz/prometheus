# Kapitola 58: Čtyři cesty programem

Dospěli jsme do bodu, kdy jsme téměř každý důležitý mechanismus PROMETHEA
prozkoumali samostatně. Víme, jak editor ukládá řádek, jak assembler hledá
instrukci, jak monitor rekonstruuje čitelný zdroj, jak se jedna instrukce
vykoná pod dohledem a jak se celá dílna přesune na zvolenou adresu.

Při takovém studiu rozsáhlého programu však hrozí jedno nebezpečí. Čím lépe
umíme jednotlivé části pojmenovat, tím snáze zapomeneme, že uživatel je nikdy
nevnímá jako izolované součásti.

Člověk u klávesnice si neříká:

```text
nyní vyvolám tabulku řetězců s high-bit zakončením
nyní opravím ordinal symbolu
nyní vstoupím do druhého průchodu
```

Prostě stiskne klávesu, sestaví program, podívá se do paměti nebo provede jeden
krok. PROMETHEUS za něj tiše překračuje hranice mnoha subsystémů.

Tato kapitola proto sleduje čtyři úplné cesty, aniž by se zastavovala kvůli
výuce nových mechanismů:

1. klávesa se stane trvalým zdrojem;
2. zdroj se stane strojovým kódem;
3. paměť se stane čitelným assemblerem;
4. jedna strojová instrukce se stane bezpečně pozorovanou změnou stavu.

Tyto cesty zároveň odhalují něco hlubšího. PROMETHEUS není trojice nesouvisejících
programů namačkaných do jediného binárního obrazu. Editor, assembler a monitor
si navzájem znovu a znovu půjčují své reprezentace a rutiny.

## Cesta první: klávesa se stane zdrojem

Představme si, že aktivní řádek editoru je prázdný a uživatel napíše:

```asm
LOOP    DJNZ LOOP
```

Budeme řádek sledovat od klávesové matice až do komprimované oblasti zdroje.

### 1. Spectrum ohlásí fyzickou klávesu

Hlavní smyčka editoru nakonec dospěje k:

```asm
processKey:
    call getKeypressCodeOrZero
```

ROMová rutina skenování klávesnice nevrací hotový příkaz PROMETHEA. Ohlásí
fyzickou polohu klávesy a stav modifikátorů. `processKey` potom provede vlastní
překlad dílny:

- běžná písmena se normalizují;
- CAPS SHIFT a SYMBOL SHIFT vybírají alternativní významy;
- CAPS LOCK může obrátit velikost písmen;
- příkazová písmena se mohou změnit na kompaktní tokeny nad `$80`;
- držená klávesa se porovná s předchozí normalizovanou klávesou;
- prodlevy rozhodnou, zda bude přijata jako opakování;
- bzučák potvrdí přijatý stisk.

U běžného zdrojového textu je výsledkem znak podobný ASCII. První `L` ve slově
`LOOP` ještě není labelem zdroje. Je to pouze jeden přijatý bajt.

### 2. Editovatelný řádek přijme znak

Znak vstoupí do `updateInputBuffer`. Editační řádek je nulou ukončený řetězec,
který obsahuje pohyblivou značku kurzoru `$01`. Vložení nevyžaduje velký objekt
textového editoru. Rutina přesouvá bajty skrz značku, dokud nový znak nezaujme
pozici kurzoru a značka se neposune o jedno místo doprava.

Po několika stiscích kláves dočasný buffer koncepčně obsahuje:

```text
L O O P _ _ _ _ D J N Z _ L O O P kurzor 0
```

Mezery mají význam. PROMETHEUS dělí assemblerový řádek do polí a tabulace
pomáhá uživateli mezi nimi přecházet. V této fázi je však řádek stále lidským
textem. Lze jej libovolně opravovat, aniž by se narušila trvalá oblast zdroje.

### 3. ENTER volí zdroj namísto dispatch příkazu

Když je ENTER přijat, `updateInputBuffer` se vrátí s nastaveným Z. Editor
propadne do:

```asm
submitInputLineOrDispatchCommand:
    ...
    cp 080h
    jr c,parseAndInsertSourceLine
```

První neprázdný token rozhodne o cestě:

```text
token >= $80  -> příkaz editoru, například ASSEMBLY nebo FIND
token <  $80  -> assemblerový zdrojový řádek
```

Náš řádek začíná znakem `L`, a proto se vydá cestou zdroje.

Tento malý test je křižovatkou mezi viditelným editorem a front-endem jazyka.
PROMETHEUS nepotřebuje vedle sebe samostatný parser příkazového řádku a parser
zdrojového řádku. Vrstva klávesnice a tokenů poskytne dispatchi dost informací,
aby si vybral.

### 4. Text se stane sémantickým dočasným záznamem

Volání:

```asm
call encodeInputLineToSourceRecord
```

vykoná práci prozkoumanou v kapitolách 13, 20, 21 a 22.

V našem příkladu:

1. rozpozná `LOOP` jako volitelné pole labelu;
2. najde `DJNZ` ve slovníku mnemonik;
3. klasifikuje operand jako relativní cíl obsahující expression;
4. vyhledá nebo vytvoří ordinal symbolu `LOOP`;
5. najde odpovídající záznam v tabulce instrukcí;
6. zapíše kompaktní záznam do dočasného úložiště zakódovaného záznamu;
7. připojí koncový/back-link bajt potřebný pro zpětnou navigaci.

Uložený záznam neobsahuje čtyři písmena `DJNZ`. Obsahuje indexy a bajty
expressionu, z nichž lze později znovu sestavit `DJNZ LOOP`. Zdrojový řádek
překročil svou nejdůležitější hranici:

```text
lidský zápis -> kompaktní sémantická reprezentace
```

### 5. Kombinovaná oblast zdroje a symbolů otevře mezeru

Parser se vrátí do:

```asm
parseAndInsertSourceLine:
    call encodeInputLineToSourceRecord
    call getRecordAfterActiveLine
    ...
    call insertByteRangeAtHLFromDE
```

`insertByteRangeAtHLFromDE` dělá více než jen zkopírování nových bajtů. Trvalé
záznamy zdroje a tabulka symbolů zabírají jedinou sbalenou pohyblivou oblast.
Vložení záznamu proto vyžaduje malou relokaci paměti:

```text
ověř, že se přidané bajty vejdou pod U-TOP
posuň následující suffix zdroje a symbolů nahoru
zvětši ukazatel společného konce
zvětši ukazatel začátku tabulky symbolů
oprav ukazatele vybraného bloku ležící na vložení nebo nad ním
zkopíruj nový záznam do otevřené mezery
```

Symbol `LOOP` mohl vzniknout během zakódování záznamu. Jeho jméno a vektor leží
nad záznamy zdroje, takže se přesunou společně se suffixem. Záznam ukládá pouze
ordinal a vektor stále vede od tohoto ordinalu k přesunutému záznamu jména a
hodnoty.

### 6. INSERT nebo OVERWRITE rozhodne o osudu starého řádku

Samomodifikovaný bajt na `varcInsertMode+1` volí mezi dvěma viditelnými významy
editoru:

```text
INSERT     zachovej starý aktivní záznam a vlož nový za něj
OVERWRITE  vlož nový záznam a potom odstraň starý aktivní záznam
```

Dokonce i přepis je implementován jako bezpečné vložení následované smazáním.
Toto pořadí zabrání zničení starého řádku dříve, než je nový řádek analyzován a
přijat.

### 7. Teplý start znovu sestaví pohled

Běžným dokončovacím hookem je:

```asm
varcPostCommandContinuationJump:
    jp prometheusWarmStart
```

Cesta teplého startu resetuje dočasný stav editoru, rozbalí záznamy kolem
aktivního ukazatele, vykreslí třináct záznamů nad ním a šest pod ním, obnoví
editační řádek a vrátí se do `processKey`.

Uživatel vidí jeden nový řádek. Uvnitř řádek prošel cestou:

```text
klávesová matice
-> normalizovaný bajt klávesy
-> editovatelný textový buffer
-> slovníky mnemonik a operandů
-> ordinal symbolu
-> záznam tabulky instrukcí
-> komprimovaný záznam zdroje
-> vložení do sbalené oblasti zdroje a symbolů
-> rekonstruovaný text obrazovky
```

To je první úplná cesta.

## Cesta druhá: zdroj se stane strojovým kódem

Uživatel nyní zadá průběžný příklad:

```asm
        ORG 32768
START   LD B,5
LOOP    DJNZ LOOP
        RET
        ENT START
```

a vyvolá `ASSEMBLY`.

### 1. Token příkazu dospěje k řadiči kompilace

Slovo `ASSEMBLY` nebylo v příkazovém vstupním bufferu uloženo jako běžná
písmena. Vstup z klávesnice je rozvinul na token `$C1`. Dispatcher použije tento
token jako dvoubajtový index do `commandHandlerTable` a skočí do handleru
sestavení.

Handler dospěje k:

```asm
processCompilation:
```

To není samotný generátor kódu. Je to dirigent dvou průchodů nad stejnou
posloupností komprimovaného zdroje.

### 2. Existující odemčené definice se vymažou

Před prvním průchodem běžné symboly ztratí bit `DEFINED`. Zamčené symboly si
hodnotu ponechají, aby mohly zůstat dostupné samostatně sestavené nižší vrstvy.

Tento rozdíl je malý, ale účinný:

```text
běžný label zdroje -> tato kompilace jej musí znovu definovat
zamčený symbol     -> chová se jako importovaná nebo pevná definice
```

Vektor symbolů po celou dobu zachovává ordinaly. Záznamy zdroje není třeba
přepisovat jen proto, že se hodnoty připojené k jejich jménům mají znovu
vypočítat.

### 3. Logická adresa a fyzický výstup začnou společně

Řadič inicializuje dva samomodifikované ukazatele těsně za současnou oblastí
zdroje a symbolů:

```text
varcAddressCounter        logická adresa používaná labely a $
varcAssemblyOutputPointer fyzická adresa přijímající generované bajty
```

Zpočátku jsou shodné. `ORG` je může později oddělit. PROMETHEUS tak může říci:

```text
předstírej, že kód žije na $8000
ale jeho bajty ukládej do libovolné bezpečné volné RAM
```

V našem příkladu první záznam změní logickou adresu na `$8000`, zatímco fyzický
ukazatel výstupu zůstane ve volné oblasti nad zdrojem a symboly.

### 4. První průchod prochází komprimované záznamy

Řadič nainstaluje `firstPassProcessSourceRecord` do samomodifikovaného `CALL` a
navštíví záznamy v pořadí zdroje.

Průchod nevytváří napůl hotové instrukce. Ptá se pouze na to, co musí znát pro
přiřazení adres:

```text
ORG 32768      nastav logickou adresu na $8000
START LD B,5   definuj START=$8000 a potom přičti 2
LOOP DJNZ LOOP definuj LOOP=$8002 a potom přičti 2
RET            přičti 1
ENT START      ulož požadovaný entry expression
```

Délky poskytuje tabulka instrukcí. Běžné operandy ještě není třeba vyhodnotit
jen proto, abychom zjistili, že `DJNZ expression` zabírá dva bajty.

Na konci prvního průchodu má každý label zdroje v tomto programu hodnotu.

### 5. Stejná smyčka se stane druhým průchodem

`varcAssemblyPassTransitionCounter` změní stav a dispatch `CALL` se opatchuje na
`secondPassEmitSourceRecord`. Řadič resetuje oba assemblerové ukazatele a znovu
projde stejné záznamy.

Nyní již kompaktní záznamy zdroje stačí. PROMETHEUS znovu neanalyzuje viditelný
zápis. Už zná:

- index mnemoniky;
- třídy operandů;
- vybraný záznam tabulky instrukcí;
- zakódované expressiony a ordinaly symbolů.

Pro `LD B,5` vezme druhý průchod opcode `$06` z tabulky a připojí immediate bajt
`$05`.

Pro `DJNZ LOOP` vypočítá:

```text
cíl                   $8002
adresa za DJNZ        $8004
displacement          $8002 - $8004 = -2 = $FE
```

Výslednými bajty jsou:

```text
06 05 10 FE C9
```

### 6. Každý emitovaný bajt se kontroluje

`emitByteAtAssemblyOutput` neukládá slepě přes současný ukazatel. Nejprve ověří,
že cíl leží mimo chráněnou rezidentní oblast, zdroj a symboly a zároveň pod
U-TOP.

Je to dobrý příklad toho, jak kompaktní program umisťuje bezpečnost do úzkého
sdíleného bodu. Každá třída instrukce i každá datová direktiva nakonec emituje
bajty přes stejný kontrolovaný helper. Pravidlo není třeba duplikovat v `DEFB`,
`DEFW`, indexovaných instrukcích, relativních větveních a immediate operandech.

### 7. RUN přidá poslední cestu

Jestliže uživatel zvolí `RUN`, kompilace navíc vyžaduje právě jeden platný
`ENT`. Expression `START` se vyhodnotí na `$8000`; operand generovaného volání
se opatchuje touto vstupní adresou; PROMETHEUS program zavolá; a běžný `RET` se
vrátí přes `returnFromCompiledProgram` do dílny.

Úplná cesta je:

```text
komprimované záznamy
-> predikce adres v prvním průchodu
-> hodnoty symbolů
-> vyhledání v tabulce ve druhém průchodu
-> vyhodnocení expressionů
-> kontrolovaná emise bajtů
-> volitelné spuštění řízené ENT
```

Viditelný text byl důležitý při vytvoření záznamu. Samotné sestavení pracuje
hlavně s kompaktním významem, který je již uložen v paměti.

## Cesta třetí: paměť se stane čitelným assemblerem

Předpokládejme nyní, že současná adresa monitoru je `$8000`, kam bylo uloženo
oněch pět bajtů.

Uživatel požádá o disassembly.

### 1. Současná adresa vstoupí do sdíleného producenta řádku

Monitor uchovává své zaměření v operandu samomodifikované instrukce:

```text
varcMonitorCurrentAddress+1 = $8000
```

Pohled disassembly nakonec zavolá:

```asm
disassembleNextLineToBuffer:
```

Cílem není okamžitě obrazovka. Rutina nejprve vytvoří neutrální formátovaný
řádek v `lineBuffer`.

Právě díky tomuto oddělení může stejný dekodér později zásobovat:

- rolující seznam monitoru;
- pevnou položku čelního panelu;
- výstup na tiskárnu;
- zpětné vložení do zdroje editoru.

### 2. Politika datových oblastí se kontroluje před dekódováním opcode

Adresa se otestuje proti oknům DEFB a DEFW.

Jestliže leží ve skrytém rezidentním rozsahu, řádek je vynuceně zobrazen jako
datová direktiva. PROMETHEUS tak nepředstírá, že jeho vlastní zapisovatelné
operandy, kompaktní tabulky a záznamy zdroje jsou běžnými instrukcemi.

Na `$8000` žádný takový vynucený rozsah neplatí, a proto dekódování pokračuje.

### 3. Dekodér rozpozná fyzickou podobu instrukce

`decodeInstructionAtHL` přečte `$06`. Určí rodinu prefixů, prohledá sdílenou
tabulku 687 záznamů instrukcí a najde formu:

```asm
LD B,n
```

Následující bajt poskytne `n=$05`.

Rutina vrací strukturální informace, nikoli uhlazenou prózu:

```text
délka instrukce
deskriptor mnemoniky a operandů
bajty nebo adresa operandu
základní a alternativní časování
případná třída toku řízení
```

Je to stejná tabulka, kterou assembler použil opačným směrem. Při zadávání
zdroje se PROMETHEUS ptal:

> Který záznam odpovídá mnemonice LD a operandům B,expression?

Při disassembly se ptá:

> Který záznam odpovídá prefix/opcode bajtům `$06`?

### 4. Dočasný záznam zdroje se stane formátovacím mostem

Místo udržování druhého textového formatteru assembleru vytvoří disassembler
dočasný komprimovaný záznam zdroje podobný tomu, který zadal editor.

Tento záznam potom může projít přes `expandSourceRecordToLineBuffer`, běžný
expander zdroje.

Díky tomuto opětovnému použití získá disassembly stejné:

- psaní mnemonik;
- psaní operandů;
- konvence formátování čísel;
- mezery a rozložení polí;
- pravidla zobrazování symbolů;
- reprezentaci pseudo-instrukcí pro neznámé nebo datové bajty.

Když se dekóduje následující instrukce `$10,$FE`, relativní bajt se převede zpět
na absolutní cíl `$8002`. `findSymbolOrdinalByValue` může číslo nahradit
symbolem `LOOP`, jestliže symbol s touto hodnotou existuje.

Řádky se koncepčně stanou:

```asm
8000  LD B,5
8002  DJNZ LOOP
8004  RET
```

### 5. Řádek si zvolí cíl až na konci

Kanonický řádek lze nyní spotřebovat několika způsoby.

Pro interaktivní listing jej callback seznamu monitoru vykreslí a posune okno.

Pro čelní panel vybere deskriptor pevnou pozici na obrazovce.

Pro výstup na tiskárnu posílá callback znaky přes kanál 3 Spectra.

Při zpětném disassemblování zkopíruje `monDisassembleIntoSource` rekonstruovaný
text do běžného vstupního bufferu a odešle jej přes
`submitInputLineOrDispatchCommand`. Řádek se znovu analyzuje, dostane živé
ordinaly symbolů a vloží se jako běžný záznam zdroje.

Úplná cesta tedy je:

```text
adresa paměti
-> politika DEFB/DEFW
-> fyzický dekodér opcode
-> sdílený záznam tabulky instrukcí
-> dočasný komprimovaný záznam zdroje
-> běžný expander zdroje
-> volitelná jména symbolů
-> lineBuffer
-> obrazovka, panel, tiskárna nebo editor
```

Dekodér se stal generátorem zdroje, protože oba směry se shodnou na kompaktním
jazyce zdroje uprostřed.

## Cesta čtvrtá: jedna instrukce se stane pozorovanou změnou stavu

Monitor nyní dokáže přečíst `DJNZ LOOP`. Uživatel stiskne klávesu single-step v
okamžiku, kdy uložené uživatelské PC ukazuje na `$8002` a B obsahuje 5.

### 1. Uložený procesor je výchozí pravdou

PROMETHEUS právě běží na vlastním stacku a vlastních registrech. Uživatelský
program reprezentuje uložený obraz obsahující:

- hlavní a alternativní registry;
- IX a IY;
- SP;
- logické PC;
- stav přerušení;
- refresh registr;
- nahromaděné časování.

Čelní panel zobrazuje hodnoty z tohoto obrazu. Uživatel se nedívá na živé BC
nebo AF monitoru.

### 2. Instrukce se dekóduje strukturálně

`stepAtCurrentMonitorAddress` dospěje do `stepInstructionAtHL`, která zavolá
stejný dekodér instrukcí používaný pro textové disassembly.

Tentokrát není potřeba formátovaný řádek. Krokovací engine chce:

```text
délka = 2
třída toku řízení = podmíněné relativní větvení
sekvenční adresa = $8004
provedená adresa = $8002
sekvenční a provedené časování
případný popis přístupu do paměti
```

Jedna tabulka opět slouží dvěma spotřebitelům. Monitor nedekóduje Z80 jednou pro
zobrazení a podruhé pro vykonání.

### 3. Bezpečnost se předpoví před spuštěním skutečné instrukce

`validateInstructionBeforeExecution` zkontroluje třídu instrukce a každý
předpovězený přístup do paměti.

U `DJNZ` nedochází mimo načtení samotné instrukce k žádnému čtení nebo zápisu
dat, takže ji okna READ a WRITE neodmítnou. Kandidátní následující adresy se
rovněž připraví pro pozdější kontroly RUN.

Instrukce jako `LD (HL),A` by místo toho použila uloženou hodnotu HL ke kontrole
jediné adresy WRITE. `LDIR` by ověřila celé opakované rozsahy.

PROMETHEUS operaci neemuluje. Předpovídá pouze tolik jejích navenek viditelných
účinků, aby mohl rozhodnout, zda ji smí skutečný Z80 provést.

### 4. Scratch trampoline opraví fyzický tok řízení

Původní bajty se zkopírují do scratch RAM. Podmíněné relativní větvení si
nemůže ponechat displacement `$FE`, protože `$FE` ze scratch adresy by skočil
dovnitř scratch oblasti, nikoli na logickou adresu `$8002`.

PROMETHEUS přepíše scratch displacement na `+3`:

```text
scratch DJNZ +3
propadnutí -> skok do sekvenčního zachycení
provedené větvení -> skok do provedeného zachycení
```

Skutečný Z80 stále dekrementuje B a rozhodne o podmínce ze skutečných flags a
hodnoty registru. Přesměrovány jsou pouze fyzické výstupy.

### 5. PROMETHEUS půjčí procesor uživatelské instrukci

`restoreUserStateAndExecuteTrampoline` opustí soukromý stav monitoru:

- obnoví se uložené primární a alternativní registry;
- obnoví se IX a IY;
- uložený uživatelský SP se stane živým;
- znovu se vytvoří zaznamenaná politika přerušení;
- vykonávání vstoupí do scratch instrukce.

PROMETHEUS se na krátký okamžik stane stavem uživatelova procesoru.

### 6. Zvítězí jedna ze dvou zachycovacích cest

Když B začíná hodnotou 5, `DJNZ` ji změní na 4 a větvení provede. Přepsaný
displacement `+3` vybere `captureUserStateAfterTakenFlow`.

Tato cesta:

- zakáže přerušení pro bezpečné zachycení;
- uloží výsledné uživatelské registry a ukazatel stacku;
- rekonstruuje stav přerušení;
- opraví refresh registr o instrukce přidané monitorem;
- vybere provedené logické následující PC `$8002`;
- přičte časování provedené cesty.

Kdyby se B změnilo na nulu, sekvenční zachycovací cesta by místo toho vybrala
`$8004` a kratší sekvenční časování.

### 7. Monitor se vrátí ke své běžné tváři

Nový uložený obraz nyní říká:

```text
B  = 4
PC = $8002
```

Monitor znovu vstoupí přes teplý start, překreslí čelní panel řízený deskriptory
a čeká na další klávesu.

Úplná cesta je:

```text
uložený obraz procesoru
-> sdílený dekodér instrukcí
-> předpovězené bezpečnostní kontroly
-> přepis toku řízení ve scratch oblasti
-> vykonání skutečným Z80
-> zachycení provedené nebo sekvenční cesty
-> oprava logického PC a časování
-> uložený obraz procesoru
-> překreslení čelního panelu
```

Instrukce nebyla interpretována softwarem. Byla obklopena právě tolika
mechanismy, aby ji mohl skutečný procesor vykonat a přesto se vrátil
pozorovatelný výsledek.

## Přechody jsou důležitější než krabice

Tyto čtyři cesty odhalují několik opakovaných přechodů.

### Lidský text a kompaktní význam

Editor přijímá text, ale trvalý zdroj je sémantický. Tentýž kompaktní záznam
později podporuje:

- rekonstrukci obrazovky;
- sestavení;
- překlad při ukládání a načítání z kazety;
- zpětné disassemblování;
- skenování odkazů na symboly.

### Význam instrukce a fyzické bajty

Tabulka instrukcí propojuje oba směry:

```text
mnemonika + třídy operandů -> opcode a recept emise
opcode a prefixové bajty   -> mnemonika + třídy operandů
```

Krokovacímu enginu poskytuje také délku a časování.

### Neutrální buffery a několik cílů

`lineBuffer` odděluje vytvoření od prezentace. Řádek se sestaví jednou a potom
se pošle na obrazovku, čelní panel, tiskárnu, do vyhledávací logiky nebo do
vkládání zdroje.

### Uložený stav a dočasný živý stav

Monitor zachází s uživatelským procesorem jako s daty až do posledního okamžiku.
Potom se uložený obraz stane živými registry, vykoná se jedna instrukce a
výsledek se znovu stane daty.

### Samomodifikované continuations a opakovaně použitelné smyčky

PROMETHEUS často patchuje operand `CALL` nebo `JP`, aby mohl stejnou smyčku
použít s jiným workerem:

- první průchod proti druhému průchodu;
- výstup na obrazovku proti tiskárně;
- běžný teplý start proti continuation importu nebo náhrady;
- sekvenční proti provedenému zachycení;
- chování ROM pro LOAD proti VERIFY.

Zdroj je kompaktní nejen proto, že jsou komprimovány jednotlivé záznamy, ale
také proto, že jsou toky parametrizovány drobnými kousky spustitelného stavu.

## Pohled pseudokódem na celý program

```text
while PROMETHEUS je rezidentní:
    zobraz stav editoru nebo monitoru
    key = normalize_spectrum_keyboard()

    if je odeslán zdroj editoru:
        record = parse_and_encode(text)
        insert_record_and_repair_dynamic_pointers(record)

    if je požadováno sestavení:
        first_pass(compressed_source, symbols)
        second_pass(compressed_source, symbols, checked_output)

    if je prohlížena paměť:
        decoded = decode_instruction_or_data(address)
        line = expand_through_source_formatter(decoded)
        send_line_to_selected_destination(line)

    if je krokována jedna instrukce:
        decoded = decode_instruction(address)
        validate_predicted_effects(decoded, saved_cpu)
        trampoline = rewrite_only_dangerous_control_flow(decoded)
        result = execute_on_real_z80(saved_cpu, trampoline)
        saved_cpu = repair_logical_result(result)
```

Instalátor stojí mimo tuto rezidentní smyčku, ale používá stejný styl: pomocí
kompaktních generovaných metadat promění neutrální payload pro origin nula ve
zvolené živé rozložení.

## Co se během čtyř cest mění v paměti

- editovatelný vstupní buffer přijímá a ztrácí lidský text;
- dočasné úložiště zakódovaného záznamu přijímá sémantické záznamy;
- vložení zdroje přesouvá sbalený suffix zdroje a symbolů;
- vektory symbolů získávají hodnoty během prvního průchodu;
- generované bajty se objevují nad dynamickým koncem zdroje a symbolů;
- `lineBuffer` opakovaně přijímá rekonstruované pohledy;
- uložené uživatelské registry se mění pouze tehdy, když monitor potvrdí výsledek vykonání;
- samomodifikované ukazatele a operandy callbacků řídí každý sdílený pipeline.

## Znovu propojené důležité labely

- `processKey`
- `updateInputBuffer`
- `submitInputLineOrDispatchCommand`
- `encodeInputLineToSourceRecord`
- `insertByteRangeAtHLFromDE`
- `prometheusWarmStart`
- `processCompilation`
- `firstPassProcessSourceRecord`
- `secondPassEmitSourceRecord`
- `emitByteAtAssemblyOutput`
- `disassembleNextLineToBuffer`
- `decodeInstructionAtHL`
- `expandSourceRecordToLineBuffer`
- `findSymbolOrdinalByValue`
- `monDisassembleIntoSource`
- `stepAtCurrentMonitorAddress`
- `stepInstructionAtHL`
- `validateInstructionBeforeExecution`
- `restoreUserStateAndExecuteTrampoline`
- `captureUserStateAfterTakenFlow`
- `captureUserStateAfterSequentialFlow`

## Zpět k celému stroji

PROMETHEUS působí větší než jeho 16 000 rezidentních bajtů, protože jeho části
nejsou jedna od druhé hermeticky oddělené. Výstup parseru se stává vstupem
assembleru. Disassembler si půjčuje expander zdroje. Tabulka instrukcí se
zároveň stává tabulkou časování. Uložený obraz registrů je současně modelem pro
zobrazení i spustitelným stavem procesoru.

Následující kapitola se ptá, jak právě toto sdílení, komprese a záměrné
překrývání umožnily, aby se tak úplná dílna vůbec vešla.
