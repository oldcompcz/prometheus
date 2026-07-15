# Kapitola 3: Mapa stroje

PROMETHEUS přesouvá pamětí mnoho druhů informací: záznamy zdroje, symboly, vytvořený kód, obrazy obrazovky, zásobníky, instalační tabulky a uložený stav procesoru. Než začneme kteroukoli z těchto struktur zkoumat podrobně, potřebujeme mapu.

Mapa je neobvyklá tím, že neexistuje jediné trvalé uspořádání. PROMETHEUS se vyskytuje nejméně ve třech důležitých podobách:

1. jako CODE blok právě načtený z kazety;
2. jako dočasný instalátor pracující na adrese `$5000`;
3. jako rezidentní program na adrese zvolené uživatelem.

Uvnitř rezidentního programu jsou některé hranice pevné vzhledem k jeho základně, jiné se však posouvají s růstem zdroje a tabulky symbolů.

## Celkový 64KB adresní prostor Spectra

Z80 dokáže adresovat 65 536 bajtových pozic od `$0000` do `$FFFF`.

Zjednodušená mapa 48K Spectra vypadá takto:

```text
$0000 ┌──────────────────────────────┐
      │ 16K ROM Spectra              │
$3FFF └──────────────────────────────┘
$4000 ┌──────────────────────────────┐
      │ bitmapa obrazovky            │
$57FF ├──────────────────────────────┤
$5800 │ atributy obrazovky           │
$5AFF ├──────────────────────────────┤
      │ systémové proměnné, kanály,  │
      │ oblast BASICu a obecná RAM   │
$FFFF └──────────────────────────────┘
```

Obrazovka není samostatné grafické zařízení s vlastní soukromou pamětí. Bajty od `$4000` jsou obyčejná RAM viditelná procesoru, kterou videoobvody průběžně interpretují.

PROMETHEUS používá obrazovou RAM dvěma způsoby:

- běžně jako viditelné rozhraní editoru nebo monitoru;
- během instalace částečně jako dočasný pracovní prostor a zásobník.

Toto znovupoužití je bezpečné pouze tehdy, když instalátor plně ovládá stroj a je připraven obrazovku později překreslit.

## Historická instalační adresa

Historická výchozí instalační adresa je:

```asm
INSTALLATION_ADDRESS: equ 0x5dc0
```

Úplný rezidentní obraz má přesně 16 000 bajtů, tedy `$3E80` bajtů. Jeho vnitřní uspořádání je definováno relativně k nule:

```asm
    org 0

relocatablePayloadStart:
ENTRY_POINT_WITH_MONITOR:
    jp startPrometheus
```

Sestavení obrazu s počátkem v nule znamená, že každý interní label je nejprve vyjádřen jako posun od začátku rezidentního obrazu. Během instalace relokační systém přičte zvolenou rezidentní základnu ke každému internímu absolutnímu slovu, které je třeba opravit.

Pro libovolnou základnu úplné instalace `B` mají hlavní části toto uspořádání:

```text
B+$0000 ┌─────────────────────────────────┐
        │ prefix monitoru                 │ 5 000 bajtů
B+$1387 └─────────────────────────────────┘
B+$1388 ┌─────────────────────────────────┐
        │ suffix assembleru/editoru       │
        │ tabulky a počáteční pracovní    │
        │ oblasti                         │ 11 000 bajtů
B+$3E7F └─────────────────────────────────┘
```

Exkluzivní konec je `B+$3E80`.

Při historické základně `$5DC0` dostaneme:

```text
$5DC0 ┌─────────────────────────────────┐
      │ prefix monitoru                 │
$7147 └─────────────────────────────────┘
$7148 ┌─────────────────────────────────┐
      │ assembler/editor, tabulky,      │
      │ počáteční zdroj a konec symbolů │
$9C3F └─────────────────────────────────┘
```

Hodnota `$1388` není náhodné magické číslo. Je to přesně 5 000 v šestnáctkové soustavě a zároveň:

```text
ENTRY_POINT_WITHOUT_MONITOR - ENTRY_POINT_WITH_MONITOR
```

Zdroj tuto vazbu vynucuje symbolicky.

## Úplná a pouze assemblerová rezidentní instalace

Když uživatel zvolí celý systém, instalátor zkopíruje všech 16 000 bajtů rezidentního obrazu.

Začíná instrukcí:

```asm
    ld bc,relocatablePayloadEnd-ENTRY_POINT_WITH_MONITOR
```

Při vynechání monitoru posune zdrojový ukazatel na `ENTRY_POINT_WITHOUT_MONITOR` a změní délku kopírování:

```asm
    ld bc,ENTRY_POINT_WITHOUT_MONITOR-ENTRY_POINT_WITH_MONITOR
    add hl,bc
    ld bc,relocatablePayloadEnd-ENTRY_POINT_WITHOUT_MONITOR
```

Zkopírovaný suffix má tedy 11 000 bajtů.

Představme si, že uživatel zvolí cílovou adresu `$8000`.

Úplná instalace umístí vstup monitoru na `$8000`, hranici části bez monitoru na `$9388` a exkluzivní konec obrazu na `$BE80`.

Instalace pouze assembleru umístí samotný `ENTRY_POINT_WITHOUT_MONITOR` na `$8000`. Zkopírovaný suffix pak zabírá `$8000` až `$AAF7`.

Tento rozdíl je důležitý. Kód assembleru a editoru byl sestaven tak, jako by původně začínal na posunu `$1388`, ale v podobě bez monitoru leží fyzicky hned na začátku zvoleného cíle. Instalátor tento rozdíl vyrovná během relokace a aplikuje dvě výslovné opravy určené pouze pro assemblerovou instalaci.

Zdroj tak může udržovat jediné společné tělo assembleru a editoru, aniž by potřeboval druhou samostatně linkovanou kopii.

## Program načtený z kazety ještě není rezidentním programem

Distribuovaný CODE blok obsahuje více než jen 16 000 bajtů rezidentního obrazu. Před ním se nacházejí:

- bootstrap nezávislý na adrese načtení;
- instalátor logicky sestavený pro `$5000`;
- generovaná data konfiguračních oprav;
- generované relokační proudy;
- obrazová data instalátoru.

Fyzické pořadí v souboru a logické adresy za běhu nejsou totéž.

Užitečný pojmový obrázek je:

```text
CODE blok načtený někam do RAM
┌────────────────────────────────────┐
│ bootstrap bezpečný vůči relokaci   │
├────────────────────────────────────┤
│ bajty instalátoru určeného pro     │
│ adresu $5000                       │
├────────────────────────────────────┤
│ konfigurační a relokační proudy    │
├────────────────────────────────────┤
│ grafika a data instalátoru         │
├────────────────────────────────────┤
│ rezidentní obraz sestavený od nuly │
└────────────────────────────────────┘
```

Bootstrap nejprve zjistí, kam byl CODE blok skutečně načten. Potom zkopíruje malý instalátor na `$5000` a skočí na něj. Instalátor nyní může bezpečně používat vlastní absolutní labely, protože opravdu běží na adrese, pro kterou byl sestaven.

Teprve po volbě uživatelských možností zkopíruje a relokuje rezidentní obraz.

Tuto posloupnost podrobně prozkoumáme ke konci knihy. Zatím je důležité držet tři podoby odděleně:

```text
načtený obraz ≠ dočasný instalátor ≠ konečný rezidentní obraz
```

## Spodní část rezidentního obrazu je většinou pevná

Uvnitř rezidentního obrazu jsou posuny rutin a tabulek určeny při sestavení. Pro zvolenou základnu `B` platí:

- `ENTRY_POINT_WITH_MONITOR` leží na `B+$0000`;
- `startMonitor` je v historickém uspořádání na `B+$01B4`;
- `ENTRY_POINT_WITHOUT_MONITOR` leží na `B+$1388`;
- `startPrometheus` je na `B+$1F09`;
- `processKey` je na `B+$2879`;
- `relocatablePayloadEnd` je na `B+$3E80`.

Tyto posuny pomáhají při ověřování, kniha však bude dávat přednost labelům před číselnými adresami. Budoucí záměrná změna může rutinu posunout, zatímco label nadále vyjadřuje její význam.

## Horní konec začíná kódem, tabulkami a dvaceti prázdnými řádky

Blízko konce rezidentního obrazu leží tabulka instrukcí a počáteční editovatelné úložiště.

Zdrojový buffer začíná dvaceti prázdnými záznamy:

```asm
sourceBufferStart:
    defb 0x00, 0x30
    defb 0x00, 0x30
    ; ...
sourceBufferAccessLine:
    defb 0x00, 0x30
    ; ...
```

Hned za počátečním zdrojem leží prázdná tabulka symbolů:

```asm
symbolTableDefaultPt:
    defw 0
codeEndDefaultPt:
    defs 6
```

První slovo říká, že tabulka symbolů zpočátku obsahuje nula položek. Následující konec poskytuje počáteční chráněný stav a výchozí oblast konce kódu.

Právě zde přestává být mapa paměti úplně statická.

## Zdroj a symboly sdílejí pohyblivou hranici

