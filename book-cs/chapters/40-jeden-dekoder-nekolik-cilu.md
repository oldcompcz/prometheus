# Kapitola 40: Jeden dekodér, několik cílů

Disassembler se může snadno změnit ve sbírku téměř totožných rutin. Jedna
rutina tiskne na obrazovku. Jiná tiskne na papír. Třetí převádí tytéž bajty na
editovatelný zdroj. Čtvrtá vyplňuje malé okno v panelu registrů. Kdyby každá
verze prováděla vlastní dekódování instrukcí, program by rostl a jednotlivé
varianty by se od sebe pomalu vzdalovaly.

PROMETHEUS se této pasti vyhýbá. Má jeden ústřední krok:

```text
strojová adresa
    -> jeden kanonický 32sloupcový řádek v lineBuffer
    -> následující strojová adresa
```

Teprve potom jiná rutina rozhodne, kam má řádek putovat.

Tato kapitola se zabývá právě touto druhou polovinou. Kapitola 39 vysvětlila,
jak se bajty mění na mnemonic, operandy, volitelné symboly a případný prázdný
oddělovač. Nyní budeme hotový řádek sledovat ke čtyřem různým cílům:

1. do rolovacího okna seznamu monitoru;
2. do pevné oblasti disassembly na čelním panelu;
3. na výstupní kanál Spectra 3, obvykle tiskárnu;
4. do editoru zdroje PROMETHEA.

Důležité poučení je obecnější než samotné disassemblování. Na malém stroji má
užitečná mezireprezentace často větší cenu než několik chytrých zvláštních
případů.

## Neutrální místo setkání

Neutrální podobou je `lineBuffer`. Má přesně třicet dva bajtů, protože to je
šířka obrazovky Spectra i běžného rendereru zdrojového řádku. Může obsahovat:

- číselný prefix adresy;
- pole labelu;
- pole mnemonic a operandů;
- koncové mezery;
- zcela prázdný oddělovací řádek.

Dekodér netiskne ve chvíli, kdy rozhoduje, co instrukce znamená. Nejprve celý
řádek dokončí a v `HL` vrátí adresu následující položky:

```asm
    call disassembleNextLineToBuffer
    ; lineBuffer now contains one complete row
    ; HL now points at the next machine-code address
```

Tento kontrakt je záměrně prostý. Volající nemusí vědět, zda řádek vznikl z:

- obyčejné instrukce;
- vynuceného bajtu `DEFB`;
- vynuceného slova `DEFW`;
- neznámé posloupnosti opkódů;
- vyžádaného oddělovače po nepodmíněném přenosu řízení.

Dostane jeden řádek a jednu následující adresu.

V pseudokódu:

```text
function make_disassembly_line(address):
    if čeká prázdný oddělovač:
        vyčisti lineBuffer
        zruš čekající oddělovač
        return address

    klasifikuj address jako DEFB, DEFW nebo instrukci
    vytvoř dočasný záznam zdroje
    expanduj tento záznam do lineBuffer
    doplň adresu nebo informace o symbolu

    if tato instrukce vyžaduje vizuální oddělení:
        zapamatuj si, že příští volání musí vrátit prázdný řádek

    return adresa za dekódovanými bajty
```

Řádek tedy není pouhým textem pro zobrazení. Je výměnným formátem mezi
dekodérem a několika nezávislými spotřebiteli.

## Cíl jedna: rolovací seznam monitoru

Nejjednodušším spotřebitelem je interaktivní výpis vyvolaný V nebo SYMBOL
SHIFT+4. První varianta se zeptá na počáteční adresu, druhá začne na současné
adrese monitoru.

Srdce výpisu je téměř směšně krátké:

```asm
monListDisassembly:
    call beginMonitorListOutputWithBlankLine
    call disassembleNextLineToBuffer
    call outputMonitorListLineAndPollContinuation
    jr $-6
```

Smyčka nemá koncovou adresu. Pokračuje tak dlouho, jak dovoluje společná
konvence monitoru pro výpis seznamu:

- držená klávesa plynule vypisuje další řádky;
- její uvolnění výpis pozastaví;
- jiná běžná klávesa pokračuje;
- EDIT se vrátí do monitoru.

`outputMonitorListLineAndPollContinuation` neví, že řádek představuje
disassembly. Stejná obecná mašinérie okna seznamu se používá i pro výpis paměti
a tabulek. Připojí `lineBuffer`, podle potřeby okno odroluje a obslouží klávesy
pro pokračování.

První cíl má tedy ve své nejjednodušší podobě tento tvar:

```text
repeat forever:
    address = make_disassembly_line(address)
    připoj lineBuffer do okna seznamu monitoru
    respektuj klávesy pokračování seznamu
```

