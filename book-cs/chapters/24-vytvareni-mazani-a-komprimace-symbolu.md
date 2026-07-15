# Kapitola 24: Vytváření, mazání a komprimace symbolů

Tabulka symbolů z kapitoly 23 je kompaktní, protože neobsahuje volné místo ani redundantní jména. Kompaktnost však znamená práci pokaždé, když se kolekce změní.

Přidání symbolu může vyžadovat:

- připojení nového vektoru pořadového čísla;
- vložení záznamu hodnoty a jména doprostřed abecedních dat;
- přesun všech bajtů nad místem vložení;
- úpravu vektorů, jejichž záznamy se posunuly.

Odstranění symbolu je ještě obtížnější. Odpovídající vektor zmizí, takže všechna pozdější pořadová čísla se změní. Záznamy zdroje, které se na ně odkazují, se musí najít a přepsat.

PROMETHEUS provádí tyto operace přímo v zabalené paměti. Neexistuje oddělená znovu sestavená kopie tabulky ani heap allocator, který tiše vrátí nový objekt. Program otevírá a zavírá přesně velké mezery, opravuje každý dotčený odkaz a pokračuje v práci v téže oblasti paměti.

Tato kapitola tedy není jen o symbolech. Je o zachování **identity, zatímco se reprezentace pohybuje**.

## Symbol často vznikne dříve, než je definován

Předpokládejme, že programátor zadá:

```asm
        JR LOOP
```

a `LOOP` dosud neexistuje.

Řádek nemůže opakovaně ukládat celý zápis jména a nemůže uložit konečnou adresu, protože label ještě nebyl definován. `findOrCreateSymbolOrdinal` proto vytvoří nedefinovaný symbol a vrátí jeho nové pořadové číslo.

Záznam zdroje může okamžitě obsahovat:

```text
SYMBOL(pořadové číslo LOOP)
```

Později, když první průchod narazí na:

```asm
LOOP    RET
```

nastaví ve stejném vektoru flag DEFINED a zapíše aktuální logickou adresu do slova hodnoty.

Vytvoření zakládá identitu. Definice dodává hodnotu. Jsou to dvě oddělené události.

## Existující jména jdou snadnou cestou

Vytvářecí rutina nejprve zavolá běžný lookup:

```asm
findOrCreateSymbolOrdinal:
    call parseSymbolNameAndFindOrdinal
    ret nc
```

Carry clear znamená, že zápis již existuje, takže se pořadové číslo vrátí bez změny tabulky.

To je obvyklá cesta opakovaných odkazů. Symbol se může ve zdroji objevit mnohokrát, ale vytvoří se jen jednou.

Carry set znamená, že normalizované jméno zůstává v `numberStringBuffer` připravené k vložení. Rutina potom zahájí pečlivě seřazenou posloupnost změn paměti.

## Před přesunem zkontroluj strop

Tabulka sdílí prostor s komprimovaným zdrojem a musí zůstat pod U-TOP. Vytvoření nejprve rezervuje dost místa pro nejhorší okamžitou potřebu:

```asm
varcCodeEndPt:
    ld hl,codeEndDefaultPt
    ld bc,0000ch
    call ensureBCBytesFitBelowUTop
```

Pevná kontrola dvanácti bajtů je konzervativní pro nejdelší povolené jméno a související overhead vektoru a hodnoty.

Přesný růst tabulky pro jméno délky `L` je:

```text
2 bajty  nový vektor pořadového čísla
2 bajty  slovo hodnoty
L bajtů  jméno ukončené high bitem
```

tedy:

```text
celkový růst = L + 4
```

PROMETHEUS kontroluje kapacitu dříve, než začne přesouvat bajty. Chyba po polovině vložení by se napravovala mnohem obtížněji.

## Dočasný vytvářecí záznam

Normalizované jméno již leží v dočasném workspace. Bajty začínající na `symbolEntryCreationPrefix` se používají jako staging záznam:

```text
$00
v workspace dočasně přítomná délka jména
normalizované znaky jména...
```

Při kopírování do tabulky se první dva bajty stanou slovem nedefinované hodnoty. Zdánlivý dočasný bajt délky není trvalým polem délky. Později se přepíše, až symbol dostane hodnotu.

