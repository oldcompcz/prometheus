# Kapitola 33: Monitor shora

Editor a assembler nám pomáhají strojový kód **vytvořit**. Monitor nám pomáhá
**setkat se s ním za běhu — nebo ještě dříve, než se jej odvážíme spustit**.

Monitor strojového kódu se někdy popisuje jako soubor pomocných nástrojů:

- zobrazit paměť;
- měnit bajty;
- ukázat registry;
- disassemblovat instrukce;
- hledat nebo přesouvat bloky;
- nastavovat breakpointy;
- vykonat jednu instrukci;
- načítat a ukládat syrovou paměť.

PROMETHEUS obsahuje všechny tyto funkce, ale takový seznam skrývá jeho ústřední
myšlenku. Monitor je interaktivním čelním panelem pro druhý, dočasně pozastavený
stav stroje Z80.

Fyzickým procesorem je stále jediný Z80 ve Spectru. Monitor však uchovává
uloženou sadu uživatelských registrů, současnou adresu, ochranná okna a pravidla
vykonávání. Dovoluje člověku tento pozastavený svět prohlížet a měnit. Když má
kód krokovat nebo spustit, opatrně propůjčí skutečný procesor uživatelskému stavu
a potom si jej znovu vezme zpět.

Mechanismus vykonávání zatím otevírat nebudeme. Ten je tématem části VI. Tato
kapitola projde režim monitoru shora:

```text
vstup do monitoru
    ↓
příprava jeho soukromého zásobníku a sdílené vstupní oblasti
    ↓
vykreslení čelního panelu řízeného deskriptory
    ↓
přečtení jedné normalizované klávesy
    ↓
dispatch příkazu monitoru
    ↓
návrat do teplého vstupu monitoru a nové vykreslení
```

Cílem je, aby rozsáhlý prefix monitoru působil jako jedna soudržná aplikace ještě
předtím, než prozkoumáme jeho jednotlivé nástroje.

## Monitor nemusí být vůbec nainstalován

Úplný rezidentní obraz začíná zde:

```asm
ENTRY_POINT_WITH_MONITOR:
    jp startPrometheus
```

O pět tisíc bajtů později leží:

```asm
ENTRY_POINT_WITHOUT_MONITOR:
    jp startPrometheus
```

Když je instalátor nastaven na `Monitor: No`, zkopíruje pouze suffix začínající
na `ENTRY_POINT_WITHOUT_MONITOR`. Editor a assembler zůstanou, prefix monitoru
však chybí.

Toto fyzické oddělení vysvětluje neobvyklou opravu vstupu poblíž příkazu editoru
`MONITOR`:

```asm
invokeMonitor:
    ld b,"a"
    call containsInputBufferCharacterInB
    call z,processCompilation
    call clearDisplayToSpaces
assemblerOnlyMonitorFallbackOpcode:
    defb 0c3h
assemblerOnlyMonitorFallbackAddress:
    defw startMonitor
```

V úplné instalaci tvoří poslední bajty:

```asm
    jp startMonitor
```

Při instalaci pouze assembleru instalátor opraví cíl tak, aby pokus vyvolat
chybějící monitor neskočil do neexistujícího kódu.

Monitor je tedy volitelný v nejsilnějším možném smyslu: není pouze skrytý, ale z
rezidentního obrazu je fyzicky vynechán.

## Volitelný parametr `A` nejprve sestaví zdroj

Příkaz `MONITOR` může obsahovat parametr `A`:

```asm
    ld b,"a"
    call containsInputBufferCharacterInB
    call z,processCompilation
```

Je-li `A` přítomno, PROMETHEUS před vstupem do monitoru sestaví současný zdroj.

To podporuje přirozený pracovní postup:

```text
editace zdroje
MONITOR A
prohlížení nebo spuštění právě sestaveného výsledku
```

Bez `A` se monitor otevře okamžitě a ponechá existující paměť beze změny.

Po volitelném sestavení se obrazovka editoru vymaže a řízení skočí do
`startMonitor`.

## Teplý vstup místo jedné nekonečné smyčky

Hlavním vstupem je:

```asm
startMonitor:
    di
    call setBorderColor
    ld sp,internalStackTop
    call monitorInputBuffersInitialization
    ...
```

Označit jej za „smyčku“ je přesné jen částečně. Každý příkaz monitoru se běžně
vrací do **nového vyvolání** `startMonitor`.

Tento vstup:

- zakáže přerušení při obnovování stavu monitoru;
- obnoví nastavenou barvu borderu;
- vrátí soukromý interní zásobník na začátek;
- inicializuje sdílené vstupní buffery;
- znovu vytvoří stavový řádek;
- obnoví sdílené handlery chyb a pokračování;
- překreslí celý čelní panel;
- přečte jednu klávesu a předá její příkaz.

Proč pokaždé resetovat zásobník? Příkazy monitoru mohou být složité. Některé
volají rutiny ROM, jiné zobrazují dlouhé výpisy, další dočasně opravují chybové
cesty a některé se připravují vykonat uživatelský kód. Nový vstup přes známý
vrchol zásobníku brání tomu, aby opuštěná nebo neobvyklá cesta postupně
znečišťovala následující příkaz.

Trvalý stav monitoru se proto nemá uchovávat na zásobníku předchozího příkazu.
Žije v:

- uložených polích registrů;
- tabulkách monitoru;
- deskriptorech čelního panelu;
- samomodifikovaných operandech, například současné adrese;
- výslovných strukturách navigace a ochrany.

## Monitor má vlastní stavovou větu

Při vstupu se do `inputBufferStart` vloží čtyři kompaktní tokeny:

```text
UNIVERSUM Control  ON/OFF  Call  NON/DEF/ALL
```

Přesné znění se skládá z kódů tokenů monitoru, nekopíruje se jako jeden dlouhý
řetězec.

První pravidlo oznamuje, zda jsou povoleny kontroly instrukcí. Druhé ukazuje, jak
se při trasování zachází s cíli CALL a RST:

```text
NON  vybrané cíle volání nevykonávat přímo
DEF  vykonávat cíle přítomné v seznamu definovaných adres
ALL  dovolit všechna přímá volání
```

Kód odvozuje viditelné tokeny ze spustitelného stavu:

```asm
    ld a,(varcInstructionControlsDisabled+1)
    add a,0c7h
    ld (hl),a
    ...
    ld a,(directCallModeGateOpcode)
```

`directCallModeGateOpcode` není jen číselné nastavení. Obsahuje jeden ze tří
skutečných opcodů — NOP, RET Z nebo RET — jejichž chování používá trasovací
mechanismus. `startMonitor` zároveň interpretuje hodnoty těchto opcodů jako
kompaktní číslo pravidla pro zobrazení.

Jde o charakteristický styl PROMETHEA: jediný bajt slouží jako vykonávané pravidlo
i jako zakódovaný stav uživatelského rozhraní.

## Sdílené mechanismy editoru se přelaďují pro režim monitoru

Monitor nemá úplně oddělený textový systém. Znovu používá vstupní buffer editoru,
expander tokenů, chybový hook a pokračování po příkazu. Při teplém vstupu je
záměrně obnoví nebo přesměruje.

Změní se základna expanze tokenů:

```asm
    ld hl,l96a4-1
    ld (varcTokenExpansionTableBase+1),hl
```

Editor běžně rozvíjí tokeny assemblerových příkazů. Monitor potřebuje vlastní
kompaktní slovník pro prompty a popisky panelu.

Obnoví se sdílený chybový hook:

```asm
    ld hl,printStatusBar
    ld (errorAction+1),hl
```

Jednotlivé prompty monitoru jej později nahradí, aby se syntaktické chyby mohly
objevit na editačním řádku monitoru a tentýž prompt šlo zopakovat.

Také sdílené hooky zrušení a dokončení se vrátí k bezpečným výchozím hodnotám:

```asm
    ld hl,clearStringBuffers
    ld (abortCommandAndReturnToEditor+1),hl
    ld hl,prometheusWarmStart
    ld (varcPostCommandContinuationJump+1),hl
```

