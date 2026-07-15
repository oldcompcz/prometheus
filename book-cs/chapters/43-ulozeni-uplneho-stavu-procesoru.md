# Kapitola 43: Uložení úplného stavu procesoru

Až dosud se monitor choval jako opatrný pozorovatel. Četl bajty, formátoval
registry, dekódoval instrukce, prohledával paměť a upravoval vybraná místa. Při
žádné z těchto činností nemusel PROMETHEUS odevzdat řízení procesoru Z80.

Single-step je jiný.

Aby PROMETHEUS vykonal jednu instrukci přesně tak, jak by ji vykonal zkoumaný
program, musí mu na okamžik přenechat celý procesor. V akumulátoru musí být
uživatelův akumulátor, ne dočasná hodnota monitoru. Flags musí patřit uživateli.
Musí se obnovit běžná i alternativní sada registrů. Stack pointer musí ukazovat
na uživatelův stack. Záleží dokonce i na stavu přerušení a refresh registru.

Tím vzniká ústřední problém části VI:

> Jak se může monitor na okamžik stát jiným programem a potom se vrátit s věrným
> obrazem toho, co se stalo?

Odpověď začíná úplným uloženým obrazem procesoru.

## Dva stroje sdílející jeden Z80

Fyzický procesor je jen jeden, ale monitor s ním zachází, jako by se na něm
střídaly dva logické stroje.

Prvním je **stroj monitoru**. Má:

- soukromý stack PROMETHEA;
- dočasné hodnoty registrů používané rutinami monitoru;
- stav obrazovky a klávesnice;
- ukazatele do zdroje, symbolů a tabulek;
- callbacky opravené přímo do instrukcí.

Druhým je **stroj uživatele**. Má:

- hodnoty registrů zobrazené na čelním panelu;
- uživatelův stack pointer;
- uživatelův stav přerušení;
- logický program counter představovaný současnou adresou monitoru;
- průběžný součet času vykonávání.

Když monitor čeká na klávesu, obsahuje fyzický Z80 stav stroje monitoru. Stav
stroje uživatele žije v paměti.

Když se vykonává instrukce, role se obrátí:

```text
před vykonáním
    fyzický Z80 = stav monitoru
    obraz v paměti = stav uživatele

obnova
    fyzický Z80 = stav uživatele
    adresa stacku monitoru zapamatována v opraveném kódu

vykonej jednu připravenou instrukci

zachycení
    obraz v paměti = nový stav uživatele
    fyzický Z80 = dočasný stav zachycování

obnov stack monitoru
    fyzický Z80 = znovu stav monitoru
```

Uložený obraz proto není záloha vytvářená jen pro nouzové situace. Je běžným
domovem uživatelského procesoru pokaždé, když má řízení PROMETHEUS.

## Uložený obraz má tvar stacku

Poblíž konce rezidentního payloadu leží kompaktní blok začínající na
`savedRegisterR`:

```asm
savedRegisterR:
    defb 000h
savedRegisterI:
    defb 000h
savedAlternateRegisterSet:
    defs 8
savedRegisterIY:
    defb 03ah
savedRegisterIYHigh:
    defb 05ch
savedRegisterIX:
    defb 000h
savedRegisterIXHigh:
    defb 000h
savedRegisterBC:
    defb 0ffh
savedRegisterB:
    defb 0afh
savedRegisterDE:
    defb 001h
savedRegisterD:
    defb 001h
savedRegisterHL:
    defb 000h
savedRegisterH:
    defb 000h
savedRegisterAF:
    defb 000h
savedRegisterA:
    defb 000h
savedRegisterSP:
    defw 0
accumulatedTStates:
    defw 0
monitorAddressX:
    defw 0
monitorAddressY:
    defw 0
```

Zdánlivě podivné pořadí je záměrné. Část s registry lze spotřebovat posloupností
instrukcí Z80 `POP`.

Přehlednější mapa vypadá takto:

