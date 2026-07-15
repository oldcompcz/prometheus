# Kapitola 61: Komentovaný atlas zdroje

Kniha se záměrně vyhýbala tomu, aby procházela `prometheus.asm` od prvního řádku
k poslednímu. Takový postup by představil relokaci dříve, než by čtenář věděl,
co se vlastně relokuje, monitor dříve než editor zdroje a velké tabulky dříve
než rutiny, které jim dávají význam.

Nyní můžeme toto rozhodnutí obrátit.

Editor, assembler, monitor, vykonávací engine i instalátor jsme nejprve poznali
jako úplné funkce a potom jako soubory menších mechanismů. Fyzický zdrojový
soubor už by neměl působit jako stěna nesouvisejících labelů. Lze jej číst jako
emitovanou geografii jediného těsně sbaleného programu.

Tato kapitola je atlasem, nikoli další lekcí o jednom subsystému. Sleduje
současný rekonstruovaný soubor `src/prometheus.asm` ve fyzickém pořadí a pro
každou oblast odpovídá na čtyři otázky:

1. Jaké bajty nebo definice zde leží?
2. Které vstupní body a tabulky by měl čtenář poznat?
3. Proč se tento materiál nachází právě na tomto místě souboru?
4. Které předchozí kapitoly jej vysvětlují do hloubky?

Níže uvedené rozsahy řádků se vztahují k rekonstrukci v042. Pro orientaci jsou
užitečné, trvalými orientačními body však zůstávají labely. Přidání komentáře
poblíž začátku souboru může posunout číslo každého pozdějšího řádku, aniž se
změní jediný strojový bajt.

## Zdroj má tři různé druhy pořadí

Než atlas otevřeme, oddělme tři představy, které se snadno směšují.

### Textové pořadí

Jde o pořadí, v němž se materiál objevuje v `prometheus.asm`:

```text
constants
bootstrap
installer
installer metadata
resident monitor
resident assembler/editor
static language tables
initial source and symbol tail
```

Řádek `INCLUDE` vloží další soubor do tohoto textového proudu přesně na daném
místě.

### Pořadí emitovaného obrazu

Většina příkazů emitujících strojové bajty se objevuje také v pořadí svých bajtů
v distribuovaném bloku CODE. Existují však změny `ORG` a kontextů logických
adres. Instalátor se kopíruje na `$5000`, zatímco rezidentní payload se sestavuje
od originu nula a teprve později se relokuje.

Zdroj tedy popisuje jediný distribuovaný obraz, který obsahuje několik světů
logických adres.

### Pořadí runtime volání

Runtime tok řízení se o textovou úhlednost nestará. Rutinu poblíž konce může
volat vstup poblíž začátku. Tabulka za rendererem může popisovat rozhodnutí,
která renderer provedl dříve. Editor může zavolat assembler, ten může zavolat
sdílený evaluator expressionů a ten může použít rutiny symbolů umístěné mnohem
dále.

Nikdy nepředpokládejme:

```text
next in source = next in execution
```

Fyzické pořadí utváří historické rozložení, volitelná instalace, kompaktní
offsety a potřeba zachovat přesné bajty — nikoli moderní modulární systém.

## Atlas jediným pohledem

Současný hlavní soubor lze rozdělit do následujících širokých oblastí:

| Přibližné řádky v042 | Stabilní hranice | Hlavní téma |
|---:|---|---|
| 1–233 | záhlaví souboru až konstanty zpráv | architektonické poznámky, adresy ROM/systému a konstanty |
| 234–304 | `bootstrapEntry` až `bootstrapCopiedFragmentEnd` | fyzická samolokalizace odolná vůči relokaci |
| 305–1181 | origin instalátoru až konec loga/metadat | interaktivní instalátor, kopírování, konfigurace a dekodér relokace |
| 1182–1685 | `relocatablePayloadStart` až nastavení výstupu monitoru | vstup monitoru, deskriptory panelu, ochranné tabulky a stav navigace |
| 1686–3743 | `startMonitor` až obsluha chyb operací | UI monitoru, paměťové, blokové, kazetové a vstupní nástroje |
| 3744–4480 | `stepAtCurrentMonitorAddress` až predikce přístupů | engine kontrolovaného vykonávání |
| 4480–5868 | `disassembleNextLineToBuffer` až vykreslování panelu | disassembly, kontroly ochrany, výpisy a čelní panel |
| 5869–6163 | tabulky přístupů/toku až texty monitoru | uložený stav procesoru a metadata monitoru |
| 6164–7793 | `ENTRY_POINT_WITHOUT_MONITOR` až sdílené nastavení kazety | dispatch příkazů, expressiony, příkazy editoru, symboly a import/export kazety |
| 7794–8854 | `processCompilation` až `invokeRun` | dvouprůchodový assembler, zakódované expressiony a základní sdílené utility |
| 8855–11347 | `startPrometheus` až zobrazování znaků | teplá smyčka editoru, parser zdroje, expanze, klávesnice a obrazovkový výstup |
| 11348–12128 | vytváření symbolů až dočasné workspaces | symboly, přesuny paměti, formátování čísel, vkládání/mazání a buffery |
| 12129–12479 | `internalStackTop` až tabulky názvů příkazů | zprávy a kompaktní slovníky jazyka/UI |
| include na 12480 | `instructionTable.asm` | 687 záznamů tvarů instrukcí |
| 12488–12534 | `sourceBufferStart` až `relocatablePayloadEnd` | počáteční zdroj, tabulka symbolů a konec emitovaného payloadu |

Tato mapa je záměrně hrubá. Některá témata procházejí několika oblastmi.
Disassembler monitoru například spoléhá na tabulku instrukcí fyzicky umístěnou
poblíž konce assemblerového suffixu. Expander zdroje editoru používá také
disassembly monitoru. Fyzická geografie a konceptuální vlastnictví nejsou vždy
totéž.

---

# Trasa jedna: Distribuovaný instalační obraz

## Oblast 1: Návrhové poznámky, adresy stroje a sdílené konstanty

Zdroj začíná dlouhým architektonickým komentářem. Ten není součástí historického
binárního souboru; jde o rekonstruovaného průvodce, který popisuje:

- rozdělení na instalátor a rezidentní obraz;
- volitelný prefix monitoru;
- generování relokace z více originů;
- samomodifikovaný stav `varc...`;
- konvence kompaktních dat;
- pravidla labelů;
- očekávání ověřování.

Čtenář zdroje by měl toto záhlaví při prvním průchodu jednou přečíst a po
dokončení atlasu se k němu vrátit. Mnoho výrazů, které zprvu znějí abstraktně —
*assembler-only suffix*, *opcode-shaped data*, *origin-dependent word* — pak
ukáže na konkrétní oblasti.

První emitované definice jsou konstanty, nikoli rutiny:

```asm
INSTALLATION_ADDRESS: equ 0x5dc0
VRAM_ADDRESS:         equ 0x4000
ATTRIBUTES_ADDRESS:   equ 0x5800
LOADER_ADDRESS:       equ 0x5000
```

Tyto názvy vymezují čtyři adresní světy, s nimiž se setkáme při startu:

- `$5DC0`, historickou fyzickou adresu načtení bloku CODE;
- `$4000`, bitmapovou paměť obrazovky Spectra a workspace bootstrapu;
- `$5800`, atributy obrazovky;
- `$5000`, pevné dočasné umístění instalátoru.

Za nimi následují vstupní body ROM a systémové proměnné. Užitečným čtenářským
návykem je každý externí bod okamžitě zařadit:

```text
ROM_...     volatelná služba poskytovaná ROM Spectra
SYSVAR_...  zapisovatelný/čitelný stav vlastněný prostředím ROM
```

Zbývající konstanty určují pozice na obrazovce, počty řádků, barvy textu,
velikosti bufferů a indexy zpráv. Netvoří jediný konceptuální subsystém; jsou
slovníkem sdíleným vším, co následuje.

