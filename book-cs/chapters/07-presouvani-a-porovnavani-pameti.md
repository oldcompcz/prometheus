# Kapitola 7: Přesouvání a porovnávání paměti

Textový editor na moderním počítači může operační systém požádat o větší blok paměti pokaždé, když dokument naroste. PROMETHEUS nemůže. Žije uvnitř jediného pevného 64kilobajtového adresního prostoru, jehož většinu už zabírá ROM, obrazovka, systémové proměnné, rezidentní program, uživatelův zdroj, symboly a nakonec také sestavený výsledek.

Když se řádek zdroje prodlouží, PROMETHEUS nezíská nový kontejner. Otevře mezeru uvnitř existujícího.

Když se řádky smažou, mezeru znovu uzavře.

Když se symboly vkládají v abecedním pořadí, přesune všechna následující data symbolů.

Když se kopíruje vybraný blok, musí počítat s tím, že se zdrojový a cílový rozsah mohou překrývat.

Přesouvání paměti proto není drobnou pomocnou funkcí schovanou na okraji programu. Je jedním z mechanismů, které vůbec umožňují existenci editoru.

Totéž platí pro porovnávání. PROMETHEUS se opakovaně ptá například:

- Leží tato adresa před oblastí zdroje?
- Je pod `U-TOP` dost místa?
- Leží tento ukazatel na místě vložení bajtů nebo za ním?
- Posunul se kurzor zdroje za poslední skutečný záznam?
- Leží cíl nad zdrojem, takže by kopírování dopředu zničilo bajty, které ještě potřebujeme?

Na Z80 se na podobné otázky obvykle odpovídá odečtením a příznakem carry. Neexistuje samostatná instrukce ve smyslu „porovnej tyto dvě šestnáctibitové adresy a vrať logickou hodnotu“. PROMETHEUS tento význam skládá z menších operací.

Tato kapitola sleduje celou cestu od jednoduché rutiny pro kopírování bezpečné při překryvu až po vkládání a mazání zdroje. Uvidíme přitom, že PROMETHEUS chápe ukazatele jako součást pohybující se struktury, nikoli jako izolovaná čísla.

## Problém police s knihami

Představme si polici s knihami bez volného místa mezi nimi:

```text
[A][B][C][D][E][F]
```

Chceme vložit dvě nové knihy před `C`. Nejprve musíme posunout `C` až `F` o dvě pozice doprava:

```text
[A][B][ ][ ][C][D][E][F]
```

Teprve potom lze nové knihy vložit do mezery.

Představme si však, že knihy přesouváme po jedné zleva doprava:

1. zkopíruj `C` na první novou pozici;
2. zkopíruj `D` na další;
3. pokračuj dál.

Zní to rozumně, ale při nevhodném překryvu první kopie přepíše původní `E`. Přesunutá kopie `C` se pak může zkopírovat znovu, jako by šlo o původní data. Police se poškodí.

Bezpečná metoda začíná na vzdáleném konci:

1. nejprve přesuň `F`;
2. potom `E`;
3. pokračuj pozpátku, dokud se nepřesune `C`.

Při mazání, kdy se následující bajty přesouvají směrem k nižším adresám, je naopak bezpečné kopírovat od začátku.

Z toho plyne pravidlo používané v celém PROMETHEU:

```text
if destination leží nad source:
    kopíruj pozpátku
else:
    kopíruj dopředu
```

Rutina toto konzervativní pravidlo používá i tehdy, když se rozsahy ve skutečnosti nepřekrývají. Kopírování pozpátku je stále správné; jde prostě o bezpečnou volbu pro každý přesun vzhůru.

## Z80 už umí kopírovat posloupnost

Z80 nabízí blokové kopírovací instrukce:

- `LDIR` kopíruje dopředu;
- `LDDR` kopíruje pozpátku.

Obě opakovaně přenesou jeden bajt z `(HL)` do `(DE)` a upravují ukazatele i počet v `BC`.

Pro `LDIR`:

```text
(HL) → (DE)
HL = HL + 1
DE = DE + 1
BC = BC - 1
repeat until BC = 0
```

U `LDDR` se ukazatele místo toho pohybují dolů.

PROMETHEUS tyto instrukce obaluje rutinou s významem podobným funkci knihovny C obvykle nazývané `memmove`: zkopíruj rozsah správně i tehdy, když se zdroj a cíl překrývají.

