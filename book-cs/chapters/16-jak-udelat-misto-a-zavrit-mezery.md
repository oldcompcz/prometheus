# Kapitola 16: Jak udělat místo a zavřít mezery

Editor už umí porozumět řádku zdroje, uložit jej jako komprimovaný záznam, znovu jej sestavit a přecházet z jednoho záznamu na druhý. Zbývá jedna velká praktická otázka:

> Co se stane, když nový záznam nemá stejnou délku jako starý?

PROMETHEUS nemůže požádat operační systém o nový blok paměti. Vlastní jedinou těsně zabalenou oblast, ve které za záznamy zdroje bezprostředně následuje tabulka symbolů. Chce-li vložit tři bajty poblíž začátku, může být nutné posunout o tři bajty vzhůru tisíce pozdějších bajtů. Při smazání záznamu musí mezeru zavřít, stáhnout tabulku symbolů dolů a opravit každou zapamatovanou adresu, jejíž obsah se přesunul.

Mohlo by se zdát, že je k tomu zapotřebí velká sbírka zvláštních případů. Zdroj však většinu editačních operací skládá ze dvou obecných transformací:

```text
vložení:
    otevři mezeru
    přesuň pozdější bajty vzhůru
    oprav ukazatele
    zkopíruj nové bajty do mezery

smazání:
    změř odstraňované záznamy
    přesuň pozdější bajty dolů
    oprav ukazatele
    vyčisti uvolněný konec
```

Obtížnou částí není samotné kopírování bajtů. Kapitola 7 už představila mover založený na `LDIR`/`LDDR`, který fyzický přesun provede bezpečně. Obtížné je zachovat *význam* všech ukazatelů kolem přesouvaných bajtů.

## Jedna zabalená oblast s několika významy

Dynamickou oblast si lze představit takto:

```text
nízké adresy

komprimované záznamy zdroje
    ukazatel aktivního řádku míří někam sem
    ukazatele vybraného bloku míří někam sem

počet symbolů a vektory pořadových čísel
abecedně uložené záznamy symbolů
malý chráněný konec

vysoké adresy
```

Její pohyblivé hranice popisují dva samomodifikované ukazatele:

- `varcSymbolTablePt` označuje místo, kde právě začíná tabulka symbolů;
- `varcCodeEndPt` označuje horní konec společného prostoru zdroje a symbolů.

Ani jedna adresa není pevná. Přidání zdroje posune obě vzhůru. Odebrání zdroje je stáhne dolů. Zdroj tedy nemá vlastní nezávislou alokaci: roste tak, že posouvá vše za bodem vložení.

Editor si navíc pamatuje adresy *uvnitř* zdroje:

- `varcSourceBufferActiveLine`;
- `varcSelectedBlockStart`;
- `varcSelectedBlockEnd`;
- pokračovací pozici příkazu FIND;
- dočasné ukazatele jednotlivých příkazů.

Ne všechny opravuje stejné primitivum. Některé jsou trvalými strukturálními ukazateli a upravují se centrálně. Jiné vlastní konkrétní příkaz, který ví, co má jejich hodnota znamenat po dokončení operace, a nastaví je výslovně.

Tento rozdíl bude důležitý v celé kapitole.

## Před růstem se zeptej U-TOP

Každé vložení začíná kontrolou, zda se zvětšená oblast stále vejde pod konfigurovatelný strop uživatelské paměti U-TOP.

Skutečná rutina je kompaktní:

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

`BC` obsahuje počet přidávaných bajtů. Rutina počítá:

```text
proposedEnd = currentEnd + byteCount
```

Selhání může nastat dvěma způsoby.

Za prvé se šestnáctibitový součet může přetočit z vysoké adresy zpět na nízkou. Z80 v takovém případě nastaví carry a PROMETHEUS okamžitě hlásí plnou paměť.

Za druhé může navrhovaný konec dosáhnout U-TOP nebo jej překročit. Poslední odečtení vrací carry pouze tehdy, když platí:

```text
proposedEnd < U-TOP
```

Porovnání je přísné. U-TOP je hranice, nikoli bajt dostupný oblasti zdroje.

Kontrola proběhne ještě před jakýmkoli přesunem. Neúspěšné vložení proto ponechá zabalený zdroj i tabulku symbolů beze změny.

## Otevření mezery

Hlavním vstupem pro vložení je:

```asm
insertByteRangeAtHLFromDE:
    ld b,000h
.insertByteRangeCommon:
    push de
    push hl
    call ensureBCBytesFitBelowUTop
    ...
```