### Tuto oblast čtěme spolu s

- kapitolou 3 o mapě paměti;
- kapitolou 8 o obrazovce, klávesnici, zvuku a službách ROM Spectra;
- kapitolami 50–57 o instalačních adresách;
- kapitolou 60 o pravidlech úprav symbolických adres.

### Nepřikládejme jí příliš velký význam

Poloha konstanty poblíž začátku neznamená, že je globálně důležitá. Například
`LINES_BEFORE_ACCESS_LINE` má zásadní význam pro okno editoru, nikoli však pro
relokaci. Místo snahy zapamatovat si každou definici používejme hledání odkazů a
najděme její konzumenty.

## Oblast 2: Bootstrap odolný vůči relokaci

Prvním spustitelným orientačním bodem je:

```asm
bootstrapEntry:
```

Tento krátký fragment leží v distribuovaném obrazu na libovolné fyzické adrese,
kterou použil loader. Musí se spustit dříve, než program tuto adresu zná. Dokud
tedy nezíská fyzický základ, vyhýbá se běžným absolutním odkazům do vlastního
kódu.

Důležitými anchory jsou:

- `bootstrapEntry`;
- `bootstrapRecoverLoadAddress`;
- `bootstrapCopiedFragmentEnd`.

Oblast plní tři úkoly:

1. připraví dolní část obrazovky jako dočasný workspace a stack;
2. zjistí fyzickou adresu načtení pomocí `CALL` na ROM rutinu tvořenou `RET`;
3. zkopíruje malý fragment instalátoru na `$5000` a skočí na něj.

Po chytrém stackovém triku, který vyprodukuje základní adresu, vypadá zdroj
klamně obyčejně. Je to dobrý příklad, proč musí atlas zdroje pojmenovávat
hranice. Podivná část je soustředěna na začátku; zbytek je běžné pozičně
nezávislé kopírování.

### Proč se nachází právě zde

Bootstrap musí být prvními spustitelnými bajty, na něž přejde BASICový loader.
Současně potřebuje, aby za ním následovaly bajty instalátoru ve známé vzdálenosti
labelů. Jeho fyzické místo v obrazu je proto součástí algoritmu.

### Tuto oblast čtěme spolu s

- kapitolou 51, která ji vysvětluje instrukci po instrukci;
- kapitolou 57 o její roli v celé cestě od kazety k editoru.

## Oblast 3: Vlastní instalátor na logické adrese `$5000`

Po bootstrapu přepne zdroj do kontextu logické adresy instalátoru. Hlavním
vstupem je:

```asm
installerEntryAt5000:
```

Od tohoto místa až po generovaná metadata a konec loga kód předpokládá, že běží
ze své zkopírované pracovní oblasti na `$5000`.

Samotná oblast instalátoru obsahuje několik podoblastí.

### 3A. Vytvoření obrazovky a vstupní smyčka

Viditelné instalační rozhraní začíná kolem:

- `installerEntryAt5000`;
- `installerRedrawAndWait`;
- `installationAddressString`;
- `varcMonitorInstallFlag`;
- `varcInstallerTextAttribute`;
- `varcInstallerHighlightAttribute`;
- `varcKeyboardEchoDelay`;
- `varcInstallerCaseMode`;
- `varcInstallationAddressCursor`.

Mnohé labely `varc...` jsou zde zvlášť důležité. Instalátor neukládá všechny
volby do konvenční struktury. Přepisuje operandy nebo opcodes instrukcí, které se
později přečtou jako nastavení.

Při čtení této oblasti spojme každý zapisovatelný label s jeho použitím:

```text
kde je bajt změněn klávesou?
kde je stejný bajt později kopírován nebo interpretován?
leží label na opcodu, začátku instrukce, nebo operandu?
```

Poblíž následují pomocné rutiny uživatelského rozhraní:

- editace desetinné adresy;
- tisk inline řetězců;
- transformace velikosti písmen;
- transformace tučného písma;
- manipulace s atributy;
- vykreslení loga.

Kapitoly 5 a 52 vysvětlují, proč tyto zdánlivě drobné vykreslovací rutiny slouží
současně jako trvalé konfigurační úložiště.

### 3B. Výběr a kopírování rezidentního obrazu

Cestu kopírování ukotvují:

- `installerPrepareAssemblerOnlyImage`;
- cesty úplného obrazu a zpětného kopírování kolem něj;
- expressiony délky payloadu založené na `relocatablePayloadEnd`;
- hranice monitoru `ENTRY_POINT_WITHOUT_MONITOR`.

Nejdůležitější je, že zdroj neobsahuje dva rezidentní programy. Obsahuje jediný
16 000bajtový payload s odnímatelným prefixem o velikosti 5 000 bajtů. Instalátor
vybere buď:

```text
ENTRY_POINT_WITH_MONITOR .. relocatablePayloadEnd
```

nebo:

```text
ENTRY_POINT_WITHOUT_MONITOR .. relocatablePayloadEnd
```

Cesta pouze s assemblerem navíc aplikuje své záměrné kompatibilní patche. Při
úpravě této oblasti výslovně rozlišujme *source pointer*, *destination pointer*,
*délku kopírování* a *relokační korekci*. Souvisejí spolu, ale nejsou
zaměnitelné.

### 3C. Průchod konfiguračními patchi

Instalátor neobsahuje čtrnáct natvrdo zapsaných absolutních cílových adres.
Spotřebovává proud signed delt začínající na:

```asm
installerConfigurationPatchDeltas:
    include "configurationPatchTable.asm"
```

Pomocnými dekodéry jsou:

- `installerStoreAAndAdvancePatchPointer`;
- `installerAdvancePatchPointer`.

Include se generuje z labelů `configurationPatchTarget...` rozptýlených v
rezidentním payloadu. Textové pořadí zdroje tak vytváří užitečný vztah mezi
soubory:

```text
resident semantic labels
        ↓ build-time generator
configurationPatchTable.asm
        ↓ included here
original compact installer decoder
```

Runtime Spectra o generátoru nic neví. Pouze prochází historický formát delt.

### 3D. Dekodér a tabulka relokace

Hlavním runtime dekodérem je:

```asm
installerApplyRelocationTable:
```

Generovaný proud se vkládá zde:

```asm
include "relocationTable.asm"
```

Poblíž ležící label označuje přechod z relokačních metadat do konce loga
instalátoru:

```asm
relocationSecondStreamTerminatorAndLogoStart:
```

Dekodér je malý, protože build-time tabulka nese seznam 1 293 slov, která je
nutné upravit. Proud je rozdělen na prefix monitoru a suffix assembleru, takže
stejný kompaktní dekodér podporuje oba instalační režimy.

### 3E. Logo instalátoru a konec dočasného kódu

Bitmapa loga a renderer řádků zabírají konec oblasti instalátoru. Na jejich
poloze záleží, protože bootstrap kopíruje omezený segment instalátoru a
terminátor relokačního proudu sdílí přechod do dat loga.

Jde o oblast, kde se na rozložení obrazu podílejí i zdánlivě dekorativní bajty.
Přesunutí loga může změnit délku instalátoru, přestože nezmění rezidentní kód.

### Celý instalátor čtěme spolu s

- kapitolami 50–57;
- kapitolou 5 o zapisovatelném stavu v instrukcích;
- kapitolou 7 o kopírování bezpečném při překryvu;
- kapitolou 54 o konfiguračních metadatech;
- kapitolou 55 o generování a dekódování relokace;
- kapitolou 56 o okolním obrazu TAP.

---

# Trasa dvě: Volitelný prefix monitoru

## Oblast 4: Hranice payloadu s originem nula a vstup monitoru

Rezidentní payload začíná na:

```asm
relocatablePayloadStart:
```