```text
offset  velikost  uložená hodnota
------  --------  --------------------------------
  0        1      R
  1        1      I
  2        2      BC'
  4        2      DE'
  6        2      HL'
  8        2      AF'
 10        2      IY
 12        2      IX
 14        2      BC
 16        2      DE
 18        2      HL
 20        2      AF
 22        2      SP
 24        2      průběžný součet T states
 26        2      adresa monitoru X
 28        2      adresa monitoru Y
```

První dva bajty tvoří jedno praktické slovo pro obnovu: po vyzvednutí do `HL`
dostane `L` registr R a `H` registr I. Za nimi už jsou všechny dvojice registrů
uspořádány v bajtovém pořadí stacku.

Je to pěkný příklad datové struktury navržené podle instrukcí, které ji budou
spotřebovávat. Moderní program by možná definoval záznam a pro každé pole napsal
samostatnou operaci načtení. PROMETHEUS uspořádá záznam tak, aby mohl většinu
stavu obnovit přesunutím `SP` na blok a několika instrukcemi `POP`.

## Little-endian slova a užitečné aliasy

Z80 ukládá slovo do paměti nižším bajtem jako prvním. Uložené `BC` proto vypadá
takto:

```text
savedRegisterBC   = C
savedRegisterB    = B
```

Podobně:

```text
savedRegisterDE   = E
savedRegisterD    = D
savedRegisterHL   = L
savedRegisterH    = H
savedRegisterAF   = F
savedRegisterA    = A
```

Tyto labely neoznačují duplicitní paměť. Jsou to jména různých bajtových pozic
uvnitř týchž slov.

To je důležité pro čelní panel. Deskriptor registru A může ukazovat přímo na
`savedRegisterA`, zatímco deskriptor AF může ukazovat na `savedRegisterAF` a
požadovat dvoubajtové zobrazení.

Stejná paměť tak může bez kopírování nebo přerovnávání podporovat oba pohledy:

```text
A  = $3E
F  = $45
AF = $3E45
```

## Program counter je uložen jinde

Možná jste si všimli, že uložený obraz neobsahuje pole jménem PC.

Z80 nemá běžnou instrukci typu `LD HL,PC`. Ještě důležitější však je, že
PROMETHEUS už má pro logický program counter přirozené místo: současnou adresu
monitoru.

Samomodifikovaný operand na `varcMonitorCurrentAddress` plní několik úloh:

- je adresou, kolem níž se kreslí čelní panel;
- je počáteční adresou pro navigaci po instrukcích;
- je adresou předávanou rutině `stepInstructionAtHL`;
- po úspěšném kroku se stane zachyceným následujícím PC.

Logický stroj uživatele je proto rozdělen mezi tři blízké formy stavu:

```text
uložený obraz procesoru  registry, SP, I, R, čas a monitor X/Y
současná adresa monitoru logický PC
operand stavu přerušení  logický stav DI/EI
```

Toto rozdělení je praktické, ne teoreticky čisté. Monitor potřebuje současnou
adresu i tehdy, když se žádná instrukce nevykonává. Její použití jako uloženého
PC šetří další slovo a udržuje prohlížení i vykonávání zaměřené na stejné místo.

## Stav přerušení je vykonatelný bajt

Stav povolení přerušení není uložen uvnitř souvislého bloku registrů. Žije v
immediate operandu této instrukce:

```asm
varcInterruptEnableState:
    ld a,000h
```

Konvence zní:

```text
0 = přerušení zakázána, DI
1 = přerušení povolena, EI
```

Renderer čelního panelu tento operand čte a převádí jej na zobrazovanou
mnemoniku. Builder vykonávacího trampolínu čte tentýž operand a mění jej na
skutečný bajt instrukce.

Převod je kompaktní:

```asm
ld a,(varcInterruptEnableState+1)
add a,a
add a,a
add a,a
add a,0f3h
```

