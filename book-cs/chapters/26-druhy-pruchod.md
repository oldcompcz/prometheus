# Kapitola 26: Druhý průchod

Na začátku druhého průchodu PROMETHEUS záměrně zapomene, kde první průchod
skončil.

Logická adresa a fyzický ukazatel výstupu se vrátí na společnou výchozí hodnotu
těsně nad zdrojem a symboly. Scan zdroje se vrátí k prvnímu záznamu. `ORG`,
`PUT` a `DEFS` se budou interpretovat znovu.

Co však nezmizí, je mapa adres vytvořená v prvním průchodu. Vybrané labely nyní
nesou bit 6 DEFINED a jejich záznamy symbolů obsahují konečné hodnoty.

Druhý průchod tedy vidí tentýž zdroj za jiných podmínek:

```text
stejné záznamy
stejné pořadí
stejné počáteční ukazatele
stejné direktivy řídící adresy
ale nyní je dostupná hodnota každého běžného labelu
```

Jeho úkolem je změnit tento stabilní význam v bajty.

## Jeden handler pro strojové a pseudo záznamy

`secondPassEmitSourceRecord` začíná informačním bajtem záznamu:

```asm
secondPassEmitSourceRecord:
    ld b,(ix+001h)
    ld a,b
    and 030h
    cp 030h
    jr z,.executePseudoInstructionSecondPass
```

V běžných strojových záznamech popisují bity 5 a 4 rodiny prefixů DD a FD.
Kombinace `$30` je vyhrazena jako namespace pseudo-instrukcí, takže slouží jako
rychlé rozlišení:

```text
DD i FD jsou označeny → interpretuj bajt 0 jako pseudo-opcode
jinak                 → vyšle strojovou instrukci
```

Parser zaručil platnost záznamu už při jeho vložení. Druhý průchod se tedy může
soustředit na kódování, nikoli na pravopis nebo gramatiku.

## Společný emitter instrukcí

U běžné instrukce zapisuje `emitMachineInstructionBytes` části v pevném pořadí:

```text
volitelný DD
volitelný FD
volitelný CB
volitelný ED
uložený opcode
bajty operandu vybrané třídou
```

Úsek zdroje je přímočarý:

```asm
emitMachineInstructionBytes:
    ld a,0ddh
    bit 5,b
    call nz,emitByteAtAssemblyOutput
    ld a,0fdh
    bit 4,b
    call nz,emitByteAtAssemblyOutput
    ld a,0cbh
    bit 7,b
    call nz,emitByteAtAssemblyOutput
    ld a,0edh
    bit 6,b
    call nz,emitByteAtAssemblyOutput
    ld a,(ix+000h)
    call emitByteAtAssemblyOutput
```

Ve správně zakódovaném zdroji existují pouze platné kombinace. Emitter
nepotřebuje velký strom určující, která mnemonika dovolují který prefix. Toto
rozhodnutí bylo zachyceno v záznamu tabulky instrukcí už při zadání zdroje.

Každý prefix i opcode prochází týmž chráněným zapisovačem bajtů. Instrukce, která
překročí neplatnou hranici, je proto odmítnuta přesně u bajtu, kde se stane
nebezpečnou.

## Přeskočení řádkového labelu

Volitelné pořadové číslo řádkového labelu je součástí trvalého payloadu záznamu,
není však operandem. Před vyhodnocením expressionu emitter volá:

```asm
    call skipEncodedLineLabelIfPresent
```

Je-li nastaven informační bit 3, posune se `IX` o dva bajty. Jinak zůstane u
hlavičky záznamu.

Evaluator expressionu vždy čte svůj první bajt na `IX+2`, takže mu tato malá
úprava poskytne jednotný pohled:

```text
IX+2 = první bajt operandu
```

bez ohledu na to, zda řádek zdroje zároveň definoval label.

## Třídy operandů jsou recepty pro vysílání

Tři spodní informační bity vybírají jeden ze sedmi receptů:

| Třída | Význam | Bajty za opcodem |
|---|---|---|
| 0 | bez operandu | žádné |
| 1 | immediate bajt | jeden zkontrolovaný bajt |
| 2 | absolutní slovo | low bajt, high bajt |
| 3 | relativní cíl | vypočtený podepsaný displacement |
| 4 | displacement IX/IY | jeden podepsaný bajt |
| 5 | displacement IX/IY plus immediate | podepsaný bajt, zkontrolovaný bajt |
| 6 | vektor RST | složený do již vyslaného opcodu |

