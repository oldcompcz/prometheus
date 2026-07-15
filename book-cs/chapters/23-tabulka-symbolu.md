# Kapitola 23: Tabulka symbolů

Tabulka symbolů zní jako slovník:

```text
START  = 32768
LOOP   = 32771
SCREEN = 16384
```

Tento popis je pravdivý, ale neúplný. PROMETHEUS potřebuje, aby tatáž sbírka jmen plnila několik různých úloh.

Assembler chce symbol rychle najít, když programátor napíše jeho jméno. Záznamy zdroje potřebují krátký a stabilní odkaz, který se nezmění pokaždé, když se tabulka přesune. Příkaz `TABLE` chce jména zobrazovat abecedně. První průchod potřebuje symbol označit jako definovaný. Při oddělené práci může být nutné ponechat uloženou hodnotu zamčenou. `TABLE C` chce odstranit nepoužívaná jména a zbývající bajty zkompaktovat.

Jediný prostý seznam by alespoň jednu z těchto úloh činil nepohodlnou. PROMETHEUS proto tabulku ukládá současně ve **dvou pořadích**:

- pole vektorů pořadových čísel, v němž pozice dávají symbolům stabilní čísla;
- abecední oblast hodnot a jmen, jejíž záznamy se dobře zobrazují a hledají podle zápisu.

Obě pořadí spojuje pole vektorů.

Tento návrh patří k nejelegantnějším datovým strukturám celého programu. Je také dobrým příkladem toho, co programátoři dělali při nedostatku paměti: místo několika úplných indexů uložili jen drobnou vrstvu nepřímosti.

## Kde tabulka leží

Tabulka symbolů nemá pevnou adresu. Leží bezprostředně nad komprimovaným zdrojem a přesouvá se při každém vložení nebo smazání záznamů zdroje.

Hrubé uspořádání vypadá takto:

```text
nízké adresy

    komprimované záznamy zdroje
    trvalá výplň prázdnými záznamy

    začátek tabulky symbolů  ← varcSymbolTablePt
        dvoubajtový počet symbolů
        dvoubajtové vektory pořadových čísel
        seřazené záznamy hodnot a jmen

    první nepoužitý bajt     ← varcCodeEndPt

vysoké adresy
```

Toto uspořádání dovoluje zdroji a symbolům sdílet jednu rostoucí zabalenou oblast.

Vloží-li se pod tabulku nový záznam zdroje, celá tabulka symbolů se posune vzhůru. Smaže-li se záznam zdroje, posune se dolů. Žádný záznam zdroje neobsahuje přímou adresu do tabulky, takže tyto přesuny odkazy na symboly nezneplatní.

Expressiony zdroje místo toho obsahují pořadová čísla, například:

```text
symbol 1
symbol 2
symbol 37
```

Vektor příslušného pořadového čísla na aktuálním začátku tabulky řekne PROMETHEU, kde nyní skutečně leží jméno a hodnota.

## Přesné uspořádání

Označme `P` aktuální adresu uloženou ve `varcSymbolTablePt+1` a `N` počet symbolů.

Tabulka začíná:

```text
P+0   low bajt počtu
P+1   high bajt počtu
```

Za nimi následuje `N` dvoubajtových vektorů:

```text
P+2            vektor pro pořadové číslo 1
P+4            vektor pro pořadové číslo 2
P+6            vektor pro pořadové číslo 3
...
P+2+2*(N-1)    vektor pro pořadové číslo N
```

Za vektory leží fyzické záznamy symbolů seřazené abecedně podle jména:

```text
low bajt hodnoty
high bajt hodnoty
znak jména 1
znak jména 2
...
poslední znak jména s nastaveným bitem 7
```

Trvalý bajt délky jména neexistuje.

Malá tabulka by koncepčně mohla vypadat takto:

```text
P:
    03 00                   tři symboly

    vektor pořadového čísla 1  ───────────────┐
    vektor pořadového čísla 2  ───────┐       │
    vektor pořadového čísla 3  ───┐   │       │
                                   │   │       │
    $8000  "ALPHA"               ◄───┘       │
    $8010  "LOOP"                ◄───────────┘
    $4000  "SCREEN"              ◄──────────── jiný vektor
```

