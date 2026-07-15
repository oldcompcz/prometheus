# Kapitola 22: Expressiony bez velkého překladače

Assembler by byl velmi nepříjemný, kdyby každý operand musel být už hotovým číslem.

Chceme psát:

```asm
        LD HL,SCREEN+32
        JR NZ,LOOP
        DEFW TABLE+2
        ORG #8000
```

nikoli:

```asm
        LD HL,16416
        JR NZ,-7
        DEFW 32786
        ORG 32768
```

Jména činí program čitelným a aritmetika dovoluje jedinému jménu popsat několik blízkých míst. Potíž je v tom, že assembler často narazí na výraz dříve, než ví, co jména znamenají. `LOOP` může být definován o dvacet řádků později. `TABLE` se může po editaci posunout. Aktuální adresa reprezentovaná `$` se mění od jednoho záznamu zdroje k druhému.

Moderní překladač by mohl v paměti vytvořit strom:

```text
        +
       / \
  SCREEN  32
```

PROMETHEUS nic tak velkolepého nedělá. Používá drobný jazyk expressiony, který lze zkontrolovat při zadání řádku, kompaktně uložit do záznamu zdroje a později při sestavení vyhodnotit. Neexistuje halda uzlů syntaktického stromu, parser priority operátorů ani rekurzivní sestup vnořenými závorkami.

Systém je dost malý na to, aby se dal pochopit jako posloupnost atomů a operátorů. Tato jednoduchost není náhodná. Je jedním ze způsobů, jak PROMETHEUS vtěsná seriózní assembler do 48K Spectra.

## Výraz má tři životy

Tentýž výraz se během svého života objevuje ve třech podobách.

### 1. Text pro člověka

Programátor zadá například:

```text
TABLE+2
```

nebo:

```text
$-START
```

Tento tvar se dobře čte, ale bylo by plýtváním ukládat jej znovu a znovu v komprimovaném zdrojovém programu. Dlouhé jméno by se muselo kopírovat do každého řádku, který je používá.

### 2. Zakódovaný payload zdroje

Při přijetí řádku zdroje zůstane běžná interpunkce a číslice jako znaky, ale jméno symbolu se nahradí jeho dvoubajtovým pořadovým číslem.

Koncepčně:

```text
TABLE+2
```

se změní na:

```text
[tagované pořadové číslo TABLE] '+' '2'
```

Přesné bajty probereme později v této kapitole. Důležité je, že trvalý záznam si pamatuje, *který symbol* byl napsán, aniž by si pamatoval celý jeho zápis.

### 3. Šestnáctibitová hodnota

Během průchodu assembleru se výraz přečte z komprimovaného záznamu a vypočítá pomocí aktuálních hodnot symbolů a aktuálního čítače adres.

```text
TABLE = $8120
TABLE+2 = $8122
```

Výsledkem je šestnáctibitové číslo. Pozdější kód rozhodne, zda se toto číslo hodí pro konkrétní pole instrukce: bajt, slovo, relativní displacement, číslo bitu a podobně.

Toto oddělení je zásadní:

```text
zadání řádku výraz zkontroluje a uloží
sestavení jej později vyhodnotí
emise instrukce později zkontroluje způsob použití hodnoty
```

## Malý jazyk

Expressiony PROMETHEA jsou složeny z **atomů** spojených binárními operátory.

Hlavní atomy jsou:

```text
1234        desítkové číslo
#4D2        hexadecimální číslo
%101101     binární číslo
"A"         jednobajtová konstanta v uvozovkách
"AB"        dvoubajtová konstanta v uvozovkách
$           aktuální logická adresa sestavení
LABEL       hodnota symbolu
```

Binární operátory jsou:

```text
+   sčítání
-   odčítání
*   násobení
/   bezznaménkové dělení
?   bezznaménkový zbytek
```

Před atomem může stát úvodní `+` nebo `-`:

```text
-1
+TABLE
BASE+-2
```

