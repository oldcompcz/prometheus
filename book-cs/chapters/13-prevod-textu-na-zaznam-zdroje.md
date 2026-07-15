# Kapitola 13: Převod textu na záznam zdroje

V předchozí kapitole jsme zkoumali kompaktní záznam zdroje, jako by se už hotový objevil v paměti. Viděli jsme jeho dvoubajtovou hlavičku, volitelná pořadová čísla symbolů a závěrečnou značku `$C0+n`. Tím jsme odpověděli na otázku:

> Co si PROMETHEUS ponechá poté, co přijme zdrojový řádek?

Nyní si můžeme položit zajímavější otázku:

> Jak se z řádku napsaného člověkem stane takový záznam?

Odpovědí není jediný krok tokenizace. PROMETHEUS postupně mění způsob, jakým se na řádek dívá.

Nejprve vidí tři široká pole určená člověku:

```text
label       mnemonic     operandy
```

Potom vidí známá slova a text mající podobu výrazu:

```text
symbol      mnemonic #   třídy operandů
```

Následně najde jeden přesný popis instrukce:

```text
opcode      rodina prefixu      deskriptory operandů
```

Nakonec zapíše trvalý záznam, v němž se opakované názvy změnily na pořadová čísla symbolů a viditelné mezery řádku zmizely.

Je to dobrý příklad vzoru této knihy shora dolů, zdola nahoru a znovu shora dolů. Nejprve projdeme celý převod, potom prozkoumáme jeho malé mechanismy a nakonec zrekonstruujeme jeden úplný řádek od klávesnicového bufferu až po vložení do zdroje.

## Celý převod v jednom pohledu

Když uživatel stiskne ENTER na obyčejném zdrojovém řádku, editor nakonec dorazí do `parseAndInsertSourceLine`:

```asm
parseAndInsertSourceLine:
    call encodeInputLineToSourceRecord
    call getRecordAfterActiveLine
    push hl
    ld (varcInsertionPointForPointerAdjustment+1),hl
    ld de,encodedRecordStorageLength
    ld a,(de)
    ld c,a
    inc de
    call insertByteRangeAtHLFromDE
    pop hl
    ld (varcSourceBufferActiveLine+1),hl
```

Tento úryvek odděluje dvě činnosti, které lze snadno zaměnit:

1. `encodeInputLineToSourceRecord` řádku **porozumí** a vytvoří dočasný komprimovaný záznam.
2. `insertByteRangeAtHLFromDE` už připravené bajty **uloží** do trvalé oblasti zdroje.

Parser při rozpoznávání neposílá bajty přímo doprostřed paměti zdroje. Nejprve sestaví úplného kandidáta v pevném pracovním prostoru. Najde-li chybu, původní zdroj zůstane nedotčen.

V prostém pseudokódu:

```text
record = encode(editLine)

if kódování selhalo:
    zobraz chybu
    ponech zdroj beze změny
else:
    insertionPoint = recordAfter(activeRecord)
    otevři prostor o record.length bajtech
    zkopíruj record do tohoto prostoru
    nastav nový záznam jako aktivní

    if režim OVERWRITE:
        smaž původní aktivní záznam

    return do editoru
```

Návrh „nejprve dočasně“ není jen pohodlný. Jde o malou transakci: PROMETHEUS řádek potvrdí teprve poté, co prošel všemi testy rozpoznání a syntaxe.

## Vstupem je stále editovatelný řádek

Encoder začíná na `inputBufferStart`, tedy u stejného krátkého nulou zakončeného řetězce popsaného v kapitole 11. Uvnitř se stále může nacházet pohyblivá značka kurzoru `$01`.

Parserové rutiny proto nečtou bajty prostým `LD A,(HL)`. Používají `atHLorNextIfOne`:

```asm
atHLorNextIfOne:
    ld a,(hl)
    cp 001h
    ret nz
    inc hl
    ld a,(hl)
    ret
```

Pro parser je značka průhledná. Patří k editačnímu rozhraní, nikoli k jazyku assembleru.

Jde o opakující se princip PROMETHEA:

> Dočasná reprezentace může obsahovat soukromé řídicí bajty, ale další vrstva dostane pohled, v němž tyto bajty zmizely.

