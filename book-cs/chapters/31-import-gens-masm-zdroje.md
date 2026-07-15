# Kapitola 31: Import zdroje GENS/MASM

PROMETHEUS umí načíst vlastní uložené projekty, ale programátor Spectra už může
mít zdroj také v jiné podobě.

Jiný assembler může ukládat program jako text, který na pohled působí docela
obyčejně. Řádky mohou mít na začátku čísla. Znaky mohou používat bit 7 k vlastním
účelům. Řádky mohou končit znakem carriage return místo markerů záznamů zdroje
PROMETHEA. A téměř jistě nebudou používat pořadová čísla symbolů PROMETHEA ani
jeho pětibajtové deskriptory instrukcí.

Příkaz `GENS` tvoří most mezi těmito světy.

Na první pohled to zní jako rozsáhlý projekt kompatibility. Mohli bychom si
představit druhý parser, který rozumí cizí syntaxi a přímo vyrábí záznamy
PROMETHEA. Skutečná implementace je mnohem menší a opatrnější:

```text
načti cizí proud bajtů do dočasné paměti
for each cizí řádek:
    zahoď jeho dvoubajtové číslo řádku
    normalizuj jeho text do běžného editačního bufferu
    odešli tento text, jako by jej napsal uživatel
```

Poslední krok je nejdůležitější. Import GENS/MASM nevytváří druhý front-end
assemblerového jazyka. Vytváří pouze dalšího **producenta řádků editoru**.
Normální parser PROMETHEA zůstává jedinou autoritou, která smí převést text na
komprimovaný zdroj.

V této kapitole projdeme import od dispatch příkazu až po poslední převedený
řádek. Cestou uvidíme, jak zachází se jmény souborů, čísly řádků, znaky s
nastaveným horním bitem, příliš dlouhým vstupem, přerušením uživatelem a chybně
ukončenými posledními daty.

## Tři sloty příkazů vedou k jedinému importéru

Abecední tabulka příkazů obsahuje tyto položky:

```asm
    defw invokeGens                         ; $C7 / G / GENS
    defw invokeToggleNumberBase             ; $C8 / H / decimal-hex
    defw invokeGensTokenAliasI              ; $C9 / I / import path
    defw invokeGensTokenAliasJ              ; $CA / J / import path
```

Všechny tři importní labely leží na stejné adrese:

```asm
invokeGens:
invokeGensTokenAliasI:
invokeGensTokenAliasJ:
    call prepareTapeSourceImport
```

Jako běžný uživatelský příkaz je dokumentován pouze `GENS`. Sloty `I` a `J` jsou
fakta viditelná v rekonstruované dispatch tabulce, samotný statický alias nám však
neříká, zda bylo možné v každé verzi nebo konfiguraci vytvořit všechny tyto
tokeny běžným vstupem editoru.

Pro pochopení algoritmu není otázka aliasů důležitá. Všechny tři labely vstupují
do stejné cesty.

Je to opakující se poučení z reverzního inženýrství:

> Tabulka adres nám říká, které cíle existují. Ne vždy nám ale říká, které cíle
> byly určeny běžným uživatelům.

## GENS začíná přesně jako nativní LOAD

První helper je sdílen s importérem nativního projektu:

```asm
prepareTapeSourceImport:
    xor a
    ld (varcInsertMode+1),a
    call readFileNameWithColon
    call loadMatchingCodePayloadToTemporaryMemory
```

Jeho práce je:

1. vynutit režim INSERT editoru;
2. přečíst nové jméno souboru za `:`, nebo znovu použít zapamatované jméno;
3. prohledávat kazetu po odpovídající hlavičce CODE Spectra;
4. ověřit, že se payload vejde pod U-TOP;
5. načíst payload do dočasné horní paměti.

Adresa dočasného uložení se vypočítá takto:

```text
temporaryStart = U-TOP - payloadLength
```

Současný zdroj a tabulka symbolů zůstávají na svých místech. Cizí bajty leží nad
nimi, u horního konce volné oblasti.

Importér tak získá prostor pro postupnou práci:

```text
nízká paměť                              vysoká paměť

PROMETHEUS | aktivní zdroj | aktivní symboly | volno | dočasný cizí text | U-TOP
```

Jak se importované řádky vkládají, aktivní zdroj a symboly rostou vzhůru.
Dočasný proud se spotřebovává od své nízké adresy směrem vzhůru. Jestliže se tyto
dvě čelní hranice setkají, nezbývá dost prostoru pro současnou existenci obou
reprezentací.