Jeho veřejný kontrakt zní:

```text
HL = adresa začátku mezery
DE = adresa vkládaných bajtů
BC = počet bajtů
```

Parser má délku záznamu obvykle jen v `C`, proto pojmenovaný vstup vynuluje `B`. Příkaz COPY už disponuje úplným šestnáctibitovým počtem bajtů a skočí přímo do společného těla.

Předpokládejme, že paměť právě vypadá takto:

```text
A | B | C | D | tabulka symbolů | konec
        ^ bod vložení
```

a nový záznam má délku `N`. Požadovaný výsledek je:

```text
A | B | mezera N bajtů | C | D | tabulka symbolů | konec
```

Rutina spočítá délku od bodu vložení po `varcCodeEndPt` a požádá `moveMemoryBlockOverlapSafe`, aby celý tento polootevřený suffix — až po aktuální hranici konce, ale bez ní — posunul o `N` bajtů vzhůru.

V pseudokódu:

```text
suffixLength = codeEnd - insertionPoint
move(
    source      = insertionPoint,
    destination = insertionPoint + N,
    length      = suffixLength
)
```

Protože cíl leží nad zdrojem a rozsahy se obvykle překrývají, mover použije `LDDR`: začne na horním konci a postupuje zpět. Kdyby kopíroval dopředu, první zapsané bajty by zničily zdrojové bajty, které dosud nebyly přečteny.

## Proč se zdrojové adresy před přesunem ukládají

Vkládané bajty mohou samy ležet uvnitř oblasti, která se má posunout. U COPY to platí jistě: zdrojem je vybraný blok komprimovaných záznamů, který už leží ve zdrojové oblasti.

Vkládací rutina před otevřením mezery uloží původní zdrojovou adresu i adresu vložení na zásobník. Příkaz COPY může navíc předem opravit svou zdrojovou adresu, pokud se vybrané bajty při vytvoření mezery posunou.

Je zde užitečné obecné poučení:

> Správný `memmove` ochrání přesouvané bajty, ale automaticky neopraví samostatný ukazatel, který tyto bajty označuje.

PROMETHEUS zachází s těmito problémy odděleně.

## Oprava pohyblivých hranic

Po posunu suffixu vzhůru se musí o stejný počet bajtů vždy posunout dvě hranice oblastí:

```asm
ld hl,varcCodeEndPt+1
call increaseAtHLbyBC
ld hl,varcSymbolTablePt+1
call increaseAtHLbyBC
```

Pomocná rutina přečte little-endian slovo, přičte `BC` a výsledek zapíše zpět.

Pojmově:

```text
codeEnd       += N
symbolTablePt += N
```

Obsah tabulky symbolů není třeba znovu interpretovat. Všechny její bajty se přesunuly společně. Změnit se musí pouze vnější ukazatel na její začátek a vnější ukazatel na konec celé společné oblasti.

## Podmíněná oprava hranic bloku

Konec vybraného bloku se posune pouze tehdy, když leží na bodu vložení nebo nad ním. Hranice pod novou mezerou stále označuje stejný fyzický záznam na stejné adrese.

Operace vložení uloží svou hranici do samomodifikovaného operandu:

```asm
varcInsertionPointForPointerAdjustment:
    ld de,defaultPointerAdjustmentSentinel
```

Potom zavolá tutéž pomocnou rutinu pro oba ukazatele výběru:

```asm
ld hl,varcSelectedBlockStart+1
call adjustPointerAtHLIfAtOrAfterInsertion
ld hl,varcSelectedBlockEnd+1
call adjustPointerAtHLIfAtOrAfterInsertion
```

Logika helperu je:

```text
pointer = slovo uložené na HL

if pointer >= insertionPoint:
    pointer += insertedByteCount
```

Skutečné porovnání odečte bod vložení od uloženého ukazatele a bez změny se vrátí tehdy, když carry říká, že ukazatel ležel pod mezerou.

Tato politika přesně odpovídá potřebám ukazatele na začátek záznamu. Vloží-li se nový záznam před existující vybraný řádek, bajty tohoto řádku se posunou vzhůru a ukazatel je následuje. Proběhne-li vložení za vybraným řádkem, ukazatel zůstane na místě.

## Proč se zde neopravuje ukazatel aktivního řádku

Možná jste si všimli, že `insertByteRangeAtHLFromDE` opravuje oba konce vybraného bloku, ale nikoli `varcSourceBufferActiveLine`.

