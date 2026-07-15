# Kapitola 41: Kazetové nástroje monitoru

Kazetové příkazy editoru ukládají strukturovaný dokument PROMETHEA: komprimovaný
zdroj následovaný jeho tabulkou symbolů. Kazetové příkazy monitoru mají
primitivnější účel. Přesouvají libovolné bloky paměti.

Tento rozdíl je zásadní:

```text
editor SAVE / LOAD:
    rozumí záznamům zdroje a symbolům

monitor S / J / Y:
    rozumí adresám, délkám a kazetovým blokům Spectra
```

Monitor může uložit sestavený kód, obrazovou paměť, datovou tabulku nebo téměř
jakýkoli jiný rozsah bajtů. Dokáže načíst surový blok na zvolenou cílovou
adresu. Může také přečíst a zobrazit standardní hlavičku Spectra a teprve potom
se rozhodnout, zda načte následující datový blok.

Tyto příkazy jsou malými obálkami kolem kazetových rutin ROM Spectra, současně
však odhalují několik typických návyků PROMETHEA:

- inkluzivní rozsahy se převádějí až v posledním možném okamžiku;
- parametry se někdy uchovávají na stacku pod návratovou adresou;
- jeden prompt přijímá dva různé jazyky, číslo nebo `:filename`;
- standardní hlavička Spectra vzniká uvnitř již existujícího pracovního bufferu;
- bezpečnostní kontroly monitoru jsou záměrně užší než pozdější ochranný systém
  trasování.

## Dva způsoby popisu rozsahu

SAVE i LOAD mají po dvou klávesových variantách:

```text
First, Last
First, Length
```

První podoba již přímo vytváří inkluzivní rozsah. Druhá vypočítá:

```text
Last = First + Length - 1
```

Než se tedy příkaz dostane ke své kazetové koncovce, vypadají obě varianty
stejně:

```text
DE = First
HL = Last
```

ROM však očekává počáteční adresu a počet bajtů. PROMETHEUS odkládá převod až do
`prepareMonitorTapeBlockParameters`:

```text
length = Last - First + 1
IX = First
DE = length
A  = spodní bajt hodnoty Leader
```

Přehazování registrů v pomocné rutině působí neobvykle, protože First a Last
byly uloženy pod její návratovou adresou:

```asm
prepareMonitorTapeBlockParameters:
    ld a,l
    pop bc
    pop de
    pop hl
    push bc
    or a
    sbc hl,de
    inc hl
    ex de,hl
    push hl
    pop ix
    ret
```

Čtěme ji raději jako diagram stacku než instrukci po instrukci:

```text
před pomocnou rutinou:
    vrchol -> návrat z pomocné rutiny
              First
              Last

pomocná rutina dočasně odstraní návratovou adresu
pomocná rutina získá First a Last
pomocná rutina obnoví návratovou adresu
pomocná rutina převede inkluzivní rozsah na IX + length
```

Zadanou hodnotu Leader přežije pouze spodní bajt. Hodnota jako `$12FF` se tedy
chová přesně stejně jako `$FF`.

## Uložení surového bloku

Běžný příkaz S se zeptá na First, Last a Leader. SYMBOL SHIFT+S se zeptá na
First, Length a Leader.

Je-li Leader číselným expressionem, PROMETHEUS uloží **surový kazetový blok**.
Spodní bajt se stane příznakem kazetového bloku předaným ROM. Nevznikne žádná
hlavička Spectra ani filename.

Pojmově:

```text
zeptej se na rozsah
zeptej se na číselný Leader
převeď inkluzivní rozsah na počátek + délku
ulož blok rutinou ROM SAVE s tímto příznakem
```

To je užitečné pro soukromé kazetové formáty. Program si může například zvolit
příznak `$42` pro jeden druh bloku a `$43` pro jiný.

Příkaz skočí přímo do řídicí rutiny SAVE v ROM:

```asm
.writeMonitorBlockWithSelectedLeader:
    call prepareMonitorTapeBlockParameters
    jp ROM_SaveControl_4c6
```

Nevrací se přes žádnou stavovou obálku PROMETHEA. Jakmile se skok provede,
konečné chování kazety a hlášení chyb přebírá ROM Spectra.