Zpočátku může působit zvláštně, že vstup monitoru obnovuje pokračování do teplého
startu editoru. Jde o obranný úklid. Předchozí operace s kazetou, výpisem nebo
sestavením jednoho řádku mohly sdílené hooky opravit. Nový příkaz monitoru má
začínat ze známého výchozího stavu a teprve potom instalovat dočasné chování,
které potřebuje.

## Syntetická návratová adresa způsobí automatické překreslení příkazů

Jde o jeden z nejčistších triků s tokem řízení v monitoru:

```asm
    ld hl,startMonitor
    push hl
    call redrawFrontPanelAtCurrentAddress
    call readKeyCode
```

`startMonitor` před dispatchí klávesy uloží na zásobník vlastní adresu.

Tabulkový dispatcher později uloží adresu handleru příkazu a provede `RET`.
Zásobník pak pojmově vypadá takto:

```text
vrchol → vybraný handler příkazu
         startMonitor
```

`RET` dispatcheru vstoupí do handleru. Když handler nakonec vykoná své obyčejné
`RET`, vrátí se do `startMonitor`.

K pouhému překreslení panelu není zapotřebí žádný koncový skok specifický pro
příkaz.

V pseudokódu:

```text
push adresa(startMonitor)
push adresa(vybranýHandler)
return                      // vstoupí do vybranýHandler

vybranýHandler nakonec vrátí řízení
    → startMonitor
    → obnova a překreslení panelu
```

Proto lze mnoho handlerů monitoru napsat jako obyčejné podprogramy, přestože jsou
součástí interaktivní příkazové smyčky.

Některé handlery záměrně skáčou jinam — Q se například vrací do editoru a příkaz
trasování může zůstat ve vykonávací smyčce — výchozí chování je však zabudováno
do zásobníku.

## Současná adresa je těžištěm monitoru

Před dispatchí příkazu monitor načte:

```asm
    ld hl,(varcMonitorCurrentAddress+1)
```

Současná adresa je uložena v bezprostředním operandu samomodifikované instrukce:

```asm
varcMonitorCurrentAddress:
    ld hl,00000h
```

Téměř každá operace monitoru začíná na této adrese:

- zobrazení paměti;
- disassemblování;
- posun po bajtech;
- krokování jedné instrukce;
- navigace po adresách;
- sestavení jednoho řádku;
- překreslení čelního panelu.

Tabulkově předávané handlery ji automaticky dostávají v `HL`.

Užitečný první mentální model zní:

> Editor má současný záznam zdroje. Monitor má současnou adresu paměti.

Obě aplikace překreslují okno kolem tohoto středu a dovolují příkazům jej
posouvat nebo znovu vykládat.

## Čelní panel se vytváří z deskriptorů

`redrawFrontPanelAtCurrentAddress` neobsahuje jednu dlouhou natvrdo zapsanou
sekvenci typu „zde vytiskni A, tam BC, jinde paměť“. Místo toho prochází
`frontPanelItemDescriptors`.

Každá položka má sedm bajtů. V hrubých rysech říká:

```text
kam kreslit v bitmapě Spectra
který popisek nebo selector položku určuje
jak se mají hodnoty formátovat
zda je položka pevná, proměnná, skrytá nebo viditelná
odkud pochází její hodnota nebo nepřímá počáteční adresa
```

Mezi typické položky patří:

- editační řádek monitoru;
- jedenáctiřádkové okno výpisu;
- malé okno disassembleru;
- stav přerušení;
- A, B, C, D, E, H a L;
- poloviny indexových registrů;
- příznaky a dvojice registrů;
- oblasti paměti založené na uložených ukazatelích.

Deskriptor okna výpisu například začíná:

```asm
frontPanelListWindowItem:
    defb 000h
    defb 040h
    defb 0a0h
    defb 003h
frontPanelListWindowSizeFlags:
    defb 08bh
    defw 0
```

Spodních pět bitů `$8B` udává výchozí výšku jedenácti řádků. Bit 7 označuje
položku s proměnnou velikostí. Editor čelního panelu může bajty deskriptoru měnit
a běžný renderer se při příštím teplém vstupu okamžitě přizpůsobí novému
rozložení.

