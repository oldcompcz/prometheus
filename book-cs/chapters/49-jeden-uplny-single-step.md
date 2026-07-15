# Kapitola 49: Jeden úplný single-step

Část VI sestavila krokovací engine zdola nahoru. Viděli jsme uložený obraz
procesoru, scratch program, dva zachycovací výstupy, přepis toku řízení, predikci
paměťových přístupů, časování a trasovací smyčky. Každý mechanismus je sám o sobě
natolik malý, že mu lze porozumět, ale úplná operace přesto prochází několika
bankami registrů, stacky a dočasnými reprezentacemi.

Je čas vrátit se nahoru.

Tato kapitola sleduje jednu instrukci od panelu monitoru až do okamžiku, kdy je
panel připraven k novému vykreslení. Příklad je záměrně převzat z malého programu,
který nás provází od kapitoly 2:

```asm
        ORG 32768
START   LD B,5
LOOP    DJNZ LOOP
        RET
        ENT START
```

Předpokládejme, že program už vykonal `LD B,5` a několik iterací smyčky. Uložený
stav nyní obsahuje:

```text
současná adresa      $8002
B                    2
instrukce            10 FE      DJNZ $8002
uložená přerušení    DI
součet T-stavů       $0120      ilustrativní předchozí součet
```

Následující instrukce sníží B. Protože výsledkem bude 1, větev se provede zpět na
`$8002`.

PROMETHEUS tento výsledek předem nezná. Právě o to jde. Skutečný Z80 musí provést
snížení a rozhodnout o větvení podle vlastního registru B. Úkolem monitoru je
připravit podmínky tak, aby se obě možná rozhodnutí bezpečně vrátila.

## Celá operace v jednom pohledu

Než sestoupíme k podrobnostem, zde je úplná cesta:

```text
současná adresa monitoru $8002
        ↓
dekóduj 10 FE jako DJNZ s displacementem -2
        ↓
ulož sekvenční PC $8004 a základní časování
        ↓
ověř, že je vykonání dovoleno
        ↓
sestav scratch kód začínající uloženým DI
        ↓
přepiš displacement zkopírovaného DJNZ z -2 na +3
        ↓
ulož logické PC provedené větve $8002 a její časování
        ↓
obnov všechny uložené uživatelské registry a uživatelský SP
        ↓
skutečný Z80 vykoná DJNZ ve scratch RAM
        ↓
B se změní na 1, takže fyzická větev zvolí zachycení provedené cesty
        ↓
zachyť úplný stav procesoru
        ↓
ověř logické výsledné PC proti ochraně RUN
        ↓
potvrď PC $8002 a časování provedené větve
        ↓
vrať v carry politiku překreslení
```

Základní oddělení je vidět už zde:

```text
fyzická cesta vykonání     scratch RAM
logická cesta programu     z $8002 zpět na $8002
```

PROMETHEUS dovoluje, aby první cesta byla umělá, a druhá tak mohla zůstat věrná.

## Vstup přes současnou adresu monitoru

Ruční krok, pomalé trasování i rychlé trasování vstupují do stejného malého
wrapperu:

```asm
stepAtCurrentMonitorAddress:
    ld hl,(varcMonitorCurrentAddress+1)
```

Současná adresa je uložena v bezprostředním operandu, jak vysvětlila kapitola 5.
Jejím načtením do HL dostane společný engine svůj jediný formální vstup:

```text
HL = adresa instrukce, která se má vykonat
```

Wrapper přejde přímo do `stepInstructionAtHL`.

Je to užitečná architektonická volba. Jádro enginu se nezajímá, zda je vyvolal:

- jeden ruční krok;
- smyčka pomalého trasování;
- smyčka rychlého trasování;
- jiný interní volající, který už má adresu v HL.

Rozdíl mezi těmito režimy se projeví až po návratu z kroku.

## Fáze 1: dekódování bez vykonání

Řadič začne uložením původní adresy a zavolá stejný dekodér, který používají
výpisy a obrácené disassemblování:

```asm
stepInstructionAtHL:
    push hl
    call decodeInstructionAtHL
    ex af,af'
    jp nz,startMonitor
```

Pro naše dva bajty:

```text
$8002  $10
$8003  $FE
```

`decodeInstructionAtHL` zjistí:

```text
rodina instrukce        relativní větev DJNZ
sekvenční adresa        $8004
surový operand          $00FE
délka instrukce         2
základní časování       časování neprovedené větve
metadata opcode/prefix  kompaktní hodnoty deskriptoru
platnost                 platná
```

Dekodér vrátí v HL adresu následující za instrukcí. Ta je užitečnější než
samostatná délka, protože délku lze později získat odečtením:

```text
$8004 - $8002 = 2 bajty
```

Flags platnosti se přesunou do alternativního AF pomocí `EX AF,AF'`. Živý registr
A bude vzápětí potřeba pro časování a práci s deskriptory, ale výsledek dekódování
musí přežít. Neznámá instrukce způsobí okamžitý teplý návrat do monitoru.
PROMETHEUS zobrazí neznámé bajty jako `DEFB`; nebude je slepě vykonávat.

## Fáze 2: vytvoření neutrálního sekvenčního stavu

Než řadič zjistí, zda jde o větev, připraví neškodný výchozí stav:

```asm
    ld (varcSequentialNextAddress+1),hl
    ld (varcTakenFlowNextAddress+1),hl
    ld (varcDecodedInstructionOperandWord+1),de
```

Pro náš příklad:

```text
sekvenční následující adresa = $8004
adresa provedené větve       = zpočátku $8004
surový operand               = $00FE
```

Proč se obě adresy inicializují stejnou hodnotou?

Většina instrukcí žádnou provedenou větev nemá. Ani podmíněná instrukce nemusí
později odpovídat zvláštnímu handleru. Když oba výstupy dostanou sekvenční
adresu, vznikne bezpečný neutrální stav:

```pseudocode
sequentialPC = decodedAddressAfterInstruction
takenPC      = sequentialPC
```

Handler toku řízení změní `takenPC` pouze tehdy, je-li to nutné.

Surový operand se rovněž uloží do bezprostředního slova. Predikce paměťových
adres a přepis toku řízení jej pak mohou použít i poté, co byly dočasné hodnoty
registrů dekodéru využity k jiným účelům.

## Fáze 3: zapamatování čistého chybového stavu

Řadič dále uchová metadata dekodéru a zapamatuje si současnou uloženou hodnotu R:

```asm
    push bc
    ld a,(savedRegisterR)
    ld (varcRestoreRBeforeOperationError+1),a
    call validateInstructionBeforeExecution
```

Samotné dekódování načítalo bajty instrukce, a tím narušilo fyzický refresh
registr Z80. Když validace instrukci odmítne, monitor chce zobrazit uloženou
uživatelskou hodnotu R, nikoli hodnotu znečištěnou vlastní kontrolní prací.
Samomodifikovaný obnovovací operand poskytuje chybové cestě bod návratu.

Validace klade několik otázek:

1. Je to přesně `HALT`, zatímco uložený stav je DI?
2. Jsou zapnuté kontroly instrukcí?
3. Předpovídá instrukce chráněné READ?
4. Předpovídá chráněné WRITE?
5. Jde o opakovanou blokovou instrukci vyžadující kontrolu celých rozsahů?

`DJNZ` nečte uživatelskou paměť ani do ní nezapisuje. Není to HALT. Validační
cesta se proto vrátí bez námitky.

Stále jde o kontrolu před vykonáním. Žádný uživatelský registr ani uživatelská
paměť se dosud nezměnily.

## Fáze 4: obnovení původní adresy

Původní adresa instrukce byla před dekódováním uložena na stack. Po validaci ji
řadič obnoví do DE:

```asm
    pop bc
    pop de
    push bc
    call buildInstructionExecutionTrampoline
```

Důležité hodnoty nyní pojmově jsou:

```text
DE = $8002       původní fyzická adresa
HL = $8004       zapamatovaná odděleně v patchovaném kódu
BC = metadata dekodéru
```

Metadata zůstávají na stacku, zatímco se sestavuje scratch program.

## Fáze 5: sestavení neutrálního scratch programu

`buildInstructionExecutionTrampoline` odečte původní adresu od sekvenční adresy:

```text
$8004 - $8002 = 2
```

Potom zavolá `beginExecutionTrampoline`. Uložená přerušení jsou DI, takže prvním
scratch bajtem se stane `$F3`:

```asm
DI
```

Za něj se zkopírují původní dva bajty instrukce:

```text
F3 10 FE
```

Nakonec builder připojí dva absolutní skoky:

```text
JP captureUserStateAfterSequentialFlow
JP captureUserStateAfterTakenFlow
```

V této neutrální fázi workspace vypadá takto:

```text
scratch+0   F3             DI
scratch+1   10 FE          DJNZ -2        zkopírováno beze změny
scratch+3   C3 ss ss       JP sekvenční zachycení
scratch+6   C3 tt tt       JP zachycení provedené větve
```

Kdyby šlo o obyčejnou aritmetickou instrukci, byl by scratch program nyní
připraven. Propadnutí pokračováním by dosáhlo skoku do sekvenčního zachycení.
Pouhé zkopírování relativní větve beze změny je však nebezpečné.

Na původní adrese znamená displacement `$FE`:

```text
$8004 - 2 = $8002
```

Ve scratch RAM by znamenal „dva bajty před sekvenčním scratch PC“, což je zcela
jiná adresa. Větev potřebuje fyzický scratch cíl a oddělený logický cíl programu.

## Fáze 6: klasifikace toku řízení

Řadič hledá v `controlFlowDescriptorTable` pomocí kompaktních metadata opcode a
prefixu z dekodéru:

```asm
    ld hl,controlFlowDescriptorTable
    call matchInstructionAccessDescriptor
```

`DJNZ` odpovídá rodině relativního toku řízení. Vrácený malý index vybere offset
v `tracedControlFlowHandlerOffsets` a ten vede do `simulateRelativeControlFlow`.

Tento mechanismus je záměrně užší než emulátor Z80. Engine nemá zvláštní handler
pro `INC B`, `ADD HL,DE` ani `XOR A`; skutečný procesor je dokáže vykonat beze
změny. Handler potřebuje pouze proto, že `DJNZ` obsahuje fyzický vztah k PC, který
se zkopírováním změní.

## Fáze 7: přepis fyzické větve a zachování logické větve

Handler relativního toku provede dva odlišné výpočty.

Nejprve změní zkopírovaný displacement na `+3`:

```text
sekvenční scratch PC po DJNZ = scratch+3
začátek JP provedené větve   = scratch+6
potřebný displacement        = +3
```

Scratch bajty se změní na:

```text
F3 10 03 C3 ss ss C3 tt tt
```

Skutečný Z80 má nyní dva bezpečné fyzické výsledky:

```text
DJNZ bez skoku -> propadne do JP sekvenčního zachycení
DJNZ se skokem -> skočí +3 na JP zachycení provedené větve
```

Za druhé handler vypočítá původní logický cíl. Uložený surový bajt `$FE` se
znaménkově rozšíří na -2 a přičte k původnímu sekvenčnímu PC:

```text
$8004 + (-2) = $8002
```

Výsledek se zapíše do `varcTakenFlowNextAddress`.

Handler také přičte rozdíl časování provedené větve. U `DJNZ` je základní cena
neprovedené cesty 8 T-stavů a provedená cesta přidává 5:

```text
sekvenční časování = 8
časování větve     = 13
```

Nakonec vybere `noPostFlowStackAdjustment`, protože relativní větev nemění
uživatelský stack.

Scratch cesta a logický výsledek jsou nyní úplně odděleny:

```text
fyzický cíl provedené větve = zachycovací stub ve scratch RAM
logický cíl provedené větve = $8002
```

## Fáze 8: obnovení uživatelského procesoru

Řadič zavolá:

```asm
restoreUserStateAndExecuteTrampoline
```

Tato rutina nejprve upraví uložené R o známá načtení instrukcí, která právě
nastanou, a uloží současný SP monitoru do patchované instrukce `LD SP,nn`. Tato
patchovaná instrukce je nití vedoucí zpět domů; jakmile se aktivuje uživatelský
SP, běžný call stack monitoru už není dostupný.

Potom nastaví SP na `savedRegisterR` a obnoví uživatelský obraz pečlivě seřazenou
řadou POPů:

```text
R a I
alternativní BC', DE', HL', AF'
IY a IX
primární BC, DE, HL, AF
uživatelský SP
```

V našem příkladu dostane primární B hodnotu 2. Fyzický Z80 nyní obsahuje
uživatelský stav, nikoli dočasný stav monitoru.

Rutina skočí do scratch workspace. Nevolá jej pomocí CALL. CALL by vložil
návratovou adresu monitoru na uživatelský stack a instrukce by tak pozorovala
vymyšlené stackové slovo.

