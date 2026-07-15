# Kapitola 29: Ukládání zdroje a symbolů

Program uchovávaný pouze v RAM je jen dočasným hostem.

Na 48K Spectru vypnutí stroje smaže komprimovaný zdroj editoru, tabulku symbolů
i každý sestavený bajt, který nebyl zapsán na kazetu. PROMETHEUS proto potřebuje
způsob, jak uchovat nejen strojový kód, ale pracovní podobu projektu: záznamy
zdroje a jména, která těmto záznamům dávají význam.

Jeho nativní příkaz `SAVE` zapisuje obojí jako jediný payload typu Spectrum CODE.

Tato věta zní jednoduše. Implementace však musí vyřešit několik méně zjevných
problémů:

- zdroj a symboly zabírají dvě sousední, ale rozdílně strukturované oblasti;
- editor mezi nimi udržuje trvalé prázdné záznamy, které do uloženého programu
  nepatří;
- místo celého zdroje lze uložit vybraný blok;
- i blok stále potřebuje úplnou tabulku symbolů, aby bylo možné interpretovat
  jeho pořadová čísla;
- hlavička kazety Spectra zná celkovou délku v bajtech, ale nativní `LOAD` musí
  navíc vědět, kde končí část se zdrojem;
- `VERIFY` musí později porovnat přesně ty rozsahy paměti, které byly uloženy;
- ROM pro kazetu očekává určitý stav a časovou posloupnost.

Tato kapitola začne logickým balíkem viditelným programátorovi, sestoupí do
hlavičky a paměťové aritmetiky a potom se vrátí k celé cestě z paměti editoru na
kazetu.

## O co uživatel žádá

PROMETHEUS přijímá čtyři užitečné podoby:

```text
SAVE :name      ulož celý zdroj pod novým jménem
SAVE            ulož celý zdroj s použitím zapamatovaného jména
SAVE b:name     ulož vybraný blok pod novým jménem
SAVE b          ulož vybraný blok s použitím zapamatovaného jména
```

Parametr příkazu `b` znamená inkluzivní blok označený v editoru. Dvojtečka uvádí
jméno souboru o délce nejvýše deseti znaků.

Naposledy použité jméno se uchovává v:

```asm
fileNameBuffer:
    defb "prometheus"
```

Počáteční výchozí jméno je tedy `prometheus`. Nově zadané kratší jméno se doplní
mezerami na deset bajtů vyžadovaných kazetovou hlavičkou Spectra.

Tento malý trvalý buffer zpříjemňuje opakovanou práci s kazetou:

```text
SAVE :lesson1
VERIFY
SAVE
```

Poslední `SAVE` znovu použije `lesson1`, pokud mezitím jiný příkaz zapamatované
jméno nezměnil.

## Ukládaný objekt není sestavený program

Nativní cesta editorového SAVE uchovává:

```text
komprimované záznamy zdroje
úplnou současnou tabulku symbolů
```

Neznamená „ulož bajty vyslané při posledním sestavení“. Monitor má samostatné
příkazy pro libovolné bloky paměti a běžný formát CODE Spectra může obsahovat i
vygenerovaný kód. Zde nás zajímá projekt, který lze znovu načíst do editoru
PROMETHEA.

Toto rozlišení je zásadní. Obraz strojového kódu obsahuje dost informací ke
spuštění, ale nestačí ke spolehlivé obnově komentářů, labelů, expressionů,
direktiv a struktury editoru.

## Jeden logický balík, dvě aktivní oblasti

V paměti leží smysluplný zdroj pod tabulkou symbolů:

```text
sourceBufferAccessLine
    ... komprimované záznamy zdroje ...
    ... šest trvalých prázdných záznamů ...
varcSymbolTablePt
    počet symbolů
    vektory pořadových čísel
    záznamy hodnot a jmen
varcCodeEndPt
```

Dvanáct bajtů bezprostředně pod `varcSymbolTablePt` tvoří šest dvoubajtových
prázdných záznamů. Jsou konstrukční výplní editoru, nikoli částí uživatelova
programu.