Pro nulu je výsledkem `$F3`, opcode instrukce `DI`.
Pro jedničku je výsledkem `$FB`, opcode instrukce `EI`.

V pseudokódu:

```text
interruptOpcode = $F3 + 8 * savedInterruptBoolean
```

Funguje to proto, že se oba opcodes náhodou liší o osm.

Jeden bajt znovu plní několik úloh:

- zapamatovaný stav uživatele;
- data čelního panelu;
- vstup pro konstrukci trampolínu.

## Editace uloženého stavu bez dotyku fyzických registrů

Kapitola 34 ukázala, že položky čelního panelu odkazují do paměti. Když uživatel
upraví A, HL, SP nebo jiný registr, změní PROMETHEUS uložený obraz, ne současný
pracovní registr monitoru.

To je nezbytné. Představme si, že monitor během parsování nové hodnoty
uživatelova registru HL používá své fyzické `HL`. Kdyby výsledek zapsal pouze do
fyzického registru, zmizel by hned po návratu příkazu, jakmile by monitor použil
HL k něčemu jinému.

Místo toho:

```text
načti novou hodnotu
    -> najdi adresu uložené hodnoty z deskriptoru
    -> zapiš ji do uloženého obrazu procesoru
    -> pozdější obnova ji načte do skutečného registru
```

Uživatel upravuje příští stav procesoru, který se obnoví.

Stejný princip vysvětluje `monSwapPrimaryAndAlternateRegisters`. Rutina neprovede
`EXX` ani `EX AF,AF'`, protože by tyto instrukce prohodily živé registry monitoru.
Místo toho vymění dvě osmibajtové oblasti paměti:

```asm
monSwapPrimaryAndAlternateRegisters:
    ld b,008h
    ld hl,savedRegisterBC
    ld de,savedAlternateRegisterSet
.swapNextPrimaryAlternateRegisterByte:
    ld c,(hl)
    ld a,(de)
    ld (hl),a
    ld a,c
    ld (de),a
    inc hl
    inc de
    djnz .swapNextPrimaryAlternateRegisterByte
    ret
```

Příkaz vymění uložené `BC/DE/HL/AF` za uložené `BC'/DE'/HL'/AF'`. IX, IY, SP, I,
R a stav přerušení se nezmění.

Je to bezpečnější a pojmově čistší než narušovat stroj monitoru.

## Obnova obrazu registrů

Skutečnou obnovu provádí rutina `restoreUserStateAndExecuteTrampoline`. Její
první polovina je pečlivě seřazené rozbalení:

```asm
ld sp,savedRegisterR
pop hl
ld a,l
ld r,a
ld a,h
ld i,a
pop bc
pop de
pop hl
pop af
exx
ex af,af'
pop iy
pop ix
pop bc
pop de
pop hl
pop af
ld sp,(savedRegisterSP)
jp encodedRecordStorageLength
```

Přečtěme si ji pomalu.

### 1. Zapamatování stacku monitoru

Než se `SP` změní, zapíše se jeho současná hodnota do operandu pozdější
instrukce:

```asm
ld (varcRestoreMonitorStackAfterExecution+1),sp
```

Tento opravený operand je cestou domů. Jakmile se načte uživatelův SP, přestane
být běžný call stack monitoru aktivním stackem.

### 2. Nasměrování SP na uložený obraz

```asm
ld sp,savedRegisterR
```

Instrukce `POP` nyní čtou uložený záznam.

### 3. Obnova R a I

První slovo se vyzvedne do HL:

```text
L = uložené R
H = uložené I
```

Hodnoty se přenášejí přes A, protože Z80 umí načíst I a R pouze prostřednictvím
A:

```asm
ld a,l
ld r,a
ld a,h
ld i,a
```

### 4. Obnova alternativní sady

Další čtyři instrukce `POP` získají uložené `BC'`, `DE'`, `HL'` a `AF'`. Zpočátku
jsou fyzicky ve právě viditelné sadě. Potom:

```asm
exx
ex af,af'
```

přesune jejich hodnoty do architektonických alternativních sad.

### 5. Obnova indexových a primárních registrů

Další hodnoty se vyzvednou do IY, IX, BC, DE, HL a AF.

### 6. Obnova uživatelova stacku

Nakonec:

```asm
ld sp,(savedRegisterSP)
```

Uživatelův stack je aktivní. Od této chvíle rutina nemůže bezpečně použít `CALL`
ani `RET` přes stack monitoru. Skočí přímo do scratch programu.

Algoritmus obnovy tedy zní:

```text
zapamatuj monitor SP
oprav uložené R pro nadcházející fetch operace monitoru a trampolínu
SP = adresa uloženého obrazu
obnov R a I
obnov alternativní sadu registrů
obnov IY a IX
obnov primární sadu registrů
SP = uložené uživatelské SP
skoč do připravené scratch instrukce
```

## Proč R potřebuje korekci

Refresh registr R je neobvyklý. Jeho spodních sedm bitů se zvyšuje při fetch
operacích instrukcí. Samotný průchod obnovovacím a zachycovacím kódem monitoru
jej mění.

PROMETHEUS chce, aby uložená hodnota R co nejvěrněji popisovala uživatelský
program, ne počet instrukcí monitoru vykonaných při přípravě experimentu.

Helper `adjustSavedRefreshRegisterLow7` přičte korekci k bitům 0 až 6 a zachová
bit 7:

```asm
adjustSavedRefreshRegisterLow7:
    ld hl,savedRegisterR
    add a,(hl)
    xor (hl)
    and 07fh
    xor (hl)
    ld (hl),a
    ret
```

Tato posloupnost může vypadat tajemně, ale její účel lze říci jednoduše:

```text
nových spodních sedm bitů = starých spodních sedm bitů + korekce
nový bit 7                = starý bit 7
```

Různé cesty používají různé korekční konstanty, protože před uživatelskou
instrukcí nebo po ní provedou různý počet fetch operací. Přesné konstanty jsou
implementační účetnictví, ne součást uživatelova programu.

Důležitá myšlenka je, že R nelze naivně uložit a obnovit, má-li monitor ukazovat
uvěřitelnou trasovanou hodnotu.

## Opětovné zachycení stavu uživatele

Po vykonání připravené instrukce skočí kód do jednoho ze vstupů zachycení. V tom
okamžiku:

- primární registry obsahují výsledky uživatele;
- alternativní registry obsahují alternativní výsledky uživatele;
- SP je výsledný uživatelův SP;
- I a R jsou živé architektonické registry;
- stack monitoru není aktivní.

Kód zachycení musí vše serializovat dříve, než se vrátí k běžnému kódu monitoru.

První operací je:

```asm
ld (savedRegisterSP),sp
```

Tím se zaznamená výsledný stack pointer uživatele.

PROMETHEUS potom dočasně použije svůj scratch workspace jako malý stack, zatímco
shromažďuje AF, I a R. Před obnovením vlastnictví monitoru provede `DI`, aby
nemohlo přijít přerušení uprostřed citlivého prohazování sad registrů a stacků.

Později `.saveRemainingUserState` ukládá hodnoty do oblasti uloženého obrazu v
opačném pořadí, než v jakém je čtou obnovovací instrukce `POP`:

```asm
push bc
push ix
push iy
exx
ex af,af'
push af
push hl
push de
push bc
ld a,i
ld h,a
ld a,r
ld l,a
push hl
```

Protože je `SP` nastaven na konec oblasti registrů, vyplní tyto instrukce `PUSH`
obraz odzadu, dokud R a I neleží v jeho prvních dvou bajtech.

Obecný algoritmus zachycení zní:

```text
ulož výsledné uživatelské SP
zachovej primární AF, HL a DE
získej I a R spolu s jejich flags
ulož primární BC, IX a IY
přepni na alternativní sady
ulož AF', HL', DE' a BC'
ulož I a R na začátek obrazu
obnov monitor SP
oprav uložené R
obnov logický stav přerušení
vrať se do kódu monitoru
```

