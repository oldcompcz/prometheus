# Kapitola 27: Pseudo-instrukce a řízení sestavení

Procesor Z80 neví nic o `ORG`, `EQU`, `DEFB` ani `ENT`.

Tato slova nejsou instrukcemi procesoru, ale pokyny pro assembler. Utvářejí
adresy, vytvářejí data, rezervují prostor a sdělují PROMETHEU, jak má být hotový
program spuštěn.

Označení *pseudo-instrukce* je užitečné, protože se ve zdroji objevují na
stejných místech jako skutečné instrukce a ukládají se ve stejném systému
komprimovaných záznamů. Jejich účinky jsou však mnohem rozmanitější než pouhé
„vyšli opcode“.

Některé vysílají bajty. Některé mění ukazatele. Některé definují hodnoty. Jiné
ovlivňují pouze příkaz `RUN`. Prázdné řádky a komentáře při sestavení nedělají
nic, přesto však zabírají záznamy ve zdroji.

PROMETHEUS těmto záznamům přiděluje pseudo-opcody `$00` až `$09`:

```text
$00 prázdný záznam
$01 komentář
$02 ENT
$03 EQU
$04 ORG
$05 PUT
$06 DEFB
$07 DEFM
$08 DEFS
$09 DEFW
```

Jejich informační bajt používá namespace pseudo-instrukcí a za ním může podle
stejného pravidla jako u strojových záznamů následovat pořadové číslo
řádkového labelu.

Tato kapitola zkoumá direktivy jako jeden malý jazyk. Cílem není pouze vypsat
jejich syntaxi, ale ukázat, jak spolupracují se dvěma ukazateli a dvěma
průchody vysvětlenými v kapitolách 25 a 26.

## Tabulka účinků

Nejjednodušší je začít třemi otázkami pro každou direktivu:

1. Musí ji vyhodnotit první průchod?
2. Musí ji druhý průchod vyhodnotit nebo vyslat?
3. Jaký stav mění?

| Direktiva | První průchod | Druhý průchod | Hlavní účinek |
|---|---|---|---|
| empty/comment | ignoruje | ignoruje | pouze uspořádání zdroje |
| `ENT` | ignoruje | vyhodnotí | vstupní adresa pro RUN |
| `EQU` | vyhodnotí | ignoruje | hodnota řádkového labelu |
| `ORG` | vyhodnotí | vyhodnotí | logický i fyzický ukazatel |
| `PUT` | vyhodnotí | vyhodnotí | pouze fyzický ukazatel |
| `DEFB` | spočítá položky | vyhodnotí a vyšle | bajtová data |
| `DEFM` | spočítá znaky | dekóduje a vyšle | textová data |
| `DEFS` | vyhodnotí a posune | vyhodnotí a posune | rezervovaná mezera |
| `DEFW` | spočítá položky | vyhodnotí a vyšle | slovní data |

Asymetrie je záměrná. První průchod vykoná právě tolik práce, kolik je potřeba k
určení pozdějších adres. Druhý vykoná právě tolik práce, kolik je potřeba k
uskutečnění výstupu a přípravě metadat pro RUN.

## Prázdné záznamy a komentáře

Prázdný řádek zdroje má pseudo-opcode `$00`. Komentář má `$01` a nese svůj
textový payload beze změny.

Ani jeden v žádném průchodu nemění adresy ani výstup.

Pro editor však stále mají význam:

- zobrazují se v okně zdroje;
- lze je vybírat, kopírovat, mazat, hledat a tisknout;
- komentáře zachovávají programátorovo vysvětlení;
- pohyb mezi záznamy musí přeskočit jejich přesnou uloženou délku.

Chování assembleru je prosté:

```text
if pseudoOpcode < ENT:
    return
```

Jde o užitečné oddělení **struktury zdroje** od **struktury výsledku**. Ne vše,
co stojí za zachování v programu, musí mít reprezentaci ve strojovém kódu.

## `ENT`: adresa používaná příkazem RUN

`ENT expression` vybírá vstupní adresu pro příkaz `RUN`.

