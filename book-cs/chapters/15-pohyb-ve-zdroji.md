# Kapitola 15: Pohyb ve zdroji

Textový editor na moderním počítači často udržuje pole řádků, strom úseků nebo velký znakový buffer doplněný indexy. PROMETHEUS nemá prostor na samostatnou tabulku, která by obsahovala adresu každého řádku zdroje.

Místo ní tvoří navigační strukturu samotné komprimované záznamy.

Každý záznam vysvětluje, jak dojít k následujícímu. Každý proměnlivě dlouhý záznam zanechává na svém konci malou stopu pro cestu zpět. Jediný ukazatel označuje aktivní řádek. Viditelné okno editoru se pokaždé znovu vytvoří chůzí od tohoto ukazatele oběma směry.

Tato kapitola propojí formát záznamu z kapitoly 12 s pohledem na editor z kapitoly 9.

## Zdroj je posloupnost, nikoli tabulka ukazatelů na řádky

V paměti jsou záznamy uloženy bezprostředně jeden za druhým:

```text
záznam 0 | záznam 1 | záznam 2 | záznam 3 | ... | tabulka symbolů
```

Neexistuje žádná trvalá struktura typu:

```text
linePointers[0]
linePointers[1]
linePointers[2]
...
```

Takový index by stál dva bajty na každý řádek zdroje a po každém vložení nebo smazání by se musel opravovat.

PROMETHEUS místo toho klade místní otázky:

```text
Když znám začátek tohoto záznamu, kde tento záznam končí?
Když znám začátek tohoto záznamu, kde začínal předchozí záznam?
```

Na tyto otázky odpovídají `getNextSourceRecord` a `getPreviousSourceRecord`.

## Pohyb vpřed čte aktuální záznam

Aby PROMETHEUS našel následující záznam, prozkoumá informační bajt aktuálního záznamu.

Pevný případ je okamžitý:

```text
žádný label řádku
třída operandu/uložení je nula
    → délka záznamu je přesně dva bajty
```

U proměnlivého záznamu scanner prochází bajty payloadu, dokud nenarazí na koncovou značku v rozsahu `$C0`–`$FF`.

Hodnoty `$80`–`$BF` musí považovat za první polovinu dvoubajtového odkazu na symbol a přeskočit následující spodní bajt. Jinak by tento spodní bajt mohl náhodou mít hodnotu `$C0` nebo vyšší a být mylně pokládán za konec záznamu.

Algoritmus vypadá takto:

```text
HL = začátek záznamu
info = record[1]
HL += 2

if label řádku je přítomen:
    HL += 2

if není label and class == 0:
    return HL

repeat:
    byte = *HL++

    if byte >= $C0:
        return HL

    if byte >= $80:
        HL++       přeskoč spodní bajt pořadového čísla
```

Po návratu ukazuje `HL` na první bajt následujícího záznamu.

## Pohyb zpět čte bajt před aktuálním záznamem

Při cestě zpět PROMETHEUS vůbec nezkoumá aktuální záznam. Podívá se na bajt bezprostředně před ním.

Je-li tento bajt menší než `$C0`, musí být předchozí záznam pevnou dvoubajtovou formou. Daný bajt je jeho informační bajt.

Je-li hodnota `$C0` nebo vyšší, jde o koncovou značku předchozího proměnlivého záznamu. Jejích spodních šest bitů udává počet proměnlivých bajtů mezi hlavičkou a značkou.

Skutečná rutina je natolik krátká, že stojí za zopakování:

```asm
getPreviousSourceRecord:
    dec hl
    ld a,(hl)
    cp 0c0h
    jr c,.previousRecordIsFixedLength
    and 03fh
    ld e,a
    ld d,000h
    sbc hl,de
    dec hl
.previousRecordIsFixedLength:
    dec hl
    ret
```

V pseudokódu:

```text
HL--
lastByte = *HL

if lastByte < $C0:
    HL--
    return HL

payloadLength = lastByte & $3F
HL -= payloadLength
HL--       překroč informační bajt
HL--       překroč bajt opcodu
return HL
```

Koncová značka je tedy drobným relativním odkazem zpět.