Panel je tedy drobné uživatelské rozhraní řízené daty.

Kapitola 34 otevře formát deskriptoru podrobně. Prozatím si zapamatujme tok na
vysoké úrovni:

```text
uložený stav monitoru
    ↓ obecný renderer deskriptorů
viditelný čelní panel
```

## Překreslení je úplnou obnovou stavu

Po každém běžném příkazu zavolá `startMonitor`:

```asm
    call redrawFrontPanelAtCurrentAddress
```

Úplné překreslení se může zdát nákladné, ale přináší výrazné výhody:

- handlery nemusí samy aktualizovat každé ovlivněné pole;
- pohledy na registry, paměť a disassemblování zůstanou vzájemně konzistentní;
- změny formátu panelu se projeví přes tentýž renderer;
- příkazy se mohou soustředit na změnu stavu místo údržby částí obrazovky;
- nový vstup po chybě nebo zrušení výpisu má jediný spolehlivý vizuální výsledek.

Na Z80 s taktem 3,5 MHz to není zadarmo, ale práce s monitorem se řídí lidským
tempem. Jednoduchost kódu a konzistence stavu mají větší cenu než ušetření
několika vykreslených znaků po záměrném stisku klávesy.

## Jedna klávesa se čte až po dokončení panelu

Monitor používá tutéž normalizovanou klávesnicovou rutinu, kterou jsme poznali v
editoru:

```asm
    call readKeyCode
```

Před dispatchí vymaže bitmapový řádek editačního pole monitoru, aby pod další
operací nezůstal předchozí prompt:

```asm
    call getMonitorEditLineBitmapRowStart
    call clearBitmapTextRow
```

Několik důležitých kláves se testuje přímo, protože jejich akce jsou ústřední
nebo vyžadují zvláštní tok řízení:

```asm
    cp 071h
    jp z,startPrometheus

    cp 014h
    jp z,invokeFrontPanelEditor

    cp 023h
    jp z,invokeToggleNumberBase

    cp 03ah
    jp z,stepInstructionAtHL

    cp 02ch
    jp z,setRegisterValue

    cp 003h
    jp z,clearDisplay
```

Představují mimo jiné:

- Q: návrat do editoru PROMETHEA;
- SYMBOL SHIFT+W: editaci rozložení čelního panelu;
- SYMBOL SHIFT+3: přepínání desetinného a šestnáctkového zobrazení;
- SYMBOL SHIFT+Z: krokování současné instrukce;
- SYMBOL SHIFT+N: nastavení hodnoty registru;
- CAPS SHIFT+0: obnovení nebo vymazání obrazovky monitoru.

Zbývající příkazy používají kompaktní tabulku.

## Čtyřicet vazeb v tabulce rozdílů adres

Monitor má čtyřicet klávesových vazeb předávaných tabulkou. Dispatcher začíná:

```asm
    ld c,a
    ld b,028h
    ld hl,monitorKeyboardActions
    ld de,monitorKeyboardActionsTable
```

Každá položka tabulky obsahuje:

```text
neznaménkový rozdíl od předchozího handleru
normalizovaný kód klávesy
```

Při procházení se rozdíl kumulativně přičítá k `HL`:

```asm
.scanMonitorKeyBindings:
    ld a,(de)
    inc de
    call addAtoHL
    ld a,(de)
    cp c
    inc de
    jr z,.invokeMatchedMonitorKeyBinding
    djnz .scanMonitorKeyBindings
```

Při shodě:

```asm
.invokeMatchedMonitorKeyBinding:
    push hl
    ld hl,(varcMonitorCurrentAddress+1)
    ret
```

Vypočtená adresa handleru se uloží na zásobník, do `HL` se obnoví současná adresa
a `RET` vstoupí do handleru.

Jde o další kompaktní náhradu velké tabulky dvoubajtových adres. Handlery jsou v
paměti uspořádány dostatečně blízko, takže stačí jednobajtové dopředné rozdíly.

Výchozí kontrakt zní:

```text
vstup:
    HL = současná adresa monitoru

na zásobníku pod handlerem:
    startMonitor

běžné RET:
    překreslení monitoru
```