Komprimovaný zdroj roste v paměti směrem vzhůru. Tabulka symbolů leží bezprostředně nad ním. Při vložení záznamu zdroje se může celá oblast symbolů posunout. Po smazání zdroje se vzniklá mezera může znovu uzavřít.

Pojmově:

```text
nižší adresy
┌────────────────────────────┐
│ pevné rezidentní rutiny    │
│ pevné tabulky              │
├────────────────────────────┤
│ komprimované záznamy       │
│ zdroje                     │  rostou a zmenšují se
├────────────────────────────┤
│ tabulka symbolů            │  posouvá se se změnami zdroje
├────────────────────────────┤
│ značka chráněného konce    │
└────────────────────────────┘
vyšší adresy
```

Aktuální pozice si pamatuje několik samomodifikovaných operandů:

- ukazatel na současnou tabulku symbolů;
- současný chráněný konec kódu;
- ukazatele na aktivní a viditelné záznamy zdroje;
- současný ukazatel výstupu assembleru.

Toto uspořádání šetří paměť, protože není třeba trvale rezervovat místo pro maximálně velký zdroj nebo maximální tabulku symbolů. Vytváří však přísné pravidlo: kdykoli se pod některým ukazatelem vloží nebo odstraní bajty, musí být každý dotčený ukazatel opraven.

Pozdější kapitoly o editoru ukážou rutiny, které tyto opravy provádějí.

## Kam se ukládá sestavený kód?

Pokud direktiva `ORG` nebo `PUT` neurčí něco jiného, inicializuje PROMETHEUS logické počítadlo adres i fyzický ukazatel výstupu na první bajt za současnou dynamickou oblastí zdroje a symbolů:

```asm
    ld hl,(varcCodeEndPt+1)
    inc hl
    ld (varcAddressCounter+1),hl
    ld (varcAssemblyOutputPointer+1),hl
```

Výchozí vytvořený program tedy začíná bezprostředně za současnými pracovními daty PROMETHEA.

Je třeba rozlišovat dvě související, ale odlišné věci:

- **logickou adresu** používanou pro labely a relativní výpočty;
- **fyzický ukazatel výstupu**, který určuje, kam se bajty skutečně zapisují.

Obvykle se posouvají společně. `ORG` mění oba. `PUT` může změnit fyzický cíl a ponechat odlišný logický model adres.

Náš průběžný příklad používá `ORG 32768`, takže je jeho výstup záměrně umístěn na `$8000`, nikoli hned za tabulku zdroje a symbolů.

## Obrazovka je zobrazovačem i adresovatelnou pamětí

PROMETHEUS zapisuje přímo do bitmapové a atributové oblasti Spectra. Zná neobvyklé uspořádání obrazových řádků a používá pomocné rutiny pro pohyb o jednu znakovou buňku nebo textový řádek.

Několik pevných adres je pojmenováno poblíž začátku zdroje:

```asm
VRAM_ADDRESS:                  equ 0x4000
ATTRIBUTES_ADDRESS:            equ 0x5800
ACCESS_LINE_ATTRIBUTE_ADDRESS: equ 0x59e0
BOTTOM_LINE_VRAM_ADDRESS:      equ 0x50e0
```

Tato jména proměňují viditelné oblasti v cíle v paměti:

- přístupový řádek má vlastní řádek atributů, který lze zvýraznit;
- spodní řádek obrazovky může obsahovat stav nebo vstup monitoru;
- deskriptory čelního panelu monitoru ukazují na bitmapové buňky;
- instalátor kreslí přímo do obrazové paměti.

Kapitola o zobrazování vysvětlí, proč posun o jeden viditelný textový řádek není totéž jako přičtení 32 k bitmapové adrese Spectra.

## Zásobníky se objevují na více místech

PROMETHEUS nemůže předpokládat, že předchozí zásobník Spectra zůstává vhodný.

Během bootstrapu a instalace se část obrazové paměti používá jako dočasný zásobník. Po zkopírování rezidentního obrazu vytvoří instalátor nový zásobník uvnitř nainstalované oblasti na známém posunu od cíle, vloží na něj rezidentní vstup a dosáhne jej instrukcí `RET`.

Editor a monitor později při teplém vstupu obnovují vlastní interní vrchol zásobníku. Tím brání hromadění opuštěných rámců příkazů v případech, kdy se operace monitoru nebo chyba editoru vrací nestandardním pokračováním.

Jde o další příklad toho, jak program zachází s tokem řízení jako se zdrojem, který lze obnovit do výchozího stavu, nikoli jen slepě následovat.

## Chráněná paměť je pohyblivý pojem

Monitor může zkoumat téměř celou adresovatelnou paměť, ale nesmí bezstarostně přepisovat rezidentní program, zdroj ani symboly. Horní hranice chráněné oblasti proto není konstantou danou při sestavení. Sleduje dynamický ukazatel konce kódu.

