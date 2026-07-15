# Kapitola 30: VERIFY a LOAD

Uložení projektu je pouze polovina podpory kazety.

PROMETHEUS musí odpovědět na dvě rozdílné otázky:

```text
VERIFY: Obsahuje kazeta přesně to, co zapsal poslední SAVE?
LOAD:   Jak lze uložený projekt bezpečně sloučit se současným stavem editoru?
```

Oba příkazy sdílejí nízkoúrovňovou kazetovou mechaniku, ale jejich účinky jsou
velmi odlišné. VERIFY porovnává. LOAD importuje.

Překvapivou částí je LOAD. Uložené bajty komprimovaného zdroje **nekopíruje**
přímo do aktivní oblasti zdroje. Místo toho balík dočasně umístí poblíž U-TOP,
rozbalí jeden importovaný záznam pomocí importované tabulky symbolů, převede jej
zpět na běžný řádek editoru a odešle tento řádek přes obvyklý parser a mechanismus
vkládání.

Tato zdánlivě nepřímá cesta řeší několik obtížných problémů současně:

- importovaná pořadová čísla symbolů se mohou lišit od současných;
- současný projekt už může obsahovat některá stejná jména;
- podrobnosti formátu záznamů zdroje má ověřovat jeden parser, nikoli dva;
- importované záznamy mohou při novém zakódování narůst nebo se zkrátit;
- načtení bloku se má chovat jako vložení ručně napsaného zdroje.

Začneme u VERIFY a potom projdeme LOAD od kazetové hlavičky přes dočasně uložený
payload až po slučování záznam po záznamu.

## VERIFY si pamatuje předchozí SAVE

`invokeVerify` nepřijímá argument jména ani rozsahu. Spoléhá na stav opravený
nejnovějším SAVE:

```text
začátek zdroje
délka zdroje
začátek tabulky symbolů
pomocná délka řetězeného segmentu
zapamatované jméno souboru
```

Díky tomu je VERIFY přesný, ale záměrně krátkodobý.

Představme si, co by se stalo, kdyby VERIFY znovu vypočítal „celý současný
zdroj“:

- předchozí SAVE mohl zapsat pouze vybraný blok;
- uživatel mohl od SAVE upravit záznamy;
- tabulka se mohla přesunout nebo změnit délku;
- samotné zapamatované jméno nepopisuje původní paměťové segmenty.

Samomodifikovaná pole uchovávají skutečné rozsahy odeslané na kazetu.

## Hledání hlavičky CODE

VERIFY i LOAD používají `scanTapeForNextCodeHeader`.

Rutina opakovaně žádá o sedmnáctibajtovou hlavičku Spectra do
`BOTTOM_LINE_VRAM_ADDRESS`:

```asm
scanTapeForNextCodeHeader:
    ld ix,BOTTOM_LINE_VRAM_ADDRESS
    ld de,00011h
    xor a
    scf
    call callRomTapeLoadOrVerify
    jr nc,scanTapeForNextCodeHeader
```

Helper pokračuje po neúspěšných čteních. Po úspěšné hlavičce zobrazí zprávu
`Found` a deset bajtů jména souboru. Netisknutelné znaky se zobrazují jako `?`,
takže poškozená nebo neobvyklá hlavička nemůže poslat řídicí kódy rendereru
obrazovky.

Bajt typu musí být roven 3:

```asm
    ld a,(BOTTOM_LINE_VRAM_ADDRESS)
    cp 003h
    jr nz,scanTapeForNextCodeHeader
```

Ostatní typy bloků Spectra se ignorují.

Toto oddělení je užitečné:

```text
scanner hlaviček:
    najdi další platnou hlavičku CODE

volající:
    rozhodni, zda je její jméno přijatelné
```

VERIFY vyžaduje přesné jméno. LOAD podporuje přesný výběr i wildcard.

## Přesné porovnání jména souboru

Porovnání je přímočará smyčka přes deset bajtů:

```asm
compareRequestedNameWithLoadedHeaderExact:
    ld b,MAX_FILE_NAME_LENGTH
    ld hl,fileNameBuffer
    ld de,BOTTOM_LINE_VRAM_ADDRESS+1
.compareLoadedHeaderNameLoop:
    ld a,(de)
    cp (hl)
    inc hl
    inc de
    ret nz
    djnz .compareLoadedHeaderNameLoop
    ret
```

