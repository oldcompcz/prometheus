# Dodatek C: Mapy paměti

PROMETHEUS nemá jedinou trvalou mapu paměti. Bajty mezi kazetou a běžícím
editorem procházejí několika uspořádáními a samotný rezidentní program obsahuje
pohyblivou hranici mezi zdrojem, symboly a generovaným kódem.

Tento dodatek shromažďuje mapy používané v celé knize. Adresy začínající `B+`
jsou offsety od uživatelem zvolené instalační báze `B`. Adresy začínající `L+`
jsou offsety od fyzické adresy, na níž byl načten úplný instalační blok CODE.

Není-li uvedeno jinak, koncové adresy v próze jsou inkluzivní. Diagramy, které
zobrazují **exkluzivní konec**, jej výslovně pojmenovávají.

## C.1 Adresový prostor 48K Spectra

```text
$0000 ┌──────────────────────────────────────────────┐
      │ 16K ROM                                     │
      │ PROMETHEUS volá vybrané pevné vstupní body │
$3FFF └──────────────────────────────────────────────┘
$4000 ┌──────────────────────────────────────────────┐
      │ bitmapa obrazovky, 6144 bajtů               │
      │ také dočasný workspace/stack instalátoru    │
$57FF ├──────────────────────────────────────────────┤
$5800 │ attributes obrazovky, 768 bajtů             │
$5AFF ├──────────────────────────────────────────────┤
$5B00 │ workspace ROM, kanály, BASIC a volná RAM    │
      │                                              │
      │ instalační obraz nebo rezidentní PROMETHEUS │
      │ zdroj, symboly a generovaný uživatelský kód │
      │                                              │
$FFFF └──────────────────────────────────────────────┘
```

Historická nominální adresa načtení a úplné instalace je `$5DC0`, bootstrap však
nepředpokládá, že data CODE skutečně dorazila právě tam.

## C.2 Úplný historický distribuční TAP

Kanonický kazetový obraz obsahuje osm bloků TAP:

```text
blok 0  HEADER BASIC  "PROMETHEUS"  délka 54, autostart 9999
blok 1  DATA   BASIC  54bajtový loader
blok 2  HEADER CODE   "prometheus"  délka 18 356, load 24 000
blok 3  DATA   CODE   18 356bajtový instalační obraz PROMETHEA
blok 4  HEADER CODE   "skatecrazy"  délka 7 291
blok 5  DATA   CODE   7 291bajtový payload
blok 6  HEADER CODE   "gensor    "  délka 300, load 55 000
blok 7  DATA   CODE   300bajtový payload GENSOR
```

Každý logický blok Spectra je ve formátu TAP uložen jako:

```text
2bajtová little-endian délka těla TAP
flag bajt
bajty payloadu
XOR checksum
```

Rekonstrukce PROMETHEA nahrazuje nebo ověřuje blok 3 a ostatních sedm bloků
zachovává přesně.

## C.3 Distribuovaný obraz CODE PROMETHEA

Datový payload PROMETHEA o 18 356 bajtech je **instalační obraz**, nikoli pouze
16 000bajtový rezidentní program.

Na historické fyzické adrese načtení `$5DC0` má hrubé rozložení:

```text
$5DC0 ┌──────────────────────────────────────────────┐
      │ bootstrap odolný vůči relokaci              │
      │ prvních 23 bajtů před kopírovaným instalát. │
$5DD7 ├──────────────────────────────────────────────┤
      │ fyzické bajty instalátoru sestaveného pro   │
      │ logické vykonání na $5000                   │
      │ generovaná patchovací a relokační metadata  │
      │ první část loga/dat instalátoru             │
$65B2 ├──────────────────────────────────────────────┤
$65B3 │ zbývající bitmapová data loga               │
$66F3 ├──────────────────────────────────────────────┤
$66F4 │ relokovatelný rezidentní payload, offset 0  │
      │ ENTRY_POINT_WITH_MONITOR                    │
$7A7B │ poslední bajt 5 000bajtového prefixu monit. │
$7A7C │ ENTRY_POINT_WITHOUT_MONITOR                 │
      │ 11 000bajtový suffix assembleru/editoru    │
$A573 │ poslední bajt úplného instalačního obrazu   │
$A574 │ exkluzivní konec                            │
      └──────────────────────────────────────────────┘
```