Poslední znak jména už má nastaven bit 7, takže nový záznam je okamžitě kompatibilní s trvalou abecední reprezentací.

Je to kompaktní trik: bajty workspace jsou uspořádány tak, aby bylo možné stejnou sekvenci zkopírovat přímo do její konečné strukturální role.

## Nejprve vytvoř místo pro nový vektor

Nové pořadové číslo se musí připojit za všechny existující vektory. Abecední oblast záznamů však začíná bezprostředně za polem vektorů, takže přidání dvou bajtů vektoru posune celou oblast záznamů vzhůru.

Patchovaný operand na `varcNewSymbolVectorSlot+1` určuje místo, kde se má otevřít nový vektor.

Rutina vypočítá délku od tohoto místa k aktuálnímu konci a provede overlap-safe přesun vzhůru:

```asm
varcNewSymbolVectorSlot:
    ld de,00000h
    xor a
    sbc hl,de
    ld b,h
    ld c,l
    ld h,d
    ld l,e
    inc de
    inc de
    call moveMemoryBlockOverlapSafe
```

Po tomto přesunu:

```text
staré vektory zůstávají na místě
na jejich konci existuje nový prázdný dvoubajtový slot vektoru
všechny abecední záznamy se posunuly o dva bajty vzhůru
```

`varcCodeEndPt+1` se zvýší o dva.

Protože se offsety vektorů měří od kotvy jmen, která se s rozšířeným polem vektorů posune také, tento první přesun celé oblasti záznamů sám o sobě relativní pozice reprezentované existujícími offsety nemění. Ty změní až pozdější abecední vložení.

## Potom najdi abecední pozici

Rutina prochází fyzické záznamy hodnot a jmen v pořadí zápisu a porovnává nové normalizované jméno znak po znaku.

Vybere první záznam, jehož jméno je větší než nové:

```text
nové ALPHA před uložené LOOP
nové LOOP před uložené SCREEN
nové ZED za všechny existující záznamy
```

Porovnání maskuje z viditelných znaků high terminátorový bit. Správně zpracovává i prefixy:

```text
A je před AB
LOOP je před LOOP2
```

Základní algoritmus je:

```text
insertionPoint = konec oblasti záznamů
for each uložený záznam v abecedním pořadí:
    if newName < storedName:
        insertionPoint = tento záznam
        break
```

Nové pořadové číslo na této abecední pozici nezávisí. Je jednoduše novým počtem symbolů. To je zásadní oddělení pořadí identity od pořadí jmen.

## Otevři mezeru pro hodnotu a jméno

Fyzický záznam potřebuje `nameLength + 2` bajtů. PROMETHEUS vypočítá počet bajtů nad vybraným místem vložení, přesune je vzhůru, posune `varcCodeEndPt` a zkopíruje staging záznam do mezery.

Koncepčně:

```text
před:
    záznam ALPHA
    záznam LOOP
    záznam SCREEN

vlož BETA:
    posuň LOOP a SCREEN vzhůru

    záznam ALPHA
    [nová mezera]
    záznam LOOP
    záznam SCREEN

kopíruj:
    záznam ALPHA
    záznam BETA
    záznam LOOP
    záznam SCREEN
```

Přesun používá overlap-safe primitivu z kapitoly 7. Protože destination leží nad source a rozsahy se překrývají, primitiva zvolí kopírování odzadu.

## Zvyš počet

Jakmile záznam existuje, dvoubajtový počet na začátku tabulky se zvýší.

Počet plní v celém subsystému několik úloh:

- určuje nejvyšší pořadové číslo;
- udává délku pole vektorů;
- lokalizuje první fyzický záznam;
- omezuje lookup, zobrazovací a úklidové smyčky.

Jeho změna mění vypočítanou kotvu jmen, takže opravy vektorů musí používat konzistentní interpretaci stavu před a po změně. Původní kód během operace ukládá patchované kotvy, aby aritmetika zůstala malá.

## Vypočítej offset nového vektoru

Nový vektor musí ukazovat na první bajt jména vloženého fyzického záznamu relativně k nové kotvě jmen.

Prostě:

```text
newOffset = newNameAddress - newNameAnchor
```

Nový vektor začíná s oběma flags vynulovanými:

```text
DEFINED = 0
LOCKED  = 0
```