## Jaké druhy příkazů se skrývají za tabulkou?

Prozkoumáme je v pozdějších kapitolách, ale už nyní pomůže jejich členění shora.

### Navigace po adresách

Příkazy mohou:

- výslovně nastavit současnou adresu;
- posunout se o jeden bajt dozadu nebo dopředu;
- posunout se o jednu dekódovanou instrukci;
- ukládat adresy na malý navigační zásobník a znovu je z něj vybírat.

### Prohlížení a editace paměti

Monitor může zobrazovat bajty, slova nebo znaky a může paměť upravovat po jedné
položce nebo souvisle.

### Disassemblování a vytváření zdroje

Dokáže dekódovat instrukce na text, vypsat nebo vytisknout rozsah a vkládat
dekódované řádky do editoru zdroje PROMETHEA.

### Blokové operace

Dokáže hledat s maskami, vyplňovat paměť, přesouvat překrývající se bloky a
prohlížet rozsahy.

### Registry a řízení vykonávání

Dokáže měnit uložené registry, krokovat instrukci, automaticky trasovat, spravovat
breakpointy a rozhodovat, jak se zachází s instrukcemi CALL a RST.

### Editace ochrany

Zpřístupňuje uzavřené rozsahy zakazující čtení, zápis nebo vykonávání. Má také
tabulky zobrazovaných oblastí DEFB/DEFW, které ovlivňují disassemblování.

### Kazetové operace

Dokáže načítat, ověřovat a ukládat syrové bloky paměti nezávisle na
strukturovaných příkazech pro projekty zdroje z části IV.

Monitor má široký rozsah, protože je pracovním prostředím pro experimenty se
strojovým kódem, nikoli pouze debuggerem připojeným k assembleru.

## Vstup monitoru používá známý 32bajtový pracovní prostor

Příkazy potřebující hodnotu volají `promptForMonitorValue`. Příkazy sestavující
jednu instrukci používají `assembleMonitorInputLine`. Oba znovu používají běžný
vstupní buffer a velkou část běžného parseru výrazů nebo zdroje.

Monitor mění tři okolní podrobnosti:

1. kde se prompt vykresluje;
2. kde se zobrazují chyby;
3. kam po úspěšném dokončení pokračuje řízení.

Číselný prompt nakonec vstupuje do běžného vyhodnocovače výrazů, takže uživatel
může zadat například:

```text
32768
#8000
%10101010
'A'
$
SYMBOL+2
```

Při sestavení jednoho řádku používá monitor běžný parser zdroje a stejné handlery
záznamů prvního a druhého průchodu, nevkládá však záznam do uživatelova
komprimovaného zdroje.

Toto znovupoužití přesně odpovídá vzoru, který jsme viděli u LOAD a GENS:

```text
zvláštní funkce připraví běžný vstup
    ↓
důvěryhodný parser nebo vyhodnocovač provede sémantickou práci
```

## Okno výpisu má neobvyklé pravidlo pokračování

Mnoho operací monitoru vytváří více řádků, než se vejde do okna výpisu na panelu.
Sdíleným pomocníkem výstupu je:

```asm
outputMonitorListLineAndPollContinuation:
    call appendLineBufferToMonitorListWindow
    xor a
    in a,(0feh)
    cpl
    and 01fh
    ret nz
    call readKeyCode
    cp 004h
    ret nz
```

Chybějící závěrečné `RET` je záměrné. Je-li nově vědomě stisknutou klávesou EDIT
(normalizovanou jako `$04`), provádění propadne přímo do `startMonitor`, který je
ve zdroji fyzicky následující.

Chování je:

```text
while je některá klávesa fyzicky držena:
    okamžitě posílej další řádky

když není držena žádná klávesa:
    čekej na vědomý stisk

if je klávesou EDIT:
    vrať se do monitoru propadnutím
else:
    pokračuj ve výpisu
```

Toto uspořádání umožňuje rychlý souvislý výstup při držené klávese a jednoduché
zastavení klávesou EDIT.

Zároveň ukazuje, proč rekonstrukce assemblerového zdroje vyžaduje pozornost k
fyzickému propadnutí. Chybějící `RET` nemusí znamenat poškození.