Přesné vnitřní hranice instalátoru je nejlépe chápat logicky, nikoli
předpokladem, že jeho zdrojové adresy sestavení odpovídají fyzickým polohám v
tomto spojeném souboru.

Pro libovolnou fyzickou bázi načtení `L` zabírá stejný obraz:

```text
L+$0000 ... L+$47B3     celkem 18 356 bajtů
```

a rezidentní payload začíná na:

```text
L+$1934
```

protože `$66F4-$5DC0 = $1934`.

Bootstrap používá výslovný historický zdrojový offset `$0017`, aby ve fyzickém
obrazu našel kopírované bajty instalátoru. Tato hodnota popisuje spojení obrazu
načtení, nikoli adresu uvnitř relokovatelného rezidentního payloadu.

## C.4 Dočasné použití obrazovkové paměti bootstrapem

Bezprostředně po vstupu:

```text
$4000 ┌──────────────────────────────────────────────┐
      │ vymazáno pomocí LDIR                        │
      │ dolní bitmapa displeje dočasně zničena     │
$401F ├──────────────────────────────────────────────┤
$4020 │ zde začíná dočasný stack instalátoru       │
      │ zde je vložena fyzická báze načtení        │
      │ později vyměněna za fyzický ptr payloadu   │
$4FFF ├──────────────────────────────────────────────┤
$5000 │ pevný cíl pro kopírovaný instalátor        │
      └──────────────────────────────────────────────┘
```

Mazání začíná s HL=`$4000`, DE=`$4001`, BC=`$0FFF` a nulou na `$4000`. Po
dokončení je DE přirozeně `$5000`, takže následující LDIR může instalátor
kopírovat bez nového načtení DE.

Dočasný stack je bezpečný pouze proto, že jsou vypnuta přerušení a instalátor
vlastní celý stroj.

## C.5 Instalátor na logické adrese `$5000`

Bootstrap zkopíruje `$07CD` bajtů na `$5000` a skočí tam.

```text
$5000 ┌──────────────────────────────────────────────┐
      │ kód instalátoru a zapisovatelné operandy   │
      │ rutiny obrazovky/UI, handlery kláves        │
      │ copy/configuration/relocation decoder       │
      │ generovaná metadata uvnitř kopírované části│
$57CC └──────────────────────────────────────────────┘
$57CD   exkluzivní konec kopírovaného fragmentu
```

Na `installerEntryAt5000`:

```text
HL  = fyzický ukazatel bezprostředně za kopírovaným fragmentem
SP  = $4020, dočasný stack v obrazovce
(SP)= fyzická báze celého načteného obrazu CODE
```

Prvních 320 bajtů na fyzické adrese HL dokončuje dva pruhy loga o 20 znacích × 8
řádcích. Po obou voláních kopírování loga ukazuje HL na fyzický začátek
16 000bajtového rezidentního payloadu. `EX (SP),HL` potom vytvoří:

```text
HL   = fyzická báze CODE pro desetinné zobrazení
(SP) = fyzický začátek rezidentního payloadu, zachovaný do ENTER
```

## C.6 Logický rezidentní obraz s originem nula

Rezidentní payload je sestaven s originem nula:

```text
$0000 ┌──────────────────────────────────────────────┐
      │ ENTRY_POINT_WITH_MONITOR                    │
      │ prefix monitoru                             │ 5 000 bajtů
$1387 └──────────────────────────────────────────────┘
$1388 ┌──────────────────────────────────────────────┐
      │ ENTRY_POINT_WITHOUT_MONITOR                 │
      │ suffix assembleru/editoru                   │
      │ statické tabulky a počáteční živý tail     │ 11 000 bajtů
$3E7F └──────────────────────────────────────────────┘
$3E80   relocatablePayloadEnd, exkluzivní/žádný bajt
```

Tento obraz s originem nula je adresovým jazykem používaným při generování
relokací. Interní absolutní slovo zpočátku obsahuje offset payloadu. Instalace k
němu přičte zvolenou bázi nebo opravenou bázi assembler-only varianty.