Slovo hodnoty začíná nulou. Symbol existuje, ale jeho hodnota zůstává neznámá, dokud ji nedefinuje pozdější průchod nebo direktiva.

## Oprav offsety posunutých vektorů

Vložení fyzického záznamu posune tento záznam a každý abecedně pozdější záznam vzhůru o `nameLength + 2` bajtů.

Jejich vektory se musí zvýšit o stejnou délku. Záznamy abecedně před místem vložení se nepohnuly a jejich offsety zůstávají stejné.

Pravidlo opravy je:

```text
for each existující vektor:
    if vector.offset >= newRecordInsertionOffset:
        vector.offset += newRecordLength
```

Kód porovnává každý očištěný čtrnáctibitový offset s offsetem vložení nového symbolu a pro dotčené vektory volá `increaseAtHLbyBC`.

Všimněme si, co se *nemění*:

- stará pořadová čísla;
- záznamy zdroje;
- hodnoty a jména před místem vložení;
- flags v existujících vektorech.

Opravuje se pouze malá vrstva nepřímosti.

## Příklad vytvoření

Začněme dvěma symboly nalezenými v tomto pořadí:

```text
pořadové číslo 1 = LOOP
pořadové číslo 2 = SCREEN
```

Fyzické záznamy:

```text
LOOP
SCREEN
```

Nyní zdroj poprvé zmíní `ALPHA`.

Nové pořadové číslo se připojí:

```text
pořadové číslo 1 = LOOP
pořadové číslo 2 = SCREEN
pořadové číslo 3 = ALPHA
```

Záznam se však vloží abecedně:

```text
ALPHA
LOOP
SCREEN
```

Vektory `LOOP` a `SCREEN` se zvýší, protože jejich záznamy se posunuly. Nový vektor 3 ukazuje v pořadí čísel zpět na první fyzický záznam.

Existující komprimovaný zdroj stále obsahuje pořadová čísla 1 a 2 a nepotřebuje žádnou změnu.

To je odměna za tento návrh.

## TABLE L a TABLE U

Vytvoření a definice nejsou jediné přechody stavu. Příkazy tabulky mohou všechny symboly zamknout nebo odemknout.

PROMETHEUS používá pro obě operace jedinou smyčku. Samotná instrukce pracující s každým high bajtem vektoru se modifikuje.

Pro `TABLE L` je vybraná instrukce koncepčně:

```asm
SET 7,(HL)
```

Pro `TABLE U` se změní na:

```asm
RES 7,(HL)
```

Zdroj obsahuje:

```asm
varcSymbolVectorFlagInstruction:
    set 7,(hl)
```

a druhý bajt opcode se před smyčkou vektorů patchuje.

Je to klasický vzor PROMETHEA:

```text
jeden průchod
jedna samomodifikovaná drobná operace
několik významů příkazu
```

Zamčení nemění jména, hodnoty ani offsety. Pouze nastaví bit 7 v každém high bajtu vektoru.

## Co zamčení znamená

Zamčený symbol se považuje za symbol s použitelnou hodnotou i po vymazání běžného stavu DEFINED.

To může podporovat workflow jako:

```text
sestav nebo načti skupinu známých adres
zamkni tabulku symbolů
vymaž nebo nahraď zdroj
použij zachované hodnoty v jiném sestavení
```

Zámek nezabrání fyzické komprimaci tabulky, ale `TABLE C` zamčený symbol neodstraní. Jeho identita a hodnota přežijí.

Odemčení tuto ochranu odstraní. Pokud symbol není odkazován aktuálním zdrojem ani jinak znovu definován, může jej pozdější komprimace odstranit.

## Proč se nepoužívané symboly hromadí

Zadání jména symbol okamžitě vytvoří. Pozdější editace může odstranit každý řádek zdroje, který se na něj odkazuje.

Například:

```asm
        LD HL,TEMP
```

vytvoří `TEMP`. Smaže-li se řádek, symbol v tabulce zůstane. Je to záměrné: smazání jediného řádku zdroje nemá okamžitě spustit drahé prohledání celého zdroje a přepis tabulky.

Opuštěná jména však postupně spotřebovávají paměť a zanášejí výstup `TABLE`. Operace `TABLE C` na vyžádání provede explicitní garbage collection.

