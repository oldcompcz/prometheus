# Dodatek D: Kompaktní datové formáty

PROMETHEUS šetří paměť tím, že obecné datové struktury nahrazuje malými místními
jazyky. Bajt může být znakem s ukončovací značkou, počtem s flagem, deltou k
blízké rutině nebo deskriptorem instrukce, jehož pole dávají smysl pouze jednomu
konzumentovi.

Následující formáty jsou referenční popisy. Je třeba je číst spolu s kódem, který
je spotřebovává. Podobně vypadající tabulky nemusí používat stejný bias,
signedness ani terminátor.

## D.1 Obecné konvence

### D.1.1 Little-endian slova

Není-li uvedeno jinak, šestnáctibitové slovo je uloženo:

```text
low byte, high byte
```

### D.1.2 High bit jako interpunkce

Bit 7 často označuje poslední znak řetězce nebo slova. Uložený bajt se obvykle
získává pomocí:

```text
character = byte AND $7F
end        = byte has bit 7 set
```

Ne každý bajt s high bit je text. Horní bity používají také command-tokeny,
flags deskriptorů a pole komprimovaného zdroje.

### D.1.3 Biased counts

Několik tabulek ukládá:

```text
stored count = visible count + 1
```

Hranice nula/jedna potom může sloužit jako terminátor nebo zjednodušit
odčítací smyčku. Před odečtením jedničky vždy zkontrolujte konzumenta tabulky.

### D.1.4 Samorelativní offsety

Jednobajtový vektor často ukládá vzdálenost od vlastního bajtu vektoru nebo od
známé báze tabulky k cíli. Tím se vyhne relokaci, protože zdroj i cíl se pohybují
společně.

### D.1.5 Data ve tvaru opcode

Některé tabulky jsou zapsány mnemonicami Z80, aby pohodlně emitovaly určité
bajtové hodnoty. Bajty jsou daty, dokud prokázaná cesta toku řízení neukáže, že
se vykonávají.

## D.2 Řetězce ukončené high bitem

### Rozložení

```text
ordinary character bytes
final character with bit 7 set
```

Příklad pro `RUN`:

```asm
    defb "RU",0CEh
```

`$CE & $7F = $4E`, což je `N`.

Ekvivalentní pohled na bajty:

```text
$52 $55 $CE
 R   U   N|end
```

### Prázdné řetězce

Formát může reprezentovat prázdné nebo zvláštní slovo okamžitým bajtem s high
bit nebo samostatným počtem. Nepředpokládejte, že každá tabulka dovoluje prázdný
řetězec.

### Konzumenti

- názvy příkazů editoru;
- slovníky mnemoniců a operandů;
- zprávy a slovník monitoru;
- názvy symbolů;
- inline text instalátoru.

### Porovnávání

Typický comparator maskuje bit 7 pro porovnání znaku a současně si pamatuje, zda
kandidát i slovo tabulky skončily na stejné pozici. Samotný prefix se nesmí
shodovat s delším slovem.

## D.3 Inline řetězce za `CALL`

### Zdrojový tvar

```asm
    call installerPrintInlineString
    defb "Instalation address",":"+080h
nextInstruction:
```

### Runtime rozložení

```text
CALL opcode
16-bit target
first inline character
...
last character | $80
next executable opcode
```

### Decoder

```text
returnAddress = POP()
source = returnAddress
repeat:
    b = *source++
    draw(b & $7F)
until b & $80
JUMP source
```

Rutina se nevrací přes původní návratovou adresu, protože ta ukazuje na data.
Skočí na opravené pokračování.

### Jednobajtová varianta promptu

Prompty monitoru používají stejnou myšlenku návratové adresy, ale spotřebují
přesně jeden token:

```asm
    call promptForMonitorValue
    defb 0C4h
```

Rutina sejme návratovou adresu, přečte token, zvýší ukazatel a vloží opravené
pokračování na stack.

## D.4 Command-tokeny

### Rozsah

Command-tokeny editoru zabírají `$C1-$DA`, odpovídající A–Z:

```text
$C1 A
$C2 B
...
$DA Z
```

### Dispatch

Dispatcher token zdvojnásobí a indexuje word tabulku posunutou o
`commandHandlerTable-($C1*2)`.