Nejpřekvapivější pravidlo je, že PROMETHEUS vyhodnocuje striktně zleva doprava. Násobení a dělení **nemají** obvyklou matematickou prioritu před sčítáním a odčítáním.

Tedy:

```text
2+3*4
```

se vyhodnotí jako:

```text
(2+3)*4 = 20
```

nikoli:

```text
2+(3*4) = 14
```

Toto pravidlo zní primitivně, ale odstraňuje potřebu zásobníku operátorů nebo stromu výraz. Manuál může pravidlo uvést, programátor může v případě potřeby přidat mezilehlý symbol `EQU` a evaluator zůstane mimořádně malý.

Závorky viditelné v operandech obvykle patří syntaxi adresování Z80:

```asm
LD A,(TABLE+2)
```

Vymezují nepřímý operand; nejsou obecným mechanismem priority v aritmetickém jazyce.

## Encoder je zároveň syntaktickou kontrolou

Kapitola 21 skončila u `encodeOperandExpression`. Rutina dostane normalizovaný buffer operandu a zapisuje proměnné bajty do dočasného záznamu zdroje.

Její hlavní práci lze zapsat takto:

```text
repeat:
    přečti volitelné unární znaménko
    přečti jeden atom
    zakóduj atom

    if byla dosažena hranice výraz:
        dokonči

    vyžaduj jeden z operátorů + - * / ?
    ulož operátor
    vyžaduj další atom
```

Skutečná rutina začíná přesunem za vnější syntaxi operandu. Přímý výraz začíná okamžitě. Výraz v závorkách přeskočí otevírací závorku. Indexovaný operand přeskočí `(ix` nebo `(iy)` a začne u znaménka displacementu.

```asm
encodeOperandExpression:
    cp ","
    jr z,.beginExpressionTokenScan
    inc de
    cp "-"
    jr z,.beginExpressionTokenScan
    inc de
    inc de
.beginExpressionTokenScan:
    call testClosingBracketOrComma
```

Tato kompaktní vstupní posloupnost závisí na třídách operandů určených již v kapitole 21. `encodeOperandExpression` znovu neobjevuje celou vnější gramatiku. Volající mu už řekl, s jakým druhem operandu nesoucího výraz pracuje.

## Hranice výraz

Helper `testClosingBracketOrComma` rozpoznává místa, kde musí aktuální výraz skončit:

```asm
testClosingBracketOrComma:
    ld a,(de)
    inc de
    cp ")"
    jr z,.setFlagForSyntaxError
    cp ","
    jr z,.setFlagForSyntaxError
    or a
    ret nz
.setFlagForSyntaxError:
    scf
    ret
```

Navzdory historickému názvu lokálního labelu zde carry nemusí znamenat chybu. Znamená:

```text
byla dosažena čárka, uzavírací závorka nebo konec textu
```

Volající rozhodne, zda je tato hranice v daném okamžiku legální.

Na začátku atomu je hranice nelegální:

```text
TABLE+
       ^ byl vyžadován další atom
```

Po úplném atomu je tatáž hranice přesně tím, co výraz ukončuje.

PROMETHEUS často používá flags právě tímto způsobem. Carry nemá jeden univerzální význam. Je to kompaktní odpověď, na jejímž významu se dohodl volající s volaným.

## Unární plus zmizí; unární minus zůstane

Na začátku každého atomu encoder zkontroluje znaménko:

```asm
    cp "+"
    jr z,.readExpressionAfterUnaryMinus
    cp "-"
    jr nz,.classifyExpressionAtom
    call storeAtIXMoveToNextAndIncB
.readExpressionAfterUnaryMinus:
    call testClosingBracketOrComma
```

Unární plus nenese žádnou informaci, takže se spotřebuje, ale neuloží.

Unární minus je důležité a zkopíruje se do komprimovaného výraz. Při pozdějším vyhodnocení znamená:

```text
přečti atom
nahraď hodnotu jejím šestnáctibitovým dvojkovým doplňkem
potom použij předchozí binární operátor
```

Například:

```text
BASE+-2
```