## Zachycení povolení přerušení bez přímého čtení IFF

Z80 nemá běžnou instrukci, která by zkopírovala jeho interrupt flip-flop přímo
do obecného registru. Instrukce `LD A,I` a `LD A,R` však za běžných podmínek
kopírují stav povolení přerušení do flagu P/V.

PROMETHEUS používá během zachycení obě instrukce a ukládá jejich flags do malé
dočasné oblasti poblíž sdíleného vstupního bufferu. Potom provede OR příslušných
bajtů flagů a zredukuje bit 2 na booleovskou nulu nebo jedničku:

```asm
ld hl,interruptStateCaptureScratch
ld a,(hl)
dec hl
dec hl
or (hl)
and 004h
rrca
rrca
ld (varcInterruptEnableState+1),a
```

Pojmově:

```text
pv = flag PV pozorovaný při čtení I nebo R
savedInterruptBoolean = pv ? 1 : 0
```

Komentáře ve zdroji tento výsledek správně popisují jako aproximaci uživatelova
stavu přerušení. Je to chytré využití informací, které Z80 zpřístupňuje, nikoli
kouzelné přímé čtení každého skrytého klopného obvodu přerušení.

Pro mentální model knihy je důležitý stabilní výsledek:

- panel může zobrazit DI nebo EI;
- uživatel může stav přepnout;
- příští scratch program začne odpovídajícím opcode;
- zachycení zapamatovaný stav po vykonání aktualizuje.

## Vstupy zachycení pro sekvenční a provedenou větev

Existují dva běžné vstupy zachycení:

- `captureUserStateAfterSequentialFlow`;
- `captureUserStateAfterTakenFlow`.

Oba serializují registry stejným způsobem. Liší se logickým výsledkem, který ke
kroku připojí.

Sekvenční vstup dodá:

- flag cesty 0;
- běžný počet T states z dekodéru;
- adresu bezprostředně za původní instrukcí.

Vstup provedené větve dodá:

- flag cesty 1;
- handlerem upravený počet T states pro provedenou větev;
- skutečný cíl větve, volání, návratu nebo nepřímého skoku.

U instrukce jako `INC A` není toto rozlišení potřeba; vždy pokračuje sekvenčně.
Zásadní začne být u podmíněného řízení toku. Kapitola 46 ukáže, jak se scratch
instrukce přepisuje tak, aby oba výsledky skončily ve správném vstupu zachycení.

Existuje také `breakpointHitCaptureEntry`, který záměrně přejde do rozložení
sekvenčního zachycení. Kapitola 44 vysvětlí, proč jediný `NOP` stačí k tomu, aby
dočasný breakpoint sdílel tutéž serializační rutinu stavu.

## Co uložený obraz neslibuje

Je lákavé nazvat tento obraz dokonale zmrazeným Z80. To by bylo příliš silné
tvrzení.

PROMETHEUS ukládá stav požadovaný svým modelem monitoru, některé architektonické
a okolní podrobnosti však leží mimo obraz:

- PC je samostatně představován současnou adresou monitoru;
- stav přerušení se rekonstruuje z dostupných flags;
- samotný režim přerušení není nabízen jako samostatné uložené editovatelné pole;
- externí zařízení a stav ULA se nevracejí zpět;
- změny paměti provedené vykonanou instrukcí zůstávají změnami;
- přerušení nebo hardwarová událost mohou mít následky přesahující obraz
  registrů.

Na kompaktní 48K monitor jde přesto o působivě úplný snapshot procesoru. Návrh
zachycuje obě běžné sady registrů, indexové registry, SP, I, R, flags, logické
povolení přerušení a časové účetnictví potřebné pro step engine.

## Úplná okružní cesta stavem