```text
handler = word[commandHandlerTable + 2*(token-$C1)]
JUMP handler
```

### Mapa příkazů

```text
$C1 A  ASSEMBLY
$C2 B  BASIC
$C3 C  COPY
$C4 D  DELETE
$C5 E  konec zdroje
$C6 F  FIND
$C7 G  GENS
$C8 H  přepnutí decimal/hex
$C9 I  alias GENS/import
$CA J  alias GENS/import
$CB K  začátek zdroje
$CC L  LOAD
$CD M  MONITOR
$CE N  cesta ROM NEW
$CF O  alias ROM NEW
$D0 P  PRINT
$D1 Q  QUIT
$D2 R  RUN
$D3 S  SAVE
$D4 T  TABLE
$D5 U  U-TOP
$D6 V  VERIFY
$D7 W  přepnutí INSERT/OVERWRITE
$D8 X  CLEAR
$D9 Y  alias CLEAR
$DA Z  REPLACE
```

Vektor textových názvů příkazů je oddělený. Obsahuje historické duplicitní sloty
a aliasy; identita tabulky nedokazuje, že je každý alias dosažitelný každou
vstupní cestou.

### Okamžité akce kláves

Pohyb cursoru, EDIT, změny okrajů bloku a některé přepínače režimu se zpracují
před dispatch tokenizovaných příkazů. Nejsou command-tokeny jen proto, že je
vyvolává písmenová klávesa.

## D.5 Normalizované kódy kláves monitoru

`readKeyCode` vrací obyčejná písmena malými písmeny. Kombinace modifierů a
zvláštní klávesy používají kompaktní kódy zvolené překladačem klávesnice.

Hlavní tabulka vazeb monitoru ukládá čtyřicet dvojic:

```text
handler delta, normalized key code
```

Šest dalších příkazů se testuje přímo před tabulkou.

Kód klávesy není zárukou ASCII Spectra. Je výstupem normalizační pipeline
PROMETHEA. Komentáře vedle tabulky jsou nejbezpečnějšími lidsky čitelnými názvy
kláves.

## D.6 Komprimované zdrojové záznamy

Zásadní oprava zjištěná během rekonstrukce je, že trvalý zdrojový záznam
**nezačíná** obecným bajtem délky. Má dvoubajtovou hlavičku, proměnlivý payload a
koncový/back-link bajt, jehož hodnota podporuje zpětný průchod.

### D.6.1 Hrubé rozložení

```text
+0  opcode or pseudo-opcode / primary record byte
+1  information byte
+2  optional line-label ordinal or variable fields
... compressed operands/expressions/text
last terminal/back-link marker
```

Přesná pole závisí na třídě záznamu.

### D.6.2 Prázdný záznam

```text
$00,$30
```

Dvacet kopií tvoří počáteční obraz zdroje.

### D.6.3 Informační bajt

Důležitý význam horních bitů zahrnuje:

```text
(info & $30) == $30    namespace pseudoinstrukcí
otherwise              záznam strojové instrukce
```

Další bity popisují přítomnost a tvar polí labelu/operandů. Jejich význam se
interpretuje společně s primárním opcode/deskriptorovým bajtem.

### D.6.4 Namespace pseudo-opcodes

```text
$00 prázdný řádek
$01 komentář
$02 ENT
$03 EQU
$04 ORG
$05 PUT
$06 DEFB
$07 DEFM
$08 DEFS
$09 DEFW
```

Pseudo-opcode je kód zdrojového záznamu, nikoli opcode Z80.

### D.6.5 Záznamy strojových instrukcí

Strojový záznam ukládá dost kompaktních metadat pro obnovu:

- zvoleného tvaru z tabulky instrukcí;
- třídy prefix/opcode;
- volitelného labelu řádku;
- operandových expressionů nebo pevných operandů;
- index displacementu a immediate polí, jsou-li přítomna.

Neukládá původní mezery ani velikost písmen. Expanze vytváří kanonický zdrojový
řádek.

### D.6.6 Koncový/back-link marker

Poslední bajt dovoluje zpětnému walkeru najít předchozí záznam v konstantním
čase. Dopředný průchod interpretuje pole současného záznamu a najde jeho konec;
zpětný průchod používá marker bezprostředně před současným záznamem.