## Viditelný jazyk tří polí

Editor PROMETHEA nabízí obvyklé rozvržení assembleru:

```text
sloupce  0..8     volitelný label
sloupce  9..13    mnemonic
sloupce 14..31    operandy
```

Parser nespoléhá na dokonale zarovnané mezery. Používá je jako oddělovače a tam, kde to dává smysl, další mezery ignoruje. Šířky polí slouží hlavně jako editační a validační limity.

`encodeInputLineToSourceRecord` provede první hrubé rozdělení:

```asm
encodeInputLineToSourceRecord:
    cp ";"
    jr z,.encodeCommentSourceRecord
    cp " "
    call nz,readSourceFieldUntilSpace
    call skipSpaces
    ld de,parsedMnemonicBuffer
    ld c,005h
    call readSourceFieldUntilSpace
    call skipSpaces
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

Hrubý algoritmus vypadá takto:

```text
if první viditelný znak je ';':
    zakóduj komentář zvláštní cestou
else:
    if řádek začíná před polem mnemonic:
        přečti volitelný label

    přeskoč mezery
    přečti mnemonic v rámci jeho pěti sloupců parseru

    přeskoč mezery
    přečti první operand do pevného pracovního prostoru,
        zastav se na čárce mimo uvozovky
    přečti druhý operand až do konce řádku
```

Názvy dočasných oblastí jsou historickými kompromisy. Například `commandArgumentBuffer` se zde znovu používá jako buffer druhého operandu. PROMETHEUS šetří paměť tím, že různé operace si v různou dobu půjčují tentýž pracovní prostor.

## Jeden čtenář pole, tři oddělovače

Rutiny pro label či mnemonic, první operand a druhý operand vstupují do stejné smyčky, jen s jiným oddělovačem:

```asm
readSourceFieldUntilSpace:
    ld b," "
    jr .readDelimitedFieldLoop
readFirstOperandUntilComma:
    ld b,","
    jr .readDelimitedFieldLoop
readSecondOperandToEnd:
    ld b,000h
```

Je to kompaktní a současně pojmově čisté. Pravidla smyčky jsou:

```text
přečti viditelný bajt a ignoruj značku kurzoru

if začíná citovaný text:
    kopíruj jej bez interpretace mezer a čárek
else if bajt je zvolený oddělovač:
    skonči
else if bajt je mezera mimo uvozovky:
    přeskoč ji
else if bajt je nula:
    skonči na konci řádku
else:
    normalizuj jej a zkopíruj
```

Mimo citovaný text smyčka nastaví bit 5:

```asm
set 5,a
```

U písmen ASCII tím převede velká písmena na malá. Dočasný slovník parseru je proto nezávislý na velikosti písmen:

```text
LD      ld      Ld      lD
```

Všechny tyto podoby se změní na stejné normalizované mnemonic.

Citovaný text se kopíruje doslova. Znak uvnitř řetězce je datem, nikoli klíčovým slovem assembleru.

## Proč čárky uvnitř uvozovek nerozdělují operandy

Uvažujme:

```asm
        DEFM "A,B"
```

Naivní scanner čárek by řetězec rozdělil za `A`. PROMETHEUS při nalezení `'` nebo `"` místo toho vstoupí do smyčky kopírující citovaný text. Testy oddělovačů se pozastaví, dokud se neobjeví odpovídající koncová uvozovka.

Parser není obecným překladačem jazyka, ale rozumí dostatečné místní struktuře, aby rozlišil:

```text
čárku oddělující operandy
čárku uloženou uvnitř citovaných dat
```

Je to užitečné poučení z malých parserů. Nepotřebují obrovskou formální gramatiku, lze-li obtížné případy jazyka izolovat do několika změn stavu.

## Komentáře používají nejkratší cestu

Zdrojový řádek začínající středníkem se nedělí na label, mnemonic a operandy. PROMETHEUS ví, že libovolnou prózu nelze smysluplně komprimovat víc než jejím zabalením do jednoho záznamu.

Zvláštní cesta začíná:

```asm
.encodeCommentSourceRecord:
    ld ix,encodedRecordPayload
    ld (ix-002h),001h
    ld (ix-001h),037h
    ld b,0ffh
```

