# Kapitola 46: Instrukce, které mění tok řízení

Scratch program z předchozí kapitoly funguje nádherně pro obyčejnou instrukci:

```text
DI nebo EI
zkopírovaná instrukce
JP sequential capture
JP taken capture
```

Je-li zkopírovanou instrukcí `INC A`, vykoná se a propadne do prvního
zachycovacího skoku. Logickou následující adresou je jednoduše adresa za `INC A`
v uživatelově programu.

Větvení je jiné. Může mít dvě možné následující adresy. Volání navíc mění stack.
Návrat získává svůj cíl ze stacku. Relativní skok vypočítává svůj cíl z adresy,
na níž je fyzicky vykonán — a zkopírovaná instrukce už neleží na své původní
adrese.

PROMETHEUS to řeší bez emulace veškeré aritmetiky a chování flagů Z80. Skutečnou
instrukci ponechá všude, kde je to nadále užitečné, ale přepíše její cestu scratch
programem tak, aby se každý možný výsledek vrátil jedním ze dvou zachycovacích
výstupů.

O pravdivosti podmínky stále rozhoduje skutečný Z80. PROMETHEUS pouze zařídí, kam
povedou provedená a neprovedená cesta.

## Problém s kopírováním větvení

Předpokládejme, že uživatelův program obsahuje:

```asm
$8000   DEC B
$8001   JR NZ,$7FF0
```

Displacement instrukce `JR` se měří od bajtu za původní instrukcí. Pokud se její
dva bajty zkopírují do scratch RAM například na `$9001`, ukazoval by stejný
displacement někam poblíž `$9003`, nikoli na `$7FF0`.

Zkopírovaný absolutní skok má jiný problém:

```asm
JP NZ,$8120
```

Jeho cíl zůstává `$8120`, ale pokud se skok provede, procesor unikne ze scratch
programu dříve, než PROMETHEUS zachytí výsledné registry.

Zkopírovaný návrat je ještě horší:

```asm
RET Z
```

Jestliže podmínka uspěje, Z80 sejme skutečnou adresu z uživatelova stacku a
pokračuje na ní. Zachycovací mechanismus je opět obejit.

Monitor proto potřebuje malé množství znalostí specifických pro jednotlivé
instrukce. Ne tolik, aby reprodukoval celou instrukci, ale dost na to, aby dohlédl
na její tok řízení.

## Klasifikace pouze nebezpečných instrukcí

Dekodér už vrací dvě kompaktní části identity:

- **B** obsahuje významný bajt opcode;
- horní nibble registru **C** určuje prefix nebo třídu dekodéru.

Stepping engine prohledá `controlFlowDescriptorTable`. Každý řádek obsahuje:

```text
maska opcode
očekávaný maskovaný opcode
třída dekodéru plus index handleru
```

Tabulka má čtrnáct řádků pokrývajících:

- `JR`, podmíněné `JR` a `DJNZ`;
- absolutní `JP` a `CALL`, podmíněné i nepodmíněné;
- `RET` a podmíněné `RET`;
- `RST`;
- `JP (HL)`, `JP (IX)` a `JP (IY)`;
- `RETN` a `RETI`.

Všechno ostatní nepotřebuje přepis toku řízení a proběhne obyčejným uspořádáním
scratch programu.

Hledání je společné s tabulkami přístupů do paměti popsanými v kapitole 47:

```asm
ld hl,controlFlowDescriptorTable
call matchInstructionAccessDescriptor
jr c,.executePreparedInstructionTrampoline
```

Carry znamená, že neodpovídal žádný řádek. V takovém případě zůstane zkopírovaná
instrukce beze změny.

Když řádek odpovídá, jeho spodní výsledné bity vyberou jeden z osmi handlerů.
Výběr je nepřímý:

```asm
ld hl,tracedControlFlowHandlerOffsets
call addAtoHL
ld a,(hl)
ld hl,simulateRelativeControlFlow
call addAtoHL
call dispatchDisassemblyOperandHandler
```

Tabulka offsetů je zapsána jako bajty, které lze náhodou disassemblovat jako
instrukce Z80:

```asm
tracedControlFlowHandlerOffsets:
    nop
    inc d
    ld c,d
    ld h,a
    ld a,h
    add a,c
    add a,(hl)
    sub l
```

