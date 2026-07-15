# Kapitola 42: Celá cesta zkoumáním programu

Deset kapitol jsme monitor rozebírali na jednotlivé součásti. Teď je čas znovu
složit dohromady celou jeho prohlížecí část.

Tato kapitola nepřináší žádný velký nový algoritmus. Místo toho sleduje jedno
realistické sezení a pozoruje, jak již známé mechanismy spolupracují:

```text
vstup do monitoru
volba adresy
čtení čelního panelu
výpis a klasifikace paměti
změna způsobu zobrazení
hledání bajtů
úprava jedné instrukce
odeslání disassembly výpisu na papír nebo do zdroje
uložení a obnovení bloku
```

Smyslem není zapamatovat si klávesy. Důležité je vidět, že monitor není pytel
navzájem nesouvisejících nástrojů. Většina viditelných operací prochází několika
málo společnými reprezentacemi a smlouvami.

## Program, který budeme zkoumat

Předpokládejme, že editor sestavil na adrese `$8000` tuto malou rutinu:

```asm
START   LD B,5
LOOP    DJNZ LOOP
        RET
```

Paměť obsahuje:

```text
$8000  06 05
$8002  10 FE
$8004  C9
```

Tabulka symbolů obsahuje:

```text
START = $8000
LOOP  = $8002
```

Zatím ji nebudeme spouštět. Vykonávání začíná až v části VI. Monitor je prozatím
pozorovatelem a editorem.

## 1. Vstup do monitoru

Příkaz editoru `MONITOR` dojde do `invokeMonitor`. S parametrem `A` nejprve sestaví
současný zdroj. Potom vyčistí obrazovku editoru a skočí buď na skutečný prefix
monitoru, nebo v instalaci obsahující pouze assembler přes fallback opravený
instalátorem.

`startMonitor` poté vytvoří čistý soukromý svět:

- přerušení jsou zakázána;
- obnoví se border;
- resetuje se stack monitoru;
- inicializuje se sdílený stav vstupu;
- znovu se sestaví text zásad;
- překreslí se čelní panel;
- načte a dispatchuje se klávesa.

Každý běžný příkaz monitoru se vrací na syntetickou adresu `startMonitor`
uloženou na stacku. Každý handler tak dostane nový teplý vstup a překreslení,
aniž by musel obsahovat vlastní závěrečný skok.

Na této úrovni vypadá smyčka takto:

```text
startMonitor:
    resetuj dočasný stav monitoru
    překresli panel kolem current_address
    key = načti klávesu
    dispatch key
    ; RET handleru znovu dosáhne startMonitor
```

## 2. Volba `$8000`

Uživatel zvolí současnou adresu a zadá `$8000`. Prompt se vykreslí přes sdílený
vstupní řádek monitoru. Vyhodnocovač expressionů přijme šestnáctkové číslo a
vrátí je v `HL`.

`setMonitorCurrentAddressAndRet` opraví operand instrukce:

```asm
varcMonitorCurrentAddress:
    ld de,00000h
```

Dva bajty operandu nyní obsahují `$8000`. Jsou současně uloženým stavem a vstupem
budoucí instrukce.

Při dalším teplém vstupu dodá monitor tuto současnou adresu handlerům i
překreslení čelního panelu.

## 3. Čtení čelního panelu

Panel nekreslí čtyřiatřicet zvláštních tiskových rutin. Jeho tabulka deskriptorů
říká, kde leží každá položka, jak se jmenuje, odkud pochází její hodnota a jak se
má formátovat.

Položka disassembly závislá na současné adrese dostane `$8000` prostřednictvím
`varcFrontPanelDisassemblyAddress`. Její smyčka s pevným počtem řádků opakovaně
volá sdílený disassembler.

Panel proto může vedle uložených registrů, flags a vybraných hodnot paměti
ukázat například:

```text
START   LD B,5
LOOP    DJNZ LOOP
        RET
```

V této chvíli spolupracuje několik vrstev:

```text
stav současné adresy
    -> deskriptor panelu
    -> zvláštní renderer disassembly
    -> sdílený dekodér instrukcí
    -> dočasný záznam zdroje
    -> lineBuffer
    -> bitmapový renderer
```

Panel je pohledem na stav, nikoli samostatným modelem stroje.

## 4. Pohyb po bajtech a instrukcích

Klávesa pro posun o jeden bajt vpřed změní `$8000` na `$8001`. Panel nyní začíná
uprostřed instrukce `LD B,5`. Bajt `$05` může být podle následujících bajtů
interpretován jako nějaká zcela jiná instrukce.

Není to chyba. Monitor strojového kódu dovoluje libovolné zarovnání.

Klávesa pro posun o jednu instrukci vpřed se chová jinak:

```asm
monOneInstructionForward:
    call decodeInstructionAtHL
    jr setMonitorCurrentAddressAndRet
```

Při začátku na `$8000` dekodér rozpozná dvoubajtovou instrukci a vrátí
`HL=$8002`. Současnou adresou se stane začátek následující instrukce.

Tentýž dekodér tedy slouží dvěma účelům:

- v kapitole 39 se jeho výsledek používal k vytvoření textu;
- navigace používá pouze vrácenou následující adresu.

Je to první náznak vykonávacího engine, který přijde později. Dekódování je
užitečné i tehdy, když se nic netiskne.

## 5. Otevření interaktivního výpisu

V zahájí disassembly výpis od vyžádané adresy. SYMBOL SHIFT+4 začne od adresy
současné.

Výpis nemá předem určený konec. Dekodér vytváří vždy jeden řádek `lineBuffer` a
společná výstupní rutina seznamového okna se stará o rolování a klávesy
pokračování.

Po `RET` dekodér vyžádá prázdný oddělovač. Následující volání vydá prázdný řádek,
aniž by posunulo adresu, a další volání pokračuje pamětí na `$8005`.

To ukazuje, proč smlouva dekodéru zahrnuje text i následující adresu:

```text
řádek 1: START LD B,5      next = $8002
řádek 2: LOOP  DJNZ LOOP   next = $8004
řádek 3:       RET         next = $8005, čeká oddělovač
řádek 4:                   next = $8005
řádek 5: dekóduj na $8005  next = ...
```

## 6. Změna zobrazování adres

Ovládací prvky C a SYMBOL SHIFT+C mění dvě nezávislé volby:

- zda se tisknou číselné adresy;
- zda se dávají přednost symbolům, nebo se ponechávají číselné hodnoty.

Tyto preference ovlivní všechna pozdější použití sdíleného disassembleru:

- interaktivní výpis;
- řádky čelního panelu;
- disassembly na tiskárně;
- obrácené disassemblování do zdroje.

Režim se nepředává dolů velkým záznamem parametrů. Je uložen v samomodifikovaném
stavu, například v `varcDisassemblyAddressMode` a
`varcShowNumericDisassemblyAddresses`.

Výsledek se může změnit z:

```text
$8002  DJNZ $8002
```

na:

```text
$8002  DJNZ LOOP
```

nebo na řádek orientovaný na zdroj bez číselného prefixu.

## 7. Rozlišení kódu a dat

Předpokládejme, že bajty na `$8100` tvoří tabulku:

```text
01 00 02 00 03 00
```

Bez nápovědy se je disassembler pokusí interpretovat jako instrukce. Pomocí
klávesy 2 tabulky ochran může uživatel označit `$8100..$8105` jako oblast DEFW.
Tentýž disassembler nyní vypíše slova.

Pomocí klávesy 1 lze jiný rozsah vynutit jako `DEFB`.

Když současná adresa vstoupí do samotného rezidentního PROMETHEA, automaticky se
uplatní skrytá dynamická oblast DEFB. Monitor zobrazí jeho vlastní bajty jako
data, místo aby předstíral, že jde o běžné uživatelské instrukce.

Tato zásada se kontroluje před dekódováním opcodu:

```text
if adresa v tabulce DEFB:
    vytvoř jednobajtový záznam DEFB
else if adresa v tabulce DEFW:
    vytvoř jednoslovný záznam DEFW
else:
    dekóduj instrukci
```

Klasifikace a dekódování jsou tedy dvě oddělená rozhodnutí.

## 8. Hledání smyčky

Představme si, že nevíme, kde rutina leží, ale pamatujeme si část jejího tvaru v
bajtech:

```text
06 : 10 : C9
```

Příkaz G monitoru uloží pět dvojic `(value, mask)`. Dvojtečky vytvoří nulové masky
a proto odpovídají libovolnému bajtu.

Vzorec hledání pro každou pozici je:

```text
(memory XOR wanted) AND mask
```

Na `$8000` leží pět bajtů:

```text
06 05 10 FE C9
```

Vzoru odpovídají. Monitor nastaví `$8000` jako současnou adresu a čelní panel
okamžitě nabídne symbolický disassembly výpis.

N zahájí další hledání za předchozí shodou. Finder, stav současné adresy a čelní
panel jsou volně propojeny jedinou adresou, nikoli velkým objektem výsledku
hledání.

## 9. Úprava jedné instrukce

Předpokládejme, že chceme `LD B,10` místo `LD B,5`.

Příkaz SPACE připraví jeden assemblerový řádek monitoru na současné adrese.
Uživatel zadá:

```asm
LD B,10
```

PROMETHEUS nepoužívá zvláštní zapisovač opcode monitoru. Znovu využije:

- běžný tokenizer zdroje;
- slovníky mnemonic a operandů;
- tabulku instrukcí;
- logiku velikosti prvního průchodu;
- emisi bajtů druhého průchodu;
- chráněné kontroly výstupu.

Bajty se změní na:

```text
$8000  06 0A
```

Po návratu do teplého vstupu monitoru se panel znovu překreslí a nový operand je
viditelný.

Tato cesta je delší než ruční zapsání `$0A` do `$8001`, ale zachovává záměr
vyjádřený assemblerem a odhalí neplatné tvary instrukcí.

## 10. Prohlížení surových bajtů a znaků

L zobrazuje číselné řádky paměti. O zobrazuje znakové řádky. Oba používají
společné seznamové okno monitoru a jeho chování při pokračování.

Uživatel se proto může na stejnou adresu dívat ve třech jazycích:

```text
číselná paměť:   06 0A 10 FE C9
znaky:           .....
disassembly:     LD B,10 / DJNZ LOOP / RET
```

Ani jeden z nich není jediným pravým významem paměti. Jsou to interpretace
zvolené podle právě kladené otázky.

To je zvlášť důležité na osmibitovém stroji, kde tentýž bajt může být:

- opcode;
- operand;
- znak;
- fragment bitmapy;
- počet položek tabulky;
- část little-endian adresy.

## 11. Přesouvání, vyplňování a ochrana bloků

Dvojice příkazů I a P pracují s inkluzivními rozsahy. MOVE volí při překryvu
zdroje a cíle kopírování vpřed nebo vzad. FILL uloží první bajt a nechá jej přes
zbytek rozsahu replikovat instrukcí `LDIR`.

Oba chrání rezidentní PROMETHEUS, ale nekonzultují konfigurovatelná okna WRITE.
Tato okna patří zásadám vykonávání uživatelských instrukcí.

Toto rozdělení už lze chápat jako záměrnou architekturu, nikoli nesrovnalost:

```text
důvěryhodný blokový příkaz monitoru:
    chraň rezidentní dílnu

neznámá uživatelská instrukce během trasování:
    chraň rezidentní dílnu
    plus uživatelská okna READ/WRITE/RUN
```

Monitoru samotnému se důvěřuje, že provede operaci, kterou uživatel výslovně
požadoval.

## 12. Odeslání disassembly jinam

D se zeptá na rozsah a vytiskne jej přes kanál 3. SYMBOL SHIFT+D odešle stejné
vygenerované řádky parseru editoru.

Pro náš příklad může obrácené disassemblování znovu vytvořit:

```asm
START   LD B,10
LOOP    DJNZ LOOP
        RET
```

Cesta je záměrně kruhová:

```text
zdroj
 -> komprimované záznamy
 -> strojové bajty
 -> text disassembly
 -> běžný parser zdroje
 -> znovu komprimované záznamy
```

Protože návratová cesta používá běžný parser, rekonstruovaný zdroj dodržuje
stejná pravidla jako zdroj zadávaný z klávesnice. Selže-li jeden vygenerovaný
řádek, monitor obnoví uložený bod stacku, nechá uživatele řádek opravit a zkusí
jej znovu. Dřívější vložení zůstanou zachována.

## 13. Uložení zkoumaného bloku

S může uložit `$8000..$8004` jako surový blok se zvoleným příznakem nebo jako
standardní soubor CODE pomocí `:filename`.

Y může později přečíst hlavičku CODE, zobrazit její typ, jméno, adresu a délku a
po stisku J načíst následující blok `$FF`.

Tím se uzavírá cyklus zkoumání a opravy:

```text
najdi rutinu
prohlédni symboly a instrukce
změň jednu instrukci
vytiskni nebo rekonstruuj zdroj
ulož opravené bajty
```

Monitor nemusí vědět, že těch pět bajtů tvoří náš průběžný příklad. Poskytuje
obecné operace, které se právě v tomto pracovním postupu vhodně skládají.

## Tři neutrální formy monitoru

Napříč částí V se většina operací sbíhá ke třem jednoduchým formám.

### 1. Adresa

`varcMonitorCurrentAddress+1` je ústředním bodem pro:

- překreslování čelního panelu;
- navigaci po bajtech a instrukcích;
- výsledky hledání;
- editaci paměti;
- krokování v následující části.

### 2. Dvaatřicetibajtový řádek

`lineBuffer` je výměnným bodem pro:

- výpisy paměti;
- disassembly;
- řádky čelního panelu;
- výstup na tiskárnu;
- obrácené vkládání zdroje;
- zobrazení hlavičky.

### 3. Inkluzivní rozsah

Dvojice First/Last podporují:

- MOVE;
- FILL;
- monitorové SAVE a LOAD;
- ochranná okna.

Některé příkazy přijímají First/Length, ale před skutečnou prací je normalizují
na stejnou inkluzivní formu.

Tyto formy udržují program srozumitelný. Každý subsystém může spolupracovat,
aniž by sdílel všechny své soukromé podrobnosti.

## Hranice důvěry monitoru

Nyní můžeme shrnout, co prohlížecí monitor chrání a co ne.

| Operace | Je chráněn rezidentní PROMETHEUS? | Používají se vlastní okna READ/WRITE/RUN? |
|---|---:|---:|
| Klasifikace disassembly | rezidentní oblast vynucena jako DEFB | pouze tabulky DEFB/DEFW |
| Jednořádkové sestavení do paměti | ano, přes emitter assembleru | ne |
| MOVE / FILL | ano | ne |
| Surový monitorový LOAD | ano | ne |
| Monitorový SAVE | žádný zákaz čtení | ne |
| Trasovaná uživatelská instrukce | ano | ano, podle typu přístupu |

Poslední řádek patří do části VI. Právě kvůli němu pět tabulek rozsahů zahrnuje
READ, WRITE a RUN, přestože je vlastní důvěryhodné blokové nástroje monitoru
většinou nekonzultují.

## Zkoumání není vykonávání

Monitor zatím změnil paměť jen tehdy, když jej o to uživatel výslovně požádal:

- sestavit náhradní instrukci;
- přesunout nebo vyplnit rozsah;
- načíst kazetový blok.

Dosud neobnovil uložené uživatelské registry a nedovolil neznámé instrukci se
vykonat.

Tento další krok je mnohem těžší. Před vykonáním jediné instrukce musí
PROMETHEUS odpovědět například na tyto otázky:

- Který úplný stav procesoru patří uživatelskému programu?
- Čte, zapisuje nebo vykonává tato instrukce chráněnou adresu?
- Je to skok, call, návrat nebo restart?
- Kam se má řízení vrátit do monitoru?
- Jak může monitor vykonat relokovanou kopii, aniž změní její význam?
- Co se stane s přerušeními, alternativními registry, SP a registrem refresh?

Dekodér instrukcí, kterému již rozumíme, bude základem, sám však nestačí.

## Úplná smyčka zkoumání v pseudokódu

```text
enter_monitor(optional_compile):
    if optional_compile:
        sestav zdroj

    repeat:
        resetuj soukromý stack monitoru a hooky
        překresli panel řízený deskriptory na current_address
        key = načti klávesu monitoru

        if key mění adresu:
            aktualizuj current_address

        else if key požaduje pohled:
            převeď paměť na řádky lineBuffer
            odešli řádky do panelu nebo rolujícího seznamu

        else if key edituje paměť:
            použij důvěryhodnou operaci monitoru nebo assembleru
            chraň rezidentní dílnu tam, kde to daný příkaz vyžaduje

        else if key mění zásady:
            uprav tabulky zobrazení, DEFB/DEFW nebo ochrany vykonávání

        else if key přenáší data:
            převeď inkluzivní rozsah na kazetové parametry ROM

        else if key požaduje vykonávání:
            vstup do mechanismu části VI
```

Teplý vstup vrací každý dokončený příkaz ke stejnému vrcholovému obrazu.

## Co se změnilo v paměti

Během celého sezení:

- `varcMonitorCurrentAddress+1` sleduje ohniskovou adresu;
- prezentaci řídí deskriptory panelu a samomodifikované bajty režimu;
- `lineBuffer` opakovaně přijímá různé pohledy na paměť;
- tabulky rozsahů mohou získat nebo ztratit uživatelská okna;
- jednořádkové sestavení může změnit strojové bajty;
- stav finderu si pamatuje pět dvojic masky a hodnoty i následující pozici;
- obrácené disassemblování může vytvořit záznamy zdroje a symboly;
- kazetové příkazy mohou vyplnit pracovní hlavičky nebo přepsat načítaný cíl;
- uložený stav uživatelského procesoru zůstává datovým obrazem monitoru, nikoli
  dosud běžícím CPU.

## Znovu propojené důležité labely

- `invokeMonitor`
- `startMonitor`
- `varcMonitorCurrentAddress`
- `frontPanelItemDescriptors`
- `redrawFrontPanelAtCurrentAddress`
- `varcFrontPanelDisassemblyAddress`
- `decodeInstructionAtHL`
- `disassembleNextLineToBuffer`
- `lineBuffer`
- `monFindSequence`
- `monNextSequence`
- `monitorFindByteMaskPairs`
- `editOneMonitorAssemblyLine`
- `assembleMonitorInputLine`
- `defbDisassemblyAreaTable`
- `defwDisassemblyAreaTable`
- `setReadProtectedAreas`
- `setWriteProtectedAreas`
- `setExecutionProtectedAreas`
- `monDisassemblyOnPrinter`
- `monDisassembleIntoSource`
- `monSaveBlockFirstLast`
- `monLoadBlockFirstLast`
- `monReadTapeHeaderOrLeader`

## Myšlenky potřebné v části VI

- Dekodér může vrátit strukturu instrukce bez vytváření textu.
- Současná adresa se stane uloženým program counterem uživatele.
- Soukromý stack monitoru musí přežít instrukce, které používají nebo nahrazují
  uživatelský stack.
- Okna READ, WRITE a RUN začnou platit, když monitor vykonává neznámý kód jménem
  uživatele.
- Samomodifikované opcodes zásad a uložená pokračování budou vybírat mezi několika
  cestami vykonávání.
- Před vykonáním se musí obnovit úplný obraz uživatelských registrů a po něm
  znovu zachytit.

Část V nás naučila, jak PROMETHEUS na jiný program **hledí**. Část VI vysvětlí,
jak se tímto programem na okamžik **stane** a přesto znovu najde cestu domů.
