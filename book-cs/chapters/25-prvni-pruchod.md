# Kapitola 25: První průchod

Assembler nakonec musí zapisovat bajty, nemůže však rozumně začít právě jimi.
Než lze zakódovat skok, musí mít jeho cíl adresu. Než může mít label adresu,
musí assembler vědět, kolik bajtů mu předchází. A než to může vědět, musí znát
velikost každé instrukce a každé datové direktivy, na kterou cestou narazí.

Tento zdánlivě kruhový problém je důvodem existence prvního průchodu.

PROMETHEUS jej řeší tradičním způsobem:

```text
první průchod:  zjisti mapu budoucího programu
druhý průchod:  použij tuto mapu k vytvoření budoucího programu
```

První průchod nevysílá běžné bajty instrukcí. Jeho hlavním výsledkem je soubor
faktů:

- hodnota každého řádkového labelu;
- hodnota každého symbolu `EQU`, který lze v daném okamžiku vypočítat;
- logická adresa před každým záznamem zdroje a za ním;
- účinek direktiv `ORG`, `PUT` a direktiv rezervujících paměť;
- informace, zda některé jméno není definováno dvakrát;
- informace, zda expression řídící adresy nezávisí na dosud neznámém jménu.

Jakmile tyto skutečnosti existují, může druhý průchod vyhodnotit dopředné odkazy
a zapsat konečný strojový kód.

Tato kapitola sleduje první průchod od jeho nejvyššího controlleru až k drobným
trikům pro počítání bajtů uvnitř `firstPassProcessSourceRecord` a potom se vrací
k úplnému průchodu zdrojem.

## Zdroj je již rozebrán

První průchod nečte z editovaného řádku slova jako `LD`, `LOOP` nebo `DEFW`.
Tato práce proběhla už při vložení řádku.

V okamžiku zahájení sestavení každý záznam zdroje již obsahuje:

- opcode nebo pseudo-opcode;
- informační bajt popisující prefixy, přítomnost labelu a třídu operandu;
- volitelné dvoubajtové pořadové číslo řádkového labelu;
- podle potřeby kompaktní materiál expressionu.

Toto oddělení je důležité. První průchod může pracovat s malým sémantickým
záznamem, místo aby znovu a znovu parsoval text určený člověku.

U obyčejné instrukce mu k určení budoucí velikosti obvykle stačí dva bajty
hlavičky. Hodnotu operandu zatím vyhodnocovat nemusí.

Například zdroj:

```asm
        JR LOOP
```

již v komprimované podobě říká:

```text
toto je strojová instrukce tvaru JR
její třída operandu je relativní cíl
její expression odkazuje na symbol s pořadovým číslem N
```

První průchod ví, že taková instrukce zabere dva bajty. Může posunout čítač
adresy, aniž by znal současnou hodnotu `LOOP`.

Právě tím jsou možné běžné dopředné odkazy.

## Příprava světa symbolů

Controllerem je `processCompilation`. Před procházením zdroje odstraní ze
symbolů stav DEFINED:

```asm
    ld c,0b6h
    call processSymbolTableItems
```

Bajt `$B6` je opcode instrukce:

```asm
RES 6,(HL)
```

Jak vysvětlila kapitola 24, `processSymbolTableItems` vloží tento opcode do své
samomodifikované vektorové operace a použije ji na celou tabulku.

Bit 6 je během sestavení běžným stavem DEFINED a při komprimaci symbolů také
dočasným značkovacím bitem. Jeho vynulování poskytne novému prvnímu průchodu
čistou množinu definic pocházejících ze zdroje.

Zamčené symboly si ponechávají bit 7. Evaluator expressionu přijme symbol,
pokud je nastaven bit 6 nebo bit 7. Zamčenou hodnotu je tedy možné nadále použít
jako importovanou konstantu nebo adresu nižší vrstvy, přestože její běžný bit
DEFINED byl právě smazán.

Koncepčně:

```text
for each symbol:
    symbol.defined = false
    symbol.locked zůstává beze změny
```

Každé sestavení tak začíná novým průchodem definic, aniž by zničilo záměrně
uchované externí hodnoty.

## Celý zdroj nebo vybraný blok