Nastaví:

```text
bajt opcodu       $01       pseudo-opcode komentáře
informační bajt   $37       pseudo-záznam, třída 7, bez labelu
```

Potom kopíruje viditelný řádek včetně počátečního středníku až po nulový terminátor. Závěrečná nula se neukládá. Běžný finalizer doplní značku zpětné délky a zveřejní počet bajtů.

Komentáře tak zcela obcházejí:

- vyhledání mnemonic;
- rozpoznání operandů;
- vytváření symbolů;
- hledání v tabulce instrukcí;
- kontrolu výrazů.

Je to rychlejší i bezpečnější. Slovo jako `loop` v komentáři nesmí potichu vytvořit symbol.

## Rozpoznání mnemonic nejprve podle délky

Po rozdělení polí obsahuje `parsedMnemonicBuffer` normalizované nulou zakončené slovo, například `djnz`.

PROMETHEUS jej neporovnává od začátku se všemi mnemonic. Nejprve změří délku pomocí `lengthUpToZero` a malým deskriptorem vybere jen slova této délky.

Pojmově:

```text
délka 1  → porovnej s bucketem jednopísmenných mnemonic
délka 2  → porovnej s bucketem dvoupísmenných mnemonic
délka 3  → porovnej s bucketem třípísmenných mnemonic
délka 4  → porovnej s bucketem čtyřpísmenných mnemonic
```

Deskriptory v `mnemonicLookupByLengthDescriptors` jsou obdivuhodně husté. Některé bajty vypadají jako instrukce Z80, protože je tabulka vložena přímo do assemblerového zdroje:

```asm
mnemonicLookupByLengthDescriptors:
    defw mnemonicsReferences
    defb 0x01
    ld bc,0020ch
    add hl,hl
    ld c,017h
    scf
```

Procesor tyto zdánlivé instrukce nikdy nevykoná. Jejich bajty kódují počty a offsety bucketů.

`prepareLengthBucketLookup` převede délku na:

- počet kandidátních slov v bucketu;
- adresu prvního zabaleného zápisu;
- logický index prvního kandidáta.

`compareWithMnemonics` pak porovnává slova zakončená vysokým bitem znak po znaku. Nastavený carry znamená, že žádný kandidát neodpovídal.

V pseudokódu:

```text
length = strlen(mnemonic)
bucket = mnemonicBuckets[length]

for each word in bucket:
    if word == mnemonic:
        return mnemonicIndex

chyba "Bad mnemonic"
```

Jde o malou, ale důležitou optimalizaci. Délka vyřadí většinu mnemonic dřív, než začne jakékoli porovnávání znaků.

## Prázdné mnemonic a pseudo-instrukce

Řádek může obsahovat jen label. V takovém případě začíná buffer mnemonic nulou a PROMETHEUS ponechá index mnemonic nula.

Slova řídící assembler, například `ORG`, `EQU`, `ENT`, `DEFB`, `DEFM`, `DEFS` a `DEFW`, mají také indexy mnemonic, ale některá se později převedou do rozsahu pseudo-opcodů popsaného v kapitole 12.

Definiční mnemonic dostávají zvláštní cestu, protože mohou obsahovat seznamy a řetězce se syntaxí odlišnou od běžné instrukce s jedním či dvěma operandy.

## Operandy se nejprve klasifikují, nikoli vyhodnocují

Parser má nyní až dva normalizované řetězce operandů. Ještě se neptá, na jakou hodnotu se vyhodnotí výraz `LOOP+2`. Ptá se, jaký *druh textu operandu* před sebou má.

`classifyOperandText` nejprve změří délku řetězce.

U krátkých řetězců prohledá tabulku pevných operandů. Patří sem například:

```text
a       hl      nz      (bc)      ix
```

Najde-li pevný zápis, vrátí rutina jeho kompaktní index deskriptoru.

Jinak vyberou strukturální pravidla jednu z tříd nesoucích výraz:

```text
text                 třída
--------------------------------------------
LABEL+2              přímý výraz
(TABLE)              výraz v závorkách
(IX+5)               displacement IX
(IY-3)               displacement IY
```

Podstatný úryvek je:

```asm
.classifyNonRegisterOperand:
    ld a,(hl)
    cp "("
    ld a,02ch
    ret nz
    inc hl
    ld a,(hl)
    cp "i"
    jr nz,.returnGenericExpressionOperandClass
```

Neznámý zápis bez závorek se stane deskriptorem `$2C`, obecným přímým výrazem. Text v závorkách se stane `$2D`, pokud nemá zvláštní podobu displacementu `ix` nebo `iy`.

Ještě nejde o kontrolu instrukce. `nonsense` může dočasně vypadat jako výraz. Pozdější fáze z něj buď vytvoří symbol, nebo odmítnou celou formu instrukce.

## IX a IY sdílejí většinu popisu

Z80 má paralelní rodiny instrukcí IX a IY. Tabulka obsahující každou formu dvakrát by plýtvala místem.

`normalizeIndexOperandClass` mapuje deskriptory IY na odpovídající varianty IX a nastaví `varcUseIYPrefix`:

```text
rozpoznej třídu ve tvaru IY
    → převeď ji na společnou tabulkovou třídu IX
    → zapamatuj si, že konečný prefix musí být FD místo DD
```

Tabulka instrukcí tak může popsat jednu společnou indexovou rodinu. Po nalezení odpovídajícího záznamu se informační bajt záznamu zdroje upraví tak, aby zaznamenal, zda uživatel napsal IX, nebo IY.

Jde o kompaktní formu normalizace:

> Při hledání odstraň nepodstatný rozdíl, zapamatuj si jej bokem a ve výsledku jej obnov.

## Několik operandů se kontroluje okamžitě podle rozsahu

Některé instrukce používají velmi malé literálové pole, které je ve skutečnosti součástí identity instrukce:

```asm
IM 0
BIT 7,A
RES 3,(HL)
SET 2,B
```

PROMETHEUS kontroluje první operand `IM`, `BIT`, `RES` a `SET` ještě před hlavním hledáním v tabulce instrukcí. Neplatné číslo bitu nelze považovat za libovolný výraz, protože příslušné bity jsou součástí samotného opcodu.

Je to užitečné rozlišení:

```text
LD A,VALUE      VALUE může zůstat nevyřešené až do sestavení
BIT 9,A         9 je neplatné okamžitě
```

Parser provádí časné kontroly tam, kde je vyžaduje tvar instrukce, a skutečné vyhodnocení adresy či hodnoty odkládá na průchody assembleru.

## Sbalení dvou tříd operandů do vyhledávacího klíče

Tabulka instrukcí ukládá kompaktní deskriptory operandů přes hranice bajtů. Po klasifikaci obou operandů PROMETHEUS zabalí jejich indexy do `D:E` pomocí posunů a rotací:

```asm
.packOperandClassesLoop:
    sla e
    rl d
    djnz .packOperandClassesLoop
```

Přesné rozložení bitů je při prvním čtení méně důležité než účel:

```text
třída prvního operandu + třída druhého operandu
        ↓
jeden kompaktní porovnávací klíč
```

Index mnemonic se připraví jako další klíč a parser prochází `instructionsTable`, dokud nenajde jeden pětibajtový záznam, v němž:

- odpovídá index mnemonic;
- odpovídá deskriptor prvního operandu;
- odpovídá deskriptor druhého operandu;
- je slučitelná rodina prefixu.

Právě zde se věrohodně vypadající řádek stane jednou přesnou formou instrukce Z80.

Samotné `LD` například nestačí. Tabulka rozlišuje:

```text
LD A,B
LD A,(HL)
LD HL,nn
LD (nn),A
LD (IX+d),n
```

Ústřední otázka parseru tedy nezní jen:

> Je `LD` známé slovo?

Zní:

> Existuje podporovaný záznam instrukce pro toto mnemonic a tyto dvě třídy operandů?

Neúspěch vyvolá `Bad instruction`, což je přesnější než `Bad mnemonic`.

## Tabulka instrukcí vrací připravená metadata

Po nalezení odpovídajícího pětibajtového záznamu získá PROMETHEUS:

- bajt opcodu;
- informaci o rodině prefixu;
- kompaktní třídu operandu či uložení potřebnou později;
- dostatek údajů k opětovné rekonstrukci mnemonic a operandů.

