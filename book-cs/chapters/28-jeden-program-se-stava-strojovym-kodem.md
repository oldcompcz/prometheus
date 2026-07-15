# Kapitola 28: Jeden program se stává strojovým kódem

Devět kapitol jsme assembler rozebírali na zvládnutelné části. Víme, jak
PROMETHEUS rozpoznává slova, třídí operandy, ukládá expressiony, vytváří symboly,
předpovídá adresy a vysílá bajty. Je čas tyto části znovu složit dohromady.

Vrátíme se k malému programu uvedenému na začátku knihy:

```asm
        ORG 32768
START   LD B,5
LOOP    DJNZ LOOP
        RET
        ENT START
```

Program je dost malý, abychom se v něm neztratili, ale přitom prochází téměř
každou důležitou vrstvou assembleru:

- pseudo-instrukcí nastavující origin;
- dvěma definicemi symbolů;
- pevným registrovým operandem;
- immediate expressionem;
- relativním skokem na symbol;
- instrukcí bez operandu;
- expressionem `ENT`, který připraví `RUN`.

Program v této kapitole projdeme třikrát.

Nejprve se na něj podíváme shora a řekneme si, co se musí stát. Potom podrobně
projdeme záznamy, symboly a oba průchody. Nakonec se znovu vrátíme k celku a
uvidíme obraz strojového kódu jako jediný hotový výsledek.

## Cíl ještě před začátkem cesty

Zdroj začíná:

```asm
        ORG 32768
```

Desítkové číslo 32768 je hexadecimální `$8000`. Logický čítač adresy i fyzický
výstupní ukazatel se proto přesunou na `$8000`.

Toto rozlišení je důležité, i když zde mají obě hodnoty shodou okolností stejnou
hodnotu:

```text
logicalAddress = adresa přiřazovaná labelům a atomu `$`
outputPointer  = bajt RAM, který dostane následující výstupní bajt
```

`ORG` mění oba. Pozdější `PUT` by je mohl oddělit, ale tento příklad takovou
komplikaci nepotřebuje.

Očekávaný výstup lze snadno předpovědět:

```text
$8000  06 05     LD B,5
$8002  10 FE     DJNZ LOOP
$8004  C9        RET
```

`ORG` ani `ENT` nevytvářejí bajty. Výsledný program je tedy dlouhý pět bajtů.

Účelem sestavení však není pouze zjistit těchto pět hodnot. Musí také:

- přiřadit `START=$8000`;
- přiřadit `LOOP=$8002`;
- ověřit, že každý tvar zdroje je platný;
- vypočítat podepsaný displacement skoku `$FE`;
- zařídit, aby příkaz `RUN` volal `$8000`;
- při vysílání výsledku nepřepsat chráněnou paměť.

## Zdroj nevstupuje do assembleru jako text

Ve chvíli, kdy uživatel vyvolá ASSEMBLY, je pět řádků už uloženo jako
komprimované sémantické záznamy. Jejich zápis byl převeden na indexy, třídy,
pořadová čísla a zakódované expressiony.

Přesná pořadová čísla závisejí na současné tabulce symbolů. Pro tento příklad si
můžeme představit, že editor vytvořil:

```text
ordinal 1 -> START
ordinal 2 -> LOOP
```

Záznamy si potom můžeme koncepčně představit takto:

```text
záznam 1
    pseudo-opcode: ORG
    expression: literal 32768

záznam 2
    řádkový label: pořadové číslo symbolu 1 (START)
    tvar instrukce: LD registr, immediate bajt
    pevný operand: B
    expression: literal 5

záznam 3
    řádkový label: pořadové číslo symbolu 2 (LOOP)
    tvar instrukce: DJNZ relativní expression
    expression: pořadové číslo symbolu 2 (LOOP)

záznam 4
    tvar instrukce: RET
    bez payloadu expressionu

záznam 5
    pseudo-opcode: ENT
    expression: pořadové číslo symbolu 1 (START)
```

Nejde o doslovný výpis bajtů, protože indexy tabulky instrukcí a pořadová čísla
symbolů jsou vlastnostmi současného zdroje a tabulky. Důležitá je sémantická
struktura.

Všimněme si, co v ní chybí:

- písmena `S T A R T` se neopakují v záznamech 2 a 5;
- písmena `L O O P` se neopakují v definici a skoku záznamu 3;
- `LD`, `DJNZ` a `RET` jsou reprezentovány kompaktními identitami tabulky;
- desítkové zápisy `32768` a `5` se změnily na zakódované numerické atomy.

Assembler tedy začíná z podoby, která je už částečně pochopena. Nemusí znovu
tokenizovat pět řádků určených člověku.

## Před prvním průchodem symboly ztrácejí staré definice

Předchozí sestavení mohlo v tabulce symbolů zanechat hodnoty. PROMETHEUS jim
nemůže jednoduše věřit, protože editace mohla změnit délky instrukcí nebo pozice
labelů.

`processCompilation` nejprve vynuluje bit DEFINED každého nezamčeného symbolu:

```asm
    ld c,0b6h
    call processSymbolTableItems
```

Bajt `$B6` je zakódovaná operace `RES 6,(HL)` vložená do sdíleného modifikátoru
vektorů symbolů. Bit 6 je dočasný bit DEFINED/značka.

Jména a uložená hodnotová slova zůstávají. Smaže se pouze stav jejich současné
definice. Zamčené symboly si ponechávají svůj zvláštní stav a mohou zůstat
použitelné jako externí konstanty nebo dříve sestavená rozhraní.

Předpokládejme, že v našem příkladu není zamčený ani `START`, ani `LOOP`:

```text
před resetem:
    START  hodnota z libovolného dřívějšího sestavení, DEFINED může být nastaven
    LOOP   hodnota z libovolného dřívějšího sestavení, DEFINED může být nastaven

po resetu:
    START  záznam stále existuje, DEFINED je vynulován
    LOOP   záznam stále existuje, DEFINED je vynulován
```

Záznamy zdroje stále odkazují na stejná pořadová čísla. Stabilní identita
přežívá; význam závislý na pozici se znovu vytvoří.

## Instalace strategie prvního průchodu

Controller opraví své volání prováděné pro každý záznam tak, aby ukazovalo na
`firstPassProcessSourceRecord`:

```asm
    ld hl,firstPassProcessSourceRecord
    ld (varcAssemblyPassHandlerCall+1),hl
```

Zároveň nastaví přechodový čítač na 1. Tento jediný bajt provede controller třemi
stavy:

```text
1    probíhá první průchod
0    přepni na druhý průchod
$FF  oba průchody jsou dokončeny
```

Na začátku scanu se oba ukazatele sestavení nastaví těsně za současný zdroj a
tabulku symbolů. To je pouze výchozí hodnota. První záznam je okamžitě nahradí
adresou `$8000`.

## První průchod, záznam 1: `ORG 32768`

První záznam patří do namespace pseudo-instrukcí. První průchod dojde k handleru
`ORG`, vyhodnotí jeho zakódovaný expression a nastaví oba ukazatele:

```text
logicalAddress = $8000
outputPointer  = $8000
```

Žádný bajt se nezapíše.

První průchod musí `ORG` vyhodnotit už nyní, protože na něm závisí adresy všech
následujících labelů. Dopředný odkaz by v tomto expressionu nepomohl: assembler
by potřeboval pozdější adresu k výpočtu originu, zatímco pozdější adresa sama
závisí na originu.

Po záznamu 1:

```text
START nedefinován
LOOP  nedefinován
logicalAddress = $8000
outputPointer  = $8000
```

## První průchod, záznam 2: `START LD B,5`

Záznam obsahuje pořadové číslo řádkového labelu. Než započítá instrukci,
`firstPassProcessSourceRecord` podle něj vyhledá vektor a záznam symbolu `START`.

Běžné pravidlo řádkového labelu zní:

```text
if symbol je zamčený or již definovaný:
    ohlas chybu definice
else:
    symbol.value = logicalAddress
    nastav symbol.DEFINED
```

Logická adresa je nyní `$8000`, tedy:

```text
START = $8000
```

Tvar instrukce byl nalezen už při editaci. První průchod nevyhodnocuje literal
`5`; pouze zjišťuje, kolik bajtů daný tvar instrukce zabere.

Pro `LD B,n` poskytuje tabulka instrukcí základní opcode a třídu vysílání
operandu. Úprava délky daná třídou říká, že za opcodem následuje jeden immediate
bajt:

```text
bajty opcodu      1
immediate operand 1
celkem            2
```