Cesty `ASSEMBLY` a `RUN` mohou sestavit celý zdroj nebo jen vybraný blok.
`processCompilation` nejprve hledá parametr příkazu `B` a uloží záměrně obrácený
bajt režimu:

```text
0 = pouze vybraný blok
1 = celý zdroj
```

Obrácení je jen výhodné pro větev používanou v horké scanovací smyčce. Je-li
aktivní režim celého zdroje, dojde řízení přímo k handleru záznamu. V režimu
bloku může `testSourceRecordOutsideSelectedBlock` záznam přeskočit dříve, než
jej kterýkoli průchod zpracuje.

Vybrané meze jsou včetně krajních záznamů. Tentýž test členství se používá v
obou průchodech, takže druhý průchod nemůže omylem vyslat řádek, který první
průchod vynechal z výpočtu adres.

Má to praktický důsledek: sestavení bloku je malý samostatný překlad používající
zamčené hodnoty symbolů a definice nacházející se uvnitř vybraného bloku. Není
to slib, že každý odkaz na nevybraný řádek zůstane nějakým způsobem dostupný.

## Instalace handleru prvního průchodu

PROMETHEUS nemá dvě kopie smyčky pro průchod zdrojem. Controller místo toho
opraví operand jediné instrukce `CALL`:

```asm
    ld hl,firstPassProcessSourceRecord
    ld (varcAssemblyPassHandlerCall+1),hl
```

Později se tentýž operand změní na `secondPassEmitSourceRecord`.

Scan má tedy tento tvar:

```text
for each vybraný sourceRecord:
    CALL currentPassHandler
```

kde `currentPassHandler` nejprve představuje první průchod a později druhý.

Je to dobrý příklad toho, jak PROMETHEUS používá kód jako malý objekt. Instrukce
`CALL` v sobě obsahuje právě platnou strategii.

## Kde sestavení začíná

Na začátku každého průchodu se oba pracovní ukazatele nastaví jeden bajt nad
současný konec zdroje a oblasti symbolů:

```asm
.initializeAssemblyPass:
    ld hl,(varcCodeEndPt+1)
    inc hl
    ld (varcAddressCounter+1),hl
    ld (varcAssemblyOutputPointer+1),hl
```

Oba ukazatele mají různý význam:

- `varcAddressCounter+1` je **logická adresa**, kterou představují labely a atom
  `$`;
- `varcAssemblyOutputPointer+1` je **fyzický cíl v RAM**, do něhož druhý průchod
  zapisuje bajty.

Na začátku jsou stejné, direktivy je však mohou oddělit.

`ORG` změní oba. `PUT` změní pouze fyzický ukazatel. Běžné vysílání posouvá oba.
`DEFS` posouvá oba, ale nic nezapisuje.

První průchod musí tento rozdíl zachovat, přestože obvykle žádné bajty
nezapisuje. Jinak by hodnoty přiřazené pozdějším labelům nesouhlasily s tím, co
nakonec vyšle druhý průchod.

## Scanner si nejprve pamatuje následující záznam

Buffer zdroje je sbalený a několik zpracovávacích rutin volně používá `HL` a
`IX`. Controller proto vypočítá následníka ještě před voláním handleru průchodu:

```asm
    push hl
    call getNextSourceRecord
    ld (varcNextAssemblyRecordPointer+1),hl
    pop ix
```

Po této sekvenci:

- `IX` ukazuje na současný záznam;
- operand `varcNextAssemblyRecordPointer` si pamatuje jeho následníka.

Handler může vyhodnocovat expressiony, procházet symboly nebo manipulovat s
jinými ukazateli. Po jeho návratu controller znovu načte uloženého následníka a
pokračuje.

Jde o stejný návrhový princip, který se v programu opakuje: zachovej malý kus
strukturálního stavu, který musí přežít složitou operaci, a potom dovol této
operaci volně používat pracovní registry.

## Chyby vědí, který řádek zdroje je způsobil

Bezprostředně před zpracováním záznamu se jeho adresa uloží také do operandu
`reportAssemblyErrorAtSourceRecord`:

```asm
    ld (reportAssemblyErrorAtSourceRecord+1),hl
```