Parser nyní zná sémantický tvar řádku. Může začít zapisovat trvalý záznam.

## Sestavení hlavičky a volitelného labelu řádku

`initializeRecordHeaderAndOptionalLabel` dostane opcode v `E` a informační bajt v `D`.

Nejprve zapíše tyto dva bajty do `encodedRecordHeader`.

Potom zkontroluje, zda původní řádek začínal labelem. Pokud ano:

1. nastaví bit 3 informačního bajtu;
2. zavolá `findOrCreateSymbolOrdinal`;
3. označí horní bajt pořadového čísla bitem 7;
4. zapíše dvoubajtové pořadové číslo bezprostředně za hlavičku;
5. nastaví počáteční počet proměnlivých bajtů na dva.

Záznam zdroje uchovává číslo symbolu labelu, nikoli jeho zápis.

Zadání:

```asm
LOOP    DJNZ LOOP
```

tak může vytvořit `LOOP` v tabulce symbolů jen jednou, přestože jej řádek zmiňuje dvakrát:

- jednou jako label řádku;
- jednou jako výraz cíle skoku.

Oba výskyty v záznamu se stanou stejným pořadovým číslem.

## Výrazy se komprimují bez výpočtu

Assembler nemusí být schopen vypočítat výraz už při zadávání řádku. Dopředný odkaz může jmenovat label, který dostane adresu až v prvním průchodu sestavení.

Encoder proto kontroluje a komprimuje **syntaxi** výrazu, ale obvykle nepočítá konečnou hodnotu.

`encodeOperandExpression` prochází posloupnost atomů a operátorů.

Podporované operátory zahrnují:

```text
+   -   *   /   ?
```

Výraz může začínat unárním plusem nebo minusem. Unární plus se zahodí; unární minus se zachová, protože mění hodnotu.

Hrubý pseudokód:

```text
přečti volitelné počáteční znaménko

repeat:
    přečti jeden atom

    if atom je identifikátor:
        najdi nebo vytvoř symbol
        ulož označené dvoubajtové pořadové číslo
    else if atom je číslo:
        ověř radix a 16bitový rozsah
        ulož kanonický zápis
    else if atom je citovaný literál:
        ověř jednobajtovou nebo dvoubajtovou podobu
        ulož citovaný zápis
    else:
        chyba syntaxe

    if dosažena hranice výrazu:
        skonči

    vyžaduj jeden podporovaný operátor
```

Trvalý výraz zůstává dostatečně čitelný pro pozdější rozbalení, ale zápisy symbolů byly nahrazeny kompaktními odkazy.

## Identifikátory se mění na pořadová čísla symbolů

Test prvního písmene rozpozná atom připomínající symbol. PROMETHEUS dočasně přesune ukazatel identifikátoru do `HL` a zavolá `findOrCreateSymbolOrdinal`.

Potom zapíše:

```text
$80 | ordinalHigh
ordinalLow
```

Ukazatel ve zdroji se posune o délku identifikátoru, ale trvalý záznam naroste jen o dva bajty.

U dlouhého symbolu používaného mnohokrát jde o značnou úsporu.

Ještě důležitější je přímý vztah mezi zdrojem a správou symbolů. Pozdější kompakce symbolů musí pouze systematicky upravit pořadová čísla; zdrojové výrazy nikdy neobsahují křehké ukazatele do pohyblivé paměti.

## Čísla se kontrolují nyní, přestože se použijí až později

PROMETHEUS přijímá číselné podoby jako:

```text
1234       desítkově
%101101    binárně
#7FFF      šestnáctkově
```

Při kopírování textového zápisu do záznamu současně akumuluje číselnou hodnotu v `HL`.

Pro každou číslici:

```text
value = value * radix + digit
```

Násobení probíhá opakovaným 16bitovým sčítáním. Jakýkoli carry hlásí `Big number`. Stejnou chybovou cestu použije číslice mimo zvolený radix.

Proč kontrolovat číslo nyní, když assembler výraz později znovu vyhodnotí?

Protože chybný číselný text nezávisí na hodnotách symbolů. Odmítnutí už při zadání zabrání tomu, aby se neplatný záznam vůbec dostal do trvalého zdroje.

