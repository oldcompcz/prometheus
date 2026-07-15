# Kapitola 35: Navigace po adresách a vstup monitoru

Editor má aktivní řádek zdroje. Monitor má **současnou adresu**.

Tato adresa je středem světa monitoru. Začíná na ní malé okno disassembly
výpisu. Mohou na ní začínat výpisy paměti. SPACE a E na ní sestavují strojový
kód. Krokování vykoná instrukci na této adrese. Většina tabulkově dispatchovaných
příkazů monitoru ji před zahájením dostane v HL.

Adresa je proto více než číslo zobrazené na obrazovce. Je polohou monitoru v
prostoru strojového kódu.

Tato kapitola vysvětluje, jak PROMETHEUS tuto polohu přesouvá, jak se uživatele
ptá na adresy a jiné expressiony, jak po chybách vstupu bezpečně opakuje pokus a
jak tentýž mechanismus upravuje uložené hodnoty registrů.

## Současná adresa je uložena uvnitř instrukce

Trvalá hodnota se nachází zde:

```asm
varcMonitorCurrentAddress:
    ld de,00000h
```

Dva bajty operandu této instrukce `LD DE,nn` jsou současnou adresou monitoru.
Kód, který si potřebuje zapamatovat novou adresu, zapisuje do
`varcMonitorCurrentAddress+1`.

Když je vybrán tabulkově dispatchovaný příkaz, `startMonitor` před návratem do
handleru znovu načte slovo do HL:

```asm
    ld hl,(varcMonitorCurrentAddress+1)
    ret
```

Rodina kompaktních handlerů tím získává společný kontrakt:

```text
vstup:  HL = současná adresa monitoru
výstup: obyčejný RET překreslí monitor
```

Handler, který chce současnou adresu změnit, nakonec dospěje sem:

```asm
setMonitorCurrentAddressAndRet:
    ld (varcMonitorCurrentAddress+1),hl
    ret
```

Následující teplý vstup monitoru překreslí disassembly okno i všechny položky
panelu závislé na adrese podle nové hodnoty.

## Pohyb o jeden bajt

Dva příkazy provádějí nejjednodušší možný pohyb:

```text
kurzor nahoru → předchozí bajt
ENTER         → následující bajt
```

Odpovídající kód je záměrně sdílený:

```asm
monOneByteBack:
    dec hl
    dec hl

monOneByteForward:
    inc hl
setMonitorCurrentAddressAndRet:
    ld (varcMonitorCurrentAddress+1),hl
    ret
```

Vstup přes `monOneByteBack` provede dvě dekrementace a potom propadne do jedné
inkrementace, takže výsledným pohybem je minus jedna. Vstup přes
`monOneByteForward` provede pouze závěrečnou inkrementaci.

Při čtení po jednotlivých řádcích to vypadá podivně. Jako tři vstupní body je to
kompaktní:

```text
BACK:     HL = HL - 1
FORWARD:  HL = HL + 1
STORE:    currentAddress = HL
```

Šestnáctibitová aritmetika se přirozeně přetáčí. Pohyb vpřed z `$FFFF` dospěje
na `$0000`; pohyb vzad z `$0000` dospěje na `$FFFF`.

## Pohyb o jednu instrukci

Kurzor dolů postupuje o dekódovanou délku instrukce na současné adrese:

```asm
monOneInstructionForward:
    call decodeInstructionAtHL
    jr setMonitorCurrentAddressAndRet
```

`decodeInstructionAtHL` vrací HL na bajtu následujícím za dekódovanou položkou.
Tou může být jednobajtová instrukce, několikabajtová prefixovaná instrukce nebo
vynucená položka `DEFB`/`DEFW` v nakonfigurované datové oblasti.

Příkaz pohybu proto sdílí stejnou interpretaci jako viditelný disassembly výpis.
Monitor neudržuje druhý dekodér délky instrukcí.

Jde o důležitý invariant:

```text
co disassembler označí za jednu položku
    =
co kurzor dolů přeskočí jako jednu položku
```