Klíčové stabilní offsety ve v042 jsou:

```text
$0000  ENTRY_POINT_WITH_MONITOR
$01B4  startMonitor
$1388  ENTRY_POINT_WITHOUT_MONITOR
$1F09  startPrometheus
$2879  processKey
$3E80  relocatablePayloadEnd
```

Labely jsou trvanlivější než tyto číselné offsety, ale offsety jsou užitečné pro
ověřování a čtení mapy.

## C.7 Úplná rezidentní instalace na bázi `B`

Úplný systém kopíruje všech 16 000 bajtů:

```text
B+$0000 ┌────────────────────────────────────────────┐
        │ vstup monitoru a prefix monitoru          │
        │ čelní panel, paměťové nástroje, disassembl│
        │ řízené vykonávání a uložený obraz CPU     │
B+$1387 └────────────────────────────────────────────┘
B+$1388 ┌────────────────────────────────────────────┐
        │ vstup a tělo assembleru/editoru           │
        │ příkazy, parser, zdroj, symboly, kazeta   │
        │ statické slovníky/tabulka instrukcí       │
        │ 20 počátečních záznamů + prázdná tabulka │
B+$3E7F └────────────────────────────────────────────┘
B+$3E80   exkluzivní konec rezidentu
```

Na historické bázi `$5DC0`:

```text
$5DC0 ┌──────────────────────────────────────────────┐
      │ prefix monitoru                             │
$7147 └──────────────────────────────────────────────┘
$7148 ┌──────────────────────────────────────────────┐
      │ suffix assembleru/editoru                   │
$9C3F └──────────────────────────────────────────────┘
$9C40   exkluzivní konec
```

Na příkladové bázi `$8000`:

```text
$8000  vstup monitoru
$9388  vstup assembleru/editoru
$BE7F  poslední rezidentní bajt
$BE80  exkluzivní konec
```

## C.8 Rezidentní instalace pouze assembleru na bázi `B`

Instalátor vynechá prvních 5 000 bajtů a suffix umístí přímo na B:

```text
B+$0000 ┌────────────────────────────────────────────┐
        │ bývalý offset payloadu $1388              │
        │ ENTRY_POINT_WITHOUT_MONITOR               │
        │ suffix assembleru/editoru                 │
        │ tabulky a počáteční živý tail             │ 11 000 bajtů
B+$2AF7 └────────────────────────────────────────────┘
B+$2AF8   exkluzivní konec
```

Pro B=`$8000`:

```text
$8000  vstup assembleru/editoru
$AAF7  poslední rezidentní bajt
$AAF8  exkluzivní konec
```

Linkovaná absolutní slova suffixu stále popisují offsety úplného payloadu s
originem nula. Instalátor je proto relokuje s:

```text
addend = B - $1388
```

takže původní logická adresa `$1388+x` se stane fyzickou `B+x`.

Dva výslovné patche assembler-only varianty opravují chování, jehož nelze
dosáhnout jednotnou relokací slov:

- odkaz výstupu/ochrany, který musí přeskočit vynechaný prefix;
- fallback příkazu MONITOR, který nemůže skočit do monitoru, jenž nebyl
  nainstalován.

## C.9 Překrývající se rozložení kopie

Instalační obraz a cíl se mohou překrývat. Uvažujme fyzický zdrojový rozsah
`S..S+length-1` a cílový `D..D+length-1`.

### Bezpečné dopředné kopírování

```text
D <= S
or
D >= S+length
```

Instalátor může použít `LDIR`:

```text
nízké adresy                                     vysoké adresy
zdroj [----------------]
cíl  [----------------]       nebo       cíl [----------------]
```

### Nutné zpětné kopírování

```text
S < D < S+length
```

```text
zdroj [----------------]
         cíl [----------------]
```

Dopředné kopírování by přepsalo ještě nepřečtené zdrojové bajty. Instalátor
převede HL a DE na inkluzivní konce bloků a použije `LDDR`.

Relokační a konfigurační průchody pracují nad zkopírovaným rezidentem, nikoli nad
předpokládaným nepřekrývajícím se obrazem.

## C.10 Rezidentní prefix monitoru podle funkčních oblastí

