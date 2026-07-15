# Kapitola 20: Jak PROMETHEUS rozpoznává slova

Člověk tento řádek pochopí okamžitě:

```asm
LOOP    DJNZ LOOP
```

Je v něm label jménem `LOOP`, instrukce `DJNZ` a operand odkazující na tentýž label.

PROMETHEUS s takovým porozuměním začít nemůže. Dostane znaky v editačním bufferu. Musí rozhodnout, která skupina znaků je mnemonic, zda je její zápis platný a jaké kompaktní číslo ji má reprezentovat v záznamu zdroje.

Velký moderní assembler by mohl použít hashovací tabulku plnou struktur a ukazatelů. PROMETHEUS používá něco mnohem menšího:

1. převede slovo na malá písmena;
2. změří jeho délku;
3. podle délky vybere malý bucket kandidátů;
4. porovná je se zabalenými slovy ukončenými vysokým bitem;
5. vrátí kompaktní index slova.

Tentýž mechanismus rozpoznává pevné operandy jako `A`, `HL`, `NZ`, `(HL)` a `AF'`.

Tato kapitola pojednává o tomto slovníkovém mechanismu. Zároveň ukazuje obecnější návrhovou lekci: je-li paměti málo, rozpoznání slova může být levnější, když program nejprve položí velmi jednoduchou otázku, která odstraní většinu kandidátů.

## Rozpoznávání začíná po rozdělení polí

Kapitola 13 ukázala, jak `encodeInputLineToSourceRecord` rozdělí řádek zdroje do dočasných polí:

```text
naparsovaný label
parsedMnemonicBuffer
varLowercasedOperands
commandArgumentBuffer
```

Písmena mimo řetězce v uvozovkách se normalizují na malá. Mnemonic `DJNZ`, `djnz` i smíšený zápis `DjNz` se proto všechny změní na:

```text
djnz\0
```

Encoder poté změří délku mnemonic:

```asm
    push hl
    call lengthUpToZero
    ld hl,mnemonicLookupByLengthDescriptors
    call prepareLengthBucketLookup
    pop hl
    call compareWithMnemonics
    jp c,badMnemonicError
```

Tento krátký úsek obsahuje celou strategii rozpoznávání.

`lengthUpToZero` vrátí délku v `B`. Tabulka descriptorů převede tuto délku na:

- počet kandidátních slov;
- ukazatel na první zabalené slovo této délky.

`compareWithMnemonics` testuje pouze tyto kandidáty. Nastavený carry znamená, že se žádný neshodoval.

## Proč je délka tak užitečnou první otázkou

Představme si, že úplný slovník mnemonic obsahuje slova jako:

```text
cpi  cpir  djnz  ex  exx  ld  lddr  nop  reti  rlca
```

Má-li kandidát čtyři znaky, nemůže jít o `EX`, `LD` ani `NOP`. Není důvod porovnávat ani jejich první písmeno.

PROMETHEUS rozděluje slovník mnemonic do čtyř užitečných délek:

```text
jednoznakové zvláštní tvary
dvouznakové mnemonic
tříznakové mnemonic
čtyřznakové mnemonic
```

Rekonstruované bajty descriptorů nám říkají velikosti bucketů:

```text
délka 1:  1 kandidát
délka 2: 12 kandidátů
délka 3: 41 kandidátů
délka 4: 23 kandidátů
```

Dohromady popisují 77 prohledávaných zápisů. Index mnemonic nula je samostatně vyhrazen záznamu obsahujícímu pouze label nebo žádnou mnemonic; prohledávaná množina zahrnuje také názvy pseudo-operací používané jazykem záznamů editoru.

Chybně napsané pětiznakové mnemonic nemusí prohledávat vůbec nic. Editor již omezil pole mnemonic na pět znaků, ale legální zabalený slovník je uspořádán kolem skutečných krátkých slov Z80 a direktiv zdroje.

Není to tak rychlé jako dokonalý moderní lookup. Je to však kompaktní, předvídatelné a dostatečné pro člověka zadávajícího na Spectru jeden řádek za druhým.

## Tabulka descriptorů, která vypadá jako strojový kód

Descriptor bucketů mnemonic je zapsán takto:

```asm
mnemonicLookupByLengthDescriptors:
    defw mnemonicsReferences
    defb 0x01
    ld bc,0020ch
    add hl,hl
    ld c,017h
    scf
```

Na první pohled to vypadá jako krátká a poněkud podivná rutina Z80. Nespouští se.

Za počátečním ukazatelem následují dvojice datových bajtů:

```text
(počet kandidátů, offset do referenčního vektoru)
```

Náhodou se disassemblují jako instrukce, protože každou posloupnost bajtů lze interpretovat jako nějaké instrukce Z80. Původní program šetří bajty zdroje tím, že nechává assembler emitovat vhodné hodnoty prostřednictvím syntaxe instrukcí. Komentáře rekonstrukce odhalují zamýšlený význam dat.

Logický descriptor pro mnemonic je:

```text
base pointer = mnemonicsReferences

délka 1 → počet  1, offset vektoru  1
délka 2 → počet 12, offset vektoru  2
délka 3 → počet 41, offset vektoru 14
délka 4 → počet 23, offset vektoru 55
```

Operandy mají vlastní tabulku:

```asm
operandLookupByLengthDescriptors:
    defw operandsReferences
    defb 0x0c
    add hl,bc
    rrca
    dec d
    ld (bc),a
    inc h
    ld b,026h
```

Její logický obsah je:

```text
délka 1 → počet 12, offset vektoru  9
délka 2 → počet 15, offset vektoru 21
délka 3 → počet  2, offset vektoru 36
délka 4 → počet  6, offset vektoru 38
```

Jakmile čtenář tento idiom rozpozná, zdánlivý kód přestane být záhadný. Je to malý kompaktní index.

## Dvě úrovně nepřímosti

Bucket neukazuje přímo do jediné dlouhé tabulky zápisů. Nejprve zvolí položku v **samovztažném referenčním vektoru**.

Vektor mnemonic začíná:

```asm
mnemonicsReferences:
    defb 000h
    defb 04dh
mnemonics00:
    defb mnemonicsTable00-mnemonics00
mnemonics01:
    defb mnemonicsTable01-mnemonics01
    ; ...
```

Každý běžný bajt vektoru říká:

```text
spellingAddress = addressOfThisVectorByte + signedByteStoredHere
```

Cílem je jeden zápis ukončený vysokým bitem v `mnemonicsTable`.

Například zabalená slova poblíž začátku jsou uložena takto:

```asm
mnemonicsTable00: defb "c",0xF0
mnemonicsTable01: defb "d",0xE9
mnemonicsTable02: defb "e",0xE9
```

Vysoký bit označuje poslední znak. Po zamaskování bitu 7 se odhalí zápisy jako:

```text
cp
di
ei
```

Pozdější položky zahrnují:

```asm
mnemonicsTable53: defb "cal",0xEC
mnemonicsTable56: defb "def",0xE2
mnemonicsTable60: defb "djn",0xFA
mnemonicsTable71: defb "ret",0xE9
```

které se dekódují jako:

```text
call
defb
djnz
reti
```

Proč používat referenční vektor místo uložení slov přímo v pořadí bucketů?

Protože tentýž kompaktní index je užitečný v obou směrech:

- při zadávání textu se najde zápis a vrátí se jeho číselný index mnemonic;
- při expanzi zdroje se začne indexem a přes vektor se obnoví zápis.

Slovník tedy slouží encoderu i decoderu.

## Výběr bucketu délky

`prepareLengthBucketLookup` provádí adresní aritmetiku:

```asm
prepareLengthBucketLookup:
    ld a,b
    add a,a
    ld c,a
    xor a
    ld b,a
    push hl
    add hl,bc
    ld b,(hl)
    inc hl
    ld c,(hl)
    pop hl
    ld e,(hl)
    inc hl
    ld d,(hl)
    ld h,a
    ld l,c
    add hl,de
    ld e,(hl)
    ld d,a
    add hl,de
    ex de,hl
    ret
```

Rutina je hutná, protože spojuje několik malých úkolů.

V próze:

```text
vstup:
    B  = délka kandidátního slova
    HL = adresa tabulky descriptorů bucketů podle délky

načti:
    základní ukazatel tabulky
    počet kandidátů této délky
    offset referenčního vektoru pro tuto délku

následuj:
    samovztažný displacement položky vektoru

výstup:
    B  = počet zabalených slov k vyzkoušení
    C  = logický index prvního kandidáta
    DE = adresa prvního zabaleného zápisu
```

Násobení dvěma je zde pouze proto, že každý bucket délky zabírá dva bajty.

Po návratu této rutiny už obecný comparator nemusí vědět, zda zpracovává mnemonic nebo operandy. Má kandidátní řetězec v `HL`, zabalený zápis v `DE`, počet v `B` a první logický index v `C`.

## Porovnání běžného řetězce se zabalenými slovy