Malá šestnáctková písmena se v uloženém výrazu normalizují na velká. Dva ekvivalentní zápisy tak nevytvářejí zbytečné rozdíly v zobrazení.

## Citované atomy výrazu obsahují nejvýše dva bajty

Citovaný literál ve výrazu představuje jedno- nebo dvoubajtovou hodnotu. Encoder přijímá podle implementovaných pravidel prázdnou, jednoznakovou či dvouznakovou citovanou podobu, ponechá oddělující uvozovky a třetí datový znak odmítne chybou `Bad string`.

To se liší od `DEFM`, kde je datem celý řetězec a může být mnohem delší. Gramatiku určuje kontext.

PROMETHEUS se opět vyhýbá jednomu obrovskému univerzálnímu parseru. Pro běžné atomy výrazu používá malý parser a pro definiční záznamy vyhrazenou cestu.

## Hranice operandů se neukládají vždy stejně

Čárka mezi dvěma strojovými operandy je už reprezentována dvěma deskriptory operandů v tabulce instrukcí. Nemusí se zachovávat jako obyčejný text.

Obsahují-li oba operandy zakódovaný výrazový materiál, vloží PROMETHEUS mezi ně soukromý bajt `$1F`:

```asm
ld (ix+000h),01fh
```

Při rozbalování `$1F` řekne rendereru prvního výrazu, kde má skončit. Metadata mnemonic říkají rendereru, že existuje druhý operand, takže sám vypíše viditelnou čárku a pokračuje dalším výrazem.

Definiční seznamy, například:

```asm
        DEFB 1,2,3
```

jsou jiné. Jejich čárky patří do seznamu proměnlivé délky, takže zůstávají uvnitř payloadu definice.

Ukazuje to důležité pravidlo komprese:

> Neukládej interpunkci, pokud ji už určuje struktura; ulož ji, pokud počet položek jinak není znám.

## Definiční pseudo-instrukce používají specializovaný encoder

`DEFB`, `DEFM`, `DEFS` a `DEFW` se rozpoznají podle indexu mnemonic a namapují na pseudo-opcody `$06` až `$09`.

U seznamů výrazů PROMETHEUS spojí dočasné buffery prvního a druhého operandu, kde je to třeba, obnoví čárku a opakovaně volá encoder výrazu.

U `DEFM` ověří odpovídající uvozovky a zkopíruje celý citovaný řetězec. Na rozdíl od běžného literálu ve výrazu není řetězec `DEFM` omezen na dva datové bajty.

Záznam stále používá stejný vnější rámec:

```text
pseudo-opcode
informační bajt
volitelné pořadové číslo labelu řádku
zakódovaný payload definice
značka $C0+n
```

Formát je společný, gramatika payloadu specializovaná.

## Dokončení dočasného záznamu

Během celé konstrukce počítá `B` proměnlivé bajty za dvoubajtovou hlavičkou.

Finalizer je kompaktní:

```asm
.finalizeEncodedSourceRecord:
    ld a,b
    or a
    jr z,.storeEncodedRecordStorageLength
    set 7,b
    set 6,b
    ld (ix+000h),b
    inc a
.storeEncodedRecordStorageLength:
    add a,002h
    ld (encodedRecordStorageLength),a
    ret
```

Čtěme jej takto:

```text
if variableByteCount != 0:
    připoj $C0 + variableByteCount
    copyLength = variableByteCount + značka + hlavička
else:
    copyLength = pouze dvoubajtová hlavička

zveřejni copyLength před pracovním prostorem záznamu
```

`encodedRecordStorageLength` leží záměrně bezprostředně vedle bajtů záznamu, takže vkládací rutina může s dočasným výsledkem zacházet jako s:

```text
bajt délky následovaný datovými bajty
```

Do trvalého zdroje vstoupí pouze datové bajty.

## Obsluha chyb chrání trvalý zdroj

Encoder může hlásit:

- `Bad mnemonic`;
- `Bad operand`;
- `Bad instruction`;
- `Big number`;
- `Bad string`;
- `Syntax horror`;
- `Memory full` při pozdějším vkládání.

Všechny parserové chyby opustí zpracování společnými cestami stavového řádku ještě před voláním vkládacího primitiva.