## Fáze 9: skutečný Z80 rozhodne

Scratch program začíná:

```asm
DI
DJNZ +3
```

`DI` obnoví uloženou politiku přerušení. Nemění běžné flags používané instrukcí
`DJNZ`.

Skutečný `DJNZ` nyní vykoná svou architektonickou práci:

1. B se změní z 2 na 1.
2. Procesor ověří, zda je B nulový.
3. B není nulový, takže relativní větev se provede.
4. Displacement +3 přeskočí JP sekvenčního zachycení.
5. Vykonávání dosáhne JP zachycení provedené větve.

Žádná rutina PROMETHEA nevypočítala `B-1` ani nenapodobovala podmínku větvení.
Obojí provedl skutečný Z80.

To je jádro návrhu:

> Přepiš místo, kam se řízení vrátí, ale nepřepisuj význam instrukce.

## Fáze 10: vstup do zachycení provedené cesty

Provedený skok dosáhne `captureUserStateAfterTakenFlow`.

Prvním úkolem je zachovat uživatelský SP dříve, než se použije jakýkoli stack
zachycení. Rutina potom shromáždí AF a důkazy o I a R, zakáže přerušení a uloží
primární registry, které jsou stále živé.

Dodá tři výsledky specifické pro tuto cestu:

```text
příznak cesty     1
časování          13
logické PC        $8002
```

Tyto hodnoty pocházejí z patchovaných operandů:

```asm
varcTakenFlowTStates:
    ld de,00000h
varcTakenFlowNextAddress:
    ld hl,00000h
```

Handler relativního toku je vyplnil před vykonáním.

Společný serializer uloží zbytek primárních a alternativních registrů, IX, IY,
I, R a SP do obrazu uspořádaného jako stack. B=1 je nyní uloženo v
`savedRegisterB`. Potom obnoví SP monitoru z
`varcRestoreMonitorStackAfterExecution` a rekonstruuje uloženou booleovskou
hodnotu přerušení z flagových důkazů zachycených pomocí `LD A,I` a `LD A,R`.

Fyzický Z80 je znovu strojem monitoru. Uživatelský stroj včetně nové hodnoty B
žije v paměti.

## Fáze 11: kontrola výsledné adresy vykonávání

Zachycovací rutina se vrátí řadiči. Výsledné logické PC se získá a při zapnutých
kontrolách instrukcí ověří proti `setExecutionProtectedAreas`:

```text
kandidátní PC = $8002
```

Tato kontrola probíhá až po vykonání. Na historickém pořadí záleží. Kdyby byla
adresa `$8002` chráněná, PROMETHEUS by ohlásil `Run ERROR` a odmítl potvrdit novou
současnou adresu i časování, ale B by už v uloženém obrazu mělo hodnotu 1. Už by
nastaly i případné vedlejší účinky na paměť nebo stack.

V našem příkladu je `$8002` povolena.

## Fáze 12: použití případné logické opravy stacku

Příznak cesty je nenulový, protože bylo použito zachycení provedené větve. Řadič
proto zavolá samomodifikovaný callback po toku:

```asm
varcPostTakenControlFlowCallback:
    call nz,noPostFlowStackAdjustment
```

U `DJNZ` je callback prázdná rutina. Simulovaný CALL by nahradil scratch
návratové slovo původním sekvenčním PC. Simulovaný RET by posunul uložený SP o
dva. Řadič zde nepotřebuje další test opcode; callback už dříve vybral handler
toku řízení.

## Fáze 13: potvrzení PC a času

Teprve po kontrole RUN a případné opravě stacku řadič krok potvrdí:

```asm
    ld (varcMonitorCurrentAddress+1),hl
    ld hl,(accumulatedTStates)
    add hl,de
    ld (accumulatedTStates),hl
```

Nový viditelný stav je:

```text
současná adresa      $8002
B                    1
součet T-stavů       starý součet + 13
```

Současná adresa se zdánlivě nezměnila, protože smyčka větví sama na sebe.
Procesorový stav dokazuje, že k postupu došlo: B se snížilo a čas se posunul.

Proto debugger nemůže pokládat „stejné PC“ za „nic se nestalo“.

## Fáze 14: vrácení politiky překreslení v carry