Ukazatele se posunou:

```text
logicalAddress = $8002
outputPointer  = $8002
```

Žádný výstupní bajt ještě nebyl zapsán. První průchod pouze měří.

## První průchod, záznam 3: `LOOP DJNZ LOOP`

Nejprve se definuje label:

```text
LOOP = $8002
```

Potom se změří tvar instrukce. `DJNZ expression` zabírá dva bajty:

```text
opcode         1
relativní bajt 1
celkem         2
```

Skutečnost, že expression odkazuje na `LOOP`, nemusí být v prvním průchodu
vyhodnocena. Délka instrukce je známa už z jejího tvaru.

Po záznamu:

```text
logicalAddress = $8004
outputPointer  = $8004
```

To je klasická výhoda dvouprůchodového assembleru. Expression skoku lze odložit,
dokud každý běžný řádkový label nedostane svou adresu.

Na tomto konkrétním řádku je `LOOP` shodou okolností definován ještě předtím, než
by se vyhodnocoval jeho vlastní expression. Stejný mechanismus však zvládne i
skok na label, který leží ve zdroji až později.

## První průchod, záznam 4: `RET`

`RET` nemá prefix ani bajty operandu. Jeho záznam v tabulce instrukcí předpovídá
jeden bajt.

```text
logicalAddress = $8005
outputPointer  = $8005
```

## První průchod, záznam 5: `ENT START`

První průchod `ENT` ignoruje. Nevysílá bajty a neovlivňuje mapu adres.

Expression se záměrně odkládá do druhého průchodu, kdy už jsou definovány všechny
běžné labely.

Konečný stav prvního průchodu je:

```text
START = $8000, DEFINED
LOOP  = $8002, DEFINED
logicalAddress = $8005
outputPointer  = $8005
```

Mapa je úplná.

## Přechod mezi průchody

Na konci scanu zdroje se přechodový čítač změní z 1 na 0. Controller znovu
opraví volání strategie:

```asm
    ld hl,secondPassEmitSourceRecord
    ld (varcAssemblyPassHandlerCall+1),hl
```

Potom znovu spustí totéž procházení zdroje od začátku.

Logický i fyzický ukazatel se znovu nastaví na výchozí dynamický konec a
`ORG 32768` oba opět nahradí hodnotou `$8000`. Provádění direktiv v obou
průchodech zaručuje, že druhý průchod projde přesně stejnou historií adres jako
první.

## Druhý průchod, záznam 1: zopakování originu

`ORG 32768` se znovu vyhodnotí:

```text
logicalAddress = $8000
outputPointer  = $8000
```

Stále se nevysílá žádný bajt.

## Druhý průchod, záznam 2: vyslání `LD B,5`

Strojový handler druhého průchodu přečte popis prefixu/opcodu v záznamu a vyšle
opcode pro `LD B,n`:

```text
$06
```

Potom vyhodnotí zakódovaný expression `5`. Validator immediate bajtu přijímá
hodnoty, jejichž high bajt je `$00` nebo `$FF`, čímž zachovává kompaktní bajtovou
sémantiku assembleru. Pět je samozřejmě platná hodnota.

Vyšle se druhý bajt:

```text
$05
```

Paměť nyní obsahuje:

```text
$8000  $06
$8001  $05
```

Každé volání `emitByteAtAssemblyOutput` provádí více než obyčejný store. Ověří,
že současný cíl neleží v chráněném residentním prostoru, zdroji nebo symbolech a
že je pod U-TOP. Teprve potom bajt zapíše a posune oba ukazatele sestavení.

Po instrukci:

```text
logicalAddress = $8002
outputPointer  = $8002
```

## Druhý průchod, záznam 3: výpočet `DJNZ LOOP`

Nejprve se vyšle opcode:

```text
$10
```

Výstupní a logický ukazatel nyní míří na bajt displacementu na `$8003`. Procesor
interpretuje podepsaný displacement relativního skoku od adresy následující za
celou dvoubajtovou instrukcí.

PROMETHEUS tedy potřebuje:

```text
target = hodnota LOOP = $8002
adresa následující instrukce = $8004

displacement = target - adresa následující instrukce
             = $8002 - $8004
             = -2
```

V osmibitovém dvojkovém doplňku:

```text
-2 = $FE
```