Jména se porovnávají jako pole hlavičky s pevnou délkou, včetně doplňovacích
mezer. `ABC` a `ABC       ` už v této chvíli nejsou dvě různé reprezentace;
parser zapamatované jméno předem normalizoval do desetibajtové podoby doplněné
mezerami.

VERIFY opakuje hledání, dokud nenajde přesné jméno:

```asm
invokeVerify:
    call scanTapeForNextCodeHeader
    call compareRequestedNameWithLoadedHeaderExact
    jr nz,invokeVerify
```

## Nesrovnalost wildcardu v LOAD

Manuál popisuje jméno tvořené deseti mezerami jako „přijmi první blok CODE“.
Skutečný kód je širší.

`acceptLoadedHeaderIfNameMatchesOrWildcard` připraví smyčku o deseti iteracích,
ale při wildcard testu opakovaně zkoumá pouze `fileNameBuffer[0]`; `HL` se
neposouvá.

Skutečné chování tedy je:

```text
první bajt zapamatovaného jména je mezera:
    přijmi libovolnou hlavičku CODE

jinak:
    vyžaduj přesnou shodu deseti bajtů
```

Jméno začínající jedinou mezerou je proto wildcard, i když pozdější bajty
mezerami nejsou.

Tato kniha popisuje implementované chování a nepřepisuje je potichu tak, aby
odpovídalo pravděpodobnému záměru manuálu. Takové drobné nesrovnalosti patří k
poctivému porozumění historickému programu.

## Carry volí v ROM mezi LOAD a VERIFY

Sdílený wrapper `callRomTapeLoadOrVerify` dostává:

```text
IX = cílová nebo porovnávaná adresa
DE = počet bajtů
A  = očekávaný flag kazetového bloku
carry set   -> LOAD
carry clear -> VERIFY
```

Připraví očekávaný flag a stav operace v alternativním akumulátoru, zakáže
přerušení, zapíše stav border/MIC pro kazetu na port `$FE` a zavolá vstup
`LD-BYTES` v ROM Spectra.

Tatáž rutina ROM může příchozí bajty buď zapisovat do RAM, nebo je porovnávat s
RAM. Režim volí carry při vstupu.

Proto VERIFY vytváří `$FF` bez nastavení carry:

```asm
    xor a
    dec a
```

Akumulátor se změní na `$FF`, zatímco carry zůstane vynulováno.

LOAD naopak před voláním záměrně ponechá carry nastavené.

## Ověření segmentu zdroje

Po nalezení odpovídající hlavičky načte VERIFY zapamatovaný rozsah zdroje do IX
a DE:

```asm
varcLastSavedSourceStart:
    ld ix,00000h
varcLastSavedSourceLength:
    ld de,00000h
    call performTapeLoadOrVerifyOrReportError
```

Operandy opravil SAVE.

V režimu VERIFY porovnává ROM každý příchozí bajt zdroje s bajtem, který už leží
v paměti. Neshoda vynuluje carry úspěchu a vede ke zprávě `Tape error`.

Zdroj může být:

- úplná smysluplná oblast zdroje; nebo
- přesně vybraný blok uložený naposledy.

VERIFY nemusí vědět, která možnost platí. Důvěřuje zapamatovanému rozsahu.

## Ověření pomocného segmentu

Část tabulky používá stejný protokol řetězeného markeru jako SAVE. VERIFY znovu
načte zapamatovaný začátek tabulky symbolů a pomocnou délku, obnoví stav markeru
ROM v alternativním akumulátoru a zavolá `ROM_LD_MARKER`.

Nízkoúrovňová posloupnost je neobvyklá, ale logická operace jednoduchá:

```text
porovnej pokračování můstku a tabulky na kazetě
s přesným aktivním segmentem tabulky použitým SAVE
```

Selže-li porovnání zdroje nebo tabulky, příkaz ohlásí `Tape error`. Je-li
stisknuta SPACE, společná cesta přerušení se vrátí do editoru.

## Proč má VERIFY následovat okamžitě

Předpokládejme, že uživatel provede:

```text
SAVE :work
vlož nový řádek zdroje
VERIFY
```

Zapamatovaný ukazatel zdroje a délka mohou stále popisovat původní bajtový
rozsah, ale vložení mohlo přesunout nebo změnit to, co na něm leží. Tabulka
symbolů se také mohla posunout vzhůru.

VERIFY není systém pro správu verzí. Je to kontrola důvěry v zápis na kazetu:

```text
SAVE
VERIFY dříve, než začneš dál editovat
```