Třída není totéž co textová kategorie operandu z kapitoly 21. Je to konečné
chování při vysílání bajtů uložené v záznamu zdroje.

U každé nenulové třídy se zakódovaný expression vyhodnotí do `BC`. Třída potom
určí, jak se tato hodnota zapíše.

## Třída 1: široké bajtové pravidlo PROMETHEA

Jednobajtová hodnota se přijme, je-li high bajt buď `$00`, nebo `$FF`:

```asm
validateAndEmitImmediateByte:
    ld a,b
    inc a
    and 0feh
    jr nz,.reportAssemblyBigNumber
    ld a,c
```

Tím jsou povoleny rozsahy:

```text
$0000..$00FF
$FF00..$FFFF
```

a vysílá se low bajt.

Druhý rozsah představuje záporné hodnoty od -256 do -1 v šestnáctibitovém
dvojkovém doplňku. Je širší než běžný rozsah podepsaného bajtu. Oba následující
řádky tedy mohou vytvořit `$FF`:

```asm
        DEFB 255
        DEFB -1
```

hodnota jako `$0100` je však odmítnuta chybou `Big number`.

Test je kompaktní: po zvýšení high bajtu a maskování `$FE` zůstane nula pouze pro
původní hodnoty `$00` a `$FF`.

## Třída 2: slova v pořadí little-endian

Slovo v `BC` se vysílá nejprve low bajtem:

```asm
emitWordBCAtAssemblyOutput:
    ld a,c
    call emitByteAtAssemblyOutput
    ld a,b
    jr emitByteAtAssemblyOutput
```

Jde o standardní pořadí little-endian procesoru Z80.

Pro:

```asm
        LD HL,$1234
```

odpovídající záznam instrukce vyšle:

```text
21 34 12
```

Opcode přišel první. Za ním následuje slovo operandu jako low `$34`, high `$12`.

Tentýž helper používá `DEFW`, takže operandy instrukcí i explicitní slovní data
dodržují přesně stejné pořadí bajtů a stejnou ochranu výstupu.

## Třída 3: absolutní expression se změní na relativní bajt

Záznamy zdroje uchovávají cíl relativního skoku jako absolutní expression.
Druhý průchod jej převede poté, co prefixy a opcode už posunuly čítač logické
adresy.

Potřebný vzorec je:

```text
displacement = target - addressAfterCompleteInstruction
```

Ve větvi třídy 3 ukazuje logický čítač těsně za opcode. Kód zvýší jeho dočasnou
kopii ještě o jedna, aby zahrnul bajt displacementu, a potom odečte tento
programový čítač za celou instrukcí od cíle.

Implementace používá elegantní výměnu přes zásobník k přeuspořádání hodnot:

```asm
    ld hl,(varcAddressCounter+1)
    inc hl
    push bc
    ex (sp),hl
    pop bc
    and a
    sbc hl,bc
```

Po výměně a `POP` drží `HL` cíl a `BC` adresu za úplnou instrukcí. `SBC HL,BC`
vytvoří podepsaný rozdíl.

Výsledek je platný pouze v rozsahu:

```text
-128..127
```

nebo jako šestnáctibitové bitové vzory:

```text
$FF80..$FFFF nebo $0000..$007F
```

Cokoli jiného vyvolá `Big number`.

V našem průběžném příkladu:

```asm
LOOP    DJNZ LOOP
```

předpokládejme, že `LOOP` je `$8002`. Po vyslání opcodu `$10` je logický čítač
`$8003`. Po přidání bajtu displacementu dostaneme `$8004`:

```text
$8002 - $8004 = -2 = $FE
```

Vyslaná instrukce je:

```text
10 FE
```

## Třída 4: podepsaný indexový displacement

Expression v `(IX+d)` nebo `(IY+d)` se vyhodnotí jako šestnáctibitová hodnota,
přesune se do `HL` a zkontroluje stejným validátorem podepsaného bajtu, jaký
používají relativní skoky.

Platné jsou hodnoty -128 až 127. Vysílá se low bajt.

Zdroj může obsahovat:

```asm
        LD A,(IX-3)
```

Evaluator expressionu vrátí `$FFFD`; validátor podepsaného bajtu jej přijme a
vyšle `$FD`.

Toto opětovné použití je možné, protože relativní skoky i indexované adresování
potřebují přesně stejný konečný rozsah podepsaného bajtu, přestože se jejich
hodnoty počítají jinak.

## Třída 5: displacement a immediate bajt

Některé indexované tvary vyžadují dva expressiony, například:

```asm
        LD (IX+5),17
```

Zakódovaný záznam zdroje je uchovává oddělené interním oddělovačem expressionů
představeným v kapitole 13.

Emitter:

1. zkontroluje a zapíše podepsaný displacement;
2. posune `IX` k následujícímu zakódovanému expressionu;
3. vyhodnotí immediate;
4. zkontroluje jej širokým jednobajtovým pravidlem;
5. vyšle jej.

Instrukce se změní na:

```text
DD 36 05 11
```

kde `$11` je desítkové číslo 17.

## Třída 6: složení vektoru RST do opcodu

`RST` je neobvyklé tím, že jeho zdánlivý operand je zakódován přímo v opcodu.
Povolené vektory jsou:

```text
0, 8, 16, 24, 32, 40, 48, 56
```

PROMETHEUS nejprve vyšle základní opcode z tabulky instrukcí. Potom zkontroluje
expression:

- high bajt musí být nula;
- tři spodní bity musí být nulové;
- bity 6 a 7 musí být nulové.

Je-li hodnota platná, přičte se vektor k právě vyslanému bajtu:

```asm
    ld hl,(varcAssemblyOutputPointer+1)
    dec hl
    add a,(hl)
    ld (hl),a
```

Druhý výstupní bajt není potřeba. Emitter upraví svůj vlastní nejnovější
výsledek.

Neplatný vektor se hlásí jako `Bad instruction`, nikoli `Big number`, protože
problémem není velikost, ale neexistence požadovaného tvaru RST.

## Problém pořadí bajtů indexovaných instrukcí CB

Většina instrukcí odpovídá společnému pořadí:

```text
prefixy, opcode, bajty operandu
```

Indexované rotační a bitové instrukce nikoli. Z80 je kóduje takto:

```text
DD/FD, CB, displacement, opcode operace
```

Společná struktura záznamu však přirozeně vysílá:

```text
DD/FD, CB, opcode operace, displacement
```

PROMETHEUS se vyhne samostatnému úplnému emitteru. `secondPassEmitSourceRecord`
rozpozná rodinu indexed-CB z informačních bitů, zavolá společný emitter a potom
v paměti prohodí poslední dva bajty:

```asm
    call emitMachineInstructionBytes
    ld hl,(varcAssemblyOutputPointer+1)
    dec hl
    ld a,(hl)
    dec hl
    ld b,(hl)
    ld (hl),a
    inc hl
    ld (hl),b
```

Například dočasné společné pořadí:

```text
DD CB 46 05
```

se opraví na:

```text
DD CB 05 46
```

Tato drobná oprava zvládá nepohodlné kódování Z80, zatímco téměř všechno ostatní
může zůstat na jediné obecné cestě vysílání.

## Chráněný zapisovač bajtů

Každý skutečně vytvořený bajt prochází rutinou `emitByteAtAssemblyOutput`.

Tato rutina vlastní dva kusy stavu uložené v operandech instrukcí:

```asm
varcAssemblyOutputPointer:
    ld hl,00000h

varcAddressCounter:
    ld hl,00000h
```

Před zápisem porovná fyzický cíl se třemi hranicemi. Vytvořený výstup je povolen,
pokud leží:

1. pod relokovaným residentním obrazem PROMETHEA; nebo
2. přísně nad současným koncem residentní části, zdroje a symbolů;
3. a současně ne nad U-TOP.

Odmítne se zápis, který by přepsal:

- residentní aplikaci;
- komprimovaný zdroj;
- tabulku symbolů;
- chráněnou horní oblast.

Kontrola probíhá pro každý jednotlivý bajt. Instrukce začínající na platném místě,
ale překračující do chráněné paměti selže u prvního zakázaného bajtu.

Při úspěchu:

```text
memory[outputPointer] = byte
outputPointer += 1
logicalAddress += 1
```