Prázdný oddělovač se považuje za skutečný vizuální řádek. Protože pro něj
dekodér vrátí tutéž adresu, následující iterace dekóduje bajt paměti, který před
oddělovačem čekal.

## Cíl dva: čelní panel

Čelní panel potřebuje jiný druh výpisu. Nemůže rolovat donekonečna. Jeho
deskriptor rezervuje pevnou obdélníkovou oblast a přesně říká, kolik řádků se
má vykreslit.

Zvláštní renderer panelu začne vyzvednutím počtu řádků z deskriptoru položky:

```asm
.renderFrontPanelDisassemblyWindow:
    ld a,(ix+004h)
    and 01fh
    ld b,a
    call clearPendingDisassemblySeparatorAndReturn
varcFrontPanelDisassemblyAddress:
    ld hl,00000h
```

Počáteční adresa je operandem samomodifikované instrukce `LD HL,nn`. Kdykoli se
panel překreslí pro novou adresu monitoru, tento operand se patchne. Smyčka je
pak přímočará:

```asm
.renderNextFrontPanelDisassemblyRow:
    push bc
    call disassembleNextLineToBuffer
    call renderLineBufferAtMonitorListCursor
    pop bc
    djnz .renderNextFrontPanelDisassemblyRow
```

Od interaktivního seznamu se liší ve dvou bodech:

1. panel začíná bez čekajícího oddělovače zděděného po dřívějším použití;
2. o konci rozhoduje počet v deskriptoru, nikoli stisk klávesy.

Renderer stále dostává tentýž třicetidvoubajtový řádek. Pouze jej umístí na
bitmapovou pozici vybranou deskriptorem panelu.

Panel tedy nevlastní druhý miniaturní disassembler. Vlastní krátkou smyčku s
pevným počtem iterací kolem běžného disassembleru.

## Cíl tři: tiskárna

Příkaz D se zeptá na First a Last a odešle disassembly zadaného rozsahu na
kanál Spectra 3. V běžné konfiguraci Spectra jde o tiskový kanál, přestože jej
kanálový systém ROM může přesměrovat jinam.

Vybraná výstupní rutina se vloží do `HL`:

```asm
monDisassemblyOnPrinter:
    ld hl,outputLineBufferToChannel3
```

Řízení pak propadne do společného driveru rozsahu. Driver patchne operand
skutečné instrukce `CALL`:

```asm
varcRangedDisassemblyOutputCall:
    call 00052h
```

Za běhu její operand ukazuje buď na cíl tiskárny, nebo na cíl zdroje, se kterým
se setkáme za chvíli. Opkód zůstává `CALL`; mění se pouze dvoubajtový cíl.

Samotný cíl tiskárny je sdílen s příkazem PRINT editoru:

```asm
outputLineBufferToChannel3:
    ld a,003h
    call ROM_ChannelOpen
    ei
    ld hl,00010h
    call printExpandedSourceLineWithRoutine
    ld a,00dh
    rst ROM_PrintACharacter
    xor a
    ret
```

Otevře kanál 3, vytiskne již připravený řádek, vyšle ENTER a vrátí se. Není v
něm vůbec žádná logika disassembleru.

Driver rozsahu navíc každý vytvořený řádek připojí do okna seznamu monitoru ještě
před voláním zvoleného cíle. Uživatel tedy může sledovat tytéž řádky, které se
právě tisknou.

## Jeden driver rozsahu

Společný driver je nejdůležitější částí této kapitoly. Jeho úplný tvar je:

```text
zvol cíl pro jednotlivé řádky
zeptej se na First a Last
current = First

while current < Last:
    next = make_disassembly_line(current)
    zobraz lineBuffer v okně seznamu monitoru
    odešli lineBuffer zvolenému cíli

    if CAPS SHIFT+ENTER žádá zastavení:
        dokonči

    current = next
```

`Last` je exkluzivní. Je-li `Last` rovno `$8100`, instrukce začínající na
`$8100` se nevypíše. Instrukce začínající na `$80FF` se vypíše celá, i když
její bajty operandu leží na `$8100` nebo za touto adresou. Test se týká
počáteční adresy každé dekódované položky, nikoli každého bajtu, který může
dekodér přečíst.

Zdroj provede porovnání po návratu z cíle:

```asm
    push hl
    or a
    sbc hl,de
    pop hl
    jr c,.processNextRangedDisassemblyLine
```

Zde `HL` obsahuje následující počáteční adresu a `DE` exkluzivní koncový bod.

Tento návrh také znamená, že čekající prázdný oddělovač se rozsahu účastní.
`HL` neposune, ale vypíše se, dokud pod `Last` stále zbývá další skutečná
adresa.

## Cíl čtyři: editovatelný zdroj PROMETHEA

