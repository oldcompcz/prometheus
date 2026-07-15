# Kapitola 45: Sestavení scratch instrukce

Monitor nemůže bezpečně vykonat každou instrukci přesně tam, kde ji našel.

Obyčejnou instrukci jako `INC A` by teoreticky mohl zavolat pomocí malého
uspořádání a nechat ji proběhnout na původním místě. Mnohé instrukce by však
potom pokračovaly další uživatelovou instrukcí dříve, než by PROMETHEUS mohl
získat řízení zpět. Větvení může skočit jinam. Volání a návraty používají
uživatelův stack. Instrukce může ležet v ROM, kam za ni nelze zapsat dočasnou
past. A i v RAM by patchování bajtů za každou instrukcí narušovalo sledovaný
program.

PROMETHEUS proto ve vlastním scratch prostoru sestaví drobný dočasný program.
Zkopíruje do něj uživatelovu instrukci, připojí zachycovací výstupy, obnoví obraz
uživatelského procesoru a scratch program vykoná.

Tato kapitola vysvětluje tento miniaturní generátor kódu.

## Laboratorní stůl pro jedinou instrukci

Scratch program začíná na `encodedRecordStorageLength`.

Tento název pochází z editoru a assembleru. Stejná oblast paměti se normálně
používá k sestavení dočasného komprimovaného záznamu zdroje:

```asm
encodedRecordStorageLength:
    defb 0
encodedRecordHeader:
    defb 0
encodedRecordInfoByte:
    defb 0
encodedRecordPayload:
    defw 0
encodedRecordPayloadAfterLabel:
    defw 0
encodedRecordPayloadWorkspace:
    defs 28
```

Během vykonávání instrukce se však žádný záznam zdroje nesestavuje. Workspace se
vypůjčí jako spustitelná RAM.

To je pro PROMETHEA příznačné. Paměť není trvale rozdělena na velké množství
jednoúčelových objektů. Oblast dostane roli pro právě probíhající operaci a
rutiny se shodnou na tom, kdy je tato role bezpečná.

Scratch oblast je dostatečně velká pro:

- jeden opcode DI nebo EI;
- zkopírovanou nebo přepsanou uživatelovu instrukci;
- dva absolutní zachycovací skoky;
- dočasné operandy toku řízení a pomocný stav.

Parser zdroje, disassembler a stepping engine se při používání stejných bajtů
střídají.

## Proč instrukci kopírovat?

Uvažujme krokování této sekvence:

```asm
$8000   INC A
$8001   LD ($9000),A
```

Kdyby PROMETHEUS jednoduše skočil na `$8000`, Z80 by vykonal `INC A` a hned
potom načetl `LD ($9000),A`. Neexistuje žádné automatické zastavení po jediné
instrukci.

Monitor by mohl adresu `$8001` dočasně přepsat breakpointem, ale to má několik
nevýhod:

- následující bajty mohou ležet v ROM;
- následující adresa může být chráněná nebo sdílená;
- větvení nemusí dočasného breakpointu vůbec dosáhnout;
- instalace a obnova patche při každém kroku je rušivá;
- další instrukce může začínat méně než tři bajty před důležitými daty;
- podmíněný tok potřebuje více než jednu možnou adresu zastavení.

Zkopírování instrukce do scratch RAM řeší obyčejný případ propadnutí:

```text
scratch:
    zkopírované INC A
    JP do zachycení
```

Po `INC A` Z80 přirozeně dojde k připojenému skoku místo k další uživatelově
instrukci.

Pro normální instrukci bez větvení je to téměř celý trik.

## Každý scratch program začíná DI nebo EI

`beginExecutionTrampoline` zapíše první bajt:

```asm
beginExecutionTrampoline:
    ld hl,encodedRecordStorageLength
    ld a,(varcInterruptEnableState+1)
    add a,a
    add a,a
    add a,a
    add a,0f3h
    ld (hl),a
    inc hl
    ret
```

Vyslaný bajt je:

```text
$F3  DI, když je uložený stav 0
$FB  EI, když je uložený stav 1
```

Scratch program tedy obnoví logický stav přerušení uživatele bezprostředně před
zkopírovanou instrukcí.

Tato volba si zaslouží pozornost. Samotná
`restoreUserStateAndExecuteTrampoline` musí při obnovování registrů vykonat
mechanismus monitoru. Nemůže jednoduše ponechat současný stav přerušení monitoru
a tvrdit, že představuje uživatele. Scratch program uplatní uloženou volbu v
posledním prakticky možném okamžiku.

Například:

```text
scratch adresa S

S+0   FB             EI
S+1   3C             INC A
S+2   C3 lo hi       JP sequentialCapture
S+5   C3 lo hi       JP takenCapture
```

Pravidlo zpoždění `EI` na Z80 znamená, že přerušení začnou být účinná až po
následující instrukci. Tento detail patří ke skutečnému chování hardwaru, které
trampoline přirozeně zdědí.

## Zjištění délky instrukce

Disassembler už instrukci dekódoval před sestavením trampoline. Vrací:

- DE = původní adresa instrukce;
- HL = sekvenční adresa za instrukcí;
- BC = dekódovaná metadata opcode/prefixu;
- časovací údaje a informace o operandu v samomodifikovaném stavu.

Délka tedy je:

```text
instructionLength = sequentialAddress - originalAddress
```

Zdroj ji vypočítá přímo:

```asm
buildInstructionExecutionTrampoline:
    ld hl,(varcSequentialNextAddress+1)
    and a
    sbc hl,de
    ld b,h
    ld c,l
```

V tomto bodě není potřeba samostatná tabulka délek instrukcí. Dekodér už prošel
bajty a vytvořil následující adresu.

Toto opětovné použití je jedním z důvodů, proč je disassembler monitoru pro
vykonávání ústřední. Není pouze tiskárnou textu. Je autoritou pro strukturu
instrukce, kterou používá stepper.

## Kopírování přesné sekvence bajtů

Po vložení délky do BC rutina zahájí scratch program a instrukci zkopíruje:

```asm
call beginExecutionTrampoline
ex de,hl
ldir
ex de,hl
```

Přehazování registrů lze číst takto:

```text
před EX:
    DE = původní adresa instrukce
    HL = scratch cursor za DI/EI
    BC = délka instrukce

po EX:
    HL = původní adresa instrukce
    DE = scratch cíl

LDIR zkopíruje BC bajtů

druhé EX:
    HL = scratch cursor za zkopírovanou instrukcí
```

Pro `LD BC,$1234` vznikne tato scratch sekvence:

```text
F3 nebo FB
01 34 12
```

Kopírují se i prefixové bajty. Indexovaná instrukce jako:

```asm
LD A,(IX+5)
```

si zachová úplnou sekvenci bajtů:

```text
DD 7E 05
```

Zkopírovaná instrukce vidí obnovenou hodnotu IX, takže se jejím přesunutím
nezmění efektivní adresa.

## Připojení dvou výstupů

Po zkopírování zapíše `appendSequentialAndTakenCaptureJumps` dva absolutní
skoky:

```asm
appendSequentialAndTakenCaptureJumps:
    ld de,captureUserStateAfterSequentialFlow
    call writeJumpAtHL
    ld de,captureUserStateAfterTakenFlow
writeJumpAtHL:
    ld (hl),0c3h
writeDEWordAtHLAndAdvance:
    inc hl
    ld (hl),e
    inc hl
    ld (hl),d
    inc hl
    ret
```

Výsledné obecné rozložení je:

```text
+0                 DI nebo EI
+1                 bajty zkopírované/přepsané instrukce
+1+délka            JP do sekvenčního zachycení
+4+délka            JP do zachycení provedeného toku
```

Proč připojovat dva skoky, když instrukce jako `INC A` může pouze propadnout?

Protože stejné rozložení musí podporovat také podmíněný tok řízení.

Přepsané `JR Z,target` lze uspořádat takto:

- podmínka nesplněna: dojde k prvnímu JP;
- podmínka splněna: přeskočí první JP a dojde ke druhému.

Přepsaný podmíněný CALL, JP nebo RET může použít stejnou dvojici. Pevné rozložení
se dvěma výstupy zmenšuje pozdější handlery.

U obyčejných instrukcí je druhý skok jednoduše nedosažitelný.

## Krok bez změny toku řízení

Projděme `INC A` z adresy `$8000`.

Předpokládejme:

```text
současná adresa       = $8000
paměť[$8000]          = $3C
uložené A              = $05
uložená přerušení      = DI
```

Dekodér vrátí:

```text
původní DE             = $8000
sekvenční HL            = $8001
délka                   = 1
základní časování       = 4 T states
```

Scratch program bude:

```text
F3                         DI
3C                         INC A
C3 <sekvenční zachycení>   JP captureUserStateAfterSequentialFlow
C3 <zachycení toku>        JP captureUserStateAfterTakenFlow
```

Controller kroku nenajde pro `INC A` žádný deskriptor toku řízení, takže nic
nepřepisuje.