a okamžitě poskytuje vstup úplné instalace:

```asm
ENTRY_POINT_WITH_MONITOR:
    jp startPrometheus
```

Tento skok může zprvu překvapit. Úplný obraz začíná prefixem monitoru, běžný
start však vstupuje do editoru. Monitor je služba, do níž se později vstupuje
příkazem `MONITOR`; není počátečním uživatelským rozhraním.

Na jiném místě se hodnota závislá na originu `ENTRY_POINT_WITH_MONITOR+2` ukládá
jako data tvarovaná jako opcode, nikoli jako adresa. Právě proto má generátor z
více originů v oblasti tabulek explicitní výjimku
`relocationExceptionMonitorEntryDescriptorWord`.

Payload se sestavuje od originu nula. Každé interní absolutní slovo v této
oblasti proto začíná jako offset. Instalátor přičte zvolený rezidentní základ
pouze na vygenerovaných relokačních cílech.

## Oblast 5: Deskriptory čelního panelu a úložiště ochranného stavu

Brzy po vstupu monitoru předkládá zdroj data dříve než hlavní smyčku monitoru:

- `frontPanelItemDescriptors`;
- `frontPanelEditLineItem`;
- `frontPanelListWindowItem`;
- `frontPanelDisassemblyWindowItem`;
- `frontPanelRegistersItems`;
- tabulky disassembly oblastí DEFB a DEFW;
- stack navigačních adres;
- ochranné tabulky READ, WRITE a RUN;
- seznam adres přímých volání.

Toto pořadí je dobrým testem vyzrálého čtení zdroje. Začátečník často velké
tabulky přeskočí, protože nic „nedělají“. Zde však tabulky **jsou** značnou
částí návrhu monitoru.

Čelní panel je generický, protože každý sedmibajtový deskriptor určuje, co se má
kreslit, kde najít hodnotu a jakou reprezentaci použít. Ochranné tabulky sdílejí
formát biased-count/rozsah. Seznam přímých volání mění politiku krokování, aniž
mění vykonávací engine.

Každou tabulku čtěme společně s jejím pozdějším konzumentem:

| Časná data | Pozdější konzument |
|---|---|
| deskriptory položek čelního panelu | `renderFrontPanelItem` a dispatch rendererů |
| oblasti DEFB/DEFW | `disassembleNextLineToBuffer` |
| rozsahy READ/WRITE/RUN | ochranné kontroly a validace kroku |
| navigační stack | `monLevelUp` / `monLevelDown` |
| seznam přímých volání | gate toku řízení ve vykonávacím enginu |

Data se objevují brzy mimo jiné proto, že historické rozložení drží trvalou
konfiguraci monitoru poblíž jeho vstupu. Konceptuálně je však vhodné přečíst
kapitoly 34, 38, 39 a 46–48 dříve, než se pokusíme dekódovat každý bajt.

## Oblast 6: Teplý vstup monitoru a dispatch klávesnice

Skutečným vstupem řídicí smyčky monitoru je:

```asm
startMonitor:
```

Poblíž ležící oblast zahrnuje:

- reset soukromého stacku;
- obnovení hooků zobrazení/vstupu;
- vytvoření stavového řádku;
- úplné překreslení panelu;
- normalizaci kláves;
- tabulku akcí kláves monitoru;
- navigaci po adresách;
- pohyb po bajtech a instrukcích;
- nastavení okna výpisu.

Tabulka kláves je další kompaktní dispatch struktura. Textová posloupnost
handlerů není viditelným pořadím klávesnice; tabulka mapuje normalizované kódy
kláves na blízké rutiny pomocí kompaktních offsetů.

Užitečnými orientačními body jsou:

- `monitorKeyboardActions`;
- `monitorKeyboardActionsTable`;
- `monSetCurrentAddress`;
- `monOneByteBack` / `monOneByteForward`;
- `monLevelUp` / `monLevelDown`;
- `varcMonitorCurrentAddress`;
- `monOneInstructionForward`;
- `monListDisassembly`.

Kapitola 33 popisuje hlavní smyčku. Kapitola 35 vysvětluje stav adres a vstupu.
Kapitola 40 ukazuje, jak se výstup seznamu stává jedním z několika cílů téhož
disassembly řádku.

## Oblast 7: Vstup monitoru, editace paměti a přepínače politiky

Za navigací soubor seskupuje mnoho viditelných příkazů monitoru:

- jednorázovou editaci paměti;
- jednořádkové sestavení;
- vstup expressionu s promptem;
- souvislou editaci paměti;
- přepínač kontrol instrukcí;
- cyklování režimu přímých volání;
- číselný/symbolický režim disassembly;
- pomalé a rychlé trasování;
- přepínač stavu přerušení.

Důležitými anchory jsou:

- `monMemoryEditingOneShot`;
- `editOneMonitorAssemblyLine`;
- `promptForMonitorValue`;
- `monitorInputRestart`;
- `assembleMonitorInputLine`;
- `monMemoryEditing`;
- `monToggleInstructionControls`;
- `monCycleDirectCallMode`;
- `monToggleNumericDisassemblyAddresses`;
- `monSlowTracing`;
- `monFastTracingToAddress`;
- `monToggleInterruptEnableState`.

Tato oblast ukazuje, jak PROMETHEUS sdílí nízkoúrovňové mechanismy mezi
subsystémy. Expressiony monitoru používají evaluator assembleru. Jednořádkové
sestavení používá běžný parser a oba handlery průchodů. Vstupní řádek používá
buffer a renderer editoru, ale s pokračováními dokončení a chyb specifickými pro
monitor.

Nečtěme tyto rutiny jako druhý nezávislý editor. Jsou adaptéry kolem sdíleného
kódu suffixu.

## Oblast 8: Kazetové nástroje monitoru, zpětné disassembly a příkazy nativního vykonávání

Další viditelné nástroje zahrnují:

- SAVE bloku podle First/Last nebo First/Length;
- LOAD bloku;
- prohlížení kazetové hlavičky/leaderu;
- záměnu bank registrů;
- disassembly na tiskárnu;
- rozsahové disassembly do zdroje;
- běh k dočasnému breakpointu;
- nativní volání podprogramu;
- MOVE a FILL;
- číselné a znakové výpisy paměti;
- editaci seznamu přímých volání;
- maskované FIND/NEXT.

Oblast je rozsáhlá, rutiny však lze seskupit podle neutrální formy, kterou
spotřebovávají:

```text
inkluzivní rozsah paměti -> SAVE, LOAD, MOVE, FILL
adresa                   -> výpis, znakový pohled, začátek běhu
32sloupcový lineBuffer   -> tiskárna nebo vložení do zdroje
pět dvojic (value,mask)  -> FIND/NEXT
uložený obraz procesoru  -> nativní volání nebo běh k breakpointu
```

Reprezentativními orientačními body jsou:

- `monSaveBlockFirstLast`;
- `prepareMonitorTapeBlockParameters`;
- `monLoadBlockFirstLast`;
- `monReadTapeHeaderOrLeader`;
- `monDisassemblyOnPrinter`;
- `monDisassembleIntoSource`;
- `parseAndInsertDisassemblyLine`;
- `monRunToTemporaryBreakpoint`;
- `monCallSubroutineWithSavedState`;
- `monMoveBlockFirstLast`;
- `monFillBlockFirstLast`;
- `monListMemoryFromTheCurrentAddress`;
- `monCharactersFromTheCurrentAddress`;
- `monFindSequence` / `monNextSequence`.

Kapitoly 36–42 je popisují jako uživatelské funkce. Ve fyzickém pořadí zdroje
tvoří také most k vykonávacímu enginu: příkazy breakpointu a nativního volání
představují uložený stav a scratch vykonávání dříve, než začne kontrolované
krokování.

## Oblast 9: Editor tabulek rozsahů a sdílené prompty monitoru