Proto musí mutace záznamu přesně dokončit tail marker. Poškozený marker může při
pohybu vzhůru ve zdroji skočit doprostřed jiného záznamu.

### D.6.7 Labely řádků jako ordinaly

Komprimovaný zdroj odkazuje na symboly ordinalem od jedničky místo opakování
textu symbolu. Vektor symbolů přeloží ordinal na současný záznam. TABLE C může
symboly zkomprimovat a přepsat všechny dotčené ordinaly ve zdroji.

### D.6.8 Expressiony

Expressiony jsou ukládány jako kompaktní sekvence atomů a operátorů. Atomy mohou
reprezentovat:

- doslovné číselné hodnoty;
- současnou adresu `$`;
- odkazy ordinalem symbolu;
- quoted bajtové hodnoty.

Evaluator pracuje zleva doprava, nikoli jako velký parser precedence. Zakódovaný
tvar interpretuje specializovaný evaluator během sestavení a expanze zdroje.

### D.6.9 Konceptuální příklad

Zdroj:

```asm
LOOP:   LD A,COUNT+1
```

Konceptuální záznam:

```text
deskriptor strojového tvaru `LD A,n`
informační bity: přítomen label, přítomen expression operand
ordinal(LOOP)
expression atom ordinal(COUNT)
operator +
literal 1
terminal/back-link marker
```

Přesné bajty závisí na indexech tabulek a ordinale symbolů, proto kniha pro tento
ilustrativní řádek nevymýšlí pevnou bajtovou sekvenci.

## D.7 Dočasný editovatelný vstupní řádek

Vstupní buffer není trvalým zdrojovým záznamem.

### Reprezentace

```text
characters and compact tokens
one movable cursor marker `$01`
terminator/high-bit state appropriate to renderer/parser
```

Cursor je in-band: pohyb cursoru znamená přesouvání markeru `$01` bufferem.
Renderer zaznamená adresu markeru do samomodifikovaného operandu a na jeho místě
nakreslí glyph stavu CAPS.

### Ochranný bajt před bufferem

`inputBufferGuardByte` leží bezprostředně před bufferem, protože některé čtečky
před načtením nejprve zvýší ukazatel. Podobné guard bajty existují před dalšími
buffery řádku/operandů.

## D.8 Tabulka symbolů

### D.8.1 Nejvyšší rozložení

```text
word count
word vector[count]
variable-length symbol records sorted by name
```

### D.8.2 Ordinaly

Ordinaly jsou jedničkové:

```text
ordinal 1 -> vector entry 1
ordinal 2 -> vector entry 2
...
```

Slovo počtu není ordinal nula.

### D.8.3 Položky vektoru

Každé slovo je kompaktní reprezentací ukazatele/offsetu interpretovanou relativně
k pohyblivé bázi tabulky symbolů. Vektor umožňuje, aby ordinaly ve zdroji
zůstávaly stabilní, zatímco se záznamy symbolů vkládají abecedně.

Když se oblast zdroje pohne, `varcSymbolTablePt` se pohne s ní. Vnitřní vztahy
vektoru zůstávají smysluplné, protože mover a logika vkládání opraví potřebné
offsety.

### D.8.4 Záznam symbolu

Záznam obsahuje:

```text
flags
16-bit value
high-bit-terminated name
```

Přesné umístění flags/hodnoty spotřebovávají rutiny lookupu, zobrazení a
definice. Důležité sémantické flags jsou:

```text
DEFINED  value is currently valid for assembly
LOCKED   preserve across definition reset / separate compilation
mark bit transiently used by TABLE C
```

### D.8.5 Seřazené záznamy versus ordinal vector

Současně existují dvě pořadí přístupu:

```text
source reference -> ordinal vector -> record
name lookup       -> alphabetically sorted record scan
```

Proto vložení symbolu aktualizuje offsety vektoru a smazání záznamu je víc než
uzavření jediné bajtové mezery.

## D.9 Syntaxe textového expressionu a zakódovaný formát expressionu

### D.9.1 Textové atomy přijímané evaluatorem monitoru/editoru

```text
desetinné číslice    1234
hexadecimální         #1F nebo právě nakonfigurovaná syntaxe
binární               %1010
quoted bajt           atom typu "A" podle historických pravidel parseru
současná adresa       $
název symbolu         LABEL
```

### D.9.2 Operátory