## Proč je cesta zpět konstantně rychlá

Proměnlivý záznam může obsahovat několik bajtů výrazu, ale pohyb zpět je nemusí procházet. Uloženou délku odečte jedinou šestnáctibitovou operací.

Při pohybu vpřed lze krátký payload projít, protože editační řádek je krátký. Bez koncové délky by však byl pohyb zpět mnohem nepříjemnější: editor by musel začít na počátku zdroje a jít vpřed, dokud by znovu neobjevil předchozí záznam.

PROMETHEUS věnuje jeden bajt značky pouze záznamům, které potřebují proměnlivý materiál. Za tento bajt získává účinný pohyb kurzoru vzhůru výpisem.

## Aktivní řádek je jediný samomodifikovaný ukazatel

Aktuální poloha editoru je uložena v operandu této instrukce:

```asm
varcSourceBufferActiveLine:
    ld hl,sourceBufferAccessLine
```

Za běhu se slovo za `LD HL,` přepisuje adresou začátku aktivního komprimovaného záznamu.

Aktivní řádek není číslo řádku. Je to přímý ukazatel do právě používané zabalené oblasti zdroje.

Běžný pohyb je díky tomu levný:

```text
načti aktivní ukazatel
najdi sousední záznam
ověř hranici
ulož nový aktivní ukazatel
```

Znamená to však také, že vložení nebo smazání zdroje musí tento ukazatel opravit pokaždé, když se paměť kolem něj přesune. Kapitola 16 prozkoumá tuto opravnou mechaniku podrobně.

## Počáteční zdroj obsahuje navigační výplň

Počáteční obraz zdroje obsahuje dvacet pevných prázdných záznamů `$00,$30`.

Jsou uspořádány tak, aby `sourceBufferAccessLine` označoval čtrnáctý záznam:

```text
13 prázdných záznamů před přístupovým řádkem
1 aktivní prázdný záznam
6 prázdných záznamů za ním
```

To odpovídá dvaceti viditelným řádkům okna zdroje.

Výplň není jen kosmetická. Dovoluje editoru použít na začátku prázdného programu stejné průchody záznamy jako později:

- projít třináct záznamů zpět a najít horní viditelný řádek;
- vykreslit aktivní řádek;
- vykreslit šest záznamů pod ním.

Není třeba zvláštní případ „zdroj zatím neexistuje“. Prázdný zdroj je už platným řetězcem záznamů.

## Aktivní řádek má přísnější dolní hranici než vykreslování

`compareHLWithSourceBufferStart` porovnává kandidáta na aktivní ukazatel s `sourceBufferAccessLine`, nikoli s fyzickým labelem `sourceBufferStart`:

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

Tento rozdíl je nenápadný, ale důležitý.

Třináct záznamů před `sourceBufferAccessLine` tvoří trvalou výplň zobrazení. Aktivní řádek editoru se do nich nesmí přesunout. Existují proto, aby horní část výpisu zůstala zaplněná, když je aktivní první skutečný řádek zdroje.

Existují tedy dva významy slova „začátek“:

```text
fyzický sourceBufferStart
    začátek horní výplně zobrazení

sourceBufferAccessLine
    nejdřívější povolená poloha aktivního řádku
```

Rekonstruovaný název labelu `compareHLWithSourceBufferStart` je poněkud široký; skutečná politika kódu zní „porovnej s nejdřívějším aktivním záznamem zdroje“.

## Přesun na předchozí aktivní řádek

`moveActiveLineToPreviousSourceRecord` provádí:

```asm
moveActiveLineToPreviousSourceRecord:
    call getRecordBeforeActiveLine
    call compareHLWithSourceBufferStart
    ccf
    jr .commitActiveLineMoveIfValid
```

Pomocná rutina nejprve spočítá předchozí záznam. Porovnání potom zkoumá, zda kandidát neleží před povolenou hranicí přístupového řádku.

Je-li neplatný, editor se překreslí, aniž by uložený ukazatel změnil.

Je-li platný, společná větev zápisu uloží kandidáta do `varcSourceBufferActiveLine`.