Prvních 5 000 bajtů je těsně propletených, ale konceptuální mapa je:

```text
B+$0000  skok vstupu úplného systému
          uložené/výchozí konfigurační tabulky monitoru
          deskriptory čelního panelu a ochranná okna
          teplý vstup monitoru a dispatcher kláves
          navigace po adresách a vstup monitoru
          výpis/editace paměti, blokové MOVE/FILL/FIND
          kazetové operace S/J/Y
          trasování, breakpoint a nativní CALL příkazy
          builder scratch vykonání a zachycení stavu
          klasifikátory toku řízení a přístupů do paměti
          disassembler a směrování výstupu
          vykreslování čelního panelu
          uložený primární/alternativní obraz registrů
          řetězce monitoru a kompaktní metadata
B+$1388  hranice assembler-only varianty
```

Nejde o přísnou mapu modulů v pořadí zdroje. Disassembler a renderery panelu
například spotřebovávají tabulky umístěné blízko jiných dat monitoru.

## C.11 Uložený obraz procesoru

Monitor uchovává úplný prohlížitelný stav procesoru v zapisovatelných bajtech
rezidentu. Konceptuálně:

```text
uložené primární registry
    AF, BC, DE, HL
uložené indexové a systémové registry
    IX, IY, SP, I, R
uložené alternativní registry
    AF', BC', DE', HL'
pseudoregistry monitoru
    akumulátor T-stavů, ukazatele zobrazení X/Y, současné PC
stav povolení přerušení
scratch slova zachycení flags pro LD A,R a LD A,I
```

Přesné bajty jsou proloženy deskriptory čelního panelu a podporou vykonávání.
Čelní panel neudržuje duplicitní model zobrazení: pole deskriptorů ukazují přímo
na tento uložený stav.

Během jednoho řízeného kroku skutečný Z80 dočasně obdrží uložený uživatelský
stav. Po scratch instrukci zachycovací kód serializuje výsledný stav zpět před
obnovením stacku monitoru.

## C.12 Oblast scratch vykonávání

Execution engine sestaví dočasný program v zapisovatelném scratch prostoru
rezidentu:

```text
začátek scratch
┌───────────────────────────────────────────┐
│ opcode DI nebo EI zvolený z uloženého st.│
│ obnovení registrů/kontextu                │
│ kopírovaná, změněná nebo náhradní instr. │
│ volitelné mosty návratu větve/call        │
│ skok do sekvenční/taken cesty zachycení  │
└───────────────────────────────────────────┘
blízký scratch
┌───────────────────────────────────────────┐
│ dočasně uložené AF a sondy přerušení     │
│ operand obnovy stacku                     │
│ predikované next-PC/callback data         │
└───────────────────────────────────────────┘
```

Bajty se regenerují pro každý krok. Nejde o stabilní podprogram, kterému lze
porozumět z jediného dumpu paměti.

Nativní breakpoint a direct-CALL režimy používají příbuzné scratch/řídicí
struktury, ale mohou vykonávat uživatelský kód libovolně dlouho, než se zachycení
vrátí.

## C.13 Suffix assembleru/editoru podle funkčních oblastí

Od offsetu payloadu `$1388`:

```text
+$1388  vstupní skok a dispatcher tokenizovaných příkazů
         příkazy editoru a operace vybraného bloku
         vyhodnocení expressionů a lookup symbolů
         tape save/verify/load zdroje a symbolů a import GENS
         řadič dvouprůchodového sestavení a emitery druhého průchodu
         pseudoinstrukce a RUN
         teplá smyčka editoru a odevzdání zdrojového řádku
         parser text→záznam a expander záznam→text
         navigace zdrojem a dynamické vkládání/mazání
         klávesnice, tokeny a vlastní vykreslování obrazovky
         vkládání/sběr symbolů a paměťové utility
         zprávy, slovníky mnemoniců/operandů
         názvy příkazů a 687 deskriptorů instrukcí
         dvacet prázdných zdrojových záznamů
         prázdná tabulka symbolů + rezerva code-end
+$3E80  exkluzivní konec
```

## C.14 Počáteční tail zdroje a symbolů

Na konci čerstvě instalovaného payloadu:

```text
nižší adresy
┌────────────────────────────────────────────┐
│ tabulka instrukcí                        │
├────────────────────────────────────────────┤
│ sourceBufferStart                        │
│ 20 × prázdný záznam `$00,$30`            │
│                                           │
│ sourceBufferPreviousLine označuje záznam 12│
│ sourceBufferAccessLine označuje záznam 13 │
│ dalších šest prázdných záznamů pod displejem│
├────────────────────────────────────────────┤
│ symbolTableDefaultPt                     │
│ slovo `$0000` = nula položek symbolů      │
├────────────────────────────────────────────┤
│ codeEndDefaultPt                         │
│ šest rezervovaných bajtů v chráněném tailu│
├────────────────────────────────────────────┤
│ defaultPointerAdjustmentSentinel         │
│ neškodné fallback slovo za počátečním koncem│
└────────────────────────────────────────────┘
vyšší adresy
```

Zdroj se inicializuje dvaceti záznamy, aby access line mohla začínat s třinácti
platnými záznamy nad sebou a šesti pod sebou.

## C.15 Dynamické uspořádání zdroje/symbolů během editace

Trvalá oblast editoru se mění při vytváření záznamů a symbolů:

```text
pevné rezidentní tabulky
        │
        ▼
┌────────────────────────────────────────────┐
│ komprimované zdrojové záznamy             │ rostou/zmenšují se nahoru
│ trvalé prázdné tail záznamy                │
├────────────────────────────────────────────┤  varcSymbolTablePt
│ slovo počtu symbolů                       │
│ ordinal vector                            │
│ seřazené proměnlivé záznamy symbolů       │ pohybují se se zdrojem
├────────────────────────────────────────────┤
│ chráněný živý konec / stav code-end        │ varcCodeEndPt
└────────────────────────────────────────────┘
```

Vložení zdroje otevře mezeru a posune oblast symbolů nahoru. Smazání zdroje
mezeru zavře a posune ji dolů. Společné memory movers opraví fyzické ukazatele;
volající editoru/symbolů opraví sémantické odkazy, například aktivní řádek,
hranice bloku a ordinaly symbolů.

## C.16 Vnitřní mapa tabulky symbolů

Konceptuální živá tabulka symbolů je:

```text
symbolTablePt:
+0  count low
+1  count high
+2  vector entry for ordinal 1
+4  vector entry for ordinal 2
...
    each vector word is a compact offset to a symbol record

sorted symbol records:
    flags/value/name representation
    variable-length high-bit-terminated name
```

Vektor zachovává stabilní ordinaly od jedničky používané komprimovaným zdrojem,
zatímco záznamy mohou zůstat abecedně seřazené podle názvu. TABLE C může odstranit
neodkazované odemčené záznamy a přepsat ordinaly ve zdroji.

## C.17 Výchozí výstup generovaného kódu

Bez `ORG` nebo `PUT` inicializuje kompilace:

```text
logical address  = varcCodeEndPt + 1
physical output  = varcCodeEndPt + 1
```

Konceptuálně:

```text
rezident + zdroj + symboly
┌────────────────────────────────────────────┐
│ chráněná živá oblast PROMETHEA            │
└────────────────────────────────────────────┘  codeEndPt
                                             +1
┌────────────────────────────────────────────┐
│ výchozí generovaný strojový kód           │
└────────────────────────────────────────────┘
```

`ORG` mění logickou i fyzickou pozici. `PUT` mění fyzický výstupní ukazatel a
zachovává odlišný čítač logické adresy. `DEFS` posouvá pozice bez emitování
bajtů.

Assembler chrání živou oblast rezidentu/zdroje/symbolů před výstupem.
Uživatelem zvolený U-TOP omezuje povolený horní konec.

## C.18 Reprezentace vybraného bloku zdroje

PROMETHEUS ukládá dva ukazatele na zdrojové záznamy jako okraje bloku. Jejich
fyzické pořadí se nepředpokládá; `getSelectedBlock` je normalizuje:

```text
margin A ---- možná dříve nebo později ---- margin B

normalized result:
DE = first record
HL = last record
```

Příkazy COPY, DELETE, PRINT, SAVE a blokový FIND spotřebovávají tento
normalizovaný inkluzivní rozsah záznamů. Výběr je stav editoru, nikoli bit uložený
v každém zdrojovém záznamu.