Kompaktní evaluator podporuje aritmetickou/operatorovou sadu zdroje, včetně:

```text
+  -  *  /  ?
```

Vyhodnocování je záměrně malé a převážně zleva doprava. Nejde o moderní gramatiku
expressionů s úplným stromem precedence.

### D.9.3 Zakódované atomy

Trvalé záznamy nahrazují textové názvy symbolů ordinal tagy a doslovné hodnoty
kódují kompaktními tvary. Zakódovaný evaluator sdílí aritmetické primitivy s
textovým evaluatorem, ale čte proud záznamu místo editačního bufferu.

### D.9.4 Historická asymetrie uvozovek

Parser má cestu neprůhledného kopírování spuštěnou podmínkou podobnou apostrofu,
ale v příslušné rutině je potvrzeným uzavíracím delimiterem dvojitá uvozovka.
Tato zvláštnost je zachována a bez testů by se neměla zobecňovat na čisté
moderní pravidlo quoting.

## D.10 Slovníky mnemoniců

PROMETHEUS neukládá jedno konvenční pole C řetězců.

### D.10.1 Buckets podle délky

Lookup mnemonicu nejprve zvolí bucket podle délky slova. Kompaktní položka bucketu
určuje počet slov a místo, kde začínají jejich spellingy ukončené high bitem.

Tím se omezí porovnávání, protože `LD` se nikdy neporovnává s `EXX` nebo `OTDR`,
pokud se jejich délky liší.

### D.10.2 Kódování slova

Uvnitř bucketu:

```text
letters, final letter|$80
letters, final letter|$80
...
```

Pozice nalezeného mnemonic se stává částí klíče tvaru instrukce.

### D.10.3 Zachování duplicit/aliasů

Zdánlivě duplicitní slova nebo odkazy mohou zabírat odlišné sloty, protože číslo
slotu, nikoli pouze spelling, se účastní jiné tabulky. Neslučujte je bez
sledování všech konzumentů.

## D.11 Slovníky operandů

Spellingy operandů jsou také ukončeny high bitem a seskupeny do kompaktních
tabulek. Příklady zahrnují registry, podmínky a pevné tvary v závorkách:

```text
a
bc
(hl)
(ix
(iy
```

Některé položky jsou prefixy, nikoli úplné uživatelsky viditelné operandy,
protože parser zpracovává následující displacement nebo uzavírací interpunkci
samostatně.

Zdroj definuje `operandsTable00` až `operandsTable42`. Prázdně vypadající položky
a opakovaná počáteční písmena jsou součástí lookup/index schématu.

## D.12 Vektor názvů operací

`operationLabels` je samorelativní bajtový vektor. Každá položka obsahuje:

```text
address(operationLabelX) - address(thisVectorByte)
```

Cílem je jeden z názvů příkazů ukončených high bitem.

Historické aliasy zůstávají oddělenými sloty:

- DELETE se objevuje vícekrát;
- GENS zabírá několik tokenových slotů;
- NEW a CLEAR mají duplicitní tokenové položky.

Vektor se používá k rozpoznání textových příkazů a spojení názvu s abecedním
namespace tokenů.

## D.13 Deskriptory instrukcí

Vložený `instructionTable.asm` obsahuje 687 záznamů pevné délky. Jeden záznam
reprezentuje jeden přijímaný tvar instrukce Z80, nikoli pouze jeden mnemonic.

### D.13.1 Konceptuální pole

Záznam poskytuje kompaktní informace několika konzumentům:

```text
mnemonic index
operand-form indexes/classes
prefix/opcode bytes or derivation fields
instruction length
second-pass emission class
disassembly operand handler class
control-flow and timing bits
```

Přesné rozdělení bitů se záměrně spotřebovává přes masky a pomocné tabulky, místo
aby bylo rozbaleno do velké struktury podobné C.

### D.13.2 Sdílení konzumenti

Stejný deskriptor podporuje:

- přesné rozpoznání tvaru parserem zdroje;
- počítání délky v prvním průchodu;
- emitování prefix/opcode/operandů ve druhém průchodu;
- disassembly monitoru;
- navigaci podle délky instrukce;
- základní počet T-stavů;
- podporu klasifikace toku řízení.

Toto sdílení je jednou z největších paměťových úspor PROMETHEA.