Kapitola 39 vysvětlí, jak dekodér k tomuto výsledku dospěje.

## Přímé nastavení adresy

Příkaz M se zeptá na adresu paměti. Jeho handler je kompaktní, protože propadne
stejnými vstupy pro pohyb:

```asm
monSetCurrentAddress:
    call promptForMonitorValue
    defb 0c4h
    inc hl

monOneByteBack:
    dec hl
    dec hl

monOneByteForward:
    inc hl
```

Po návratu hodnoty z promptu v HL je výsledná aritmetika:

```text
+1 -1 -1 +1 = 0
```

Hodnota se tedy uloží beze změny.

Inline bajt `$C4` není instrukcí vykonanou po volání. Je textovým tokenem monitoru
pro prompt. `promptForMonitorValue` odstraní návratovou adresu ze zásobníku,
spotřebuje bajt tokenu a uloží zpět opravenou návratovou adresu ukazující za něj.

Zdroj proto lze číst téměř jako tento smyšlený zápis:

```text
address = prompt("Memory")
```

aniž by bylo nutné uchovávat samostatný pointer na text promptu.

## Desetiúrovňová cesta navigace

Příkazy kurzor vlevo a kurzor vpravo dělají více než jen odečítání nebo sčítání.
Poskytují malou historii navigace.

`monitorNavigationAddressStack` obsahuje:

```text
bajt 0      hloubka, 0..10
bajty 1..   deset little-endian uložených adres
```

Tento zásobník nijak nesouvisí:

- se skutečným SP procesoru Z80;
- s uloženým uživatelským SP;
- s trasovanými instrukcemi CALL a RET.

Patří pouze prohlížeči adres monitoru.

### Sestup na podřízenou adresu

Kurzor vpravo se zeptá na novou adresu. Je-li uloženo méně než deset úrovní:

1. zvětší hloubku;
2. uloží starou současnou adresu do nového slotu;
3. nastaví zadanou adresu jako současnou.

Pojmově:

```text
if depth < 10:
    navigation[depth] = currentAddress
    depth += 1
    currentAddress = prompt("Memory")
```

To se hodí při sledování pointerů nebo volání. Čtenář může opustit jednu adresu,
prozkoumat související adresu a později se vrátit.

### Návrat o úroveň výše

Kurzor vlevo v hloubce nula neudělá nic. Jinak hloubku zmenší, získá odpovídající
uloženou adresu a nastaví ji jako současnou.

```text
if depth > 0:
    depth -= 1
    currentAddress = navigation[depth]
```

PROMETHEUS těmto operacím říká „o úroveň dolů“ a „o úroveň nahoru“, jako by se
uživatel pohyboval stromem souvisejících adres, nikoli chronologickou historií
prohlížeče.

Zásobník není automaticky svázán s disassemblovanými instrukcemi CALL. Uživatel
sám rozhoduje, kdy je adresa podřízeným místem, které stojí za zapamatování.

## Monitor si půjčuje vstupní řádek editoru

PROMETHEUS už má schopný editor řádku:

- buffer chráněný strážními bajty;
- pohyblivý marker kurzoru `$01`;
- vkládání a mazání;
- expanzi tokenů;
- normalizovaný vstup z klávesnice;
- vyhodnocování expressionů;
- chybová hlášení.

Monitor jej používá znovu, místo aby vytvářel druhý.

`monitorInputBuffersInitialization` obnoví tento tvar:

```text
$80 guard | $01 cursor | nulami vyplněný zbytek
```

`renderMonitorInputLine` dočasně vybere tabulku tokenů monitoru a zavolá běžný
renderer vstupního řádku na bitmapovém řádku popsaném položkou
`frontPanelEditLineItem`.

`monitorInputLoop` potom sleduje známý cyklus:

```text
vykresli řádek
přečti a normalizuj jednu klávesu
uprav sdílený buffer
repeat until ENTER
```

EDIT požadavek opustí a skočí přímo do `startMonitor`.