Nevysílá žádný bajt a nemění žádný z obou ukazatelů sestavení. První průchod ji
ignoruje. Druhý vyhodnotí expression poté, co byly definovány běžné labely, a
uloží výsledek do operandu instrukce:

```asm
varcRunEntryCallTarget:
    call 00000h
```

Cíl je tedy dalším samomodifikovaným operandem instrukce.

`RUN` vyžaduje právě jednu direktivu `ENT`. Před sestavením nastaví `invokeRun`
bajt rovnováhy na 1:

```asm
    ld a,001h
    ld (varcRunEntDirectiveBalance+1),a
```

Každá direktiva `ENT` ve druhém průchodu jej sníží.

Po sestavení:

```text
nula direktiv ENT         hodnota zůstane 1
jedna direktiva ENT       hodnota klesne na 0
více direktiv ENT         hodnota podteče nebo zůstane nenulová
```

Přijata je pouze nula. Jinak PROMETHEUS ohlásí `ENT ?`.

Tento kompaktní čítač rozlišuje „právě jednu“ bez samostatného příznaku
viděno/neviděno a dalšího počítadla duplicit.

Platný `RUN` potom vymaže obrazovku a provede:

```asm
varcRunEntryCallTarget:
    call 00000h
```

Chce-li se vygenerovaný program vrátit do PROMETHEA, očekává se, že skončí
instrukcí `RET`.

Protože se `ENT` vyhodnocuje ve druhém průchodu, může odkazovat na label
definovaný ve zdroji až za svým vlastním řádkem. V této chvíli už existuje úplná
mapa z prvního průchodu.

## `EQU`: jméno, jehož hodnota není jeho pozicí

Běžný řádkový label dostane logickou adresu, na níž jeho řádek začíná. `EQU`
tento poziční význam nahrazuje hodnotou expressionu.

Typický zdroj může obsahovat:

```asm
SCREEN  EQU 16384
WIDTH   EQU 32
```

Label patří k záznamu. V prvním průchodu jej běžná cesta labelu nejprve označí
jako DEFINED. Větev `EQU` potom vyhodnotí zakódovaný expression a zapíše výsledek
do hodnotového slova téhož symbolu.

Druhý průchod pro `EQU` nedělá nic, protože hodnota symbolu už existuje a žádný
bajt se nevysílá.

Toto načasování vytváří pravidlo pořadí:

```text
expression EQU smí používat:
    dřívější definice v současném průchodu
    zamčené symboly zachované odjinud

expression EQU nesmí používat:
    běžný symbol poprvé definovaný až později v témže průchodu
```

Například:

```asm
START   EQU BASE+16
BASE    EQU 32768
```

selže, není-li `BASE` už zamčený, protože se nejprve vyhodnocuje `START`.
Obrácené pořadí obou záznamů funguje.

PROMETHEUS je tedy dvouprůchodovým assemblerem pro běžné odkazy v instrukcích,
ale jeho expressiony `EQU` se v prvním průchodu řídí jediným scanem vpřed.

## `ORG`: zvol obě podoby otázky „kde“

`ORG expression` nastaví:

```text
logicalAddress = expression
outputPointer  = expression
```

Říká zároveň:

- „následující vygenerovaný bajt se považuje za uložený na této adrese“;
- „zapiš tento bajt na tuto adresu v RAM“.

`ORG` se provádí v prvním i druhém průchodu, protože oba začínají ve stejném
výchozím stavu a potřebují projít stejnou historií adres.

Běžný program začíná například:

```asm
        ORG 32768
```

Pozdější labely potom dostávají hodnoty od `$8000` výše a druhý průchod tam
zapisuje bajty.

`ORG` je také důvodem, proč může sestavení opustit bezpečnou výstupní oblast za
zdrojem a zamířit do nižší volné paměti. Zapisovač každého bajtu kontroluje, zda
zvolený region nepřekrývá PROMETHEUS, zdroj, symboly nebo U-TOP.

Expression musí být dostupný už v prvním průchodu. Dopředný label nemůže určovat
origin, protože hodnoty pozdějších labelů samy závisejí na originu.