Validator podepsaného bajtu přijme rozsah -128 až 127 a zapíše `$FE`.

Vyslaná paměť nyní vypadá takto:

```text
$8000  06 05     LD B,5
$8002  10 FE     DJNZ $8002
```

Ukazatele se posunou na `$8004`.

### Proč skok neobsahuje `$8002`

Začínající programátor v assembleru může očekávat, že bajty za `DJNZ` budou
obsahovat cílovou adresu. Relativní skok Z80 má však jen jeden bajt operandu.
Ukládá vzdálenost, nikoli adresu.

Za běhu:

```text
načti $10 na $8002
načti $FE na $8003
program counter je nyní $8004
B = B - 1
if B != 0:
    PC = $8004 + signed($FE)
       = $8004 - 2
       = $8002
```

Assembler přeložil symbolický záměr „jdi na LOOP“ do malého místního pohybu,
kterému procesor skutečně rozumí.

## Druhý průchod, záznam 4: vyslání `RET`

`RET` je jednoduchá jednobajtová instrukce:

```text
$C9
```

Hotová oblast strojového kódu je:

```text
Adresa   Hex bajty  Význam
$8000    06 05      LD B,5
$8002    10 FE      DJNZ $8002
$8004    C9         RET
```

Oba ukazatele sestavení mají hodnotu `$8005`.

## Druhý průchod, záznam 5: příprava RUN

`ENT START` vyhodnotí `START` a získá `$8000`.

Místo zápisu výstupních bajtů opraví operand residentního volání:

```asm
varcRunEntryCallTarget:
    call 00000h
```

Po direktivě se tři bajty této instrukce chovají jako:

```text
CD 00 80
```

Direktiva také sníží `varcRunEntDirectiveBalance`. Protože rovnováha začala na 1
a jde o jediný `ENT`, dosáhne nuly.

Tato nula dokazuje, že existovala právě jedna vstupní direktiva.

## Dokončení druhého průchodu

Na konci druhého scanu podteče přechodový čítač z 0 na `$FF`. Controller se vrátí
do `invokeAssembly`, který zobrazí zprávu o dokončení sestavení.

Žádný třetí scan se nekoná.

Dvouprůchodový proces lze nyní shrnout tabulkou:

| Záznam | První průchod | Druhý průchod |
|---|---|---|
| `ORG 32768` | nastav oba ukazatele na `$8000` | nastav oba ukazatele na `$8000` |
| `START LD B,5` | definuj `START`; přičti 2 | vyšle `06 05` |
| `LOOP DJNZ LOOP` | definuj `LOOP`; přičti 2 | vyšle `10 FE` |
| `RET` | přičti 1 | vyšle `C9` |
| `ENT START` | ignoruj | oprav cíl RUN; sniž rovnováhu ENT |

## Tabulka symbolů po sestavení

Tabulka symbolů má stále svou obvyklou dvouúrovňovou strukturu:

```text
vektory pořadových čísel
    1 -> fyzický záznam pro START
    2 -> fyzický záznam pro LOOP

abecední záznamy hodnot/jmen
    LOOP   hodnota $8002
    START  hodnota $8000
```

Pořadí vektorů vyjadřuje stabilní identitu pořadových čísel. Fyzické záznamy jsou
uspořádány abecedně, takže `LOOP` může stát před `START`, i když `START` dostal
nižší pořadové číslo.

Oba vektorové záznamy mají nastaven DEFINED. Nemusí ukládat každé místo, kde byl
symbol použit. Komprimované záznamy zdroje nadále obsahují jejich pořadová čísla.

## Co RUN udělá s výsledkem

Příkaz `RUN` nejprve vyvolá sestavení. Potom zkontroluje rovnováhu ENT.

V tomto programu je rovnováha nulová, takže RUN vymaže obrazovku a provede
opravené volání `$8000`.

Procesor vykoná:

```text
B = 5
repeat:
    B = B - 1
until B = 0
return
```

`RET` se vrátí k instrukci za `varcRunEntryCallTarget`. PROMETHEUS potom může
počkat na klávesu a obnovit obrazovku editoru.

Program, který se nikdy nevrátí, by si ponechal řízení. PROMETHEUS kolem běžného
RUN nevytváří ochrannou hranici procesu. Opatrnější mechanismus krokování patří
monitoru a bude vysvětlen mnohem později.