### D.13.3 Indexované CB tvary

Tvary DDCB/FDCB vyžadují netriviální pořadí emitování:

```text
DD/FD, CB, displacement, opcode
```

Kompaktní deskriptor a třída druhého průchodu spolupracují na opravě tohoto
pořadí, přestože běžné emitování prefix/opcode by bajty umístilo jinak.

### D.13.4 Složení operandu RST

Třída RST ověří malý vektor a složí jej do bitů opcode místo emitování
samostatného operandového bajtu.

### D.13.5 Pole časování

Dolní timing bits dávají základní počet T-stavů. Handlery vykonávání jej upravují
pro taken větve a opakované blokové instrukce.

## D.14 Vektor handlerů operandů disassembly

`disassemblyOperandHandlerOffsets` ukládá kompaktní offsety k rendererům
operandů. Decoder zvolí třídu z deskriptoru instrukce a provede dispatch přes
offset.

Handlery pokrývají tvary jako:

- žádné operandové bajty;
- immediate byte;
- little-endian word;
- relativní cíl;
- displacement IX/IY;
- displacement plus immediate;
- vektor RST;
- pevný text registru/podmínky.

Vektor je samorelativní, a proto nepotřebuje runtime relokaci.

## D.15 Deskriptory čelního panelu

Existuje třicet čtyři záznamů po sedmi bajtech.

### Rozložení

```text
+0..+1  bitmap destination or special-area address
+2      heading/name representation
+3      source class and current display format
+4      byte size and supported-format capability mask
+5..+6  source/destination address or accessor data
```

### Bajt +2: název

Jednopísmenné názvy lze uložit přímo s nastaveným bitem 7. Delší názvy odkazují
do tabulek operandů/názvů.

### Bajt +3: zdroj/formát

Tento bajt kombinuje místo, odkud zobrazená hodnota pochází, se způsobem jejího
vykreslení. Editor čelního panelu cyklí podporované formáty podle capability dat.

### Bajt +4: velikost/capabilities

Dolní bity popisují šířku hodnoty nebo chování zvláštní oblasti. Další bity
určují, které číselné, hexadecimální, znakové nebo podmínkové formáty jsou
povoleny.

### Bajty +5/+6

U skalárních položek označují uloženou hodnotu. Editor registrů znovu používá
stejnou adresu pro uložení nové jednobajtové nebo little-endian dvoubajtové
hodnoty. Zvláštní položky interpretují slovo jako accessor/ukazatel tabulky.

### Zvláštní oblasti

Položky seznamu, disassembly a flags používají specializované renderery místo
obyčejného skalárního fetch. Jejich deskriptory přesto zapadají do stejného
sedmibajtového vnějšího tvaru.

## D.16 Data přepínání formátu čelního panelu

Editor panelu používá kompaktní capability masky. Některé bajty `$FF` jsou
emitovány mnemonicami `RST $38`. Znamenají „všechny příslušné přepínače
povoleny“, nikoli vykonatelná volání.

Tabulka přepínání formátu proto může bez znalosti svého konzumenta vypadat jako
smíšený kód.

## D.17 Tabulky ochranných oken

### Vnější rozložení

```text
byte biasedCount
repeated visible entries:
    word first
    word last
spare tail words
```

Uložený počet je o jedna větší než viditelný počet rozsahů.

### Sémantika rozsahu

Koncové body jsou inkluzivní. Checker jediné adresy uspěje, když:

```text
first <= address <= last
```

Checker rozsahu testuje překryv inkluzivního rozsahu operace s každým chráněným
oknem.

### Dynamické rezidentní okno

Současná oblast PROMETHEA se syntetizuje odděleně z nainstalovaného začátku a
pohyblivého `varcCodeEndPt`. Není prostě jedním neměnným řádkem uživatelské
tabulky.

### Rodiny tabulek

- oblasti chráněné pro READ;
- oblasti chráněné pro WRITE;
- oblasti chráněné pro RUN;
- oblasti DEFB disassembly;
- oblasti DEFW disassembly.

Formát je sdílený, ale ne všechny příkazové cesty konzultují každou rodinu.

## D.18 Tabulka deskriptorů toku řízení

Execution engine řízeného vykonávání klasifikuje instrukce, které nelze prostě
zkopírovat do scratch RAM.