```asm
moveMemoryBlockOverlapSafe:
    ld a,b
    or c
    ret z
    push hl
    xor a
    sbc hl,de
    pop hl
    jr c,.moveMemoryBlockBackward
    ldir
    ret
.moveMemoryBlockBackward:
    add hl,bc
    dec hl
    ex de,hl
    add hl,bc
    dec hl
    ex de,hl
    lddr
    ret
```

Její kontrakt je:

```text
HL = zdrojová adresa
DE = cílová adresa
BC = počet bajtů
```

První tři instrukce testují přesun nulové délky. `OR C` spojí obě poloviny počtu pouze pro nastavení příznaků. Jsou-li obě nulové, není co dělat.

Následující porovnání dočasně vypočte:

```text
source - destination
```

`XOR A` vynuluje carry před `SBC HL,DE`. Leží-li source pod destination, odečtení si musí vypůjčit a carry se nastaví. To je nebezpečný případ přesunu vzhůru, takže rutina zvolí cestu pozpátku.

Všimněte si `PUSH HL` a `POP HL`. Odečtení je použito pouze kvůli příznakům. Původní ukazatel zdroje se musí před zahájením kopírování obnovit.

## Proč kopírování pozpátku začíná posledním bajtem

`LDDR` očekává, že `HL` a `DE` ukazují na poslední kopírované bajty, nikoli na první. Volající předává začátky rozsahů, a proto PROMETHEUS oba ukazatele upraví:

```asm
add hl,bc
 dec hl
```

Pojmově:

```text
lastSource = source + length - 1
```

Stejný výpočet se po prohození `HL` a `DE` provede pro cíl.

Pro čtyřbajtový přesun:

```text
source začíná na S
poslední zdrojový bajt = S + 4 - 1 = S + 3
```

`-1` je důležité. `source + length` je adresa bezprostředně za rozsahem. PROMETHEUS často používá tuto konvenci **výlučného konce**, protože usnadňuje výpočet délek:

```text
length = exclusiveEnd - start
```

`LDDR` však potřebuje včetně posledního bajtu, proto rutina jednou sníží adresu.

## Rutina může vrátit odpověď v příznacích a zachovat otázku

Uvažujme tuto pomocnou rutinu:

```asm
compareHLWithSourceBufferStart:
    push hl
    push de
    ld de,sourceBufferAccessLine
    and a
    sbc hl,de
    pop de
    pop hl
    ret
```

Rutina porovná adresu v `HL` s trvalým začátkem zdrojového bufferu. Nastavené carry znamená, že kandidát leží pod touto hranicí.

Přesto se vrací s obnovenými `HL` i `DE`.

Jde o běžný vzor PROMETHEA:

1. ulož hodnoty;
2. proveď odečtení;
3. obnov hodnoty instrukcemi, které nemění příznaky;
4. vrať výsledek porovnání v carry a zero.

`POP` příznaky nemění, takže odpověď přežije.

V pseudokódu:

```text
function compareWithSourceStart(candidate):
    flags = subtract(candidate, sourceBufferAccessLine)
    return candidate beze změny, flags
```

Je to užitečné, protože volající často chce kandidátní adresu dál používat, pokud je platná.

Přesun k předchozímu záznamu zdroje například provede:

```asm
call getRecordBeforeActiveLine
call compareHLWithSourceBufferStart
ccf
jr .commitActiveLineMoveIfValid
```

Ukazatel na záznam zůstává v `HL`. Pouze význam carry je obrácen tak, aby vyhovoval sdílené cestě potvrzení.

## Porovnání s pohyblivou horní hranicí

Dolní hranice zdroje je pevná, ale horní hranice se s růstem zdroje a symbolů posouvá.

`comparePositionWithCodeEnd` porovná kandidátní pozici zdroje se současnou kotvou tabulky symbolů:

```asm
comparePositionWithCodeEnd:
    push hl
    push de
    ld de,0000ch
    add hl,de
    ld de,(varcSymbolTablePt+1)
    and a
    sbc hl,de
    pop de
    pop hl
    ret
```