Jeho stavová implementace tomuto účelu přesně odpovídá.

## LOAD začíná vynucením režimu INSERT

Nativní LOAD je operace sloučení. Importované záznamy se vloží za současný
access line.

`prepareTapeSourceImport` začíná:

```asm
    xor a
    ld (varcInsertMode+1),a
```

V obrácené stavové konvenci editoru volí nula INSERT, nikoli OVERWRITE.

Neexistuje skrytá volba „nahraď současný projekt“. Chce-li uživatel nahradit
vše, nejprve vymaže současný zdroj a potom načte nový.

Jakmile tomuto chování rozumíme, je užitečné: uložené bloky lze vkládat do
většího zdroje na zvolené pozici.

## Zpracování nebo opětovné použití požadovaného jména

LOAD přijímá stejnou konvenci dvojtečky jako SAVE:

```text
LOAD :name    ulož a požaduj nové jméno
LOAD          znovu použij zapamatované jméno
```

`readFileNameWithColon` mění `fileNameBuffer` pouze tehdy, je-li přítomna
dvojtečka. Nízkoúrovňový scanner potom prochází kazetové hlavičky CODE, dokud
některou nepřijme wildcard nebo přesná shoda.

## Dočasné umístění úplného payloadu pod U-TOP

Současný zdroj a tabulka symbolů musí zůstat přítomny, zatímco se importované
záznamy interpretují. PROMETHEUS proto nemůže načíst příchozí balík přímo přes
ně.

Z bajtů 11 a 12 hlavičky přečte celkovou délku, ověří, že blok může existovat
současně se současnými dynamickými daty, a zvolí:

```text
temporaryStart = U-TOP - totalLength
```

Úplný payload zabere:

```text
[temporaryStart, U-TOP)
```

Tím využije volnou horní paměť, aniž by změnil některý aktivní ukazatel zdroje.

Je-li blok příliš velký, aby mohl současně existovat se současným projektem,
zobrazí se `Memory full` ještě před načtením datového bloku.

V této chvíli existují zdroj a tabulka symbolů dvakrát, v různých podobách:

```text
dolní paměť:
    současný aktivní zdroj a současná aktivní tabulka

horní dočasná paměť:
    importovaný zdroj + můstek + importovaná tabulka
```

Tato dočasná souběžná existence je klíčem k bezpečnému překladu jmen.

## Odvození dočasných oblastí z metadat hlavičky

Označme:

```text
P = temporaryStart
S = sourceLength z bajtů hlavičky 15..16
```

LOAD potom opraví:

```text
varcImportedDataCursor      = P
varcImportedSourceEnd       = P + S
varcImportedSymbolTableBase = P + S + 2
```

Přidané dva bajty přeskočí můstek popsaný v kapitole 29.

Úplný datový blok se potom načte s:

```text
IX = P
DE = totalLength
A  = $FF
carry set
```

Chyba kazety nastane dříve, než začne slučování, takže pokud se datový blok
nepodaří načíst, aktivní zdroj zůstane beze změny.

## Proč by přímé kopírování bylo chybné

Představme si, že importovaný zdroj obsahuje pořadové číslo 2 pro symbol `LOOP`.

V současném projektu může pořadové číslo 2 znamenat `SCREEN`, nebo může existovat
jen jeden symbol. Přímé zkopírování bajtů záznamu by tiše změnilo význam programu.

I když obě tabulky obsahují stejná jména, jejich pořadová čísla se mohou lišit,
protože symboly vznikly v jiném pořadí.

PROMETHEUS to řeší překladem přes čitelná jména:

```text
importované pořadové číslo
    -> importovaná tabulka symbolů
    -> zápis jména symbolu
    -> běžný aktivní parser
    -> současné pořadové číslo
```

Importovaná tabulka dodává význam; současná tabulka dodává novou identitu.

## Dočasné přepnutí resolveru symbolů

`resolveSymbolReferenceToName` běžně začíná nepřímým načtením ukazatele na
současnou dynamickou tabulku symbolů.

Během expanze importovaného záznamu LOAD opravuje tuto první instrukci mezi dvěma
opcody:

```text
$21  LD HL,nn      použij přímou adresu dočasné tabulky
$2A  LD HL,(nn)    použij nepřímý ukazatel aktivní tabulky
```

Helper je:

```asm
patchSymbolReferenceResolverBase:
    ld (varcSymbolTableBasePointer),a
    ld (varcSymbolTableBasePointer+1),hl
    ret
```