## TABLE C je mark-and-compact collector

Algoritmus má pět hlavních fází:

```text
1. vymaž dočasné značky
2. projdi zdroj a označ každý odkazovaný symbol
3. odstraň každý neoznačený a nezamčený symbol
4. oprav offsety vektorů a pořadová čísla ve zdroji
5. znovu vymaž dočasné značky
```

Připomíná garbage collector:

- záznamy zdroje jsou kořeny;
- odkazy na symboly jsou hrany k živým objektům;
- symboly LOCKED jsou trvalé kořeny;
- neodkazované a nezamčené symboly jsou garbage.

Program jej nenazývá heap collectorem, ale myšlenkový vzor je stejný.

## Bit 6 dočasně mění význam

Za normálních okolností bit 6 znamená DEFINED. Na začátku `TABLE C` jej PROMETHEUS ve všech vektorech vymaže a zachová přitom bit 7.

Tatáž smyčka vektorů používaná pro zamknutí a odemknutí se nakonfiguruje jako:

```asm
RES 6,(HL)
```

Během mark fáze už bit 6 neznamená „definováno prvním průchodem“. Znamená:

```text
odkazováno někde v aktuálním komprimovaném zdroji
```

Opětovné použití bitu odstraňuje potřebu samostatné mark bitmapy.

Tato dočasná změna je bezpečná, protože komprimace je explicitní operace a běžný stav definic se při příštím průchodu assembleru znovu vybuduje.

## Hledání odkazů na symboly ve zdroji

Scanner zdroje musí rozumět kompaktnímu jazyku záznamů z kapitoly 12.

Odkaz na symbol se může objevit:

- jako volitelné pořadové číslo labelu řádku za dvoubajtovou hlavičkou;
- uvnitř jednoho nebo více zakódovaných payloadů expressionů.

Scanner přeskakuje:

- literal bajty pod `$80`;
- druhý bajt patřící tagovanému pořadovému číslu;
- terminálové a zpětně odkazující bajty záznamu na `$C0` nebo výše.

Zdroj obsahuje:

```asm
findNextSymbolReferenceInSource:
.findNextSourceRecordWithSymbolReference:
    call comparePositionWithCodeEnd
    ret nc
    inc hl
    ld a,(hl)
    and 00fh
    inc hl
    jr z,.findNextSourceRecordWithSymbolReference
    and 008h
    jr nz,.returnFoundSymbolReference
findNextSymbolReferenceInPayload:
.scanSourcePayloadForSymbolReference:
    ld a,(hl)
    inc hl
    cp 0c0h
    jr nc,.findNextSourceRecordWithSymbolReference
    cp 080h
    jr c,.scanSourcePayloadForSymbolReference
```

Zde se ukazuje výhoda dobře navrženého kompaktního formátu. Collector nemusí zdroj expandovat na text. Odkazy pozná přímo podle tříd bajtů.

Každé nalezené pořadové číslo se vyřeší na svůj vektor a nastaví se bit 6.

## Rozhodnutí, co lze odstranit

Po označení collector prohlédne každý vektor.

Symbol se zachová, je-li nastaven kterýkoli z horních flags:

```text
bit 6 označený ze zdroje
or
bit 7 zamčený
```

Symbol lze odstranit, pokud:

```text
(flags & $C0) == 0
```

To znamená:

```text
aktuální zdroj na něj neodkazuje
and
není zamčený
```

Stará hodnota nehraje roli. Dříve definovaný, ale nyní nepoužívaný odemčený symbol je kandidátem k odstranění.

## Odstranění fyzického záznamu

Vektor poskytne offset jména symbolu. Collector se vrátí o dva bajty, aby zahrnul slovo hodnoty, a potom skenuje až k high-bit terminátoru jména.

Odstraňovaný rozsah je:

```text
low bajt hodnoty
high bajt hodnoty
všechny bajty jména až po poslední tagovaný znak včetně
```

`closeDeletedSymbolDataGap` přesune bajty nad tímto záznamem dolů. Koncový ukazatel se zmenší o délku záznamu a uvolněné bajty nahoře se vynulují.

Fyzické záznamy za odstraněným záznamem se posunuly dolů. Offsety jejich vektorů se musí zmenšit o délku odstraněného záznamu.