Fyzické záznamy jsou seřazeny abecedně:

```text
ALPHA
LOOP
SCREEN
```

Pořadí čísel závisí na tom, kdy program na jména narazil poprvé. Může být například:

```text
pořadové číslo 1 = LOOP
pořadové číslo 2 = SCREEN
pořadové číslo 3 = ALPHA
```

Vektory dovolují, aby obě pořadí existovala současně.

## Proč se čísluje od jedničky

První symbol má pořadové číslo 1, nikoli 0.

To pohodlně zapadá do aritmetiky tabulky. První dva bajty zabírá počet a zdvojené pořadové číslo přirozeně dosáhne na odpovídající vektor od začátku tabulky:

```text
vectorAddress = P + 2 * ordinal
```

Pro pořadové číslo 1:

```text
P + 2
```

což je první vektor.

Pro pořadové číslo 2:

```text
P + 4
```

což je druhý.

Tagované pořadové číslo uložené ve expressionu zdroje má v high bajtu nastaven bit 7. Resolver tento tag před použitím pořadového čísla jako čísla odstraní.

## Vektor je offset a dva flags

Každý vektor je šestnáctibitové slovo v pořadí little-endian, ale ne všech šestnáct bitů patří offsetu adresy.

```text
bity 0–13   offset do abecední oblasti záznamů
bit 14      DEFINED nebo dočasná značka TABLE C
bit 15      LOCKED
```

V uloženém high bajtu to znamená:

```text
bit 6       DEFINED / dočasná značka
bit 7       LOCKED
```

Zbývajících šest bitů high bajtu se spojí s low bajtem do čtrnáctibitového offsetu.

Proto kód opakovaně používá:

```asm
    and 03fh
```

než začne s vektorem zacházet jako s offsetem adresy. `$3F` ponechá šest spodních bitů a oba flags odstraní.

Jediný vektor tedy dokáže odpovědět na dvě otázky:

```text
Kde leží fyzický záznam symbolu?
Jaký je aktuální stav symbolu?
```

## Vůči čemu se offset počítá

Offset není vztažen prostě k `P`. Jeho kotvou je první možný bajt jména za počtem, polem vektorů a prvním slovem hodnoty.

Koncepčně:

```text
nameAnchor = P + 2 + 2*N + 2
```

Poslední `+2` přeskočí slovo hodnoty patřící prvnímu abecednímu záznamu.

Potom:

```text
nameAddress  = nameAnchor + (vector & $3FFF)
valueAddress = nameAddress - 2
```

Offset prvního jména je tedy nula.

Tato volba ušetří každému vektoru nutnost zahrnout do displacementu dvoubajtový prefix hodnoty. Zároveň dovoluje resolveru vracet mimořádně užitečnou trojici adres:

```text
DE   = první znak jména
DE-2 = low bajt hodnoty
HL   = adresa high bajtu vektoru obsahujícího flags
```

Jediná operace vyřešení tak dá volajícím přístup ke všem třem stránkám symbolu: identitě, hodnotě a stavu.

## Jména se normalizují

Jména symbolů v PROMETHEU mají nejvýše osm znaků vybraných z:

```text
písmena
číslice
podtržítko
```

Písmena se ukládají velká. Proto:

```text
Loop
LOOP
loop
```

odkazují na tentýž symbol.

`parseSymbolNameAndFindOrdinal` shromažďuje dočasný normalizovaný zápis v `numberStringBuffer+1` a jeho délku uloží do `numberStringBuffer`.

Příslušná smyčka je:

```asm
parseSymbolNameAndFindOrdinal:
    ld de,numberStringBuffer+1
    ld b,000h
.collectNormalizedSymbolNameLoop:
    call atHLorNextIfOne
    call isNumber
    jr z,.storeNormalizedSymbolCharacter
    res 5,a
    cp "_"
    jr z,.storeNormalizedSymbolCharacter
    call isLetter
    jr nz,.finishNormalizedSymbolName
.storeNormalizedSymbolCharacter:
    ld (de),a
    inc de
    inc hl
    inc b
    ld a,b
    cp LABEL_LENGTH
    jr c,.collectNormalizedSymbolNameLoop
    jp syntaxError
```