Nativní LOAD používá metadata v hlavičce CODE k rozdělení payloadu na část zdroje
a část symbolů. GENS tato soukromá pole PROMETHEA záměrně ignoruje. Pro GENS je
načtený blok CODE pouze jednou plochou posloupností cizích bajtů. Jejím výlučným
koncem je samotný U-TOP.

## Dokumentovaný formát cizího řádku

Komentáře zdroje popisují každý cizí řádek takto:

```text
dva bajty ignorované jako číslo řádku
textové bajty
$0D carriage return
```

Malý příklad může v paměti vypadat takto:

```text
00 10 20 20 4C 44 20 41 2C 35 0D
00 20 4C 4F 4F 50 20 44 4A 4E 5A 20 4C 4F 4F 50 0D
```

Volně interpretováno:

```text
bajty čísla řádku   zdrojový text      CR
00 10               "  LD A,5"         0D
00 20               "LOOP DJNZ LOOP"   0D
```

PROMETHEUS číslo nedekóduje. Nekontroluje, zda jsou řádky seřazeny vzestupně.
Nezachovává čísla jako komentáře. Před každým textovým řádkem jednoduše přeskočí
dva bajty.

Tato volba udržuje převodník nezávislý na přesném kódování čísel řádků cizího
assembleru. Binární hodnota, desetinné číslice nebo nějaký interní token nejsou
důležité, pokud je pole čísla řádku dlouhé dva bajty.

## Pokračování se změní ještě před prvním řádkem

Běžné odeslání zdrojového řádku končí skokem přes opravitelné pokračování. Při
normálním vstupu z klávesnice toto pokračování vrací řízení do teplého startu
editoru.

GENS je nahradí:

```asm
    ld hl,continueGensImportAfterSubmittedLine
    ld (varcPostCommandContinuationJump+1),hl
```

Výsledný tok řízení je:

```text
převeď cizí řádek
    ↓
submitInputLineOrDispatchCommand
    ↓
běžný parser a mechanismus vložení
    ↓
varcPostCommandContinuationJump
    ↓
continueGensImportAfterSubmittedLine
    ↓
převeď další cizí řádek
```

Importér tedy nepotřebuje vlastní smyčku obklopující parser. Běžný parser se po
každém přijatém řádku vrátí přímo do pokračování importu.

Je to stejná technika pokračování, jakou jsme viděli u příkazů editoru a u
nativního LOAD. PROMETHEUS často mění běžně koncovou operaci v jednu etapu
většího workflow tím, že nahradí operand jediného skoku.

## Vytvoření jednoho normálního editovaného řádku

Převodník začíná zde:

```asm
.importNextGensLine:
    ld b,001h
    ld de,inputBufferStart
    ld hl,(varcImportedDataCursor+1)
    inc hl
    inc hl
```

Registry mají jednoduché úlohy:

```text
HL = další bajt cizího vstupu
DE = další bajt v PROMETHEUS inputBuffer
B  = obsazené pozice editačního bufferu, včetně budoucího markeru kurzoru
```

`HL` se dvakrát zvýší, čímž zahodí číslo řádku.

Proč `B` začíná hodnotou jedna místo nuly? Pevná vstupní oblast o 32 bajtech
potřebuje jednu pozici pro marker kurzoru/konce `$01` PROMETHEA. Importovaný text
smí zabrat pouze 31 pozic.

Základní algoritmus je:

```text
used = 1
source = importedCursor + 2
output = inputBufferStart

until source byte je CR:
    if bylo zachováno méně než 31 textových bajtů:
        normalizuj byte
        ulož jej
        used += 1
    source += 1

zapamatuj source jako další importedCursor
připoj marker $01
vynuluj zbytek 32bajtové vstupní oblasti
odešli řádek běžnou cestou
```

## Carriage return je jedinou hranicí řádku

Skenovací smyčka nejprve testuje `$0D`:

```asm
.scanNextGensLineByte:
    ld a,(hl)
    inc hl
    cp 00dh
    jr z,.finishCurrentGensLine
```

Nic jiného řádek neukončuje. Nulový bajt se považuje za řídicí znak a změní se na
mezeru. Marker konce s nastaveným horním bitem ve stylu Spectrum BASICu se pouze
ořízne na sedm bitů. Importér hledá výslovně text ukončený carriage return.