## Uložení standardního bloku CODE

Prompt Leader rozumí i druhému jazyku. Začíná-li odpověď dvojtečkou, například:

```text
:ROUTINE
```

PROMETHEUS sestaví běžnou sedmnáctibajtovou hlavičku CODE Spectra.

Její pole jsou:

```text
+0       type = 3, tedy CODE
+1..10   filename, doplněný nebo zkrácený na deset znaků
+11..12  délka dat
+13..14  parametr 1 = adresa First
+15..16  parametr 2 = v běžné cestě nula
```

Pracovní prostor není samostatně alokovaným kazetovým objektem. Je to pojmenovaný
pohled na `commandArgumentBuffer`:

```asm
commandArgumentBuffer:
    defb 000h
monitorTapeHeaderFileName:
    defs 10
monitorTapeHeaderDataLength:
    defw 0
monitorTapeHeaderParameter1:
    defs 6
```

Posledních šest bajtů obsahuje parametr 1, parametr 2 a přilehlý pracovní
prostor. Cesta SAVE výslovně uloží parametr 1 a délku dat. Parametr 2 je za
běžných okolností nulový, protože sdílená inicializace promptu vyčistila pracovní
buffer dříve, než byl zpracován `:filename`.

Příkaz potom:

1. počká, až uživatel spustí kazetu;
2. zapíše blok hlavičky s příznakem `$00`;
3. změní Leader na `$FF`;
4. zapíše zvolenou paměť jako standardní datový blok.

Jde o známou dvojici Spectra:

```text
blok hlavičky s příznakem $00
datový blok CODE s příznakem $FF
```

Načítací adresou v hlavičce je zvolená adresa First. Pozdější standardní loader
tak může zjistit, kam bajty původně patřily.

## Záměrná absence ochrany při SAVE

Monitorový SAVE nevolá kontrolu rezidentního rozsahu. Neodmítne ani obrácený
rozsah.

Tento vstup:

```text
First = $9000
Last  = $8FFF
```

se proto neohlásí jako prázdný. Šestnáctibitové odčítání přeteče:

```text
Last - First + 1 = $0000
```

Co ROM s takovou délkou udělá, patří k původnímu chování. Monitor předpokládá,
že uživatel ví, jakou paměť čte.

Zapadá to do širšího rozlišení:

- čtení paměti důvěryhodným příkazem monitoru je permisivní;
- zápis do rezidentní oblasti PROMETHEA je chráněn;
- spuštění neznámého kódu podléhá nejsilnějším, konfigurovatelným kontrolám.

Program neuplatňuje jednu univerzální ochrannou politiku na každý příkaz.

## Načtení surového bloku

J se zeptá na First, Last a číselný Leader. SYMBOL SHIFT+J se zeptá na First,
Length a číselný Leader.

Na rozdíl od SAVE volá LOAD nejprve `preserveBlockRangeAndCheckResidentWrite`.
Tato rutina odmítne:

- obrácený nebo přetečený cílový rozsah;
- jakýkoli cíl protínající rezidentní PROMETHEUS, zdroj nebo symboly.

Nekonzultuje však pět editovatelných oken WRITE popsaných v kapitole 38. Tato
okna řídí trasované uživatelské instrukce, nikoli tento důvěryhodný příkaz
monitoru.

Po kontrole rozsahu se příkaz zeptá na Leader, převede parametry a se zapnutým
carry zavolá sdílený loader ROM:

```asm
.readMonitorBlockWithSelectedLeader:
    call prepareMonitorTapeBlockParameters
    scf
    call callRomTapeLoadOrVerify
    ret c
    jp showMonitorReadWriteError
```

Surové načtení očekává přesně:

- požadovaný příznak bloku;
- požadovanou délku;
- platnou paritu kazetového bloku.

Nehledá dopředu hlavičku ani filename. První vhodný fyzický blok musí být právě
ten, který uživatel zamýšlí načíst.

PROMETHEUS zobrazí stejné `Read/Write ERROR` pro chráněný cíl i pro selhání
kazetové rutiny ROM. Rozhraní se nepokouší o podrobnou diagnózu.