Hluboké rutiny nemusí přenášet ukazatel na záznam zdroje přes každou výměnu
registrů. Nastane-li chyba, společná cesta načte opravenou hodnotu, uloží ji do
`varcSourceBufferActiveLine+1` a vrátí se do editoru s označeným příslušným
řádkem.

Chyba při vyhodnocení expressionu, kontrole rozsahu nebo ochraně výstupu tak
stále může ukázat na správný záznam zdroje.

## Definice řádkového labelu

První akcí `firstPassProcessSourceRecord` je test informačního bitu 3:

```asm
firstPassProcessSourceRecord:
    bit 3,(ix+001h)
    jr z,.accountSourceRecordLength
```

Je-li bit nulový, záznam nemá řádkový label a rutina může přejít přímo k
započítání délky.

Je-li bit nastaven, dvoubajtové pořadové číslo za hlavičkou záznamu se vyřeší na
vektor symbolu a fyzický záznam hodnoty a jména. Rutina si tento záznam zapamatuje
pro případné `EQU` a potom zkontroluje dva stavové bity vektoru:

```asm
    ld a,(hl)
    and 0c0h
    jr z,.defineLineLabelAtCurrentAddress
```

Oba bity nulové znamenají, že je jméno k dispozici pro definici.

Kterýkoli nastavený bit znamená, že jméno je již založeno:

- bit 6: bylo definováno dříve v tomto prvním průchodu;
- bit 7: je zamčené, a proto není dostupné pro novou definici.

Výsledkem je chyba `Already defined` a označení současného záznamu.

U nového labelu první průchod:

1. nastaví bit 6 v jeho vektoru;
2. přečte současnou logickou adresu;
3. zapíše tuto adresu do dvoubajtové hodnoty bezprostředně před jménem symbolu.

Jednoduše řečeno:

```text
if line obsahuje label:
    symbol = resolve(line.labelOrdinal)
    if symbol.defined or symbol.locked:
        error "Already defined"
    symbol.defined = true
    symbol.value = logicalAddress
```

V tomto okamžiku je běžný řádkový label hotový. Zbytek záznamu už pouze určuje,
o kolik se následně posune čítač adresy.

## `EQU` nejprve definuje a potom nahrazuje

Řádek `EQU` používá stejný vstup pro definici labelu. Jeho label se nejprve
označí jako DEFINED a dostane současnou adresu stejně jako každý jiný řádkový
label. Větev pseudo-instrukce potom vyhodnotí expression `EQU` a tuto dočasnou
hodnotu přepíše.

Mezilehlá hodnota současné adresy obvykle není viditelná. Opětovné použití
společné cesty labelu odstraňuje potřebu druhého mechanismu stavu definice.

Důležité omezení je dáno okamžikem vyhodnocení. `EQU` se počítá během prvního
průchodu, takže každý symbol použitý v jeho expressionu musí být už:

- definován dřívějším vybraným záznamem zdroje; nebo
- zachován jako zamčený symbol.

Pozdější obyčejný label nelze použít v dřívějším `EQU`.

Například:

```asm
SIZE    EQU END-START
START   DEFS 10
END
```

nemůže v tomto pořadí fungovat, protože při vyhodnocování `SIZE` ještě nejsou
současně definovány `END` a `START`. Problém vyřeší přesunutí `EQU` za oba labely
nebo zamčení potřebných hodnot z dřívější vrstvy.

Nejde o obecné selhání dopředných odkazů. Je to důsledek požadavku, aby první
průchod znal hodnotu okamžitě.

## Předpověď velikosti obyčejné instrukce

U strojové instrukce první průchod znovu neprohledává tabulku instrukcí.
Komprimovaný záznam už obsahuje konečný opcode a informační bajt. Tři spodní
bity informačního bajtu vybírají třídu vysílání operandu:

```text
třída 0  pouze opcode
třída 1  opcode + jeden bajt
třída 2  opcode + slovo
třída 3  opcode + relativní bajt
třída 4  opcode + indexový displacement
třída 5  opcode + indexový displacement + immediate bajt
třída 6  opcode RST s vektorem složeným přímo do něj
```

Bity rodiny prefixů říkají, zda jsou potřeba také bajty DD, FD, CB nebo ED.

PROMETHEUS balí základní délky instrukcí do neobvykle úsporné sekvence:

```asm
operandClassLengthAdjustments:
    nop
    ld bc,00102h
    ld bc,00002h
    nop
```

