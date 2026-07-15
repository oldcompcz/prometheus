# Kapitola 34: Čelní panel

Když PROMETHEUS vstoupí do monitoru, obrazovka vypadá jako pečlivě uspořádaný
přístrojový panel. Registry mají svá známá malá pole. Poblíž registrů, které
ukazují do paměti, se zobrazí několik paměťových míst. Krátký disassembly výpis
má vlastní okno. Své místo má také současný stav přerušení, nasčítaný čas a
editovatelný příkazový řádek.

Snadno bychom mohli předpokládat, že zdroj obsahuje jednu velkou kreslicí rutinu
s instrukcemi typu:

```text
vypiš A na řádku 16, ve sloupci 0
vypiš BC na řádku 18, ve sloupci 9
vypiš SP na řádku 18, ve sloupci 18
vypiš dva řádky disassembly výpisu na řádku 13
```

Takto se však panel nevytváří.

PROMETHEUS popisuje panel daty. Obecný renderer čte řadu malých záznamů a zjišťuje:

- kde položka začíná v bitmapě Spectra;
- jaký nadpis se má vypsat;
- odkud pochází její hodnota;
- zda má hodnota jeden, nebo dva bajty;
- kolik hodnot se má zobrazit;
- zda postupují vodorovně, nebo svisle;
- zda se má každá hodnota zobrazit desítkově, šestnáctkově, binárně, jako znak,
  nebo několika způsoby současně.

Výsledkem je více než konfigurovatelná obrazovka. Je to malý **jazyk popisu
obrazovky**, který monitor interpretuje.

Tato kapitola se nejprve podívá na panel jako celek, potom rozebere sedmibajtové
záznamy a renderer, který je zpracovává, a nakonec se vrátí k editoru panelu,
jenž dovoluje tyto záznamy měnit za běhu PROMETHEA.

## Třicet čtyři malých popisů

Tabulka začíná na:

```asm
frontPanelItemDescriptors:
```

Obsahuje třicet čtyři záznamů. Každý záznam má přesně sedm bajtů. Pevná velikost
je důležitá, protože renderer i editor panelu přecházejí od jedné položky k další
přičtením sedmi.

Rekonstruované rozložení je:

```text
bajt 0,1   bitmapová adresa první znakové buňky Spectra
bajt 2     nadpis nebo selektor zvláštního rendereru
bajt 3     třída zdroje a příznaky formátu zobrazení
bajt 4     příznaky velikosti a schopností
bajt 5,6   adresa hodnoty, proměnné s adresou, nebo nepoužitá nula
```

V pseudokódu jeden deskriptor připomíná:

```text
PanelItem {
    screenAddress
    heading
    formatAndSource
    sizeAndCapabilities
    valueAddress
}
```

Tabulka nezačíná obyčejnými číselnými poli, ale třemi oblastmi:

1. editačním řádkem monitoru;
2. rolovacím oknem výpisu;
3. malým oknem disassembly výpisu.

Potom popisuje stav přerušení, uložené registry, příznaky, dvojice registrů,
čítač cyklů, dvě obecné adresy nazvané X a Y a pohledy do paměti přes BC, DE, HL,
SP, IX a IY.

Renderer nepotřebuje pro každou rodinu jinou vysokoúrovňovou smyčku. Většina
rozdílů je zakódována v bajtech deskriptoru.

## Adresa obrazovky, ne řádek a sloupec

První slovo každého záznamu je bitmapová adresa Spectra. Například uložený
registr A začíná:

```asm
    defb 000h
    defb 050h
```

Tyto bajty společně tvoří `$5000`, bitmapovou adresu odpovídající první znakové
buňce řádku obrazovky 16.

Okno výpisu začíná na `$4000`, tedy v levé horní bitmapové buňce. Editační řádek
začíná na `$50E0`, v první buňce posledního textového řádku. PROMETHEUS ukládá
tyto fyzické bitmapové adresy přímo, protože jeho renderer znaků už umí přecházet
od jedné bitmapové buňky k druhé.

Tím odpadá převod dvojice jako `(sloupec,řádek)` při každém překreslení panelu.
Editor panelu také dostává jednoduchý úkol: přesun položky znamená změnu dvou
uložených bajtů adresy.