## Zpětné přečtení výstupu

Disassembler monitoru může později začít na `$8000` a zrekonstruovat tři
instrukce.

Tatáž tabulka instrukcí, která pomohla editoru přijmout zdroj a druhému průchodu
vyslat bajty, nyní pracuje opačným směrem:

```text
06 05 -> LD B,5
10 FE -> DJNZ $8002
C9    -> RET
```

Najde-li vyhledávání symbolu podle hodnoty `LOOP=$8002`, může být relativní cíl
zobrazen jako `LOOP` místo čísla.

Tím se uzavírá pozoruhodný kruh:

```text
text psaný člověkem
    -> kompaktní sémantika zdroje
    -> identita v tabulce instrukcí
    -> strojové bajty
    -> identita v tabulce instrukcí
    -> čitelný zdrojový text
```

Tabulka není pouze seznamem opcodů. Je společným mostem mezi editorem,
assemblerem a monitorem.

## Prostým pseudokódem

Zde je úplné sestavení příkladu bez detailů na úrovni registrů:

```text
symbols.clearDefinedOnUnlockedItems()

passOne:
    logical = dynamicEnd + 1
    output  = dynamicEnd + 1

    ORG 32768:
        logical = $8000
        output  = $8000

    START: LD B,5:
        define START = logical
        logical += 2
        output  += 2

    LOOP: DJNZ LOOP:
        define LOOP = logical
        logical += 2
        output  += 2

    RET:
        logical += 1
        output  += 1

    ENT START:
        žádný účinek v prvním průchodu

passTwo:
    logical = dynamicEnd + 1
    output  = dynamicEnd + 1

    ORG 32768:
        logical = $8000
        output  = $8000

    LD B,5:
        emit $06
        emit $05

    DJNZ LOOP:
        emit $10
        displacement = LOOP - (logical + 2)
        require -128 <= displacement <= 127
        emit lowByte(displacement)       ; $FE

    RET:
        emit $C9

    ENT START:
        runCallTarget = START
        entBalance -= 1

require entBalance == 0 for RUN
```

## Co se změnilo v paměti

Po úspěšném sestavení:

- vektory nezamčených symbolů `START` a `LOOP` mají nastaven DEFINED;
- jejich hodnotová slova obsahují `$8000` a `$8002`;
- bajty `$06,$05,$10,$FE,$C9` leží na adresách `$8000` až `$8004`;
- `varcAddressCounter` a `varcAssemblyOutputPointer` končí na `$8005`;
- operand `varcRunEntryCallTarget` obsahuje `$8000`;
- `varcRunEntDirectiveBalance` dosáhl nuly;
- komprimované záznamy zdroje zůstaly beze změny.

## Důležité labely, s nimiž jsme se setkali

- `processCompilation`
- `processSymbolTableItems`
- `varcAssemblyPassHandlerCall`
- `varcAssemblyPassTransitionCounter`
- `firstPassProcessSourceRecord`
- `secondPassEmitSourceRecord`
- `varcAddressCounter`
- `varcAssemblyOutputPointer`
- `emitMachineInstructionBytes`
- `emitByteAtAssemblyOutput`
- `validateAndEmitImmediateByte`
- `.validateSignedByteInHLAndEmitL`
- `varcRunEntryCallTarget`
- `varcRunEntDirectiveBalance`
- `invokeRun`

## Zpět k celkovému obrazu

Část III začala assemblerem viděným shora. Potom sestoupila přes rozpoznávání
slov, operandy, expressiony, symboly, oba průchody a direktivy. Nyní se můžeme
vrátit k původnímu pohledu z nejvyšší úrovně, tentokrát už s vyplněným každým
hlavním krokem:

```text
pět viditelných řádků zdroje
    -> pět kompaktních sémantických záznamů
    -> dvě stabilní identity symbolů
    -> mapa adres z prvního průchodu
    -> recepty opcodů a operandů druhého průchodu
    -> pět chráněných výstupních bajtů
    -> jeden opravený vstup RUN
```

Assemblerová část je na úrovni knihy dokončena.

Dalším problémem je trvalé uložení. Záznamy zdroje a symboly mají cenu pouze
tehdy, mohou-li přežít vypnutí, přecházet mezi pracovními sezeními a být sloučeny
do jiného programu. Část IV je bude sledovat na kazetu a zpět.