To vysvětluje i dříve zmíněné chování: když disassembler dosáhne vlastní rezidentní oblasti monitoru, PROMETHEUS tyto bajty nedekóduje jako běžné instrukce. Dynamický chráněný rozsah způsobí, že jsou zobrazeny jako jednobajtové záznamy `DEFB`. Bajty zůstávají viditelné, monitor však své vlastní zapisovatelné operandy instrukcí a tabulky nepředstavuje jako důvěryhodný spustitelný kód.

Ochrana tedy vychází ze současné mapy, nikoli jen z pevného historického intervalu adres.

## Spojená mapa historické úplné instalace

Následující diagram je uvnitř suffixu assembleru a editoru záměrně přibližný. Pozdější kapitoly tuto oblast rozdělí na přesné funkční části.

```text
$0000-$3FFF   ROM Spectra
$4000-$5AFF   bitmapa a atributy obrazovky
$5B00-$5DBF   pracovní prostor Spectra / kontext spodní RAM

$5DC0         ENTRY_POINT_WITH_MONITOR
              čelní panel monitoru a příkazy
              disassembler a nástroje paměti
              mechanismy vykonávání a trasování
$7147         konec 5 000bajtového prefixu monitoru

$7148         ENTRY_POINT_WITHOUT_MONITOR
              dispatch příkazů a editor
              přenos zdroje na kazetu
              dvouprůchodový assembler
              mechanismy výrazů a symbolů
              sdílené vykreslování a klávesnice
              řetězce, tabulky mnemonik, operandů a instrukcí
              počáteční komprimované záznamy zdroje
              počáteční konec symbolů a kódu
$9C3F         poslední bajt historického rezidentního obrazu
$9C40         první bajt za relocatablePayloadEnd

vyšší RAM     dostupná podle růstu zdroje,
              zvoleného U-TOP a umístění vytvářeného programu
```

Tato mapa neslibuje, že každý pozdější uživatelský program začne na `$9C40`. O tom, co je dovoleno, rozhodují `ORG`, `PUT`, růst zdroje, symboly i nastavená horní hranice. Jde o výchozí uspořádání po historické instalaci.

## Zpět k celému stroji

Cestu z kapitoly 2 nyní můžeme umístit do paměti:

```text
klávesy a editační buffer      obrazovka + rezidentní pracovní buffery
        ↓
komprimovaný zdroj             dynamický konec rezidentního obrazu
        ↓
tabulka symbolů                bezprostředně nad zdrojem
        ↓
stav prvního/druhého průchodu  samomodifikované operandy v rezidentním kódu
        ↓
vytvořený program na $8000     uživatelem zvolená výstupní paměť
        ↓
disassemblování monitoru       buffery monitoru + obrazovka
```

Jediný adresní prostor obsahuje nástroj, editovaný text, právě vytvářený program i rozhraní, kterým jej uživatel zkoumá. Většina důmyslnosti PROMETHEA vychází z bezpečného uspořádání těchto sousedů.

## Co se změnilo v paměti?

Bezprostředně po historické úplné instalaci, ještě před zadáním zdroje:

- `$5DC0-$9C3F` obsahuje relokovaný rezidentní obraz o velikosti 16 000 bajtů;
- `$5DC0-$7147` je prefix monitoru;
- `$7148-$9C3F` je suffix assembleru a editoru, tabulky a počáteční pracovní oblasti;
- konec zdroje obsahuje dvacet prázdných záznamů;
- počet položek tabulky symbolů je nula;
- stav konce kódu chrání počáteční konec zdroje a symbolů;
- obrazová paměť obsahuje nově vykreslené rozhraní editoru;
- vyšší RAM zůstává dostupná s ohledem na konfiguraci a pozdější růst zdroje či kódu.

Při instalaci pouze assembleru začíná 11 000bajtový suffix přímo na zvolené cílové adrese a prefix monitoru žádnou paměť nezabírá.

## Uvedené orientační labely zdroje

- `INSTALLATION_ADDRESS`
- `LOADER_ADDRESS`
- `relocatablePayloadStart`
- `relocatablePayloadEnd`
- `ENTRY_POINT_WITH_MONITOR`
- `ENTRY_POINT_WITHOUT_MONITOR`
- `installerPrepareAssemblerOnlyImage`
- `installerCopyImage`
- `installerCopyImageBackward`
- `sourceBufferStart`
- `sourceBufferAccessLine`
- `symbolTableDefaultPt`
- `codeEndDefaultPt`
- `varcCodeEndPt`
- `varcAddressCounter`
- `varcAssemblyOutputPointer`
