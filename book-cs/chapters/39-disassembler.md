# Kapitola 39: Disassembler

Assembler odpovídá na otázku:

> Které bajty představují tento text instrukce?

Disassembler se ptá opačně:

> Který text instrukce nejlépe vysvětluje tyto bajty?

Druhá otázka je těžší. Zdrojový řádek obsahuje jména a záměry, které strojový
kód už nemusí uchovávat. Některé posloupnosti bajtů jsou neplatné. Data mohou
vypadat jako instrukce. Relativní skoky ukládají vzdálenost, nikoli svůj viditelný
cíl. Instrukce IX a IY přeskupují prefixy, displacementy a opkódy. Číselnou
adresu může být vhodnější vypsat jako symbol.

PROMETHEUS problém řeší opětovným použitím téměř celé jazykové mašinérie,
kterou jsme už prostudovali. Neobsahuje samostatnou obrovskou tiskárnu textů
instrukcí Z80. Bajty dekóduje do **dočasného komprimovaného záznamu zdroje** a
poté požádá běžný expander záznamu zdroje, aby vytvořil konečný řádek o šířce
32 sloupců.

Právě tento návrh je srdcem disassembleru.

## Cesta shora

Pro jednu položku na adrese HL vede cesta takto:

```text
bajty v paměti
    -> klasifikace oblasti DEFB/DEFW
    -> dekodér prefixů a opkódu Z80
    -> hledání ve sdílené tabulce instrukcí
    -> dočasný záznam zdroje
    -> běžná expanze záznamu zdroje
    -> volitelné doplnění symbolu/adresy
    -> 32sloupcový lineBuffer
```

Hlavní rutinou je `disassembleNextLineToBuffer`.

Její kontrakt je jednoduchý:

```text
input:   HL = adresa k dekódování
output:  lineBuffer = jeden tisknutelný řádek ve stylu zdroje
         HL = adresa následující položky
```

Následující položkou může být:

- další bajt po DEFB;
- dva bajty po DEFW;
- sekvenční adresa za platnou instrukcí;
- stejná adresa po vloženém vizuálním oddělovacím řádku.

Poslední možnost začne dávat smysl za chvíli.

## Interaktivní příkaz V

Příkaz V se zeptá na počáteční adresu. SYMBOL SHIFT+4 začne na současné adrese
monitoru. Obě cesty poté vstoupí do `monListDisassembly`:

```asm
monListDisassembly:
    call beginMonitorListOutputWithBlankLine
    call disassembleNextLineToBuffer
    call outputMonitorListLineAndPollContinuation
    jr $-6
```

Jde o jednu z nejčitelnějších vysokoúrovňových smyček ve zdroji:

```text
otevři seznam prázdným řádkem
repeat forever:
    dekóduj jednu položku do lineBuffer
    připoj ji do konfigurovatelného okna seznamu
    zeptej se, zda má výpis pokračovat
```

Interaktivní výpis nemá adresu Last. Jeho délku řídí rytmus uživatelových
stisků kláves.

Tiskárna a cíl obráceného převodu do zdroje budou tématem kapitoly 40. Pro tuto
chvíli je důležité, že volají tentýž dekodér jedné položky.

## Začít čistým řádkem

`disassembleNextLineToBuffer` nejprve připraví řádek tvořený přesně 32 mezerami.
Počáteční adresu položky si také zapamatuje v operandu
`varcDisassemblyInstructionAddress`.

Rutina později potřebuje obě hodnoty:

```text
HL během dekódování       postupuje k následujícím bajtům
uložená počáteční adresa  označuje řádek a počítá cíle relativních skoků
```

Bez uloženého začátku by bylo obtížné převést displacement, například `$FE`,
zpět na viditelnou cílovou adresu.

## Nejprve se zeptat, zda jsou bajty daty

Ještě před rozpoznáváním opkódu rutina nahlédne do dvou tabulek z kapitoly 38:

```asm
    ld hl,defbDisassemblyAreaTable
    call checkAddressAgainstProtectionTable
    jr c,.buildDefbDisassemblyRecord

    ld hl,defwDisassemblyAreaTable
    call checkAddressAgainstProtectionTable
    jr c,.buildDefwDisassemblyRecord
```

Pořadí je významné:

```text
DEFB má přednost před DEFW
DEFW má přednost před dekódováním instrukce
```

Dynamicky vytvořený interval rezidentního obrazu a zdroje se vyskytuje v obou
tabulkách, takže jej nejprve zachytí DEFB. Právě zde PROMETHEUS blokuje
instrukční disassemblování sebe sama.

Bajty neskrývá. Rezidentní bajt lze stále zobrazit a prozkoumat; pouze se vypíše
jako datová direktiva.

## Vytváření záznamů DEFB a DEFW

Pro DEFB rutina přečte jeden bajt a připraví ekvivalent:

```asm
    DEFB value
```

Pro DEFW přečte little-endian slovo a připraví:

```asm
    DEFW value
```

Obě cesty se poté spojí ve stejné expanzi dočasného záznamu, jaká se používá
pro instrukce.

Když běžné dekódování instrukce selže, PROMETHEUS se rovněž vrátí k DEFB pro
první bajt. Tím je zaručen postup libovolnou pamětí:

```text
platná instrukce  spotřebuje svou celou délku
známá oblast DEFW spotřebuje dva bajty
cokoli jiného     spotřebuje jeden bajt jako DEFB
```

Neplatný opkód proto nemůže výpis navždy uvěznit na jediné adrese.

## Záměrně posunutý dočasný záznam

Pracovní oblast enkodéru editoru běžně začíná dočasným bajtem délky, po němž
následují dva trvalé bajty hlavičky záznamu.

Disassembler zatím nepotřebuje záznam vkládat do zdroje. Začne o jeden bajt
dříve a tutéž pracovní oblast použije v posunuté interpretaci:

```text
encodedRecordStorageLength   dočasný opkód/pseudopříkaz
encodedRecordHeader          dočasná metadata prefixu/operandu
encodedRecordInfoByte        dočasný payload operandu/expressionu
```

Když IX ukazuje na `encodedRecordInfoByte`, zápisy do `(IX-2)` a `(IX-1)`
vytvoří dva bajty, které očekává běžný expander.

Nejde o náhodné překrytí. Je to kompaktní adaptér:

```text
výstupní formát disassembleru
        se stává
vstupním formátem expanderu záznamu zdroje
```

Trvalá délka ani značka zpětného odkazu nejsou potřeba, protože dočasný záznam
se nebude procházet uvnitř komprimovaného seznamu zdroje.

## Dekódování prefixů instrukce

Pokud adresa není klasifikována jako data, `decodeInstructionAtHL` prozkoumá
první bajty.

Dekodér rozpoznává tyto rodiny:

```text
běžný opkód
opkód CB
opkód ED
opkód DD
opkód FD
DD CB displacement opkód
FD CB displacement opkód
```

Vytváří stejné bity informací o prefixu, jaké používají komprimované záznamy
zdroje:

```text
bit 7  rodina CB
bit 6  rodina ED
bit 5  rodina DD / IX
bit 4  rodina FD / IY
bits 0..2 třída operandu
```

Tato sdílená reprezentace je jedním z důvodů, proč může tabulka instrukcí
sloužit assembleru i disassembleru.

## Nepříjemné pořadí indexovaného CB

Instrukce jako:

```asm
    BIT 3,(IX+5)
```

používá fyzické bajty v tomto pořadí:

```text
DD CB displacement opkód
```

Displacement leží před konečným operačním bajtem. Většina ostatních forem
umísťuje opkód před jeho operandy.

Dekodér zvláštní formu zpracuje explicitně:

```text
uvidí DD nebo FD
uvidí následující CB
přečte displacement do E
přečte konečný opkód do B
zapamatuje si bity prefixu indexovaného CB
```

V tabulce instrukcí hledá podle konečného opkódu a normalizovaných metadat
prefixu, zatímco displacement si uchová zvlášť pro formátování.

Jde o obrácený obraz opravy druhého průchodu popsané v kapitole 26.

## Opkódy RST se stanou jednou rodinou

Osm opkódů restartu je:

```text
$C7 $CF $D7 $DF $E7 $EF $F7 $FF
```

Jejich cílový vektor je zakódován v bitech 3 až 5 opkódu. Pro hledání v tabulce
PROMETHEUS všechny kanonizuje na `$C7`:

```asm
    ld a,(hl)
    and 0c7h
    cp 0c7h
```

Původní bity vektoru si ponechá a později je vykreslí jako:

```text
0, 8, 16, 24, 32, 40, 48 nebo 56
```

Jediná forma v tabulce instrukcí tak může představovat celou rodinu RST.

## Návratové hodnoty dekodéru

Při platné shodě vrací `decodeInstructionAtHL`:

```text
HL = následující sekvenční adresa
B  = kanonický opkód
C  = bity prefixu zkombinované s třídou operandu
DE = nezpracované bajty immediate, slova nebo displacementu
AF' zero flag = nastaven
```

Při neplatném kódování je alternativní zero flag vynulován. Volající potom
vytvoří DEFB.

Použití alternativního AF pro výsledek úspěchu dovoluje rutině vrátit běžná
registrová data, aniž by přišla o stav během vnořeného hledání v tabulce, které
mění hlavní flags.

Dekodér také ukládá dvě skutečnosti pro budoucí trasovací engine:

- pole T-states ze záznamu tabulky instrukcí;
- nezpracované slovo operandu.

Samotný disassembler časování nepotřebuje, ale jeho jediné dekódování zabrání
opakování stejného hledání v tabulce při analýze single-step.

## Sdílená tabulka instrukcí odpovídá na ústřední otázku

`decodeInstructionTableRecord` přijímá kanonický opkód B a metadata prefixu C.
Prohledává stejnou pětibajtovou tabulku instrukcí, kterou assembler používal k
převodu tříd mnemoniků a operandů na bajty.

V opačném směru z ní získá:

```text
index v tabulce mnemoniků
popisovač prvního operandu
popisovač druhého operandu
třídu operandu
```

DD a FD sdílejí formy tabulky. Malá zapamatovaná varianta pozdější expanzi
sdělí, zda má být viditelným jménem IX, nebo IY.

Tabulka tedy není pouhou emisní tabulkou assembleru. Je kompaktním obousměrným
popisem podporovaného jazyka Z80.

## Osm tříd operandů

Dolní tři bity metadat vybírají jeden z osmi handlerů:

```text
0  žádné bajty operandu
1  jednobajtový immediate
2  dvoubajtové slovo nebo adresa
3  signed relativní skok
4  signed displacement IX/IY
5  signed displacement IX/IY plus immediate bajt
6  vektor RST nesený v opkódu
7  neplatné
```

Kompaktní tabulka offsetů dispatchuje na handler. Stejně jako mnohé tabulky
PROMETHEA ukládá malé relativní offsety kódu, nikoli celé adresy.

Handlery samy netisknou konečnou interpunkci. Připojují kompaktní materiál
operandu/expressionu, který běžný expander zdroje už umí vykreslit.

## Relativní skoky musí obnovit cíl

Relativní instrukce ukládá osmibitový signed displacement od adresy následující
za instrukcí.

Pro dvoubajtový JR nebo DJNZ:

```text
target = instructionAddress + 2 + signed displacement
```

Uvažujme běžící příklad:

```text
adresa        $8002
bajty         $10 $FE
```

`$FE` jako signed hodnota znamená -2:

```text
$8002 + 2 - 2 = $8002
```

Disassembler proto zapíše:

```asm
LOOP    DJNZ LOOP
```

nebo číselný ekvivalent, podle režimu symbolů.

Pouhé vypsání `$FE` by popisovalo kódování, nikoli význam v jazyce assembleru.

## Indexované displacementy si zachovávají znaménko

Při adresování IX/IY je osmibitový displacement rovněž signed. PROMETHEUS jej
převede zpět na viditelný tvar `+n` nebo `-n`:

```text
$05  -> +5
$FB  -> -5
```

Třída operandu 5 navíc nese immediate bajt, například u instrukce pro
indexovanou paměť, která zapisuje literální hodnotu.

Dočasný zdrojový expression se sestavuje v pořadí očekávaném běžným expanderem,
ne nutně ve fyzickém pořadí strojového kódu.

## Ukončení dočasného záznamu

Po sestavení opkódu a materiálu operandů v pracovní oblasti rutina zapíše `$C0`
jako terminální značku proměnného záznamu:

```asm
    ld (ix+000h),0c0h
    ld ix,encodedRecordStorageLength
    call expandSourceRecordToLineBuffer
```