Cenou je, že pohyb v bitmapě Spectra není obyčejné lineární sčítání. Jak
vysvětlila kapitola 8, sousední textové řádky jsou v paměti prokládané. Editor
panelu proto při přesunu položky nahoru, dolů, vlevo nebo vpravo používá stejné
pomocné rutiny bitmapových adres jako běžný renderer textu.

## Bajt 2: jaký nadpis se má objevit?

Třetí bajt deskriptoru vybírá viditelný nadpis, má však tři užitečné podoby.

### Zabalený název operandu

Malé hodnoty indexují běžnou tabulku názvů operandů. Používá se pro nadpisy jako:

```text
AF  BC  DE  HL  SP  IX  IY
```

Monitor neuchovává druhou tabulku zápisu názvů registrů. Znovu používá
`operandsReferences`, stejný kompaktní slovník, který používá assembler a
disassembler.

Například položka AF obsahuje selektor `$15`. Renderer předá tento index rutině
`renderFrontPanelOperandName`, která vyřeší a vypíše zabalený název.

### Jeden přímý glyph

Hodnoty od `$80` výše lze po zohlednění zobrazovacího významu horního bitu vypsat
přímo jako jeden znak. Jednotlivé položky osmibitových registrů používají hodnoty
jako:

```text
$C1  A
$C2  B
$C3  C
$C4  D
```

U jednopísmenného nadpisu se tím ušetří vyhledání v tabulce.

### Adresa v závorkách

Selektory `$D8` a vyšší požadují zvláštní nadpis. Místo pevného názvu renderer
vypíše vyřešenou adresu v závorkách:

```text
(32768):
```

nebo v šestnáctkovém režimu:

```text
(#8000):
```

Používá se to u adresových položek X a Y a u pohledů do paměti přes uložené
dvojice registrů. Nadpis tedy neříká pouze „paměť na HL“, ale skutečnou současnou
adresu uloženou v HL.

Nadpis vzniká z živých dat, takže se po úpravě registru nebo adresy panelu změní.

## Bajt 3: odkud hodnota pochází

Nejnižší dva bity bajtu 3 deskriptoru vybírají jednu ze čtyř tříd zdroje nebo
rendereru.

```text
00  položka příznaků
01  nepřímá položka paměti
10  přímá skalární položka
11  zvláštní oblast
```

### Třída 2: přímá skalární data

Většina deskriptorů registrů používá třídu 2. Bajty 5 a 6 ukazují přímo na
uloženou hodnotu:

```asm
    defw savedRegisterBC
```

Renderer čte ze samotného `savedRegisterBC`. Je-li položka nastavena jako slovo,
čte dva bajty. Je-li nastavena jako bajt, čte jeden.

To se hodí pro registry a další běžné proměnné monitoru, například čítač T-stavů.

### Třída 1: adresa obsahující adresu

Položky pohledu do paměti používají třídu 1. Bajty 5 a 6 ukazují na slovo, které
obsahuje adresu určenou k prohlížení.

Například položka `(HL)` ukazuje na `savedRegisterHL`:

```asm
    defw savedRegisterHL
```

Renderer nejprve přečte uloženou hodnotu HL a potom ji považuje za začátek
paměti, která se má zobrazit.

V pseudokódu:

```text
pointerVariable = descriptor.valueAddress
memoryAddress   = wordAt(pointerVariable)
valueSource     = memoryAddress
```

Tentýž mechanismus slouží pro X a Y. To jsou obyčejné adresové proměnné vlastněné
monitorem, nikoli registry Z80, ale z pohledu rendereru jde prostě o slova
obsahující adresy paměti.

### Třída 0: příznaky

Registr F je natolik neobvyklý, že dostává vlastní renderer. Jeho bity lze
zobrazit jako názvy podmínek nebo jako řadu osmi binárních číslic. Brzy se k
němu vrátíme.

### Třída 3: zvláštní oblasti

Editační řádek, okno výpisu, okno disassembly výpisu a zobrazení stavu přerušení
nejsou obyčejné posloupnosti bajtů. Třída 3 je odklání ke zvláštní obsluze.

Deskriptory editačního řádku a obecného výpisu hlavně vyhrazují oblasti obrazovky.
Deskriptor disassembly výpisu opakovaně volá společný jednořádkový dekodér.
Deskriptor přerušení vypisuje uložený stav `EI` nebo `DI`.

