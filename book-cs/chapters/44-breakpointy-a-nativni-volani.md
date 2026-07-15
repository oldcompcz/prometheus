# Kapitola 44: Breakpointy a nativní volání

Single-step udržuje PROMETHEA nablízku každé instrukci. Dekóduje ji,
zkontroluje její účinky na paměť, připraví řízenou kopii, vykoná ji a okamžitě
zachytí výsledek.

Někdy však uživatel nechce právě tohle.

Podprogram může být dlouhý, ale už důvěryhodný. Program může potřebovat běžet
plnou rychlostí, dokud nedosáhne určité adresy. Pro takové případy nabízí
monitor dvě přímější operace:

- zavolat jeden podprogram s uloženým stavem uživatele;
- běžet nativně až k dočasnému breakpointu.

Obě operace používají uložený obraz procesoru z kapitoly 43, ale uvolňují dohled
monitoru. Nekontrolují každou instrukci uvnitř volané nebo běžící části kódu.
Spoléhají na obyčejný tok řízení Z80, který vykonávání přivede zpět.

Tato kapitola vysvětluje obě únikové cesty i rizika, která přijímají.

## Nativní vykonávání proti trasovanému vykonávání

Pomůže, když rozdíl jasně pojmenujeme.

**Trasovaná** instrukce je pod dohledem:

```text
dekóduj
zkontroluj
zkopíruj nebo přepiš
vykonej ve scratch RAM
okamžitě zachyť
```

**Nativní** operace přenechá uživatelskému programu delší tah:

```text
obnov uložený stav
CALL nebo JP do uživatelského kódu
nech běžet obyčejný strojový kód
vrať se pouze slíbenou cestou
zachyť stav
```

Během nativního vykonávání PROMETHEUS:

- nekontroluje každé čtení ani zápis do paměti;
- nevynucuje uvnitř volaného kódu okna RUN;
- nepočítá T states každé instrukce;
- nezískává řízení po každé instrukci;
- nechrání sám sebe před programem, který skočí jinam, než se čekalo.

Nativní vykonávání je rychlejší a pro důvěryhodný kód přirozenější, ale je méně
uzavřené.

## Zavolání jednoho uživatelského podprogramu

SYMBOL SHIFT+H vyvolá `monCallSubroutineWithSavedState`. Příkaz si vyžádá adresu
a předá ji společnému builderu trampoline:

```asm
monCallSubroutineWithSavedState:
    call promptForMonitorValue
    defb 0cch
    ex de,hl
    ld c,0cdh
```

Důležité hodnoty jsou:

```text
C  = $CD, opcode pro CALL nn
DE = požadovaná adresa podprogramu
```

Následující rutina zapíše do scratch paměti drobný spustitelný program:

```asm
executeNativeCallOrJumpThroughTrampoline:
    call beginExecutionTrampoline
    ld (hl),c
    inc hl
    ld (hl),e
    inc hl
    ld (hl),d
    inc hl
    call appendSequentialAndTakenCaptureJumps
    jp restoreUserStateAndExecuteTrampoline
```

Pro volání podprogramu má scratch program tento tvar:

```text
DI nebo EI
CALL target
JP captureUserStateAfterSequentialFlow
JP captureUserStateAfterTakenFlow
```

Druhý skok je přítomen proto, že builder sdílí stepping engine. Normální nativní
`CALL` se vrátí na bajt bezprostředně za svou tříbajtovou instrukcí, tedy na
první připojený skok. Dostane se proto do vstupu sekvenčního zachycení.

Skutečný tok vypadá takto:

```text
obnov uživatelské registry a SP
    -> vykonej CALL target
       -> uživatelský podprogram běží nativně
       -> uživatelův RET se vrátí do scratch RAM
    -> JP do sekvenčního zachycení
    -> ulož výsledné uživatelské registry a SP
    -> obnov stack monitoru
    -> vrať se do monitoru
```

Podprogram vidí uživatelský procesor přesně tak, jak je zobrazen na čelním
panelu. Výsledky v registrech se zachytí zpět do tohoto obrazu.

## Proč musí být uživatelův SP platný

Skutečný `CALL` zapisuje návratovou adresu na aktivní stack. Než se CALL vykoná,
načetla rutina `restoreUserStateAndExecuteTrampoline`:

```asm
ld sp,(savedRegisterSP)
```

Návratová adresa se tedy uloží na uživatelův stack, ne na soukromý stack
monitoru.