Před vstupem single-step soustřeďuje zdroj helpery pro:

- editaci ochranných tabulek;
- editaci seznamu přímých volání;
- vykreslování konců rozsahů;
- inicializaci řádkového assembleru monitoru;
- prompty First/Length a First/Last;
- kontroly zápisu do rezidentní oblasti;
- zobrazení chyb operací a zotavení.

Užitečné anchory zahrnují:

- `writeMonitorTextToDE`;
- `displayAndEditFiveRangeTable`;
- `displayAndEditDirectCallAddressList`;
- `monitorInputBuffersInitialization`;
- `renderMonitorInputLine`;
- `monitorInputLoop`;
- `promptForFirstAndLength`;
- `promptForFirstAndLast`;
- `preserveBlockRangeAndCheckResidentWrite`;
- `showMonitorOperationError`.

Nejde o okázalý kód, vysvětluje však, proč vyšší příkazy monitoru zůstávají
kompaktní. Prompt, parsing, opakování, zobrazení i normalizace rozsahu jsou
soustředěny zde.

---

# Trasa tři: Kontrolované vykonávání

## Oblast 10: Vstup kroku, obnovení stavu uživatele a zachycení

Vykonávací engine začíná na:

```asm
stepAtCurrentMonitorAddress:
```

a rychle dospěje k:

```asm
stepInstructionAtHL:
```

Tato oblast řídí jeden úplný krok:

```text
dekóduj
validuj
sestav scratch instrukci
obnov stav uživatele
vykonej na skutečném Z80
zachyť stav
oprav logický tok a časování
vrať se do monitoru
```

Nejdůležitějšími anchory první poloviny jsou:

- `testCapsShiftEnter`;
- `restoreUserStateAndExecuteTrampoline`;
- `captureUserStateAfterTakenFlow`;
- `captureUserStateAfterSequentialFlow`;
- `breakpointHitCaptureEntry`;
- `varcTakenFlowNextAddress`;
- `varcSequentialNextAddress`;
- `varcRestoreMonitorStackAfterExecution`.

Pořadí zdroje zrcadlí fyzické výstupy scratch programu: sekvenční a provedená
cesta potřebují rozdílné vstupy zachycení, protože potvrzují různé logické adresy
a hodnoty časování.

Při čtení této oblasti mějme otevřené kapitoly 43, 45, 48 a 49.

## Oblast 11: Oprava toku řízení a sestavení scratch programu

Další skupina obsahuje malý interpreter přepisující nebezpečný tok řízení:

- úpravu návratového stacku;
- handlery toku řízení řízené deskriptory;
- transformaci relativních větvení;
- politiku přímých CALL/RST;
- kopírování scratch instrukce;
- připojené zachycovací skoky.

Hlavní labely zahrnují:

- `replaceScratchCallReturnAddress`;
- `advanceSavedStackAfterReturn`;
- `tracedControlFlowHandlerOffsets`;
- `simulateRelativeControlFlow`;
- `directCallModeGateOpcode`;
- `buildInstructionExecutionTrampoline`;
- `appendSequentialAndTakenCaptureJumps`;
- `beginExecutionTrampoline`.

Na tomto místě záleží na lokálních labelech. Mnohé tečkou prefixované cíle
vybírají malé blízké případy a neměly by být zaměněny za opakovaně použitelná
rozhraní.

Je zde vidět ústřední architektonický fakt z kapitoly 46: PROMETHEUS neemuluje
aritmetiku instrukcí. Mění pouze fyzické hrany toku řízení potřebné k bezpečnému
návratu do svého zachycovacího kódu.

## Oblast 12: Validace před vykonáním a predikce efektivní adresy

Před vykonáním scratch kopie PROMETHEUS předpovídá, zda by instrukce četla nebo
zapisovala do zakázané paměti.

Skupina začíná kolem:

- `validateInstructionBeforeExecution`;
- `varcInstructionControlsDisabled`;
- `validateMatchedMemoryAccess`;
- `matchInstructionAccessDescriptor`;
- `effectiveAddressAccessorOffsets`;
- rutin accessorů efektivních adres;
- `varcDecodedInstructionOperandWord`.

Tento kód je třeba číst spolu s tabulkami deskriptorů umístěnými později v
prefixu monitoru. Jedna strana provádí vyhledávání v tabulce; druhá ukládá masky,
velikost přístupu a indexy receptů adres.

Toto rozdělení je pro PROMETHEUS typické:

```text
později umístěná kompaktní deklarativní tabulka
        ↓
zde umístěný malý generický interpreter
```

Kapitola 47 vysvětluje recepty pro registry, indexované displacementy, adresy
stacku a rozsahy blokových přenosů. Kapitola 38 vysvětluje cílové ochranné
tabulky.

---

# Trasa čtyři: Dekódování a zobrazování stroje

## Oblast 13: Disassembly do neutrálního řádkového bufferu

Hlavní disassembly pipeline začíná na:

```asm
disassembleNextLineToBuffer:
```

Její fyzická poloha bezprostředně za validací vykonávání je logická: stepper už
potřebuje dekódovanou délku instrukce a metadata a monitor potřebuje tentýž
dekodér pro zobrazení.

Skupina zahrnuje:

- vymazání řádkového bufferu a stav čekajícího oddělovače;
- klasifikaci oblastí DEFB/DEFW;
- dekódování instrukce;
- dispatch handlerů operandů;
- formátování signed a indexovaných displacementů;
- hledání symbolu podle hodnoty;
- politiku formátování čísel;
- `decodeInstructionAtHL`.

Důležité labely zahrnují:

- `varcDisassemblyInstructionAddress`;
- `varcDisassemblyAddressMode`;
- `varcShowNumericDisassemblyAddresses`;
- `dispatchDisassemblyOperandHandler`;
- `disassemblyOperandHandlerOffsets`;
- `findSymbolOrdinalByValue`;
- `decodeInstructionAtHL`.

Výstup se nekreslí přímo. Jde o 32sloupcovou reprezentaci v `lineBuffer`, kterou
může pozdější kód poslat do rolujícího okna, pevné položky čelního panelu,
tiskárny nebo parseru zdroje.

Čtěme spolu s kapitolami 39 a 40 a potom se vraťme ke kapitolám 20–21, abychom
viděli stejná metadata instrukcí z opačného směru.

## Oblast 14: Generické ochranné kontroly a výstup seznamu monitoru

Za dekódováním následují opakovaně použitelné kontroly adres a rozsahů:

- `checkRangeAgainstResidentRegionOnly`;
- `checkRangeAgainstProtectionTable`;
- `checkAddressAgainstProtectionTable`;
- jejich výstupy obnovující stack.

Kód dočasně používá tabulku rozsahů jako stav průchodu řízený stackem. Je to
jedna z rutin, které vypadají podivněji izolovaně než při pochopení jako odpověď
na tlak na paměť.

Následující výstupní helpery zahrnují:

- `beginMonitorListOutputWithBlankLine`;
- `appendLineBufferToMonitorListWindow`;
- `renderLineBufferAtMonitorListCursor`.

Společně spojují neutrální dekódovaný text s pohyblivou dvacetřádkovou oblastí
seznamu monitoru.

Obě poloviny vysvětlují kapitoly 38 a 40.

## Oblast 15: Editor a renderer čelního panelu

Další velký blok zdroje implementuje systém deskriptorů představený poblíž
začátku prefixu monitoru.

Jeho vstupní body a stav zahrnují:

- `invokeFrontPanelEditor`;
- `varcActiveFrontPanelItemOffset`;
- `redrawFrontPanelAtCurrentAddress`;
- `redrawEntireFrontPanel`;
- `renderFrontPanelItemIfEnabled`;
- `renderFrontPanelItem`;
- `clearOrRenderFrontPanelSpecialArea`;
- `varcInterruptEnableState`;
- `varcFrontPanelDisassemblyAddress`.