Čtyři třídy dovolují jedné tabulce popsat jednoduché hodnoty i větší oblasti
panelu, aniž by se každá položka musela změnit v samostatný ukazatel na funkci.

## Bajt 3 vybírá také reprezentace

Horní bity téhož bajtu vybírají výstupní formáty:

```text
bit 7  desítkově
bit 6  šestnáctkově
bit 5  binárně
bit 4  jako znak
bit 3  dvoubajtová hodnota místo jednobajtové
bit 2  svislá posloupnost místo vodorovné
```

Tyto bity jsou nezávislé. Hodnotu lze zobrazit ve více reprezentacích.

Bajt by se tedy mohl objevit jako:

```text
65 #41 01000001 A
```

jsou-li povoleny desítkový, šestnáctkový, binární i znakový formát.

To je důležitý detail. Formát není jediná výčtová hodnota typu:

```text
format = HEX
```

Je to sada přepínačů:

```text
showDecimal   = ano
showHex       = ano
showBinary    = ne
showCharacter = ano
```

Renderer zkoumá čtyři bity v pevném pořadí a volá každý povolený formátovač.

## Jeden bajt, nebo slovo

Bit 3 vybírá, zda každá logická hodnota zabírá jeden, nebo dva bajty.

U bajtové položky renderer doplní jeden bajt nulou do HL. U slovní položky přečte
běžnou little-endian dvojici.

Čelní panel používá toto rozlišení přirozeně:

- A, B, C, D, E, H, L, I a R jsou bajtové položky;
- AF, BC, DE, HL, SP, IX, IY a T jsou slovní položky;
- oblast paměti lze přepínat mezi bajtovým a slovním výkladem, dovolují-li to
  její příznaky schopností.

Kompaktní tabulka rendererů formátu obsahuje samostatné offsety pro bajtové a
slovní varianty desítkového, šestnáctkového, binárního a znakového výstupu.
Místo osmi úplných adres rutin ukládá PROMETHEUS osm jednobajtových offsetů od
`frontPanelValueRendererCodeBase`.

Je to stejný návrhový návyk, který jsme už viděli jinde:

```text
malá pevná rodina blízkých rutin
    → ulož jednobajtové offsety
    → přičti offset ke známé základně kódu
    → JP (IX)
```

## Vodorovné nebo svislé posloupnosti

Bit 2 určuje, co se stane po vypsání jedné logické hodnoty.

Ve vodorovném režimu pokračuje další hodnota na stejném řádku. Ve svislém režimu
PROMETHEUS posune bitmapový kurzor o jeden textový řádek a vynuluje stav mezer
mezi formáty.

To je důležité hlavně pro pohledy do paměti. Pět bajtů na SP lze zobrazit vedle
sebe, nebo lze stejné hodnoty uspořádat do svislého sloupce.

Vysokoúrovňová smyčka rendereru je:

```text
repeat descriptor.size krát:
    přečti jeden bajt nebo slovo

    for each povolená reprezentace:
        vypiš tuto reprezentaci

    if svisle:
        přejdi na další textový řádek
    else:
        pokračuj na současném řádku
```

Kód rendereru je kompaktní, ale toto je myšlenka, kterou realizuje.

## Bajt 4: velikost a možnosti editace

Nízkých pět bitů bajtu 4 deskriptoru představuje současnou velikost.

U obyčejné položky registru velikost nula položku skryje a velikost jedna ji
zobrazí. U položky paměti může velikost určovat počet po sobě jdoucích bajtových
nebo slovních hodnot. U oken výpisu a disassembly výpisu určuje jejich výšku v
textových řádcích.

Dva vyšší bity popisují, které operace editoru panelu dávají smysl:

```text
bit 6  lze přepínat bajtový/slovní typ
bit 5  lze přepínat vodorovný/svislý směr
```

Bit 7 označuje skutečně proměnlivě velkou položku. Je-li nastaven, vybírají
písmena A až Z v editoru panelu velikosti 0 až 25. Není-li nastaven, má smysl
pouze stav skryto/zobrazeno; kód zahodí vyšší bity velikosti.

Toto oddělení je nenápadné, ale užitečné:

```text
současný stav       žije v nízkých pěti bitech
povolené operace    žijí v horních bitech schopností
```

Editor panelu tak může zůstat obecný. Před změnou vlastnosti otestuje bit
schopnosti, místo aby například věděl, že paměť na SP lze měnit ve velikosti,
ale registr A nikoli.

