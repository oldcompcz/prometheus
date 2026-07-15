# Kapitola 48: Čas, přerušení a režimy trasování

Jakmile PROMETHEUS dokáže bezpečně vykonat jednu instrukci, zůstávají tři
otázky:

1. Kolik procesorového času má tato instrukce přidat k počitadlu?
2. Jaký stav přerušení má uživatelský program vidět?
3. Jak lze jeden krok pomalu nebo rychle opakovat, aniž by monitor ztratil
   kontrolu nad klávesnicí a obrazovkou?

Tyto otázky spolu souvisejí těsněji, než se zpočátku zdá. Dva zachycovací výstupy
nenesou pouze dvě možné hodnoty PC, ale také dvě možná časování. Scratch program
začíná uloženým stavem DI nebo EI. Krokovací rutina vrací výsledek klávesové
kombinace, podle něhož automatické trasování pozná, zda má znovu vykreslit čelní
panel.

PROMETHEUS tak z jednoho pečlivě řízeného kroku vytváří několik uživatelsky
viditelných režimů vykonávání.

## Co je T-stav?

Instrukce Z80 netrvá abstraktní „jeden krok“. Spotřebuje určitý počet hodinových
period nazývaných **T-stavy**.

Jednoduché instrukce mohou mít jednu pevnou cenu:

```text
NOP       4 T-stavy
INC B     4 T-stavy
LD A,n    7 T-stavů
```

Podmíněné a opakované instrukce mohou mít více než jednu cenu:

```text
JR NZ,d   jedna cena, není-li skok proveden,
          o pět T-stavů více, je-li proveden

LDIR      opakuje se podle BC
```

PROMETHEUS udržuje šestnáctibitové akumulované počitadlo v
`accumulatedTStates`. Čelní panel je může zobrazovat a editovat stejně jako jiná
uložená slova.

Počitadlo není nástěnnými hodinami. Je modelem sestaveným z metadat instrukcí a
několika úprav specifických pro zvolenou cestu.

## Časování začíná v tabulce instrukcí

Sdílená tabulka instrukcí používaná assemblerem a disassemblerem nese také malé
pole časování. Při dekódování se spodních pět bitů časování zkopíruje do
samomodifikovaného přístupového operandu:

```asm
varcDecodedInstructionTStates:
    ld de,00004h
```

Horní bajt se vynuluje, takže běžné časování začíná jako šestnáctibitová hodnota:

```text
DE = základní časování
```

U instrukce s jedinou cestou tato hodnota dorazí k sekvenčnímu zachycení a později
se přičte ke kumulativnímu počitadlu.

Toto opětovné použití je důležité. PROMETHEUS neudržuje vedle dekodéru instrukcí
samostatnou databázi časování. Identita instrukce zjištěná dekodérem dodává
základní hodnotu používanou při trasování.

## Dva výstupy mohou nést dvě časování

Sekvenční zachycovací vstup používá základní časování:

```asm
varcDecodedInstructionTStates:
    ld de,00004h
varcSequentialNextAddress:
    ld hl,00000h
```

Vstup pro provedenou větev používá hodnoty patchované handlerem:

```asm
varcTakenFlowTStates:
    ld de,00000h
varcTakenFlowNextAddress:
    ld hl,00000h
```

Každý zachycovací výstup tedy nese dvojici:

```text
sekvenční výstup -> sekvenční PC, sekvenční čas
provedený výstup -> cílové PC, čas provedené větve
```

Samotná instrukce zvolí výstup. Skutečná podmínka Z80 proto zároveň zvolí
časování, aniž by PROMETHEUS musel samostatně vyhodnocovat flags.

## Úprava časování podmíněných instrukcí

Handlery toku řízení začínají se základním časováním v A. Upravují pouze rodiny,
které potřebují jinou cenu pro provedenou větev.

U relativních větvení ukázala kapitola 46 přesnou úpravu:

```asm
add a,005h
```

Neprovedená cesta si ponechá základní hodnotu z tabulky. Provedená cesta dostane
o pět T-stavů více.

Handlery CALL a příbuzných absolutních přenosů používají kompaktní úpravy, které
rozlišují provedené a neprovedené chování. Místo další úplné tabulky handler mění
spodní bajty časování, které už dodal dekodér.

Důležitý návrhový princip zní:

```text
tabulka instrukcí ukládá společné/základní časování
handler toku ukládá pouze rozdíl potřebný pro konkrétní cestu
```