Mění současně opcode i jeho operand.

Pro jeden importovaný záznam:

```text
oprav resolver na přímou importovanou tabulku
expanduj záznam do čitelného řádku
obnov resolver na nepřímou současnou tabulku
```

Obnovení proběhne bezprostředně po expanzi, ještě před parsováním řádku do
aktivního zdroje.

Jde o disciplinovanou samomodifikaci použitou jako dočasná strategie adresování.

## Smyčka importovaných záznamů

`invokeLoad` opraví pokračování editoru po příkazu tak, aby se úspěšně odeslaný
řádek vrátil do importní smyčky:

```asm
    ld hl,continueSourceImportAfterSubmittedLine
    ld (varcPostCommandContinuationJump+1),hl
```

Každá iterace potom provede následující práci.

### 1. Zapamatuj současný dočasný záznam

`varcImportedDataCursor` načte adresu dalšího importovaného záznamu do `HL`.
Adresa se také vloží do `IX`, což je ukazatel na záznam zdroje očekávaný expanzní
rutinou.

### 2. Najdi další záznam před zpracováním současného

`getNextSourceRecord` rozumí pevným i proměnným délkám záznamů. LOAD okamžitě
uloží následníka zpět do `varcImportedDataCursor`.

Jde o známý vzor bezpečné iterace:

```text
vypočítej další pozici dříve, než hlubší operace znovu použije registry
```

### 3. Zastav na hranici importovaného zdroje

Adresa současného záznamu se porovná s `varcImportedSourceEnd`. Jakmile leží na
hranici nebo za ní, bylo dosaženo můstku a tabulky a import je hotov.

### 4. Expanduj pomocí importované tabulky

Resolver se opraví na `LD HL,nn` s bází dočasné tabulky. Potom:

```asm
    call expandSourceRecordToLineBuffer
```

Výsledkem je běžný 32bajtový řádek editoru obsahující label, mnemonic, operandy,
mezery a značku kurzoru `$01`.

### 5. Obnov aktivní resolver

Opcode se vrátí na `$2A` a operand pojmenuje `varcSymbolTablePt+1`. Běžné
operace editoru mohou znovu řešit současná pořadová čísla.

### 6. Odmítnutí importovaného záznamu, který nelze expandovat

Ohlásí-li expanze `Source error`, příkaz se přeruší a problematický text zůstane
k dispozici pro prohlédnutí nebo opravu.

### 7. Odeslání přes běžný editor

32bajtový řádek se zkopíruje do `inputBufferStart`, pomocné buffery parseru se
vyčistí a řízení skočí na:

```text
submitInputLineOrDispatchCommand
```

Od tohoto okamžiku nelze importovaný řádek odlišit od řádku zadaného na
klávesnici.

Projde:

- rozdělením polí;
- rozpoznáním mnemonic a operandů;
- ověřením expressionů;
- vyhledáním nebo vytvořením aktivních symbolů;
- zakódováním současných pořadových čísel;
- sestavením komprimovaného záznamu;
- kontrolou kapacity paměti;
- vložením za současný access line.

Existuje jediný jazyk zdroje a jediná cesta vkládání.

## Příklad překladu symbolu

Předpokládejme, že dočasný balík obsahuje:

```text
importované pořadové číslo 1 -> START
importované pořadové číslo 2 -> LOOP
```

V aktivním projektu už je:

```text
současné pořadové číslo 1 -> SCREEN
současné pořadové číslo 2 -> START
současné pořadové číslo 3 -> WIDTH
```

Importovaný záznam odpovídající:

```asm
        DJNZ LOOP
```

obsahuje importované pořadové číslo 2. Během expanze:

```text
importované pořadové číslo 2
    -> záznam "LOOP" v dočasné tabulce
    -> text lineBufferu "DJNZ LOOP"
```

Během běžného parsování ještě `LOOP` v aktivní tabulce není, takže se vytvoří:

```text
současné pořadové číslo 4 -> LOOP
```

Nově vložený komprimovaný záznam používá současné pořadové číslo 4, nikoli
importované číslo 2.

Význam zůstane zachován, přestože se identita změní.

## Proč mohou záznamy během LOAD změnit velikost

Dočasný a nový záznam jsou sémanticky ekvivalentní, ale nemusí mít stejnou
fyzickou délku.

Důvody zahrnují:

- současná pořadová čísla symbolů mohou mít jiné hodnoty horního a dolního bajtu;
- symbol už může existovat místo toho, aby byl nově vytvořen;
- normalizovaný text se znovu tokenizuje současnou implementací;
- růst současné tabulky mění dostupnou paměť, nikoli sémantiku zdroje.

LOAD proto nemůže předpovědět konečnou aktivní velikost pouze z délky
importovaného zdroje.

## Pohybující se hranice kolize

Aktivní dynamická oblast roste vzhůru, jak se vkládají importované řádky a
symboly. Ukazatel na další dočasný záznam se také pohybuje vzhůru vysokým
payloadem.

Před další iterací PROMETHEUS porovnává:

```text
současný konec aktivního kódu
adresu dalšího dočasného záznamu
```

Dokud platí:

```text
liveEnd < nextImportedRecord
```

obě oblasti zůstávají oddělené.

Setkají-li se nebo překříží, LOAD ohlásí `Memory full`.

Tato pozdní kontrola je nutná, přestože původní payload prošel úvodní kontrolou
kapacity. Nové zakódování a slučování symbolů mohou spotřebovat jiný počet bajtů
než dočasná reprezentace.

Obraz je:

```text
nízké adresy                                          vysoké adresy

[aktivní zdroj + aktivní tabulka --->] volná mezera [---> zbytek payloadu]

                         kolize znamená Memory full
```

## Zobrazení průběhu a přerušení

Po každém úspěšně vloženém řádku `continueSourceImportAfterSubmittedLine`
zkontroluje klávesnici.

Chování je záměrně kompaktní:

```text
žádná klávesa  pokračuj v importu bez zobrazování
SPACE          přeruš a vrať se do editoru
jiná klávesa   propadni do překreslení viditelného okna zdroje
```

Propad do `renderVisibleSourceRecords` poskytuje průběh na vyžádání, aniž by
každý importovaný řádek zpomaloval překreslením.

Dříve importované řádky zůstanou zachovány, i když uživatel stiskne SPACE.

## LOAD je inkrementální, nikoli transakční

PROMETHEUS neudržuje rollback log.

Různá selhání nastávají v různých fázích:

### Chyba hlavičky nebo dat na kazetě

Nastane před začátkem slučování. Aktivní zdroj zůstane beze změny.

### Chyba expanze nebo parseru

Dřívější záznamy zůstanou vloženy. Problematický rekonstruovaný řádek zůstane v
čitelné podobě pro opravu.

### SPACE během slučování

Dřívější záznamy zůstanou vloženy. Operace se zastaví.

### Pozdní kolize paměti

Dřívější záznamy zůstanou vloženy a zobrazí se `Memory full`.

Nejde o nedbalé ošetření chyb. Plně transakční import by vyžadoval další paměť
pro zapamatování každého vložení a každé změny tabulky symbolů — tedy právě ten
prostředek, který už je pod tlakem.

Program dává přednost užitečnému částečnému výsledku a opravitelnému současnému
řádku.

## Dokončení importu

Jakmile dočasný cursor dosáhne `varcImportedSourceEnd`, LOAD obnoví běžné
pokračování po příkazu:

```asm
.finishSourceImport:
    ld hl,prometheusWarmStart
    ld (varcPostCommandContinuationJump+1),hl
    jp (hl)
```

Dočasný balík zůstane v horní paměti pouze jako opuštěné bajty. Leží mimo aktivní
ukazatele zdroje a tabulky a pozdější práce jej může přepsat.

Importované záznamy nyní zcela patří současnému projektu:

- používají současná pořadová čísla symbolů;
- zabírají současnou komprimovanou oblast zdroje;
- jejich jména žijí v současné tabulce symbolů;
- objevují se za řádkem editoru, který byl aktivní při začátku LOAD.

## Nahrazení místo sloučení

Protože LOAD vždy používá režim INSERT, dokumentovaný postup nahrazení je:

```text
CLEAR y
LOAD :name
```

Bez vymazání je LOAD sloučením na současné pozici.

Díky tomu lze uložený blok znovu používat jako fragment knihovny. Tentýž
mechanismus může vložit rutinu do jiného projektu bez zvláštního linkeru nebo
systému include souborů.

## V prostém pseudokódu: VERIFY

```text
function verifyMostRecentSave():
    repeat:
        header = readNextValidCodeHeader()
    until header.name == retainedName

    verifyTapeBytes(
        memory = rememberedSourceStart,
        length = rememberedSourceLength,
        flag = $FF
    )

    verifyChainedAuxiliaryBytes(
        memory = rememberedTableStart,
        length = rememberedAuxiliaryLength
    )

    if některé porovnání selhalo:
        zobraz "Tape error"
```