Comparator se jmenuje `compareWithMnemonics`, ačkoli zpracovává také pevné operandy.

Jeho ústřední smyčka je:

```asm
.compareLookupWordCharacters:
    ld a,(de)
    and 07fh
    cp (hl)
    jr nz,.skipMismatchedLookupWord
    ld a,(de)
    inc hl
    inc de
    and 080h
    jr z,.compareLookupWordCharacters
```

Pro každý zabalený znak:

1. vymaže vysoký ukončovací bit;
2. porovná výsledný znak s normalizovaným vstupem;
3. po shodě posune oba ukazatele;
4. otestuje vysoký bit původního zabaleného bajtu;
5. pokračuje, dokud se neshoduje koncový znak.

Úplná shoda vrátí aktuální index v `A`:

```asm
    pop hl
    xor a
    ld a,c
    ret
```

Při neshodě nelze jednoduše posunout ukazatel o jeden bajt, protože zabalená slova mají různé délky. Rutina scanuje `DE` dopředu, dokud nenajde poslední znak označený vysokým bitem, zvýší logický index a zkusí dalšího kandidáta:

```asm
.skipMismatchedLookupWord:
    pop hl
.scanToLookupWordTerminatorLoop:
    ld a,(de)
    and 080h
    inc de
    jr z,.scanToLookupWordTerminatorLoop
    inc c
    djnz compareWithMnemonics
    scf
    ret
```

Všimněte si, že `HL`, ukazatel na kandidátní vstup, se před každým dalším pokusem obnoví. Ukazatel do zabalené tabulky zůstane na následujícím slově.

V pseudokódu:

```text
for index v candidateRange:
    if input se rovná packedWordIgnoringFinalHighBit:
        return index
    packedPointer = pozice za aktuálním packedWord

return NOT_FOUND
```

## Cesta `DJNZ` slovníkem

Sledujme mnemonic z našeho průběžného příkladu.

Normalizovaný vstup je:

```text
d j n z 0
```

`lengthUpToZero` vrátí 4.

Descriptor čtyřznakového bucketu poskytne:

```text
23 kandidátů
počínaje indexem mnemonic 55
```

`prepareLengthBucketLookup` následuje odpovídající položku vektoru k prvnímu zabalenému čtyřznakovému zápisu.

`compareWithMnemonics` zkouší bucket v pořadí. Když dorazí k:

```asm
mnemonicsTable60: defb "djn",0xFA
```

porovná:

```text
'd' s 'd'
'j' s 'j'
'n' s 'n'
($FA & $7F) = 'z' se 'z'
```

Vysoký bit v `$FA` říká, že slovo zde končí. Comparator vrátí index mnemonic v `A` a encoder tento index uloží do metadat instrukce v záznamu zdroje.

Pokud uživatel napíše `DJNX`, délka bude stále vyhovovat, ale poslední znak selže. Po vyčerpání všech 23 kandidátů se nastaví carry a `badMnemonicError` zvolí hlášení `Bad mnemonic`.

## Pevné operandy používají tentýž recognizer

Krátký operand se nejprve porovnává s `operandsReferences` a `operandsTable`.

Zabalený slovník obsahuje:

- registry jako `A`, `B`, `HL`, `IX` a `IY`;
- dvojice registrů jako `BC`, `DE`, `SP` a `AF`;
- podmínky jako `NZ`, `Z`, `NC`, `C`, `PO`, `PE`, `P` a `M`;
- pevné tvary v závorkách jako `(BC)`, `(DE)`, `(HL)`, `(IX)`, `(IY)` a `(SP)`;
- zvláštní zápisy jako `AF'`.

Tabulka zdroje vypadá podivně, protože ukončení vysokým bitem se znovu mísí s krátkými řetězci:

```asm
operandsTable35: defb "(c",0xA9
operandsTable36: defb "af",0xA7
operandsTable37: defb "(bc",0xA9
operandsTable39: defb "(hl",0xA9
operandsTable40: defb "(ix",0xA9
```

Po vymazání bitu 7 je `$A9` znak `')'` a `$A7` apostrof. Vznikne:

```text
(c)
af'
(bc)
(hl)
(ix)
```

Vrácený index operandu není pouhým číslem zápisu. Je to **třída operandu** používaná při hledání v tabulce instrukcí.

Například pevný registr `B` a pevná podmínka `NZ` dostanou odlišná čísla tříd, přestože jde v obou případech o krátká slova. Tato čísla umožní PROMETHEU rozlišit:

```asm
LD B,5
JR NZ,LOOP
```