Šetří se tím data a dva zachycovací vstupy přesto mohou hlásit různé ceny.

## Časování opakovaných blokových instrukcí

`LDIR` a `LDDR` jsou zvláštní, protože jejich doba závisí na uložené hodnotě BC.
Cesta validace paměti vypočítá:

```text
21 * BC - 5
```

a před vykonáním zapíše výsledek zpět do `varcDecodedInstructionTStates`.

Opakovaná instrukce se potom spustí jako jediná skutečná operace Z80. Počitadlo
obdrží modelovanou cenu celého opakování, nikoli jedné iterace.

To je jeden z důvodů, proč predikce paměti a predikce časování sdílejí kód: obě
potřebují stejný počet BC a obě musejí zvlášť rozpoznat opakované ED opcodes.

## Přímé CALL záměrně narušují úplnost časování

V režimu CALL NON se CALL simuluje zachycovacím enginem. Jeho vnější časování se
modeluje a pozdější kroky mohou trasovat instrukce uvnitř volané rutiny jednu po
druhé.

V režimu CALL DEF nebo ALL běží přijatá rutina nativně, dokud se nevrátí do
scratch trampoline. PROMETHEUS její vnitřní instrukce nevidí.

Proto platí:

```text
započítáno:    časování vnějšího CALL/RST zvolené handlerem
nezapočítáno:  tělo přímo vykonané rutiny
```

Počitadlo T-stavů na čelním panelu je tedy při povoleném přímém vykonávání
nespolehlivé jako měření úplné doby programu.

Nejde o náhodné opomenutí. Je to výslovná cena za rychlejší režim.

## Potvrzení času teprve po úspěšném kroku

Po zachycení a kontrole RUN potvrdí řadič krokování současně PC i čas:

```asm
ld (varcMonitorCurrentAddress+1),hl
ld hl,(accumulatedTStates)
add hl,de
ld (accumulatedTStates),hl
```

V DE je časování vybrané konkrétní cestou.

Na pořadí záleží. Run ERROR zjištěný po vykonání zabrání přičtení, přestože už
mohly nastat účinky na registry nebo paměť. Vzniká tak nesrovnalost vysvětlená v
kapitole 47:

```text
vedlejší účinky instrukce mohou existovat
ale
PC a počitadlo T-stavů zůstávají nepotvrzeny
```

Počitadlo je šestnáctibitové. Přirozeně se přetočí z `$FFFF` na `$0000`. Žádné
varování před přetečením ani skrytý širší součet neexistuje.

## Uložený stav přerušení je booleovská hodnota

Monitor ukládá uživatelovu volbu přerušení do jednoho samomodifikovaného bajtu:

```text
0  DI
1  EI
```

`SYMBOL SHIFT+M` ji přepíná:

```asm
monToggleInterruptEnableState:
    ld hl,varcInterruptEnableState+1
    jr .invertLogicAtHLAndRet_
```

Čelní panel čte tentýž bajt a zobrazuje DI nebo EI. Krokovací engine jej čte při
zahájení scratch programu.

Jediná stavová hodnota tak propojuje:

- uživatelský příkaz;
- zobrazení na panelu;
- bezpečnostní kontrolu HALT;
- generovanou vykonávací trampoline.

## Převod booleovské hodnoty na skutečný opcode

`beginExecutionTrampoline` mapuje 0 nebo 1 na `$F3` nebo `$FB`:

```asm
ld a,(varcInterruptEnableState+1)
add a,a
add a,a
add a,a
add a,0f3h
ld (hl),a
```

Výpočet je:

```text
0 * 8 + $F3 = $F3 = DI
1 * 8 + $F3 = $FB = EI
```

Tento opcode se vykoná bezprostředně před zkopírovanou nebo přepsanou
uživatelovou instrukcí.

Monitor sám musí při změně stacků a serializaci stavu přerušení zakázat. Vyslání
uživatelovy volby na začátku scratch kódu obnoví logický stav v posledním
prakticky možném okamžiku.

## Zpoždění EI patří skutečnému procesoru

Na Z80 se přerušení neaktivují okamžitě přesně ve chvíli načtení EI. Stanou se
přípustnými až po následující instrukci.

Protože PROMETHEUS vyšle skutečné EI následované skutečnou zkopírovanou
instrukcí, zdědí toto hardwarové pravidlo přirozeně:

```text
EI
zkopírovaná uživatelova instrukce
zachycovací skok
```

Stepper nemusí v softwaru vymýšlet flag zpoždění EI. Správnou posloupnost provede
skutečný Z80.