Pod nimi leží specializované renderery:

- záhlaví flags a podmínky;
- binární bajt;
- znak;
- desetinné slovo;
- název operandu;
- text ukončený vysokým bitem;
- pohyb po bitmapových adresách.

Fyzické pořadí je klasickým uspořádáním table-interpreter:

```text
editor a vysokoúrovňový průchod
        ↓
generický renderer deskriptoru
        ↓
malý dispatch rendererů specifických pro formát
        ↓
helpery pohybu po adresách obrazovky
```

Hlavním průvodcem je kapitola 34. Kapitola 8 vysvětluje operace s bitmapou
Spectra. Kapitola 5 vysvětluje konfiguračně patchované atributy a operandy režimů
nalezené uvnitř této oblasti.

## Oblast 16: Uložený obraz procesoru a tabulky metadat monitoru

Poblíž konce volitelného prefixu ustupuje spustitelný kód trvalému stavu a velkým
deklarativním tabulkám.

Uložený obraz procesoru začíná kolem:

- `savedRegisterR`;
- `savedRegisterI`;
- `savedAlternateRegisterSet`;
- uložených slov IY, IX, BC, DE, HL a AF s bajtovými aliasy;
- `savedRegisterSP`;
- `accumulatedTStates`;
- stavu adres X/Y monitoru.

Toto rozložení má záměrně tvar stacku. Obnovovací rutiny hodnoty `POP`ují v
jednom pořadí; zachycovací rutiny je v opačném pořadí `PUSH`ují zpět.

Následující velké tabulky zahrnují:

- `readAccessDescriptorTable`;
- `monitorTables`;
- `writeAccessDescriptorTable`;
- `relocationExceptionMonitorEntryDescriptorWord`;
- `controlFlowDescriptorTable`;
- `monitorTextReferences` a `monitorTextsTable`.

Každá patří ke konzumentovi umístěnému dříve v prefixu:

| Tabulka | Hlavní kapitoly |
|---|---|
| uložený obraz procesoru | 43, 48, 49 |
| deskriptory READ/WRITE | 47 |
| deskriptory toku řízení | 46 |
| vektor/tabulka textů monitoru | 6, 33–41 |
| výjimka relokace | 55 |

Poslední text monitoru končí bezprostředně před hranicí pouze s assemblerem.
Toto umístění není jen estetické: následující label musí zůstat prvním bajtem
kopírovaným při instalaci pouze s assemblerem.

---

# Trasa pět: Suffix assembleru/editoru

## Oblast 17: Vstup pouze s assemblerem a dispatch příkazů

Přesnou hranicí je:

```asm
ENTRY_POINT_WITHOUT_MONITOR:
```

Tento label má současně tři významy:

1. rezidentní vstup instalace pouze s assemblerem;
2. začátek 11 000bajtového suffixu;
3. symbolický bod odčítání pro délky instalátoru a relokační korekci.

První rutiny zavádějí dispatch příkazů a příkazy polohy ve zdroji. Důležité
orientační body zahrnují:

- `commandHandlerTable`;
- příkazy začátku/konce zdroje;
- `getSourceEndPosition`;
- `invokeUTop`;
- textové vyhodnocení expressionu přes `evaluateInputExpression` a
  `evaluateExpressionAtHL`.

Tabulka příkazů se objevuje před mnoha handlery, protože dispatch potřebuje
kompaktní centrální mapu. Některé handlery leží bezprostředně pod ní; jiné jsou
mnohem dále. Neodvozujme vlastnictví pouze z blízkosti.

Čtěme spolu s kapitolami 9, 10, 17 a 22.

## Oblast 18: FIND, REPLACE, PRINT a operace s bloky zdroje

Další skupina obsahuje vyšší příkazy editoru:

- `invokeReplace` a jeho pokračování;
- `invokeFind` / `findNextOccurrence`;
- procházení řádků řízené callbackem;
- uložení argumentu malými písmeny;
- `invokePrint`;
- `invokeDelete`;
- porovnávání textu v řádkovém bufferu;
- uložení textu náhrady.

Klíčem ke kompaktnosti této oblasti jsou callbacky. FIND a PRINT sdílejí průchod
záznamy, zatímco REPLACE expanduje záznam na text a záměrně jej posílá zpět přes
běžný parser.

Fyzické pořadí odhaluje pipeline:

```text
stav příkazu
-> společný scanner
-> rekonstruovaný lineBuffer
-> callback specifický pro příkaz
-> volitelné běžné odeslání zdrojového řádku
```

Tuto oblast vysvětlují kapitoly 14, 17 a 18.

## Oblast 19: Zobrazení, zamykání a komprimace symbolů

Blok příkazů symbolů začíná kolem:

- `displaySymbolTableColumn`;
- stavu zobrazení tabulky symbolů;
- `invokeTable`;
- `processSymbolTableItems`;
- `invokeClear`;
- ukazatelů komprimace;
- procházení odkazů ve zdroji.

Jde o **správcovskou** stranu symbolů: zobrazení, zamykání/odemykání, mazání a
sběr `TABLE C`. Nízkoúrovňové vyhledávání názvů a rutiny fyzického vkládání se
objevují mnohem později v souboru.

Toto oddělení je záměrné. Uživatelské příkazy jsou seskupeny poblíž ostatních
handlerů příkazů, zatímco společné primitivy symbolů leží u helperů parseru a
paměti.

Čtěme kapitoly 23 a 24. Při sledování volání očekávejme skok o tisíce řádků
dopředu k `parseSymbolNameAndFindOrdinal`, `findOrCreateSymbolOrdinal` a rutinám
pohybu tabulky.

## Oblast 20: Nativní SAVE, VERIFY, LOAD zdroje a import GENS

Po správě symbolů následují kazetově orientované příkazy editoru:

- `invokeSave`;
- uchované délky a ukazatele zdroje/symbolů;
- zápis kazetové hlavičky;
- vstup názvu souboru;
- `invokeVerify`;
- `performTapeLoadOrVerifyOrReportError`;
- `invokeLoad` a importní kurzory;
- aliasy importu GENS/MASM;
- patch základny resolveru importovaných symbolů;
- načtení odpovídajícího payloadu CODE;
- helper stavu borderu.

Tato oblast není systémem surových kazetových bloků monitoru. Rozumí nativnímu
komprimovanému zdroji spolu s tabulkami symbolů nebo cizím textovým záznamům
převedeným parserem editoru.

Důležitou architektonickou větou je:

```text
staged tape representation -> canonical editor text -> live source records
```

nikoli přímé kopírování cizích ordinalů do živé tabulky.

Čtěme kapitoly 29–32.

## Oblast 21: Controller dvouprůchodového sestavení a emitery

Vlastní assembler začíná na:

```asm
processCompilation:
```

a zahrnuje:

- výběr scope;
- samomodifikované volání handleru průchodu;
- průchod záznamy zdroje;
- `invokeAssembly`;
- skenování pseudo-operací;
- `secondPassEmitSourceRecord`;
- `emitMachineInstructionBytes`;
- validaci immediate/signed hodnot;
- `emitByteAtAssemblyOutput` a jeho zapisovatelný ukazatel;
- čítač logické adresy;
- emisi slov;
- zpracování záznamu v prvním průchodu;
- návrat po chybě na záznam zdroje.

Je to nejlepší oblast zdroje ke čtení po kapitolách 19 a 25–28. Ty vysvětlují
vnější tvar, takže se zde čtenář může soustředit na smlouvy registrů a dispatch
záznamů místo opětovného objevování důvodu dvou průchodů.

Zapisovatelný stav je zvlášť hustý:

- současný handler průchodu;
- následující záznam zdroje;
- čítač přechodů;
- výstupní ukazatel;
- U-TOP;
- čítač logické adresy;
- položka labelu současného řádku.