aniž by při hledání instrukce nesl jejich text.

## Rozpoznání mnemonic ještě neznamená rozpoznání instrukce

Předpokládejme, že lookup mnemonic vrátí index pro `LD`.

To zdaleka nestačí. Z80 má mnoho tvarů `LD`:

```asm
LD B,C
LD B,5
LD BC,1234
LD A,(HL)
LD (32768),HL
LD IX,(TABLE)
```

Parser musí spojit:

```text
index mnemonic
třídu prvního operandu
třídu druhého operandu
```

a najít jediný přesný záznam v `instructionsTable`.

Tabulka obsahuje **687 záznamů**, každý přesně pět bajtů dlouhý. Zabírá tedy 3 435 bajtů — podle měřítek PROMETHEA hodně, stále však podstatně méně než plná textová syntaxe a emitovací kód pro každý tvar.

Reprezentativní záznamy jsou v rekonstruované tabulce dokumentovány takto:

```asm
; ld b,N
    defb 0x06,0x01,0x14,0x55,0x87

; djnz N
    defb 0x10,0x03,0x7d,0x60,0x08

; ld hl,N
    defb 0x21,0x02,0x14,0xc5,0x8a

; ld ix,N
    defb 0x21,0x22,0x14,0xdd,0x8e
```

Pět bajtů kombinuje několik polí:

```text
bajt 0  základní opcode nebo pseudo-opcode
bajt 1  prefix a informace o tvaru instrukce
bajt 2  zabalený klíč mnemonic
bajt 3  zabalené informace o třídách operandů
bajt 4  zbývající informace o operandu, velikosti a časování
```

Přesné rozbalení bitů sdílejí editor, assembler, disassembler i engine provádění. Vrátíme se k němu z těchto různých směrů.

Při zadávání zdroje je důležité, že PROMETHEUS převedl slova na čísla ještě před scanem tabulky.

## Zabalení vyhledávacího klíče

Po klasifikaci obou operandů encoder normalizuje varianty IX/IY a zabalí obě třídy operandů:

```asm
varcSecondOperandClass:
    ld a,000h
    call normalizeIndexOperandClass
    add a,a
    add a,a
    ld e,a
varcFirstOperandClass:
    ld a,000h
    call normalizeIndexOperandClass
    ld d,a
    ld b,003h
.packOperandClassesLoop:
    sla e
    rl d
    djnz .packOperandClassesLoop
```

Výsledek v `D:E` je uspořádán do stejných kompaktních bitových pozic, jaké používají pětibajtové záznamy instrukcí.

Index mnemonic se rovněž rotuje do porovnávacího tvaru očekávaného tabulkou:

```asm
varcMnemonicIndex:
    ld a,000h
    rla
```

V této chvíli textový zdroj z problému hledání zmizel. Parser drží malý číselný podpis:

```text
(klíč mnemonic, třída prvního operandu, třída druhého operandu, varianta indexového prefixu)
```

## Hledání mezi 687 tvary instrukcí

Encoder umístí `HL` těsně před `instructionsTable` a předá instrukci `CPI` omezený počet bajtů:

```asm
    ld hl,instructionsTable-2
    ld bc,INSTRUCTIONS_TABLE_SIZE
```

Scan postupuje záznamy, nejprve porovnává zabalený bajt mnemonic a potom zabalená pole operandů:

```asm
    cpi
    jp po,badInstructionError
    jr nz,.scanInstructionTableOuter
    ; ...
    cp d
    jr nz,.scanInstructionTableRecord
    ; ...
    cp e
    jr nz,.scanInstructionTableRecord
```

Shodující se mnemonic s neodpovídajícími operandy není platnou instrukcí. Scan pokračuje dalšími tvary téže mnemonic.

Toto rozlišení poskytuje dvě užitečné úrovně chyb:

- `Bad mnemonic`: samotné slovo je neznámé;
- `Bad instruction`: mnemonic existuje, ale žádný legální tvar neodpovídá zadaným operandům.

Například:

```asm
FLY A,B        ; Bad mnemonic
LD BC,DE       ; LD exists, BC and DE exist, but this form is not a Z80 LD
```

Druhý řádek rozpoznávání slov neodmítne. Přežije až do kombinovaného hledání tvaru instrukce.

## Proč je tabulka seřazena podle opcode

Při zadávání zdroje je jednoduchý omezený lineární scan přijatelný. Tatáž tabulka se však používá také opačným směrem při expanzi záznamů zdroje a disassemblování paměti. Tehdy program začíná opcodem a rodinou prefixů.

