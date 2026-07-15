# Kapitola 5: Když je kód zároveň daty

Většina programátorů se učí rozdělovat paměť na dvě říše.

V jedné žije kód: instrukce, které procesor vykonává.

Ve druhé žijí data: čísla, znaky, adresy a stav, které instrukce čtou nebo mění.

PROMETHEUS tuto hranici často odmítá udržovat uklizenou. Instrukce může být spustitelným kódem a současně místem, kde je uložena trvalá proměnná. `CALL` může být obyčejným voláním, jehož cíl se později nahradí. `JP` může sloužit jako pokračovací hook. Okamžité slovo uvnitř `LD HL,nn` může uchovávat zapamatovaný ukazatel.

Této technice se říká **samomodifikující kód**, protože program mění bajty, které patří jeho vlastním instrukcím.

Tento výraz může znít nezodpovědně. V PROMETHEU jde většinou o ukázněný postup. Měněné bajty mají pojmenované labely, známou šířku a pečlivě omezený význam. Program nepřepisuje sám sebe náhodně. S vybranými operandy instrukcí zachází jako s kompaktními proměnnými.

## Proměnná ukrytá uvnitř instrukce

Nejjednodušším příkladem je zapamatovaný ukazatel:

```asm
varcAssemblyOutputPointer:
    ld hl,00000h
```

Při vykonání tato instrukce načte do `HL` současný fyzický cíl pro sestavované bajty.

Jinde program aktualizuje její dvoubajtový operand:

```asm
ld (varcAssemblyOutputPointer+1),de
```

Label označuje bajt opcode. Přičtením jedné se dostaneme k prvnímu bajtu okamžitého slova.

Paměť tedy obsahuje:

```text
adresa varcAssemblyOutputPointer     opcode instrukce LD HL,nn
adresa + 1                           dolní bajt zapamatovaného ukazatele
adresa + 2                           horní bajt zapamatovaného ukazatele
```

Je-li ukazatel `$9000`, vypadají bajty instrukce pojmově takto:

```text
21 00 90
```

kde `$21` je opcode instrukce `LD HL,nn`.

Až se vykonávání k této instrukci dostane příště, zapamatovaná hodnota se načte přímo do `HL`.

Ve vyšším pseudokódu odpovídá účinek tomuto zápisu:

```text
assemblyOutputPointer = DE
...
HL = assemblyOutputPointer
```

PROMETHEUS ukládá proměnnou do instrukce, která ji spotřebovává.

## Proč to dělat místo obyčejného slova?

Obyčejný návrh by mohl vyhradit:

```asm
assemblyOutputPointer:
    defw 00000h
```

a načítat je pomocí:

```asm
ld hl,(assemblyOutputPointer)
```

To je zcela rozumné řešení. Samomodifikující varianta však na malém stroji se Z80 nabízí několik výhod:

- uložené slovo je už součástí instrukce, kterou rutina potřebuje;
- jeho načtení nevyžaduje další nepřímý přístup do paměti;
- instrukce a její stav zůstávají pohromadě;
- cíl callbacku lze změnit bez samostatného dispatcheru;
- kód může být menší nebo rychlejší.

PROMETHEUS obsahuje mnoho takových stavových buněk. Rekonstruované labely používají prefix `varc`, který čtenáře upozorňuje, že následující instrukce je zároveň zapisovatelným stavem.

Prefix lze číst jako:

> variable carried by code — proměnná nesená kódem

Je to konvence rekonstrukce, ale velmi užitečná.

## Logická adresa a fyzická adresa

Assembler udržuje dva související ukazatele:

```asm
varcAssemblyOutputPointer:
    ld hl,00000h

varcAddressCounter:
    ld hl,00000h
```

Zpočátku obvykle postupují společně.

**Fyzický výstupní ukazatel** říká, kam se v RAM zapíše následující bajt.

**Logické počitadlo adresy** říká, jakou adresu tomuto bajtu přisuzuje sestavovaný program. Je to hodnota představovaná symbolem současné adresy `$` a používaná při definování labelů.

Za normálních okolností platí:

```text
fyzický výstup = logická adresa
```

Direktivy jako `PUT` však mohou obě hodnoty rozdělit. Program lze sestavovat tak, jako by patřil na jednu adresu, zatímco jeho bajty se ukládají jinam.

Emitter bajtů tento rozdíl ukazuje přímo:

```asm
emitByteAtAssemblyOutput:
    ld de,ENTRY_POINT_WITH_MONITOR
varcAssemblyOutputPointer:
    ld hl,00000h
    ...
    ld (de),a
    inc de
    ld (varcAssemblyOutputPointer+1),de
varcAddressCounter:
    ld hl,00000h
    inc hl
    ld (varcAddressCounter+1),hl
    ret
```

V próze:

```text
ověř, že fyzický cíl je bezpečný
zapiš tam A
posuň a zapamatuj fyzický cíl
načti, posuň a zapamatuj logickou adresu
```

Obě zapamatovaná slova žijí v operandech instrukcí, které je načítají.

Nejde jen o trik šetřící místo. Tímto uspořádáním se přímo vyjadřuje architektura assembleru.

## Instrukce si může pamatovat jeden bajt

Ne všechny samomodifikované hodnoty jsou adresy. Mechanismus opakování klávesy ukládá šestnáctibitové počitadlo prodlevy i osmibitový kód opakované klávesy:

```asm
varcHeldKeyRepeatScanCounter:
    ld hl,00000h
    inc hl
    ld (varcHeldKeyRepeatScanCounter+1),hl

varcRepeatedKeyCode:
    ld a,00dh
```

Po přijetí klávesy se její normalizovaný kód zapíše do operandu `LD A,n`:

```asm
ld (varcRepeatedKeyCode+1),a
```

Jakmile později vyprší prodleva opakování, vykonávání dojde k `varcRepeatedKeyCode` a uložená klávesa se automaticky znovu načte.

Stejně tak se načte počitadlo opakování, zvýší a zapíše zpět do vlastního operandu `LD HL,nn`.

V pseudokódu:

```text
repeatCounter = repeatCounter + 1
if repeatCounter dosáhl prahu:
    return repeatedKeyCode
```

Nejsou potřeba žádné oddělené pojmenované bajty v RAM.

## Samomodifikovaná instrukce může být přepínačem

Installer dokáže zobrazovat text v různých režimech velikosti písmen. Mění tuto instrukci:

```asm
varcInstallerCaseTransform:
    and 0ffh
```

`AND $FF` nic nezmění, a proto funguje jako neutrální transformace. Když uživatel změní instalační volbu, může ji nahradit jiná dvoubajtová instrukce z malé tabulky možností.

Vykreslovač znaků používá ještě názornější přepínač:

```asm
varcInstallerBoldTransform:
    nop
    or (hl)
```

V normálním režimu `NOP` nic nedělá a `OR (HL)` pouze zkombinuje řádek glyfu se sebou samým.

V tučném režimu se bajt `NOP` nahradí jednobajtovým opcode pro `RRCA`. Řádek se otočí o jeden pixel a poté se ORuje s původním řádkem:

```text
normální řádek = původní
silný řádek    = rotateRight(původní) OR původní
```

Samotný proud instrukcí se stává zvoleným režimem vykreslování.

Taková úprava je výhodná, protože horká smyčka nemusí u každého z osmi řádků glyfu testovat příznak. Rozhodnutí se provede jednou při změně volby. Vykreslování potom prochází přímo vybranou instrukcí.

## `CALL` se může stát malým dispatcherem

Dvouprůchodový assembler používá pro oba průchody jednu smyčku nad záznamy zdroje. Mění se pouze rutina volaná pro každý záznam.

Na začátku obsahuje místo volání:

```asm
varcAssemblyPassHandlerCall:
    call firstPassProcessSourceRecord
```

Před zahájením průchodu controller tuto adresu výslovně nainstaluje:

```asm
ld hl,firstPassProcessSourceRecord
ld (varcAssemblyPassHandlerCall+1),hl
```

Při přechodu mezi průchody nahradí cíl volání:

```asm
ld hl,secondPassEmitSourceRecord
ld (varcAssemblyPassHandlerCall+1),hl
```

Smyčka nad záznamy nemusí obsahovat větev:

```text
if pass == 1:
    call firstPass
else:
    call secondPass
```

Jednoduše vykoná místo volání. Samotné volání už bylo naučeno, kterou rutinu znamená.

V pseudokódu:

```text
recordHandler = firstPassProcessSourceRecord
procházej zdroj pomocí recordHandler

recordHandler = secondPassEmitSourceRecord
procházej zdroj pomocí recordHandler
```

Moderní programátor by tomu mohl říkat ukazatel na funkci. PROMETHEUS jej realizuje nahrazením operandu skutečné instrukce `CALL`.

## `JP` může být hookem pokračování

Zpracování příkazu běžně končí návratem do teplého startu editoru:

```asm
varcPostCommandContinuationJump:
    jp prometheusWarmStart
```

Některé operace potřebují jiné pokračování. Workflow pro vložení a nahrazení z kazety dočasně změní cíl skoku, provede sdílenou cestu příkazu a pokračuje ve své vlastní navazující rutině.

Před běžným dispatch příkazů se obnoví normální cíl:

```asm
ld hl,prometheusWarmStart
ld (varcPostCommandContinuationJump+1),hl
```

Jde o další ukazatel na funkci, tentokrát použitý pro závěrečný skok místo vnořeného volání.

Rozdíl je podstatný:

- `CALL` očekává návrat;
- `JP` předá řízení bez vložení návratové adresy.

Hook pokračování dovoluje složité operaci vypůjčit si běžné mechanismy editoru a na jejich konci znovu získat řízení.

## Opravená instrukce může obnovit celé řídicí prostředí

Spouštěcí engine monitoru dočasně vykonává uživatelský kód. Než to udělá, musí si zapamatovat, kde byl vlastní zásobník monitoru.

Později se zachycený stav uživatele dostane k této instrukci:

```asm
varcRestoreMonitorStackAfterExecution:
    ld sp,00000h
```

Její okamžité slovo bylo předtím opraveno hodnotou ukazatele zásobníku monitoru. Vykonání instrukce okamžitě opustí dočasný uživatelský nebo trampolínový zásobník a obnoví vlastní prostředí volání monitoru.

Jde o mocnou podobu obnovy stavu. Změna `SP` neznamená pouze načtení čísla. Určuje, odkud budou všechny následující `POP` a `RET` získávat data.

Opravený operand je proto součástí toku řízení stejně jako úložiště.

## Samomodifikace může ušetřit opakovaná rozhodnutí

Nyní se rýsuje několik vzorů.

### Zapamatovaný skalár

```asm
varcInsertMode:
    ld a,000h
```

Operand ukládá bajt režimu.

### Zapamatovaný ukazatel

```asm
varcInputBufferPosition:
    ld hl,inputBufferStart+1
```

Operand ukládá adresu markeru kurzoru zjištěnou při překreslování.

### Zapamatovaný callback

```asm
varcRangedDisassemblyOutputCall:
    call appendLineBufferToMonitorListWindow
```

Operand určuje, kam se posílají vytvořené řádky disassemblovaného textu.

### Zapamatovaný cíl skoku

```asm
varcPostCommandContinuationJump:
    jp prometheusWarmStart
```

Operand vybírá pokračování po sdílené práci.

### Zapamatované chování instrukce

```asm
varcInstallerBoldTransform:
    nop
```

Nahrazuje se samotný opcode, nikoli pouze jeho operand.

Každý z těchto vzorů odstraňuje rozhodnutí nebo samostatné vyhledání z cesty, na níž se hodnota používá.

## Nebezpečí: tvar instrukce je součástí datového formátu

Samomodifikující kód vytváří přísná pravidla.

Je-li tato stavová buňka definována jako:

```asm
varcAddressCounter:
    ld hl,00000h
```

pak jiný kód předpokládá:

```text
uložený dolní bajt leží na label+1
uložený horní bajt leží na label+2
```

Nahrazení `LD HL,nn` instrukcí jiné délky by porušilo všechny zápisy, i kdyby se zdálo, že nová instrukce dělá něco podobného.

Stejně tak by nahrazení jednobajtového opravovaného opcode dvoubajtovou instrukcí mohlo přepsat následující instrukci.

Přesné rozložení bajtů je interface.

Proto úvod zdroje a komentáře rozlišují:

- bajt opcode;
- okamžitý bajt;
- okamžité slovo;
- náhradu celé instrukce;
- opravovaný cíl `CALL` nebo `JP`.

Každá změna musí zachovat očekávaný tvar, nebo upravit všechny writery a verifikátory.

## Nebezpečí: kód může být zapisovatelný z důvodů, které disassembly skrývá

Představme si, že by monitor disassembloval vlastní rezidentní oblast jako obyčejný kód. Zobrazil by například instrukce:

```asm
ld hl,$8A31
call $7420
jp $7300
```

Čtenář by mohl předpokládat, že jejich operandy jsou trvalé adresy. Ve skutečnosti mohou být některé z nich živými proměnnými nebo callbacky, které se během běhu PROMETHEA mění.

To je jeden z důvodů, proč je skrytý rezidentní rozsah monitoru nucen procházet cestou `DEFB`. Bajty zůstávají prohlížitelné, ale PROMETHEUS nepředstírá, že jeho vlastní proměnlivý proud instrukcí je stabilní posloupností uživatelských instrukcí.

Ochrana není utajením. Je přiznáním, že kód a data jsou propletené.

## Nebezpečí: v ROM nebo paměti pouze pro čtení by to nebylo možné

PROMETHEUS se může samomodifikovat, protože běží v zapisovatelné RAM. ROM ZX Spectra takto opravit nelze.

Důležitá je také vlastní relokace programu. Writer oprav musí adresovat relokovanou kopii instrukce, nikoli adresu sestavení od nuly nebo dočasnou pozici na kazetě. Installer a relokační mechanismus toto uspořádají dříve, než rezidentní program zahájí běžnou práci.

Po instalaci ukazují interní odkazy založené na labelech do zapisovatelného rezidentního obrazu.

## Zdroj používá varovné pojmenování