Uložený SP musí ukazovat do zapisovatelné RAM, kde je místo alespoň na jedno
slovo. Ukazuje-li do ROM, do obrazových dat, která se nemají změnit, do samotného
PROMETHEA nebo na neplatnou pozici u horního konce paměti, může nativní volání
selhat nebo poškodit paměť.

Monitor potají nepodstrčí bezpečný stack, protože by tím změnil prostředí
podprogramu. Kód, který SP čte nebo mění, má vidět hodnotu zvolenou uživatelem.

Jde o obecné napětí v debuggeru:

> Věrné prostředí může být méně bezpečné než uměle vytvořené.

PROMETHEUS u tohoto příkazu volí věrnost a místo zásahu uživatele varuje.

## Co nativní CALL nepočítá

Tělo podprogramu není trasováno. `accumulatedTStates` proto nezíská čas strávený
uvnitř něj.

Scratch CALL a cesta návratu k zachycení jsou implementační mechanismus, ne
posloupnost, kterou by se časovací model snažil účtovat instrukci po instrukci.
Příkaz slouží k pohodlnému vyvolání kódu, ne k časovacímu experimentu.

Stejný princip se později uplatní, když politika trasovaných CALL/RST dovolí
vybraným rutinám běžet přímo. Přímá volání zvyšují rychlost, ale monitor ztrácí
přehled o jejich vnitřku.

## Běh k dočasnému breakpointu

Operace breakpointu používá dva příkazy se společným handlerem:

- W si zapamatuje počáteční adresu nativního běhu;
- SYMBOL SHIFT+U umístí dočasný breakpoint na současnou adresu monitoru a spustí
  běh od adresy zapamatované příkazem W.

Společný vstup začíná:

```asm
monSetBreakpointRunStartOrExecute:
    cp 077h
    jr nz,monRunToTemporaryBreakpoint
    ld (varcBreakpointRunStartAddress+1),hl
    ret
```

Je-li normalizovaným kódem klávesy W (`$77`), zapíše se současná adresa v HL do
bezprostředního operandu pozdější instrukce `LD DE,nn`.

V paměti programu se zatím nic nemění. W pouze říká:

```text
příští nativní běh má začít zde
```

Uživatel potom může přejít jinam a zvolit adresu breakpointu.

## Breakpoint je tříbajtový JP

SYMBOL SHIFT+U vstoupí do `monRunToTemporaryBreakpoint` s HL rovným současné
adrese monitoru — místu, kde se má vykonávání zastavit.

PROMETHEUS z této adresy uloží přesně tři bajty:

```asm
ld de,savedBreakpointOriginalBytes
call copyThreeBytesFromHLToDE
```

Potom je nahradí instrukcí:

```asm
JP breakpointHitCaptureEntry
```

Vygenerované bajty jsou:

```text
$C3  low(adresa zachycení)  high(adresa zachycení)
```

Patch se instaluje přes chráněné výstupní rutiny assembleru:

```asm
ld a,0c3h
call emitByteAtAssemblyOutput
ld bc,breakpointHitCaptureEntry
call emitWordBCAtAssemblyOutput
```

Použití běžného emitteru je důležité. Odmítne cíle v ROM, v rezidentní oblasti
PROMETHEA a zdroje nebo nad U-TOP. Monitor proto nezapisuje skok breakpointu do
zjevně zakázané paměti.

Uživatelská trasovací okna READ, WRITE a RUN se zde nekontrolují. Jde o příkaz
nativního běhu, ne o trasovanou instrukci.

## Proč se ukládají právě tři bajty

Absolutní skok Z80 má tři bajty. PROMETHEUS vždy ukládá a nahrazuje tři bajty bez
ohledu na hranice instrukcí.

Představme si, že na adrese breakpointu začíná jednobajtová instrukce a po ní
dvoubajtová. Patch dočasně překryje obě. Kdyby adresa ležela uprostřed
instrukce, patch přesto překryje tři bajty od tohoto místa.

U jednoduchého softwarového breakpointu je to normální: předpokládá se, že
zvolená adresa je místem, odkud procesor může oprávněně načíst instrukci.
PROMETHEUS před patchováním nepoužívá disassembler, aby zarovnání dokazoval.

Samotný uložený buffer má jen tři bajty:

```asm
savedBreakpointOriginalBytes:
    nop
    nop
    nop
```

Tyto opcode `NOP` jsou neškodnými počátečními hodnotami. Není-li breakpoint
aktivní, slouží bajty pouze jako úložiště.