Kompaktní řádek kombinuje maskované rozpoznání opcode/prefix s handlerem nebo
třídou pro:

- podmíněné/nepodmíněné relativní skoky;
- absolutní CALL a JP;
- RET;
- RST;
- nepřímé JP přes HL/IX/IY;
- RETN/RETI.

Deskriptor může zahrnovat úpravy časování a volbu callbacku. Přesná sémantika
pochází z dispatcheru a handleru; samotná shodná bajtová sekvence plně
nepopisuje taken/not-taken chování.

## D.19 Tabulky deskriptorů přístupu do paměti

Predikční tabulky READ a WRITE používají řádky:

```text
opcodeMask
expectedOpcode
accessDescriptor
```

Řádek se shoduje, když:

```text
(decodedOpcode & opcodeMask) == expectedOpcode
and descriptor prefix nibble matches decoded prefix nibble
```

### Dolní bity deskriptoru

```text
0  adresa z BC
1  adresa z DE
2  adresa z HL
3  adresa z IX + signed displacement
4  adresa z IY + signed displacement
5  adresa z SP
6  adresa z SP - 2
7  immediate NN
```

Bit 3 označuje dvoubajtový přístup. Oba bajty se kontrolují nezávisle, včetně
wrapu z `$FFFF` na `$0000`.

Opakované LDIR/LDDR dostává samostatný výpočet úplného rozsahu místo reprezentace
jediným přístupem deskriptoru.

## D.20 Maskované vzory hledání

### Workspace

```text
five × (value, mask)
```

### Porovnání

```text
matchByte = ((memoryByte XOR value) AND mask) == 0
```

### Přesný bajt

```text
value = requested low byte
mask  = $FF
```

### Wildcard

```text
value = don't care
mask  = $00
```

Odpověď dvojtečkou vytvoří wildcard. Algoritmus testuje pět bajtů na každém
kandidátovi, dovoluje přirozený šestnáctibitový wrap při čtení a zastaví se,
když se zalomí samotný začátek kandidáta.

## D.21 Seznam adres direct-CALL

Seznam začíná biased count:

```text
stored count = visible targets + 1
```

Následuje jedenáct slov:

```text
up to ten visible CALL/RST targets
one spare tail word used by compact deletion
```

Hodnoty režimu direct-call jsou jinde reprezentovány vykonatelnými opcodes:

```text
NOP    NON mode
RET Z  DEF mode
RET    ALL mode
```

Opcode slouží současně jako data režimu a gate při vykonání.

## D.22 Navigační stack

Stack navigace po adresách monitoru ukládá:

```text
byte depth
word address[10]
```

Depth je při volbě nově uloženého slotu jedničková. Handlery navigace vlevo/vpravo
nebo nahoru/dolů převádějí kompaktní depth na word offset zdvojením. Nejde o
strojový stack Z80; je to rezidentní datový stack navštívených adres.

## D.23 Reprezentace nastavení instalátoru

Dočasný instalátor nemá konvenční strukturu settings. Hodnoty žijí v
zapisovatelných operandech/opcodes:

```text
text attribute byte
highlight attribute byte
keyboard echo duration immediate
monitor yes/no byte
case-mode byte and executable case opcode
bold transform opcode
installation-address cursor operand
five ASCII decimal destination digits
```

Po stisku ENTER se zvolené bajty kopírují v pevném pořadí do rezidentu pomocí
generovaného proudu konfiguračních patchů.

## D.24 Proud konfiguračních patchů

### Formát

Přesně čtrnáct signed little-endian slov:

```text
delta 0
...
delta 13
```

### Stav decoderu

```text
patchPointer = resident payload start
settingsSource = installer settings in fixed order
```

### Operace

```text
for each signed delta:
    patchPointer += delta
    *patchPointer = next setting byte
```

### Historické delty

```text
+10702, -1228, +1102, -6724, +1944, +4888, -6896,
   +14, +4423, +2360, -3864, +1234, -2156, -1955
```

Generátor je odvodí z uspořádaných labelů `@config-patch` a odmítne chybějící,
duplicitní nebo mimo rozsah ležící cíle.

### Proč signed

Cíle patchů se navštěvují v sémantickém pořadí zápisu, nikoli ve vzestupném
pořadí adres. Ukazatel se pohybuje dozadu i dopředu.