Celý mechanismus nyní můžeme vyjádřit pseudokódem:

```text
function executePreparedExperiment():
    monitorSP = SP

    adjustSavedRForRestorationPath()

    R, I = saved.R, saved.I
    BC', DE', HL', AF' = saved.alternateRegisters
    IY, IX = saved.IY, saved.IX
    BC, DE, HL, AF = saved.primaryRegisters
    SP = saved.SP

    skoč do scratchProgram

captureEntry:
    saved.SP = SP
    zachovej výsledky uživatele
    zakaž přerušení po dobu práce monitoru

    saved.primaryRegisters = BC, DE, HL, AF
    saved.IX, saved.IY = IX, IY
    saved.alternateRegisters = BC', DE', HL', AF'
    saved.I, saved.R = I, R

    SP = monitorSP
    correctSavedRForCapturePath()
    saved.interruptEnabled = deriveFromCapturedFlags()

    return do řadiče monitoru
```

Scratch program uprostřed zde záměrně zůstává neurčitý. Může obsahovat jednu
zkopírovanou běžnou instrukci, přepsanou větev, nativní `CALL` nebo nativní skok
k dočasnému breakpointu. Kapitoly 44 a 45 tyto formy vybudují.

## Zpět k celému stroji

Čelní panel je teď více než displej. Je viditelným editorem obrazu procesoru,
který PROMETHEUS dokáže zhmotnit ve skutečném Z80.

Cyklus vypadá takto:

```text
hodnoty čelního panelu
    -> uložený obraz procesoru
    -> obnova založená na POP
    -> vykonání skutečné instrukce
    -> zachycení založené na PUSH
    -> uložený obraz procesoru
    -> hodnoty čelního panelu
```

Fyzický procesor patří většinu času monitoru. Během krátkého řízeného intervalu
patří uživatelovu programu. Uložený obraz ve tvaru stacku je dveřmi mezi těmito
dvěma světy.

## Co se změnilo v paměti

Po zachycené instrukci:

- uložené primární a alternativní registry obsahují výsledné hodnoty uživatele;
- uložené IX, IY, SP, I a R jsou aktualizovány;
- `varcInterruptEnableState+1` obsahuje rekonstruovanou booleovskou hodnotu
  DI/EI;
- logický PC ještě nemusí být potvrzen — potvrzení provede vyšší řadič kroku až
  po kontrole RUN;
- `accumulatedTStates` se aktualizuje teprve po úspěšném potvrzeném kroku;
- paměťové účinky provedené instrukcí už existují.

## Důležité labely, které jsme potkali

- `savedRegisterR`
- `savedRegisterI`
- `savedAlternateRegisterSet`
- `savedRegisterIY`
- `savedRegisterIX`
- `savedRegisterBC`
- `savedRegisterDE`
- `savedRegisterHL`
- `savedRegisterAF`
- `savedRegisterSP`
- `accumulatedTStates`
- `monitorAddressX`
- `monitorAddressY`
- `varcInterruptEnableState`
- `monSwapPrimaryAndAlternateRegisters`
- `restoreUserStateAndExecuteTrampoline`
- `captureUserStateAfterSequentialFlow`
- `captureUserStateAfterTakenFlow`
- `adjustSavedRefreshRegisterLow7`
- `interruptStateCaptureScratch`

## Myšlenky potřebné v dalších kapitolách

- Uživatelský procesor běžně existuje jako obraz v paměti.
- PC je představován současnou adresou monitoru, ne polem v souvislém bloku
  registrů.
- Monitor si musí zapamatovat vlastní SP dříve, než aktivuje uživatelův SP.
- Obnova je uspořádána jako operace `POP`; zachycení jako operace `PUSH`.
- DI/EI je uložen jako booleovská hodnota v operandu instrukce a emitován jako
  první bajt každého scratch programu.
- Různé vstupy zachycení mohou sdílet serializaci registrů, ale dodat rozdílné
  logické PC a časování.