SAVE celého zdroje proto zvolí:

```text
sourceStart = sourceBufferAccessLine
sourceEnd   = varcSymbolTablePt - 12
```

Rozsah je polouzavřený:

```text
[sourceStart, sourceEnd)
```

Tento zápis znamená, že první bajt je zahrnut a samotný `sourceEnd` nikoli. Délka
zdroje je jednoduše:

```text
sourceLength = sourceEnd - sourceStart
```

Kód používá hodnotu `$FFF4` v dvojkovém doplňku, tedy -12:

```asm
    ld hl,(varcSymbolTablePt+1)
    ld de,0fff4h
    add hl,de
    ld de,sourceBufferAccessLine
```

Aritmetika působí záhadně, dokud objekty nepojmenujeme:

```text
HL = exkluzivní konec smysluplného zdroje
DE = první smysluplný záznam zdroje
```

## Uložení inkluzivně vybraného bloku

Editor uchovává dva okraje bloku a oba koncové záznamy považuje za součást
výběru. Výstup na kazetu se snáze počítá jako bajtový interval s exkluzivním
koncem.

`getSelectedBlock` vrací normalizovaný první a poslední záznam. SAVE potom od
posledního záznamu jednou postoupí:

```asm
.selectSaveBlockRange:
    call getSelectedBlock
    ex de,hl
    call getNextSourceRecord
```

Po tomto převodu platí:

```text
DE = první vybraný záznam
HL = první bajt za posledním vybraným záznamem
```

Délka zdroje je opět `HL-DE`.

Tentýž vzor se objevoval v celém editoru:

```text
blok pro člověka       inkluzivní první a poslední záznam
interval pro paměť     polouzavřený [start,end)
```

Polouzavřená podoba se vyhýbá zvláštním případům. Prázdná délka je nula, sousední
rozsahy na sebe přesně navazují a prosté odečtení dává počet bajtů.

## Proč SAVE bloku stále zahrnuje všechny symboly

Vybraný blok může odkazovat na symboly definované mimo něj. Může také používat
pořadová čísla, jejichž identity patří úplné současné tabulce.

PROMETHEUS nevytváří zmenšenou tabulku sledováním závislostí pouze ve vybraných
záznamech. I `SAVE b` zapisuje celou tabulku symbolů.

Jde o rozumný kompromis osmdesátých let:

- SAVE zůstává kompaktní a rychlý;
- není potřeba dočasný graf závislostí;
- uložené záznamy mohou vždy vyřešit svá původní pořadová čísla;
- nepoužitá jména mohou zabrat trochu místa navíc na kazetě.

Pozdější cesta LOAD tato pořadová čísla nekopíruje přímo do aktivního zdroje.
Pomocí importované tabulky je převede zpět na jména, takže úplná tabulka je
bezpečná i při načtení do projektu s jiným pořadím čísel.

## Sedmnáctibajtová hlavička Spectra

PROMETHEUS sestavuje standardní kazetovou hlavičku Spectra v dolním řádku
obrazové paměti:

```asm
    ld ix,BOTTOM_LINE_VRAM_ADDRESS
    ld (ix+000h),003h
```

Typ 3 znamená CODE.

Pole použitá nativním SAVE zdroje jsou:

```text
offset  délka  význam
+0      1      typ = 3 (CODE)
+1      10     jméno souboru doplněné mezerami
+11     2      úplná délka payloadu
+13     2      běžný parametr CODE 1, nativní LOAD jej nepoužívá
+15     2      délka části zdroje PROMETHEA
```

Poslední pole je chytrým rozšířením. Standardní hlavička CODE má dvě parametrická
slova. PROMETHEUS využívá bajty 15 a 16 k zapamatování, kolik bajtů na začátku
dat patří komprimovanému zdroji.

Nativní LOAD pak může obnovit vnitřní rozdělení, aniž by prohledával záznamy nebo
spoléhal na pevnou adresu tabulky.

## Kopírování zapamatovaného jména souboru