Řadič propadne do `testCapsShiftEnter`. Tato rutina znovu používá ROM logiku
klávesy BREAK s vybraným řádkem ENTER. Výsledek v carry znamená:

```text
carry set     běžný případ; volající může překreslit podle svého režimu
carry clear   držen CAPS SHIFT+ENTER; změň politiku zobrazení automatického trasování
```

Ruční volající může výsledek jednoduše použít. Pomalé trasování překresluje při
carry set. Rychlé trasování při carry clear. Samotný krokovací engine neví, která
smyčka jej vyvolala.

Procesor je nyní připraven na další instrukci nebo na nové vykreslení panelu.

## Co kdyby B mělo hodnotu 1?

Scratch program by byl totožný:

```text
DI
DJNZ +3
JP sekvenční zachycení
JP zachycení provedené větve
```

Skutečný Z80 by snížil B z 1 na 0 a větev by neprovedl. Vykonávání by propadlo do
JP sekvenčního zachycení.

Tato zachycovací cesta dodává:

```text
příznak cesty     0
časování          8
logické PC        $8004
```

Callback se nezavolá, protože příznak cesty je nulový. Potvrzený stav by byl:

```text
B                    0
současná adresa      $8004
přičtené časování    8
```

Stejný vygenerovaný kód tedy obslouží oba výsledky. PROMETHEUS připravuje
možnosti; hardware vybírá skutečnost.

## Co kdyby validace selhala?

Předpokládejme, že by instrukcí bylo `LD (HL),A` a uložený HL ukazoval do
chráněného okna WRITE.

Cesta by se zastavila před vykonáním scratch programu:

```text
dekóduj
předpověz efektivní adresu z uloženého HL
najdi kolizi s chráněným WRITE
obnov uložené R pro zobrazení
ukaž Read/Write ERROR
vrať se do monitoru
```

Uživatelský obraz procesoru by se neobnovil ani nevykonal.

HALT při uloženém DI se odmítá ve stejné fázi před vykonáním, i když je běžný
přepínač kontrol instrukcí vypnutý.

## Co kdyby bylo výsledné PC chráněné?

Větev může projít všemi kontrolami READ a WRITE, ale zvolit chráněnou adresu RUN.
Protože implementace kontroluje RUN až po zachycení:

```text
instrukce se vykoná
stav se zachytí
kandidátní PC koliduje s oknem RUN
objeví se Run ERROR
PC a čas se nepotvrdí
ostatní vedlejší účinky mohou zůstat
```

Není to čistá transakce, jakou bychom možná navrhli dnes. Je to chování původního
programu, a tedy součást rekonstrukce.

## Řadič v prostém pseudokódu

Úplný engine lze nyní zapsat bez šumu registrů:

```pseudocode
function step(address):
    decoded = decode(address)
    if decoded je neznámá:
        return do monitoru

    sequentialPC = decoded.nextAddress
    takenPC = sequentialPC
    operand = decoded.rawOperand
    baseTime = decoded.time

    rememberSavedRForErrorPath()
    validateHaltAndPredictedMemoryAccess(decoded)

    scratch = beginWithSavedDIorEI()
    scratch.copy(decoded.bytes)
    scratch.appendJump(sequentialCapture)
    scratch.appendJump(takenCapture)

    callback = noStackAdjustment
    takenTime = baseTime

    if decoded je dangerousControlFlow:
        rewriteScratchControlFlow(decoded, scratch)
        takenPC = calculateOriginalLogicalTarget(decoded)
        takenTime = calculateTakenTiming(decoded)
        callback = chooseCallOrReturnStackRepair(decoded)

    restoreCompleteUserProcessor()
    executeScratchOnRealZ80()
    result = captureCompleteUserProcessor()

    if controlsEnabled and result.logicalPC je chráněné RUN:
        showRunErrorAfterSideEffects()

    if result.usedTakenPath:
        callback()

    currentAddress = result.logicalPC
    accumulatedTime += result.pathTime
    return capsShiftEnterDisplayPolicy()
```

Tento pseudokód je delší než ústřední zdrojová rutina, protože mnoho detailů je
stlačeno do tabulek, samomodifikovaných operandů a sdílených helperů. Jeho tvar je
však přímočarý.

## Proč to není emulátor

Emulátor by implementoval význam každé instrukce softwarově:

```pseudocode
B = B - 1
if B != 0:
    PC = PC + signedDisplacement
```