Běžný expander poté vytvoří:

- mnemonik;
- jména registrů;
- čárky a závorky;
- znaménka plus a minus;
- číselné formátování;
- mezery polí zdroje;
- velká nebo malá písmena podle současné politiky editoru.

Právě díky tomuto opětovnému použití vypadá disassemblovaný text jako zdroj
PROMETHEA, nikoli jako samostatný dialekt monitoru.

## Čísla nebo symboly

Zobrazení adres ovlivňují dva ovládací prvky.

Příkaz C přepíná číselné adresy instrukcí na začátku řádků. SYMBOL SHIFT+C
cyklicky mění nahrazování operandů/adres symboly.

Vnitřní režimy symbolů jsou:

```text
1  pouze číselné operandy
2  nahraď přesnou hodnotu labelem
0  přesný label, jinak zkus label+1
```

Cyklus je:

```text
0 -> 2 -> 1 -> 0
```

Číslování nemá uživatel číst přímo. Je zvoleno pro kompaktní větvení kódu.

## Labely na adrese instrukce

Po expanzi zdroje PROMETHEUS zkontroluje, zda se počáteční adresa položky přesně
rovná hodnotě některého symbolu.

Pokud ano, umístí jméno symbolu do devítisloupcového pole labelu. Tento label
přesné adresy se může objevit, i když je tisk číselných adres vypnutý.

Pokud přesný symbol neexistuje, levé adresní pole se vyplní pouze tehdy, když
nastavení C požaduje číselné adresy.

Výsledkem je užitečný výstup například:

```asm
START   LD B,5
LOOP    DJNZ LOOP
        RET
```

namísto čísla před každým řádkem, když už známé labely program přirozeně člení.

## Symboly v operandech

`findSymbolOrdinalByValue` prochází ordinaly symbolů a vrátí první záznam, jehož
uložená hodnota se rovná dekódovanému cíli.

V nejúplnějším režimu PROMETHEUS po neúspěchu přesného hledání vyzkouší
`target - 1`. Shoda se zapíše jako:

```text
SYMBOL+1
```

Toto skromné pravidlo je překvapivě užitečné. Strojový kód často ukazuje jeden
bajt dovnitř označeného objektu nebo na bajt následující po označené instrukci.

Nepokouší se o libovolné offsety jako `SYMBOL+37`. Kompaktní politika je:

```text
přesný symbol
else symbol+1
else číslo
```

Duplicitní hodnoty se vyřeší prvním ordinalem. Hledání maskuje flag bits vektoru,
aby nalezlo záznam symbolu, ale výslovně nevyžaduje, aby symbol byl DEFINED nebo
LOCKED. Důvěřuje uloženým polím hodnot.

## Vizuální oddělovače po nepodmíněných přenosech řízení

Dlouhý disassembly se čte lépe, když jsou základní bloky oddělené. PROMETHEUS
vyžádá jeden prázdný řádek po:

- nepodmíněném JR;
- nepodmíněném JP;
- JP (HL), JP (IX) nebo JP (IY);
- RET.

Nevkládá oddělovače po podmíněných skocích, CALL, RST ani podmíněných návratech.

Mechanismus je samomodifikovaný. Dekodér zapíše nenulový flag do úvodního
immediate bajtu rutiny `disassembleNextLineToBuffer`. Při následujícím volání
rutina:

1. vyplní `lineBuffer` mezerami;
2. vynuluje flag;
3. vrátí se bez posunutí HL.

Další volání dekóduje tutéž následující adresu.

Tedy:

```text
volání instrukce    spotřebuje bajty
volání oddělovače   nespotřebuje žádné bajty
další instrukce     začíná na nezměněném HL
```

Prázdný řádek je stav prezentace, nikoli přízračná položka paměti.

## Neznámé bajty zůstávají čitelné

Z80 má mnoho kombinací prefixů, které jsou nepoužité, nedokumentované nebo
chybějí v tabulce instrukcí podporovaných PROMETHEEM. Paměť navíc obsahuje
libovolná data.

Když hledání selže, disassembler zvolí konzervativní cestu:

```asm
    DEFB byte
```

Je to lepší než hádat. Bajt se zachová přesně a výpis pokračuje o jednu adresu
dál.