může zůstat jednoduchou posloupností zleva doprava:

```text
atom BASE
operátor +
unární -
atom 2
```

Není potřeba žádná zvláštní gramatika odčítání kromě rozlišení binárního operátoru po jednom atomu a unárního znaménka před dalším.

## Atom aktuální adresy

Znak dolaru představuje aktuální logickou adresu sestavení:

```asm
        DEFW $-TABLE
```

Encoder uloží `$` jednoduše jako běžný literal bajt. Jeho význam se nevyřeší dříve než během průchodu assembleru, protože čítač adres se může změnit, když je zdroj nad daným řádkem upraven.

Při vyhodnocení:

```asm
    cp "$"
    ld de,(varcAddressCounter+1)
    jr z,.advancePastEncodedExpressionAtom
```

Operand instrukce patchovaný na `varcAddressCounter+1` tedy není jen proměnnou assembleru. Dává expressiony přístup k logickému místu, na kterém se právě zpracovává aktuální záznam zdroje.

Je to další příklad samomodifikujících stavových konvencí zdroje z kapitoly 5.

## Jména symbolů se mění na pořadová čísla

Je-li prvním znakem písmeno, encoder zachází s atomem jako se symbolem:

```asm
    dec de
    push de
    push ix
    ex de,hl
    call findOrCreateSymbolOrdinal
    pop ix
    set 7,h
    ld (ix+000h),h
    inc ix
    ld (ix+000h),l
    inc ix
```

Děje se zde několik důležitých věcí.

Za prvé se zápis normalizuje a vyhledá v tabulce symbolů. Pokud ještě neexistuje, vytvoří se nový symbol. Proto je možný dopředný odkaz: použití `LOOP` může vytvořit jeho identitu dříve, než pozdější řádek definuje jeho hodnotu.

Za druhé záznam zdroje ukládá jedničkově číslované pořadové číslo, nikoli ukazatel na jméno ani znaky jména.

Za třetí se v horním bajtu pořadového čísla nastaví bit 7. Tím se první bajt změní na tag v rozsahu `$80-$BF`.

Proud výraz lze proto procházet bez samostatné tabulky délek tokenů:

```text
$00-$7F  literal znak, například číslice, operátor, uvozovka nebo '$'
$80-$BF  první bajt dvoubajtového pořadového čísla symbolu
$C0-$FF  koncová značka / back-link záznamu zdroje
```

Scanner uvidí bajt alespoň `$80`, ale menší než `$C0`, ví, že ještě jeden bajt patří odkazu na symbol, a potom může pokračovat.

Toto tagování je jedním z opakujících se příkladů **malého datového jazyka** v této knize. Několik nevyužitých vysokých bitů činí smíšený proud samopopisným.

## Čísla se kontrolují během kopírování

Literální čísla nejsou přijímána jen jako libovolné řetězce znaků. Encoder kontroluje jejich syntaxi a rozsah a zároveň zachovává kanonický textový zápis.

Výchozí radix je desítkový:

```text
32768
```

Prefix zvolí jiný radix:

```text
#8000       hexadecimální
%10101100   binární
```

Základní algoritmus je:

```text
value = 0
for each platná číslice:
    value = value * radix
    value = value + digit
    selži, pokud kterákoli operace překročí 16 bitů
    zkopíruj normalizovaný znak zdroje do záznamu
```

Násobení se provádí opakovaným sčítáním, protože radix je pouze 2, 10 nebo 16:

```asm
    ld a,c
    dec a
    ld d,h
    ld e,l
.multiplyLiteralAccumulatorByRadixLoop:
    add hl,de
    jp c,bigNumberError
    dec a
    jr nz,.multiplyLiteralAccumulatorByRadixLoop
```

Je-li aktuální akumulátor `123` a radix deset, stará hodnota se k sobě přičte ještě devětkrát a vznikne `1230`. Potom se přidá číslice.

Není to nejrychlejší představitelný převod, ale čísla v řádcích zdroje jsou krátká a zadávání řádku je interaktivní. Kód šetří místo a zachytí overflow v okamžiku, kdy vznikne.

