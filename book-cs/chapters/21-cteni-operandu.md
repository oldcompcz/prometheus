# Kapitola 21: Čtení operandů

Mnemonic jsou krátká jména z konečného slovníku. Operandy jsou méně poslušné.

Operand Z80 může být například:

```text
A                  pevný registr
NZ                 pevná podmínka
1234               číselný výraz
TABLE+2            symbolický výraz
(HL)               pevný nepřímý registr
(32768)            nepřímý výraz
(IX+5)             indexovaný paměťový výraz
(IY-OFFSET)         indexovaný symbolický výraz
```

Assembler musí rozpoznat dost struktury, aby dokázal odpovědět na dvě odlišné otázky:

1. O jaký tvar instrukce by mohlo jít?
2. Kterou část textu je třeba zachovat jako výraz pro pozdější vyhodnocení?

PROMETHEUS operand při zadání řádku zdroje úplně nevyhodnocuje. To by selhalo u dopředných odkazů a zároveň by se zahodil výraz potřebný při dalších sestaveních. Místo toho každému operandu přiřadí kompaktní **třídu**.

Třída popisuje gramatický tvar:

```text
pevný registr nebo podmínka
přímý výraz
výraz v závorkách
displacement IX
displacement IY
žádný operand
```

Text výraz se potom syntakticky zkontroluje a zkomprimuje do záznamu zdroje. Jeho konečná hodnota se vypočítá až při sestavení.

## Nejprve se řádek rozdělí nejvýše na dva operandy

Tokenizer čte první operand po čárku a druhý až do konce řádku:

```asm
    ld de,varLowercasedOperands
    ld c,012h
    call readFirstOperandUntilComma
    jr nz,.parseSecondOperandText
    inc hl
    ld (firstOperandDelimiterByte),a
.parseSecondOperandText:
    ld de,commandArgumentBuffer
    ld c,012h
    call readSecondOperandToEnd
```

Dva dočasné buffery jsou:

```text
varLowercasedOperands   první operand
commandArgumentBuffer   druhý operand
```

Každý je ukončen nulou a omezen na osmnáct bajtů.

Čtečka pole přitom provádí několik užitečných normalizací:

- mezery kolem polí přeskočí volající;
- písmena mimo uvozovky se převedou na malá;
- znaky v uvozovkách si zachovají přesnou velikost písmen;
- čárka mimo uvozovaný text ukončí první operand;
- nula ukončí druhý operand;
- vyčerpání bufferu je chyba, nikoli tiché zkrácení.

Pro řádek:

```asm
LD A,(IX+TABLE-1)
```

si můžeme představit následující obsah bufferů:

```text
first  = "a\0"
second = "(ix+table-1)\0"
```

Viditelné zarovnávací mezery i velikost písmen zmizely. Syntaktická interpunkce zůstala.

## Rychlá strukturální kontrola

Po rozdělení provede `validateParsedOperandBuffers` kompaktní kontrolu hranic kombinovaného normalizovaného tvaru.

Implementace počítá nenulové bajty v pevné oblasti obsahující workspace druhého operandu a jeho strukturální terminátory. Přesná aritmetika je ovlivněna tím, jak oba dočasné buffery sousedí v paměti, účel je však jednoduchý:

```text
odmítni kombinovanou reprezentaci operandů, která je příliš dlouhá
nebo strukturálně nevyhovuje workspace záznamu
```

PROMETHEUS znovu a znovu dává přednost pevnému včasnému odmítnutí před tím, aby dlouhé pole přeteklo do sousedního scratch storage.

## Třídy operandů nejsou hodnoty operandů

Je užitečné držet oddělené tři pojmy.

### Zápis

Skutečné normalizované znaky:

```text
(ix+5)
```

### Třída

Gramatická kategorie používaná při hledání tvaru instrukce:

```text
indexovaný displacement používající IX
```

### Zakódovaný výraz

Trvalá kompaktní reprezentace displacementu:

```text
+ 5
```

Třída se zjistí nyní. Výraz se uloží nyní. Hodnota se vyhodnotí později.

U pevných operandů jako `B` nebo `(HL)` stačí samotná třída; žádný payload výraz není potřeba.

## Klasifikátor začíná délkou

`classifyOperandText` začíná podobně jako rozpoznávač slov:

```asm
classifyOperandText:
    push hl
    call lengthUpToZero
    pop hl
    ld a,b
    or a
    ret z
    cp 005h
    jr nc,.classifyNonRegisterOperand
```

Prázdný řetězec vrátí třídu nula: žádný operand.