Uživatel může později označit větší oblast jako DEFB nebo DEFW, pokud fallback
odhalí, že paměť obsahuje strukturovaná data.

## Jeden dekodér slouží více než textu

Už před kapitolou 40 vidíme, že `decodeInstructionAtHL` má několik zákazníků:

- interaktivní disassembly;
- pohyb o jednu instrukci v adresním prostoru;
- disassembly na tiskárnu;
- obrácené vložení do zdroje;
- krokování instrukcí a časování.

Textový wrapper sestavuje řádek ve stylu zdroje. Spodní dekodér vrací popis
orientovaný na stroj: rodinu opkódu, třídu operandu, nezpracovaná data,
následující PC a časování.

Toto rozdělení je důležité:

```text
decodeInstructionAtHL
    rozumí struktuře strojových bajtů

disassembleNextLineToBuffer
    převádí tuto strukturu na text zdrojového jazyka
```

Pozdější kapitoly o vykonávání mohou znovu použít první rutinu, aniž by
předstíraly, že potřebují vytištěný řádek.

## Sledování běžícího příkladu

Paměť obsahuje:

```text
$8000  06 05
$8002  10 FE
$8004  C9
```

Předpokládejme symboly:

```text
START = $8000
LOOP  = $8002
```

Na `$8000`:

```text
není v oblasti DEFB/DEFW
opkód $06 -> LD B,n
třída operandu 1 -> jeden immediate bajt
immediate = 5
dočasný záznam -> LD B,5
symbol přesné adresy -> START v poli labelu
následující adresa -> $8002
```

Na `$8002`:

```text
opkód $10 -> DJNZ relative
třída operandu 3
$FE -> -2
target = $8002
symbol přesného cíle -> LOOP
symbol přesné adresy řádku -> LOOP
následující adresa -> $8004
```

Na `$8004`:

```text
opkód $C9 -> RET
žádné operandy
vyžádej oddělovač pro následující volání
následující adresa -> $8005
```

Následující volání vydá prázdný řádek a HL zůstane `$8005`. Volání po něm se
pokusí dekódovat paměť na `$8005`.

Konečný viditelný výsledek je stejný program, který jsme původně zadali:

```asm
START   LD B,5
LOOP    DJNZ LOOP
        RET
```

Zpáteční cesta není kouzlo. Jsou to sdílené jazykové tabulky pracující opačným
směrem.

## Co se změnilo v paměti

Pro každou dekódovanou položku:

- `varcDisassemblyInstructionAddress+1` si zapamatuje její počáteční adresu;
- posunutá pracovní oblast enkodéru drží dočasný záznam zdroje;
- `lineBuffer` dostane expandovaný 32sloupcový text;
- `varcDecodedInstructionTStates` dostane základní metadata časování;
- `varcDecodedInstructionOperandWord` dostane nezpracovaná data operandu;
- flag oddělovače může být patchován pro následující volání.

Zkoumané strojové bajty se nemění.

## Důležité labely, se kterými jsme se setkali

- `monListDisassemblyFromGivenAddress`
- `monListDisassembly`
- `disassembleNextLineToBuffer`
- `varcDisassemblyInstructionAddress`
- `decodeInstructionAtHL`
- `decodeInstructionTableRecord`
- `operandClassLengthAdjustments`
- `encodedRecordStorageLength`
- `encodedRecordHeader`
- `encodedRecordInfoByte`
- `expandSourceRecordToLineBuffer`
- `findSymbolOrdinalByValue`
- `varcDisassemblyAddressMode`
- `varcShowNumericDisassemblyAddresses`
- `varcDecodedInstructionTStates`
- `varcDecodedInstructionOperandWord`
- `defbDisassemblyAreaTable`
- `defwDisassemblyAreaTable`

## Myšlenky potřebné později

- Tentýž vytvořený řádek lze poslat na obrazovku, tiskárnu nebo do editoru
  zdroje.
- Obrácené disassemblování je bezpečné a kanonické, protože se vrací přes běžný
  parser zdroje.
- Vedlejší efekty časování a nezpracovaného operandu připravují engine
  single-step.
- Kód řízení instrukcí přidá nad zde popsaný dekodér analýzu efektivních adres a
  toku řízení.