Většina je uložena v operandech instrukcí. Odkazy `+1` kontrolujme velmi pečlivě.

## Oblast 22: Evaluator zakódovaných expressionů a aritmetika

Pod handlery průchodů leží evaluator používaný na komprimovaných záznamech
zdroje:

- `evaluateEncodedExpressionAtIX`;
- dekódování operátorů;
- `applyExpressionOperatorToHLAndDE`;
- softwarové dělení;
- softwarové násobení;
- unární minus;
- uvozené konstanty.

Liší se od textového parseru poblíž vstupu suffixu, přestože oba nakonec
implementují stejný expression jazyk vyhodnocovaný zleva doprava.

Fyzické umístění vedle assembleru je přirozené: zakódované expressiony se
spotřebovávají především při zpracování průchodů. Monitor si vypůjčuje textovou
cestu.

Čtěme kapitolu 22.

## Oblast 23: Sdílená kazeta, rušení a mosty příkazů

Zbývající blok před editorem zahrnuje:

- wrapper ROM pro kazetové LOAD/VERIFY;
- kontroly zrušení klávesou SPACE;
- most z assembleru do monitoru;
- fallback opcode/adresu varianty pouze s assemblerem;
- QUIT/BASIC a helpery skenování kazetové hlavičky;
- přepínače číselné soustavy a INSERT/OVERWRITE;
- kopírování řádku obrazovky a helpery navigace zdrojem;
- RUN a jeho balance `ENT`/cíl volání.

Jsou to švy mezi hlavními uživatelskými operacemi. Fyzicky leží poblíž
assembleru, protože mnohé závisí na stavu sestavení nebo určují, co se stane po
překladu.

Fallback monitoru v instalaci pouze s assemblerem je obzvlášť citlivý na
rozložení. V suffix-only produktu nesmí `MONITOR` skočit do vynechaného prefixu.
Kapitoly 53 a 55 vysvětlují dva patche instalátoru, které tuto hranici
zabezpečují.

---

# Trasa šest: Jádro editoru a front end jazyka

## Oblast 24: Studený start, teplé starty a hlavní smyčka editoru

Viditelný editor začíná na:

```asm
startPrometheus:
```

za nímž následuje několik úrovní teplého startu:

- `prometheusWarmStart`;
- `prometheusWarmStartWithMessage`;
- `prometheusWarmStartWithCurrentBuffers`.

Oblast inicializuje nebo zachovává různá množství stavu, znovu vytváří obrazovku,
vykresluje stavový řádek a nakonec dospěje ke zpracování klávesnice.

Důležitá pokračování jsou zapisovatelná:

- poslední zpráva stavového řádku;
- pokračovací skok po příkazu;
- ukazatel aktivního záznamu zdroje;
- poloha vstupního bufferu;
- režim insert/overwrite.

Hlavním rozcestím odeslání je:

```asm
submitInputLineOrDispatchCommand:
```

následované:

```asm
parseAndInsertSourceLine:
```

Před sledováním této oblasti zdroje si přečtěme kapitoly 9, 10, 13 a 18. Potom
bude vypadat jako konkrétní implementace známého cyklu, nikoli jako bludiště
teplých vstupů.

## Oblast 25: Chování editovatelného vstupního bufferu

Další skupina implementuje:

- pohyb kurzoru;
- vkládání/mazání znaků;
- tabulaci polí;
- sledování značky kurzoru;
- expanzi tokenů příkazů;
- překreslování.

Hlavní stav je připojen k:

- `updateInputBuffer`;
- `varcInputBufferPosition`;
- `varcInputColumnAfterCursor`.

Fyzické buffery leží později, takže tento kód opakovaně odkazuje dopředu na
`inputBufferStart` a jeho ochranný bajt.

Kapitola 11 vysvětluje putující značku kurzoru `$01` i to, proč se
INSERT/OVERWRITE vztahuje na záznamy zdroje, nikoli na vkládání znaků.

## Oblast 26: Enkodér zdrojového řádku a rozpoznávání tvarů instrukcí

Front end zdroje začíná na:

```asm
encodeInputLineToSourceRecord:
```

a sestupuje přes:

- zpracování volitelného labelu;
- pole mnemonic a operandů;
- `decodeInstructionTableRecord`;
- validaci operandů;
- kódování expressionů;
- kódování uvozených/číselných atomů;
- validaci závorek/čárek;
- převod číslic soustavy;
- normalizaci IX/IY;
- klasifikaci operandů;
- vyhledávání v délkových buckets;
- čtečky vstupních polí.

Důležitý zapisovatelný stav zahrnuje:

- `varcSecondOperandClass`;
- `varcFirstOperandClass`;
- `varcMnemonicIndex`;
- `varcUseIYPrefix`;
- `varcIndexRegisterVariantOffset`.

Tento kód odkazuje dopředu do tabulek mnemonic, operandů a instrukcí poblíž
konce payloadu. Za jeho mapu považujme kapitoly 13, 20 a 21.

## Oblast 27: Expanze zdroje a navigace

Inverzní pipeline je fyzicky proložena helpery parseru a vykreslováním okna
zdroje:

- vyřešení odkazu na symbol;
- `expandSourceRecordToLineBuffer`;
- expanze operandů;
- průchod na předchozí/následující záznam;
- vykreslení viditelného zdroje;
- vykreslení záznamu zdroje;
- výstup expandovaného řádku řízený callbackem;
- vyhledávání řetězců ukončených vysokým bitem a tisk s doplněním.

Klíčovými anchory jsou:

- `resolveSymbolReferenceToName`;
- `varcSymbolTableBasePointer`;
- `expandSourceRecordToHL`;
- `getPreviousSourceRecord`;
- `getNextSourceRecord`;
- `renderVisibleSourceRecords`;
- `varcSourceBufferActiveLine`;
- `printExpandedSourceLineWithRoutine`.

V této oblasti zdroje se trvalý formát editoru znovu stává viditelným textem.
Kapitoly 12, 14 a 15 vysvětlují framing, inverzní dekódování a geometrii okna.

## Oblast 28: Vykreslování obrazovky, klávesnice a beeper

Poblíž dolní části jádra editoru zdroj soustřeďuje sdílený fyzický I/O:

- překreslení editačního řádku;
- mazání bitmapového řádku;
- skenování klávesnice ROM a stav opakování;
- `processKey`;
- CAPS LOCK a stav poslední klávesy;
- beeper přijaté klávesy;
- klasifikaci znaků;
- zobrazení tokenu/znaku;
- generický renderer znaků;
- barvu textu a pozici tisku;
- konfigurační patch transformace tučného písma.

Reprezentativní labely jsou:

- `repaintEditLine`;
- `renderInputLineAtBitmapAddress`;
- `readKeyCode`;
- `processKey`;
- `getKeypressCodeOrZero`;
- `keypressBeep`;
- `displayInputTokenOrCharacter`;
- `displayCharacter`;
- `varcPrintingPosition`.

Tato oblast se sdílí daleko za editorem. Instalátor má vlastní malý renderer,
protože běží dříve, než je rezidentní obraz připraven, monitor si však vypůjčuje
mnoho konvencí zobrazení a vstupu rezidentního suffixu.

Čtěme kapitoly 8, 10 a 11.

---

# Trasa sedm: Sdílené mechanismy úložiště a statické jazyky

## Oblast 29: Vytváření symbolů a fyzický pohyb tabulky

Nízkoúrovňové primitivy symbolů začínají kolem:

```asm
parseSymbolNameAndFindOrdinal:
```

a zahrnují:

- současný ukazatel tabulky symbolů;
- základ oblasti položek;
- logiku najdi-nebo-vytvoř;
- ukazatel konce kódu;
- nový vektorový slot;
- zavírání mezer po smazaných symbolech;
- přesun paměti bezpečný při překryvu.