Záznamy jsou uspořádány především podle opcode. Decoder proto může použít hledání s postupně půleným krokem místo toho, aby u každé instrukce začínal od prvního záznamu.

Je to dobrý příklad jediné tabulky sloužící několika směrům:

```text
text → třídy mnemonic/operandů → záznam instrukce
záznam instrukce → kanonický text zdroje
bajty opcodu → záznam instrukce → text disassemblování
záznam instrukce → metadata provádění/časování
```

Tabulka zvolená pouze pro rychlé zadávání zdroje by mohla být uspořádána podle mnemonic. PROMETHEUS přijímá poněkud méně přímé hledání encoderu, protože pořadí podle opcode prospívá také decoderu a monitoru.

## Text existuje na okrajích, uprostřed jsou indexy

Pipeline rozpoznávání můžeme shrnout takto:

```text
lidský zápis
    ↓ normalizuj a změř
slovník zabalených slov
    ↓
indexy mnemonic/operandů
    ↓ zabal
pětibajtový záznam instrukce
    ↓
komprimovaná metadata zdroje
```

Při cestě zpět na obrazovku se směr obrátí:

```text
komprimovaná metadata zdroje
    ↓
pětibajtový záznam instrukce
    ↓
indexy mnemonic/operandů
    ↓ následuj samovztažné vektory
zabalené zápisy
    ↓ vymaž poslední vysoký bit
člověkem čitelný zdroj
```

Ústřední reprezentace je číselná. Text se rekonstruuje pouze pro lidi.

## V prostém pseudokódu

Lookup mnemonic:

```text
function lookupMnemonic(text):
    text = lowercase(text)
    length = countCharacters(text)
    bucket = mnemonicBuckets[length]

    for index v rozsahu bucket.firstIndex .. bucket.lastIndex:
        if text == packedMnemonic[index]:
            return index

    error “Bad mnemonic”
```

Lookup pevného operandu:

```text
function lookupFixedOperand(text):
    if length(text) >= 5:
        return NOT_FIXED

    bucket = operandBuckets[length(text)]

    for class v bucket:
        if text == packedOperand[class]:
            return class

    return NOT_FIXED
```

Lookup tvaru instrukce:

```text
function lookupInstruction(mnemonic, operand1, operand2):
    key = pack(mnemonic.index,
               normalizeIXIY(operand1.class),
               normalizeIXIY(operand2.class))

    for record v instructionTable:
        if record.key == key:
            return record s vybraným prefixem IX/IY

    error “Bad instruction”
```

## Co se změnilo v paměti

Během rozpoznávání jednoho zadaného řádku:

- `parsedMnemonicBuffer` obsahuje normalizovaný text mnemonic;
- buffery operandů obsahují normalizované zápisy operandů;
- `varcMnemonicIndex+1` je opraven vybraným indexem mnemonic;
- `varcFirstOperandClass+1` a `varcSecondOperandClass+1` obsahují klasifikované operandy;
- `varcUseIYPrefix+1` zaznamenává, zda se mají sdílená metadata IX změnit na FD/IY;
- vybraný záznam instrukce dodá dva trvalé bajty hlavičky zdroje;
- původní viditelný zápis už není potřeba kromě materiálu výrazů a jmen symbolů.

Samotné tabulky zabalených slov jsou pouze pro čtení.

## Důležité labely a tabulky, se kterými jsme se setkali

- `parsedMnemonicBuffer`
- `mnemonicLookupByLengthDescriptors`
- `operandLookupByLengthDescriptors`
- `prepareLengthBucketLookup`
- `compareWithMnemonics`
- `mnemonicsReferences`
- `mnemonicsTable`
- `operandsReferences`
- `operandsTable`
- `varcMnemonicIndex`
- `varcFirstOperandClass`
- `varcSecondOperandClass`
- `instructionsTable`
- `INSTRUCTIONS_TABLE_SIZE`

## Co přijde dál

Rozpoznávání slov zvládá snadné operandy: registry, podmínky a několik pevných tvarů v závorkách.

Mnohé operandy však vůbec nejsou slovníkovými slovy:

```asm
5
TABLE+2
(32768)
(IX-4)
"A"
$
```

Příští kapitola ukáže, jak PROMETHEUS odděluje tyto strukturální tvary, jak normalizuje IX a IY bez zdvojení tabulky instrukcí a jak se několik velmi odlišně vypadajících operandů zdroje změní na malou sadu tříd ještě před zapojením evaluatoru výrazů.