Řetězce kratší než pět znaků mohou být pevnými operandy, takže rutina zkusí zabalený slovník operandů popsaný v kapitole 20:

```asm
    push hl
    ld hl,operandLookupByLengthDescriptors
    call prepareLengthBucketLookup
    pop hl
    call compareWithMnemonics
    ret nc
```

Vynulovaný carry znamená, že se našel pevný zápis, a vrácený index už je třídou operandu.

Příklady zahrnují:

```text
A     B     C     HL     SP
NZ    Z     NC    PO     PE
(HL)  (BC)  (DE)  AF'
```

Teprve neúspěšný lookup pevného slova pokračuje ke strukturální klasifikaci výraz.

## Přímé expressiony

Nezačíná-li text otevírací závorkou, klasifikátor vrátí třídu `$2C`:

```asm
.classifyNonRegisterOperand:
    ld a,(hl)
    cp "("
    ld a,02ch
    ret nz
```

Tato třída zhruba znamená:

```text
výraz použitý přímo jako operand
```

Pokrývá mnoho zápisů ve zdroji:

```text
5
32768
LABEL
LABEL+2
$-START
#FF
```

Třída nerozhoduje, zda instrukce potřebuje osmibitovou hodnotu, šestnáctibitovou hodnotu nebo relativní displacement. Tato informace pochází z nalezeného záznamu tabulky instrukcí.

Například všechny následující operandy mohou začít jako přímé expressiony:

```asm
LD B,5          ; immediate byte
LD HL,32768     ; immediate word
JR LOOP         ; relative displacement
RST 8           ; restricted encoded value
```

Po nalezení instrukce zvolený emitter interpretuje výraz požadovaným způsobem a provede příslušnou kontrolu rozsahu.

Toto oddělení udržuje textový klasifikátor malý.

## Expressiony v závorkách

Začíná-li operand znakem `(`, ale není rozpoznaným pevným tvarem jako `(HL)`, PROMETHEUS vrátí třídu `$2D`:

```text
obecný nepřímý výraz
```

Příklady:

```asm
LD A,(32768)
LD HL,(TABLE)
LD (SCREEN+32),A
JP (VECTOR)        ; if a corresponding instruction form exists
```

Záznam zdroje uchovává výraz uvnitř závorek, nikoli pouze jeho okamžitý číselný výsledek.

Otevírací závorka je součástí třídy. `encodeOperandExpression` ji před komprimací výraz přeskočí a zkontroluje správnou uzavírací hranici.

Při pozdější expanzi záznamu descriptor operandu znovu doplní závorky kolem rekonstruovaného výraz.

Interpunkce patřící obecnému syntaktickému tvaru je tedy často reprezentována třídou, místo aby byla ukládána znak po znaku.

## Rozpoznání displacementů IX a IY

Nejzajímavější strukturální cesta začíná, když operand začíná:

```text
(i
```

Klasifikátor zkontroluje další znak:

```asm
    inc hl
    ld a,(hl)
    cp "i"
    jr nz,.returnGenericExpressionOperandClass
    inc hl
    ld a,(hl)
    cp "x"
    ld b,02eh
    jr z,.returnIndexDisplacementOperandClass
    cp "y"
    ld b,02fh
    jr nz,.returnGenericExpressionOperandClass
```

`(IX...)` dostane třídu `$2E` a `(IY...)` třídu `$2F`, ale pouze tehdy, je-li dalším znakem `+` nebo `-`:

```asm
.returnIndexDisplacementOperandClass:
    inc hl
    ld a,(hl)
    cp "+"
    jr z,.returnRegisterOperandClass
    cp "-"
.returnGenericExpressionOperandClass:
    ld a,02dh
    ret nz
.returnRegisterOperandClass:
    ld a,b
    ret
```

Tedy:

```text
(ix+5)       třída indexovaného displacementu
(iy-table)   třída indexovaného displacementu
(ix)         pevný operand, nalezený dříve ve slovníku
(ix*2)       není gramatika indexovaného displacementu; spadne k obecnému tvaru
```

Toto rozlišení je užitečné, protože indexovaná instrukce potřebuje znaménkový jednobajtový displacement emitovaný na určitém místě mezi prefixem a bajty opcodu.

## Proč jsou `(IX)` a `(IX+0)` různé třídy

Tabulka pevných operandů obsahuje `(IX)` a `(IY)`. Používají je tvary jako:

```asm
JP (IX)
JP (IY)
```

Indexovaný odkaz do paměti jako:

```asm
LD A,(IX+0)
```

není jen jiným zápisem téhož operandu. Strojové kódování obsahuje bajt displacementu, i když je tento bajt nulový.

PROMETHEUS proto rozlišuje:

```text
(IX)       pevný nepřímý indexový registr
(IX+expr)  indexovaný paměťový operand s displacementem
```

Strukturální třídy zdrojového jazyka odrážejí skutečné rozdíly v kódování Z80.

## IX a IY sdílejí většinu záznamů tabulky

Z80 obecně používá pro IX a IY tentýž tvar instrukce. Mění se pouze bajt prefixu:

```text
DD  vybírá IX
FD  vybírá IY
```

Duplikovat každý záznam instrukce IX jeho dvojčetem IY by promarnilo velkou část tabulky. PROMETHEUS normalizuje třídy operandů IY na jejich protějšky IX a zvlášť si zapamatuje, že je třeba použít prefix FD.

Provádí to rutina `normalizeIndexOperandClass`:

```asm
normalizeIndexOperandClass:
    cp 01ah
    jr z,.convertIYClassToIXClass
    cp 01ch
    jr z,.convertIYClassToIXClass
    cp 01eh
    jr z,.convertIYClassToIXClass
    cp 02ah
    jr z,.convertIYClassToIXClass
    cp 02fh
    ret nz
.convertIYClassToIXClass:
    dec a
    push hl
    ld hl,varcUseIYPrefix+1
    ld (hl),001h
    pop hl
    cp a
    ret
```

Párová třída IY je o jedna větší než odpovídající třída IX. Normalizace ji sníží a nastaví `varcUseIYPrefix`.

Koncepčně:

```text
vstupní třída:   varianta IY
hledaná třída:   odpovídající varianta IX
vedlejší příznak: použij FD místo DD
```

To se provede nezávisle pro oba operandy, protože různé tvary Z80 mohou uvádět indexový registr na různých pozicích.

Po nalezení odpovídajícího záznamu instrukce se metadata hlavičky zdroje přepnou ze společné rodiny DD na FD, je-li příznak nastaven:

```asm
varcUseIYPrefix:
    ld a,000h
    or a
    jr z,.initializeEncodedRecordHeader
    res 5,d
    set 4,d
```

Jedna tabulka instrukcí tak může popsat obě rodiny, zatímco trvalý záznam zdroje stále pamatuje uživatelovu volbu IX/IY.

## Zvláštní malé číselné operandy

Některé instrukce Z80 mají operandy, které vypadají jako obyčejná čísla, ale patří do velmi malé pevné domény.

PROMETHEUS s několika z nich zachází zvláštním způsobem již při zadání zdroje.

### Režim přerušení

U `IM` se jednoznakový operand kontroluje proti povolenému kompaktnímu rozsahu.

### Čísla bitů

U `BIT`, `RES` a `SET` musí být první operand jedinou číslicí v povoleném rozsahu čísla bitu.

Encoder provede levný test znaku s biasem ještě před obecnou klasifikací:

```asm
    ld a,(hl)
    sub 02fh
    cp 009h
    jp nc,badOperandError
    or a
    jp z,badOperandError
```

Přesné posunuté hodnoty jsou zvoleny tak, aby odpovídaly následnému kompaktnímu klíči tabulky. Důležité je, že číslo bitu se neukládá jako libovolný výraz typu `3+4`. Syntaxe očekává přímo malou číslici.

Tabulka instrukcí tak může zvolený bit zakódovat přímo do metadata opcodu a nesmyslné tvary se odmítnou včas.

## Od tříd k signatuře instrukce

Po klasifikaci obou operandů má encoder hodnoty například:

```text
LD B,5
    mnemonic = LD
    operand1 = pevná třída B
    operand2 = třída přímého výraz

JR NZ,LOOP
    mnemonic = JR
    operand1 = pevná třída podmínky NZ
    operand2 = třída přímého výraz

LD A,(IX+3)
    mnemonic = LD
    operand1 = pevná třída A
    operand2 = třída indexovaného displacementu
    prefix   = IX
```

Obě třídy se pomocí posunů zabalí do `D:E`, aby jejich bity odpovídaly pětibajtovému formátu tabulky instrukcí. Vedle nich se zabalí index mnemonic.

Hledání se potom ptá:

> Existuje záznam instrukce Z80 s tímto mnemonic a přesně těmito třídami operandů?

To je přísnější než otázka, zda je každé slovo samo o sobě legální.

## Několik příkladů od začátku až ke třídě

### `LD B,5`

Rozdělení polí:

```text
mnemonic = ld
first    = b
second   = 5
```

Klasifikace:

```text
b → slovník pevných operandů → třída pro B
5 → nezačíná závorkou → přímý výraz $2C
```

Hledání instrukce najde záznam dokumentovaný jako:

```asm
; ld b,N
    defb 0x06,0x01,0x14,0x55,0x87
```

Výraz `5` se zkomprimuje do záznamu zdroje. Ve druhém průchodu se vyhodnotí a emituje jako jeden zkontrolovaný bajt.

### `JR NZ,LOOP`

Rozdělení polí:

```text
mnemonic = jr
first    = nz
second   = loop
```

Klasifikace:

```text
nz   → pevná třída podmínky
loop → přímý výraz $2C
```

Odpovídající záznam říká, že konečnou hodnotou je relativní displacement, nikoli absolutní bajt. Emitter relativního skoku ve druhém průchodu odečte adresu za instrukcí a zkontroluje znaménkový rozsah.

### `LD A,(HL)`

Oba operandy jsou pevnými slovy slovníku:

```text
a    → pevná třída A
(hl) → pevná třída nepřímého HL
```

Není třeba uložit žádné bajty výraz. Trvalý záznam zdroje může být krátkým pevným záznamem obsahujícím pouze své dva bajty metadata.

### `LD A,(TABLE)`

První operand zůstává pevným `A`. Druhý začíná `(`, neuspěje ve slovníku pevných operandů a není syntaxí displacementu IX/IY, takže se stane obecným nepřímým výraz `$2D`.

`TABLE` se do záznamu zkomprimuje jako pořadové číslo symbolu. Druhý průchod vyhodnotí jeho adresu a emituje slovo požadované nalezeným tvarem `LD`.

### `LD A,(IY-OFFSET)`

Druhý operand dostane třídu `$2F`:

```text
indexovaný displacement IY
```

Normalizace změní hledanou třídu na odpovídající IX a nastaví příznak IY. Lookup tabulky použije společný indexovaný záznam. Uložená hlavička zdroje používá metadata rodiny FD a výraz `-OFFSET` zůstane zachován pro pozdější vyhodnocení jako znaménkový displacement.

### `LD BC,DE`

`BC` i `DE` jsou legální pevné operandy a `LD` je legální mnemonic. Přesto žádný pětibajtový záznam instrukce nepopisuje `LD BC,DE`.

Konečný výsledek je:

```text
Bad instruction
```

Tento příklad ukazuje tři úrovně rozpoznání:

```text
slovo existuje
třídy operandů existují
kombinovaný tvar instrukce neexistuje
```

## Kódují se pouze proměnné části

Po nalezení instrukce nepotřebují pevné operandy žádný payload. Jejich identita je již obsažena ve zvoleném metadata instrukce.

Třídy nesoucí výraz se porovnávají s `$2C`:

```asm
    ld a,(varcFirstOperandClass+1)
    cp 02ch
    ld de,varLowercasedOperands
    call nc,encodeOperandExpression
```

Třídy pod `$2C` jsou pevné. Třídy `$2C` a vyšší obsahují materiál výraz, který musí být zkomprimován.

Obsahují-li výraz oba operandy, encoder mezi ně vloží bajt `$1F`:

```asm
    ld (ix+000h),01fh
    inc ix
    inc b
```

Tento oddělovač se v rekonstruovaném textu zdroje neobjeví. Je to vnitřní hranice, která pozdějšímu evaluatoru a expanderu umožní poznat, kde jeden výraz končí a druhý začíná.

PROMETHEUS tedy opět ukládá pouze to, co nelze obnovit ze záznamu instrukce.

## Encoder výraz vidí zjednodušený pohled

Třída operandu říká `encodeOperandExpression`, kolik strukturální interpunkce má přeskočit.

Koncepčně:

```text
přímý výraz:
    kóduj od prvního znaku

(výraz v závorkách):
    přeskoč otevírací závorku
    kóduj vnitřek

(IX+výraz) nebo (IY-výraz):
    přeskoč „(ix“ nebo „(iy“
    začni u znaménka + nebo - displacementu
```

Encoder poté rozpoznává:

- unární znaménka;
- atom aktuální adresy `$`;
- identifikátory nahrazené pořadovými čísly symbolů;
- číselné atomy a atomy v uvozovkách;
- aritmetické operátory;
- uzavírací závorku, čárku nebo konec záznamu.

Kapitola 22 projde tento jazyk expressiony podrobně. Zásadní je zde to, že strukturální klasifikace operandů redukuje několik viditelných tvarů na společný proud výraz.

## Klasifikace je záměrně mělká

`classifyOperandText` se nepokouší dokázat každý sémantický fakt.