Pravidlo je opačné než při vložení:

```text
for each přeživší vektor:
    if vector.offset >= removedRecordOffset:
        vector.offset -= removedRecordLength
```

## Odstranění vektoru pořadového čísla

Collector také zavře dvoubajtovou mezeru po odstraněném vektoru a sníží počet symbolů.

Tato operace narušuje strukturu více než smazání fyzického záznamu, protože pozice pořadových čísel nad odstraněnou pozicí se posunou dolů:

```text
před:
    1 ALPHA
    2 LOOP
    3 SCREEN

odstraň pořadové číslo 2:
    1 ALPHA
    2 SCREEN
```

Každý odkaz ve zdroji na staré pořadové číslo 3 se musí změnit na 2.

Právě této situaci se návrh se stabilními vektory za normálních okolností vyhýbá, ale skutečné smazání symbolu pořadí čísel nutně změní. PROMETHEUS tuto cenu platí pouze při explicitním `TABLE C`.

## Přepis pořadových čísel ve zdroji

Po určení odstraněného pořadového čísla collector znovu projde celý zdroj.

Pro každé zakódované pořadové číslo:

```text
if ordinal >= removedOrdinal:
    ordinal -= 1
else:
    ponech beze změny
```

Skutečné porovnání snižuje pořadová čísla větší nebo rovna odstraněnému. V platné tabulce by neměl existovat odkaz ve zdroji rovný odstraněnému číslu, protože mark fáze by takový symbol zachovala. Rovnost by odporovala rozhodnutí collectoru o živosti; inkluzivní porovnání udržuje smyčku kompaktní.

Bajty zdroje se aktualizují na místě. V uloženém high bajtu pořadového čísla se zachová high tag bit.

Algoritmus se opakuje pro každý odstranitelný symbol. Může to vyžadovat několik úplných průchodů zdrojem a několik přesunů zabalené paměti, což vysvětluje, proč je `TABLE C` poměrně pomalý údržbový příkaz, nikoli automatická akce po každé editaci.

## Proč odstraňování probíhá na místě

Jednodušší program by mohl postavit novou tabulku jinde a potom jí starou nahradit. PROMETHEUS si nemůže bezstarostně rezervovat další oblast velikosti celé tabulky.

Komprimace na místě má výhody:

- žádné duplicitní úložiště tabulky;
- žádná druhá kopie zdroje;
- přesné získání každého odstraněného bajtu;
- pokračující použití sdílené oblasti zdroje a symbolů.

Cenou je algoritmická pečlivost. Každý přesun vyžaduje opravu offsetů a každé smazání pořadového čísla vyžaduje přepis zdroje.

Je to známý kompromis malých systémů:

```text
šetři paměť za cenu kódu a času
```

## CLEAR používá stejný úklidový mechanismus

Příkaz `CLEAR` po potvrzení odstraní celý editovatelný zdroj. Jakmile zdroj zmizí, mnoho běžných symbolů již není odkazováno.

PROMETHEUS přejde do stejné úklidové logiky symbolů. Zamčené symboly mohou přežít; odemčené neodkazované symboly se odstraní.

Toto znovupoužití udržuje jednotný význam:

```text
kořeny ve zdroji určují živost běžných symbolů
lock bity zachovávají výslovně uchované symboly
```

## Definice se záměrně vymažou

Na konci `TABLE C` se ve všech přeživších vektorech znovu vymaže bit 6.

Pro odemčené přeživší to znamená:

```text
jméno zůstává
hodnota může fyzicky zůstat přítomná
ale nebude přijata, dokud ji nový průchod znovu nedefinuje
```

Zamčené symboly si ponechají bit 7 a zůstávají použitelné.

To brání staré odemčené hodnotě, aby se po změně zdroje tiše vydávala za aktuální definici. Příští první průchod znovu vybuduje běžný stav DEFINED ze skutečných labelů a direktiv `EQU`.

## Úplný příklad komprimace

Předpokládejme, že tabulka obsahuje:

```text
pořadové číslo 1 = START   odkazováno
pořadové číslo 2 = TEMP    již není odkazováno
pořadové číslo 3 = SCREEN  zamčeno
pořadové číslo 4 = LOOP    odkazováno
```