PROMETHEUS místo toho sestaví:

```asm
DJNZ +3
JP sequentialCapture
JP takenCapture
```

Fyzický Z80 provede snížení a rozhodnutí. PROMETHEUS dodá bezpečná místa, na
která se oba výsledky mohou ohlásit.

Monitor emuluje pouze kontext, který by prosté kopírování narušilo:

- fyzické cíle relativní k PC;
- absolutní tok do nekontrolované paměti;
- stackovou sémantiku CALL a RET;
- předpovídané chráněné rozsahy paměti;
- potvrzení logického časování a PC.

Toto rozdělení práce udržuje engine dostatečně kompaktní pro Spectrum a současně
zachovává skutečné chování procesoru pro běžnou aritmetiku, flags a paměťové
operace.

## Zpět k celému stroji

Část VI začala hodnotou registru na čelním panelu, která pasivně ležela v paměti.
Úplný krok nyní propojuje všechny vrstvy:

```text
současná adresa na čelním panelu
    -> společný disassembler
    -> metadata instrukce
    -> predikce ochrany
    -> vygenerované scratch bajty
    -> obnovený uložený procesor
    -> skutečné vykonání Z80
    -> zachycený uložený procesor
    -> oprava logického toku řízení
    -> politika RUN
    -> potvrzené PC a čas
    -> překreslení čelního panelu
```

Monitor tedy může na jednu instrukci půjčit celý stroj jinému programu a
spolehlivě si jej vzít zpět.

Tím je vykonávací engine dokončen. Nyní se můžeme obrátit k začátku zdrojového
souboru a porozumět jinému druhu dočasného odevzdání stroje: než může PROMETHEUS
cokoli editovat nebo trasovat, musí jeho instalační obraz zjistit, kam byl
načten, přesunout malý instalátor na `$5000`, zkopírovat zvolené rezidentní tělo
a opravit každou interní absolutní adresu.

## Co se změnilo v paměti

Při úspěšném kroku s provedeným `DJNZ` se změní:

- scratch workspace, nejprve na DI + zkopírovanou instrukci + zachycovací skoky
  a potom přepisem relativního toku;
- samomodifikované operandy sekvenčního a provedeného PC;
- samomodifikované operandy základního a provedeného časování;
- operand callbacku po toku;
- úplný uložený obraz procesoru, zejména B, R, stav přerušení a SP;
- současná adresa monitoru, přestože shodou okolností zůstane `$8002`;
- akumulovaný počet T-stavů.

Instrukce nezmění uživatelskou paměť ani uživatelský SP.

## Důležité labely, s nimiž jsme se setkali

- `stepAtCurrentMonitorAddress`
- `stepInstructionAtHL`
- `decodeInstructionAtHL`
- `varcSequentialNextAddress`
- `varcTakenFlowNextAddress`
- `varcDecodedInstructionOperandWord`
- `varcRestoreRBeforeOperationError`
- `validateInstructionBeforeExecution`
- `buildInstructionExecutionTrampoline`
- `controlFlowDescriptorTable`
- `matchInstructionAccessDescriptor`
- `tracedControlFlowHandlerOffsets`
- `simulateRelativeControlFlow`
- `varcTakenFlowTStates`
- `varcPostTakenControlFlowCallback`
- `restoreUserStateAndExecuteTrampoline`
- `captureUserStateAfterSequentialFlow`
- `captureUserStateAfterTakenFlow`
- `setExecutionProtectedAreas`
- `noPostFlowStackAdjustment`
- `accumulatedTStates`
- `testCapsShiftEnter`

## Myšlenky potřebné v dalších kapitolách

- PROMETHEUS odděluje fyzický scratch tok od logického toku uživatelského
  programu.
- Společný dekodér dodává následující adresu, operand, metadata a základní
  časování.
- Validace před vykonáním předpovídá nebezpečné paměťové účinky bez vykonání
  instrukce.
- Handlery toku řízení přepisují pouze fyzické návratové cesty a logické opravy.
- Skutečný Z80 vybírá sekvenční nebo provedené zachycení podle skutečného stavu
  registrů a flags.
- Zachycení serializuje úplný procesor dříve, než se vrátí stack monitoru.
- Ochrana RUN se historicky kontroluje až po vykonání.
- PC a časování se potvrdí teprve po kontrolách a případné simulované opravě
  stacku.