Fyzický payload proto musí mít po každém řádku správné CR. Příkaz není obecným
autodetektorem textových souborů.

## Příliš dlouhé řádky se zkrátí bez ztráty zarovnání

Test zbývající kapacity je kompaktní:

```asm
    bit 5,b
    jr nz,.scanNextGensLineByte
```

`B` začalo hodnotou 1 a po každém zachovaném znaku se zvyšuje. Jakmile dosáhne
32, nastaví se bit 5. Další znaky se už neukládají.

Rutina však zásadně pokračuje ve čtení až do CR.

Neopatrná implementace by mohla přestat číst ve chvíli, kdy se editační buffer
zaplní. Nepřečtený zbytek dlouhého řádku by se pak považoval za dvoubajtové číslo
následujícího řádku a všechny další záznamy by se poškodily.

PROMETHEUS místo toho dělá toto:

```text
prvních 31 znaků:
    zachovej

zbývající znaky před CR:
    zahoď, ale pokračuj ve skenování

první bajt za CR:
    správně začíná následující cizí řádek
```

Zkrácení se nehlásí jako chyba. Zachovaný prefix se odešle běžnému parseru. Může
být platný, nebo může skončit běžnou chybou zadávání zdroje.

Například:

```text
cizí řádek:
    VERYLONGNAME EQU SOMEEXPRESSIONTHATCONTINUES...

zachovaný řádek:
    VERYLONGNAME EQU SOMEEXPRESSION
```

Parser vidí pouze zachovaný tvar. Samotný importér neví, zda zkrácení změnilo
význam.

## Řídicí znaky se mění na mezery

U bajtu, který se ještě vejde, převodník rozlišuje tisknutelné hodnoty od
řídicích znaků:

```asm
    cp 020h
    jr nc,.storeNormalizedGensLineByte
    ld a,020h
.storeNormalizedGensLineByte:
    and 07fh
```

Implementovaná pravidla jsou:

```text
$0D:
    ukonči řádek

$00-$1F, kromě $0D:
    ulož jednu obyčejnou mezeru

$20-$FF:
    vynuluj bit 7 a ulož výsledek
```

TAB se tedy nerozvine k následujícímu tabulátorovému sloupci. Změní se na jednu
mezeru. Opakované řídicí znaky se změní na opakované mezery. Již existující
opakované mezery zůstanou zachovány.

Dochované doporučení příručky, že jedna mezera stačí, je třeba chápat jako radu
pro přípravu kompaktního zdroje, nikoli jako tvrzení, že převodník bílé znaky
slučuje.

## Proč se maže bit 7

Některé textové formáty Spectra používají horní bit k označení posledního znaku
slova nebo řádku. Také PROMETHEUS tuto konvenci používá v několika kompaktních
tabulkách. Cizí assembler může v uloženém zdroji rovněž ponechat nastavené horní
bity.

Instrukce:

```asm
    and 07fh
```

změní každý zachovaný znak na obyčejný sedmibitový text.

Například:

```text
cizí bajt     znak ve vstupu PROMETHEA
$CC           $4C = 'L'
$CF           $4F = 'O'
$CF           $4F = 'O'
$D0           $50 = 'P'
```

Převodník cizí konvenci horního bitu neinterpretuje. Bit jednoduše odstraní a
nechá běžný tokenizer PROMETHEA rozhodnout, co viditelné znaky znamenají.

## Dokončení editačního bufferu

Po nalezení CR se další zdrojová adresa uloží přímo do instrukce načítající tuto
adresu v následující iteraci:

```asm
.finishCurrentGensLine:
    ld (varcImportedDataCursor+1),hl
    ld a,001h
    ld (de),a
```

`$01` je pohyblivý marker kurzoru/konce editoru. Přestože se řádek importuje
automaticky a žádný lidský kurzor není vidět, parser očekává stejnou vstupní
reprezentaci jako při editaci z klávesnice.

Zbytek pevné vstupní oblasti se vynuluje:

```asm
.clearRemainingGensInputBuffer:
    inc de
    xor a
    ld (de),a
    inc b
    bit 5,b
    jr z,.clearRemainingGensInputBuffer
```

Výsledný buffer vypadá takto:

```text
textové bajty | $01 | nuly až do konce 32bajtové oblasti
```