## Proč `:filename` nedává u J smysl

`promptForMonitorValue` rozumí vstupu s dvojtečkou, protože jej sdílí se SAVE.
Handler J však žádnou větev pro filename nemá. Kdyby uživatel zadal vstup s
dvojtečkou, spodní bajt vráceného ukazatele na buffer by se omylem stal
očekávanou hodnotou Leader.

Smysluplné rozhraní proto přijímá pouze číselný Leader.

To je užitečné poučení z rekonstrukce: sdílený parser může přijímat více forem,
než pro které má konkrétní volající sémantickou obsluhu. Skutečný jazyk příkazu
určuje volající, nikoli samotný parser.

## Čtení hlavičky nebo leaderu příkazem Y

Příkaz Y je inspektorem, nikoli běžným loaderem bloku. Načte osmnáct bajtů do
`inputBufferStart`:

```text
+0       fyzický příznak kazetového bloku
+1       typ hlavičky Spectra
+2..11   filename
+12..13  délka dat
+14..15  parametr 1
+16..17  parametr 2
```

Proč osmnáct, když payload hlavičky Spectra měří sedmnáct bajtů? Běžná obálka
ROM spotřebuje příznak odděleně. Y volá ROM příměji, takže fyzický příznak
zůstane v paměti před sedmnácti bajty hlavičky.

Příprava vypadá takto:

```asm
monReadTapeHeaderOrLeader:
    call beginMonitorListOutputWithBlankLine
    ld ix,inputBufferStart
    ld de,00012h
    xor a
    scf
    ex af,af'
    ld a,00fh
    out (0feh),a
    call ROM_LoadBytes_562
```

Očekávaný příznak `$00` a režim LOAD se přesunou do alternativního akumulátoru,
jak to vyžaduje kazetová rutina ROM.

Mohou nastat dva výsledky.

### Byla přečtena platná hlavička

Monitor vytvoří jeden řádek okna seznamu obsahující:

```text
type  filename  parameter1  length  parameter2
```

Tři slova se zobrazí v právě aktivním desítkovém nebo šestnáctkovém režimu
monitoru. Řídicí znaky ve filename se změní na `?`. Bajty od `$20` výše se
kopírují beze změny, i když mají nastaven bit 7.

Uživatel potom stiskne klávesu. Je-li to J, PROMETHEUS vyloží hlavičku jako popis
cíle ve stylu CODE:

```text
First  = parametr 1
Length = délka dat
Last   = First + Length - 1
Leader = $FF
```

Cíl porovná s rezidentní pamětí a načte bezprostředně následující standardní
datový blok.

Jiná klávesa se po zobrazení hlavičky vrátí do monitoru.

### Blok nebyl platnou hlavičkou `$00`

ROM ponechá carry vynulované, první fyzický příznak bloku však zůstane v
`inputBufferStart`. PROMETHEUS zobrazí tuto jedinou hodnotu v aktivní číselné
soustavě.

Nemůže nabídnout automatické následné načtení, protože surový leader neříká:

- kam se mají data uložit;
- jak dlouhý blok je.

Y je tedy doslova čtečkou **hlavičky nebo leaderu**.

## Zobrazení hlavičky a následné načtení

Úspěšná větev pro hlavičku při vykreslování pečlivě uchová dvě hodnoty:

```asm
    ld hl,(loadedTapeHeaderParameter1)
    push hl
    ... print parameter 1 ...
    ld hl,(loadedTapeHeaderDataLength)
    push hl
    ... print length ...
```

Po `readKeyCode` získá zpět length a First:

```asm
    pop hl
    pop de
    cp 06ah
    ret nz
    add hl,de
    dec hl
```

Nyní platí `DE=First` a `HL=Last`, tedy přesně ta podoba rozsahu, kterou očekává
koncovka surového LOAD. Provede kontrolu cíle, zvolí příznak `$FF` a připojí se
k `.readMonitorBlockWithSelectedLeader`.

Jde o úsporné opětovné použití kódu:

```text
Y přečte a zobrazí hlavičku
if uživatel stiskne J:
    převeď pole hlavičky na běžný rozsah LOAD
    připoj se ke stejné chráněné koncovce surového načítání
```