Mark fáze vytvoří:

```text
START   bit6 = 1, bit7 = 0
TEMP    bit6 = 0, bit7 = 0
SCREEN  bit6 = 0, bit7 = 1
LOOP    bit6 = 1, bit7 = 0
```

`TEMP` se odstraní.

Mezera po fyzickém záznamu se zavře. Offsety za `TEMP` se zmenší. Pole vektorů se změní ze čtyř položek na tři:

```text
nové pořadové číslo 1 = START
nové pořadové číslo 2 = SCREEN
nové pořadové číslo 3 = LOOP
```

Scanner zdroje potom změní každé staré pořadové číslo 3 na 2 a každé staré pořadové číslo 4 na 3.

Nakonec se vymaže bit 6:

```text
START   existuje, právě nedefinován
SCREEN  zamčen a použitelný
LOOP    existuje, právě nedefinován
```

Příští průchod assembleru znovu definuje `START` a `LOOP` ze zdroje.

## Vkládání a mazání jsou zrcadla, ale ne přesná

Vkládání a mazání fyzického záznamu mají symetrická pravidla offsetů:

```text
vlož před offset T:
    offsety >= T se zvýší o vloženou délku

smaž na offsetu T:
    offsety >= T se sníží o odstraněnou délku
```

Zacházení s pořadovými čísly je asymetrické:

```text
vytvoření:
    připoj nový vektor
    stará pořadová čísla se nemění

smazání:
    odstraň vektor ze středu
    pozdější pořadová čísla se sníží
```

Tato asymetrie je záměrná. Vytváření je při běžné editaci časté, takže je navrženo levně pro odkazy ve zdroji. Mazání se odkládá na explicitní úklid, při němž je dražší přepis přijatelný.

## Záznam zdroje je kořenovou množinou collectoru

Stojí za to na chvíli odstoupit od instrukcí a registrů.

Symbol přežije `TABLE C` z jednoho ze dvou důvodů:

1. některý aktuální záznam zdroje jej jmenuje;
2. programátor jej zamkl.

Je to sémantické pravidlo, nikoli pouze pravidlo rozložení paměti.

Collector je zjišťuje přímým čtením kompaktní syntaxe zdroje. Moderními slovy:

```text
komprimované záznamy zdroje = kořenový graf
vektory symbolů             = handly a stav
záznamy hodnot a jmen       = spravované objekty
TABLE C                     = explicitní mark-and-compact collection
```

PROMETHEUS nebyl navržen jako objektový systém, ale objevují se v něm stejné základní problémy identity, dosažitelnosti a relokace.

## Bezpečnost při selhání

Kód obecně kontroluje prostor před vložením a provádí údržbu v pořadí, v němž má každý krok informace potřebné k opravě následujícího.

Přesto tyto operace předpokládají, že invarianty tabulky jsou již správné:

- počet odpovídá poli vektorů;
- každý offset vektoru vybírá platné jméno;
- každé jméno má závěrečnou značku high bitu;
- každé zakódované pořadové číslo ve zdroji leží v rozsahu počtu;
- zabalený zdroj a tabulka končí na `varcCodeEndPt+1`.

Poškozená tabulka by mohla přimět scanner, aby pokračoval do nesouvisející paměti. Kompaktní formát obsahuje jen málo redundance pro obrannou validaci. To je běžné u rezidentního programu navrženého ke správě vlastních důvěryhodných struktur.

Pro projekt resurrection jsou tyto invarianty cennými cíli testů a diagnostických nástrojů, i když je původní runtime všechny nekontroluje.

## Prostým pseudokódem

Vytvoření symbolu:

```text
function findOrCreateSymbol(name):
    normalized = normalizeName(name)

    existing = findOrdinal(normalized)
    if existing exists:
        return existing

    requireSpace(maximumNewEntrySize)

    oldCount = symbolCount
    newOrdinal = oldCount + 1

    openTwoByteGapAtEndOfVectorArray()
    codeEnd += 2

    insertionPoint = findAlphabeticalInsertionPoint(normalized)
    entryLength = 2 + length(normalized)

    openGap(insertionPoint, entryLength)
    copy([zeroValueWord, normalizedName], insertionPoint)
    codeEnd += entryLength
    symbolCount += 1

    newOffset = addressOfNewName - newNameAnchor

    for each old vector:
        if vector.offset >= newOffset:
            vector.offset += entryLength

    appendVector(offset=newOffset, defined=false, locked=false)
    return newOrdinal
```