Přidaných dvanáct bajtů převede kandidáta záznamu zdroje na základ používaný rozložením editoru. Přesný posun patří k uspořádání okna zdroje a jeho konce, popsanému později. Podstatné je, že horní porovnání nepracuje s pevnou konstantou sestavení. Používá současný samomodifikovaný ukazatel tabulky symbolů.

Vzor zůstává stejný:

```text
uprav candidate na základ porovnání
odečti současnou pohyblivou hranici
obnov registry
return flags
```

Toto oddělení je cenné. Navigační kód nemusí vědět, jak je konec reprezentován. Zeptá se pomocné rutiny, zda je navržená pozice stále platná.

## Otevření mezery znamená víc než přesun bajtů

Představme si, že editor zakódoval nový šestibajtový záznam zdroje a chce jej vložit na adresu `P`.

Viditelná operace zní jednoduše:

```text
vlož šest bajtů na P
```

Ve skutečnosti se musí stát několik věcí:

1. ověřit, že se dalších šest bajtů vejde pod `U-TOP`;
2. přesunout všechny následující bajty zdroje a symbolů vzhůru;
3. zvýšit zapamatovaný konec použité paměti;
4. zvýšit zapamatovaný základ tabulky symbolů;
5. opravit ukazatele vybraného bloku, pokud odkazují na přesunuté záznamy;
6. zkopírovat nový záznam do mezery.

PROMETHEUS tuto práci soustřeďuje do `insertByteRangeAtHLFromDE`.

Její vstupní kontrakt je:

```text
HL = adresa vložení
DE = adresa vkládaných bajtů
BC = počet bajtů
```

Parser má obvykle jednobajtovou délku záznamu v `C`, takže veřejný vstup začíná vynulováním `B`:

```asm
insertByteRangeAtHLFromDE:
    ld b,000h
.insertByteRangeCommon:
```

Příkaz kopírování bloku může vstoupit na `.insertByteRangeCommon` s plnou šestnáctibitovou délkou.

## Nejprve se zeptejme, zda je nový konec legální

Kontrola kapacity je stručná:

```asm
ensureBCBytesFitBelowUTop:
    push hl
    push de
    ld hl,(varcCodeEndPt+1)
    add hl,bc
    jr c,.memoryFullError
    ld de,(varcUTop+1)
    sbc hl,de
    pop de
    pop hl
    ret c
```

Navržený nový konec je:

```text
currentCodeEnd + insertedLength
```

Mohou nastat dvě chyby.

### Chyba 1: součet přeteče přes konec adresního prostoru

Šestnáctibitový součet větší než `$FFFF` se přetočí zpět na začátek paměti. Carry to okamžitě odhalí.

Bez této kontroly by zdánlivě malý výsledek mohl být omylem považován za množství volné paměti.

### Chyba 2: výsledek dosáhne U-TOP nebo jej překročí

`U-TOP` je výlučný strop zvolený uživatelem. Nový konec musí zůstat přísně pod ním.

Odečtení:

```text
newEnd - UTop
```

nastaví carry pouze tehdy, když `newEnd < UTop`. To je podmínka úspěchu.

Rutina zachovává volajícího `HL` a `DE`; znovu jsou důležité pouze příznaky a případná chybová cesta.

## Výpočet konce, který se musí přesunout

Vkládací rutina načte současný horní konec a odečte adresu vložení. Výsledkem je počet existujících bajtů na místě vložení a nad ním:

```text
tailLength = codeEnd - insertionAddress
```

Potom sestaví:

```text
source      = insertionAddress
destination = insertionAddress + insertedLength
length      = tailLength
```

a zavolá `moveMemoryBlockOverlapSafe`.

Protože destination leží nad source, přesouvací rutina zvolí `LDDR`. Konec struktury se posune vzhůru, aniž by sám sebe zničil.

Paměť potom vypadá takto:

```text
před:

nižší paměť               vyšší paměť
... [prefix][tail................]
             ^ insertion

po posunu konce vzhůru:

... [prefix][gap][tail................]
             ^   ^
             P   P + insertedLength
```

Teprve potom lze nové bajty zkopírovat do mezery pomocí `LDIR`.

## Ukazatele jsou součástí struktury

Přesun bajtů nestačí. PROMETHEUS uchovává několik adres, které ukazují dovnitř přesouvané oblasti.

Nejdůležitější jsou:

- `varcCodeEndPt+1` — horní konec použité paměti zdroje a symbolů;
- `varcSymbolTablePt+1` — pohyblivý základ tabulky symbolů;
- `varcSelectedBlockStart+1` — jedna hranice vybraného bloku;
- `varcSelectedBlockEnd+1` — druhá hranice.

První dva se vždy posunou vzhůru o počet vložených bajtů:

```asm
ld hl,varcCodeEndPt+1
call increaseAtHLbyBC
ld hl,varcSymbolTablePt+1
call increaseAtHLbyBC
```

Pomocná rutina načte little-endian slovo z paměti, přičte `BC` a zapíše je zpět:

```asm
increaseAtHLbyBC:
    ld e,(hl)
    inc hl
    ld d,(hl)
    ex de,hl
    add hl,bc
.atDEminusOnePutHLAndRet:
    ex de,hl
    ld (hl),d
    dec hl
    ld (hl),e
    ret
```

Je to další příklad kódu pracujícího s operandovými bajty samomodifikujících instrukcí. `HL` na vstupu neukazuje na obyčejnou deklaraci proměnné, ale na dolní bajt uložené okamžité adresy.

Ukazatele vybraného bloku potřebují podmíněnou opravu. Ukazatel pod místem vložení zůstává platný; ukazatel na místě vložení nebo nad ním musí následovat přesunuté bajty.

```asm
adjustPointerAtHLIfAtOrAfterInsertion:
    push hl
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
varcInsertionPointForPointerAdjustment:
    ld de,defaultPointerAdjustmentSentinel
    and a
    sbc hl,de
    pop hl
    ret c
    jr increaseAtHLbyBC
```

Pseudokód:

```text
storedPointer = wordAt(pointerCell)
if storedPointer >= insertionPoint:
    storedPointer += insertedLength
```

Samotné místo vložení je zapamatováno v operandu `varcInsertionPointForPointerAdjustment`. Tentýž helper tak může opravit obě hranice bloku.

## Proč rovnost ukazatel posouvá

Představme si, že vybraný blok začíná přesně na adrese vložení. Po otevření mezery před tímto záznamem začíná původní záznam později. Jeho ukazatel se musí zvýšit.

Podmínka je proto:

```text
pointer >= insertion point
```

nikoli pouze:

```text
pointer > insertion point
```

Odečtení tento rozdíl poskytuje přímo. Carry znamená „přísně pod“. Je-li carry vynulováno, rovnost i větší hodnota vstoupí do opravné cesty.

## Kopírování vybraného bloku přidává další hádanku

Příkaz `COPY` používá tutéž vkládací primitivu, jeho zdrojové bajty však už leží uvnitř oblasti zdroje, která se právě chystá přesunout.

Představme si kopírování bloku ležícího nad místem vložení. Otevření mezery posune původní blok vzhůru dříve, než jej závěrečné `LDIR` zkopíruje. Pokud se zdrojový ukazatel neopraví, PROMETHEUS bude kopírovat ze staré adresy, na níž už leží jiné bajty.

`invokeCopy` proto kontroluje vztah mezi:

- začátkem vybraného bloku;
- koncem vybraného bloku;
- místem vložení.

Nejprve odmítne místo vložení uvnitř vybraného bloku. Kopírování rozsahu do jeho vlastního vnitřku by při přesunu vytvořilo nejasný význam zdroje.

Pokud potom source leží na místě vložení nebo nad ním, přičte rutina k ukazateli zdroje délku nové mezery ještě před vstupem na `.insertByteRangeCommon`.

Ve zjednodušeném pseudokódu:

```text
blockStart, blockEnd = normalizedSelection()
insertion = activeLine

if insertion leží uvnitř [blockStart, blockEnd]:
    reject

length = addressAfter(blockEnd) - blockStart

if blockStart >= insertion:
    blockStart += length

insertBytes(insertion, blockStart, length)
```

Podstatné je, že zdrojový ukazatel popisuje bajty **po přesunu**, protože přesun proběhne před závěrečnou kopií.

## Mazání začíná záznamy a končí bajty

Veřejná mazací rutina přijímá:

```text
HL = první komprimovaný záznam zdroje
BC = počet záznamů
```

Přesun paměti však potřebuje délku v bajtech.

Záznamy zdroje mají proměnlivou velikost, takže PROMETHEUS postupuje záznam po záznamu:

```asm
.findEndOfDeletedLineRangeLoop:
    call getNextSourceRecord
    dec bc
    ld a,b
    or c
    jr nz,.findEndOfDeletedLineRangeLoop
```

Po smyčce:

```text
HL = první bajt za mazanými záznamy
DE = začátek mazání
```

Počet bajtů je:

```text
deletedLength = end - start
```

Je to dobrý příklad oddělení jednotky viditelné uživateli od jednotky úložiště.

Editor říká „smaž tři řádky“.

Paměťový engine říká „odstraň sedmnáct bajtů začínajících zde“.

## Uzavření mezery

Při mazání rozsahu se všechny bajty za ním přesunou dolů:

```text
před:

[prefix][mazané bajty][tail........]
         ^             ^
         start         end

po:

[prefix][tail........][unused]
```

Zdrojem je starý konec mazaného rozsahu. Cílem je starý začátek. Destination leží pod source, takže `moveMemoryBlockOverlapSafe` zvolí dopředné `LDIR`.

Po přesunu konce PROMETHEUS vynuluje uvolněné bajty na horním konci:

```asm
.clearVacatedSourceBytesLoop:
    xor a
    ld (de),a
    inc de
    dec bc
    ld a,b
    or c
    jr nz,.clearVacatedSourceBytesLoop
```

Vynulování není pro samotný přesun nutné. Ukazatel konce kódu už říká, že bajty nejsou používány. Odstranění starých dat však dává okolním pracovním oblastem předvídatelný stav a zabraňuje tomu, aby za logickým koncem zůstávaly viditelné staré zakódované záznamy.

## Oprava ukazatelů po mazání

Ukazatele horního konce se vždy sníží o počet smazaných bajtů:

```asm
ld hl,varcCodeEndPt+1
call subtractBCFromPointerAtHL
ld hl,varcSymbolTablePt+1
```

Hranice vybraného bloku podmíněně opravuje `adjustPointerAtHLForDeletion`.

Její porovnání zjišťuje, zda uložený ukazatel leží nad začátkem mazání. Pokud ano, ukazatel se zmenší o délku smazaného rozsahu.

Příkazová logika mazání potom stáhne obě vybrané hranice na jeden přeživší záznam:

```asm
ld (varcSelectedBlockStart+1),hl
ld (varcSelectedBlockEnd+1),hl
ld (varcSourceBufferActiveLine+1),hl
```

Toto rozdělení odpovědnosti je užitečné:

- nízkoúrovňová mazací rutina zhutní bajty a provede obecnou aritmetiku ukazatelů;
- příkaz `DELETE` potom zvolí rozumný přeživší výběr editoru.

Čtenář by neměl očekávat, že každé sémantické rozhodnutí editoru bude ukryto uvnitř obecné paměťové primitivy.

## Prázdné záznamy zachovávají podlahu editoru

PROMETHEUS udržuje kolem trvalé access-line oblasti malou zásobu prázdných komprimovaných záznamů. Smaže-li uživatel celý program, editor musí stále mít platné záznamy, které může zobrazovat a procházet.

`deleteSourceLinesAndRestoreTailPadding` proto kontroluje, zda konec zdroje neustoupil příliš blízko k `sourceBufferAccessLine`. Je-li to nutné, opakovaně vloží jeden dvoubajtový prázdný záznam.

V pseudokódu:

```text
smaž požadované záznamy
while konec zdroje je příliš blízko trvalé access line:
    vlož jeden prázdný dvoubajtový záznam
```

To ukazuje důležité pravidlo:

> Paměťová operace může správně zachovat bajty a přesto porušit invariant vyšší úrovně.

Doplňovací smyčka tento invariant obnoví.

## Inkluzivní výběry a výlučné bajtové rozsahy

PROMETHEUS používá inkluzivní i výlučné pojmy a jejich záměna vede k chybám o jeden bajt.

Vybraný blok je popsán dvěma začátky záznamů a je inkluzivní:

```text
první vybraný záznam ... poslední vybraný záznam
```

Pro výpočet délky v bajtech program jednou postoupí za poslední záznam:

```text
exclusiveEnd = getNextSourceRecord(lastSelected)
length = exclusiveEnd - firstSelected
```

Tento postup je bezpečnější než hledání posledního bajtu záznamu proměnlivé délky.