SYMBOL SHIFT+D zvolí druhý cíl:

```asm
monDisassembleIntoSource:
    xor a
    ld (varcShowNumericDisassemblyAddresses+1),a
    ld hl,copyDisassemblyLineToInputBuffer
    jr .configureRangedDisassembly
```

Číselné prefixy adres jsou vypnuty, protože jde o dekoraci zobrazení, nikoli o
platná pole zdroje. Přesné labely symbolů lze nadále vytvářet podle současného
režimu adres disassembly.

Cílová rutina zkopíruje všech třicet dva bajtů:

```asm
copyDisassemblyLineToInputBuffer:
    ld hl,lineBuffer
    ld de,inputBufferStart
    ld bc,00020h
    ldir
```

Poté vstoupí do běžné pipeline editoru:

```asm
parseAndInsertDisassemblyLine:
    call clearStringBuffers
    ld hl,inputBufferStart
    call atHLorNextIfOne
    ld d,000h
    ld c,009h
    jp parseAndInsertSourceLine
```

Jde o zásadní architektonickou volbu. PROMETHEUS **nevyrábí** trvalý
komprimovaný záznam zdroje přímo ze soukromých znalostí disassembleru. Projde
stejným parserem jako řádek zadaný člověkem.

Důsledky jsou cenné:

- pravopis mnemonic a operandů se zkontroluje běžným způsobem;
- jména symbolů se běžným způsobem vyřeší nebo vytvoří;
- kapacita paměti zdroje se běžným způsobem zkontroluje;
- rámování záznamu a zpětné odkazy se běžným způsobem vytvoří;
- každý vložený řádek se stane kanonickým zdrojem PROMETHEA.

Cesta vypadá takto:

```text
strojové bajty
    -> dočasný záznam disassembly
    -> kanonický 32sloupcový text
    -> běžný vstupní buffer editoru
    -> běžný parser zdroje
    -> trvalý komprimovaný záznam zdroje
```

Může působit nehospodárně opustit kompaktní záznam, expandovat jej na text a
znovu jej komprimovat. Oba záznamy však slouží různým účelům. Dočasný záznam je
soukromou pomůckou dekodéru. Trvalý záznam musí dodržet všechny invarianty
editoru a tabulky symbolů.

## Proč se z prázdných oddělovačů stávají skutečné zdrojové řádky

Po vybraných nepodmíněných skocích a návratech požádá disassembler o prázdný
řádek. Na obrazovce nebo papíře zlepšuje čitelnost. Při obráceném
disassemblování se tentýž prázdný řádek předá parseru zdroje a stane se prázdným
záznamem zdroje.

Toto chování není náhodné. Zachovává vizuální seskupení v editovatelném
programu.

Předpokládejme, že paměť obsahuje:

```asm
        RET
NEXT    LD A,1
```

Vložený zdroj může vypadat takto:

```asm
        RET

NEXT    LD A,1
```

Oddělovač je nyní součástí zdrojového dokumentu. Lze jej přesunout, smazat nebo
vytisknout jako kterýkoli jiný prázdný řádek.

## Chyby při vkládání vytvořeného zdroje

Tisk je jednoduchý: selhání tiskové operace patří ROM a uživatel může rozsah
zastavit klávesou. Vkládání zdroje je složitější, protože běžný parser může při
hlášení chyby opustit několik vnořených volání.

Před vyvoláním cíle si driver rozsahu zaznamená současný ukazatel zásobníku v
operandu další samomodifikované instrukce:

```asm
    ld (recoverRangedDisassemblyInsertionError+1),sp
```

Vstup pro zotavení začíná:

```asm
recoverRangedDisassemblyInsertionError:
    ld sp,00000h
    call monitorInputLoop
    call parseAndInsertDisassemblyLine
    jr .resumeRangedDisassemblyAfterOutput
```

Pokud vytvořený řádek nelze přijmout, běžná chybová mašinérie skočí sem.
Obnovení zaznamenaného `SP` zahodí rámce zásobníku opuštěného parseru. Monitor pak
nechá uživatele vadný řádek upravit a zkusí jej znovu.

Jde o velmi prometheovské řešení:

```text
zapamatuj si bezpečnou úroveň zásobníku
zkus běžný parser
if selže:
    obnov tuto úroveň zásobníku
    nech člověka opravit vytvořený text
    odešli jej znovu
```

Rollback neexistuje. Řádky vložené před chybou ve zdroji zůstanou. Když se
oblast zdroje zaplní, praktickým únikem je opustit operaci pomocí EDIT; již
vložené záznamy zůstanou vložené.

## Malý trvalý vedlejší efekt