## `PUT`: oddělení úložiště od logických adres

`PUT expression` mění pouze:

```text
outputPointer = expression
```

Logická adresa zůstává beze změny.

Kód tak může být sestaven, *jako by* ležel na jedné adrese, zatímco jeho bajty
jsou fyzicky uloženy na jiné.

Příklad:

```asm
        ORG 32768
        PUT 50000
HERE    LD HL,HERE
```

`HERE` má hodnotu `$8000`, ale bajty instrukce se zapisují od desítkové adresy
50000. Operand uvnitř těchto bajtů rovněž obsahuje `$8000`.

`PUT` se hodí pro pokročilejší rozvržení, postupně vytvářený kód nebo data,
která budou později přesunuta. PROMETHEUS z tohoto pozdějšího přesunu nic
neodvozuje. Pouze udržuje oba souřadné systémy.

Stejně jako `ORG` musí být `PUT` vyhodnocen v prvním průchodu a zopakován ve
druhém.

Společný helper vystihuje jejich vztah:

```asm
setOrgAddressAndOutputPointer:
    call evaluateEncodedExpressionAtIX
    ld (varcAddressCounter+1),bc
setOutputPointerFromBC:
    ld (varcAssemblyOutputPointer+1),bc
    ret
```

`ORG` vstupuje nad oba zápisy. `PUT` vstupuje až u druhého.

## `DEFB`: definování bajtů z expressionů

`DEFB` vytváří jeden bajt pro každý čárkou oddělený expression:

```asm
        DEFB 1,2,255
        DEFB LOWVALUE,-1
```

Při zadávání zdroje parser definic podle potřeby spojí dva běžné buffery operandů,
zakóduje každý expression a v komprimovaném payloadu zachová čárky jako
strukturální oddělovače.

První průchod expressiony nevyhodnocuje. Spočítá položky a posune logickou adresu
o jejich počet.

Druhý průchod vyhodnotí každou položku a pošle ji do
`validateAndEmitImmediateByte`. Široké bajtové pravidlo přijme hodnoty, jejichž
high bajt je `$00` nebo `$FF`, a potom vyšle low bajt.

`DEFB` tedy sdílí stejnou kontrolu hodnoty a stejný chráněný zapisovač jako
immediate operandy instrukcí.

Protože jsou hodnoty odloženy do druhého průchodu, může položka `DEFB` odkazovat
na pozdější běžný label:

```asm
        DEFB TABLE & 255
```

samozřejmě v rámci skutečných operátorů a syntaxe expressionů PROMETHEA, nikoli
podle konvencí moderních assemblerů. Důležité je, že symbol nemusí být
vyhodnocen jen proto, aby první průchod započítal jednu položku.

## `DEFW`: definování slov v pořadí little-endian

`DEFW` je slovním protějškem:

```asm
        DEFW START,END,BUFFER
```

První průchod spočítá položky a posune logickou adresu o dvojnásobek jejich
počtu.

Druhý průchod vyhodnotí každý expression a zavolá
`emitWordBCAtAssemblyOutput`, který zapíše:

```text
low bajt
high bajt
```

Není zapotřebí žádné omezení rozsahu. Každou šestnáctibitovou hodnotu lze
reprezentovat jako slovo.

Výše uvedený zdroj může vytvořit:

```text
low(START), high(START),
low(END),   high(END),
low(BUFFER),high(BUFFER)
```

Každý bajt je chráněn samostatně.

## `DEFM`: definování zprávy, nikoli seznamu expressionů

`DEFM` ukládá znaková data uzavřená v uvozovkách.

Parser mu poskytuje vlastní cestu místo obecného encoderu seznamu expressionů.
Do trvalého záznamu se zkopíruje celý normalizovaný řetězec včetně jeho
oddělovačů.

Dva druhy oddělovačů se liší chováním posledního bajtu.

S dvojitými uvozovkami:

```asm
        DEFM "HELLO"
```

PROMETHEUS vyšle běžné znakové bajty:

```text
48 45 4C 4C 4F
```

S apostrofy:

```asm
        DEFM 'HELLO'
```