Malá hexadecimální písmena se před zkopírováním normalizují na velká. `#beef` se tak může v kanonickém zdroji znovu objevit jako `#BEEF`.

## Platná číslice závisí na radixu

`convertInputCharacterToRadixDigit` nejprve mapuje ASCII znaky na kandidátní hodnoty:

```text
'0'..'9' → 0..9
'A'..'F' → 10..15
'a'..'f' → 10..15, s kanonickým zápisem velkými písmeny
```

Volající potom kandidáta porovná se zvoleným radixem.

```text
%102       číslice 2 není v radixu 2 platná
#1G        G není hexadecimální číslice
19         obě číslice jsou platné v radixu 10
```

Nečíselný znak může být zároveň legálním operátorem nebo hranicí, takže „není číslice“ není okamžitě chyba. Vnější parser výraz rozhodne, co smí následovat za dokončeným číslem.

## Konstanty v uvozovkách skládají jeden nebo dva bajty

PROMETHEUS přijímá atom ve dvojitých uvozovkách obsahující nejvýše dva logické znaky:

```text
"A"     → $0041
"AB"    → $4142 interpretované jako dvoubajtová konstanta pořadím evaluatoru
```

Přesné uspořádání high/low určuje posloupnost vytváření bajtů v evaluatoru, nikoli to, jak znaky vypadají na papíře. Praktické pravidlo je, že jednoznaková konstanta vytvoří bajtovou hodnotu tohoto znaku, zatímco dvouznaková konstanta vytvoří jednu šestnáctibitovou hodnotu obsahující oba bajty.

Zdvojená uvozovka představuje doslovný znak uvozovky. Třetí datový znak před uzavřením vyvolá `Bad string`.

Encoder zachovává zápis v uvozovkách v komprimovaném výraz. To je užitečné při expanzi řádku zpět do čitelného zdroje: výraz lze rekonstruovat bez vymýšlení číselné náhrady.

Algoritmus je zhruba:

```text
zkopíruj otevírací uvozovku
přečti první logický znak, pokud existuje
přečti druhý logický znak, pokud existuje
nyní vyžaduj uzavírací uvozovku
zkopíruj uzavírací uvozovku
```

Kód pro práci s uvozovkami je složitější než pseudokód, protože musí rozlišit uzavírací uvozovku od zdvojené uvozovky použité jako data.

## Operátory se ukládají doslova

Po jednom atomu encoder přijímá pouze:

```text
+ - * / ?
```

a zvolený operátor zkopíruje do záznamu.

```asm
    cp "+"
    jr z,.storeExpressionOperatorAndContinue
    cp "-"
    jr z,.storeExpressionOperatorAndContinue
    cp "*"
    jr z,.storeExpressionOperatorAndContinue
    cp "/"
    jr z,.storeExpressionOperatorAndContinue
    cp "?"
    jp nz,syntaxError
```

Další bajt musí začínat nový atom. Chybné tvary se proto odmítnou už při zadání řádku:

```text
A++        znaménko bez následujícího atomu
A&3        nepodporovaný operátor
#          radix prefix bez číslice
"ABC"      konstanta v uvozovkách je příliš dlouhá
```

Dopředný symbol v této fázi chybou není. Jeho zápis může být platný, i když jeho hodnota ještě není známa.

## Zakódovaný proud zůstává čitelný

Předpokládejme jen pro ilustraci, že `TABLE` má pořadové číslo 37. Jeho dvoubajtové pořadové číslo může být reprezentováno tagovaným high bajtem a low bajtem. Potom:

```text
TABLE+2
```

má koncepční payload:

```text
SYMBOL(37), '+', '2'
```

a:

```text
$-START
```

se změní na:

```text
'$', '-', SYMBOL(pořadové číslo START)
```

Proud není strojovým kódem. Je to kompaktní malý jazyk bez postfixu, který zůstává ve stejném pořadí jako původní text.