To je další výhoda hybridního návrhu.

## Opětovné zachycení stavu přerušení

Po instrukci používá zachycovací rutina `LD A,I` a `LD A,R`. Tyto instrukce
hlásí informace o stavu přerušení pomocí flagu P/V. PROMETHEUS dočasně zachová
jejich výsledky akumulátoru a flags na scratch stacku, obnoví stack monitoru a
zkombinuje příslušné bity flagů:

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

Výsledek se opět zredukuje na booleovskou hodnotu 0 nebo 1.

Komentáře ve zdroji tento postup popisují jako aproximaci uživatelova stavu
povolení přerušení. Z80 má dva přerušovací klopné obvody a instrukce jako RETN
mají zvláštní obnovovací chování. PROMETHEUS ukládá pouze jednoduchý stav potřebný
pro panel a příští trampoline.

Pro běžné trasování je tato kompaktní reprezentace velmi praktická. Pro přesnou
sémantiku RETN/RETI ponechává nejistotu zaznamenanou v kapitole 46.

## Korekce refresh registru

Registr R procesoru Z80 se posouvá při načítání instrukcí. PROMETHEUS sám i
scratch trampoline vykonají kolem uživatelovy instrukce další opcodes, takže
syrově zachycený R by zahrnoval režii monitoru.

`adjustSavedRefreshRegisterLow7` kompenzuje známá načtení a zachovává bit 7,
jenž se chová jinak než spodní sedmibitové počitadlo.

Korekce probíhá:

- před obnovením uživatelského stavu;
- po jeho zachycení;
- na chybových cestách, kde odmítnutá operace nemá vypadat, jako by posunula R.

Výsledek je stále pečlivě modelovaným pohledem, nikoli kouzelným zastavením
veškeré hardwarové aktivity. Je však mnohem bližší hodnotě, kterou by samotná
uživatelova instrukce vytvořila.

## Jeden krok jako příkaz monitoru

`SYMBOL SHIFT+Z` vykoná jednu instrukci na současné adrese monitoru. Vstup je
malý:

```asm
stepAtCurrentMonitorAddress:
    ld hl,(varcMonitorCurrentAddress+1)
```

Řízení propadne přímo do `stepInstructionAtHL`, jehož úplný životní cyklus nyní
zahrnuje kapitoly 43–48:

```text
dekóduj
validuj
sestav scratch instrukci
přepiš tok řízení
obnov uživatelský stav
vykonej
zachyť
zkontroluj adresu RUN
oprav logický stack
potvrď PC a T-stavy
vrať stav klávesové kombinace
```

Poslední položka dovoluje, aby stejná rutina poháněla automatické trasování.

## Důmyslné alternativní použití ROM rutiny BREAK

Na konci úspěšného kroku se engine jednoduše nevrátí. Vstoupí do klávesnicové
rutiny ROM Spectra na vnitřním místě:

```asm
testCapsShiftEnter:
    ld a,0bfh
    jp 01f56h
```

Běžná kontrola BREAK v ROM načítá řádek klávesnice obsahující SPACE. Vstup na
`$1F56` toto načtení přeskočí. PROMETHEUS dodá `$BF`, čímž vybere řádek ENTER,
zatímco zbývající kód ROM stále kontroluje CAPS SHIFT.

Vrácený carry flag znamená:

```text
carry clear  CAPS SHIFT+ENTER je držen
carry set    držen není
```

Krokovací rutina proto pomocí běžných flags současně vrací „krok uspěl“ i „co
má uživatel právě v úmyslu udělat se zobrazením trasování?“

## Pomalé trasování

Příkaz `T` opakovaně krokuje a za normálních okolností překresluje panel:

```asm
monSlowTracing:
    call stepAtCurrentMonitorAddress
    call c,redrawFrontPanelAtCurrentAddress
    call ROM_BreakKey
    jr c,monSlowTracing
```

Protože carry je nastaveno, když CAPS SHIFT+ENTER *není* držen:

```text
běžný provoz:
    překresli po každé instrukci

držení CAPS SHIFT+ENTER:
    potlač překreslování a běž rychleji
```

Po každém kroku hledá běžný test BREAK v ROM kombinaci CAPS SHIFT+SPACE. Není-li
BREAK stisknut, smyčka pokračuje.

Když se trasování zastaví, `waitForAllKeysReleased` čeká, dokud nebude matice
klávesnice čistá. Bez toho by se zastavovací kombinace mohla okamžitě stát novým
příkazem monitoru.