Zamčení nebo odemčení všech symbolů:

```text
function setAllLocks(wantedState):
    patch vectorOperation na SET bit7 or RES bit7
    for every high bajt vektoru:
        execute patchovanou operaci
```

Komprimace nepoužívaných symbolů:

```text
function compactSymbols():
    clear bit6 v každém vektoru

    for each odkaz na symbol v komprimovaném zdroji:
        set bit6 v odkazovaném vektoru

    ordinal = 1
    while ordinal <= symbolCount:
        vector = vectorAt(ordinal)

        if vector.bit6 == 0 and vector.bit7 == 0:
            removedEntryOffset = vector.offset
            removedEntryLength = deletePhysicalValueNameRecord(vector)
            deleteVector(ordinal)
            symbolCount -= 1

            for each přeživší vektor, jehož offset následoval odstraněný záznam:
                vector.offset -= removedEntryLength

            for each zakódované pořadové číslo symbolu ve zdroji:
                if encodedOrdinal >= ordinal:
                    encodedOrdinal -= 1

            # nezvyšuj ordinal: tento slot nyní zabírá nový vektor
        else:
            ordinal += 1

    clear bit6 v každém přeživším vektoru
```

## Co se změnilo v paměti

Po vytvoření nového symbolu:

- počet v tabulce se zvýšil o jedna;
- pole vektorů je o dva bajty delší;
- abecedně se vložil nulový záznam ukončený high bitem;
- offsety posunutých záznamů se zvýšily;
- na konec se připojil nový vektor bez flags;
- `varcCodeEndPt+1` se posunul vzhůru;
- existující pořadová čísla v komprimovaném zdroji se nezměnila.

Po `TABLE L` nebo `TABLE U`:

- v každém high bajtu vektoru se nastavil nebo vymazal bit 7;
- jména, hodnoty, offsety a záznamy zdroje se nezměnily.

Po `TABLE C`:

- neodkazované a nezamčené záznamy hodnot a jmen zmizely;
- jejich sloty vektorů zmizely;
- offsety přeživších se tam, kde bylo třeba, zmenšily;
- pořadová čísla ve zdroji nad každým odstraněným číslem se snížila;
- počet a koncový ukazatel jsou menší;
- bit 6 se u přeživších vymazal;
- zamčené symboly si ponechaly bit 7 a použitelné uložené hodnoty.

## Důležité labely, na které jsme narazili

- `findOrCreateSymbolOrdinal`
- `symbolEntryCreationPrefix`
- `varcNewSymbolVectorSlot`
- `varcSymbolEntryAreaBase`
- `varcCodeEndPt`
- `ensureBCBytesFitBelowUTop`
- `moveMemoryBlockOverlapSafe`
- `processSymbolTableItems`
- `varcSymbolVectorFlagInstruction`
- `findNextSymbolReferenceInSource`
- `findNextSymbolReferenceInPayload`
- `varcSymbolEntryAreaBaseForCleanup`
- `varcRemovedSymbolEntryOffset`
- `varcCurrentCompactionVectorPointer`
- `advanceSymbolVectorAndLoadOffset`
- `closeDeletedSymbolDataGap`

## Zpět k celkovému obrazu

Část III nyní sestavila přední polovinu sémantického stroje assembleru:

```text
slovo ve zdroji
    ↓
třídy mnemonic a operandů
    ↓
zakódované expressiony
    ↓
stabilní pořadová čísla symbolů
    ↓
pohyblivé abecední záznamy
    ↓
hodnoty a stavové flags používané během průchodů
```

Víme také, jak tabulka zůstává zdravá, když se jména zavádějí a později opouštějí.

Další kapitola přejde od datových struktur k činnosti. První průchod projde každý záznam zdroje, definuje labely, vyhodnotí `EQU`, zpracuje direktivy řídící adresu a předpoví, kolik bajtů každý řádek zabere. Je to fáze, která symbolický svět popsaný v kapitolách 22–24 promění v úplnou mapu budoucího programu ve strojovém kódu.