## Počáteční adresa běhu je oddělená od adresy breakpointu

Adresa začátku běhu zapamatovaná příkazem W se objevuje zde:

```asm
varcBreakpointRunStartAddress:
    ld de,breakpointHitCaptureEntry
```

Původní sestavený operand ukazuje na vstup zachycení, ale W jej opraví na
zvolenou počáteční adresu.

Za běhu jsou registry uspořádány takto:

```text
HL = adresa patche breakpointu, uchovaná na stacku monitoru
DE = počáteční adresa nativního běhu
C  = $C3, opcode pro JP nn
```

Společná nativní trampoline proto zahájí uživatelský program skutečným
absolutním skokem:

```text
DI nebo EI
JP runStart
JP sequentialCapture
JP takenCapture
```

JP se do scratch oblasti nevrací. Uživatelský program běží volně, dokud nenačte
dočasný skok na adrese breakpointu.

## Jak si program najde cestu zpět

Když program dosáhne patchované adresy, vykoná:

```asm
JP breakpointHitCaptureEntry
```

Tento vstup obsahuje jeden záměrný `NOP` a potom propadne do
`captureUserStateAfterSequentialFlow`:

```asm
breakpointHitCaptureEntry:
    nop
captureUserStateAfterSequentialFlow:
    ld (savedRegisterSP),sp
    ...
```

Proč `NOP`?

Běžná cesta sekvenčního zachycení má ve svém rozložení jednobajtovou pozici
spojenou s propadnutím ze scratch trampoline. Vstup breakpointu použije jeden
bajt, aby dosáhl stejného společného uspořádání a zachoval korekci refresh
registru kompatibilní s touto cestou.

Přesné účtování bajtů je méně důležité než princip návrhu:

> Breakpoint nepotřebuje druhou úplnou rutinu ukládání stavu. Vstoupí do
> existujícího serializeru na kompatibilním místě.

Zachycovací kód z kapitoly 43 zaznamená registry, stack, I, R i stav přerušení a
potom obnoví SP monitoru uložený před nativním vykonáváním.

Protože samotná rutina `executeNativeCallOrJumpThroughTrampoline` byla zavolána
z `monRunToTemporaryBreakpoint`, návrat ze zachycení pokračuje bezprostředně za
tímto voláním.

## Obnovení vytlačených bajtů

Před spuštěním vložila rutina breakpointu na stack monitoru dvě hodnoty:

- adresu breakpointu;
- adresu `savedBreakpointOriginalBytes`.

Tento stack je během běhu uživatelského programu neaktivní, ale cesta zachycení
jej obnoví. Kód za voláním společné trampoline proto pokračuje:

```asm
pop hl
pop de
copyThreeBytesFromHLToDE:
    ld bc,0003h
    ldir
```

Zdroj a cíl jsou připraveny tak, aby se původní tři bajty zkopírovaly zpět na
adresu breakpointu.

Dočasný patch existuje pouze během nativního běhu.

V pseudokódu:

```text
breakpoint = currentAddress
start = rememberedWAddress

savedBytes = memory[breakpoint .. breakpoint+2]
protectedWrite(breakpoint, JP captureEntry)

ulož pokračování monitoru
obnov uživatelský procesor
JP start

; uživatelský kód běží až k breakpointu
captureEntry:
    zachyť uživatelský procesor
    obnov stack monitoru
    return do příkazu breakpointu

memory[breakpoint .. breakpoint+2] = savedBytes
```

## Adresa zobrazená po zásahu

Současnou adresou monitoru zůstane zvolená adresa breakpointu. Nativní program na
ni dorazil a místo původních bajtů vykonal náhradní skok.

Obraz stavu proto popisuje procesor bezprostředně po skoku do zachycovací cesty
monitoru, zatímco viditelná ohnisková adresa popisuje logické místo, na němž se
uživatel chtěl zastavit.

PROMETHEUS se nesnaží předstírat, že přepsaná instrukce byla vykonána. Zastaví se
před původními bajty a obnoví je pro případnou pozdější prohlídku nebo vykonání.

## Režimy selhání jednoduchého softwarového breakpointu

Návrh je kompaktní, ale je třeba rozumět jeho hranicím.

### Program nemusí breakpointu nikdy dosáhnout

Nativní JP opustí scratch trampoline natrvalo. Pokud uživatelský program začne
jinde cyklit, zhroutí se, znemožní užitečný vstup, přepíše breakpoint nebo skočí
do ROM, PROMETHEUS automaticky nezíská řízení zpět.