Toto pořadí usnadňuje expanzi: literal bajty se kopírují, tagovaná pořadová čísla symbolů se nahrazují jmény a terminátor záznamu říká, kdy skončit. Kapitola 14 již tuto zpětnou cestu použila, aniž ještě vysvětlila evaluator.

## Dva evaluatory, jeden aritmetický model

PROMETHEUS má dvě hlavní situace, v nichž výraz vstupuje do evaluatoru.

### Expressiony textových příkazů

Příkazy jako `U-TOP` se zadávají do vstupního řádku a vyhodnocují přímo. `evaluateInputExpression` ukáže na argument příkazu a vstoupí do `evaluateExpressionAtHL`.

Tento evaluator nejprve zkopíruje a normalizuje text do command workspace. Potom rozpoznává atomy a symboly ze znaků.

### Zakódované expressiony zdroje

Záznamy zdroje assembleru již obsahují tagovaná pořadová čísla symbolů a zkontrolovaný literal zápis. `evaluateEncodedExpressionAtIX` je čte přímo bez rekonstrukce textu.

Tyto dva front endy se liší způsobem získávání atomu, ale sbíhají se ke stejným myšlenkám:

```text
akumulovaná hodnota
čekající binární operátor
možné unární minus na dalším atomu
sdílené šestnáctibitové aritmetické rutiny
```

Textový evaluator je užitečný pro interaktivní příkazy. Zakódovaný evaluator je dost kompaktní a rychlý na opakované spouštění během průchodů assembleru.

## Zásobník se stává workspace výraz

Textový evaluator začíná:

```asm
evaluateExpressionAtHL:
    ...
    ld hl,00000h
    ld a,"+"
.evaluateTextExpressionLoop:
    push hl
    push af
```

`HL` je dosud akumulovaný výsledek. `A` je operátor čekající na spojení tohoto výsledku s dalším atomem.

Prvním čekajícím operátorem je `+` a počáteční akumulátor je nula. Tím se první atom změní na běžný případ:

```text
0 + firstAtom
```

Zatímco se dekóduje další atom, starý akumulátor a operátor čekají na zásobníku Z80. Hodnota atomu vzniká v jiné dvojici registrů. Rutina potom čekající stav obnoví a operátor použije.

Koncepčně:

```text
accumulator = 0
pending = '+'

loop:
    atom = readAtom()
    atom = applyUnarySign(atom)
    accumulator = apply(pending, accumulator, atom)

    if konec:
        return accumulator

    pending = readOperator()
```

To je celý důvod, proč není potřeba strom výraz.

## Symboly musí být při vyhodnocení známé

Textový evaluator rozpozná jméno voláním `parseSymbolNameAndFindOrdinal` a potom pořadové číslo vyřeší:

```asm
    call resolveSymbolReferenceToName
    ld a,(hl)
    and 0c0h
    ld a,MESSAGE_UNKNOWN
    jp z,signalError
```

High flag bajt vektoru symbolu je přijat, je-li nastaven alespoň jeden z bitů:

```text
DEFINED
nebo
LOCKED
```

Existující, ale právě neznámý symbol se tedy liší od jména, které vůbec neexistuje. V obou případech interaktivní příkaz oznámí `Unknown`, ale uvnitř PROMETHEUS zachoval identitu potřebnou pro dopředné odkazy ve zdroji.

Zakódovaný evaluator provádí stejný test flags. Je-li symbol neznámý, zároveň si zapamatuje adresu jména pro diagnostiku assembleru, než se vrátí k provinilému záznamu zdroje.

Kapitola 23 vysvětlí, kde tyto flags a hodnoty žijí.

## Vyhodnocení zleva doprava v praxi

Uvažujme:

```text
10-2*3+1
```

PROMETHEUS postupuje takto:

```text
počáteční accumulator = 0, pending = +

atom 10:
    0 + 10 = 10
    další čekající operátor = -

atom 2:
    10 - 2 = 8
    další čekající operátor = *

atom 3:
    8 * 3 = 24
    další čekající operátor = +

atom 1:
    24 + 1 = 25
```