Uživatel vidí kurzor, který se jednoduše odmítne posunout nad začátek. Program přitom předchozí výplňový záznam skutečně vypočítal; pouze odmítl učinit jej aktivním.

## Horní hranice zachovává šest záznamů pod aktivním řádkem

Pohyb dolů používá `comparePositionWithCodeEnd`.

Jeho název je historický a aritmetika zpočátku působí záhadně:

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

Proč přičíst dvanáct?

Dvanáct bajtů je šest pevných prázdných záznamů:

```text
6 × 2 bajty = 12 bajtů
```

Kandidát na aktivní záznam je platný pouze tehdy, když před začátkem tabulky symbolů zbývá místo ještě pro šest následujících prázdných záznamů.

Logický test je přibližně:

```text
candidate + sizeOfSixEmptyRecords < symbolTableStart
```

Tím se udržuje dolní výplň zobrazení, kterou okno zdroje potřebuje.

Oblast zdroje proto vždy obsahuje malý konec tvořený platnými záznamy za posledním uživatelským řádkem. Aktivní řádek nesmí sestoupit za polohu, která těchto šest záznamů ponechává k dispozici.

## Potvrzení pohybu opatrně zachází s návratovou adresou

Oba směry navigace sdílejí `.commitActiveLineMoveIfValid`:

```asm
.commitActiveLineMoveIfValid:
    pop de
    jr nc,prometheusWarmStartWithCurrentBuffers
    push de
    ld (varcSourceBufferActiveLine+1),hl
    ret
```

Rutina odstraní ze zásobníku návratovou adresu volajícího ještě před případným skokem do warm startu. Je-li pohyb neplatný, může editor překreslit přímo, aniž by na zásobníku zůstala nepotřebná návratová adresa.

U platného pohybu ji vrátí na zásobník, zapíše nový ukazatel a normálně se vrátí.

Jde o drobnou techniku Z80, které stojí za to si všimnout:

> Zásobník se upraví tak, aby jedna větev působila jako návrat a druhá jako koncový skok, přičemž obě zanechají `SP` ve správném stavu.

Viditelným výsledkem je obyčejný pohyb kurzoru omezený hranicemi. Implementace je pečlivě vytvarovaným uzlem toku řízení.

## Nalezení horního viditelného záznamu

Okno zdroje není uloženo jako dvacet ukazatelů na řádky. Každé překreslení je odvodí z aktivního záznamu.

`renderVisibleSourceRecords` načte aktivní ukazatel a třináctkrát jde zpět:

```asm
varcSourceBufferActiveLine:
    ld hl,sourceBufferAccessLine
    ld b,LINES_BEFORE_ACCESS_LINE
.findTopVisibleSourceRecordLoop:
    call getPreviousSourceRecord
    djnz .findTopVisibleSourceRecordLoop
```

Protože před povolenou aktivní hranicí vždy existuje třináct výplňových záznamů, je tento průchod platný i na samém začátku zdroje.

Adresa horního záznamu se po překreslení neuchovává. Je dost levné ji znovu odvodit.

## Vykreslení dvaceti záznamů

Po nalezení horního záznamu rutina opakovaně:

1. vyčistí jeden obrazovkový řádek;
2. rozbalí a vykreslí záznam;
3. přejde na následující záznam;
4. přejde o jeden znakový řádek Spectra níže;
5. skončí po dvacátém řádku.

V pseudokódu:

```text
top = active
repeat 13 times:
    top = previous(top)

screenRow = první řádek okna zdroje
record = top

repeat 20 times:
    clear(screenRow)
    render(record, screenRow)
    record = next(record)
    screenRow++
```

Komentář v současném zdroji na jednom místě stále mluví o „šestnácti řádcích zdroje“, skutečná smyčka a geometrie zobrazení však vytvářejí dvacet. Kniha se drží implementovaného chování.

## Proč je užitečné překreslovat ze záznamů

Úplné překreslení může působit draze, přináší však silnou konzistenci:

- žádná samostatná cache obrazovkových řádků nemůže zastarat;
- značky vybraného bloku se znovu vypočítají;
- názvy symbolů se vyřeší z aktuální tabulky symbolů;
- nastavení velikosti písmen zdroje se použije jednotně;
- každý viditelný řádek odráží komprimovaný zdroj, který právě leží v paměti.