Prefix `varc` není ozdobný. Říká nám, že máme zkoumat alespoň tři věci:

1. Které bajty se čtou, když se instrukce vykoná?
2. Které jiné rutiny tyto bajty zapisují?
3. Je opcode pevný, nebo může být také nahrazen?

Například:

```asm
varcPrintingPosition:
    ld de,SECOND_LINE_ADDRESS
```

Renderer později uloží následující bitmapovou pozici do `varcPrintingPosition+1`. Instrukci proto musíme číst současně jako:

```text
načti do DE současnou tiskovou pozici
```

a jako:

```text
dva zapisovatelné bajty uchovávají současnou tiskovou pozici
```

Label spojuje oba pohledy.

## Užitečný způsob překladu samomodifikujícího kódu

Při čtení místa s `varc` jej dočasně přepište na proměnnou vyšší úrovně.

Skutečný kód:

```asm
varcInputBufferPosition:
    ld hl,inputBufferStart+1
```

Mentální překlad:

```text
HL = inputBufferPosition
```

Writer:

```asm
ld (varcInputBufferPosition+1),hl
```

Mentální překlad:

```text
inputBufferPosition = HL
```

Pro callback:

```asm
varcAssemblyPassHandlerCall:
    call firstPassProcessSourceRecord
```

Mentální překlad:

```text
call assemblyPassHandler()
```

Writer:

```text
assemblyPassHandler = secondPassEmitSourceRecord
```

Takový překlad odhaluje návrh, aniž by skrýval neobvyklou implementaci.

## Proč program tento styl používá tak široce

PROMETHEUS byl navržen pro stroj, na němž záleželo na každém bajtu a vykonávání z RAM bylo normální. Samomodifikace nabízela:

- kompaktní trvalý stav;
- přímé načítání často používaných hodnot;
- levné callbacky;
- odstranění opakovaných testů režimu;
- přirozené ukládání relokovaných runtime adres;
- opětovné použití jedné smyčky pro několik fází.

Tato technika se navíc pro Z80 zvlášť hodí. Okamžité operandy jsou uloženy přímo za opcode a absolutní cíle `CALL` a `JP` jsou obyčejná zapisovatelná slova.

Na systému s chráněnými spustitelnými stránkami, instrukční cache nebo kódem uloženým v ROM by byla méně přitažlivá. Na Spectru je praktickou součástí návrhového jazyka programu.

## Zpět k celému stroji

Editor zdroje, assembler, monitor i renderer závisejí na zapamatovaném stavu.

PROMETHEUS mohl tento stav shromáždit do jednoho velkého bloku proměnných. Místo toho je velká část rozptýlena přímo na místech, kde se spotřebovává:

```text
pozice rendereru          uvnitř LD DE,nn
současný záznam zdroje    uvnitř LD HL,nn
handler průchodu assembleru uvnitř CALL nn
pokračování příkazu       uvnitř JP nn
bajty režimů a voleb      uvnitř LD A,n
transformace fontu        uvnitř spustitelného opcode
obnova zásobníku monitoru uvnitř LD SP,nn
```

Fyzický zdroj tím vypadá podivněji, ale runtime cesta je kratší.

Následující kapitola se podívá na druhou polovinu téže filozofie. PROMETHEUS nekomprimuje pouze stav do instrukcí. Vymýšlí také několik malých datových jazyků, aby řetězce, vektory, příkazy a deskriptory zabíraly co nejméně bajtů.

## Co se změnilo v paměti?

V příkladech této kapitoly může PROMETHEUS měnit bajty uvnitř vlastního rezidentního obrazu kódu:

- okamžité operandy si pamatují ukazatele, počitadla, režimy a adresy;
- cílová slova `CALL` a `JP` vybírají callbacky a pokračování;
- vybrané opcode realizují instalační volby, například tučné vykreslování;
- ukazatel zásobníku monitoru je uložen v instrukci `LD SP,nn`;
- výstupní ukazatel assembleru a logické počitadlo adresy postupují uvnitř dvou instrukcí `LD HL,nn`.

Tyto zápisy jsou záměrnými trvalými změnami stavu. Nejde o změny uživatelova zdroje ani vytvořeného programu.

## Uvedené orientační labely zdroje

- `varcAssemblyOutputPointer`
- `varcAddressCounter`
- `emitByteAtAssemblyOutput`
- `varcHeldKeyRepeatScanCounter`
- `varcRepeatedKeyCode`
- `varcInstallerCaseTransform`
- `varcInstallerBoldTransform`
- `varcAssemblyPassHandlerCall`
- `varcPostCommandContinuationJump`
- `varcRestoreMonitorStackAfterExecution`
- `varcInputBufferPosition`
- `varcPrintingPosition`
- `varcRangedDisassemblyOutputCall`
