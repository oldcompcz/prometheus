# Kapitola 50: Proč program nelze prostě načíst a spustit

Zdrojový soubor začíná instalátorem, nikoli editorem nebo monitorem. Instalátor
jsme až dosud odkládali, protože relokaci lze pochopit teprve tehdy, když víme,
co se vlastně relokuje.

Teď už to víme.

Rezidentní aplikace obsahuje:

- tisíce volání a skoků mezi rutinami;
- ukazatele na tabulky, řetězce, buffery zdroje a uložené registry;
- adresy vložené do samomodifikovaných instrukcí;
- deskriptory monitoru ukazující na data;
- callbacky assembleru patchované do operandů;
- dvě možná rezidentní rozložení;
- počáteční záznamy zdroje a konec tabulky symbolů.

Obyčejný program typu načti-a-spusť by mohl předpokládat jedinou pevnou adresu.
PROMETHEUS chce, aby si uživatel zvolil, kde bude celá tato dílna sídlit. Může
rovněž vynechat prefix monitoru a nainstalovat pouze assembler/editor.

Tato rozhodnutí mění načítání v malou linkovací operaci prováděnou přímo na
Spectru.

## Tři adresy, ne jedna

Instalační proces pracuje se třemi různými významy adresy.

### 1. Fyzická adresa načtení z kazety

Je to místo, kam se celý distribuovaný blok CODE náhodou dostane v RAM.
Historická hlavička obvykle navrhuje `$5DC0`, ale příručka dovoluje načíst obraz
i na jinou použitelnou adresu.

Budeme ji nazývat:

```text
physicalLoadBase
```

První bootstrap instrukce se skutečně vykoná právě tam.

### 2. Dočasná adresa instalátoru

Kompaktní instalátor se zkopíruje na pevnou adresu:

```text
$5000
```

Je sestaven tak, jako by sídlil na `$5000`, takže po zkopírování může uvnitř
používat běžné absolutní labely. Vykreslí konfigurační obrazovku a provede velký
přesun i relokaci.

### 3. Konečná rezidentní adresa

Uživatel zadá pětimístnou desítkovou instalační adresu. Na ni se zkopíruje celý
rezidentní program — nebo pouze jeho assemblerová přípona.

Budeme ji nazývat:

```text
residentBase
```

Po relokaci se řízení nakonec přenese na tuto adresu.

Všechny tři hodnoty se mohou lišit:

```text
fyzický blok CODE       $8000
workspace instalátoru   $5000
rezidentní aplikace     $A000
```

Jejich zaměňování by zdrojový kód učinilo téměř nesrozumitelným.

## Načtení není instalace

Když ROM Spectra načítá blok CODE, zná pouze dvě základní věci:

```text
cílová adresa
počet bajtů
```

Nerozumí tomu, že část bloku tvoří bootstrap, část instalátor sestavený pro jiný
origin a část payload, jehož interní slova je nutné přepočítat na nový základ.

Proto:

```text
LOAD umístí bajty
INSTALL tyto bajty interpretuje a transformuje
```

Distribuovaný blok CODE je vhodnější představovat si jako samorozbalovací
vývojové prostředí než jako konečný rezidentní binární obraz.

## Rezidentní payload je linkován od nuly

Payload obsahující monitor a assembler začíná takto:

```asm
relocatablePayloadStart:
    org 0

ENTRY_POINT_WITH_MONITOR:
```

Linkování s originem nula dává každému internímu absolutnímu labelu užitečnou
vlastnost: jeho sestavené slovo je **offsetem uvnitř payloadu**.

Předpokládejme, že operand volání obsahuje:

```text
$1234
```

a toto slovo odkazuje na rutinu vzdálenou 4 660 bajtů od začátku payloadu.
Instalace payloadu na `$8000` vyžaduje:

```text
$1234 + $8000 = $9234
```

Instalátor může taková slova opravit přičtením jednoho společného základu.

Relativní větve tuto úpravu nepotřebují. Displacement `JR` závisí na vzdálenosti
mezi dvěma bajty uvnitř téhož přesunutého bloku; tato vzdálenost zůstává stejná.
Volání ROM a adresy obrazovky rovněž zůstávají pevné, protože ukazují mimo
payload.

## Proč nenapsat rezidentní kód nezávislý na poloze?

Moderní systémy se relokaci často vyhýbají výpočtem adres vzhledem k základnímu
registru. Z80 a prostředí Spectra zde takové řešení činí nepřitažlivým.

Rezidentní rutina PROMETHEA chce psát:

```asm
call renderInputLineAtBitmapAddress
ld hl,mnemonicsTable
ld (varcAssemblyOutputPointer+1),hl
```

Kdyby každá taková operace musela za běhu znovu získat základ a přičíst offset,
program by byl:

- větší;
- pomalejší;
- náročnější na registry;
- obtížněji kombinovatelný se samomodifikovanými operandy;
- méně podobný běžnému kódu Z80.

PROMETHEUS zaplatí cenu relokace jednou během instalace, aby potom mohl rezidentní
program zůstat kompaktní a přímočarý.

## Dva rezidentní produkty v jednom payloadu

Linkovaný payload má důležitou hranici:

```text
ENTRY_POINT_WITH_MONITOR
        prefix monitoru, historicky 5 000 bajtů
ENTRY_POINT_WITHOUT_MONITOR
        přípona assembleru/editoru, historicky 11 000 bajtů
relocatablePayloadEnd
```

Instalátor může vytvořit kterýkoli z obou produktů.

### Úplná instalace

```text
residentBase + 0
    prefix monitoru
    přípona assembleru/editoru
```

Vstupním bodem je `ENTRY_POINT_WITH_MONITOR` relokovaný na `residentBase`.

### Instalace pouze assembleru

Prvních 5 000 bajtů se vynechá:

```text
residentBase + 0
    pouze přípona assembleru/editoru
```

Zdrojové bajty, které byly linkovány na offsetu payloadu 5 000, nyní začínají na
rezidentním offsetu nula. Není to totéž jako pouhé vynechání kopírování. Interní
absolutní slova v příponě byla původně offsety od začátku úplného payloadu.

Pro instalaci pouze assembleru je jejich oprava pojmově:

```text
installedWord = linkedWord + residentBase - monitorPrefixLength
```

Instalátor rovněž provede dva záměrné patche, které změní předpoklady vstupů
spojených s monitorem na chování varianty bez monitoru.

Právě toto druhé rozložení je důvodem, proč jsou relokační metadata rozdělena do
dvou proudů.

## Dočasný instalátor potřebuje pevný domov

První bootstrap nemůže bezpečně používat absolutní odkazy na vlastní labely,
protože jeho fyzická adresa načtení dosud není známá. Psát za tohoto omezení celý
interaktivní instalátor by bylo bolestivé.

Řešením je udržet část nezávislou na poloze co nejmenší:

```text
zjisti fyzickou adresu načtení
zkopíruj malý instalátor na známou adresu $5000
skoč na $5000
```

Na `$5000` může instalátor používat běžné absolutní adresy pro:

- své řetězce;
- operandy nastavení;
- obsluhy klávesnice;
- data loga;
- proud patchů;
- dekodér relokace.

Konečný rezidentní obraz se nekopíruje, dokud uživatel nestiskne ENTER.

## Proč lze použít `$5000`

Během bootstrapu se dolní část bitmapy obrazovky Spectra vymaže a vypůjčí jako
workspace. Dočasný stack začíná na `$4020`. Instalátor obsadí paměť od `$5000`,
tedy pod obvyklým výchozím místem načtení `$5DC0`.

Toto uspořádání vytváří kompaktní řízenou oblast:

```text
$4000-$4FFF   vymazaná obrazovka/workspace a oblast dočasného stacku
$5000...      zkopírovaný instalátor
jinde         původní načtený instalační obraz
```

Jde pouze o dočasný stav. Konečná rezidentní aplikace může být nainstalována
jinam a později opět normálně používat obrazovku.

## Kopírování se může překrývat

Načtený payload a konečný cíl lze uspořádat několika způsoby:

```text
cíl pod zdrojem               dopředné kopírování je bezpečné
cíl nad zdrojem               může být nutné zpětné kopírování
nepřekrývající se oblasti     fungovat může kterýkoli směr
```

Pokud cíl začíná uvnitř zdrojového bloku na vyšší adrese, `LDIR` by přepsal
bajty, které ještě nebyly zkopírovány. Instalátor tento případ rozpozná a použije
kopírování směrem zpět.

Jde o tentýž problém přesunu paměti, který jsme probírali v kapitole 7, nyní však
aplikovaný na celou rezidentní aplikaci.

Moderní rekonstrukce záměrně testuje oba směry:

```text
načti vysoko -> nainstaluj nízko
načti nízko  -> nainstaluj vysoko s překryvem
```

Původní algoritmus byl na tuto pružnost připraven už tehdy.

## Konfigurační bajty se musí přesouvat s kódem

Obrazovka nastavení umožňuje uživateli zvolit například:

- instalační adresu;
- zahrnutí monitoru;
- atributy textu a zvýraznění;
- převod velikosti písmen;
- délku kliknutí klávesnice a nastavení tónu.

Rezidentní program ukládá mnohá z těchto nastavení do bezprostředních operandů
nebo malých instrukcí, nikoli do jediné běžné struktury. Jejich umístění se proto
mění spolu s rozložením payloadu.

Instalátor potřebuje kompaktní seznam cílů, které má patchovat. Historický
program tento seznam ukládá jako znaménkové delty. V rekonstrukci generují stejné
kompaktní proudy automaticky pojmenované labely `@config-patch`.

Konfigurační patchování a relokace spolu souvisejí, ale nejsou totožné:

```text
konfigurační patch
    zapiš vybraný bajt nebo slovo do pojmenovaného rezidentního nastavení

relokace
    přičti rezidentní základ k internímu slovu absolutní adresy
```

Konfigurační hodnotou může být barva nebo prodleva, která nemá s adresou nic
společného.

## Absolutní slova jsou rozptýlena v kódu i datech

Relokační místa se neomezují na zjevné instrukce `JP` a `CALL`. Vyskytují se také
v:

- `LD HL,address` a podobných bezprostředních operandech;
- ukazatelích tabulek;
- adresách deskriptorů čelního panelu;
- uložených cílech callbacků;
- samomodifikovaných proměnných inicializovaných labely;
- interních datových slovech pojmenovávajících rutiny nebo buffery.

Ruční udržování seznamu po změnách zdroje je nebezpečné. Na nový absolutní
ukazatel lze zapomenout; vložený bajt změní pozdější delty v tabulce; slovo, které
vypadá jako adresa, může být ve skutečnosti daty deskriptoru.

Rekonstrukce proto sestavuje payload na několika umělých originech a porovnává
výstupy. Skutečné relokovatelné slovo se změní přesně o rozdíl originů. Kapitola
55 tento proces vysvětlí podrobně.

## Některá data vypadající jako adresy se nesmějí přesunout

Jedno slovo v tabulkách monitoru se záměrně podobá interní adrese, ale ve
skutečnosti jde o data deskriptoru tvarovaná jako opcode:

```asm
    defw ENTRY_POINT_WITH_MONITOR+2
```

Jeho číselná závislost na originu neznamená, že je má instalátor za běhu
relokovat. Zdroj jej označuje `@noreloc` a generátor tuto výjimku ověřuje.

To ukazuje důležité pravidlo:

> Relokace se řídí významem, nikoli pouhým číselným vzhledem.

Generátor s více originy objevuje kandidáty; anotace zdroje řeší výjimečnou
sémantiku.

## Úplný instalační problém

Instalátor musí provést tuto posloupnost:

```pseudocode
physicalLoadBase = discoverWhereCODEActuallyLanded()
copySmallInstallerTo($5000)

settings = interactWithUser()
residentBase = parseFiveDecimalDigits(settings.address)

if settings.monitorEnabled:
    source = fullPayloadStart
    length = fullPayloadLength
    relocationBias = residentBase
else:
    source = assemblerSuffixStart
    length = assemblerSuffixLength
    relocationBias = residentBase - monitorPrefixLength

copyOverlapSafely(source, residentBase, length)
patchResidentConfiguration(settings)
applyRelocationStreams(relocationBias)
applyAssemblerOnlySpecialPatchesIfNeeded()
setResidentStack()
jumpToResidentEntry()
```

Každý řádek skrývá mechanismus na celou kapitolu, ale celkový účel je nyní
zřejmý.

## Mapa distribuovaného obrazu

Vysílaný blok CODE je fyzicky uspořádán přibližně takto:

```text
+------------------------------------+
| malý bootstrap odolný vůči relokaci|
+------------------------------------+
| instalátor sestavený pro $5000     |
| generovaná data patchů/relokace    |
| konec loga                         |
+------------------------------------+
| payload linkovaný od originu 0     |
|   prefix monitoru                  |
|   přípona assembleru/editoru       |
|   tabulky a počáteční workspaces   |
+------------------------------------+
```

Hodnoty ORG popisují logické adresy vykonání, nikoli nutně pořadí, v němž se
bajty nacházejí v kazetovém bloku. Build jednotlivé části vysílá souvisle a
bootstrap zná jejich fyzické offsety uvnitř tohoto bloku.

## Mapa po úplné instalaci

Pro zvolený základ `$8000`:

```text
$8000              ENTRY_POINT_WITH_MONITOR
$8000-$9387        prefix monitoru, 5 000 bajtů
$9388              ENTRY_POINT_WITHOUT_MONITOR
$9388-...          přípona assembleru/editoru
...                tabulky, prázdný zdroj a konec tabulky symbolů
```

Ke každému uvedenému absolutnímu internímu slovu bylo přičteno `$8000`.

## Mapa po instalaci pouze assembleru

Pro tentýž zvolený základ:

```text
$8000              ENTRY_POINT_WITHOUT_MONITOR zkopírovaný sem
$8000-...          přípona assembleru/editoru
```

Slova v této příponě dostanou účinnou korekci:

```text
$8000 - $1388 = $6C78
```

protože `$1388` je historická délka prefixu monitoru 5 000 bajtů.

Zdroj to vyjadřuje symbolicky, místo aby spoléhal na historické číslo.

## Proč se instalátor objevuje ve zdroji jako první

Fyzické pořadí zdroje sleduje potřeby spuštění a vysílaného obrazu:

```text
bootstrap musí být prvním vykonaným bajtem
bajty instalátoru musí následovat ve známém fyzickém displacementu
payload následuje jako materiál určený ke kopírování
```

Pořadí výkladu v knize je opačné. Nejprve jsme poznali rezidentní program, takže
výrazy jako „relokovat interní absolutní slovo“ nyní odkazují na známé věci:

- ukazatel čelního panelu;
- adresu tabulky symbolů;
- uložený callback;
- ukazatel výstupu assembleru;
- zachycovací rutinu monitoru.

Instalátor není záhadné lepidlo. Je to malý program, který připraví všechny
mechanismy, jimž už rozumíme.

## Zpět k celému stroji

PROMETHEUS nelze prostě načíst a spustit, protože načtený blok CODE není
konečným rezidentním uspořádáním.

Musí sladit:

```text
kam kazetový loader umístil obraz
kde očekává vykonání dočasný instalátor
kde chce mít aplikaci uživatel
zda je požadován celý payload, nebo jen jeho část
které bajty jsou konfigurací
která slova jsou interními adresami
který směr kopírování je bezpečný
```

Jakmile jsou tyto otázky zodpovězeny, rezidentní program se stane obyčejným
přímým kódem Z80. Volání, ukazatele a samomodifikované operandy obsahují skutečné
konečné adresy. Složitost relokace zmizí z běžné editace, sestavování i
trasování.

Příští kapitola prozkoumá malý bootstrap, který řeší první a nejnepříjemnější
otázku: jak může kód zjistit vlastní fyzickou adresu načtení dříve, než může
důvěřovat jakékoli adrese odkazující na něj samotný?

## Co se změnilo v paměti

Tato koncepční kapitola uvádí transformace, které instalace provede:

- vymaže a vypůjčí si `$4000-$4FFF`;
- zkopíruje bajty instalátoru na `$5000`;
- zkopíruje celý payload nebo assemblerovou příponu na zvolený rezidentní základ;
- patchuje vybrané konfigurační cíle;
- přičte instalační korekci k relokačním slovům;
- patchuje rozdíly vstupů varianty pouze s assemblerem;
- nastaví rezidentní stack a přenese řízení.

Podrobné zápisy probírají kapitoly 51–55.

## Důležité labely, s nimiž jsme se setkali

- `INSTALLATION_ADDRESS`
- `LOADER_ADDRESS`
- `bootstrapEntry`
- `installerEntryAt5000`
- `relocatablePayloadStart`
- `ENTRY_POINT_WITH_MONITOR`
- `ENTRY_POINT_WITHOUT_MONITOR`
- `relocatablePayloadEnd`
- `emitByteAtAssemblyOutput`
- `assemblerOnlyMonitorFallbackAddress`
- `installerConfigurationPatchDeltas`
- `installerApplyRelocationTable`

## Myšlenky potřebné v dalších kapitolách

- Fyzická adresa načtení, dočasná adresa instalátoru a konečná rezidentní adresa
  jsou tři samostatné hodnoty.
- Distribuovaný blok CODE je instalační obraz, nikoli konečný rezidentní binární
  soubor.
- Payload je linkován od originu nula, takže interní slova jsou offsety.
- Úplný produkt a produkt pouze s assemblerem potřebují odlišné relokační korekce.
- Instalátor se vykonává na pevné adrese `$5000`, aby unikl nutnosti psát kód
  nezávislý na poloze.
- Kopírování payloadu musí být bezpečné při překryvu.
- Konfigurační patchování a relokace adres používají oddělené proudy metadat.
- Kandidáti na relokaci se mohou vyskytovat v instrukcích i datech.