`LABEL_LENGTH` je devět, protože chyba nastane při pokusu shromáždit devátý znak. Osm znaků je povoleno.

Po dokončení sběru se na dočasném posledním znaku nastaví bit 7. Zápis se tím stane kompatibilním s trvalým formátem ukončeným high bitem, který PROMETHEUS používá i jinde.

## Jména nemají uloženou délku

Trvalé jméno vypadá takto:

```text
'L' 'O' 'O' ('P' | $80)
```

Čtenář maskuje bit 7, aby získal viditelný poslední znak, a zároveň pozná, že jméno právě skončilo.

Tím se ušetří jeden bajt délky na každý symbol. Scanner také může jméno přeskočit velmi malou smyčkou:

```text
repeat:
    byte = *pointer++
until byte má nastaven bit 7
```

Počet symbolů říká programu, kolik záznamů existuje. High bit říká, kde končí každý jednotlivý zápis.

## Hledání jména

Jakmile je dočasný zápis připraven, rutina prohledává vektory od nejvyššího pořadového čísla směrem dolů.

Proč prohledávat vektory, a ne již abecedně seřazené záznamy? Protože encoder zdroje potřebuje jako výsledek právě pořadové číslo. Přímé abecední hledání by našlo adresu záznamu a potom by bylo nutné dalším hledáním zjistit, který vektor na něj ukazuje.

Pro každý vektor lookup provede:

```text
odstraň flags DEFINED a LOCKED
přičti offset k aktuální kotvě jmen
porovnej dočasný zápis s trvalým jménem ukončeným high bitem
if jsou shodné, return toto pořadové číslo
```

Skutečná porovnávací smyčka je malá, protože dočasná délka je již známa:

```asm
.compareCandidateSymbolNameLoop:
    ld a,(de)
    cp (hl)
    jr nz,.candidateSymbolNameMismatch
    inc hl
    inc de
    djnz .compareCandidateSymbolNameLoop
```

Uložený poslední znak má stále nastaven bit 7 a stejně byl označen i dočasný poslední znak. Přesné porovnání proto současně kontroluje znaky i délku. `LOOP` se nemůže omylem shodovat s `LOOP2`.

Při úspěchu:

```text
carry clear
HL = jedničkově číslované pořadové číslo
```

Při neúspěchu:

```text
carry set
dočasný normalizovaný zápis zůstává k dispozici pro vytvoření
```

Je to užitečný kontrakt: drahá normalizace se neopakuje, když se volající rozhodne nový symbol vytvořit.

## Vyřešení pořadového čísla

Opačný směr zajišťuje `resolveSymbolReferenceToName`.

Vstup:

```text
DE = tagované dvoubajtové pořadové číslo ze záznamu zdroje
```

Rutina:

1. odstraní tag bit;
2. zdvojnásobí pořadové číslo a najde jeho vektor;
3. zachová adresu high bajtu vektoru;
4. odstraní z offsetu DEFINED a LOCKED;
5. vypočítá aktuální kotvu jmen z aktuálního počtu;
6. přičte čtrnáctibitový offset.

Její kontrakt je záměrně bohatý:

```text
HL = adresa high bajtu vektoru
DE = adresa jména symbolu
DE-2 = adresa hodnoty symbolu
```

Různí volající používají různé části.

Evaluator expressionu testuje `(HL) & $C0` a potom načte hodnotu z `DE-2`. Expander zdroje kopíruje jméno od `DE`. `TABLE L` a `TABLE U` mění flag bity v high bajtech vektorů. První průchod zapisuje hodnotu a nastavuje DEFINED.

Jediná rutina udržuje celou tabulku soudržnou.

## DEFINED neznamená „jméno existuje“