Jde o fyzickou stranu tabulky symbolů, která doplňuje blok uživatelských příkazů
mnohem dříve v suffixu.

Důležitými anchory jsou:

- `varcSymbolTablePt`;
- `varcSymbolEntryAreaBase`;
- `findOrCreateSymbolOrdinal`;
- `varcCodeEndPt`;
- `varcNewSymbolVectorSlot`;
- `closeDeletedSymbolDataGap`;
- `moveMemoryBlockOverlapSafe`.

Čtěme kapitoly 7, 23 a 24.

## Oblast 30: Formátování čísel, opravy ukazatelů a změny zdroje

Následující obecné utility zahrnují:

- šestnáctkové a desetinné formátování;
- výstup bajtu s pevnou šířkou;
- úpravu ukazatele po vložení;
- mazání zdrojových řádků;
- úpravu ukazatele po smazání;
- helpery stavového řádku;
- porovnání konce zdroje/kódu;
- COPY;
- vložení rozsahu bajtů.

Klíčové labely zahrnují:

- `printNumberToIX`;
- `varcHexMode`;
- `adjustPointerAtHLIfAtOrAfterInsertion`;
- `varcInsertionPointForPointerAdjustment`;
- `deleteSourceLinesAtHL`;
- `adjustPointerAtHLForDeletion`;
- `varcDeletionStartForPointerAdjustment`;
- `invokeCopy`;
- `insertByteRangeAtHLFromDE`.

Tato oblast je mechanickým enginem pod mnoha sémantickými operacemi. Přesouvá
bajty a opravuje společné ukazatele; volající stále odpovídají za význam editoru,
například který záznam se má poté stát aktivním.

Čtěme kapitoly 7, 16 a 17.

## Oblast 31: Sdílené dočasné buffery a scratch paměť

Následuje hustý blok pojmenovaného úložiště:

- `lineBuffer` a jeho ochranná/markerová pozice;
- buffery čísel a argumentů příkazů;
- pole kazetové hlavičky monitoru;
- buffery operandů;
- buffer parsované mnemonic;
- vstupní buffer a jeho ochrana;
- pole načtené kazetové hlavičky;
- scratch pro zachycení přerušení;
- workspace zakódovaného záznamu zdroje;
- podpůrná oblast pod `internalStackTop`.

Tato oblast vysvětluje mnoho dopředných odkazů, s nimiž jsme se setkali dříve.
PROMETHEUS nealokuje dočasné objekty. Opakovaně používá pevné rezidentní
workspaces, jejichž význam se mění podle operace.

Nejdůležitějším pravidlem při úpravách je vlastnictví v čase:

```text
který subsystém je aktivní?
který obsah bufferu musí přežít callback?
může se tento workspace vykonávat jako scratch kód?
roste interní stack do stejné oblasti?
```

Kapitola 5 probírá překryv kódu a dat. Kapitoly 11–14 vysvětlují buffery editoru.
Kapitola 45 vysvětluje vykonávání z workspace zakódovaného záznamu.

## Oblast 32: Chybové zprávy a slovník mnemonic

Na `internalStackTop` přepne zdroj z workspace na statická sbalená jazyková data:

- `errorMessages`;
- `mnemonicsReferences`;
- `mnemonicsTable`.

Tabulka zpráv používá ukončení vysokým bitem. Vektor mnemonic používá
jednobajtové samorelativní displacementy z každé buňky vektoru k jejímu sbalenému
textu.

Fyzické pořadí — vektor odkazů bezprostředně před tabulkou textů — udržuje
všechny displacementy v jednom bajtu. Přesunutí jednoho bez druhého může formát
rozbít, přestože se všechny symbolické labely stále vyřeší.

Kapitola 6 vysvětluje řetězce ukončené vysokým bitem a samorelativní vektory.
Kapitola 20 vysvětluje délkové buckets a indexy mnemonic.

## Oblast 33: Slovník pevných operandů a názvy příkazů editoru

Další statické struktury jsou:

- `operandsReferences`;
- `operandsTable`;
- `operationLabels`;
- názvy příkazů ukončené vysokým bitem, například ASSEMBLY, COPY, FIND a TABLE.

Tabulka pevných operandů ukládá registry, podmínky a pevné závorkové tvary.
Operandy obsahující expressiony představují třídy, nikoli úplné řetězce.

Vektor názvů příkazů podporuje kanonickou expanzi tokenizovaných příkazů editoru.
Několik tokenů se záměrně mapuje na stejné viditelné slovo, a proto se zdánlivě
opakované položky vektoru nesmějí lehkovážně „deduplikovat“.

Čtěme kapitoly 6, 10, 20 a 21.

## Oblast 34: Vložená tabulka 687 záznamů instrukcí

Na tomto místě obsahuje `prometheus.asm`:

```asm
include "instructionTable.asm"
```

Vložený soubor není externí knihovnou v moderním smyslu. Jeho bajty se na tomto
místě vloží přímo do rezidentního payloadu.

Každý pětibajtový záznam spojuje několik významů:

- index mnemonic;
- dvě třídy operandů;
- prefixy a vzor opcode;
- délku instrukce/recept emise;
- časování a další metadata používaná při dekódování/krokování.

Stejná tabulka podporuje:

```text
zdrojový text -> tvar instrukce
tvar instrukce -> strojové bajty
strojové bajty -> zdrojový tvar
strojové bajty -> znalost délky a časování
```

Protože je tabulka velká a pravidelná, kniha nereprodukuje všech 687 záznamů.
Kapitola 20 vysvětluje formát; kapitoly 26, 39 a 46–48 ukazují jeho konzumenty.

Při změně používejme vícesměrný checklist z kapitoly 60. Záznam, který se správně
sestaví, se stále může chybně disassemblovat nebo poskytovat nesprávná metadata
krokování.

## Oblast 35: Počáteční zdroj, prázdná tabulka symbolů a konec payloadu

Poslední emitovaná oblast začíná na:

```asm
sourceBufferStart:
```

Obsahuje dvacet prázdných komprimovaných záznamů. Dva labely označují zvláštní
pozice uvnitř nich:

- `sourceBufferPreviousLine`;
- `sourceBufferAccessLine`.

Výplň dává editoru třináct platných záznamů nad aktivním řádkem a šest pod ním
ještě předtím, než uživatel zadá jakýkoli zdroj.

Za prázdnými záznamy následuje:

```asm
symbolTableDefaultPt:
    defw 0
```

a počáteční společný konec zdroje/symbolů/kódu:

- `codeEndDefaultPt`;
- `defaultPointerAdjustmentSentinel`.

Nakonec:

```asm
relocatablePayloadEnd:
```

neemituje žádné bajty. Je to sémantická hranice používaná expressiony délek
instalátoru, generováním metadat a kontrolami buildu.

Jde o elegantní zakončení. Poslední emitované bajty nejsou mrtvou výplní za
programem; jsou počátečním živým dynamickým stavem, do něhož začne editor
okamžitě růst.

Čtěme kapitoly 3, 12, 15, 16, 23 a 59.

---

# Jak atlas používat při čtení kódu

## Začněme na sémantickém vstupním bodu

Nezačínejme na libovolné adrese z disassembly výpisu. Zvolme vstup dané funkce:

```text
start editoru            startPrometheus
zpracování kláves editoru processKey
odeslání zdroje           submitInputLineOrDispatchCommand
sestavení                 processCompilation
monitor                   startMonitor
single-step               stepAtCurrentMonitorAddress
disassembly               disassembleNextLineToBuffer
instalace                 installerEntryAt5000
```

Čtěme směrem dolů, dokud rutina nepředá práci jiné konceptuální oblasti. Potom
pomocí atlasu přeskočme do této oblasti místo slepého pokračování fyzickým
zdrojem.

## Sledujme data k jejich konzumentovi