Původní záznam zdroje proto zůstane zachován i v režimu OVERWRITE. PROMETHEUS nejprve nesmaže starý řádek a nedoufá, že náhrada projde parserem.

Pořadí stojí za výslovné uvedení:

```text
zakóduj nový řádek
vlož nový záznam
teprve potom v režimu overwrite smaž starý záznam
```

Editor dává přednost možnosti zotavení před nejmenším možným počtem přesunů paměti.

## Režimy vkládání a přepisování

Po zakódování vloží `parseAndInsertSourceLine` nový záznam bezprostředně za aktivní záznam a nastaví jej jako aktivní.

Je-li `varcInsertMode` nula, strukturální změna tím končí.

Je-li aktivní režim overwrite, PROMETHEUS se vrátí ke starému záznamu a smaže právě jeden záznam. Nově vložený záznam přežije a stane se logickou náhradou.

Ve zjednodušené podobě:

```text
old = active
newPosition = after(old)
insert(newRecord, newPosition)
active = newPosition

if overwrite:
    old = recordBefore(active)
    delete(old, jeden záznam)
```

Proč nejprve vložit a až potom mazat?

- neúspěšný parse nemůže zničit starý řádek;
- zakódovaný záznam existuje ještě před zahájením změny zdroje;
- společný mechanismus vkládání a mazání lze znovu použít beze změny.

## Sledujme `LOOP DJNZ LOOP`

Nyní projděme průběžný příklad:

```asm
LOOP    DJNZ LOOP
```

### 1. Rozdělení polí

Parser získá:

```text
label       "loop"
mnemonic    "djnz"
operand 1   "loop"
operand 2   prázdný
```

Slova mimo uvozovky se převedou na malá písmena.

### 2. Vyhledání mnemonic

`djnz` má délku čtyři. Vybere se bucket čtyřznakových slov a porovnání zabalených slov vrátí index mnemonic pro `DJNZ`.

### 3. Klasifikace operandu

`loop` není pevný zápis registru ani podmínky. Nezačíná znakem `(`. Stane se třídou přímého výrazu.

Druhý operand je prázdný a dostane třídu nula.

### 4. Shoda v tabulce instrukcí

Parser najde pětibajtový záznam popisující:

```text
mnemonic DJNZ
první operand = relativní výraz
druhý operand = žádný
opcode = $10
```

Výsledná informační třída zaznamená, že výraz je cílem relativního skoku se znaménkem.

### 5. Volitelný label

`LOOP` se najde nebo vytvoří v tabulce symbolů. Předpokládejme, že dostane pořadové číslo 37. Nastaví se bit 3 informačního bajtu a payload záznamu začne označeným pořadovým číslem 37.

### 6. Výraz operandu

Text operandu `LOOP` se převede na stejné pořadové číslo 37 a uloží jako další dvoubajtový označený odkaz.

### 7. Konečná značka

Proměnlivý payload obsahuje čtyři bajty:

```text
pořadové číslo labelu řádku    2 bajty
pořadové číslo cíle skoku      2 bajty
```

Konečná značka je `$C4`.

Pojmově má záznam podobu:

```text
$10, informationWithLabelAndRelativeClass,
$80|high(37), low(37),
$80|high(37), low(37),
$C4
```

Viditelný zápis `LOOP` se ve vstupním řádku objevuje dvakrát, ale v trvalém záznamu ani jednou. Jeho identitu nesou dvakrát stejná pořadová čísla.

### 8. Potvrzení

Počet bajtů se zveřejní, za aktivním záznamem se otevře prostor, bajty se zkopírují a nový záznam se stane aktivním.

Následující překreslení editoru zadaný text znovu nepoužije. Nový komprimovaný záznam čerstvě rozbalí. Jde o okamžitou kontrolu konzistence: na obrazovce se objeví to, co PROMETHEUS skutečně uložil.

## Zpět k celému editoru

Encoder zdroje je malý front end překladače, ale má pečlivě omezenou úlohu. Nepočítá konečné adresy ani neemituje strojový kód. Připravuje řádek pro tyto pozdější úlohy.

Jeho výstup už rozhodl několik otázek:

- které mnemonic bylo míněno;
- která přesná forma instrukce odpovídala;
- která rodina prefixu se použije;
- zda řádek definuje label;
- které operandy jsou pevné názvy a které výrazy;
- kde se objevují názvy symbolů;
- kterou třídu uložení výrazu musí assembler použít.

Trvalý záznam zdroje proto není jen komprimovaný text. Je cacheovaným výsledkem parsování.

Proto může být druhý průchod sestavení mnohem menší než u běžného assembleru, který pokaždé začíná od surových znaků.

## Co se změnilo v paměti?

Před úspěšným potvrzením:

- normalizované řetězce labelu, mnemonic a operandů zabírají sdílené dočasné buffery;
- `varcMnemonicIndex`, `varcFirstOperandClass`, `varcSecondOperandClass` a `varcUseIYPrefix` drží stav parseru uvnitř operandů instrukcí;
- kandidátní záznam zabírá pracovní prostor `encodedRecord...`;
- nově nalezené identifikátory už mohly dostat pořadová čísla symbolů.

Po finalizaci:

- `encodedRecordStorageLength` obsahuje počet trvalých bajtů;
- kandidátní záznam má úplnou hlavičku a volitelnou koncovou značku.

Po vložení:

- oblast zdroje a symbolů se mohla posunout nahoru;
- ukazatele na místě vložení nebo nad ním byly opraveny;
- `varcSourceBufferActiveLine` ukazuje na nový záznam;
- režim overwrite mohl odstranit předchozí starý záznam;
- `varcInsertMode` se pro další zadání vrátí do INSERT.

## Důležité myšlenky pro další kapitoly

- parsování a trvalé vložení jsou dvě oddělené operace;
- značka kurzoru je pro čtečky polí neviditelná;
- text parseru mimo uvozovky se normalizuje na malá písmena;
- komentáře zcela obcházejí parsování instrukce;
- vyhledání mnemonic a pevného operandu nejprve vybere bucket přesné délky;
- text operandu se klasifikuje dřív, než jsou známy hodnoty výrazů;
- IX a IY sdílejí normalizované tabulkové popisy;
- jeden přesný záznam tabulky instrukcí musí odpovídat mnemonic i oběma operandům;
- labely řádků i identifikátory ve výrazech se mění na pořadová čísla symbolů;
- zápis čísla se zachová, ale ověří proti 16bitovému rozsahu;
- `$1F` interně odděluje dva zakódované výrazové operandy;
- definiční seznamy zachovávají čárky, protože počet jejich položek je proměnlivý;
- záznam se potvrdí až po úplném úspěšném zakódování;
- overwrite nejprve vloží náhradu a teprve potom smaže starý záznam.

## Vysvětlené orientační body ve zdroji

- `parseAndInsertSourceLine`
- `encodeInputLineToSourceRecord`
- `.encodeCommentSourceRecord`
- `readSourceFieldUntilSpace`
- `readFirstOperandUntilComma`
- `readSecondOperandToEnd`
- `skipSpaces`
- `atHLorNextIfOne`
- `lengthUpToZero`
- `mnemonicLookupByLengthDescriptors`
- `operandLookupByLengthDescriptors`
- `prepareLengthBucketLookup`
- `compareWithMnemonics`
- `validateParsedOperandBuffers`
- `classifyOperandText`
- `normalizeIndexOperandClass`
- `varcMnemonicIndex`
- `varcFirstOperandClass`
- `varcSecondOperandClass`
- `varcUseIYPrefix`
- `instructionsTable` na úrovni zadávání zdroje
- `initializeRecordHeaderAndOptionalLabel`
- `encodeOperandExpression`
- `encodeQuotedOrNumericAtom`
- `convertInputCharacterToRadixDigit`
- `.encodeDefinitionPseudoInstruction`
- `.encodeDefmStringLiteral`
- `.finalizeEncodedSourceRecord`
- `encodedRecordStorageLength`
- `encodedRecordHeader`
- `varcInsertionPointForPointerAdjustment`
- `insertByteRangeAtHLFromDE` na úrovni potvrzení
- `varcInsertMode`
- `badMnemonicError`
- `badOperandError`
- `badInstructionError`
- `bigNumberError`
- `badStringError`
- `syntaxError`