Tyto instrukce se nespouštějí jako podprogram. Jejich bajty tvoří lookup hodnoty:

```text
třída:       0  1  2  3  4  5  6
uložený bajt:0  1  2  1  1  2  0
plus jedna:  1  2  3  2  2  3  1
```

Poslední řádek udává velikost opcodu a materiálu operandu před započtením
prefixů.

Kód potom čtyřikrát posune informační bajt. Každý zvolený bit prefixu spadne do
carry a `ADC A,0` přičte toto carry k délce.

V pseudokódu:

```text
length = baseLengthByOperandClass[class]
for prefix in [DD, FD, CB, ED]:
    if record požaduje prefix:
        length += 1
logicalAddress += length
```

Tento drobný mechanismus předpoví délku již rozpoznané instrukce, aniž by
rozebíral její expression nebo zapisoval jediný bajt.

## Proč relativní skoky nepotřebují v prvním průchodu zvláštní výpočet

Relativní skok jako:

```asm
        JR LOOP
```

ukládá ve svém záznamu zdroje absolutní expression cíle, první průchod s ním
však zachází jednoduše jako s třídou operandu 3 a přičte dva bajty.

Podepsaný displacement se zatím nepočítá.

Tento výpočet závisí na konečných adresách a patří do druhého průchodu:

```text
displacement = target - addressAfterInstruction
```

Jeho odložením dovoluje první průchod, aby se `LOOP` objevil později. Potřebuje
znát pouze skutečnost, že relativní skok má jednobajtový operand.

## Zacházení s pseudo-instrukcemi v prvním průchodu

Pseudo-opcody obývají vlastní namespace. Po přeskočení volitelného pořadového
čísla řádkového labelu první průchod provede dispatch podle bajtu pseudo-opcodu.

Celkové chování je následující:

| Direktiva | Akce v prvním průchodu |
|---|---|
| prázdný řádek / komentář | žádná |
| `ENT` | žádná |
| `EQU` | vyhodnotit nyní a přiřadit hodnotu labelu |
| `ORG` | vyhodnotit nyní; nastavit logický i fyzický ukazatel |
| `PUT` | vyhodnotit nyní; nastavit pouze fyzický ukazatel |
| `DEFB` | spočítat položky; přičíst jeden bajt na položku |
| `DEFM` | projít řetězec; přičíst jeden bajt na logický znak |
| `DEFS` | vyhodnotit počet nebo počty; posunout logický i fyzický ukazatel |
| `DEFW` | spočítat položky; přičíst dva bajty na položku |

Tato tabulka vysvětluje pravidla dopředných odkazů.

`DEFB` a `DEFW` nepotřebují v prvním průchodu znát své hodnoty. Potřebují jen
počet expressionů oddělených čárkami, takže jejich expressiony mohou odkazovat
dopředu.

`DEFM` potřebuje pouze spočítat dekódované znaky včetně zpracování zdvojených
uvozovek.

`ENT` je celý odložen až do druhého průchodu, kdy už budou definovány všechny
běžné labely.

Naproti tomu `ORG`, `PUT`, `DEFS` a `EQU` musí své hodnoty znát okamžitě, protože
ovlivňují právě budovanou mapu.

## Počítání položek definice bez jejich vyhodnocení

`countCommaSeparatedDefinitionItems` prochází zakódovaný materiál definice a
počítá oddělovače. Rozumí komprimované reprezentaci právě natolik, aby ji
nezmátly:

- čárky oddělující položky;
- quoted řetězce, které mohou obsahovat obyčejné bajty;
- dvoubajtová tagovaná pořadová čísla symbolů;
- koncová značka `$C0+n`.

Není to evaluator expressionů. Je to strukturální scanner.

Pro:

```asm
        DEFB 1,VALUE,3
```

získá první průchod tři položky a posune logickou adresu o tři.

U `DEFW` počet zdvojnásobí.

Je to rychlejší a zároveň tolerantnější než předčasné vyhodnocování expressionů.

## Počítání `DEFM` stejným způsobem, jakým se později vysílá

První a druhý průchod sdílejí `scanNextDefmCharacter`.

Tento helper rozumí:

- otevíracímu a zavíracímu delimiteru;
- zdvojeným dvojitým uvozovkám představujícím jednu doslovnou dvojitou uvozovku;
- koncové značce záznamu zdroje;
- podmínce posledního znaku;
- řetězcům uzavřeným apostrofy, jejichž poslední vyslaný bajt dostane v druhém
  průchodu nastaven bit 7.

První průchod opakovaně volá scanner a počítá logické znaky. Druhý průchod
používá tentýž scanner a tyto znaky vysílá.

Sdílení decoderu zabraňuje tomu, aby se oba průchody neshodly na délce řetězce
obsahujícího escaped uvozovku.

## `DEFS` je víc než pouhý počet délky

`DEFS` rezervuje paměť posunutím obou ukazatelů bez zápisu. Protože jeho
expression určuje umístění každého pozdějšího labelu, musí se vyhodnotit už v
prvním průchodu.

Implementace přijímá posloupnost oddělenou čárkami, přestože obvyklou podobou je
jediný počet:

```asm
        DEFS 16
```

Pro každý zakódovaný expression:

1. vyhodnotí hodnotu do `BC`;
2. přičte ji k `varcAddressCounter+1`;
3. přičte ji k `varcAssemblyOutputPointer+1`;
4. pokračuje, pokud následuje další expression oddělený čárkou.

Druhý průchod zopakuje tentýž pohyb ukazatelů. Žádná paměť se nevyplňuje ani
nemaže. `DEFS` pouze zanechá mezeru ve výstupním adresním prostoru.

Protože se nevysílá žádný bajt, ochrana výstupu se v okamžiku rezervace
nekontroluje. Leží-li ukazatel nyní v chráněné paměti, zachytí neplatný cíl až
pozdější skutečný zápis.

## `ORG` a `PUT` se musí přehrát v obou průchodech

Na začátku druhého průchodu controller nastaví oba ukazatele zpět na původní
hodnotu za zdrojem. Direktivy řídící adresy se proto musí vykonat znovu i ve
druhém průchodu.

Je to záměr. Každý průchod začíná ve stejném počátečním stavu a interpretuje
tutéž posloupnost zdroje.

```text
první průchod začne na výchozím základu
    ORG/PUT/DEFS mění jeho mapu

druhý průchod začne znovu na výchozím základu
    tytéž ORG/PUT/DEFS reprodukují mapu při vysílání bajtů
```

Kdyby druhý průchod jednoduše zdědil konečné ukazatele z prvního, začal by na
konci programu namísto na jeho začátku.

## Dokončení scanu a změna průchodu

Když ukazatel zdroje dosáhne dynamického konce zdroje, řídí přechod
`varcAssemblyPassTransitionCounter`:

```text
počáteční hodnota 1
konec prvního průchodu: snížit na 0, nainstalovat handler druhého průchodu, začít znovu
konec druhého průchodu: snížit na $FF, vrátit se
```

Kód je kompaktní:

```asm
varcAssemblyPassTransitionCounter:
    ld a,000h
    dec a
    ld (varcAssemblyPassTransitionCounter+1),a
    ld hl,secondPassEmitSourceRecord
    ld (varcAssemblyPassHandlerCall+1),hl
    jr z,.initializeAssemblyPass
    ret
```

Handler druhého průchodu se zapíše i po druhém průchodu, test nuly je však při
změně čítače na `$FF` nepravdivý, takže sestavení skončí návratem namísto zahájení
třetího scanu.

## Malá cesta prvním průchodem

Uvažujme:

```asm
        ORG 32768
START   LD B,5
LOOP    DJNZ LOOP
        RET
        ENT START
```

První průchod začne s oběma ukazateli těsně nad zdrojem a symboly.

Potom:

1. `ORG 32768` nastaví oba ukazatele na `$8000`.
2. `START` se definuje jako `$8000`; `LD B,5` má délku 2; adresa se změní na
   `$8002`.
3. `LOOP` se definuje jako `$8002`; `DJNZ LOOP` má délku 2; adresa se změní na
   `$8004`.
4. `RET` má délku 1; adresa se změní na `$8005`.
5. `ENT START` v prvním průchodu nemá žádnou akci pro délku ani vyhodnocení.

Mapa nyní existuje:

```text
START = $8000
LOOP  = $8002
logická adresa konce programu = $8005
```