Logický čítač se posouvá i tehdy, když `PUT` oddělil fyzický cíl od logické
adresy.

## Logická adresa a fyzický cíl

Rozdíl je nejlépe vidět na příkladu:

```asm
        ORG 40000
        PUT 50000
START   LD HL,START
```

Po `ORG`:

```text
logicalAddress = 40000
outputPointer  = 40000
```

Po `PUT`:

```text
logicalAddress = 40000
outputPointer  = 50000
```

`START` se definuje jako 40000. Bajty `LD HL,START` se fyzicky zapíší na 50000,
jejich operand však obsahuje 40000.

Po tříbajtové instrukci:

```text
logicalAddress = 40003
outputPointer  = 50003
```

`PUT` tedy dovoluje sestavit kód pro jednu adresu, ale uložit jej na jinou. Je to
mocná možnost, program však tento kód později automaticky nepřesune na jeho
logickou adresu. Uživatel musí mít důvod k vytvoření tohoto oddělení.

## Proč ochrana výstupu patří do zapisovače bajtů

PROMETHEUS mohl před vysláním zkontrolovat celý rozsah instrukce. To by však
vyžadovalo, aby každý volající vypočítal její velikost a opakoval stejnou logiku
hranic.

Místo toho stojí u brány jediná rutina.

Přináší to několik výhod:

- kontrolují se prefixy i opcody;
- kontrolují se immediate bajty;
- kontrolují se data `DEFB`, `DEFM` a `DEFW`;
- kontroluje se assembler oprav monitoru;
- překročení hranice se zachytí i uprostřed položky;
- všechny neplatné cíle hlásí stejnou chybu `Bad PUT (ORG)`.

Návrh je pomalejší než nekontrolované zápisy, sestavení je však interaktivní
úloha, nikoli real-time vnitřní smyčka. Bezpečnost a kompaktnost jsou důležitější.

## Chyby se vracejí k původnímu záznamu zdroje

Selže-li kontrola rozsahu bajtu, relativního displacementu nebo ochrany výstupu,
dorazí chybová cesta nakonec k `reportAssemblyErrorAtSourceRecord`.

Controller opravil tuto rutinu adresou současného záznamu ještě před voláním
handleru. Editor tedy může znovu zobrazit přesný řádek, který selhal.

Příklady:

- immediate příliš velké pro svou třídu;
- relativní cíl vzdálenější než 127 bajtů dopředu nebo 128 bajtů dozadu;
- indexový displacement mimo -128..127;
- neplatný vektor RST;
- ukazatel výstupu uvnitř PROMETHEA nebo nad U-TOP;
- nevyřešený symbol nalezený evaluatorem expressionu.

Hluboký emitter nemusí nic vědět o okně zdroje. Pouze zvolí číslo chyby.

## Jednořádkový assembler monitoru používá stejný mechanismus

Interaktivní assembler monitoru nemá vlastní encoder instrukcí.

Změní jeden zadaný řádek na běžný komprimovaný formát záznamu a potom zavolá:

```asm
    call initializeMonitorLineAssembler
    call firstPassProcessSourceRecord
    call initializeMonitorLineAssembler
    call secondPassEmitSourceRecord
```

První inicializace poskytne adresu monitoru jako logický i fyzický origin.
První průchod definuje případný řádkový label nebo stav `EQU` a předpoví velikost.
Druhá inicializace vrátí stejný origin a běžný emitter druhého průchodu zapíše
bajty přes stejnou ochrannou bránu.

Vylepšení nebo opravy centrálního assembleru se tedy vztahují také na
jednořádkovou sestavovací funkci monitoru.

## Pokračování průběžného příkladu

Po kapitole 25 vypadá mapa symbolů takto:

```text
START = $8000
LOOP  = $8002
```

Druhý průchod znovu přehraje:

```asm
        ORG 32768
START   LD B,5
LOOP    DJNZ LOOP
        RET
        ENT START
```

Kroky jsou:

1. `ORG 32768` nastaví oba ukazatele na `$8000`.
2. `LD B,5` vyšle `$06,$05`; ukazatele se změní na `$8002`.
3. `DJNZ LOOP` vyšle `$10`; vypočítá `$8002-$8004=-2`; vyšle `$FE`; ukazatele
   se změní na `$8004`.