Je to záměrné. Primitivum pro vložení ví pouze to, že se vkládají bajty. Neví, který řádek má editor po operaci považovat za aktivní.

Při běžném zadání zdroje je požadovaný výsledek:

```text
nově vložený záznam se stane aktivním
```

Volající proto adresu vložení uloží výslovně:

```asm
call insertByteRangeAtHLFromDE
pop hl
ld (varcSourceBufferActiveLine+1),hl
```

U COPY, DELETE, importu z pásky nebo REPLACE může být žádoucí aktivní řádek jiný. Tyto příkazy si jej zvolí samy.

Toto rozdělení udržuje byte mover obecný. Opravuje strukturální hranice, jejichž význam je neměnný, zatímco operace vyšší úrovně opravuje stav uživatelského rozhraní podle vlastní sémantiky.

## Naplnění otevřené mezery

Teprve po přesunutí paměti a ukazatelů se vkládací rutina vrátí k uloženým argumentům a provede:

```asm
pop de
pop hl
ldir
```

V této chvíli platí:

```text
HL = začátek mezery
DE = zdrojové bajty, případně předem opravené volajícím
BC = délka vložení
```

Mezera je volným prostorem uvnitř zabalené oblasti, takže pro její naplnění je vhodný obyčejný dopředný `LDIR`.

Celé vložení lze shrnout takto:

```text
zkontroluj kapacitu
přesuň zabalený suffix vzhůru
posuň ukazatel konce kódu vzhůru
posuň ukazatel tabulky symbolů vzhůru
oprav hranice výběru na mezeře nebo nad ní
zkopíruj požadované bajty do mezery
```

## Vložení právě rozebraného záznamu zdroje

Kapitola 13 sledovala text až do `encodedRecordStorageLength` a připravených zakódovaných bajtů. Editor potom vloží nový záznam bezprostředně za aktuální aktivní záznam:

```asm
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

Připravený buffer začíná počtem kopírovaných bajtů, po němž následuje trvalý záznam. Samotný bajt délky se nevkládá.

V pseudokódu:

```text
insertionPoint = nextRecord(active)
length = stagedRecord.length
bytes = stagedRecord.payload

insert(insertionPoint, bytes, length)
active = insertionPoint
```

To je režim INSERT: starý aktivní záznam přežije a nový se objeví pod ním.

## OVERWRITE je vložení následované smazáním

PROMETHEUS nepotřebuje samostatnou rutinu „změň velikost tohoto záznamu na místě“. OVERWRITE znovu používá vložení a smazání:

```text
1. vlož nový komprimovaný záznam za starý aktivní záznam
2. učiň nový záznam aktivním
3. přejdi zpět ke starému záznamu
4. smaž právě tento starý záznam
5. nový záznam sklouzne dolů na jeho místo
```

Příslušný úsek zdroje je:

```asm
varcInsertMode:
    ld a,000h
    or a
    jr z,.finishSourceLineInsertion
    call getRecordBeforeActiveLine
    ld (varcSourceBufferActiveLine+1),hl
    ld bc,00001h
    call deleteSourceLinesAtHL
```

Je to pěkný příklad sestavení složité viditelné operace z jednoduchých paměťových transformací.

Přirozeně zvládá i změnu délky. Náhradní záznam může být kratší nebo delší než původní. Vložení nejprve zaručí dostatek prostoru pro nový záznam a smazání potom odstraní přesný počet bajtů starého.

## Mazání začíná záznamy a teprve potom se mění v bajty

API pro smazání je vyjádřeno v záznamech zdroje:

```text
HL = první mazaný záznam
BC = počet záznamů
```

Přesun paměti však potřebuje počet bajtů. `deleteSourceLinesAtHL` proto projde pomocí `getNextSourceRecord` dopředu přes `BC` záznamů.

Začíná-li mazání na adrese `start` a průchod skončí na `end`, platí:

```text
removedBytes = end - start
```

Právě proto je dopředné procházení formátu záznamů součástí mutačního enginu. Editor nemusí zvlášť počítat délku každého záznamu; zeptá se, kde začíná záznam následující za mazaným rozsahem.

## Zavření mezery

Po změření rozsahu rutina přesune vše od `end` až po společný konec kódu dolů na `start`:

```text
před:
    prefix | bajty k odstranění | pozdější zdroj | tabulka symbolů | konec

přesuň:
    pozdější zdroj | tabulka symbolů | konec
        dolů přes bajty k odstranění