Tyto instrukce se nikdy nevykonávají. Jejich bajty opcode jsou kompaktními offsety
k sousedním vstupům handlerů.

Je to další příklad malého datového jazyka PROMETHEA. Disassembler vidí instrukce;
stepping engine vidí osm malých celých čísel.

## Dva logické výstupy

Před jakýmkoli zvláštním přepisem engine připraví dva logické cíle:

```text
sekvenční PC = adresa za původní instrukcí
provedené PC = prozatím sekvenční PC
```

Připraví také dvě časování:

```text
sekvenční časování = základní časování z tabulky instrukcí
časování provedené cesty = prozatím základní časování
```

Handler změní pouze to, co vyžaduje jeho rodina instrukcí:

- zkopírované bajty opcode nebo operandu;
- logický cíl provedené cesty;
- časování provedené cesty;
- volitelnou opravu stacku po zachycení.

Po vykonání instrukce zachycovací vstup určí, kterého fyzického výstupu bylo
dosaženo. Fyzická scratch adresa se zahodí. Výsledkem kroku se stane odpovídající
logická adresa a časování.

## Relativní větvení: skutečný Z80 vybere výstup

Pro `JR`, `JR cc` a `DJNZ` používá PROMETHEUS zvlášť elegantní přepis.

Scratch program už obsahuje dva tříbajtové skoky:

```text
JP sequentialCapture
JP takenCapture
```

Zkopírovaný relativní displacement se změní na `+3`:

```asm
simulateRelativeControlFlow:
    ld hl,encodedRecordInfoByte
    ld e,(hl)             ; original displacement
    ld (hl),003h          ; replacement displacement
```

Jestliže se větvení neprovede, vykonávání propadne do prvního `JP`, přesně jako u
obyčejné instrukce.

Jestliže se provede, `+3` přeskočí první tříbajtový skok a dopadne na druhý:

```text
zkopírované JR cc,+3
JP sequentialCapture
JP takenCapture
```

Skutečný Z80 vyhodnotí podmínku ze skutečných uložených flagů. PROMETHEUS nemusí
vědět, zda větvení způsobila nula, carry, parita, znaménko nebo čítač B.

Původní cílová adresa se vypočítá odděleně:

```asm
ld hl,(varcSequentialNextAddress+1)
ld d,000h
bit 7,e
jr z,.finishRelativeControlFlowTarget
dec d                    ; sign-extend E into DE
.finishRelativeControlFlowTarget:
add hl,de
add a,005h               ; taken relative branch costs five more T states
ret
```

V pseudokódu:

```text
originalDisplacement = signed bajt z instrukce
logicalTakenPC = originalSequentialPC + originalDisplacement
copiedDisplacement = +3
logicalTakenTime = baseTime + 5
```

Pro náš příklad:

```text
původní instrukce na $8001
sekvenční adresa          $8003
původní displacement     $ED = -19
logický cíl               $8003 - 19 = $7FF0
```

Zkopírované větvení fyzicky nikdy neskočí na `$7FF0`. Skočí o tři bajty uvnitř
scratch programu, kde zachycení provedené cesty dodá `$7FF0` jako logické PC.

## Absolutní skoky: přesměrování operandu

Instrukce jako:

```asm
JP NZ,$8120
```

už obsahuje svůj skutečný logický cíl jako šestnáctibitový operand. PROMETHEUS
ponechá tuto hodnotu ve `varcTakenFlowNextAddress`, ale operand zkopírované
instrukce změní na adresu skoku k zachycení provedené cesty ve scratch RAM.

Koncepčně:

```text
původní:
    JP NZ,$8120

scratch:
    JP NZ,takenCaptureJump
    JP sequentialCapture
 takenCaptureJump:
    JP captureTaken
```

Je-li podmínka nepravdivá, zkopírovaná instrukce propadne k sekvenčnímu zachycení.
Je-li pravdivá, skutečný Z80 vykoná zkopírovaný podmíněný skok a dosáhne zachycení
provedené cesty.

Nepodmíněné `JP` používá pouze provedenou cestu, ale může využít stejné uspořádání.