## C.19 Rozložení obrazovky editoru

Editor používá okno dvaceti zdrojových záznamů:

```text
horní okraj obrazovky
┌────────────────────────────────────────────┐
│ 13 zdrojových záznamů před aktivním řádkem│
├────────────────────────────────────────────┤
│ aktivní/access line                       │ zvýrazněné attributes
├────────────────────────────────────────────┤
│ 6 zdrojových záznamů za aktivním řádkem   │
├────────────────────────────────────────────┤
│ oblast vstupu/stavu                       │ dolní řádky bitmapy
└────────────────────────────────────────────┘
```

Pevné adresy zahrnují:

```text
BOTTOM_LINE_VRAM_ADDRESS       `$50E0`
LEFT_BOTTOM_ATTRIBUTE_ADDRESS  `$5AE0`
ACCESS_LINE_ATTRIBUTE_ADDRESS  `$59E0`
THIRD_LINE_ATTRIBUTE_ADDRESS   `$5840`
```

Přesný vizuální účel bajtu závisí na režimu. Monitor znovu používá části stejné
obrazovky pro panel a editační řádek.

## C.20 Mapa deskriptorů čelního panelu monitoru

Existuje třicet čtyři sedmibajtových deskriptorů. Každý ukazuje na:

```text
+0..+1  bitmap address or special-area reference
+2      heading/name representation
+3      source class and formatting mode
+4      size/capability flags
+5..+6  value source or destination address
```

Pevná oblast deskriptorů mapuje přímo na:

- pole registrů;
- flags;
- oblast seznamu paměti;
- oblast disassembly;
- okna odvozená z X/Y a stacku;
- oblast vstupu/editace monitoru.

Editor čelního panelu mění bajty deskriptorů přímo. Následující překreslení čte
stejnou tabulku; neexistuje oddělený uložený objekt rozložení.

## C.21 Tabulky ochranných oken

Sady oblastí READ, WRITE, RUN, DEFB a DEFW sdílejí formát rozsahů s biased count:

```text
začátek tabulky:
    stored count = visible ranges + 1
    first low word
    first high word
    second low word
    second high word
    ...
    spare tail storage
```

Dynamický rezidentní rozsah je syntetizován z:

```text
ENTRY_POINT_WITH_MONITOR nebo upravená assembler-only báze
through current varcCodeEndPt
```

Editor rozsahů monitoru může zobrazit, vložit a smazat až kapacitu viditelnou ve
formátu. MOVE a FILL však volají pouze checker rezidentu a vlastní okna
READ/WRITE nekonzultují; dodatek G zaznamenává tuto potvrzenou odchylku.

## C.22 Workspace maskovaného finderu

Příkaz G monitoru ukládá pět sousedních dvojic:

```text
monitorFindByteMaskPairs:
+0 value 1   +1 mask 1
+2 value 2   +3 mask 2
+4 value 3   +5 mask 3
+6 value 4   +7 mask 4
+8 value 5   +9 mask 5
```

Expression dá masku `$FF`. Wildcard dvojtečky dá masku `$00`. N opakuje stejnou
specifikaci hledání od současné adresy plus jedna.

## C.23 Dočasný kazetový staging pro LOAD zdroje

Editor LOAD nekopíruje komprimované záznamy přímo do živého zdroje. Načte
uložený payload poblíž U-TOP a potom importuje záznamy jeden po druhém:

```text
horní paměť poblíž U-TOP
┌────────────────────────────────────────────┐
│ staged uložený segment zdroje             │
│ staged bridge/metadata                    │
│ staged uložená tabulka symbolů            │
└────────────────────────────────────────────┘

for each imported record:
    expand using staged symbol table
    copy canonical text to inputBuffer
    submit through ordinary editor parser
    create/resolve live symbols by name
```

Tento staging odděluje importovaný namespace ordinalů od živého. Selhání může
ponechat již importované záznamy potvrzené; operace není transakčním
all-or-nothing merge.

## C.24 Dočasné rozložení importu GENS/MASM