Jméno může v tabulce existovat, aniž má právě platnou hodnotu.

Přirozeně se to stává u dopředných odkazů:

```asm
        JR LOOP
        ...
LOOP    RET
```

Když se zadá první řádek, `LOOP` lze vytvořit jako symbol, aby záznam zdroje mohl uložit jeho pořadové číslo. Žádný průchod assembleru však zatím nedošel k labelu a nepřiřadil mu adresu.

Vektor proto začíná s oběma stavovými flags vynulovanými:

```text
existuje: ano
definován: ne
zamčen: ne
```

Když první průchod narazí na definici labelu, zapíše PROMETHEUS aktuální logickou adresu do slova hodnoty a nastaví bit 6.

Rozdíl je tento:

```text
identita symbolu může být známa dříve než jeho hodnota
```

To je základ dopředných odkazů.

## Hodnoty LOCKED přežívají jinak

Bit 7 znamená LOCKED.

Uložená hodnota zamčeného symbolu se považuje za známou i tehdy, když není nastaven běžný bit DEFINED. Evaluatory expressionů symbol přijmou, pokud:

```text
(flags & $C0) != 0
```

takže stačí kterýkoli z obou flags.

To podporuje určitou formu oddělené práce. Programátor může zachovat vybrané hodnoty symbolů přes vymazání nebo opětovné sestavení zdroje. Přesný workflow řídí příkazy `TABLE L`, `TABLE U` a `TABLE C`, popsané v kapitole 24.

LOCKED se nesmí chápat jako „bajty se nesmějí přesunout“. Fyzický záznam se může při změnách zdroje nebo jiných symbolů dále pohybovat. LOCKED chrání význam a uloženou hodnotu, nikoli adresu záznamu v tabulce.

## Slova hodnoty nemají flags

Každý abecední záznam začíná prostou dvoubajtovou hodnotou:

```text
low bajt hodnoty
high bajt hodnoty
```

Flags neleží vedle ní. Jsou v příslušném vektoru pořadového čísla.

Toto oddělení má důsledek při zobrazování tabulky. PROMETHEUS prochází abecední záznamy, protože právě takové pořadí chceme zobrazit, ale pro každý záznam musí najít vektor, který ukazuje na jeho jméno, aby zjistil flags.

Zobrazení tabulky tedy provádí malý zpětný lookup:

```text
for each abecední záznam symbolu:
    najdi vektor, jehož maskovaný offset vybírá tento záznam
    přečti LOCKED a DEFINED z vektoru
    naformátuj jméno a hodnotu
```

Stojí to čas, ale šetří redundantní flag bajty a zachovává návrh se dvěma pořadími.

## Zobrazení TABLE

Běžný příkaz `TABLE` ukazuje čtyřicet symbolů na stránku ve dvou sloupcích po dvaceti.

Zobrazený řádek koncepčně obsahuje:

```text
značku zamčení
jméno symbolu
hodnotu nebo značku nedefinovaného stavu
```

Konvence jsou:

```text
'*'       symbol je zamčen
' '       symbol není zamčen
'.....'   DEFINED ani LOCKED neposkytuje použitelnou hodnotu
číslo     hodnota je známá
```

Tabulka může podle aktuálního režimu výstupu používat desítkové nebo hexadecimální formátování čísel.

Fyzické záznamy již leží abecedně, takže vlastní průchod zobrazením je na této úrovni přímočarý. Dodatečné hledání vektoru je potřeba jen kvůli flags.

Screen driver vymaže řádky tabulky, vykreslí levý sloupec, potom pravý a čeká na klávesu:

```text
SPACE      opustí zobrazení tabulky
jiná klávesa  přejde na další stránku
```

`TABLE P` používá tentýž základní průchod a současně směruje každou naformátovanou položku do cesty tiskárny.

## Malý příklad

Předpokládejme, že programátor nejprve napíše řádky zmiňující symboly v tomto pořadí:

```text
LOOP
SCREEN
ALPHA
```

Pořadová čísla budou:

```text
1 = LOOP
2 = SCREEN
3 = ALPHA
```