## Skrývání je součástí vykreslování

`renderFrontPanelItemIfEnabled` začíná nejjednodušším možným testem viditelnosti:

```asm
    ld a,(ix+004h)
    and 01fh
    ret z
```

Nulová velikost znamená „tento deskriptor nevykresluj“. Volající přesto posune IX
o sedm bajtů a pokračuje dalším deskriptorem.

Neexistuje samostatný seznam viditelných položek ani strom větvení popisující
současné rozložení. Viditelnost je uložena v datech.

Konfigurace je díky tomu trvalá a levná. Skrytí I nebo zobrazení AF znamená změnu
jednoho bajtu deskriptoru. Běžná smyčka překreslení ji okamžitě respektuje.

## Jak se vykresluje běžná položka

Společným vstupem je `renderFrontPanelItem`. Ve zjednodušeném pseudokódu:

```text
vynuluj stav mezer mezi formáty
nastav kurzor obrazovky z bajtů 0,1 deskriptoru
vyřeš zdroj hodnoty z třídy zdroje deskriptoru
vypiš nadpis
vypiš dvojtečku

for each hodnota požadovaná velikostí deskriptoru:
    přečti bajt nebo slovo
    vypiš každou povolenou reprezentaci
    posuň ukazatel zdroje
    podle potřeby přejdi o jeden řádek obrazovky níže
```

Skutečná rutina používá DE jako ukazatel dat, HL jako kurzor obrazovky a IX jako
deskriptor. Tyto hodnoty pečlivě zachovává a prohazuje, protože všechny čtyři
rutiny reprezentací očekávají trochu jiné uspořádání registrů.

Zajímavé nejsou jednotlivé instrukce PUSH a POP. Důležité je, že záznam dodává
veškerou politiku potřebnou pro společnou smyčku.

## Kompaktní dispatcher reprezentací

PROMETHEUS podporuje osm variant rendereru:

```text
desítkový bajt       desítkové slovo
šestnáctkový bajt    šestnáctkové slovo
binární bajt         binární slovo
znakový bajt         znakové slovo
```

Tabulka neobsahuje osm adres. Obsahuje offsety do těsně uloženého shluku malých
rutin.

Vybraný offset se přičte k:

```asm
frontPanelValueRendererCodeBase:
```

a kód skočí přes IX.

Samomodifikovaná okamžitá hodnota uvnitř
`dispatchFrontPanelValueRendererWithSeparator` si pamatuje, zda už byla vypsána
předchozí reprezentace. První reprezentace začne okamžitě; pozdější dostanou
oddělující mezeru.

Tento drobný stav nahrazuje čtyři téměř shodné cesty „není-li první, vypiš
mezeru“.

## Znaková podoba je záměrně obranná

Bajt paměti nemusí být tisknutelným znakem. Znakový renderer proto zkoumá spodních
sedm bitů.

```text
$20..$7F  zobraz odpovídající glyph
$00..$1F  zobraz tečku
bit 7     zachovej význam inverzního videa
```

Hodnota `$01` se tedy změní v `.`, zatímco `$81` v tečku v inverzním videu.
Stejnou politiku znovu používá znakový výpis paměti v kapitole 36.

Monitor netvrdí, že každý bajt je text. Dává každému bajtu stabilní vizuální
podobu o jedné buňce.

## Příznaky jsou zvláštním jazykem

Uložený bajt F má na panelu dvě interpretace.

Ve výchozí podobě PROMETHEUS vybírá jeden název z každé ze čtyř dvojic:

```text
Z / NZ
C / NC
PE / PO
M / P
```

U vynulovaného registru F panel ukáže varianty odpovídající nenastaveným bitům a
vytvoří shrnutí jako:

```text
NZ NC PO P
```

Volby pocházejí z `frontPanelConditionNameSelectionTable`, jejíž záznamy jsou
pojmově:

```text
maska příznaku, token při nastavení, token při vynulování
```

Je-li pro F povolen binární formát, zvláštní renderer místo toho vypíše nadpis
podobný:

```text
SZ-H-PNC
```

a pod něj osm skutečných bitů.

Zdánlivé instrukce v tabulce podmínek jsou data. Je to jedno z míst, kde je
lineární disassembler obzvlášť zavádějící: bajty náhodou tvoří věrohodná větvení
a operace s registry, renderer je však čte jako masky a indexy názvů.