Po volitelném zpracování dvojtečky se deset trvalých bajtů jména zkopíruje do
hlavičky:

```asm
.copySaveNameIntoCodeHeader:
    ld hl,fileNameBuffer
    ld de,BOTTOM_LINE_VRAM_ADDRESS+1
    ld bc,0000ah
    ldir
```

`readFileNameFromInput` přijme nejvýše deset logických vstupních znaků. Skončí-li
jméno dříve, doplní zbytek mezerami.

Trvalý buffer se nezmění jen proto, že byl zkopírován do kazetové hlavičky.
Zůstane k dispozici pro další SAVE nebo LOAD.

## Výpočet délky tabulky

Tabulka symbolů začíná na `varcSymbolTablePt` a spojená dynamická oblast končí na
`varcCodeEndPt`.

Délka tabulky v bajtech je:

```text
tableLength = varcCodeEndPt - varcSymbolTablePt
```

Zdroj provede odečtení, dočasně výsledek zvýší pro řetězený zapisovač, uloží tuto
pomocnou délku pro VERIFY a potom se při výpočtu úplného payloadu vrátí k běžné
délce tabulky.

Na logické úrovni si označme:

```text
S = sourceLength
T = tableLength
```

Ukládaný datový payload má podobu:

```text
bajty zdroje [S]
dvoubajtový můstek
bajty tabulky symbolů [T]
```

Úplná délka dat CODE tedy je:

```text
S + 2 + T
```

Hlavička dostane:

```text
bajty 11..12 = S + T + 2
bajty 15..16 = S
```

## Záhadný dvoubajtový můstek

Dva bajty mezi zdrojem a tabulkou nejsou záznamy zdroje a nejsou součástí báze
tabulky symbolů používané LOAD.

Zapisovač nejprve odešle segment zdroje přes běžný řídicí vstup ROM SAVE. Potom
zahájí kompaktní pokračování jeden bajt před aktivní tabulkou symbolů a vstoupí
do `ROM_SA_SET` se zvláštně připraveným stavem markeru.

Výsledný logický payload obsahuje před tabulkou dva můstkové bajty.

Rekonstruovaný zdroj jejich přítomnost dokazuje, protože:

- SAVE přičítá k celkové délce 2;
- LOAD počítá bázi importované tabulky jako `sourceEnd+2`;
- nativní záznamy končí na `sourceEnd` a tyto bajty nikdy nespotřebují.

Jejich jednotlivé role na úrovni průběhu signálu v řetězeném zapisovači ROM
nepotřebujeme k pochopení souborového formátu PROMETHEA. Opatrná rekonstrukce by
neměla vymýšlet názvy pro chování, které nebylo samostatně prokázáno.

Správný model pro tuto knihu je jednoduše:

```text
[source][dvoubajtový můstek][table]
```

## Zapamatování přesného SAVE pro VERIFY

VERIFY znovu nevypočítává aktuální rozsah zdroje. SAVE opraví čtyři pole uvnitř
pozdějších instrukcí:

```text
varcLastSavedSourceStart
varcLastSavedSourceLength
varcLastSavedSymbolTableStart
varcLastSavedAuxiliarySegmentLength
```

Zdroj zapisuje hodnoty přímo do operandů instrukcí:

```asm
    ld (varcLastSavedSourceStart+2),de
    ld (varcLastSavedSourceLength+1),hl
    ld (varcLastSavedSymbolTableStart+2),de
    ld (varcLastSavedAuxiliarySegmentLength+1),hl
```

Jde o další použití kódu jako trvalého stavu.

Proč si pamatovat skutečné adresy, a ne pouze jméno souboru a délky z hlavičky?
Protože VERIFY musí bajty na kazetě porovnat s přesnými paměťovými segmenty,
které byly zapsány:

```text
segment zdroje  může být vybraný blok, nikoli celý zdroj
segment tabulky začíná jinde a používá řetězený protokol
```

To také vysvětluje staré pravidlo z manuálu: VERIFY patří bezprostředně za SAVE.
Pokud editor nejprve změní zdroj nebo symboly, zapamatované rozsahy už nemusí
obsahovat uložené bajty.