Poté importér vynuluje pomocné buffery parseru a vstoupí do běžné cesty odeslání
příkazu:

```asm
    call clearStringBuffers
    jp submitInputLineOrDispatchCommand
```

Skok je významný. Za tímto bodem už neexistuje žádný zvláštní parser GENS.

## Cizí zdroj se posuzuje podle pravidel PROMETHEA

Po odeslání projde řádek stejnými etapami jako text z klávesnice:

```text
inputBuffer
    ↓
rozhodnutí zdroj-nebo-příkaz
    ↓
rozdělení polí
    ↓
hledání mnemonic
    ↓
klasifikace operandů
    ↓
zpracování výrazů a symbolů
    ↓
vytvoření komprimovaného záznamu
    ↓
INSERT do aktivního zdroje
```

Převodník tím zdarma získává několik užitečných vlastností.

### Jména symbolů vstupují do současné tabulky běžným způsobem

Cizí řádek obsahující:

```asm
LOOP    DJNZ LOOP
```

způsobí, že běžný parser symbolů najde nebo vytvoří `LOOP` v aktivní tabulce.
Žádná cizí tabulka symbolů není potřeba.

### Nepodporovaná syntaxe selže viditelně

Jestliže cizí assembler přijímal zápis, kterému PROMETHEUS nerozumí, běžný editor
ohlásí `Bad mnemonic`, `Bad operand`, `Bad instruction` nebo jinou známou chybu
zdroje.

Vadný převedený text zůstane dostupný k prohlédnutí a opravě.

### Vnitřní formát zdroje zůstane kanonický

I když je několik vnějších zápisů ekvivalentních, importované řádky se uloží ve
stejné kompaktní reprezentaci jako ručně napsané řádky. Pozdější expanze používá
kanonický zápis mnemonic a operandů PROMETHEA.

### Jeden parser znamená jednu sadu chyb a oprav

Každá oprava běžného zadávání zdroje automaticky zlepší i import GENS. Neexistuje
druhý konstruktor záznamů, který by bylo nutné udržovat synchronizovaný.

## Importovaný řádek může náhodou vypadat jako příkaz

Sdílená cesta odeslání nejprve rozhoduje, zda připravený řádek představuje zdroj,
nebo tokenizovaný příkaz. To má jemný důsledek.

GENS je určen pro řádky assemblerového zdroje a běžná assemblerová syntaxe obvykle
obsahuje úvodní mezery, labely, mnemonic nebo komentáře. Importovaný text však
není označen jako „určitě zdroj“. Prochází stejným rozlišovačem jako ručně
napsaný řádek.

Řádek, jehož normalizovaný tvar odpovídá příkazu editoru, proto může vstoupit do
dispatch příkazů místo vložení zdroje.

Návrh předpokládá, že cizí soubor obsahuje assemblerový zdroj v podobě přijatelné
pro běžný editor. Převodník netvoří vlastní chráněný dávkový jazyk.

Je to další příklad záměrného znovupoužití, které přináší výhody i pozorovatelné
sémantické důsledky.

## Pokračování po úspěšném vložení

Po dokončení parseru a inserteru se spustí opravené pokračování:

```asm
continueGensImportAfterSubmittedLine:
    call pollImportKeyboardAndRefreshIfRequested
    ld hl,(varcImportedDataCursor+1)
    ld de,(varcUTop+1)
    and a
    sbc hl,de
    jr c,.importNextGensLine
    jr .finishSourceImport
```

Dějí se tři věci.

### Za prvé: možnost zrušit operaci nebo zobrazit průběh

`pollImportKeyboardAndRefreshIfRequested` provede rychlý scan klávesnice:

```text
žádná klávesa:
    okamžitě pokračuj

SPACE:
    přeruš import a vrať se do editoru

libovolná jiná klávesa:
    znovu vykresli viditelné okno zdroje a potom pokračuj
```

Neobvyklý fall-through do `renderVisibleSourceRecords` realizuje zobrazení
průběhu na vyžádání bez překreslování po každém importovaném řádku.

Neustálé překreslování by import zpomalovalo. Bez jakéhokoli překreslení by
delší načítání vypadalo jako zamrznutí. PROMETHEUS dovoluje uživateli vyžádat si
pohled stisknutím libovolné klávesy kromě SPACE.

### Za druhé: porovnání kurzoru proudu s U-TOP

Pro GENS je U-TOP výlučným koncem dočasných dat. Dokud platí:

```text
importedCursor < U-TOP
```

rutina předpokládá, že na dané adrese začíná další cizí řádek.

Rovnost nebo vyšší adresa import ukončí.

### Za třetí: obnovení běžného pokračování editoru

GENS sdílí s nativním LOAD cestu dokončení:

```asm
.finishSourceImport:
    ld hl,prometheusWarmStart
    ld (varcPostCommandContinuationJump+1),hl
    jp (hl)
```

Dočasné pokračování se odstraní dříve, než se obnoví normální editace.

## Chybně ukončený poslední řádek může překročit hranici

Porovnání s U-TOP probíhá **mezi řádky**, nikoli pro každý skenovaný bajt.

Předpokládejme, že poslední cizí řádek nemá carriage return. Skenovací smyčka
pokračuje v posouvání `HL` a hledá `$0D`, i když už překročila U-TOP. Teprve až
se CR nakonec najde, může se řízení vrátit do
`continueGensImportAfterSubmittedLine` a provést kontrolu hranice.

Komentáře zdroje zachovávají upozornění příručky, že U-TOP na `$FFFF` může
způsobit, že se takový scan přetočí do nízkých adres ROM. Volba o něco nižšího
U-TOP toto extrémní nebezpečí zmenšuje, skutečný požadavek na formát souboru je
však jednodušší:

> Každý cizí řádek, včetně posledního, musí končit carriage return.

Nejde o moderní parser s kontrolou hranic. Je to kompaktní kód osmdesátých let,
který pracuje s důvěryhodnými daty z kazety podle dokumentovaného pravidla pro
jejich přípravu.

## Import není transakční

Stejně jako nativní LOAD vkládá GENS jeden řádek po druhém.

Jestliže deset řádků uspěje a jedenáctý selže, prvních deset ve zdroji zůstane.
Pokud uživatel stiskne SPACE, zůstanou všechny řádky vložené před přerušením.
Jestliže se příliš dlouhý řádek zkrátí na neplatnou syntaxi, předchozí práce se
nevrací zpět.

Operace se chová spíše jako písař, který rychle zadává řádky, než jako moderní
atomický import souboru:

```text
for each řádek:
    pokus se jej napsat a vložit
    při chybě skonči
```

To má dva praktické důsledky.

1. Uživatel může částečně importovaný výsledek prohlédnout a opravit.
2. Opakovaný import bez předchozího odstranění prefixu může řádky zdvojit.

Chování odpovídá omezené paměti PROMETHEA. Transakční rollback by vyžadoval
uchovat dost informací k vrácení změn v rostoucím zdroji a tabulce symbolů právě
ve chvíli, kdy dočasný cizí soubor už zabírá horní volnou oblast.

## GENS a nativní LOAD řeší odlišné překladové problémy

Oba importéry sdílejí dočasné uložení a odesílání řádků, začínají však z jiných
reprezentací.

### Nativní LOAD

```text
komprimovaný záznam PROMETHEA
+ importovaná tabulka symbolů PROMETHEA
    ↓ expanze s importovanými jmény symbolů
kanonický textový řádek
    ↓ běžný parser
nový aktivní komprimovaný záznam
```

Ústředním problémem je překlad importovaných **pořadových čísel symbolů** do
současné tabulky symbolů.

### GENS/MASM

```text
cizí číslo řádku + text + CR
    ↓ zahození čísla a normalizace bajtů
běžný textový řádek
    ↓ běžný parser
nový aktivní komprimovaný záznam
```

Ústředním problémem je překlad cizího **textového kontejneru** do konvence
vstupního bufferu editoru.

Po tomto prvním překladu se obě cesty záměrně spojí.

## Úplný příklad

Představme si dočasný cizí payload obsahující tři řádky:

```text
[number]["        ORG 32768"][CR]
[number]["START   LD B,5"][CR]
[number]["LOOP    DJNZ LOOP"][CR]
```

U druhého řádku provede importér tyto kroky:

```text
1. importedCursor ukazuje na dva bajty čísla řádku
2. přeskoč oba bajty
3. zkopíruj S T A R T mezery L D mezeru B , 5
4. vynuluj bit 7 každého kopírovaného bajtu
5. připoj $01
6. vynuluj zbytek pevného bufferu
7. odešli řádek běžným zadáním zdroje
8. najdi nebo vytvoř symbol START
9. najdi mnemonic LD
10. klasifikuj B jako pevný operand
11. zakóduj 5 jako atom výrazu
12. vytvoř a vlož komprimovaný záznam
13. vrať se přes continueGensImportAfterSubmittedLine
14. přejdi k dalšímu cizímu řádku
```