## Zvláštní oblast: okno disassembly výpisu

Položka disassembly výpisu neukazuje na uložená data. Její selektor odkloní
renderer do `.renderFrontPanelDisassemblyWindow`.

Současná adresa se vloží do samomodifikovaného operandu:

```asm
varcFrontPanelDisassemblyAddress:
    ld hl,00000h
```

Velikost z nízkých pěti bitů deskriptoru se stane počtem řádků. Pro každý řádek
PROMETHEUS:

1. zavolá `disassembleNextLineToBuffer`;
2. vykreslí výsledný 32znakový řádek;
3. pokračuje od další adresy vrácené v HL.

Výchozí velikost deskriptoru je dva, takže se zobrazí dva řádky disassembly
výpisu. Změna velikosti změní počet dekódovaných řádků, aniž se změní kód
disassembleru.

## Zvláštní oblast: stav přerušení

Deskriptor stavu přerušení vybírá jinou malou zvláštní cestu. Uložený bajt
monitoru `varcInterruptEnableState` se převede na odpovídající index mnemoniku a
vypíše se jako `EI` nebo `DI`.

Ani zde položka panelu neukládá vlastní adresu rutiny. Její selektor stačí, aby ji
obecný handler zvláštních položek rozpoznal.

## Běžné překreslení proti úplnému překreslení

Dva příbuzné vstupy vykreslují rozsahy deskriptorů.

`redrawFrontPanelAtCurrentAddress` začíná třetím deskriptorem — oknem disassembly
výpisu — a vykreslí 32 záznamů. Záměrně ponechává editační řádek a obecný
rolovací výpis beze změny. Tyto oblasti mohou obsahovat prompt nebo poslední
výstup výpisu, který má běžné obnovení monitoru zachovat.

`redrawEntireFrontPanel` začíná deskriptorem nula a vykreslí všech 34 záznamů.
Tuto úplnou podobu používá editor panelu, protože musí odhalit každou
nakonfigurovanou oblast.

Sdílená smyčka je téměř triviální:

```text
repeat B krát:
    vykresli deskriptor, není-li jeho velikost nulová
    IX += 7
```

Složitost žije v interpretu deskriptoru, nikoli v průchodu tabulkou.

## Editace panelu za jeho běhu

SYMBOL SHIFT+W vstoupí do `invokeFrontPanelEditor`.

Editor začíná chytrým trikem s mapou obsazení. Vybarví všech 768 atributových
buněk Spectra zvláštní barvou editoru a potom znovu vykreslí všechny položky
panelu. Vykreslené znaky nahradí tuto barvu běžným atributem textu. Buňky, které
si stále zachovávají barvu editoru, žádná položka nepoužila, takže se jejich
bitmapové buňky vymažou.

V pseudokódu:

```text
vybarvi každou atributovou buňku barvou editoru
vykresli všechny deskriptory panelu

for each buňka obrazovky:
    if její atribut má stále barvu editoru:
        vymaž její bitmapu
```

Není potřeba samostatné pole obsazení 32 krát 24. Samotná atributová obrazovka
Spectra dočasně slouží jako mapa.

## Výběr jednoho deskriptoru

`varcActiveFrontPanelItemOffset` ukládá bajtový offset, nikoli číslo položky.
Protože každá položka zabírá sedm bajtů, možné offsety jsou:

```text
0, 7, 14, 21, ...
```

Vybraná položka se překreslí barvou přístupového řádku. Klávesy 4 a 3 přecházejí
na další nebo předchozí deskriptor a na koncích cyklicky pokračují z opačné
strany.

Editor se po každé změně vrací přes syntetickou adresu `invokeFrontPanelEditor`.
Tím se znovu vytvoří celý panel, zvýrazní se nová aktivní položka a přečte se
další klávesa.

Je to stejný vzor teplého vstupu, jaký používá samotný monitor, jen v menším
měřítku.

## Přesun položky

Klávesy 5 až 8 přesouvají vybraný deskriptor vlevo, dolů, nahoru a vpravo.

Kód k adrese nepřičítá jednoduché konstanty. Volá pomocné rutiny pohybu v bitmapě
Spectra, aby správně zachoval prokládání řádků a přechody přes okraj obrazovky.
Výsledná bitmapová adresa se zapíše zpět do bajtů 0 a 1 deskriptoru.