Handler nemusí vyhodnocovat flagy. Pouze přesměruje fyzický cíl a zapamatuje si
původní logický.

## CALL: scratch návratová adresa se musí opravit

Simulovaný `CALL` lze rovněž přesměrovat k zachycení provedené cesty, ale skutečný
`CALL` Z80 má další účinek: uloží návratovou adresu na stack.

Ve scratch RAM ukazuje uložené slovo zpět do scratch programu. To je správné během
vykonávání instrukce, ale bylo by chybné ponechat je na uloženém uživatelově
stacku. Pozdější `RET` v uživatelově programu se má vrátit k instrukci za
původním CALL, nikoli do dočasného workspace PROMETHEA.

PROMETHEUS proto nechá zkopírovaný CALL uložit jeho běžné scratch návratové slovo.
Po zachycení stavu toto slovo nahradí:

```asm
replaceScratchCallReturnAddress:
    ld hl,(savedRegisterSP)
    ld de,(varcSequentialNextAddress+1)
    ld (hl),e
    inc hl
    ld (hl),d
    ret
```

Posloupnost je:

```text
1. zkopírovaný CALL se provede;
2. skutečný Z80 sníží uživatelský SP a uloží scratch návratovou adresu;
3. zachycení provedené cesty serializuje výsledný uživatelský SP;
4. callback po toku řízení přepíše horní slovo;
5. horním slovem se stane původní sekvenční PC.
```

Je užitečné rozlišovat:

- **fyzický** CALL proběhne ve scratch RAM;
- **logická** návratová adresa patří původnímu programu.

PROMETHEUS opraví pouze adresu. Samotný pohyb stacku provedl skutečný procesor.

Podmíněné CALL využívají oba výstupy. Callback opravující stack se vyvolá pouze
tehdy, když provedená cesta ohlásí nenulový flag cesty.

## NON, DEF a ALL: někdy CALL nepřesměrovávat

PROMETHEUS může volitelně dovolit, aby sledovaný `CALL` nebo `RST` vykonal svůj
skutečný cíl nativně.

Tři režimy jsou uloženy jako spustitelné bajty opcode:

```text
$00  NOP     NON — nikdy nevykonávat přímo
$C8  RET Z   DEF — vykonávat přímo jen tehdy, je-li cíl v seznamu
$C9  RET     ALL — vykonávat každý CALL/RST přímo
```

Bajt režimu leží na `directCallModeGateOpcode`.

V režimu DEF se cíl porovná s `directCallAddressList`. Procházení používá stack
pointer Z80 jako kompaktní iterátor seznamem:

```asm
ld hl,directCallAddressList
ld b,(hl)
inc hl
ld sp,hl
...
pop hl                  ; next candidate target
```

Skutečný SP monitoru se nejprve uloží do operandu na
`restoreStackAfterDirectCallScan` a před vykonáním vybraného opcode režimu se
obnoví.

Výsledek je překvapivě kompaktní:

```text
NON: NOP pokračuje do simulace
DEF: RET Z se předčasně vrátí pouze po shodě s cílem v seznamu
ALL: RET se vždy předčasně vrátí
```

Předčasný návrat ponechá zkopírovaný CALL namířený na skutečnou uživatelovu
rutinu. Ta proběhne nativně a její `RET` se vrátí do skoku k sekvenčnímu zachycení
ve scratch programu.

Je to mnohem rychlejší, ale má to důsledky:

- instrukce uvnitř rutiny nejsou jednotlivě trasovány;
- uvnitř se nekontrolují okna READ, WRITE ani RUN;
- uvnitř se netestuje BREAK;
- nepočítají se její vnitřní T states;
- poškozený stack nebo rutina bez návratu mohou monitoru uniknout.

Režim DEF umožňuje uživateli udělit tuto důvěru jen vybraným rutinám, například
službám ROM nebo známému pomocnému kódu.

## RST se stává CALL

Instrukce Z80 `RST` je jednobajtové volání jednoho z osmi pevných vektorů:

```text
$00, $08, $10, $18, $20, $28, $30 nebo $38
```

Vektor je zakódován v bitech 3–5 opcode. PROMETHEUS tyto bity vyjme a ze
zkopírovaného bajtu vytvoří obyčejný tříbajtový CALL:

```asm
ld hl,encodedRecordHeader
ld a,(hl)
and 038h
ld (hl),0cdh             ; CALL opcode
inc hl
ld (hl),a                ; low byte of vector
inc hl
ld (hl),000h             ; high byte
```

Po rozšíření může RST využít stejný mechanismus jako CALL:

- simulovanou opravu stacku v režimu NON;
- výběr přímého vykonání v režimu DEF nebo ALL;
- obyčejné sekvenční zachycení poté, co se přímo vykonaný handler vrátí.

Jedna rodina instrukcí se přeloží na jinou, protože jejich logické účinky jsou si
dostatečně blízké, aby bylo možné znovu použít existující mechanismus.

## RET: cíl přečíst, fyzickému návratu nedůvěřovat

Pro návrat je logickým cílem slovo na uloženém uživatelském SP:

```asm
ld hl,(savedRegisterSP)
ld e,(hl)
inc hl
ld d,(hl)
```

PROMETHEUS toto slovo přečte před vykonáním. Zkopírovaný `RET` nebo podmíněný
`RET` se potom převede na ekvivalentní absolutní skok mířící k zachycení provedené
cesty.

Proč nevykonat skutečný RET?

Protože skutečný RET by okamžitě skočil na uživatelův cíl mimo scratch program.
Překladem na JP uvnitř scratch RAM nechá PROMETHEUS skutečný Z80 rozhodnout o
podmínce, ale zachová si řízení.

Logickým cílem zůstává slovo přečtené z uživatelova stacku.

Provedený RET musí toto slovo rovněž spotřebovat. Protože je žádný skutečný RET
nesměl sejmout, callback po zachycení posune uložený SP:

```asm
advanceSavedStackAfterReturn:
    ld hl,(savedRegisterSP)
    inc hl
    inc hl
    ld (savedRegisterSP),hl
```

Pro podmíněný RET:

```text
neproveden:
    sekvenční zachycení
    SP beze změny

proveden:
    zachycení provedené cesty
    logické PC = slovo na starém SP
    SP = starý SP + 2
```

O tom, zda se callback spustí, opět rozhoduje flag cesty.

## Nepřímé skoky používají přímo uložené registry

Cíl `JP (HL)` není uložen v bajtech instrukce. Pochází z uloženého registru HL.
Indexované formy podobně používají IX nebo IY.

PROMETHEUS načte odpovídající uloženou dvojici:

```asm
ld hl,(savedRegisterD+1)          ; saved HL
...
ld hl,(savedRegisterIYHigh+1)     ; saved IX
...
ld hl,(savedRegisterIY)           ; saved IY
```

Bajty zkopírovaného skoku se neutralizují, aby nemohly opustit scratch RAM, a
vybraná hodnota registru se nainstaluje jako logické zachycené PC.

Na rozdíl od podmíněného větvení má `JP (HL)` jediný výsledek. Může proto znovu
použít cestu běžně nazývanou sekvenční zachycení, ale místo adresy za instrukcí z
dekodéru dodat cíl z registru.

Připomíná to, že „sekvenční“ a „provedená“ jsou názvy dvou fyzických zachycovacích
vstupů. Logickou adresu dodanou kterýmkoli z nich lze podle potřeby patchovat.

## RETN a RETI: skutečná nejistota

Tabulka toku řízení rozpoznává rozšířenou rodinu návratů tvořenou instrukcemi
`RETN` a `RETI`. Zdroj čte cíl ze stacku a připravuje stejný druh nepřímého
návratu jako u obyčejného RET.

Statická analýza však neprokazuje každý sémantický detail se stejnou jistotou:

- callback posouvající uložený SP není na všech cestách stejně explicitní;
- architektonická obnova IFF1 z IFF2 není reprezentována jako samostatná jasná
  operace.

Rekonstruovaný zdroj proto nepředstírá, že jsou tyto instrukce dokonale
pochopeny. Zachovává historické bajty a nejistotu zaznamenává.

Pro projekt vzkříšení je to správný přístup. Kde kód nějaké chování dokazuje, kniha je
vysvětlí. Kde je pouze naznačuje, kniha to přizná.

## Úplný příklad podmíněného CALL

Uvažujme:

```asm
$8100   CALL Z,$9000
```

Dekodér stanoví:

```text
sekvenční PC = $8103
provedené PC = $9000
základní časování = časování neprovedené cesty z metadat instrukce
```

V režimu NON se scratch program koncepčně změní na:

```text
DI/EI
CALL Z,takenCaptureJump
JP sequentialCapture
 takenCaptureJump:
JP takenCapture
```

Není-li Z nastaven:

```text
podmínka CALL neuspěje
nedojde k zápisu na stack
sekvenční zachycení ohlásí PC=$8103
SP je beze změny
```

Je-li Z nastaven:

```text
podmínka CALL uspěje
skutečný Z80 uloží scratch návratové slovo
zachycení provedené cesty ohlásí PC=$9000
callback nahradí scratch slovo hodnotou $8103
uložený SP zůstane snížený o dvě
```

Aritmetika, flagy, snížení stacku i rozhodnutí podmínky pocházejí ze skutečného
Z80. PROMETHEUS dodal bezpečné fyzické cíle a opravil jediné slovo specifické pro
scratch prostor.

## Zpět k celému stroji

Engine toku řízení není druhým interpretem Z80. Je to soubor malých adaptérů kolem
skutečného procesoru:

```text
dekóduj instrukci
    -> obyčejná instrukce? zkopíruj beze změny
    -> relativní větvení? nasměruj provedenou cestu na druhé zachycení
    -> JP/CALL? přesměruj fyzický cíl
    -> RET? získej logický cíl z uživatelova stacku
    -> RST? rozšiř na CALL
    -> nepřímé JP? získej cíl z uloženého registru

obnov skutečný uživatelský stav
vykonej skutečnou instrukci
zachyť vybraný výstup
v případě potřeby oprav logický stack
potvrď logické PC
```

Proto implementace podporuje všechny podmínky Z80 bez velkého vyhodnocovače
podmínek. Konečným soudcem zůstává skutečný registr flagů.

Dalším problémem už není, kam instrukce směřuje, ale kterých paměťových míst se
cestou dotkne.

## Co se změnilo v paměti

Během přípravy toku řízení může PROMETHEUS upravit scratch kopii takto:

- změnit relativní displacement na `+3`;
- nahradit absolutní cíl adresou scratch zachycení;
- přeložit RET na formu podobnou JP;
- rozšířit RST na tříbajtový CALL;
- vynulovat bajty nepřímého skoku;
- připojit druhou dvojici zachycovacích skoků tam, kde ji vyžaduje přepsané
  uspořádání.

Patchuje také samomodifikovaný stav uchovávající:

- logické PC provedené cesty;
- časování provedené cesty;
- callback stacku po provedené cestě;
- režim přímého CALL;
- SP monitoru používaný při procházení seznamu cílů přímých volání.

Po provedeném simulovaném CALL nebo RET může být opraven uložený uživatelský
stack.

## Důležité labely, s nimiž jsme se setkali

- `controlFlowDescriptorTable`
- `matchInstructionAccessDescriptor`
- `tracedControlFlowHandlerOffsets`
- `simulateRelativeControlFlow`
- `directCallAddressList`
- `directCallModeGateOpcode`
- `restoreStackAfterDirectCallScan`
- `replaceScratchCallReturnAddress`
- `advanceSavedStackAfterReturn`
- `noPostFlowStackAdjustment`
- `varcSequentialNextAddress`
- `varcTakenFlowNextAddress`
- `varcPostTakenControlFlowCallback`
- `varcTakenFlowTStates`

## Myšlenky potřebné v dalších kapitolách

- Deskriptory toku řízení klasifikují pouze instrukce, které mohou uniknout ze
  scratch RAM nebo změnit logický stack.
- Každou podmínku stále vyhodnocuje skutečný Z80.
- Sekvenční zachycení a zachycení provedené cesty jsou fyzické výstupy nesoucí
  logická PC.
- Relativní větvení používají náhradní displacement `+3`.
- Simulované CALL a RET vyžadují po zachycení opravu stacku.
- Režimy přímého CALL/RST záměrně vyměňují ochranu a přesnost časování za rychlost.
- Některé podrobnosti RETN/RETI zůstávají v historické implementaci nejisté.