Okno zdroje je projekcí, nikoli druhým editovatelným modelem.

## Držená šipka používá rychlejší obrazovou cestu

Při obyčejném pohybu může warm start překreslit celé okno zdroje. Kdyby se při držené šipce znovu a znovu vytvářelo všech dvacet řádků, působilo by rolování pomalu.

PROMETHEUS proto pro plynulé rolování používá kopírování bitmapových řádků:

- zkopíruje devatenáct existujících textových řádků o jednu pozici;
- vykreslí pouze nově odkrytý krajní záznam;
- přímo otestuje klávesnicovou matici;
- opakuje, dokud zůstává šipka stisknutá.

`copyScreenTextRowAtYToDE` a `copyEightBitmapRows` přesouvají osm bitmapových vrstev, které tvoří jeden znakový řádek Spectra.

`writeLineOfCodeAndTestKeyboard` vykreslí nový krajní řádek a ihned vzorkuje klávesnicový řádek.

Jde o optimalizaci na úrovni pohledu. Aktivní ukazatel zdroje se stále posouvá záznam po záznamu týmiž navigačními rutinami.

## Vybraný blok tvoří dva vnější ukazatele na záznamy

Výběr bloku není uložen v hlavičkách záznamů. Jeho konce si pamatují dva samomodifikované ukazatele:

```asm
varcSelectedBlockStart:
    ld hl,sourceBufferAccessLine
varcSelectedBlockEnd:
    ld de,sourceBufferAccessLine
```

`getSelectedBlock` normalizuje jejich pořadí. Pokud uživatel nastavil dolní a horní hranici obráceně, rutina je před použitím prohodí.

Záznam leží uvnitř vybraného bloku, jestliže se jeho počáteční adresa nachází mezi normalizovanými konci včetně obou hranic.

Tento návrh má několik výhod:

- výběr bloku nepřepisuje každý záznam;
- vymazání nebo posun hranic mění pouze dvě slova;
- vykreslování může přidat dočasnou značku bez změny zdroje;
- COPY, DELETE, PRINT i sestavení výběru mohou sdílet stejné konce.

Cena spočívá v tom, že vložení a mazání musí tyto ukazatele opravit, kdykoli se paměť zdroje posune. To je další úkol pro kapitolu 16.

## Navigace a výběr spolu souvisejí, ale nejsou totéž

Aktivní řádek může ležet uvnitř i vně vybraného bloku. Jeho pohyb automaticky netáhne obě hranice výběru.

Speciální klávesa hranice bloku provede výslovnou změnu:

```text
stará horní hranice se stane dolní hranicí
aktuální aktivní záznam se stane novou horní hranicí
```

Uživatel tak může oblast vymezit tím, že navštíví její konce.

Během překreslení porovnává `testSourceRecordOutsideSelectedBlock` každý vykreslovaný záznam s normalizovaným rozsahem. Záznam uvnitř dostane do `lineBuffer` dočasnou zobrazovací značku.

Trvalý záznam nemá žádný bit „vybráno“. Výběr je stav editoru, nikoli význam zdroje.

## Vložení a smazání musí zachovat platnou navigaci

Představme si, že se nový záznam vloží před aktivní řádek. Surové paměťové adresy nad bodem vložení vzrostou. Bez opravy by:

- aktivní ukazatel mohl mířit doprostřed jiného záznamu;
- hranice vybraného bloku by se posunuly jinam;
- ukazatel tabulky symbolů by byl chybný;
- konec kódu a další ukazatele oblastí by mohly zastarat.

Společné primitivy pro vkládání a mazání proto upravují všechny registrované ukazatele, které leží na hranici přesunu nebo nad ní.

Samotné navigační rutiny mohou zůstat jednoduché, protože strukturální změna slibuje zachování jejich invariantů:

```text
active vždy ukazuje na začátek záznamu
hranice výběru vždy ukazují na začátky záznamů
symbolTablePt následuje konec zdroje
šest dolních výplňových záznamů zůstává k dispozici
třináct horních výplňových záznamů zůstává trvalých
```