## Soukromý svět uloženého stavu monitoru

Ještě před vysvětlením krokování jsou viditelné různé kategorie stavu:

```text
uložené hlavní registry
uložené alternativní registry
uložené IX a IY
uložené SP, I, R a stav přerušení
současná adresa monitoru
navigační zásobník adres
deskriptory čelního panelu
oblasti zobrazení DEFB/DEFW
rozsahy NO READ / NO WRITE / NO RUN
seznam přímých cílů CALL/RST
pravidla kontroly instrukcí
akumulátor času trasování
```

Některé jsou běžnými datovými bajty. Jiné tvoří operandy uvnitř instrukcí. Další
jsou seznamy s posunutým počtem nebo kompaktní deskriptory.

Čelní panel je pohledem do tohoto světa. Editace zobrazeného registru nemusí
změnit registr, který právě používá samotný běžící monitor. Mění **uložený
uživatelský stav**, jenž bude obnoven při spuštění nebo krokování uživatelského
kódu.

Toto rozlišení je zásadní:

```text
pracovní registry monitoru:
    dočasné nástroje, které PROMETHEUS právě používá

uložené uživatelské registry:
    model zkoumaného programu
```

Část VI ukáže, jak program mezi oběma světy přechází.

## Monitor chrání sám sebe před svým předmětem

Monitor, který spouští libovolný strojový kód, čelí paradoxu: zkoumaný kód může
přepsat samotný monitor, jeho zásobník, tabulky nebo obrazovku používanou k
hlášení výsledku.

PROMETHEUS tento problém řeší několika ochrannými strukturami:

- rozsahy zakazující čtení;
- rozsahy zakazující zápis;
- rozsahy zakazující vykonávání;
- automatická dynamická ochrana vlastní rezidentní oblasti;
- analýza instrukce před každým krokem;
- zvláštní zacházení s disassemblováním uvnitř rezidentních datových oblastí.

Ochranný systém nedokáže libovolný kód učinit dokonale bezpečným. Z80 nemá
jednotku správy paměti. Dovoluje však monitoru odmítnout mnoho nebezpečných
operací ještě předtím, než uživatelské instrukci propůjčí procesor.

Tyto kontroly prozkoumáme v kapitolách 38 a 47.

## Monitor je také druhým uživatelským rozhraním postaveným z prvního

Nyní se ukazuje širší návrh.

Editor a monitor vypadají odlišně, ale sdílejí:

- normalizaci klávesnice;
- expanzi kompaktních tokenů;
- 32bajtovou vstupní oblast;
- vyhodnocování číselných a symbolických výrazů;
- vykreslování řádkového bufferu;
- rutiny znaků obrazovky;
- wrappery kazetové ROM;
- opravování pokračování;
- stavové a chybové hooky;
- slovník instrukcí.

Mění se okolní stavový automat.

Ústředním objektem editoru je záznam zdroje. Ústředním objektem monitoru je
adresa paměti a uložený stav procesoru.

Příkazová smyčka editoru se ptá:

```text
Co se má stát se zdrojem kolem aktivního záznamu?
```

Monitor se ptá:

```text
Co se má zobrazit nebo provést kolem současné adresy a uloženého stavu CPU?
```

PROMETHEUS nejsou dvě úplně oddělené aplikace. Je to jedna kompaktní sada
parserů, rendererů a paměťových rutin uspořádaná do dvou odlišných dílen.

## Vrcholová smyčka monitoru v pseudokódu

Pomineme-li zvláštní příkazy, které se nevracejí, vypadá teplá smyčka takto:

```text
function startMonitor():
    zakažPřerušení()
    obnovBorder()
    SP = internalStackTop
    inicializujSdílenýVstupMonitoru()

    sestavStavovéTokeny(
        instructionControlPolicy,
        directCallPolicy
    )
    vykresliVstupníŘádekMonitoru()

    vyberSlovníkTokenůMonitoru()
    obnovVýchozíSdílenéChybovéAHookyZrušení()

    push startMonitor jako vnější návrat
    překresliČelníPanel(currentAddress)

    key = přečtiNormalizovanouKlávesu()
    vymažŘádekPromptuMonitoru()

    if key je přímáZvláštníKlávesa:
        jump do jejího handleru

    handler = najdiVeČtyřicetipoložkovéTabulceRozdílů(key)
    if nalezen:
        HL = currentAddress
        returnDo(handler)

    vyzkoušejSdílenéKlávesyOblasti(key)
```