## Výzva uživateli ke spuštění magnetofonu

Před zápisem hlavičky PROMETHEUS zobrazí stavovou zprávu `Start tape`.
`waitForKeyAndWriteTapeHeader` potom:

1. provede krátkou aktivní prodlevu;
2. čeká, dokud není stisknuta libovolná fyzická klávesa;
3. zavolá rutinu ROM SAVE se sedmnáctibajtovým blokem hlavičky;
4. provede druhou prodlevu před datovým blokem.

Čekání na klávesu čte klávesnicovou matici přímo:

```asm
.waitForTapeStartKey:
    xor a
    in a,(0feh)
    cpl
    and 01fh
    jr z,.waitForTapeStartKey
```

Aktivně nízké bity klávesnice se invertují, zamaskují a otestují. Nezáleží na
tom, která klávesa byla stisknuta; stisk znamená „magnetofon je připraven“.

Pro volání hlavičky platí:

```text
IX = adresa hlavičky
DE = 17
A  = 0, flag hlavičky
```

Datový blok následuje se standardním flagem `$FF`.

## Zápis dvou logických segmentů

Na vysoké úrovni se SAVE chová takto:

```text
vyber celý zdroj nebo označený blok
načti nebo znovu použij jméno souboru
sestav hlavičku CODE
zapamatuj rozsahy zdroje a tabulky pro VERIFY
zobraz Start tape
zapiš hlavičku
zapiš bajty zdroje
pokračuj zapisovačem přes můstek a tabulku symbolů
umožni přerušení klávesou SPACE
```

Skutečný zdroj kolem prvního zápisu dat je kompaktní:

```asm
    pop de
    pop ix
    ld a,0ffh
    call ROM_SaveControl_4c6
```

V této chvíli platí:

```text
IX = začátek vybraného zdroje
DE = délka zdroje
A  = datový flag $FF
```

Pokračování potom načte zapamatovanou pozici tabulky symbolů a pomocnou délku ze
samomodifikovaných operandů a vstoupí do nízkoúrovňové cesty marker/setup v ROM.

Neobvyklá posloupnost není ozdobnou chytrostí. Umožňuje, aby se dvě nesouvislé
aktivní oblasti paměti objevily jako jediný logický payload kazety, aniž by bylo
nejprve nutné obě zkopírovat do odděleného dočasného bufferu.

Šetří tím RAM — přesně ten prostředek, který se PROMETHEUS snaží zachovat.

## Příklad konkrétního rozložení

Představme si malý stav editoru:

```text
délka smysluplného uloženého zdroje S = 80 bajtů
délka tabulky symbolů T               = 46 bajtů
```

Hlavička uloží:

```text
sourceLength = 80
completeLength = 80 + 2 + 46 = 128
```

Datový blok na kazetě logicky obsahuje:

```text
offset 0..79    80 bajtů komprimovaného zdroje
offset 80..81   dvoubajtový můstek
offset 82..127  46 bajtů tabulky symbolů
```

LOAD může později umístit 128bajtový blok na libovolnou dočasnou adresu `P` a
odvodit:

```text
importedSourceStart = P
importedSourceEnd   = P + 80
importedTableBase   = P + 82
```

V datech není uložena žádná absolutní adresa zdroje ani tabulky. Potřebnou
strukturu poskytují délky v hlavičce.

## Uložený blok je fragment projektu, nikoli samostatná binárka

Předpokládejme, že vybraný blok obsahuje:

```asm
DRAW    CALL PIXEL
        RET
```

a `PIXEL` je definován jinde. Uložený blok stále obsahuje úplnou tabulku symbolů,
takže jeho záznam pro `CALL PIXEL` lze později expandovat.

Při načtení do jiného projektu se importované pořadové číslo pro `PIXEL`
nepovažuje za aktivní pořadové číslo. LOAD vyřeší importované jméno a nechá
běžný parser vytvořit nebo najít odpovídající současný symbol.