Pomalé trasování je tedy opakovaný single-step s volitelným omezením
překreslování. Nemá samostatný vykonávací engine.

## Rychlé trasování k adrese

`SYMBOL SHIFT+T` si vyžádá `Last` a opakuje stejnou jednokrokovou rutinu:

```asm
monFastTracingToAddress:
    call promptForMonitorValue
    defb 0xc3
    ld (varcFastTraceStopAddress+1),hl
.fastTraceNextInstruction:
    call stepAtCurrentMonitorAddress
    call nc,redrawFrontPanelAtCurrentAddress
```

Zde je pravidlo zobrazení obrácené:

```text
běžný provoz:
    nepřekresluj

držení CAPS SHIFT+ENTER:
    po současném kroku překresli
```

Rychlé trasování má rychle překonat mnoho instrukcí a panel ukázat pouze na
vyžádání.

Po každém kroku porovná nově potvrzenou současnou adresu s `Last`:

```asm
ld hl,(varcMonitorCurrentAddress+1)
varcFastTraceStopAddress:
    ld de,00000h
or a
sbc hl,de
ret z
```

Porovnání nastává až po kroku. Proto:

- `Last` je podmínkou zastavení nad výsledným PC;
- rovná-li se počáteční PC hodnotě `Last`, jedna instrukce se přesto vykoná;
- trasování se zastaví poté, co instrukce dorazí na `Last`, nikoli ve všech
  možných výkladech před vykonáním instrukce, která na této adrese leží.

Mezi kroky se také kontroluje BREAK.

## Pomalé a rychlé trasování jsou politiky zobrazení

Oběma režimům lze porozumět bez představy dvou trasovacích enginů:

```text
pomalé trasování:
    krok
    obvykle překresli
    BREAK?
    repeat

rychlé trasování:
    krok
    obvykle nepřekresluj
    výsledné PC == Last?
    BREAK?
    repeat
```

Oba dědí veškeré chování jednoho kroku:

- dekódování instrukce;
- ochranu READ/WRITE/RUN;
- režimy CALL;
- odmítnutí HALT při DI;
- přepis toku řízení;
- zachycení stavu přerušení;
- akumulaci T-stavů;
- všechny původní okrajové případy.

Toto opětovné použití zmenšuje kód a udržuje režimy konzistentní.

## Kontroly instrukcí během trasování

Přepínač READ/WRITE/RUN je globální pro celý krokovací engine. Pomalé trasování,
rychlé trasování i ruční single-step čtou tentýž invertovaný bajt.

Při zapnutých kontrolách:

```text
READ a WRITE se předpovědí před vykonáním
RUN se zkontroluje po zachycení
HALT při DI se odmítne
```

Při vypnutých kontrolách:

```text
tabulky READ, WRITE a RUN se přeskočí
HALT při DI se stále odmítne
```

Vypnutí kontrol může experimentování usnadnit, ale zároveň dovolí trasovanému
kódu poškodit monitor nebo vstoupit do libovolných oblastí. Tyto kontroly
instrukcí přestanou prosazovat i dynamický skrytý rezidentní rozsah.

## Režim přímého CALL během trasování

Nastavení NON/DEF/ALL je rovněž společné všem režimům kroku a trasování.

Při pomalém trasování může přímý podprogram způsobit, že zdánlivý krok bude dlouho
čekat, než se panel překreslí. Při rychlém trasování může proběhnout libovolně
velké tělo bez jediného mezilehlého zastavení. V obou případech jeho vnitřní
instrukce:

- nelze přerušit kontrolou BREAK prováděnou monitorem po jednotlivých krocích;
- nepřispívají k součtu T-stavů;
- nenarážejí na ochranná okna trasování.

Zobrazení režimu proto není kosmetické. Mění hranici dohledu.

## Úplný příklad časování

Uvažujme tuto smyčku:

```asm
LOOP:   DEC B
        JR NZ,LOOP
```

Předpokládejme, že B začíná hodnotou 3.

Skutečný Z80 vykoná a PROMETHEUS zaznamená:

```text
DEC B        pevné časování z tabulky
JR NZ skok   základní časování JR + 5
DEC B        pevné časování z tabulky
JR NZ skok   základní časování JR + 5
DEC B        pevné časování z tabulky
JR NZ bez    základní časování JR
```

Podmínku nikdy nevyhodnocuje kód monitoru. Každé zkopírované JR zvolí fyzický
výstup podle skutečného flagu Z. Tento výstup dodá odpovídající čas.