Kompaktní datová struktura funguje jen proto, že každý zapisující respektuje stejná pravidla jako každý čtenář.

## Oprava po smazání

Smazání aktivního řádku vyžaduje vybrat přeživší záznam, který se stane novým aktivním řádkem. Hlavní cesta editoru obvykle:

1. smaže právě jeden komprimovaný záznam;
2. zjistí, zda se mazalo na první povolené aktivní pozici;
3. pokud ne, přejde na předchozí přeživší záznam;
4. uloží tento ukazatel jako aktivní;
5. překreslí editor.

Uživatel tak zůstane blízko smazaného řádku místo skoku na nesouvisející adresu.

Společná cesta přerušení také opravuje aktivní ukazatel, který dosáhl hranice konce zdroje:

```asm
call comparePositionWithCodeEnd
call z,getPreviousSourceRecord
```

I zotavení po chybě považuje navigační invarianty za součást stavu aplikace.

## Průběh importu znovu používá vykreslování zdroje

Během importu zdroje PROMETHEUS obvykle nepřekresluje po každém vloženém řádku. To by zpomalilo převod z pásky nebo z cizího formátu zdroje.

`pollImportKeyboardAndRefreshIfRequested` kontroluje klávesnici:

- žádná klávesa: okamžitě pokračuj v importu;
- SPACE: přeruš společnou cestou zrušení příkazu;
- jiná klávesa: propadni do `renderVisibleSourceRecords` a ukaž průběh na vyžádání.

Je zde vidět, že renderer okna zdroje slouží i mimo obyčejný pohyb kurzoru. Každá operace, která udržuje platný aktivní ukazatel, si může vyžádat novou projekci řetězce záznamů.

## Úplný pohyb o jeden řádek dolů

Předpokládejme, že aktivní ukazatel označuje záznam `R` a uživatel stiskne šipku dolů.

```text
1. načti adresu R z varcSourceBufferActiveLine
2. getNextSourceRecord projde R a vrátí adresu S
3. přičti k S 12 kvůli požadavku na šest koncových záznamů
4. porovnej s aktuálním začátkem tabulky symbolů
5. if neplatné:
       ponech aktivní ukazatel beze změny
       překresli přes warm start
6. if platné:
       ulož S jako aktivní
       vrať se do cesty rolování/editoru
7. okno zdroje se posune nebo překreslí kolem S
```

Nezvyšuje se žádné číslo řádku. Nevybírá se prvek pole. Pohyb je čistě strukturální.

## Úplné překreslení na začátku prázdného zdroje

Na počátku platí:

```text
active = sourceBufferAccessLine
```

Renderer třináctkrát zavolá `getPreviousSourceRecord` a dojde k `sourceBufferStart`.

Potom vykreslí:

```text
záznamy 0–12     horní výplň
záznam 13        aktivní přístupový řádek
záznamy 14–19    dolní výplň
```

Všech dvacet záznamů jsou platné prázdné řádky `$00,$30`. Editor může používat běžné algoritmy ještě předtím, než uživatel zadá jedinou instrukci.

Jde o elegantní návrh hranic:

> Místo abychom každou rutinu učili zvláštním případům „žádný předchozí řádek“ a „žádný další řádek“, umístíme kolem použitelného zdroje skutečné prázdné záznamy.

## Úplné překreslení vybraného bloku

Předpokládejme, že hranice ukazují na záznamy `B` a `D`, zatímco aktivní řádek je `C`.

Renderer pro každý viditelný záznam:

```text
normalizuj konce na low..high
porovnej začátek aktuálního záznamu s low
porovnej začátek aktuálního záznamu s high

if uvnitř:
    vlož do lineBuffer dočasný znak výběru

vytiskni rekonstruovaný řádek
```

Tytéž komprimované záznamy se tak mohou jevit jako vybrané nebo nevybrané, aniž by se změnil jediný bajt zdroje.

## Zpět k celému editoru

Formát záznamu zdroje plní současně tři úkoly:

1. kompaktní uložení rozebraného assemblerového zdroje;
2. vstup pro assembler a rutiny rozbalování textu;
3. místní navigační strukturu editoru.