nastaví bit 7 posledního vyslaného znaku:

```text
48 45 4C 4C CF
```

To odpovídá konvenci řetězců ukončených high bitem, kterou PROMETHEUS široce
používá i uvnitř sebe samého.

Společný `scanNextDefmCharacter` obsluhuje oba průchody. Vrací každý logický znak
a sděluje volajícímu, kdy dosáhl posledního.

Uvnitř řetězce s dvojitými uvozovkami také sloučí zdvojenou dvojitou uvozovku.
Dvojice uvozovek představuje jedinou doslovnou uvozovku, nikoli konec řetězce a
následný nový počáteční oddělovač.

První průchod počítá logické znaky vrácené tímto decoderem. Druhý je vysílá. U
posledního znaku řetězce odděleného apostrofy nastaví druhý průchod před voláním
společného zapisovače bajtů bit 7.

Použití jediného scanneru pro oba úkoly zaručuje, že pravidla escapování
nezpůsobí odlišnost mezi předpovězenou a skutečně vyslanou délkou.

## `DEFS`: rezervování prostoru bez jeho vyplnění

`DEFS expression` posune oba ukazatele sestavení, ale nic nezapíše:

```asm
BUFFER  DEFS 256
```

Začíná-li `BUFFER` na `$9000`, následující label bude mít hodnotu `$9100`. Bajty
od `$9000` do `$90FF` si ponechají obsah, který v paměti byl předtím.

Tento rozdíl je důležitý. `DEFS` není totéž jako:

```asm
        DEFB 0,0,0,...
```

Oblast neinicializuje.

Oba průchody vyhodnotí počet a posunou:

```text
logicalAddress += count
outputPointer  += count
```

Rekonstruovaný zdroj ukazuje, že smyčka zakódovaných expressionů přijímá více
než jeden čárkou oddělený počet, přestože běžně dokumentovanou podobou je jedna
hodnota. Každá hodnota se přičte postupně.

Protože se žádný bajt nezapisuje, rutina ochrany výstupu se při přeskočení mezery
nevolá. Dopadne-li nový výstupní ukazatel do zakázané oblasti, chyba se objeví až
při první skutečné operaci zápisu některé pozdější instrukce nebo datové
direktivy.

Stejně jako u `ORG`, `PUT` a `EQU` musí být počet vyhodnotitelný už v prvním
průchodu. Dopředný odkaz nemůže určit, kolik prostoru mají dřívější záznamy
rezervovat.

## Labely na datových a rezervačních direktivách

Všechny pseudo-záznamy používají stejný volitelný mechanismus řádkového labelu
jako strojové instrukce.

Následující zápisy jsou proto přirozené:

```asm
MESSAGE DEFM "READY"
TABLE   DEFW ITEM1,ITEM2
BUFFER  DEFS 64
```

První průchod definuje label na logické adrese *před* uplatněním velikosti
záznamu nebo jeho změny ukazatelů.

Tedy:

```text
MESSAGE = adresa prvního bajtu zprávy
TABLE   = adresa prvního slova
BUFFER  = začátek rezervované oblasti
```

U `EQU` je běžná poziční hodnota labelu okamžitě nahrazena výsledkem expressionu.

U `ORG` nebo `PUT` by label na témže záznamu byl definován ještě před provedením
direktivy měnící ukazatele. Vyplývá to přímo ze společného pořadí prvního
průchodu. Přehledný styl zdroje proto obvykle zapisuje direktivy řídící adresy
bez labelu, mohl-li by být zamýšlený význam jinak překvapivý.

## Záznamy definic jsou zakódovány jinak než instrukce

Při zadávání zdroje vybírají indexy mnemonic pro `DEFB` až `DEFW` cestu
`.encodeDefinitionPseudoInstruction`.

Ta:

1. převede mnemonic na pseudo-opcode 6 až 9;
2. vytvoří společnou hlavičku a volitelné pořadové číslo labelu;
3. spojí čárkami oddělený materiál ze dvou naparsovaných bufferů operandů;
4. zkontroluje celkovou normalizovanou délku;
5. buď zakóduje položky expressionů, nebo zkopíruje quoted řetězec `DEFM`;
6. připojí obvyklou koncovou/back-link značku `$C0+n`.