A předpokládejme hodnoty:

```text
LOOP   = $8010
SCREEN = $4000
ALPHA  = $8000
```

Tabulku si můžeme představit takto:

```text
count = 3

vektory pořadových čísel:
    [1] offset LOOP   + flags
    [2] offset SCREEN + flags
    [3] offset ALPHA  + flags

abecední záznamy:
    $8000, ALPHA
    $8010, LOOP
    $4000, SCREEN
```

Záznam zdroje obsahující pořadové číslo 1 vždy znamená `LOOP`, i když se fyzický záznam `LOOP` posune po vložení `ALPHA` před něj.

Při vložení nového dřívějšího jména se vektor `LOOP` upraví na nový fyzický offset. Pořadové číslo ve zdroji zůstane 1.

Právě tento problém řeší nepřímost.

## Proč neukládat přímé ukazatele

Představme si, že každý odkaz ve zdroji ukládá adresu záznamu symbolu.

Vložení jediného řádku zdroje by potom přesunulo celou tabulku a vyžadovalo nalezení a přepsání každého odkazu na symbol ve zdroji. Přidání jednoho abecedně dřívějšího symbolu by posunulo pozdější záznamy a vyžadovalo další přepis. Načtení uloženého balíku zdroje na jinou adresu by zneplatnilo všechny odkazy.

Pořadová čísla těmto problémům předcházejí:

```text
záznam zdroje ukládá stabilní identitu
vektor překládá identitu na aktuální místo
```

Samotné vektory se při fyzickém přesunu záznamů opravovat musí, ale na každý symbol existuje jen jeden vektor. Symbol použitý padesátkrát stále vyžaduje úpravu jediného offsetu.

Je to tatáž obecná myšlenka, kterou používá mnoho pozdějších systémů:

- handly objektů;
- tabulky file descriptorů;
- relokační tabulky;
- indexy do poolů stringů;
- virtuální adresy překládané na fyzické.

PROMETHEUS ji používá v mimořádně kompaktní podobě.

## Proč neudržovat záznamy v pořadí čísel

Kdyby byly záznamy uloženy v pořadí pořadových čísel, řešení odkazu ze zdroje by bylo snadné, ale abecední výpis tabulky a porovnávání jmen by bylo méně pohodlné.

Kdyby pořadová čísla byla prostě abecedními pozicemi, přidání `ALPHA` před `LOOP` by změnilo každé následující číslo a přinutilo přepsat celý komprimovaný zdroj.

Zvolený návrh odděluje:

```text
stabilní pořadí identity      = vektory pořadových čísel
proměnlivé pořadí zápisu      = abecední záznamy
```

Nový vektor se připojí na konec, takže existující identity zůstanou stejné. Jeho fyzický záznam se vloží abecedně, takže čitelné pořadí zůstane zachováno.

Kapitola 24 ukáže pečlivé opravy offsetů, které to umožňují.

## Samotný začátek tabulky se pohybuje

Je třeba rozlišovat dvě úrovně pohybu.

### Přesun celé tabulky

Editace komprimovaného zdroje mění adresu uloženou ve `varcSymbolTablePt+1`. Celá tabulka se přesune společně. Relativní offsety vektorů zůstávají platné, protože vektory i záznamy se posunuly o stejnou vzdálenost.

### Přesun záznamů uvnitř tabulky

Vytvoření nebo smazání symbolu mění pozice *uvnitř* tabulky. Některé offsety vektorů se potom musí upravit, protože vektory a záznamy jmen se neposunou všechny stejně.

Tento rozdíl vysvětluje, proč vložení do zdroje může použít obecnou opravu ukazatelů, zatímco vložení symbolu potřebuje specializovanou opravu vektorů.

## Koncový ukazatel

`varcCodeEndPt+1` ukazuje na první nepoužitý bajt nad společným úložištěm zdroje a symbolů.

Používá se pro:

- kontrolu, zda se nová data vejdou pod U-TOP;
- výpočet délek přesunů při otevírání a zavírání mezer;
- nalezení konce dat tabulky;
- vynulování bajtů uvolněných mazáním;
- zabránění kolizi zabalených oblastí s pamětí uživatele.