Obrácené disassemblování zapíše nulu do
`varcShowNumericDisassemblyAddresses+1`. Po dokončení neobnoví předchozí hodnotu.
Pozdější interaktivní disassembly proto také začíná se skrytými číselnými
prefixy, dokud je uživatel znovu nezapne pomocí C.

Při čtení rozhraní se to snadno přehlédne, při čtení samomodifikovaného stavu je
to zřejmé. Příkaz mění sdílenou předvolbu zobrazení, nikoli lokální dočasnou
volbu.

## Porovnání čtyř použití

| Cíl | Pravidlo zastavení | Co spotřebovává `lineBuffer` | Trvalý efekt |
|---|---|---|---|
| Interaktivní seznam | uživatelovy klávesy pokračování | renderer okna seznamu | žádný kromě stavu zobrazení monitoru |
| Čelní panel | počet řádků z deskriptoru | pevný renderer panelu | žádný |
| Tiskárna | exkluzivní Last nebo zastavovací kombinace kláves | výstupní rutina kanálu 3 | externí tištěný výstup |
| Editor zdroje | exkluzivní Last, chyba nebo zastavovací kombinace kláves | běžný parser zdroje | vložené záznamy zdroje a symboly |

Všechna čtyři použití začínají týmž dekodérem a týmž řádkem.

## Sledování běžícího příkladu

Předpokládejme, že paměť stále obsahuje:

```text
$8000  06 05
$8002  10 FE
$8004  C9
```

a tabulka symbolů obsahuje `START=$8000` a `LOOP=$8002`.

### Na čelním panelu

Deskriptor tří řádků začínající na `$8000` vyžádá:

```text
START   LD B,5
LOOP    DJNZ LOOP
        RET
```

Smyčka panelu skončí, protože její počet řádků klesne na nulu.

### V interaktivním seznamu

V začne na `$8000` a může pokračovat za `$8004`. Po `RET` může následující
volání vytvořit prázdný oddělovač ještě před dekódováním `$8005`.

### Na tiskárně

D s First `$8000` a Last `$8005` vytiskne tři řádky instrukcí. Exkluzivní
koncový bod zabrání nové instrukci začít na `$8005`.

### V editoru zdroje

SYMBOL SHIFT+D se stejným rozsahem zkopíruje každý řádek do `inputBufferStart`
a odešle jej parseru. Po posledním `RET` neleží pod koncovým bodem žádná další
strojová adresa, takže čekající oddělovač nemusí vytvořit další závěrečný záznam
zdroje.

Bajty doputovaly celou cestu zpět do editovatelného zdroje bez druhého dekodéru
instrukcí.

## Co se změnilo v paměti

Podle vybraného cíle:

- `lineBuffer` se přepisuje pro každý vytvořený řádek;
- `varcRangedDisassemblyOutputCall+1` uchovává adresu zvoleného cíle;
- `varcPostCommandContinuationJump+1` se dočasně přesměruje pro vkládání do
  zdroje;
- současná adresa a exkluzivní koncový bod se uchovávají na zásobníku monitoru;
- `recoverRangedDisassemblyInsertionError+1` si může zapamatovat bezpečný
  ukazatel zásobníku;
- `inputBufferStart` dostává vytvořený text zdroje;
- obrácené disassemblování může vkládat záznamy a vytvářet symboly;
- `varcShowNumericDisassemblyAddresses+1` zůstává po obráceném disassemblování
  vynulovaný.

Dekódované strojové bajty samotné se nemění.

## Důležité labely, se kterými jsme se setkali

- `lineBuffer`
- `disassembleNextLineToBuffer`
- `monListDisassemblyFromGivenAddress`
- `monListDisassembly`
- `outputMonitorListLineAndPollContinuation`
- `.renderFrontPanelDisassemblyWindow`
- `varcFrontPanelDisassemblyAddress`
- `renderLineBufferAtMonitorListCursor`
- `monDisassemblyOnPrinter`
- `.configureRangedDisassembly`
- `.processNextRangedDisassemblyLine`
- `varcRangedDisassemblyOutputCall`
- `outputLineBufferToChannel3`
- `monDisassembleIntoSource`
- `copyDisassemblyLineToInputBuffer`
- `parseAndInsertDisassemblyLine`
- `recoverRangedDisassemblyInsertionError`
- `varcShowNumericDisassemblyAddresses`

## Myšlenky potřebné později

- Nezpracované vedlejší efekty instrukce z dekodéru mohou sloužit analýze
  vykonávání, i když se žádný řádek netiskne.
- Samomodifikovaná volání se používají jako kompaktní selektory strategie.
- Obnovení uloženého ukazatele zásobníku je způsob PROMETHEA, jak bezpečně
  uniknout z opuštěné vnořené operace.
- Monitor rozlišuje důvěryhodné nástroje od uživatelského programu, který bude
  později vykonávat instrukci po instrukci.