Objevuje se v `invokeCopy` i při mazání vybraného bloku.

Obecné pravidlo zní:

```text
lidský výběr: inkluzivní záznamy
přesun paměti: [start, exclusiveEnd)
```

Hranatá závorka znamená, že začátek je zahrnut; kulatá, že konec zahrnut není.

## Carry neznamená vždy „chybu“

V PROMETHEU může carry podle kontraktu rutiny znamenat mnoho různých věcí:

- kandidátní adresa leží pod hranicí;
- rozsah leží uvnitř ochranného okna;
- symbol nebyl nalezen;
- textová shoda uspěla;
- součet přetekl;
- vložení se stále vejde pod `U-TOP`.

Proto je nebezpečné číst pouze jedinou instrukci za `CALL`. Větev jako `JR C` nemá jeden univerzální český překlad. Musíme vědět, co volaná rutina slíbila ponechat v carry.

Pro paměťová porovnání je běžný vzor neznaménkového odečtení:

```text
vynuluj carry
SBC left,right
```

Potom:

```text
carry nastaveno   → left < right
zero nastaveno    → left = right
carry vynulováno a zero vynulováno → left > right
```

Adresy se chápou jako neznaménková šestnáctibitová čísla. Adresa `$F000` leží nad `$7000`; není záporným číslem.

## Proč PROMETHEUS nepoužívá velký registr ukazatelů

Obecnější editor by mohl všechny interní ukazatele udržovat v tabulce a po každém vložení nebo mazání spustit jeden univerzální relokační průchod.

PROMETHEUS místo toho přímo opravuje několik ukazatelů důležitých pro danou operaci.

Při vložení sem patří:

- konec kódu;
- základ tabulky symbolů;
- začátek vybraného bloku;
- konec vybraného bloku;
- někdy zdrojový ukazatel držený volajícím.

Jiné subsystémy opravují vlastní struktury, když do nich vkládají data. Vložení jména symbolu například upravuje také posuny ordinal vector, protože jde o relativní pozice uvnitř oblasti symbolů, nikoli o obyčejné ukazatele do zdroje.

Tento přístup je méně abstraktní, ale menší. Neexistuje tabulka deskriptorů vysvětlující každý rezidentní ukazatel. Cenou je, že každá rutina měnící paměť musí přesně vědět, které struktury může narušit.

## Úplné vložení v pseudokódu

Obecný algoritmus vložení nyní můžeme rekonstruovat bez šumu registrů:

```text
function insertByteRange(insertion, sourceBytes, length):
    proposedEnd = codeEnd + length

    if proposedEnd přetekl or proposedEnd >= UTop:
        report "Memory full"

    tailLength = codeEnd - insertion

    memmove(
        source      = insertion,
        destination = insertion + length,
        length      = tailLength
    )

    codeEnd       += length
    symbolTablePt += length

    if selectedBlockStart >= insertion:
        selectedBlockStart += length

    if selectedBlockEnd >= insertion:
        selectedBlockEnd += length

    zkopíruj sourceBytes do insertion v délce length bajtů
```

Parser řádku zdroje a příkaz kopírování bloku se liší především tím, jak připraví `sourceBytes`, `length` a místo vložení.

## Úplné mazání v pseudokódu

```text
function deleteSourceRecords(firstRecord, recordCount):
    deletionStart = firstRecord
    deletionEnd = firstRecord

    repeat recordCount times:
        deletionEnd = nextRecord(deletionEnd)

    deletedLength = deletionEnd - deletionStart
    tailLength = codeEnd - deletionEnd

    memmove(
        source      = deletionEnd,
        destination = deletionStart,
        length      = tailLength
    )

    vynuluj deletedLength bajtů nyní nepoužívaných na horním konci

    oprav ukazatele vybraného bloku
    codeEnd       -= deletedLength
    symbolTablePt -= deletedLength
```

Příkazový wrapper potom zvolí platný přeživší záznam a obnoví prázdné koncové záznamy, pokud se zdroj příliš zkrátil.

## Proč záleží na pořadí oprav

Uvažujme vložení. Konec se musí přesunout před kopírováním nových bajtů, protože nové bajty mohou pocházet z dočasného bufferu, který se zdrojovou oblastí nepřekrývá. Opravy ukazatelů však mohou proběhnout po přesunu a před závěrečnou kopií, protože mění metadata, nikoli právě přenášené bajty.