4. `RET` vyšle `$C9`; ukazatele se změní na `$8005`.
5. `ENT START` vyhodnotí `$8000` a uloží jej jako cíl RUN.

Konečné bajty jsou:

```text
adresa   bajty     zdroj
$8000    06 05     LD B,5
$8002    10 FE     DJNZ LOOP
$8004    C9        RET
```

Předpovědi prvního průchodu a fyzické účinky druhého se shodují.

## V prostém pseudokódu

```text
function secondPass(record):
    if record je pseudoInstruction:
        executePseudoInstructionSecondPass(record)
        return

    info = record.info

    if info požaduje DD: emitByte($DD)
    if info požaduje FD: emitByte($FD)
    if info požaduje CB: emitByte($CB)
    if info požaduje ED: emitByte($ED)

    emitByte(record.opcode)
    skipOptionalLineLabel(record)

    class = info.operandEmissionClass
    if class == 0:
        return

    value = evaluate(record.firstExpression)

    switch class:
        case 1:
            emitCheckedBroadByte(value)

        case 2:
            emitByte(low(value))
            emitByte(high(value))

        case 3:
            displacement = value - (logicalAddress + 1)
            emitCheckedSignedByte(displacement)

        case 4:
            emitCheckedSignedByte(value)

        case 5:
            emitCheckedSignedByte(value)
            immediate = evaluate(record.secondExpression)
            emitCheckedBroadByte(immediate)

        case 6:
            require value in {0,8,16,24,32,40,48,56}
            mostRecentlyEmittedOpcode += value

    if instruction patří do indexedCBFamily:
        swap lastTwoEmittedBytes()
```

Společný zapisovač bajtů:

```text
function emitByte(value):
    destination = outputPointer

    if destination neleží pod residentStart:
        if destination <= codeEnd:
            error "Bad PUT (ORG)"

    if destination > UTop:
        error "Bad PUT (ORG)"

    memory[destination] = low(value)
    outputPointer += 1
    logicalAddress += 1
```

## Co se změnilo v paměti

Po úspěšném druhém průchodu:

- vytvořené instrukce a data zabírají své vybrané fyzické výstupní rozsahy;
- `varcAssemblyOutputPointer+1` ukazuje těsně za konečný fyzický výstup;
- `varcAddressCounter+1` obsahuje konečnou logickou adresu;
- relativní a indexové displacementy byly zkontrolovány na rozsah a zakódovány;
- slovní hodnoty byly zapsány v pořadí little-endian;
- u tvarů indexed-CB bylo opraveno konečné pořadí bajtů;
- `ENT`, pokud se vyskytlo, opravilo cíl RUN;
- tabulka symbolů stále obsahuje hodnoty vytvořené prvním průchodem;
- původní komprimovaný zdroj zůstal beze změny.

## Důležité labely, na které jsme narazili

- `secondPassEmitSourceRecord`
- `.executePseudoInstructionSecondPass`
- `emitMachineInstructionBytes`
- `validateAndEmitImmediateByte`
- `emitWordBCAtAssemblyOutput`
- `.validateSignedByteInHLAndEmitL`
- `validateAndEmitSignedBC`
- `.foldRstVectorIntoEmittedOpcode`
- `emitByteAtAssemblyOutput`
- `varcAssemblyOutputPointer`
- `varcAddressCounter`
- `varcUTop`
- `reportAssemblyErrorAtSourceRecord`
- `assembleMonitorInputLine`
- `initializeMonitorLineAssembler`

## Zpět k celkovému obrazu

Oba průchody nyní tvoří sladěnou dvojici:

```text
první průchod se ptá: kolik prostoru a jaké adresy?
druhý průchod se ptá: které přesné bajty a kam je dovoleno je zapsat?
```

Tentýž kompaktní záznam podporuje obě otázky. První průchod čte jeho tvar; druhý
uskutečňuje jeho obsah.

Strojové instrukce však tvoří pouze polovinu jazyka assembleru. Programy také
potřebují volit originy, rezervovat paměť, definovat konstanty, ukládat doslovné
bajty a vybírat vstupní bod. Kapitola 27 shromáždí tyto pseudo-instrukce do
jednoho souvislého systému a ukáže, jak se každá z nich účastní jednoho nebo
obou průchodů.