Protože se úklid provede až poté, co se `breakpointHitCaptureEntry` vrátí přes
uložené pokračování monitoru, zůstávají do té doby vytlačené bajty patchované.

### Existuje pouze jeden slot breakpointu

`savedBreakpointOriginalBytes` uchovává jedinou tříbajtovou posloupnost.
Neexistuje pole záznamů breakpointů ani příznak aktivity. Tento mechanismus
nepodporuje několik současných softwarových breakpointů.

### Program může patch změnit

Běžící kód má obyčejný přístup do paměti. Dočasný JP může záměrně nebo náhodně
přepsat. Monitor během nativního běhu zápisy netrasuje.

### Přerušení mohou změnit cestu

Uložený stav DI/EI se použije před nativním skokem. Jsou-li přerušení povolena,
může proběhnout rutina přerušení. Je to součást uživatelova strojového prostředí,
ale zároveň to znamená, že cesta k breakpointu není izolovaná.

### Účinky na stack a hardware jsou skutečné

Na rozdíl od simulovaného experimentu může nativní kód bez kontroly každé
instrukce používat stack, porty, režim přerušení i paměť. Zachycení stavu
zaznamená výsledné registry procesoru; vnější účinky vrátit nedokáže.

## Proč je instalace patche chráněná, ale obnova přímá

Tři bajty breakpointu se instalují přes `emitByteAtAssemblyOutput` a
`emitWordBCAtAssemblyOutput`. Tyto rutiny provádějí bezpečnostní kontroly výstupu
assembleru.

Obnova používá přímé `LDIR`.

Na první pohled může tato asymetrie působit neopatrně. Vychází z prosté
skutečnosti: pokud byla instalace na dané adrese přijata, má být možné obnovit
bajty na tutéž adresu. Adresa stále leží na stacku monitoru; žádný nový cíl se
nevybírá.

Přímé kopírování je kratší a při úklidu nenarušuje stav výstupního emitteru.

Teoretické riziko přesto existuje, pokud běžící program před dosažením
breakpointu změní systémové hranice paměti nebo jinak zneplatní předpoklady.
PROMETHEUS je kompaktní monitor, ne chráněný operační systém.

## Jeden společný builder, dva různé sliby

Nativní CALL a běh k breakpointu sdílejí
`executeNativeCallOrJumpThroughTrampoline`, ale jejich sliby o toku řízení se
liší.

### Slib nativního CALL

```text
CALL target
    target nakonec vykoná RET
    RET se vrátí na sekvenční zachycovací skok ve scratch RAM
```

### Slib běhu k breakpointu

```text
JP start
    program nakonec dosáhne patchované adresy
    patchovaný JP dosáhne vstupu zachycení breakpointu
```

Společný builder potřebuje jen opcode a cíl:

```text
$CD + target  pro CALL
$C3 + start   pro JP
```

Za přípravu cesty zpět odpovídá volající.

Jde o elegantní rozdělení. Builder trampoline nemusí vědět, co podprogram
znamená ani jak byl breakpoint nainstalován. Zapíše instrukci přenosu řízení a
standardní výstupy zachycení. Vyšší příkazy vytvoří odpovídající podmínku návratu.

## Nativní volání uvnitř trasování

Kapitola 48 se k nativnímu vykonávání vrátí v jemnější podobě. PROMETHEUS lze
nastavit tak, aby vybrané trasované instrukce CALL nebo RST nechal běžet přímo:

- NON: žádný cíl CALL/RST není přímý;
- DEF: přímé jsou pouze adresy v seznamu přímých volání;
- ALL: přímý je každý cíl CALL/RST.

Platí stejný kompromis:

- přímé vykonávání je mnohem rychlejší;
- jednotlivé instrukce volaného těla se nekontrolují;
- jeho T states se nepřičítají přesně;
- řízení se získá zpět teprve při návratu.

Explicitní příkaz SYMBOL SHIFT+H je nejjasnějším úvodem, protože uživatel přímo
žádá o jedno nativní volání. Později bude trasovací engine rozhodovat, zda
podobnou volnost použije pro dekódovaný CALL/RST.

## Porovnání tří způsobů vykonávání kódu

PROMETHEUS nyní nabízí tři obecné styly vykonávání:

| Styl | Kdy získá řízení zpět | Kontroly ochrany | Přehled o časování |
|---|---|---|---|
| vykonání jednoho kroku ve scratch oblasti | po jedné instrukci | pro každou dekódovanou instrukci | modelováno pro každou instrukci |
| nativní CALL podprogramu | když se podprogram vrátí | ne uvnitř těla | tělo se nepočítá |
| nativní běh k breakpointu | po dosažení patchované adresy | ne během běhu | běh se nepočítá |

Žádný není nejlepší ve všech situacích.

- Single-step je pomalý, ale pozorovatelný.
- Nativní CALL je užitečný pro důvěryhodné servisní rutiny.
- Běh k breakpointu se hodí k překonání dlouhé oblasti plnou rychlostí.

Monitor dává uživateli na výběr, místo aby každý problém nutil do jediného
mechanismu vykonávání.

## Malý příklad

Předpokládejme tento uložený stav:

```text
PC/current = $8000
SP         = $9000
A          = $05
interrupts = DI
```

Důvěryhodný podprogram na `$8200` zvýší A a vrátí se.

SYMBOL SHIFT+H s cílem `$8200` sestaví:

```text
$F3                 DI
$CD $00 $82         CALL $8200
$C3 <seq capture>   JP sequential capture
$C3 <taken capture> JP taken capture
```

Obnova aktivuje SP `$9000`. CALL zapíše svou návratovou adresu do scratch oblasti
na `$8FFE..$8FFF`, spustí podprogram a RET tuto adresu vyzvedne. Zachycení potom
uloží A=`$06` a znovu SP=`$9000`.

Pro běh k breakpointu si představme:

```text
W start       = $8000
current break = $8100
```

PROMETHEUS změní bajty na `$8100..$8102` na JP do zachycení, obnoví tentýž stav a
skočí na `$8000`. Dosáhne-li program `$8100`, uložený obraz se aktualizuje a
původní tři bajty se obnoví.

Uživatel pak může stroj v místě zastavení prozkoumat.

## Zpět k celému stroji

Kapitola 43 dala PROMETHEU dveře mezi obrazem v paměti a skutečným Z80. Tato
kapitola ukázala dva způsoby, jak dveřmi projít, aniž by se jimi program hned po
jednom kroku vracel:

```text
uložený obraz
    -> skutečný Z80
       -> důvěryhodný CALL a RET
       -> zachycení

uložený obraz
    -> skutečný Z80
       -> nativní JP a volný běh
       -> dočasný JP breakpointu
       -> zachycení
```

Obě cesty závisejí na drobném scratch programu. Příští kapitola tento program
prozkoumá jako znovupoužitelný kus generovaného strojového kódu.

## Co se změnilo v paměti

Nativní volání podprogramu může změnit:

- všechny uložené registry a flags;
- obsah uživatelova stacku během CALL;
- libovolnou paměť nebo hardware, kterých se podprogram dotkne;
- zapamatovaný stav přerušení po zachycení.

Běh k breakpointu navíc dočasně mění:

- tři bajty na adrese breakpointu;
- `savedBreakpointOriginalBytes`;
- bezprostřední operand na `varcBreakpointRunStartAddress`, když se použije W.

Po úspěšném zásahu breakpointu se původní tři bajty obnoví.

## Důležité nalezené labely

- `monCallSubroutineWithSavedState`
- `executeNativeCallOrJumpThroughTrampoline`
- `monSetBreakpointRunStartOrExecute`
- `monRunToTemporaryBreakpoint`
- `varcBreakpointRunStartAddress`
- `savedBreakpointOriginalBytes`
- `copyThreeBytesFromHLToDE`
- `emitByteAtAssemblyOutput`
- `emitWordBCAtAssemblyOutput`
- `breakpointHitCaptureEntry`
- `captureUserStateAfterSequentialFlow`
- `restoreUserStateAndExecuteTrampoline`

## Myšlenky potřebné v dalších kapitolách

- Scratch program může začínat skutečným CALL nebo skutečným JP.
- Cestou zpět může být normální RET do scratch RAM nebo patchovaný JP na adrese
  breakpointu.
- Nativní vykonávání se záměrně vzdává ochrany a časování po jednotlivých
  instrukcích.
- Stack monitoru může zůstat nečinný, zatímco je aktivní uživatelův SP, a
  společný serializer zachycení jej potom obnoví.
- Standardní výstupy zachycení dovolují několika vykonávacím příkazům sdílet
  jediný mechanismus ukládání stavu.