po:
    prefix | pozdější zdroj | tabulka symbolů | konec | nepoužité bajty
```

Cíl leží pod zdrojem, proto `moveMemoryBlockOverlapSafe` zvolí dopředný `LDIR`. V tomto směru je bezpečné číst od nízkých adres k vysokým.

Společnému moveru je lhostejné, že některé bajty jsou záznamy zdroje a pozdější bajty patří symbolům. Vidí jediný souvislý suffix.

## Vyčištění uvolněného horního konce

Po stlačení zůstane nad novým koncem `removedBytes` starých bajtů. PROMETHEUS každý z nich vynuluje:

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

Tyto bajty už nejsou součástí živého zdroje ani tabulky symbolů, takže správnost nevyžaduje zachování jejich starých hodnot. Nulování má praktické výhody:

- staré úlomky zdroje nezůstávají jako matoucí trosky;
- pozdější pracovní oblasti začínají předvídatelnými nulami;
- náhodný scan za živý konec méně pravděpodobně najde něco zdánlivě smysluplného.

Na stroji s omezenou pamětí „nepoužité“ neznamená fyzicky neexistující. Znamená to „mimo aktuální hranici“. Nulování tuto hranici zviditelní nejen v ukazatelích, ale i v samotných bajtech.

## Oprava ukazatelů po smazání

Mazání posouvá pozdější bajty dolů. Jednoduchý opravný helper používá uložený začátek mazání:

```asm
varcDeletionStartForPointerAdjustment:
    ld hl,09c28h
```

Pro každý konec vybraného bloku provede ekvivalent:

```text
if pointer > deletionStart:
    pointer -= removedBytes
```

Ukazatel na začátku mazání nebo pod ním zůstane beze změny.

Helper je záměrně mechanický. Neví nic o tom, zda konec výběru ležel *uvnitř* odstraněného bloku, nebo až za ním. Pouze následuje fyzické pravidlo přesunu. Destruktivní příkaz vyšší úrovně, například blokový DELETE, potom dá ukazatelům bloku nový sémantický význam.

Jde o další důležité rozlišení:

```text
fyzická oprava:
    přiměj adresu následovat přesunuté bajty

sémantická oprava:
    rozhodni, co má stav editoru znamenat, když tyto bajty už neexistují
```

Společná mazací rutina provádí první. Její volající může provést druhou.

Nakonec se oba dynamické konce oblastí bezpodmínečně zmenší:

```text
codeEnd       -= removedBytes
symbolTablePt -= removedBytes
```

Tabulka symbolů se fyzicky posunula dolů přesně o tento počet bajtů.

## Obnovení trvalého prázdného konce

Smazání velkého rozsahu — třeba i celého uživatelského programu — by mohlo zkrátit zdroj natolik, že by pod přístupovým řádkem nezůstalo potřebných šest záznamů.

`deleteSourceLinesAndRestoreTailPadding` obaluje základní mazací rutinu. Po stlačení opakovaně testuje trvalou oblast přístupového řádku. Dokud leží konec zdroje příliš nízko, vloží další pevný dvoubajtový prázdný záznam:

```asm
.ensureSourceTailPaddingLoop:
    ld hl,sourceBufferAccessLine
    call comparePositionWithCodeEnd
    jr c,.sourceTailPaddingRestored
    ld d,h
    ld e,l
    ld c,002h
    call insertByteRangeAtHLFromDE
    jr .ensureSourceTailPaddingLoop
```

`HL` i `DE` ukazují na existující prázdný záznam, takže vložení zkopíruje jeho dvoubajtovou formu `$00,$30`.

Smyčka je půvabně úsporná. Místo samostatné konstanty pro prázdný záznam duplikuje už existující přístupový řádek tak dlouho, dokud neobnoví navigační invariant.

## Smazání aktivního řádku jedinou klávesou

Přímá klávesa delete odstraní právě jeden komprimovaný záznam:

```asm
ld bc,00001h
ld hl,(varcSourceBufferActiveLine+1)
call deleteSourceLinesAndRestoreTailPadding
```

Editor potom zvolí blízkého přeživšího:

```text
if mazání začalo na nejdřívějším povoleném aktivním řádku:
    ponech tuto adresu aktivní
else:
    přejdi na předchozí přeživší záznam