Běžné cesty instrukcí zatím nezapsaly jediný bajt strojového kódu.

## V prostém pseudokódu

Controller:

```text
function compile(scope):
    clearDefinedBitOnAllSymbols()

    passState = 1
    currentHandler = firstPass

    repeat:
        logicalAddress = codeEnd + 1
        outputPointer = codeEnd + 1
        record = firstSourceRecord

        while record leží před sourceEnd:
            nextRecord = record.next
            zapamatuj si record pro hlášení chyb

            if scope je wholeSource or record leží uvnitř selectedBlock:
                currentHandler(record)

            record = nextRecord

        passState -= 1
        currentHandler = secondPass

    until passState != 0
```

Handler prvního průchodu:

```text
function firstPass(record):
    if record obsahuje řádkový label:
        symbol = resolve(record.lineLabelOrdinal)
        if symbol.defined or symbol.locked:
            errorAt(record, "Already defined")
        symbol.defined = true
        symbol.value = logicalAddress
        zapamatuj symbol jako možný cíl EQU

    if record je strojová instrukce:
        logicalAddress += sizeFromInformationByte(record.info)
        return

    switch record.pseudoOpcode:
        case empty, comment, ENT:
            return

        case EQU:
            rememberedLineLabel.value = evaluate(record.expression)

        case ORG:
            value = evaluate(record.expression)
            logicalAddress = value
            outputPointer = value

        case PUT:
            outputPointer = evaluate(record.expression)

        case DEFB:
            logicalAddress += countItems(record)

        case DEFM:
            logicalAddress += countDecodedCharacters(record)

        case DEFS:
            for each expression in record:
                count = evaluate(expression)
                logicalAddress += count
                outputPointer += count

        case DEFW:
            logicalAddress += 2 * countItems(record)
```

## Co se změnilo v paměti

Po úspěšném prvním průchodu:

- každý vybraný běžný řádkový label má nastaven bit 6;
- slovo hodnoty každého takového labelu obsahuje jeho logickou adresu;
- každý vybraný label `EQU` obsahuje vyhodnocenou hodnotu;
- zamčené symboly stále nesou bit 7 a uchovávají své hodnoty;
- `varcAddressCounter+1` obsahuje konečnou logickou adresu dosaženou průchodem;
- `varcAssemblyOutputPointer+1` obsahuje konečnou fyzickou pozici vyplývající z
  `ORG`, `PUT` a `DEFS`;
- cesty prvního průchodu zatím nevyslaly žádnou běžnou instrukci ani datový bajt;
- cíl dispatchu pro každý záznam byl změněn na `secondPassEmitSourceRecord`;
- ukazatel zdroje je připraven začít znovu od začátku.

## Důležité labely, na které jsme narazili

- `processCompilation`
- `varcCompileWholeSource`
- `varcAssemblyPassHandlerCall`
- `varcNextAssemblyRecordPointer`
- `varcAssemblyPassTransitionCounter`
- `reportAssemblyErrorAtSourceRecord`
- `firstPassProcessSourceRecord`
- `varcCurrentLineLabelEntry`
- `operandClassLengthAdjustments`
- `skipEncodedLineLabelIfPresent`
- `setOrgAddressAndOutputPointer`
- `setOutputPointerFromBC`
- `advancePointersForDefsExpressions`
- `countCommaSeparatedDefinitionItems`
- `scanNextDefmCharacter`
- `varcAddressCounter`
- `varcAssemblyOutputPointer`

## Zpět k celkovému obrazu

První průchod změnil symbolický zdroj v úplnou mapu adres, program však stále
neexistuje jako bajty.

Důležitým výsledkem není pouze konečná velikost. Je jím shoda mnoha drobných
skutečností:

```text
labely mají hodnoty
velikosti instrukcí jsou známy
ORG a PUT vytvarovaly adresní prostory
rezervace paměti posunuly pozdější labely
běžné dopředné operandy lze nyní vyřešit
```

Kapitola 26 přehraje tentýž zdroj ze stejného počátečního stavu. Tentokrát
handler nepředpovídá. Vysílá prefixy, opcody, immediate hodnoty, slova,
relativní displacementy a data a cestou kontroluje každý fyzický cíl.