Importer GENS podobně stageuje cizí bajty poblíž U-TOP. Každý cizí řádek je
rámován dvoubajtovým číslem řádku a ukončením carriage return, normalizován do
textového řádku PROMETHEA, omezen kapacitou editačního bufferu a odevzdán běžné
cestě zdroje.

```text
staged cizí bajty
        ↓ line decoder
inputBuffer canonical text
        ↓ ordinary tokenizer/parser
live compressed source + live symbols
```

Řídicí znaky se normalizují, high bits se odstraňují a příliš dlouhé řádky se
zkracují podle potvrzeného chování importeru.

## C.25 Relokační proudy v instalačním obrazu

Generovaný proud reprezentuje 1 293 relokovaných slov:

```text
první proud    571 cílů prefixu monitoru
bridge         posune průběžný cíl do suffixu assembleru
druhý proud    722 cílů assembleru/editoru
```

Emitovaný historický proud zabírá 1 145 bajtů. Je uložen před zbývajícím logem a
rezidentním payloadem v instalačním obrazu a s instalátorem se kopíruje na
`$5000`.

Relokační proud **neobsahuje** absolutní cílové adresy. Obsahuje delty od
předchozího cíle a volitelné počty opakování. Instalátor prochází současně proud
i zkopírovaný cílový obraz.

## C.26 Proud konfiguračních patchů

Čtrnáct zvolených uživatelských nastavení se kopíruje do čtrnácti rezidentních
bajtů nebo opcodes. Tabulka obsahuje čtrnáct signed slov:

```text
current patch pointer begins at payload offset 0
for each word:
    pointer += signed delta
    write next selected setting byte
```

Historické cílové offsety jsou:

```text
$29CE $2502 $2950 $0F0C $16A4 $29BC $0ECC
$0EDA $2021 $2959 $1A41 $1F13 $16A7 $0F04
```

Pořadí je pořadím instalačních zápisů, nikoli adres; signed delty se proto po
payloadu pohybují dopředu i dozadu.

## C.27 Časová osa instalačních stavů

Nejužitečnější společná mapa je chronologická:

```text
1. Tape loader
   Obraz CODE existuje na fyzické adrese L, možná ne $5DC0.

2. Bootstrap
   $4000-$4FFF vymazáno; SP=$4020.
   Fyzická L získána přes CALL do ROM RET.

3. Kopie instalátoru
   `$07CD` bajtů zkopírováno z L+$0017 na `$5000`.
   Řízení skočí na `$5000`.

4. UI instalátoru
   Tail loga čten z původního fyzického obrazu.
   Fyzický ukazatel payloadu zachován na obrazovkovém stacku.

5. Potvrzení
   Na B se zkopíruje úplných 16 000 bajtů nebo suffix 11 000 bajtů.
   Směr zvolen jako memmove.

6. Konfigurace
   Do zkopírovaného rezidentu se patchuje čtrnáct nastavení.

7. Relokace
   Proudy monitoru a/nebo assembleru přičtou správnou bázi k 16bitovým slovům.

8. Vstup
   Nastaví se nový rezidentní stack.
   Zvolený vstup se vloží na stack a dosáhne pomocí RET.

9. Teplý start editoru/monitoru
   Interní stack resetován; obrazovka překreslena; dynamický tail zdroje/symbolů
   začíná žít.
```

## C.28 Rychlá reference adresové aritmetiky

```text
full payload length                 $3E80 = 16 000
monitor prefix length               $1388 =  5 000
assembler/editor suffix length      $2AF8 = 11 000
installation image length           $47B4 = 18 356
historical full base                $5DC0
historical full assembler boundary  $7148
historical full exclusive end       $9C40
historical physical payload start   $66F4 in loaded image
historical image exclusive end      $A574
installer execution base            $5000
bootstrap temporary stack           $4020
```

Kdykoli se dvě z těchto hodnot objeví v jednom výpočtu, nejprve určete adresový
svět:

```text
fyzická adresa instalačního obrazu
logická adresa instalátoru
offset payloadu s originem nula
fyzická adresa úplného rezidentu
fyzická adresa assembler-only rezidentu
adresa obrazovky/hardware
```

Většina zdánlivých adresových hádanek PROMETHEA vzniká smícháním těchto světů.