Formát SAVE je tedy přenosovou reprezentací sémantiky zdroje, nikoli příslibem,
že vnitřní offsety tabulky nebo pořadová čísla zůstanou navždy stejná.

## Přerušení a selhání

SPACE je společná klávesa pro přerušení kazetových operací. Helper
`abortCurrentOperationIfSpacePressed` zachová flags ROM, pokud SPACE držena není,
a při jejím stisku skočí zpět do editoru.

SAVE přerušené magnetofonem, kazetou nebo uživatelem může na pásce zanechat
nepoužitelný blok, ale nemusí vracet změny v paměti editoru: zdroj a symboly se
pouze četly, nebyly přesouvány ani měněny, kromě neškodných zapamatovaných
metadat pro VERIFY.

## V prostém pseudokódu

```text
function save(command):
    header.type = CODE

    blockMode = command obsahuje B
    if command obsahuje ':':
        retainedName = readAtMostTenCharactersAndPadWithSpaces()

    header.name = retainedName

    if blockMode:
        sourceStart = selectedBlock.firstRecord
        sourceEnd = adresaZa(selectedBlock.lastRecord)
    else:
        sourceStart = sourceBufferAccessLine
        sourceEnd = symbolTableStart - 12

    sourceLength = sourceEnd - sourceStart
    tableStart = symbolTableStart
    tableLength = codeEnd - tableStart

    header.totalLength = sourceLength + 2 + tableLength
    header.prometheusSourceLength = sourceLength

    rememberForVerify(
        sourceStart,
        sourceLength,
        tableStart,
        tableLengthAndWriterState
    )

    zobraz "Start tape"
    waitForAnyKey()
    romSave(header, 17, HEADER_FLAG)
    romSaveSourceThenChainBridgeAndTable(
        sourceStart,
        sourceLength,
        tableStart,
        tableLength
    )
```

## Co se změnilo v paměti

SAVE nepřeskupuje aktivní zdroj ani tabulku. Mění pouze dočasný a zapamatovaný
stav:

- dolní řádek bitmapy obsahuje pracovní sedmnáctibajtovou hlavičku CODE;
- `fileNameBuffer` může obsahovat nově zadané jméno doplněné mezerami;
- slovo celkové délky v hlavičce obsahuje `S+T+2`;
- poslední slovo hlavičky obsahuje `S`;
- čtyři samomodifikovaná pole si pamatují rozsahy zdroje a tabulky pro VERIFY;
- stav kazetové ROM dočasně ovládá časování, border a MIC;
- samotné bajty komprimovaného zdroje a tabulky symbolů zůstávají na místě.

## Důležité labely, které jsme potkali

- `invokeSave`
- `fileNameBuffer`
- `readFileNameWithColon`
- `readFileNameFromInput`
- `copyFileNameFromHLToDE`
- `getSelectedBlock`
- `getNextSourceRecord`
- `varcSymbolTablePt`
- `varcCodeEndPt`
- `varcLastSavedSourceStart`
- `varcLastSavedSourceLength`
- `varcLastSavedSymbolTableStart`
- `varcLastSavedAuxiliarySegmentLength`
- `waitForKeyAndWriteTapeHeader`
- `ROM_SaveControl_4c6`
- `ROM_SA_SET`
- `abortCurrentOperationIfSpacePressed`

## Zpět k celkovému obrazu

PROMETHEUS změnil dvě aktivní, rozdílně strukturované oblasti paměti v jeden
přenosný objekt:

```text
zdroj editoru
    + úplný význam symbolů
    + malý konstrukční můstek
    + délky ve standardní hlavičce CODE
    -> jeden datový blok na kazetě
```

Formát je kompaktní, protože nerozbaluje zdroj do textu a před uložením
nekopíruje projekt do mezilehlého balíku v RAM.

Příští kapitola sleduje opačný směr. LOAD však není zrcadlovým obrazem, který
slepě zkopíruje bajty domů. Balík nejprve umístí do horní paměti a každý
importovaný řádek znovu protáhne editorem, přičemž překládá jména a cestou
ověřuje syntaxi.