Výsledkem je 25.

Programátor zvyklý na obvyklou prioritu si musí toto pravidlo pamatovat. Pro implementaci je velkým zjednodušením: stačí jeden akumulátor a jeden čekající operátor.

## Šestnáctibitová aritmetika přetéká

Sčítání a odčítání používá přirozené šestnáctibitové chování Z80. Překročí-li výsledek `$FFFF`, přeteče modulo 65536.

```text
$FFFF + 1 = 0
0 - 1 = $FFFF
```

V assembleru je to užitečné. Například `U-TOP -1` přirozeně vytvoří `$FFFF`.

Samotné zadání literalu je přísnější: zapsané číslo příliš velké pro šestnáct bitů vyvolá `Big number`. Aritmetika prováděná po platných atomech však smí přetékat.

Toto rozlišení je rozumné:

```text
70000       není legální šestnáctibitový literal
$FFFF+1     je legální šestnáctibitový výpočet, jehož výsledek přeteče na nulu
```

## Sčítání a odčítání

Dvě nejjednodušší implementace operátorů jsou téměř přímým překladem svého významu:

```asm
.addExpressionOperands:
    add hl,de
    ret
.subtractExpressionOperands:
    or a
    sbc hl,de
```

`or a` vynuluje carry před `SBC` a změní je tak na obyčejné šestnáctibitové odčítání.

Operandy používají společnou konvenci:

```text
HL = akumulovaná levá strana
DE = právě načtený atom pravé strany
```

Výsledek se vrací v `HL` a stane se dalším akumulátorem.

## Násobení pomocí posunů a sčítání

Z80 nemá obecnou instrukci pro šestnáctibitové násobení. PROMETHEUS používá šestnáctikrokovou rutinu shift-and-add.

Na vysoké úrovni:

```text
result = 0
repeat pro 16 bitů násobitele:
    posuň result
    posuň další bit násobitele do carry
    if bit byl 1:
        přičti násobenec
```

Přežije pouze dolních šestnáct bitů, což odpovídá modelu přetékání evaluatoru.

Pro mladého programátora assembleru stojí tato rutina za studium nikoli proto, že by si ji měl zapamatovat, ale protože ukazuje obecnou lekci:

> Chybějící instrukci procesoru lze často nahradit malou smyčkou nad bity.

## Dělení obnovujícím odčítáním

Také dělení je implementováno softwarově. `divideHLByDE` provádí šestnáct kol bezznaménkového restoring division.

Základní myšlenka je:

```text
remainder = 0
bity quotientu = bity dividendy

for each bit:
    posuň další bit dividendy do remainder
    zkus remainder - divisor
    if odčítání uspělo:
        ponech výsledek a nastav bit quotientu
    otherwise:
        obnov původní remainder
```

Skutečná smyčka je kompaktní:

```asm
divideHLByDE:
    ld a,h
    ld c,l
    ld hl,00000h
    ld b,010h
.unsignedDivideLoop:
    sli c
    rla
    adc hl,hl
    sbc hl,de
    jr nc,.unsignedDivideKeepBit
    add hl,de
    dec c
.unsignedDivideKeepBit:
    djnz .unsignedDivideLoop
    ret
```

Quotient se skládá v `A:C`; remainder zůstává v `HL`.

Operátor `/` vrací quotient. Operátor `?` používá remainder ponechaný stejnou primitivou.

### Dělení nulou

PROMETHEUS nevyvolává při dělení nulou zvláštní chybu. Opakované pokusy původního algoritmu vytvoří quotient `$FFFF`, což odpovídá dokumentovanému chování.

Je to užitečná historická připomínka: implementace může definovat krajní případ svým algoritmem, nikoli moderním mechanismem výjimek.

## Unární minus používá dvojkový doplněk

Pro negaci šestnáctibitové hodnoty v `DE` PROMETHEUS invertuje oba bajty a přičte jedničku:

```asm
negateDEIfOperatorIsMinus:
    cp "-"
    ret nz
    ld a,d
    cpl
    ld d,a
    ld a,e
    cpl
    ld e,a
    inc de
    ret
```

Je to standardní operace dvojkového doplňku:

```text
-value = bitwise_not(value) + 1
```

Příklady:

```text
1      → $0001
-1     → $FFFF
2      → $0002
-2     → $FFFE
```

Ani zde neexistuje objekt znaménkového čísla. Týchž šestnáct bitů lze podle potřeb okolní operace interpretovat jako bezznaménkové nebo znaménkové číslo v dvojkovém doplňku.

## Zakódovaný evaluator prochází proud pomocí `IX`

`evaluateEncodedExpressionAtIX` drží `IX` poblíž hlavičky záznamu zdroje. Aktuální bajt výraz opakovaně načítá přes pevný displacement:

```asm
    ld a,(ix+002h)
```

Místo změny displacementu rutina při spotřebování bajtů inkrementuje `IX`. Smyčka tak používá stále tentýž kompaktní tvar instrukce.

Token symbolu se rozpozná podle vysokého rozsahu:

```asm
    cp 080h
    jp c,.parseNumericOrQuotedConstantAtIX
```

Bajty pod `$80` jsou literal text. Bajt v rozsahu symbolů se stane high bajtem pořadového čísla a následuje low bajt.

Resolver potom vrací:

```text
HL = adresa flag bajtu vektoru
DE = adresa jména symbolu
DE-2 = adresa hodnoty symbolu
```

Evaluator zkontroluje flags a načte dvoubajtovou hodnotu uloženou bezprostředně před jménem.

## Koncové značky nepotřebují samostatnou délku

Po použití atomu `readEncodedExpressionOperatorOrEnd` prohlédne další bajt. Musí rozlišit:

- další operátor;
- oddělovač operandů;
- terminál / back-link záznamu zdroje.

Protože terminálové bajty leží v rozsahu `$C0-$FF`, stejné číselné rozsahy, které rozlišují symboly, zviditelňují i konec.

Evaluator nepotřebuje samostatně uloženou délku výraz. Prochází samopopisný payload zdroje, dokud okolní formát záznamu neřekne, že má skončit.

To je jeden z důvodů, proč je kódování záznamu zdroje z kapitoly 12 tak účinné: navigace editoru, vyhodnocení výraz, procházení odkazů na symboly i expanze zdroje rozumějí týmž třídám bajtů.

## Syntaktická kontrola a kontrola hodnoty jsou různé

PROMETHEUS záměrně odděluje několik druhů platnosti.

### Při zadání řádku

Encoder kontroluje:

- pořadí atomů a operátorů;
- legální číslice radixu;
- overflow literalu;
- uzavření uvozovek a délku konstanty;
- legální zápis symbolu;
- podporované operátory.

### Během sestavení

Evaluator kontroluje:

- zda jsou odkazované symboly právě definované nebo uzamčené.

### Během emise instrukce

Pozdější kód kontroluje:

- zda se výsledná hodnota vejde do bajtu;
- zda se indexový displacement vejde do znaménkového rozsahu;
- zda relativní skok dosáhne cíle;
- zda je legální číslo bitu, restart vector nebo režim přerušení.

Tento stupňovitý návrh brání tomu, aby evaluator výraz musel znát každý možný způsob použití čísla.

## V prostém pseudokódu

Kódování textového výraz operandu:

```text
function encodeExpression(text):
    output = []

    while true:
        sign = readOptionalUnarySign()
        if sign == '-':
            output.append('-')

        atom = readAtom()

        if atom je jméno symbolu:
            ordinal = findOrCreateSymbol(atom.name)
            output.append(taggedHighByte(ordinal))
            output.append(lowByte(ordinal))

        else if atom je číslo:
            validateSixteenBitLiteral(atom)
            output.append(canonicalText(atom))

        else if atom je konstanta v uvozovkách:
            validateOneOrTwoCharacters(atom)
            output.append(originalQuotedText(atom))

        else if atom je '$':
            output.append('$')

        else:
            syntaxError()

        if jsme na hranici výraz:
            return output

        operator = readCharacter()
        if operator není v '+-*/?':
            syntaxError()
        output.append(operator)
```