Současně logické PC střídá:

```text
adresu za DEC
cíl LOOP po provedeném JR
adresu za posledním JR, když skok není proveden
```

PC a časování jsou dva paralelní výsledky téže zachycené cesty.

## Kde je model přesný — a kde není

V rámci zamýšleného návrhu modeluje PROMETHEUS mnoho časování elegantně:

- pevné časování instrukce ze sdílené tabulky;
- rozdíl provedené větve relativního skoku;
- rozdíly podmíněných absolutních přenosů;
- úplné časování LDIR/LDDR;
- volbu sekvenční nebo provedené cesty pomocí skutečných hardwarových flags.

Počitadlo však nemusí v každé situaci odpovídat uplynulému strojovému času:

- těla přímo vykonaných CALL/RST se vynechávají;
- aktivita přerušení není zachycena jako úplná časová osa událostí;
- režie monitoru a zobrazování se záměrně nepočítá;
- Run Error po vykonání potlačí potvrzení časování až po vedlejších účincích;
- nejistá sémantika RETN/RETI zůstává nejistá;
- šestnáctibitový součet se přetáčí.

Počitadlo je nejlepší chápat jako **T-stavy trasovaných uživatelských instrukcí
podle vykonávacího modelu PROMETHEA**.

## Zpět k celému stroji

Tři vykonávací režimy nyní můžeme popsat jediným jádrem:

```text
ruční krok
    jedno call stepInstructionAtHL

pomalé trasování
    repeat stejné call
    překresli, není-li držen CAPS SHIFT+ENTER

rychlé trasování
    repeat stejné call
    nepřekresluj, není-li držen CAPS SHIFT+ENTER
    zastav, když se výsledné PC rovná Last
```

Uvnitř každého kroku:

```text
základní časování pochází z metadat dekodéru
handler toku vybere případnou úpravu provedené větve
validátor blokového přesunu může časování zcela nahradit
scratch začíná uloženým DI/EI
zachycení rekonstruuje uložený stav
kontrola RUN rozhodne, zda se PC a časování potvrdí
```

Příští kapitola bude sledovat jeden úplný single-step od dekódování prvního bajtu
až po konečný stav připravený pro panel a znovu propojí všechny mechanismy části
VI.

## Co se změnilo v paměti

Úspěšně trasovaná instrukce může změnit:

- úplný uložený obraz procesoru;
- uloženou booleovskou hodnotu přerušení;
- opravenou uloženou hodnotu R;
- logickou současnou adresu;
- šestnáctibitový akumulovaný počet T-stavů;
- uživatelskou paměť a uživatelský stack podle skutečné instrukce;
- scratch workspace a samomodifikované operandy toku a časování.

Pomalé a rychlé trasování navíc patchuje nebo čte:

- cílovou adresu rychlého trasování;
- bajt kontrol instrukcí;
- opcode režimu přímého CALL;
- stav klávesové kombinace řídící zobrazení.

## Důležité labely, s nimiž jsme se setkali

- `varcDecodedInstructionTStates`
- `varcTakenFlowTStates`
- `accumulatedTStates`
- `varcInterruptEnableState`
- `beginExecutionTrampoline`
- `adjustSavedRefreshRegisterLow7`
- `interruptStateCaptureScratch`
- `testCapsShiftEnter`
- `stepAtCurrentMonitorAddress`
- `stepInstructionAtHL`
- `monSlowTracing`
- `monFastTracingToAddress`
- `varcFastTraceStopAddress`
- `monToggleInterruptEnableState`
- `monToggleInstructionControls`
- `monCycleDirectCallMode`
- `waitForAllKeysReleased`

## Myšlenky potřebné v dalších kapitolách

- Tabulka instrukcí dodává základní časování; handlery ukládají pouze rozdíly.
- Sekvenční a provedený výstup nesou současně logické PC a časování.
- Uložený stav přerušení je booleovská hodnota převáděná na skutečné opcode
  bajty DI/EI.
- Skutečný Z80 přirozeně poskytuje chování zpoždění EI.
- R se opravuje o známou režii načítání instrukcí monitoru a trampoline.
- Pomalé a rychlé trasování jsou smyčky kolem stejného jednokrokového enginu.
- CAPS SHIFT+ENTER mění politiku překreslování, nikoli sémantiku vykonávání.
- Režimy přímého CALL a chyby RUN zjištěné po vykonání omezují přesnost časování.