## D.25 Relokační proud

### Účel

Označit každé little-endian slovo ve zkopírovaném rezidentu, k němuž se musí
přičíst relokační addend.

### Vstupy decoderu

```text
HL -> stream
DE = running target address
BC = relocation addend
```

### Záznamy

```text
$00                 end of stream
$01-$C7             short record: distance, implicit count 1
$C8-$FF, count      run record: distance = prefix-$C8, explicit count
```

Pro každé zvolené slovo:

```text
DE += distance
word[DE] += BC
```

Pro run se stejná vzdálenost aplikuje opakovaně na `count` slov.

### Příklad

```text
$CF,$1D
```

znamená:

```text
distance = $CF-$C8 = 7
count    = $1D = 29
```

Relokovat 29 slov, každé sedm bajtů za předchozím cílem.

### Omezení

Přímo kódovaná individuální vzdálenost se musí vejít do `$01-$C7`. Historický
formát bez rozšíření neumí reprezentovat jednu izolovanou větší mezeru. Hardening
testy v040 takové rozložení odmítnou, místo aby tiše vytvořily chybná data.

### Proudy

```text
monitor stream    571 words
assembler stream  722 words
```

Jsou odděleny, protože assembler-only instalace vynechává prefix monitoru a
používá jiný addend.

### Výslovná výjimka

`relocationExceptionMonitorEntryDescriptorWord` se mezi probe originy mění, ale
jde o deskriptorová data ve tvaru opcode, nikoli ukazatel. `@noreloc` vyloučí
právě toto jedno slovo a generátor výjimku ověří.

## D.26 Formát objevování relokací v moderních nástrojích

Historický program obsahuje pouze kompaktní proud. Rekonstrukční generátor
objevuje cíle sestavením na několika originech a porovnáním slov:

```text
origin 0
origin $0101
origin $1234
origin $4000
(and additional hardening probes)
```

Slovo je relokovatelné, když každá hodnota z nenulového originu odpovídá:

```text
originZeroValue + probeOrigin  modulo 65536
```

Tento moderní multi-origin důkaz je rekonstrukčním metadatem, nikoli původním
runtime formátem. Dodatek G toto rozlišení výslovně zachovává.

## D.27 Formát kazetové hlavičky

Standardní payload hlavičky Spectra má 17 bajtů:

```text
+0       type
+1..+10  filename, space-padded to ten bytes
+11..+12 data length
+13..+14 parameter 1
+15..+16 parameter 2
```

Na kazetě/TAPu mu předchází flag `$00` a následuje XOR checksum.

Pro hlavičku CODE:

```text
type        3
parameter 1 load address
parameter 2 conventional secondary parameter
```

Kanonická hlavička CODE PROMETHEA obsahuje:

```text
name          "prometheus"
length        18 356
load address  24 000
parameter 2   32 768
```

## D.28 Formát kazetového datového bloku

Standardní datový blok je:

```text
flag `$FF`
payload bytes
XOR checksum
```

Editor SAVE zapíše standardní hlavičku CODE, potom hlavní segment zdroje a
navazující pomocný segment pomocí konvencí markerů ROM. Uložená logická
reprezentace kombinuje:

- rozsah zdrojových záznamů;
- bridge/length stav potřebný loaderem;
- vedlejší data tabulky symbolů.

VERIFY znovu používá přesné rozsahy patchované předchozím SAVE místo parsování
nového názvu nebo rozsahu.

## D.29 Buffer hlavičky příkazu Y monitoru

Y záměrně čte 18 bajtů:

```text
+0       physical tape flag/leader
+1       header type
+2..+11  filename
+12..+13 data length
+14..+15 parameter 1
+16..+17 parameter 2
```

Při platné hlavičce může J načíst bezprostředně následující datový blok s
parametrem 1 jako cílem a délkou hlavičky jako velikostí. Kód nevyžaduje typ
hlavičky 3.

## D.30 Raw forma leaderu SAVE/LOAD monitoru

Monitor S může uložit buď:

- standardní hlavičku CODE plus data, když prompt začíná `:filename`;
- raw blok bez hlavičky, jehož uživatelem dodaný low byte se stane leaderem/flag.