Průchody assembleru už nikdy nemusí rekonstruovat původní sloupce. Vidí kompaktní
payload určený konkrétním typem direktivy.

U `DEFB`, `DEFS` a `DEFW` byla jména symbolů uvnitř expressionů už nahrazena
tagovanými pořadovými čísly.

U `DEFM` zůstávají znakové bajty znakovými bajty, protože jejich zápis je
skutečnými daty, která mají být vyslána.

## Dispatch pseudo-instrukcí ve druhém průchodu

Rutina druhého průchodu používá aritmetický fall-through místo velké tabulky
skoků. Odečte 2, takže se `ENT` stane případem nula, a potom opakovaně snižuje
hodnotu, dokud nedosáhne ostatních direktiv.

Její tvar je přibližně:

```text
opcode < ENT: return
opcode == ENT: vyhodnoť a ulož cíl RUN
opcode == EQU: return
opcode == ORG: nastav oba ukazatele
opcode == PUT: nastav výstupní ukazatel
opcode == DEFB: smyčka expressionů, kontrolovaný emitter bajtů
opcode == DEFM: smyčka znaků, volitelný high bit posledního znaku
opcode == DEFS: smyčka expressionů posouvající ukazatele
opcode == DEFW: smyčka expressionů, emitter slov
```

Tento kompaktní dispatch funguje proto, že pseudo-opcody byly záměrně přiřazeny
v užitečném pořadí.

## Příklad kombinující direktivy

Uvažujme:

```asm
BASE    EQU 32768
        ORG BASE
START   LD HL,MESSAGE
        LD DE,BUFFER
        RET
MESSAGE DEFM 'OK'
TABLE   DEFW START,MESSAGE
BUFFER  DEFS 16
        ENT START
```

Předpokládejme následující délky instrukcí:

```text
LD HL,nn  3
LD DE,nn  3
RET       1
```

### První průchod

1. `BASE EQU 32768`
   - definuje `BASE` a nahradí jeho hodnotu `$8000`;
   - nepřidá žádnou délku.
2. `ORG BASE`
   - nastaví oba ukazatele na `$8000`.
3. `START LD HL,MESSAGE`
   - definuje `START=$8000`;
   - posune se na `$8003` bez vyhodnocení `MESSAGE`.
4. `LD DE,BUFFER`
   - posune se na `$8006` bez vyhodnocení `BUFFER`.
5. `RET`
   - posune se na `$8007`.
6. `MESSAGE DEFM 'OK'`
   - definuje `MESSAGE=$8007`;
   - spočítá dva znaky a posune se na `$8009`.
7. `TABLE DEFW START,MESSAGE`
   - definuje `TABLE=$8009`;
   - spočítá dvě slova a posune se na `$800D`.
8. `BUFFER DEFS 16`
   - definuje `BUFFER=$800D`;
   - vyhodnotí 16 a posune se na `$801D`.
9. `ENT START`
   - v prvním průchodu nic neudělá.

### Druhý průchod

1. `EQU` nedělá nic.
2. `ORG` obnoví `$8000` v obou ukazatelích.
3. `LD HL,MESSAGE` vyšle `21 07 80`.
4. `LD DE,BUFFER` vyšle `11 0D 80`.
5. `RET` vyšle `C9`.
6. `DEFM 'OK'` vyšle `4F CB`, přičemž poslední `K` má nastaven bit 7.
7. `DEFW START,MESSAGE` vyšle `00 80 07 80`.
8. `DEFS 16` přeskočí šestnáct bajtů bez zápisu.
9. `ENT START` opraví cíl volání RUN na `$8000` a splní čítač „právě jedna“.

Logický konec je `$801D`, ale poslední skutečně zapsaný bajt leží na `$800C`.
Rezervovaný buffer zabírá následující adresní rozsah, aniž by byl inicializován.