```

Proč původní adresa často zůstává užitečná? Následující záznam sklouzl dolů na starou adresu smazaného záznamu. U prvního povoleného záznamu je to nejpřirozenější přeživší. Jinde editor záměrně ustoupí o jeden záznam, aby kurzor zůstal blízko řádku nad smazaným místem.

Ani toto nerozhoduje společná byte rutina. Rozhoduje handler klávesy.

## Smazání vybraného bloku včetně obou hranic

Příkaz DELETE nejprve normalizuje oba konce bloku. Potom od dolního konce po horní spočítá záznamy včetně obou hranic:

```text
count = 1
record = lower

while record < upper:
    record = next(record)
    count++
```

Tento počet předá `deleteSourceLinesAndRestoreTailPadding`.

Jakmile bajty zmizí, příkaz zvolí přeživší záznam nejbližší odstraněnému rozsahu. Potom na něj sjednotí všechny tři ukazatele editoru:

```text
selectedBlockStart = survivor
selectedBlockEnd   = survivor
activeLine         = survivor
```

To je sémantická oprava. Výběr nemůže dál označovat blok, který už neexistuje, proto se změní na jednořádkový výběr u nového aktivního záznamu.

## COPY a pohybující se zdrojový ukazatel

COPY je choulostivější, protože vkládané bajty už leží v zabalené oblasti.

Příkaz získá:

```text
low  = první vybraný záznam
high = poslední vybraný záznam
end  = záznam za high
size = end - low
```

Mezera se otevře u aktivního záznamu, takže kopírovaný blok se objeví bezprostředně před ním.

Příkaz odmítne aktivní bod vložení ležící přísně uvnitř vybraného rozsahu. Samotná dolní hranice je užitečný zvláštní případ: protože se mezera otevírá *před* tímto záznamem, lze kopírováním na první vybraný řádek blok zdvojit na místě, aniž by se četlo z nové mezery.

Než společné vložení přesune paměť, COPY zjistí, zda vybraný zdroj leží na bodu vložení nebo nad ním.

Pokud ano, otevření mezery posune původní vybrané bajty vzhůru o `size`. Zdrojový ukazatel se proto musí ještě před závěrečným kopírováním rovněž zvýšit o `size`.

V pseudokódu:

```text
copySource = low

if copySource >= insertionPoint:
    copySource += size

insert(
    insertionPoint,
    copySource,
    size
)
```

Takovou opravu `memmove` sám nevymyslí. Mover zachovává bajty; COPY zachovává identitu vybraného bloku.

## Příklad vložení

Představme si čtyři záznamy s délkami 2, 5, 3 a 4 bajty:

```text
R0 na $A000, délka 2
R1 na $A002, délka 5
R2 na $A007, délka 3
R3 na $A00A, délka 4
tabulka symbolů na $A00E
```

Před `R2`, tedy na `$A007`, se vloží nový šestibajtový záznam.

Před operací:

```text
$A000 R0
$A002 R1
$A007 R2
$A00A R3
$A00E tabulka symbolů
```

Po posunutí suffixu o šest bajtů vzhůru:

```text
$A000 R0
$A002 R1
$A007 mezera
$A00D R2
$A010 R3
$A014 tabulka symbolů
```

Rutina potom naplní `$A007..$A00C` novým záznamem.

Důsledky pro ukazatele:

```text
symbolTablePt += 6
codeEnd       += 6
každý konec výběru >= $A007 += 6
activeLine nastaví výslovně volající
```

Zabalená posloupnost záznamů zůstává platná, protože všechny pozdější bajty se přesunuly společně.

## Příklad smazání

Nyní smažme `R1` a nový šestibajtový záznam. Předpokládejme, že jejich společná délka je jedenáct bajtů.

Průchod mazání začne na `$A002` a skončí u záznamu za novým záznamem, tedy na `$A00D`.

Suffix začínající na `$A00D` se přesune dolů na `$A002`:

```text
před:
R0 | R1 + nový | R2 | R3 | symboly

posuň dolů o jedenáct bajtů