Vyhodnocení zakódovaného výraz:

```text
function evaluateEncodedExpression(stream, currentAddress):
    accumulator = 0
    pendingOperator = '+'

    while true:
        unaryMinus = stream.peek() == '-'
        if unaryMinus:
            stream.advance()

        token = stream.peek()

        if token == '$':
            atom = currentAddress
            stream.advance()

        else if token je tagované pořadové číslo symbolu:
            symbol = resolveOrdinal(stream.readOrdinal())
            if symbol není definovaný ani uzamčený:
                error Unknown
            atom = symbol.value

        else:
            atom = parseNumericOrQuotedLiteral(stream)

        if unaryMinus:
            atom = -atom modulo 65536

        accumulator = apply(pendingOperator, accumulator, atom)

        if stream je na konci výraz:
            return accumulator

        pendingOperator = stream.readOperator()
```

Použití operátoru:

```text
function apply(op, left, right):
    '+' → left + right modulo 65536
    '-' → left - right modulo 65536
    '*' → low16(left * right)
    '/' → unsignedQuotient(left, right)
    '?' → unsignedRemainder(left, right)
```

## Co se změnilo v paměti

Když je výraz přijat do záznamu zdroje:

- literal číslice, prefixy radixu, uvozovky, `$`, unární minus a binární operátory zabírají běžné bajty payloadu;
- každý zápis symbolu byl nahrazen tagovaným dvoubajtovým pořadovým číslem;
- každý dříve neznámý symbol byl přidán do tabulky symbolů;
- záznam nenese žádnou vyhodnocenou hodnotu ani pevný ukazatel na jméno symbolu;
- syntaxe výraz a rozsahy literalů již byly zkontrolovány.

Když se výraz vyhodnocuje:

- žádné trvalé bajty zdroje se nemění;
- `varcAddressCounter+1` dodává aktuální hodnotu `$`;
- vektory symbolů dodávají stav a záznamy symbolů dodávají hodnoty;
- zásobník Z80 dočasně drží akumulátor a čekající operátor;
- výsledek se vrací jako šestnáctibitová hodnota, v `HL` pro textové expressiony nebo v `BC` pro zakódované expressiony assembleru.

## Důležité labely, které jsme potkali

- `encodeOperandExpression`
- `encodeQuotedOrNumericAtom`
- `convertInputCharacterToRadixDigit`
- `testClosingBracketOrComma`
- `evaluateInputExpression`
- `evaluateExpressionAtHL`
- `evaluateEncodedExpressionAtIX`
- `readEncodedExpressionOperatorOrEnd`
- `applyExpressionOperatorToHLAndDE`
- `multiplyHLByDE`
- `divideHLByDE`
- `negateDEIfOperatorIsMinus`
- `varcTextAtomUnarySign`
- `varcAddressCounter`

## Zpět k celkovému obrazu

Assembler nyní dokáže přenést řádek jako:

```asm
        LD HL,TABLE+2
```

několika stadii, aniž by musel znát `TABLE` příliš brzy:

```text
viditelný text operandu
    ↓
vnější třída: přímý výraz
    ↓
zakódovaný payload: SYMBOL(TABLE), '+', '2'
    ↓
vyřešení symbolu v průchodu
    ↓
šestnáctibitový výsledek
    ↓
kontrola rozsahu podle instrukce a emise bajtů
```

Chybějícím objektem tohoto příběhu je samotný symbol. Používali jsme pořadová čísla, hodnoty, jména a flags DEFINED/LOCKED, ale ještě jsme neviděli, jak spolu koexistují v paměti. Kapitola 23 otevře tabulku symbolů a ukáže, proč ji PROMETHEUS udržuje současně ve dvou pořadích.