## Text promptu je chráněn před DELETE

Prompt monitoru je uložen jako token s horním bitem následovaný markerem kurzoru.
Například:

```text
$C2 $01 ...   → "First" následované editovatelným kurzorem
```

Než `monitorInputLoop` dovolí DELETE, podívá se na bajt bezprostředně před
kurzorem. Je-li nastaven bit 7, jde o token promptu a smazání se ignoruje.

Uživatel může upravovat odpověď, ale nemůže mazat zpět do pevné části promptu.

Je to velmi malá forma ochrany pole implementovaná výhradně pomocí reprezentace
tokenu vloženého přímo v datech.

## Jedna rutina, mnoho slov promptu

Místo volání vypadá takto:

```asm
    call promptForMonitorValue
    defb 0c2h
```

Rutina:

1. sejme ze zásobníku návratovou adresu volání;
2. přečte bajt na této adrese jako token promptu;
3. adresu inkrementuje;
4. uloží opravené pokračování zpět na zásobník;
5. inicializuje vstupní buffer obsahem `[token,$01]`.

PROMETHEUS používá tokeny jako:

```text
First
Last
Memory
Length
Call
```

aniž by předával obyčejný argument v registru nebo pro každé místo volání
vyhrazoval dvoubajtový pointer.

Jde o techniku inline řetězců z kapitoly 6 zmenšenou na jednobajtový kompaktní
slovník.

## Odpovědí je celý expression

Po ENTER běžná dokončovací cesta promptu skočí do `evaluateInputExpression`.

Odpověď proto může být více než doslovná adresa. Může používat stejný zleva
doprava vyhodnocovaný jazyk expressionů jako zdroj assembleru:

```text
#8000
32768+5
TABLESTART+2
$+16
%1000000000000000
```

Znak `$` zde má běžný význam expressionu určený příslušným stavem assembleru
nebo monitoru. Lze používat definované symboly, takže práce v monitoru zůstává
propojena se jmény ve zdroji.

Řádek promptu se tak chová spíše jako nepatrný příkazový jazyk než jako numerická
klávesnice.

## Výjimka pro dvojtečku

Kazetové příkazy mohou přijímat jméno souboru začínající dvojtečkou. Po zadání
`promptForMonitorValue` zkontroluje první editovatelný znak:

```asm
    cp 03ah
    ret z
```

Je-li to `:`, rutina se vrátí, aniž by se pokusila zbytek vyhodnotit jako
expression. Volající může zbývající znaky interpretovat jako text jména souboru.

Tentýž editor promptu tedy podporuje dva typy výsledku:

```text
obyčejný vstup    → vyhodnoť a vrať 16bitovou hodnotu
vstup s dvojtečkou → vrať textovou podobu kazetovému příkazu
```

Výjimka je explicitní a malá; společný editační mechanismus zůstává sdílený.

## Bezpečné opakování po chybě parseru

Parser expressionu může odejít přes sdílenou cestu `signalError`, místo aby se
normálně vrátil. Kdyby jej monitor jednoduše zavolal, odvíjení zásobníku parserem
by mohlo zahodit několik návratových adres monitoru a bezpečné opakování by
nebylo možné.

PROMETHEUS problém řeší tím, že si pointer zásobníku promptu zapamatuje uvnitř
instrukce:

```asm
monitorInputRestart:
    ld sp,00000h
```

Při přípravě promptu se současné SP zapíše do tohoto operandu. Sdílený hook
`errorAction` se přesměruje na `retryMonitorInputAfterError`.

Při chybě tento handler:

1. vypíše běžné hlášení PROMETHEA na editačním řádku monitoru;
2. krátce počká, aby šlo zprávu přečíst;
3. skočí do `monitorInputRestart`;
4. obnoví přesný zásobník promptu;
5. vymaže dočasné řetězce parseru;
6. znovu otevře tentýž řádek k opravě.

V pseudokódu:

```text
savedPromptSP = SP

retry:
    SP = savedPromptSP
    uprav odpověď
    try vyhodnotit

on error:
    zobraz zprávu
    goto retry
```

Není to obsluha výjimek v moderním jazyce, řeší však stejný problém: obnovit
známý kontext příkazu a dovolit uživateli vstup opravit.

## Instrukce dokončení mění význam

Tři bajty na `monitorInputCompletionDispatch` obvykle tvoří:

```asm
    jp evaluateInputExpression
```

Při sestavování řádku v monitoru PROMETHEUS změní pouze bajt opcodu z `$C3`
(`JP nn`) na `$21` (`LD HL,nn`). Oba bajty adresy zůstávají beze změny.

Tytéž bajty potom znamenají:

```asm
    ld hl,evaluateInputExpression
```

Tato instrukce provede neškodnou přípravu a vykonávání propadne do
`assembleMonitorInputLine`, místo aby skočilo do evaluatoru expressionu.

Jediný samomodifikovaný opcode tedy vybírá typ výsledku:

```text
$C3  odpovědí promptu je expression
$21  zadaným textem je jeden řádek zdroje assembleru
```

Kapitola 36 bude sledovat cestu sestavení. Zde je důležitá myšlenka, že samotnému
editoru vstupu je lhostejné, co dokončení znamená.

## Úprava uložených hodnot registrů

SYMBOL SHIFT+N vyvolá `setRegisterValue`. Počáteční řádek obsahuje tokenizované
`LD ` následované kurzorem:

```text
LD _
```

Uživatel zadává tvary jako:

```text
LD HL,#8000
LD A,65
LD X,BUFFER
```

PROMETHEUS pro tento příkaz neudržuje zvláštní tabulku názvů registrů. Prochází
prvních dvacet čtyři deskriptorů čelního panelu počínaje
`frontPanelRegistersItems`.

Tyto deskriptory už obsahují:

- selektor viditelného názvu v bajtu 2;
- informaci o bajtu nebo slovu v bajtu 3;
- cílovou adresu v bajtech 5 a 6.

Popis zobrazení se stává popisem editace.

V pseudokódu:

```text
for each editovatelný deskriptor panelu:
    if zadaný název odpovídá nadpisu deskriptoru:
        value = vyhodnoť zbývající expression
        destination = descriptor.valueAddress
        ulož bajt nebo slovo podle deskriptoru
        return

error "Bad operand"
```

Jde o mimořádně elegantní opětovné použití. Registr zobrazený na panelu a registr
přijímaný příkazem `LD` se nemohou nepozorovaně rozejít do různých seznamů názvů,
protože oba popisuje tentýž záznam.

## Kterým hodnotám lze přiřazovat?

Průchod zahrnuje:

```text
A B C D E H L I R
HX LX HY LY
F AF BC DE HL SP IX IY
T X Y
```

Jednobajtový deskriptor uloží pouze dolní bajt výsledku. Slovní deskriptor uloží
běžnou little-endian dvojici. T, X a Y se podle třídy selektoru nadpisu považují
za slova, přestože ne všechna jsou názvy registrů Z80.

Přiřazení mění **uložený uživatelský stav** nebo adresové proměnné vlastněné
panelem. Nepřepisují dočasné pracovní registry monitoru. Proto změny zůstanou
viditelné po návratu příkazu a překreslení panelu.

## Zkratka pro F

F přijímá běžné číselné přiřazení, podporuje však také kompaktní přepínání
příznaků:

```text
LD F,S
LD F,Z
LD F,P
LD F,C
```

Písmena vybírají masky:

```text
S  $80
Z  $40
P  $04
C  $01
```

Vybraný bit se XORuje s uloženým bajtem F, takže příkaz jej přepíná, místo aby jej
pouze nastavoval.

Tabulka masek se ve velmi kompaktním triku s kódem a daty překrývá se
spustitelnými bajty. Za poslední maskou bezprostředně následuje opcode a adresa
skutečné instrukce `LD DE,savedRegisterAF`, po níž nepatrný společný ocas provede
XOR a uložení.