Koncová značka proměnlivého záznamu není pouze terminátorem. Umožňuje procházet výpis oběma směry. Počáteční prázdné záznamy nejsou jen prázdným zdrojem. Jsou hraniční výplní, která odstraňuje zvláštní případy. Aktivní řádek není pouze kurzorem uživatelského rozhraní. Je živým ukazatelem, jehož platnost musí zachovat každá změna paměti.

Zdánlivá jednoduchost editoru — stiskni nahoru, stiskni dolů, uvidíš dvacet řádků — stojí na pečlivé shodě formátu, rozložení paměti a vykreslování.

## Co se změnilo v paměti nebo na obrazovce?

Po platném pohybu aktivního řádku:

- `varcSourceBufferActiveLine` obsahuje začátek sousedního záznamu;
- ukazatele vybraného bloku se nezměnily;
- bajty komprimovaného zdroje se nezměnily.

Po neplatném pohybu přes hranici:

- aktivní ukazatel zůstává beze změny;
- zásobník byl opraven pro přímý skok do warm startu;
- editor se překreslí na stejné pozici.

Během úplného překreslení:

- `lineBuffer` se opakovaně rekonstruuje pro dvacet záznamů;
- bitmapové řádky se čistí a znovu kreslí;
- do `lineBuffer` se mohou vložit dočasné značky vybraného bloku;
- trvalý zdroj zůstává nedotčen.

Během rychlého rolování drženou klávesou:

- existující bitmapové řádky se kopírují nahoru nebo dolů;
- rozbalí a vykreslí se pouze jeden nově odkrytý záznam zdroje;
- klávesnicová matice se přímo vzorkuje a rozhoduje, zda pokračovat.

## Důležité myšlenky pro další kapitoly

- záznamy zdroje leží těsně za sebou bez indexu adres řádků;
- pohyb vpřed čte hlavičku a proměnlivý stream aktuálního záznamu;
- pohyb zpět používá koncovou značku předchozího záznamu;
- cesta proměnlivým záznamem zpět trvá konstantní dobu;
- aktivní řádek je samomodifikovaný přímý ukazatel na záznam;
- třináct trvalých záznamů před `sourceBufferAccessLine` poskytuje horní výplň zobrazení;
- šest záznamů za nejpozdější aktivní pozicí poskytuje dolní výplň zobrazení;
- podmínka `candidate+12 < symbolTableStart` tuto dolní výplň vynucuje;
- každé překreslení odvodí horní řádek chůzí třináct záznamů zpět;
- okno zdroje obsahuje dvacet záznamů;
- kopírování bitmap urychluje rolování drženou šipkou, aniž by měnilo význam navigace ve zdroji;
- výběr bloku představují dva vnější ukazatele na záznamy;
- vložení, smazání i import musí zachovat všechny navigační invarianty.

## Vysvětlené orientační body ve zdroji

- `getRecordBeforeActiveLine`
- `getPreviousSourceRecord`
- `getRecordAfterActiveLine`
- `getNextSourceRecord`
- `varcSourceBufferActiveLine`
- `sourceBufferStart`
- `sourceBufferPreviousLine`
- `sourceBufferAccessLine`
- `LINES_BEFORE_ACCESS_LINE`
- `moveActiveLineToPreviousSourceRecord`
- `moveActiveLineToNextSourceRecord`
- `.commitActiveLineMoveIfValid`
- `compareHLWithSourceBufferStart`
- `comparePositionWithCodeEnd`
- `renderVisibleSourceRecords`
- `.findTopVisibleSourceRecordLoop`
- `.renderVisibleSourceRecordLoop`
- `copyScreenTextRowAtYToDE`
- `copyEightBitmapRows`
- `writeLineOfCodeAndTestKeyboard`
- `varcSelectedBlockStart`
- `varcSelectedBlockEnd`
- `getSelectedBlock`
- `testSourceRecordOutsideSelectedBlock` na úrovni navigace
- `pollImportKeyboardAndRefreshIfRequested`
- `abortCommandAndReturnToEditor` na úrovni opravy aktivního ukazatele