Navzdory názvu `CodeEnd` tato hranice patří rezidentnímu úložišti zdroje a symbolů editoru, nikoli pouze emitovanému strojovému kódu. Rekonstruovaný label odráží opakovaně používané pojmy a historické rozložení původního programu.

## Prostým pseudokódem

Vyřešení pořadového čísla:

```text
function resolveSymbol(ordinal):
    ordinal = clearSourceTag(ordinal)

    vectorAddress = symbolTableBase + 2 * ordinal
    vector = readWord(vectorAddress)

    flags = highByte(vector) & $C0
    offset = vector & $3FFF

    count = readWord(symbolTableBase)
    nameAnchor = symbolTableBase + 2 + 2*count + 2
    nameAddress = nameAnchor + offset

    return {
        flagsAddress: vectorAddress + 1,
        flags: flags,
        nameAddress: nameAddress,
        valueAddress: nameAddress - 2
    }
```

Hledání jména:

```text
function findSymbolOrdinal(sourceText):
    temporaryName = normalizeUppercase(sourceText, maximumLength=8)
    markLastCharacterWithBit7(temporaryName)

    for ordinal from symbolCount down to 1:
        symbol = resolveSymbol(ordinal)
        if bytesEqual(temporaryName, symbol.name):
            return ordinal

    return notFound
```

Zobrazení tabulky:

```text
for each fyzický záznam symbolu v abecedním pořadí:
    vector = findVectorThatPointsTo(record.name)

    print '*' if vector je LOCKED else ' '
    print jméno symbolu

    if vector je DEFINED or LOCKED:
        print record.value
    else:
        print '.....'
```

## Co se změnilo v paměti

Pouhé hledání nebo vyřešení symbolu trvalé bajty nemění.

Vytváření odkazů ve zdroji již mohlo založit nedefinované symboly, takže v okamžiku popsaném touto kapitolou tabulka obsahuje:

- dvoubajtový počet symbolů;
- jeden dvoubajtový vektor pro každé pořadové číslo;
- jeden abecedně seřazený záznam hodnoty a jména pro každý symbol;
- nulové placeholdery hodnot pro dosud nedefinovaná jména;
- stav DEFINED a LOCKED v high bajtech vektorů;
- žádné přímé ukazatele ze zdroje na jména.

Při zobrazování tabulky se mění dočasné screen buffery a samomodifikované pozice výstupu, ale samotná tabulka zůstává nedotčena.

## Důležité labely, na které jsme narazili

- `varcSymbolTablePt`
- `varcCodeEndPt`
- `parseSymbolNameAndFindOrdinal`
- `resolveSymbolReferenceToName`
- `varcSymbolEntryAreaBase`
- `numberStringBuffer`
- `displaySymbolTableColumn`
- `varcEndOfSymbolTable`
- `invokeTable`
- `varcSymbolVectorFlagInstruction`

## Zpět k celkovému obrazu

Pipeline expressionu z kapitoly 22 nyní můžeme rozšířit:

```text
zápis symbolu ve zdroji
    ↓
normalizované jméno velkými písmeny
    ↓
stabilní jedničkově číslované pořadové číslo
    ↓
tagované pořadové číslo uložené v komprimovaném záznamu
    ↓
lookup vektoru během sestavení
    ↓
test DEFINED/LOCKED
    ↓
hodnota načtená z abecedního záznamu
```

Struktura tabulky vysvětluje, jak přežívají dopředné odkazy a proč se zdroj může volně přesouvat. Ještě však nevysvětluje, jak lze vložit nový abecedně seřazený záznam bez změny starých pořadových čísel ani jak lze odstranit nepoužívané symboly, když odstranění jednoho vektoru *skutečně* posune všechna pozdější čísla.

To jsou obtížnější údržbové operace. Kapitola 24 sleduje symbol od vytvoření přes zamčení, označení a smazání až po úplnou opravu odkazů ve zdroji.