## Kontrakt sdíleného loaderu ROM

`callRomTapeLoadOrVerify` používají také editorové příkazy LOAD a VERIFY. Jeho
vstupy jsou:

```text
IX = cílová nebo porovnávaná adresa
DE = délka
A  = očekávaný příznak bloku
carry set   -> LOAD
carry clear -> VERIFY
```

Obálka:

- přesune příznak a režim do `AF'` pro ROM;
- zakáže přerušení;
- připraví port `$FE`;
- zavolá ROM LD-BYTES;
- zachová carry výsledku ROM, pokud uživatel nestiskne SPACE.

Monitorové cesty J a následného načtení z Y vždy volí LOAD. Editorový VERIFY
volí druhý stav carry.

Jeden nízkoúrovňový mechanismus tak znovu podporuje několik uživatelských
příkazů.

## Praktický příklad

Předpokládejme, že sestavená rutina zabírá adresy `$8000` až `$80FF`.

### Uložení jako standardní soubor CODE

```text
S
First:  $8000
Last:   $80FF
Leader: :ROUTINE
```

PROMETHEUS zapíše:

```text
hlavička:
    type       3
    name       ROUTINE
    length     256
    parameter1 $8000
    parameter2 0

data:
    flag       $FF
    bytes      memory[$8000..$80FF]
```

### Prohlédnutí a opětovné načtení

Y přečte hlavičku a zobrazí její pole. Stiskne-li uživatel bezprostředně potom J,
načte následující blok `$FF` zpět na `$8000`, pokud tento rozsah nyní neprotíná
rezidentní PROMETHEUS.

### Uložení soukromého surového bloku

```text
S
First:  $8000
Last:   $80FF
Leader: $42
```

Zapíše se pouze datový blok s příznakem `$42`. Znovu jej načteme příkazem J se
stejným rozsahem a hodnotou Leader `$42`.

## Co se změnilo v paměti

Podle konkrétního příkazu:

- First a Last se dočasně uchovají na soukromém stacku monitoru;
- `commandArgumentBuffer` může obsahovat vytvořenou hlavičku CODE;
- `monitorTapeHeaderDataLength` a `monitorTapeHeaderParameter1` dostanou metadata
  rozsahu;
- `inputBufferStart` může obsahovat zachovaný příznak a sedmnáctibajtovou
  hlavičku;
- `lineBuffer` dostane zobrazovanou hlavičku nebo leader;
- úspěšný LOAD přepíše požadovaný cílový rozsah;
- současná adresa monitoru a stav uložených registrů se jinak nezmění.

## Důležité labely, se kterými jsme se setkali

- `monSaveBlockFirstLast`
- `monSaveBlockFirstLength`
- `.saveMonitorBlockAfterRangePrompt`
- `.writeMonitorBlockWithSelectedLeader`
- `prepareMonitorTapeBlockParameters`
- `commandArgumentBuffer`
- `monitorTapeHeaderFileName`
- `monitorTapeHeaderDataLength`
- `monitorTapeHeaderParameter1`
- `waitForKeyAndWriteTapeHeader`
- `monLoadBlockFirstLast`
- `monLoadBlockFirstLength`
- `preserveBlockRangeAndCheckResidentWrite`
- `.readMonitorBlockWithSelectedLeader`
- `callRomTapeLoadOrVerify`
- `monReadTapeHeaderOrLeader`
- `loadedTapeHeaderDataLength`
- `loadedTapeHeaderParameter1`
- `loadedTapeHeaderParameter2`
- `showMonitorReadWriteError`

## Myšlenky, které budeme potřebovat později

- Monitor záměrně rozlišuje důvěryhodné operace od trasovaného spuštění
  uživatelského kódu.
- Carry často volí provozní režim, aniž by bylo třeba dalšího vstupního bodu.
- Pracovní buffery se opakovaně reinterpretují jako dočasná strukturovaná data.
- Kapitoly o instalátoru a finálním TAP se k hlavičce Spectra a formátům
  fyzických kazetových bloků vrátí z jiného směru.