Tento příklad ukazuje, proč by jediná jednoduchá proměnná „současná pozice“
nestačila. Direktivy mohou definovat hodnoty, zapisovat data, měnit pozice nebo
pouze rezervovat rozsah adres.

## Prostým pseudokódem

Chování direktiv v prvním průchodu:

```text
function pseudoPassOne(record):
    switch record.opcode:
        case empty, comment, ENT:
            return

        case EQU:
            currentLineLabel.value = evaluate(record.expression)

        case ORG:
            value = evaluate(record.expression)
            logicalAddress = value
            outputPointer = value

        case PUT:
            outputPointer = evaluate(record.expression)

        case DEFB:
            logicalAddress += countExpressionItems(record)

        case DEFM:
            logicalAddress += countLogicalStringCharacters(record)

        case DEFS:
            for each expression:
                value = evaluate(expression)
                logicalAddress += value
                outputPointer += value

        case DEFW:
            logicalAddress += 2 * countExpressionItems(record)
```

Chování direktiv ve druhém průchodu:

```text
function pseudoPassTwo(record):
    switch record.opcode:
        case empty, comment:
            return

        case ENT:
            runTarget = evaluate(record.expression)
            entBalance -= 1

        case EQU:
            return

        case ORG:
            value = evaluate(record.expression)
            logicalAddress = value
            outputPointer = value

        case PUT:
            outputPointer = evaluate(record.expression)

        case DEFB:
            for each expression:
                emitCheckedByte(evaluate(expression))

        case DEFM:
            for each dekódovaný znak:
                if poslední and oddělovač je apostrof:
                    character |= $80
                emitByte(character)

        case DEFS:
            for each expression:
                value = evaluate(expression)
                logicalAddress += value
                outputPointer += value

        case DEFW:
            for each expression:
                emitWordLittleEndian(evaluate(expression))
```

## Co se změnilo v paměti

Podle přítomných direktiv:

- `EQU` změnil v prvním průchodu hodnotová slova symbolů;
- `ORG` v obou průchodech nahradil oba ukazatele sestavení;
- `PUT` nahradil pouze fyzický výstupní ukazatel;
- `DEFB` zapsal zkontrolované bajty;
- `DEFM` zapsal text a případně označil poslední apostrofem oddělený bajt;
- `DEFS` posunul ukazatele bez změny přeskočené RAM;
- `DEFW` zapsal slova v pořadí little-endian;
- `ENT` opravil cíl instrukce `CALL` příkazu RUN a změnil rovnováhu ENT;
- prázdné záznamy a komentáře nezměnily nic mimo úložiště zdroje.

## Důležité labely, s nimiž jsme se setkali

- `.executePseudoInstructionSecondPass`
- `skipEncodedLineLabelIfPresent`
- `setOrgAddressAndOutputPointer`
- `setOutputPointerFromBC`
- `advancePointersForDefsExpressions`
- `countCommaSeparatedDefinitionItems`
- `scanNextDefmCharacter`
- `.encodeDefinitionPseudoInstruction`
- `.encodeDefmStringLiteral`
- `validateAndEmitImmediateByte`
- `emitByteAtAssemblyOutput`
- `emitWordBCAtAssemblyOutput`
- `invokeRun`
- `varcRunEntDirectiveBalance`
- `varcRunEntryCallTarget`

## Zpět k celkovému obrazu

Část III nyní dokáže vysvětlit téměř každou transformaci prováděnou při
sestavení:

```text
zdroj psaný člověkem
    ↓
kompaktní sémantické záznamy
    ↓
mnemoniky, operandy a expressiony
    ↓
stabilní pořadová čísla a hodnoty symbolů
    ↓
mapa adres z prvního průchodu
    ↓
instrukce a data direktiv z druhého průchodu
```

Zbývá vložit všechny tyto mechanismy kolem jednoho programu a bez přerušení
sledovat jeho záznamy, symboly, adresy a konečné bajty.

Kapitola 28 tuto rekonstrukci provede. Bude návratem assemblerové části k
nejvyšší úrovni: jeden malý program vstoupí jako zdroj a odejde jako úplný obraz
strojového kódu se spustitelným vstupním bodem.