Obnova načte A=`$05` a skočí do scratch prostoru. Z80 vykoná:

```text
DI
INC A       ; A se změní na $06, flags se změní běžným způsobem
JP do zachycení
```

Zachycení uloží A=`$06` a nový bajt F. Vyšší controller později potvrdí
PC=`$8001` a přičte čtyři k `accumulatedTStates`.

Skutečná instrukce byla vykonána na skutečném Z80 s uživatelovými registry.
Změnilo se pouze její umístění a pokračování.

## Proč absolutní operandy paměti stále fungují

Přesunutí instrukce může změnit její význam, závisí-li instrukce na vlastní
adrese. Většina instrukcí Z80 na ní nezávisí.

Absolutní paměťová instrukce jako:

```asm
LD A,($9000)
```

obsahuje `$9000` přímo. Zkopírování bajtů ponechá operand beze změny, takže stále
čte `$9000`.

Smysl si zachovají i instrukce s nepřímým adresováním přes registry:

```asm
LD A,(HL)
LD (IX+5),B
PUSH DE
```

Používají obnovené uživatelovy registry a jeho stack.

Obtížné jsou kategorie, jejichž účinek závisí na původním PC nebo návratových
adresách:

- JR a DJNZ;
- podmíněné a nepodmíněné JP;
- CALL a RST;
- RET, RETI a RETN;
- JP (HL), JP (IX), JP (IY).

Tyto instrukce nelze jednoduše zkopírovat a důvěřovat jim. Kapitola 46 vysvětlí,
jak je PROMETHEUS přepisuje a přitom zachovává jejich logický cíl.

## Scratch oblast je kódem jen na okamžik

Před vykonáním je `encodedRecordStorageLength` daty. Jakmile do něj builder
zapíše, stejná adresa se stane spustitelným strojovým kódem.

Po zachycení se bajty obřadně nemažou. Následující parser, disassembler nebo krok
je podle potřeby přepíše.

Je to bezpečné, protože operace probíhají sekvenčně:

```text
sestav scratch program
obnov stav a vykonej jej
zachyť stav a vrať se
scratch oblast už není aktivní
znovu ji použij pro jinou úlohu
```

Žádné vlákno na pozadí nemůže začít parsovat zdrojový řádek, zatímco je Z80
uvnitř trampoline. Spectrum i PROMETHEUS zde pracují jednoúlohově.

Návrh šetří paměť za cenu přísnějších časových pravidel: každý subsystém musí
vědět, kdy mu sdílený workspace patří.

## Vstup do scratch prostoru bez CALL

Na konci obnovy používá PROMETHEUS:

```asm
ld sp,(savedRegisterSP)
jp encodedRecordStorageLength
```

Scratch program nevolá.

`CALL` by uložil návratovou adresu monitoru na uživatelův stack a znečistil
zkoumaný stav. Naznačoval by také, že se scratch program může normálně vrátit,
což není způsob, jakým je navržen.

Jedinými platnými výstupy jsou explicitní skoky do zachycovacího kódu.

Při čtení vykonávacího enginu je užitečné toto pravidlo:

> Jakmile je aktivní uživatelův SP, vedou cesty řízení přes skoky, nikoli přes
> běžná volání a návraty monitoru.

Vlastní návratový řetězec monitoru spí, dokud zachycení neobnoví
`varcRestoreMonitorStackAfterExecution`.

## SP monitoru je uložen v kódu

Před změnou SP patchuje obnova tuto instrukci:

```asm
varcRestoreMonitorStackAfterExecution:
    ld sp,00000h
```

Současný SP monitoru se stane budoucím bezprostředním operandem.

Během zachycení, po serializaci všech uživatelských registrů, dospěje vykonávání
k tomuto patchovanému `LD SP,nn`. Stack monitoru se znovu objeví přesně tam, kde
byl před experimentem.

Jde o samomodifikovaný kód použitý jako záznam pokračování:

```text
před vykonáním uživatelské instrukce:
    zapamatuj SP monitoru v operandu budoucího LD SP

po vykonání uživatelské instrukce:
    vykonej patchované LD SP a znovu aktivuj řetězec volání monitoru
```

Stejné slovo mohla uchovávat samostatná proměnná v paměti, ale patchovaná
instrukce jej přímo obnoví.

## Nativní trampoline CALL/JP jsou menší variantou

Společný nativní builder z kapitoly 44 také začíná
`beginExecutionTrampoline`, ale místo kopírování dekódovaných bajtů zapíše
tříbajtovou instrukci přenosu řízení:

```text
DI/EI
CALL target   nebo   JP target
JP do sekvenčního zachycení
JP do zachycení provedeného toku
```

Je to stejný laboratorní stůl, jen je na něj položen jiný experiment.

Pro CALL:

```text
CALL se vrátí k prvnímu připojenému JP
```

Pro breakpointový JP:

```text
JP natrvalo opustí scratch prostor
patchovaný breakpoint později skočí přímo do zachycení
```

Společný začátek a zachycovací výstupy dovolují nativním i trasovaným operacím
znovu použít úplný mechanismus obnovy registrů a jejich serializace.

## Větvení potřebuje dva významy slova „další“

Scratch rozložení zavádí důležité rozlišení, které bude určovat příští kapitolu.

Pro každou dekódovanou instrukci zaznamená PROMETHEUS alespoň jednu další
adresu:

```text
sekvenční další = původní adresa + délka instrukce
```

U instrukcí toku řízení může existovat také:

```text
provedená další = cíl větvení/volání/návratu
```

Dva připojené skoky odpovídají těmto logickým výsledkům, nikoli fyzickým adresám
ve scratch prostoru.

Zachycovací vstupy předají controlleru příslušnou adresu:

```asm
varcSequentialNextAddress:
    ld hl,00000h
```

a:

```asm
varcTakenFlowNextAddress:
    ld hl,00000h
```

Skutečné scratch PC během zachycení zmizí. Monitor potvrdí jednu z logických
adres původního programu.

To je jádrem simulace: vykonat dost skutečného strojového kódu, aby vznikly
správné registry a flags, ale fyzické pokračování scratch programu nahradit
pokračováním, které by měl původní program.

## Validace instrukce probíhá před vykonáním

Scratch program se sestaví teprve poté, co byla instrukce dekódována a prošla
předběžnou validací.

Controller kroku obecně dělá toto:

```text
dekóduj instrukci
zapamatuj sekvenční adresu a operand
ověř HALT a účinky na paměť
sestav scratch program
if je to nutné, přepiš tok řízení
obnov uživatelský stav
vykonej
```

Podrobnosti validace patří do kapitoly 47, ale už nyní je důležité její místo.
Zakázané čtení nebo zápis se odhalí dříve, než smí zkopírovaná instrukce
proběhnout.

Později popsanou důležitou výjimkou je ochrana RUN, která se kontroluje až na
výsledném PC po vykonání. Komentáře zdroje uvádějí, že je to slabší než formulace
dochované příručky.

Prozatím si builder scratch programu představujme tak, že pracuje s instrukcí,
u níž už controller povolil pokus o vykonání.

## Instrukce měnící stack

Zkopírovaný `PUSH`, `POP`, `EX (SP),HL` nebo podobná instrukce běží se skutečným
uloženým uživatelovým SP. To je pro věrnost nezbytné.

Zachycovací kód okamžitě zaznamená výsledný SP, než si scratch paměť vypůjčí jako
dočasný stack. Proto:

- PUSH zanechá uložený SP o dva bajty nižší;
- POP jej zanechá o dva bajty vyšší;
- data zapsaná nebo přečtená instrukcí normálně ovlivní uživatelskou paměť.

Umístění opcode ve scratch prostoru do těchto účinků nezasahuje.

CALL a RET potřebují zvláštní práci nikoli proto, že se dotýkají stacku, ale
protože by jejich návratová adresa nebo cíl odkazovaly do scratch RAM místo do
původního programu. Jejich handlery tento logický nesoulad opravují.

## Co se stane s flags

Zkopírovaná instrukce se vykoná s uloženým bajtem F obnoveným přes `POP AF`.
Jakékoli flags vytvořené skutečným Z80 se potom zachytí spolu s AF.

PROMETHEUS flags obyčejných instrukcí znovu nepočítá softwarově. Vyžadovalo by to
velký a chybami ohrožený emulátor CPU. Trampoline nechá skutečný procesor, aby se
postaral o obtížné detaily:

- half carry;
- overflow;
- nedokumentované flagové bity;
- parity;
- vzájemné účinky carry a zero.

To je jedna z nejsilnějších výhod tohoto návrhu.

Monitor simuluje **tok řízení kolem** instrukce, nikoli aritmetiku uvnitř ní.

## Miniaturní hybridní emulátor

PROMETHEUS ani jednoduše nevykonává instrukce na jejich původním místě, ani plně
neemuluje Z80 softwarově.

Používá hybridní metodu:

```text
skutečný Z80 vykonává:
    aritmetiku
    logiku
    přenosy mezi registry
    paměťové operace
    tvorbu flags

mechanismus monitoru simuluje nebo dohlíží na:
    kam je instrukce umístěna
    jak se vrátí řízení
    logické další PC
    význam stacku pro CALL/RET
    ochranné kontroly
    účtování času
```

Toto rozdělení se pro malý stroj dobře hodí. Úplný softwarový interpret Z80 by
spotřeboval mnohem více kódu. Slepé nativní vykonávání by bylo příliš těžké
ovládat. Scratch trampoline používá samotný procesor jako engine instrukcí,
zatímco PROMETHEUS spravuje nebezpečné okraje.

## Obecné recepty scratch programu

Do konce této kapitoly jsme poznali tři rozložení.

### Obyčejná instrukce

```text
DI/EI
zkopírovaná instrukce
JP do sekvenčního zachycení
JP do zachycení provedeného toku   ; normálně nedosažitelné
```

### Nativní volání podprogramu

```text
DI/EI
CALL target
JP do sekvenčního zachycení   ; dosaženo po RET z target
JP do zachycení provedeného toku
```

### Nativní běh k breakpointu

```text
DI/EI
JP runStart             ; sem se nevrací
JP do sekvenčního zachycení
JP do zachycení provedeného toku

... jinde ...
breakpoint:
JP breakpointHitCaptureEntry
```

Kapitola 46 přidá recepty pro přepsaný tok řízení, v nichž je zkopírovaná
instrukce změněna tak, aby každý výsledek zvolil jeden ze dvou zachycovacích
skoků.

## Zpět k celému stroji

Scratch workspace propojuje téměř každou dosud rozvinutou myšlenku:

- disassembler určuje délku instrukce a operandy;
- samomodifikovaný stav ukládá sekvenční adresu, časování a politiku;
- uložený obraz procesoru dodává registry a stack;
- sdílený workspace se stává generovaným kódem;
- dva zachycovací výstupy serializují výsledek;
- čelní panel později zobrazí nový stav.

Pro obyčejnou instrukci je teď úplný tok srozumitelný:

```text
současná adresa
    -> dekóduj bajty
    -> zkopíruj je do scratch prostoru
    -> připoj zachycovací skoky
    -> obnov uložený procesor
    -> vykonej skutečnou instrukci Z80
    -> zachyť procesor
    -> potvrď logickou další adresu
    -> překresli panel
```

Zbývající obtíž spočívá ve spojení „logická další adresa“. Obyčejná instrukce má
jen jednu. Větvení může mít dvě, CALL mění stack, RET získává cíl z paměti a
nepřímý JP jej získává z uloženého registru.

To je tématem příští kapitoly.

## Co se změnilo v paměti

Sestavení scratch instrukce přepíše dočasný workspace zakódovaného záznamu:

- jedním opcode DI/EI;
- zkopírovanými nebo vygenerovanými bajty instrukce;
- JP do sekvenčního zachycení;
- JP do zachycení provedeného toku.

Spoléhá také na samomodifikované operandy uchovávající:

- sekvenční další adresu;
- adresu provedeného toku;
- dekódovaný operand;
- základní a provedené časování;
- callback pro stack po toku řízení;
- adresu obnovení stacku monitoru.

Workspace je dočasný a po zachycení se znovu použije.

## Důležité navštívené labely

- `encodedRecordStorageLength`
- `encodedRecordHeader`
- `encodedRecordInfoByte`
- `encodedRecordPayloadWorkspace`
- `beginExecutionTrampoline`
- `buildInstructionExecutionTrampoline`
- `appendSequentialAndTakenCaptureJumps`
- `writeJumpAtHL`
- `varcSequentialNextAddress`
- `varcTakenFlowNextAddress`
- `varcRestoreMonitorStackAfterExecution`
- `restoreUserStateAndExecuteTrampoline`
- `captureUserStateAfterSequentialFlow`
- `captureUserStateAfterTakenFlow`

## Myšlenky potřebné v dalších kapitolách

- Původní instrukce se normálně kopíruje do sdílené scratch RAM.
- Bezprostředně před ní se vyšle DI nebo EI.
- Dva připojené zachycovací skoky představují sekvenční a provedený logický
  výsledek.
- Fyzické scratch PC se nikdy nepotvrdí jako uživatelovo PC.
- Skutečný Z80 dodává chování registrů, paměti a flags; PROMETHEUS dohlíží na tok
  řízení a bezpečnost.
- PC-relative instrukce a instrukce používající návrat ze stacku se musí
  přepsat, protože zkopírování mění význam jejich fyzického umístění.