po:
R0 | R2 | R3 | symboly | vyčištěný konec
```

Dynamické hranice se sníží o jedenáct. Konec bloku nad `$A002` následuje fyzický pohyb odečtením jedenácti. Mazací příkaz potom zvolí a uloží smysluplný přeživší výběr.

## Proč není třeba index záznamů

Index adres řádků by některé operace usnadnil, vytvořil by však další strukturu, kterou je nutné přesouvat a opravovat.

PROMETHEUS místo toho vše odvozuje ze zabalených záznamů:

- počet záznamů se průchodem změní v počet bajtů;
- adresa vložení je začátkem záznamu;
- konec mazání se najde chůzí přes záznamy;
- velikost bloku v bajtech je `next(upper)-lower`;
- sousední přeživší záznamy najdou tytéž dopředné a zpětné navigační rutiny jako editor.

Posloupnost záznamů je současně daty i indexem.

## Zpět k celému editoru

Když uživatel zadá jediný nový řádek zdroje, viditelná událost je nepatrná. Pod ní může PROMETHEUS:

1. ověřit prostor pod U-TOP;
2. posunout vzhůru všechny pozdější živé bajty zdroje a symbolů;
3. posunout hranice tabulky symbolů a konce kódu;
4. posunout konce vybraného bloku ležící nad vložením;
5. zkopírovat zakódovaný záznam do nové mezery;
6. zvolit nový aktivní záznam;
7. v režimu OVERWRITE případně smazat starý záznam;
8. překreslit okno zdroje z opraveného řetězce.

Editor funguje proto, že každá vrstva má jasnou odpovědnost:

- parser vytváří platné bajty záznamu;
- mover zachovává překrývající se rozsahy bajtů;
- engine vložení a mazání zachovává strukturu zabalené oblasti;
- helpery ukazatelů následují fyzický přesun;
- handlery příkazů obnovují význam uživatelského rozhraní;
- navigace předpokládá, že všechny tyto invarianty jsou znovu platné.

To je skrytá mechanika za obyčejným přidáním nebo odstraněním řádku.

## Co se změnilo v paměti?

Po vložení:

- zabalený suffix od bodu vložení po konec kódu se posunul vzhůru;
- nové bajty zaplnily otevřenou mezeru;
- `varcSymbolTablePt` a `varcCodeEndPt` se zvýšily;
- konce vybraného bloku na bodu vložení nebo nad ním se zvýšily;
- volající zvolil novou hodnotu aktivního řádku;
- za zdrojem nadále bezprostředně následuje tabulka symbolů.

Po smazání:

- rozsah bajtů pokrývající požadované záznamy zmizel;
- pozdější bajty zdroje a symbolů se posunuly dolů;
- uvolněné horní bajty se vynulovaly;
- dynamické hranice oblastí se snížily;
- adresy výběru nad začátkem mazání se mechanicky posunuly;
- volající obnovil smysluplné ukazatele aktivního řádku a bloku;
- prázdné koncové záznamy se v případě potřeby znovu vložily.

## Důležité myšlenky pro další kapitoly

- zdroj a symboly tvoří jednu zabalenou pohyblivou oblast;
- vložení a mazání jsou transformace bajtů sestavené z průchodu záznamy;
- před růstem se kontroluje U-TOP;
- `moveMemoryBlockOverlapSafe` zachovává překrývající se bajty, nikoli význam vnějších ukazatelů;
- hranice oblastí vždy následují celý zabalený suffix;
- ukazatele vybraného bloku dostávají centrální fyzickou opravu;
- stav aktivního řádku volí volající vyšší úrovně;
- OVERWRITE se provádí jako vložení nového a následné smazání starého záznamu;
- mazání nejprve počítá záznamy a teprve potom bajty;
- fyzická oprava ukazatelů a sémantická oprava editoru jsou odlišné úkoly;
- po velkém smazání se obnovují trvalé prázdné záznamy;
- COPY musí opravit zdrojový ukazatel, jestliže otevření mezery posune vybrané bajty.

## Vysvětlené orientační body ve zdroji

- `ensureBCBytesFitBelowUTop`
- `insertByteRangeAtHLFromDE`
- `.insertByteRangeCommon`
- `varcInsertionPointForPointerAdjustment`
- `adjustPointerAtHLIfAtOrAfterInsertion`
- `increaseAtHL`
- `increaseAtHLByTwo`
- `increaseAtHLbyBC`
- `deleteSourceLinesAtHL`
- `.findEndOfDeletedLineRangeLoop`
- `.clearVacatedSourceBytesLoop`
- `subtractBCFromPointerAtHL`
- `adjustPointerAtHLForDeletion`
- `varcDeletionStartForPointerAdjustment`
- `deleteSourceLinesAndRestoreTailPadding`
- `.ensureSourceTailPaddingLoop`
- `parseAndInsertSourceLine` na úrovni změny paměti
- `varcInsertMode` na úrovni potvrzení změny
- `.checkDeleteActiveLineKey`
- `invokeCopy` na úrovni změny paměti
- `invokeDelete` na úrovni změny paměti