Rutina GENS nemusí v žádném okamžiku znát rozložení komprimovaného záznamu.
Potřebné znalosti dodává běžný parser.

## Malý převodník v pseudokódu

Celou funkci lze vyjádřit kompaktně:

```text
function importForeignSource(name):
    vynuť režim INSERT
    stagedStart, stagedEnd = loadMatchingCodeBelowUTop(name)
    cursor = stagedStart
    editorContinuation = continueImport

    while cursor < stagedEnd:
        cursor += 2                    // zahoď číslo řádku
        line = prázdný

        while memory[cursor] != CR:
            byte = memory[cursor]
            cursor += 1

            if length(line) < 31:
                if byte < SPACE:
                    byte = SPACE
                line.append(byte AND $7F)

        cursor += 1                    // přejdi za CR
        inputBuffer = line + CURSOR_MARKER + zeroPadding
        submitInputLineNormally()

continueImport:
    zkontroluj přerušení nebo požadavek na zobrazení průběhu

    obnov běžné pokračování editoru
```

Skutečný kód je kratší, protože stav jako `cursor` a `editorContinuation` je
uložen v operandech instrukcí místo ve formálním objektu.

## Co se změnilo v paměti

Během importu:

- cizí payload CODE je dočasně uložen bezprostředně pod U-TOP;
- `varcImportedDataCursor+1` postupuje tímto payloadem;
- `varcPostCommandContinuationJump+1` ukazuje na pokračování GENS;
- `inputBufferStart` se znovu vytváří pro každý cizí řádek;
- úspěšně analyzované řádky zvětšují aktivní komprimovaný zdroj;
- nová jména mohou zvětšovat a přeskupovat aktivní tabulku symbolů;
- samotné dočasné bajty se nepřepisují.

Po normálním dokončení:

- aktivní zdroj obsahuje nově zakódované záznamy PROMETHEA;
- importovaná čísla řádků a konvence horního bitu zmizely;
- dočasné bajty v horní paměti lze zahodit;
- běžné pokračování editoru je obnoveno.

## Proč stojí tento návrh za zapamatování

Importér GENS je krásným příkladem návrhového principu malých systémů:

> Přelož neznámou reprezentaci do běžného veřejného vstupu systému a potom
> znovu použij důvěryhodnou cestu.

PROMETHEUS po převodníku kazetových dat nechce, aby rozuměl záznamům symbolů,
deskriptorům instrukcí nebo vkládání do paměti zdroje. Chce po něm pouze, aby
postupně vytvářel věrohodné řádky editoru.

Právě proto se kompatibilita mezi dvěma assemblery vejde do několika desítek
instrukcí Z80.

## Důležité labely, které jsme potkali

- `invokeGens`
- `invokeGensTokenAliasI`
- `invokeGensTokenAliasJ`
- `prepareTapeSourceImport`
- `loadMatchingCodePayloadToTemporaryMemory`
- `varcImportedDataCursor`
- `.importNextGensLine`
- `.scanNextGensLineByte`
- `.finishCurrentGensLine`
- `continueGensImportAfterSubmittedLine`
- `pollImportKeyboardAndRefreshIfRequested`
- `submitInputLineOrDispatchCommand`
- `.finishSourceImport`

## Myšlenky potřebné v pozdějších kapitolách

- Několik operací monitoru znovu použije běžné vstupní mechanismy editoru a
  assembleru místo vytváření soukromých parserů.
- Kazetová data se často nejprve dočasně uloží do oblasti horní paměti a teprve
  potom interpretují.
- Opravitelné pokračování může změnit jednu obyčejnou operaci v etapu většího
  stavového automatu.
- Historické importéry mohou důvěřovat ukončovacím znakům souboru více, než by
  očekával moderní čtenář.

## Pokrytí zdroje

Tato kapitola vysvětluje blok importu GENS/MASM od `invokeGens` po
`continueGensImportAfterSubmittedLine`, včetně sdíleného použití
`prepareTapeSourceImport`, `varcImportedDataCursor`,
`pollImportKeyboardAndRefreshIfRequested` a běžné pipeline odeslání řádku
editoru.