## V prostém pseudokódu: LOAD

```text
function loadNativeSource(command):
    editorMode = INSERT
    parseOrReuseFilename(command)

    repeat:
        header = readNextValidCodeHeader()
    until wildcardRequested() or header.name == retainedName

    total = header.totalLength
    sourceLength = header.prometheusSourceLength

    vyžaduj, aby currentDynamicData + total mohly společně existovat pod UTOP

    stagedStart = UTOP - total
    loadTapeData(stagedStart, total)

    stagedCursor = stagedStart
    stagedSourceEnd = stagedStart + sourceLength
    stagedTableBase = stagedSourceEnd + 2

    postSubmitContinuation = continueImport

    while stagedCursor < stagedSourceEnd:
        record = stagedCursor
        stagedCursor = nextRecord(stagedCursor)

        resolver = direct(stagedTableBase)
        line = expandRecord(record)
        resolver = indirect(currentSymbolTablePointer)

        odešli line přes běžný parser editoru v režimu INSERT

        if SPACE:
            přeruš a zachovej vložený prefix
        if currentCodeEnd >= stagedCursor:
            ohlas Memory full a zachovej vložený prefix

    postSubmitContinuation = normalWarmStart
    return do editoru
```

## Co se změnilo v paměti

Po úspěšném VERIFY:

- pracovní prostor hlavičky obsahuje odpovídající hlavičku CODE;
- bajty kazety byly porovnány se zapamatovanými rozsahy zdroje a tabulky;
- aktivní zdroj a tabulka symbolů zůstaly beze změny.

Po úspěšném LOAD:

- úplný payload kazety byl dočasně umístěn pod U-TOP;
- `varcImportedDataCursor`, `varcImportedSourceEnd` a
  `varcImportedSymbolTableBase` byly opraveny podle dočasného rozložení;
- `resolveSymbolReferenceToName` se opakovaně přepínal mezi adresováním importované
  a aktivní tabulky;
- každý importovaný záznam byl expandován do textu a znovu zakódován běžným
  editorem;
- aktivní zdroj a tabulka rostly vzhůru;
- importovaná pořadová čísla byla nahrazena současnými pořadovými čísly se
  stejnými jmény;
- pokračování po příkazu bylo obnoveno na `prometheusWarmStart`.

## Důležité labely, které jsme potkali

- `invokeVerify`
- `scanTapeForNextCodeHeader`
- `compareRequestedNameWithLoadedHeaderExact`
- `acceptLoadedHeaderIfNameMatchesOrWildcard`
- `callRomTapeLoadOrVerify`
- `performTapeLoadOrVerifyOrReportError`
- `ROM_LD_MARKER`
- `prepareTapeSourceImport`
- `loadMatchingCodePayloadToTemporaryMemory`
- `invokeLoad`
- `varcImportedDataCursor`
- `varcImportedSourceEnd`
- `varcImportedSymbolTableBase`
- `patchSymbolReferenceResolverBase`
- `expandSourceRecordToLineBuffer`
- `submitInputLineOrDispatchCommand`
- `continueSourceImportAfterSubmittedLine`
- `pollImportKeyboardAndRefreshIfRequested`
- `varcPostCommandContinuationJump`

## Zpět k celkovému obrazu

Nativní přenos přes kazetu není v obou směrech pouhým dumpem paměti.

SAVE je kompaktní a důvěřivý, protože zapisuje vnitřně konzistentní současný
projekt:

```text
bajty zdroje + můstek + úplná tabulka
```

LOAD je opatrný a překladový, protože tento projekt zavádí do jiného současného
stavu:

```text
dočasný záznam
    -> importovaná jména
    -> čitelný řádek
    -> běžný parser
    -> současná jména a pořadová čísla
    -> nový aktivní záznam
```

Tento návrh umožňuje PROMETHEU slučovat uložené fragmenty, zachovat význam
symbolů a znovu použít nejsilnější validační cestu, to vše bez velkého druhého
importéru.

Příští kapitola použije tentýž princip na cizejší formát zdroje: text GENS/MASM
s čísly řádků. Místo aby assembler dostal druhý úplný syntaktický engine,
PROMETHEUS převede každý cizí řádek do běžného editačního bufferu a nechá známý
editor převzít práci.