Když narazíme na tabulku, vyhledejme rutinu, která ji čte. Když narazíme na
interpreter, vyhledejme jeho tabulku.

Užitečné dvojice zahrnují:

```text
frontPanelItemDescriptors       <-> renderFrontPanelItem
controlFlowDescriptorTable      <-> traced control-flow dispatch
read/write access tables        <-> matchInstructionAccessDescriptor
mnemonicsReferences             <-> compareWithMnemonics
operandsReferences              <-> fixed operand lookup
instructionTable.asm            <-> parser, emitter and decoder
configurationPatchTable.asm     <-> installerAdvancePatchPointer
relocationTable.asm             <-> installerApplyRelocationTable
```

PROMETHEUS často ukládá polovinu algoritmu v kódu a druhou polovinu v kompaktní
tabulce.

## Označme zapisovatelné tvary instrukcí

Kdykoli se objeví label `varc...`, poznamenejme si:

- celou instrukci;
- přesný přepisovaný bajt;
- všechny zapisující rutiny;
- všechny vykonávací cesty, které jej spotřebují;
- zda se relokuje nebo konfiguračně patchuje.

Tím se samomodifikovaný kód promění ze záhady v explicitní záznam stavu.

## Rozlišujme hranice oblastí od obyčejných labelů

Tyto labely ovlivňují build nebo volitelné rozložení a vyžadují větší opatrnost:

```text
bootstrapCopiedFragmentEnd
installerEntryAt5000
relocatablePayloadStart
ENTRY_POINT_WITH_MONITOR
ENTRY_POINT_WITHOUT_MONITOR
sourceBufferStart
relocatablePayloadEnd
```

Přesunutí obyčejné rutiny může změnit relokační offsety. Přesunutí hranice sekce
může navíc změnit, které bajty vůbec existují v produktu pouze s assemblerem.

## Používejme knihu oběma směry

Kapitoly a atlas zdroje tvoří obousměrnou mapu.

Od funkce ke zdroji:

```text
„Chci pochopit FIND“
-> kapitola 17
-> invokeFind / findNextOccurrence
-> sdílený scan callback a matcher lineBufferu
```

Od zdroje k funkci:

```text
„Našel jsem effectiveAddressAccessorOffsets“
-> oblast 12 atlasu
-> kapitola 47
-> predikovaná bezpečnost READ/WRITE při krokování
```

Rejstřík rutin/tabulek plánovaný pro dodatek F toto vyhledávání zpřesní, atlas
však už poskytuje geografii ve velkém měřítku.

# Závěrečná cesta shora dolů

Nyní můžeme celý fyzický soubor shrnout jedinou souvislou větou.

`prometheus.asm` začíná pojmenováním světa Spectra, v němž bude běžet. Malý
bootstrap zjistí, kam distribuovaný obraz skutečně dopadl, a zkopíruje instalátor
do dolního workspace obrazovky. Instalátor se uživatele zeptá, kde a jak má
PROMETHEUS žít, zkopíruje buď úplný rezidentní payload, nebo jeho suffix
assembleru/editoru, aplikuje čtrnáct viditelných konfiguračních voleb, relokuje
1 293 interních slov a předá řízení.

Payload s originem nula začíná volitelným monitorem. Jeho první oblast ukládá
popisy čelního panelu, ochranné rozsahy a stav navigace. Hlavní kód implementuje
pohyb po adresách, prohlížení paměti, blokové nástroje, kazetové operace, zpětné
disassembly a příkazy nativního vykonávání. Engine kontrolovaného vykonávání pak
přepisuje pouze nebezpečné hrany toku řízení, předpovídá paměťové účinky, spustí
skutečnou instrukci ve scratch RAM a zachytí výsledný stav procesoru. Sdílený
disassembler převádí bajty na neutrální řádek; generický výstup a kód čelního
panelu vykreslují tento řádek i uložený procesor. Prefix končí poli uloženého
stavu, tabulkami deskriptorů vykonávání a kompaktními texty monitoru.

Přesně na 5 000 bajtech začíná `ENTRY_POINT_WITHOUT_MONITOR` suffix, který může
přežít samostatně. Dispatch příkazů, operace editoru, příkazy symbolů a nativní
kazetový přenos zdroje vedou k dvouprůchodovému assembleru a evaluatoru
zakódovaných expressionů. Následuje studené/teplé jádro editoru, potom parser
zdroje, expander, klávesnice a obrazovkové služby. Pod nimi leží nízkoúrovňové
rutiny symbolů a přesunu paměti, za nimi sdílené pracovní buffery a sbalené
jazykové slovníky. Vložená tabulka instrukcí poskytuje jediný společný sémantický
popis 687 tvarů instrukcí. Emitovaný obraz zakončuje dvacet prázdných
komprimovaných záznamů a prázdná tabulka symbolů, již připravené stát se
uživatelovým pracovním zdrojem.

To jsou játra PROMETHEA: nikoli jedna ústřední rutina, ale hustý orgán sdílených
reprezentací, jimiž prochází každá funkce.

# Čeho dosáhl hlavní text

Šedesát jedna kapitol nyní pokrylo celý program na architektonické, algoritmické
i zdrojově geografické úrovni:

- část I poskytla techniky Z80 a Spectra potřebné později;
- část II sledovala editor od kláves ke komprimovanému zdroji a zpět;
- část III vysvětlila názvy, expressiony a oba průchody assembleru;
- část IV sledovala zdroj na kazetu a zpět;
- část V vysvětlila zkoumání a disassembly v monitoru;
- část VI rekonstruovala kontrolované vykonávání skutečným Z80;
- část VII vysvětlila bootstrap, instalaci, relokaci a sestavení TAPu;
- část VIII znovu propojila celý stroj, jeho paměťové hospodářství, pravidla
  bezpečných úprav a fyzické rozložení zdroje.

Hlavní vyprávění je dokončeno. Dodatky představují užitečnou práci, nikoli
chybějící architekturu. Poskytnou rychlejší referenční pohledy na materiál, který
kapitoly již vysvětlily: neobvyklé techniky Z80, smlouvy ROM, mapy paměti,
kompaktní formáty, příkazové klávesy, rejstříky rutin/tabulek a zdokumentované
nejistoty.

## Důležité zdrojové anchory

- `bootstrapEntry`
- `installerEntryAt5000`
- `installerConfigurationPatchDeltas`
- `installerApplyRelocationTable`
- `relocatablePayloadStart`
- `ENTRY_POINT_WITH_MONITOR`
- `startMonitor`
- `stepAtCurrentMonitorAddress`
- `disassembleNextLineToBuffer`
- `frontPanelItemDescriptors`
- `readAccessDescriptorTable`
- `controlFlowDescriptorTable`
- `ENTRY_POINT_WITHOUT_MONITOR`
- `processCompilation`
- `startPrometheus`
- `submitInputLineOrDispatchCommand`
- `encodeInputLineToSourceRecord`
- `expandSourceRecordToLineBuffer`
- `processKey`
- `findOrCreateSymbolOrdinal`
- `moveMemoryBlockOverlapSafe`
- `lineBuffer`
- `internalStackTop`
- `mnemonicsReferences`
- `operandsReferences`
- `instructionTable.asm`
- `sourceBufferStart`
- `symbolTableDefaultPt`
- `relocatablePayloadEnd`

## Zpět ke zdroji

Zdrojový soubor už není nutné číst jako hádanku, v níž je každá adresa neznámá.
Jeho oblasti mají role, jeho tabulky mají konzumenty, jeho zapisovatelné operandy
mají vlastníky a jeho hranice mají význam pro build.

Další etapa knihy nepřidá žádný další skrytý subsystém. Promění dokončený výklad
v referenční dodatky, které čtenáři umožní rychle odpovídat na menší otázky a
současně neztratit z očí tuto větší mapu.