Běžný handler změní stav monitoru a vykoná `RET`. Syntetický vnější návrat znovu
vstoupí do `startMonitor`, který vše překreslí ze změněného stavu.

## Sledování jedné jednoduché akce

Předpokládejme, že uživatel stiskne klávesu přiřazenou k příkazu „další bajt“.

Cesta je:

```text
1. startMonitor znovu sestaví panel a přečte klávesu
2. přímé testy se neshodují
3. procházení čtyřicetipoložkové tabulky najde navigační handler
4. dispatcher uloží tento handler na zásobník
5. dispatcher načte HL=současná adresa
6. RET vstoupí do handleru
7. handler zvýší HL
8. handler uloží HL do varcMonitorCurrentAddress+1
9. handler provede RET
10. syntetický návrat vstoupí do startMonitor
11. čelní panel se překreslí kolem nové adresy
```

Samotný handler může obsahovat jen několik instrukcí, protože vstup, opětovné
zobrazení a předání stavu zajišťuje společný rámec.

Tak v malém vypadá vrcholová architektura monitoru.

## Co se změnilo v paměti

Během jednoho běžného příkazu monitoru:

- `SP` se při teplém vstupu resetuje na `internalStackTop`;
- stavové tokeny monitoru dočasně obsadí `inputBufferStart`;
- sdílené operandy tokenů, chyb, zrušení a pokračování se obnoví nebo přeladí;
- bitmapa čelního panelu se znovu vytvoří z deskriptorů a uložených dat stavu;
- příkaz může změnit současnou adresu, uložené registry, paměť, tabulky nebo
  pravidla;
- běžné `RET` znovu vstoupí do `startMonitor` a zahodí starý zásobník příkazu.

Komprimovaný zdroj editoru obvykle zůstává nedotčen, pokud příkaz výslovně
nesestavuje řádek zdroje nebo nevkládá disassemblování do editoru.

## Důležité labely, které jsme potkali

- `ENTRY_POINT_WITH_MONITOR`
- `ENTRY_POINT_WITHOUT_MONITOR`
- `invokeMonitor`
- `assemblerOnlyMonitorFallbackAddress`
- `startMonitor`
- `internalStackTop`
- `monitorInputBuffersInitialization`
- `varcTokenExpansionTableBase`
- `varcMonitorCurrentAddress`
- `redrawFrontPanelAtCurrentAddress`
- `frontPanelItemDescriptors`
- `monitorKeyboardActions`
- `monitorKeyboardActionsTable`
- `outputMonitorListLineAndPollContinuation`
- `promptForMonitorValue`
- `assembleMonitorInputLine`

## Myšlenky potřebné v pozdějších kapitolách

- Vzhled čelního panelu je uložen v datech, nikoli v pevné kreslicí rutině.
- Syntetická návratová adresa způsobí, že se běžné handlery monitoru automaticky
  překreslí.
- Monitor rozlišuje vlastní pracovní registry od uloženého uživatelského stavu
  CPU.
- Současná adresa plní stejnou organizační roli jako aktivní řádek zdroje v
  editoru.
- Sdílené parsery a renderery se přelaďují opravenými hooky, místo aby se
  duplikovaly.
- Ochranu a řízení vykonávání nelze oddělit od krokování libovolného kódu.

## Pokrytí zdroje

Tato kapitola vysvětluje `invokeMonitor`, teplý vstup v `startMonitor`, jeho
obnovu sdílených hooků, sestavení stavu, překreslení čelního panelu, přímé testy
kláves, čtyřicetipoložkový dispatch rozdílů a konvenci syntetického návratu.
Podrobné deskriptory panelu, navigační příkazy, paměťové operace, ochranné
tabulky, disassembler a krokování zůstávají pro kapitoly 34–49.