Viditelný panel se přesune, protože následující překreslení interpretuje změněná
data. Neexistuje samostatná implementace „přesuň registr A“.

## Změna velikosti

Písmena A až Z se převedou na hodnoty 0 až 25 a vloží do pole velikosti.

U proměnlivých položek to znamená přesně to, co naznačuje:

```text
A → velikost 0
B → velikost 1
C → velikost 2
...
Z → velikost 25
```

U pevných skalárních položek se zachová pouze nízký bit odpovídající viditelnosti.
V praxi se operace používá k jejich skrytí nebo zobrazení, nikoli k vyžádání
řady sedmnácti kopií registru A.

Stejná vstupní cesta tak slouží pro výšky výpisů, výšky disassembly výpisu,
délky posloupností paměti i prostou viditelnost.

## Změna formátu

Šest příkazů se shiftem popisuje `frontPanelFormatToggleKeyTable`:

```text
SS+D  přepni desítkový formát
SS+H  přepni šestnáctkový formát
SS+B  přepni binární formát
SS+C  přepni znakový formát
SS+T  přepni bajtový/slovní typ, je-li podporován
SS+S  přepni vodorovný/svislý směr, je-li podporován
```

Každá položka tabulky obsahuje:

```text
klávesa, požadovaná maska schopností, bit určený k XOR
```

První čtyři přepínače formátu lze obecně použít. Typ a směr nejprve otestují
odpovídající bity schopností v bajtu 4 deskriptoru. Nepodporuje-li položka danou
operaci, klávesa nemá žádný účinek.

Bajty tabulky se v lineárním disassembly výpisu překrývají s věrohodnými opcodes
Z80, zde však jsou pouze tříbajtovými popisy úprav vlastností.

## Panel jako interpretovaný objekt

Nyní se můžeme vrátit k čelnímu panelu jako celku.

Při vstupu do monitoru:

```text
načte se současná adresa
    ↓
renderer začne deskriptorem 2
    ↓
každý viditelný záznam dodá pozici na obrazovce, nadpis a politiku dat
    ↓
běžné hodnoty používají společnou formátovací smyčku
    ↓
příznaky, stav přerušení a disassembly výpis používají zvláštní větve
    ↓
tytéž záznamy lze později upravovat na místě
```

Panel působí pevně, protože jeho výchozí nastavení jsou rozumná. Uvnitř je však
malým interpretovaným dokumentem.

Tento návrh šetří kód, ale také dává monitoru vlastnost neobvyklou pro tak malý
stroj: uživatel může přeuspořádat čelní panel debuggeru bez nového sestavení
PROMETHEA.

## Co se změnilo v paměti?

Při běžném překreslení se mění pouze bitmapové a atributové buňky. Uložený stav
uživatelského programu se čte, ale nemění.

Při editaci panelu může PROMETHEUS změnit:

- bajty 0 a 1 deskriptoru určující pozici;
- bajt 3 deskriptoru určující formát, typ a směr;
- bajt 4 deskriptoru určující velikost nebo viditelnost;
- `varcActiveFrontPanelItemOffset` určující právě vybraný deskriptor.

Samotné záznamy jsou měnitelnou rezidentní konfigurací.

## Myšlenky potřebné v dalších kapitolách

- Názvy registrů a cíle lze obnovit ze stejných deskriptorů, které slouží k
  zobrazení.
- Okno výpisu a okno disassembly výpisu jsou konfigurovatelné zvláštní oblasti.
- Položky paměti mohou dereferencovat uložené registry nebo adresová slova
  vlastněná panelem.
- Současně lze povolit několik výstupních reprezentací.
- Ochranné tabulky a seznamy adres znovu použijí stejnou obecnou filozofii:
  kompaktní data plus jeden sdílený interpret.

## Pokrytí zdroje

Tato kapitola vysvětluje `frontPanelItemDescriptors`, sedmibajtový formát
deskriptoru, `redrawFrontPanelAtCurrentAddress`, `redrawEntireFrontPanel`,
`renderFrontPanelItemIfEnabled`, `renderFrontPanelItem`, kompaktní offsety
rendererů hodnot, vykreslování příznaků, vykreslování zvláštních oblastí,
`invokeFrontPanelEditor` a `frontPanelFormatToggleKeyTable`.