Při kopírování bloku může být otevřením mezery posunut samotný zdrojový ukazatel. `invokeCopy` tento ukazatel opraví před voláním vkládacího jádra.

Při mazání si rutina musí před přesunem konce zapamatovat začátek mazání i délku mazaných bajtů, protože původní pozice záznamů po zhutnění zmizí.

Bezpečná transformace paměti proto probíhá ve třech fázích:

```text
1. Změř a zapamatuj
2. Přesuň bajty
3. Oprav metadata a invarianty
```

Pokusit se po druhé fázi znovu odvodit původní hranice by bylo mnohem obtížnější.

## Zpět k celému stroji

V kapitole 3 se zdroj a symboly objevily jako dvě sousední dynamické oblasti. Nyní vidíme, jak mohou zůstat sousedy i během změn editoru.

Nový záznam zdroje otevře mezeru pod tabulkou symbolů. Ukazatele tabulky symbolů a konce kódu se posunou vzhůru. V případě potřeby je následují vybrané ukazatele zdroje.

Mazání mezeru uzavře. Konec, včetně dat symbolů, sklouzne dolů. Ukazatele horní hranice se zmenší.

Nové jméno symbolu provede podobný přesun uvnitř oblasti symbolů a opraví vlastní posuny ve vektoru.

Installer později používá tentýž směr závislý na vztahu adres, aby bezpečně zkopíroval celý rezidentní obraz i při překryvu načtené a cílové oblasti.

Scroller obrazovky používá menší specializovanou kopii, protože řádky bitmapy Spectra jsou prokládané a neleží lineárně.

Ústřední myšlenka je tedy širší než volba mezi `LDIR` a `LDDR`:

> PROMETHEUS chápe paměť jako soubor struktur, jejichž bajty a ukazatele se musí přesouvat společně.

## Co se změnilo v paměti?

Po obecném vložení `N` bajtů:

- všechny bajty od místa vložení po starý konec kódu se posunuly vzhůru o `N`;
- `varcCodeEndPt` se zvýšil o `N`;
- `varcSymbolTablePt` se zvýšil o `N`;
- ukazatele vybraného bloku na místě vložení nebo nad ním se zvýšily o `N`;
- nové bajty obsadily otevřenou mezeru.

Po mazání:

- všechny bajty za smazaným rozsahem se posunuly dolů;
- uvolněné horní bajty byly vynulovány;
- ukazatele konce kódu a tabulky symbolů se zmenšily;
- ukazatele výběru editoru byly opraveny nebo resetovány příkazovým wrapperem;
- pro zachování minimálního rozložení editoru mohly být znovu vloženy prázdné záznamy zdroje.

## Důležité myšlenky pro pozdější kapitoly

- `LDIR` a `LDDR` tvoří základ bezpečného strukturálního přesouvání.
- Neznaménkové šestnáctibitové porovnání se obvykle vyjadřuje pomocí `SBC HL,DE` a příznaků.
- PROMETHEUS často zachová porovnávané hodnoty a vrátí pouze příznaky.
- Výběry ve zdroji jsou inkluzivní, ale paměťové rozsahy se nejsnáze měří pomocí výlučného konce.
- Po přesunu bajtů musí následovat oprava ukazatelů.
- Invarianty vyšší úrovně, například trvalé prázdné záznamy zdroje, mohou vyžadovat další práci nad rámec samotného přesunu.

## Vysvětlené orientační labely zdroje

- `moveMemoryBlockOverlapSafe`
- `ensureBCBytesFitBelowUTop`
- `insertByteRangeAtHLFromDE`
- `.insertByteRangeCommon`
- `adjustPointerAtHLIfAtOrAfterInsertion`
- `varcInsertionPointForPointerAdjustment`
- `increaseAtHL`
- `increaseAtHLByTwo`
- `increaseAtHLbyBC`
- `deleteSourceLinesAtHL`
- `subtractBCFromPointerAtHL`
- `adjustPointerAtHLForDeletion`
- `varcDeletionStartForPointerAdjustment`
- `deleteSourceLinesAndRestoreTailPadding`
- `compareHLWithSourceBufferStart`
- `comparePositionWithCodeEnd`
- `invokeCopy`
- `invokeDelete`