Pro mladého čtenáře je nejbezpečnější tuto oblast chápat nikoli simulováním jejího
náhodného lineárního disassembly výpisu. Čtěte ji jako:

```text
čtyři záznamy (písmeno,maska)
následované společnou rutinou přepnutí
```

## Jedna úplná cesta zadání adresy

Předpokládejme, že současnou adresou monitoru je `$8000`, uživatel stiskne M,
zadá:

```text
LOOP+2
```

a stiskne ENTER.

Cesta vypadá takto:

```text
startMonitor dispatchuje M s HL=$8000
    ↓
monSetCurrentAddress zavolá promptForMonitorValue
    ↓
inline token vytvoří pevný prompt "Memory"
    ↓
monitorInputLoop edituje sdílený buffer řádku
    ↓
evaluator expressionu vyřeší LOOP a přičte 2
    ↓
propadávající aritmetika ponechá výsledek beze změny
    ↓
setMonitorCurrentAddressAndRet jej uloží do operandu LD DE
    ↓
RET dospěje k syntetickému startMonitor
    ↓
překreslení panelu začne disassembly výpis na nové adrese
```

Žádná část této cesty nepotřebuje zvláštní „parser adres“. PROMETHEUS skládá svou
běžnou klávesnici, editor řádku, renderer tokenů, evaluator expressionů a teplé
překreslení monitoru.


## Jedna úplná cesta úpravy registru

Pro:

```text
LD HL,BUFFER
```

PROMETHEUS:

1. vytvoří pevný prefix `LD `;
2. přijme zbytek přes `monitorInputLoop`;
3. prochází nadpisy deskriptorů, dokud nenajde HL;
4. vyhodnotí `BUFFER` běžným parserem expressionů se znalostí symbolů;
5. přečte z deskriptoru cílový pointer `savedRegisterHL`;
6. zjistí, že HL je slovní položka;
7. uloží oba bajty výsledku;
8. vrátí se k úplnému překreslení panelu.

Paměťová položka panelu `(HL)` je nepřímá přes totéž uložené slovo, takže ihned
začne zobrazovat také paměť na nové adrese.

Jediné přiřazení tedy bez zvláštní koordinace aktualizuje několik viditelných
důsledků.

## Co se změnilo v paměti?

Navigace po adresách může změnit:

- operand `varcMonitorCurrentAddress`;
- hloubku a uložená slova v `monitorNavigationAddressStack`.

Obsluha promptu dočasně mění:

- `inputBufferStart` a polohu jeho kurzoru;
- opcode v `monitorInputCompletionDispatch`;
- uložený operand SP v `monitorInputRestart`;
- sdílený hook `errorAction`;
- dočasné řetězce parseru.

Editace registrů mění oblast uložených uživatelských registrů,
`accumulatedTStates` nebo adresové proměnné X/Y vlastněné monitorem, které vybral
odpovídající deskriptor.

## Myšlenky potřebné v dalších kapitolách

- Současná adresa je výchozím bodem pro výpisy, disassembly a vykonávání.
- Vstup promptu je běžným vstupem editoru s jinou dokončovací akcí.
- Po chybách parseru lze bezpečně opakovat pokus, protože se obnoví zásobník
  příkazu.
- Editace registrů znovu používá názvy a cíle deskriptorů čelního panelu.
- Kurzor dolů závisí na témže dekodéru, který bude později sloužit disassembleru
  a krokování.

## Pokrytí zdroje

Tato kapitola vysvětluje `varcMonitorCurrentAddress`, `monSetCurrentAddress`,
pohyb po bajtech a instrukcích, `monitorNavigationAddressStack`, `monLevelUp`,
`monLevelDown`, `promptForMonitorValue`, `monitorInputBuffersInitialization`,
`renderMonitorInputLine`, `monitorInputLoop`, zotavení po chybě vstupu monitoru,
`monitorInputCompletionDispatch` a `setRegisterValue`.