Neví, zda se `TABLE+2` vejde do osmi bitů. Nezná adresu `TABLE`. Nepočítá relativní displacement. Dokud není nalezen záznam instrukce, neví, zda se přímý výraz stane immediate bajtem, slovem, číslem portu nebo restart vektorem.

Jeho práce je pouze:

```text
kde je to možné, rozpoznej pevný slovník
jinak urč vnější gramatický tvar
```

Toto rozdělení práce udržuje cestu zadání řádku rychlou a dovoluje dopředné odkazy.

## Kompaktní gramatika

Přijímané vnější tvary můžeme popsat takto:

```text
operand := prázdný
         | fixedOperand
         | výraz
         | '(' výraz ')'
         | '(ix' ('+' | '-') výraz ')'
         | '(iy' ('+' | '-') výraz ')'
```

Některé tvary jako `(IX)` zachytí `fixedOperand` dříve, než se začne zvažovat indexované pravidlo.

Zvláštní rodiny instrukcí přidávají malá omezení:

```text
IM mode
BIT bitNumber,target
RES bitNumber,target
SET bitNumber,target
```

Gramatika není implementována jako obecná tabulka parseru. Je zakódována pořadím testů uvnitř `classifyOperandText` a zvláštními kontrolami kolem něj.

## V prostém pseudokódu

```text
function classifyOperand(text):
    if text je prázdný:
        return NONE

    if length(text) < 5:
        fixed = lookupFixedOperand(text)
        if fixed existuje:
            return fixed.class

    if text nezačíná '(':
        return DIRECT_EXPRESSION

    if text začíná '(ix+' nebo '(ix-':
        return IX_DISPLACEMENT

    if text začíná '(iy+' nebo '(iy-':
        return IY_DISPLACEMENT

    return INDIRECT_EXPRESSION
```

Normalizace:

```text
function normalizeIndexClass(class):
    if class je varianta IY:
        useIYPrefix = true
        return odpovídající třída IX
    return class
```

Úplné rozpoznání tvaru řádku:

```text
mnemonicIndex = lookupMnemonic(mnemonicText)
class1 = classifyOperand(firstOperand)
class2 = classifyOperand(secondOperand)

searchClass1 = normalizeIndexClass(class1)
searchClass2 = normalizeIndexClass(class2)

record = findInstruction(mnemonicIndex, searchClass1, searchClass2)
if record neexistuje:
    error “Bad instruction”

if useIYPrefix:
    převeď zvolené metadata rodiny DD na FD

kóduj expressiony pouze pro třídy DIRECT_EXPRESSION a vyšší
```

## Co se změnilo v paměti

Po klasifikaci operandů a nalezení instrukce:

- normalizované řetězce prvního a druhého operandu zůstávají ve svých dočasných bufferech;
- `varcFirstOperandClass+1` obsahuje první třídu;
- `varcSecondOperandClass+1` obsahuje druhou třídu;
- `varcUseIYPrefix+1` zaznamenává zápis IY, pokud byla nutná normalizace;
- odpovídající pětibajtový záznam instrukce dodal opcode a informační bajty pro dočasný komprimovaný záznam zdroje;
- text pevných operandů lze zahodit;
- text nesoucí výraz se komprimuje do trvalých bajtů payloadu.

Žádná konečná hodnota výraz zatím nebyla potřeba.

## Důležité labely, které jsme potkali

- `readFirstOperandUntilComma`
- `readSecondOperandToEnd`
- `varLowercasedOperands`
- `commandArgumentBuffer`
- `validateParsedOperandBuffers`
- `classifyOperandText`
- `normalizeIndexOperandClass`
- `varcUseIYPrefix`
- `varcFirstOperandClass`
- `varcSecondOperandClass`
- `encodeOperandExpression`
- `firstOperandDelimiterByte`

## Zpět k celkovému obrazu

Pipeline assembleru z kapitoly 19 můžeme nyní rozšířit:

```text
text zdroje zadaný uživatelem
    ↓
mnemonic rozpoznaný zabaleným slovníkem
    ↓
operandy klasifikované pevným slovníkem a vnější syntaxí
    ↓
vybrán přesný pětibajtový záznam instrukce
    ↓
proměnné expressiony zkomprimovány do záznamu zdroje
    ↓
první průchod určí adresy a definice
    ↓
druhý průchod vyhodnotí expressiony a emituje bajty
```

Dalším chybějícím dílem je samotný výraz. Záznam zdroje může obsahovat `TABLE+2`, `$-START`, hexadecimální číslo, znak v uvozovkách nebo unární minus. Kapitola 22 ukáže, jak je PROMETHEUS ukládá a vyhodnocuje bez velkého compileru, stromu priority operátorů nebo haldy dočasných uzlů.