Monitor J přijímá číselný leader/flag. Přestože pozdější stručná reference
navrhuje `:filename`, strojová cesta nemá pro J smysluplnou větev filename.

## D.31 Kontejnerový formát TAP

Soubor `.tap` spojuje záznamy:

```text
word bodyLength
byte flag
bodyLength-2 payload bytes
byte checksum
```

Samotné slovo délky není zahrnuto do XOR. XOR flagu, payloadu a checksumu je
nula.

Template builder rekonstrukce:

1. najde pojmenovanou dvojici hlavička/data CODE PROMETHEA;
2. nahradí binární payload;
3. aktualizuje délku hlavičky;
4. přepočítá dotčené checksums;
5. zachová nesouvisející bloky bajt po bajtu.

## D.32 Data loga instalátoru

Zdroj loga je lineární podle sloupce znaků:

```text
20 columns × 8 row bytes = 160 bytes per band
2 bands = 320 bytes
```

`installerDrawLogoRow` zapisuje osm bajtů a zvyšuje D pro průchod pixelovými
řádky Spectra, obnoví DE a potom zvýší E pro další vodorovný bajt.

Logo je fyzicky rozděleno, protože bootstrapem kopírovaný fragment končí před
zbývajícími 320 bajty spotřebovanými při vstupu instalátoru. Postup HL těmito
bajty přirozeně vede k ukazateli na rezidentní payload.

## D.33 Pevné pracovní buffery a guard bajty

Důležité dočasné oblasti zahrnují:

```text
inputBufferStart          editable line / monitor prompts / tape header
lineBuffer                neutral 32-column output line
firstOperandBuffer        parser operand workspace
second operand/string workspaces
monitorFindByteMaskPairs  five masked bytes
scratch instruction area  generated one-step program
```

Některé čtečky před načtením ukazatel předem zvýší. Rekonstrukce pojmenovává
bajty bezprostředně před buffery jako guards:

- `lineBufferReadGuard`;
- `firstOperandBufferReadGuard`;
- `inputBufferGuardByte`.

Jejich umístění je strukturální, i když se jejich přesná hodnota obvykle
ignoruje.

## D.34 Indexy zpráv

Stavové/chybové zprávy jsou voleny malými čísly:

```text
1  BAD MNEMONIC
2  BAD OPERAND
3  BIG NUMBER
4  SYNTAX HORROR
5  BAD STRING
6  BAD INSTRUCTION
7  MEMORY FULL
8  BAD PUT/ORG
9  UNKNOWN
10 WAIT PLEASE
11 ASSEMBLY COMPLETE
12 START TAPE
13 TAPE ERROR
14 ANY KEY
15 COPYRIGHT
16 SOURCE ERROR
17 FOUND
18 ALREADY DEFINED
19 ENT
```

Indexy jsou konstanty do kompaktních textových dat, nikoli přímé obrazovkové
kódy.

## D.35 Kompaktní textové tokeny monitoru

Monitor sestavuje stavové řádky a prompty z tokenových bajtů místo ukládání
každé úplné věty. `startMonitor` například zapíše čtyři tokeny, které vytvoří
ekvivalent:

```text
UNIVERSUM Control  ON/OFF  Call  NON/DEF/ALL
```

Báze tabulky expanze tokenů je sama patchována při přepnutí mezi slovníkem
editoru a monitoru.

## D.36 Bezpečné čtení kompaktních dat

Pro každou neznámou tabulku:

1. najděte všechny čtečky a zapisovače;
2. určete, zda jsou offsety signed, unsigned nebo biased;
3. zjistěte bázi používanou pro samorelativní hodnoty;
4. stanovte, zda jsou koncové body inkluzivní nebo exkluzivní;
5. ověřte, zda je počet nula legální nebo zakódovaný jako jedna;
6. rozlište trvalá data od dočasného workspace;
7. prohlédněte úpravy assembler-only instalace;
8. neusuzujte na vykonávání jen proto, že se bajty čistě disassemblují;
9. zachovejte duplicity, dokud není vyvrácena jejich indexová role;
10. po každé změně emitovaného rozložení regenerujte relokační/konfigurační
    metadata.

Formáty PROMETHEA jsou malé, protože každý má úzkého disciplinovaného konzumenta.
Matoucí se stávají teprve tehdy, když se s nimi zachází jako s příklady jedné
obecné struktury.
