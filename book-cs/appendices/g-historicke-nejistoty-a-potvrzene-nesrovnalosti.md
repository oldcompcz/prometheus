# Dodatek G: Historické nejistoty a potvrzené nesrovnalosti

Rekonstruovaný program svádí ke dvěma opačným chybám.

První je přehnaná opatrnost: zacházet s každou jasně dekódovanou instrukcí, jako
by se o ní nedalo nic vědět. Druhou je přehnaná jistota: proměnit věrohodný
výklad v historický fakt jen proto, že dobře zapadá do okolního kódu.

Tento dodatek obě chyby odděluje. Uvádí, jaký druh důkazů podpírá jednotlivá
důležitá tvrzení, a zaznamenává místa, kde dochovaný program, dochované popisy a
moderní rekonstrukční nástroje neříkají přesně totéž.

## G.1 Třídy důkazů používané v této knize

V následujících tabulkách se používají tato písmena.

| Značka | Třída důkazu | Význam |
|---|---|---|
| **E** | potvrzeno vykonáním | Chování bylo pozorováno v emulátoru nebo procvičeno automatizovaným scénářem vykonání. |
| **S** | staticky doloženo | Tok instrukcí a dat dokládá chování přímo, i když nebyl zapotřebí samostatný runtime test. |
| **I** | odvozeno | Strojové operace jsou známé, ale jejich historický účel, zamýšlené rozhraní nebo význam okrajového případu není zcela prokázán. |
| **D** | nesrovnalost | Kód se liší od dochované dokumentace nebo dvě části implementace viditelně vynucují odlišná pravidla. |
| **R** | specifické pro rekonstrukci | Položka patří modernímu vzkříšení zdroje, testům, labelům, generátorům nebo této knize, nikoli historickému běžícímu binárnímu programu. |

Tyto třídy se mohou překrývat. Chování může být současně **S** i **D**: kód je
jednoznačný a jednoznačně se liší od manuálu. Vygenerovaná tabulka může být
**R**, zatímco přesná shoda jejích emitovaných bajtů s historickou tabulkou je
potvrzena jako **E/S**.

## G.2 Co zde znamená „historické“

Rekonstruovaný zdroj má několik vrstev:

```text
historické bajty strojového kódu
        ↓ dekódované do assembleru
moderní labely a komentáře
        ↓ rozšířené anotacemi
moderní generátory, testy a reporty
        ↓ vysvětlené touto knihou
```

Na původním stroji běžela pouze první vrstva. Významový moderní label, například
`acceptLoadedHeaderIfNameMatchesOrWildcard`, popisuje objevenou roli; není
důkazem, že původní autor používal toto anglické jméno. Stejně tak
`@config-patch` a `@noreloc` jsou moderní anotace zdroje umožňující bezpečné
generování a kontrolu. Instalátor vidí pouze kompaktní proudy bajtů, které z nich
vzniknou.

Když tato kniha říká „PROMETHEUS dělá X“, obvykle tím míní, že historická
sekvence bajtů implementuje X. Když říká „rekonstrukce označuje“, „generátor
kontroluje“ nebo „test prokazuje“, odkazuje na moderní vrstvu.

## G.3 Pevně potvrzená fakta rekonstrukce

Než vypíšeme nejistoty, je užitečné uvést, co v technickém základu v042 nejisté
není.

| Značka | Fakt | Základ |
|---|---|---|
| **E/S** | Sestavený payload CODE je bajt po bajtu shodný s dochovaným historickým payloadem. | Povinné sestavení a binární porovnání. |
| **E/S** | Rekonstruovaný TAP je bajt po bajtu shodný s dochovaným historickým TAPem. | Rekonstrukce bloků TAP, ověření délek a kontrolních součtů a porovnání celého souboru. |
| **E** | Bootstrap odolný vůči relokaci nalezne svou fyzickou adresu načtení a v testovaných rozloženích dojde k instalátoru. | Emulované startovní scénáře. |
| **E** | Kopírování instalátoru funguje pro historické rozložení, nepřekrývající se dopředné kopírování i překrývající se zpětné kopírování. | Emulované scénáře pokrývající všechny tři směry a vztahy rozložení. |
| **S/R** | Vygenerovaný čtrnáctipoložkový konfigurační proud se shoduje s historickým proudem. | Generování řízené labely a následné přesné porovnání bajtů. |
| **S/R** | Vygenerovaná relokační metadata o 1 293 slovech se shodují s historickým proudem. | Analýza na více originech, explicitní výjimky a přesné porovnání. |
| **S** | Volitelný prefix monitoru má přesně 5 000 bajtů a obraz pouze s assemblerem je suffix vybraný jeho přeskočením. | Rozdíl vstupních labelů a instalační korekce `$1388`. |
| **S** | Rezidentní tabulka instrukcí obsahuje 687 pevných pětibajtových záznamů. | Build konstanta, velikost emitovaného include a pevný krok všech konzumentů. |

Shoda bajtů dokazuje zachování historického programu. Nedokazuje, že každé
historické chování bylo rozumné ani že každá věta manuálu byla přesná.

## G.4 Dynamické komentáře toku jsou důkazem, nikoli úplným grafem volání

Starší fáze disassembly obsahovaly komentáře jako:

```text
flow from: ...
ghost flow from: ...
```

Pocházely z execution traces emulátoru. Ukazují, že testovací běh dosáhl daného
místa ze zaznamenaného původu. **Neznamenají**:

- že uvedený původ je jediným možným volajícím;
- že nezaznamenaná cesta nemůže nastat;
- že volání řízené tabulkou nebo samomodifikovaným operandem je staticky nemožné;
- že byly procvičeny všechny podmíněné cesty.

Moderní zdroj odstranil velkou část hlučných adresových a bajtových ocásků z
inline komentářů, ale důkazní význam zůstává důležitý. Dodatek F proto ve svém
kompaktním sloupci volajících používá přímé statické odkazy a výslovně netvrdí,
že jde o úplný dynamický graf volání.

**Klasifikace: E/R.** Traces jsou skutečným pozorovaným důkazem získaným během
rekonstrukce, nejsou však součástí historického binárního programu ani úplným
důkazem chování.

## G.5 Chování wildcardu jména souboru

Dochovaný popis tvrdí, že wildcard LOAD vybere jméno souboru složené výhradně z
mezer. Implementace provádí podivnější test.

Rutina načte **první znak požadovaného jména**, porovná jej s mezerou a tentýž
nezměněný test desetkrát zopakuje. Neposouvá se přes deset znaků jména.

Proto platí:

```text
první znak jména je mezera        wildcard
první znak jména není mezera      přesné desetibajtové porovnání
```

Jméno začínající mezerou je přijato jako wildcard, i když další pozice obsahují
nemezerové bajty. Jméno obsahující mezery až po prvním nemezerovém znaku wildcard
není.

Opakování silně naznačuje zamýšlenou desetiznakovou smyčku, v níž byl vynechán
nebo ztracen posun ukazatele, historický záměr však z bajtů samotných prokázat
nelze. Rekonstrukce zachovává skutečné pravidlo prvního znaku a tiše je
„neopravuje“.

**Klasifikace: S/D; zamýšlená příčina I.**

## G.6 EQU se vyhodnocuje v prvním, nikoli ve druhém průchodu

Jeden dochovaný popis umisťuje vyhodnocení `EQU` do druhého průchodu. Kód
assembleru dokládá opak:

- první průchod si pamatuje položku labelu současného řádku;
- větev EQU tehdy vyhodnotí expression a zapíše hodnotu;
- druhý průchod EQU rozpozná a vrátí se bez dalšího přiřazení.

Má to praktický důsledek. Expression EQU může použít symboly definované dříve v
prvním průchodu nebo zachované jako zamčené symboly. Dopředný symbol, který je
stále nedefinovaný, skončí běžnou cestou chyby Unknown. Ve druhém průchodu už
není příležitost jej dodatečně rozřešit.

Nejde jen o implementační detail. Mění to množinu přijímaných zdrojových
programů.

**Klasifikace: S/D.**

## G.7 Ochrana RUN se provádí až po vykonání instrukce

Trasovaný krok monitoru bývá popisován tak, že odmítne vykonat instrukci, jejíž
výsledné PC leží v oblasti chráněné RUN. Skutečné pořadí je:

```text
připrav scratch instrukci
obnov uživatelský stav
vykonej instrukci
zachyť výsledný stav
zkontroluj výsledné PC proti rozsahům RUN
potvrď nebo odmítni PC a časování
```

Leží-li výsledná adresa v chráněné oblasti, PROMETHEUS ohlásí Run ERROR a
nepotvrdí nové monitorové PC ani vybraný počet T-stavů. Instrukce už však
proběhla. Zápisy do paměti, změny stacku a vedlejší účinky zachycených registrů
mohou již existovat.

Rozdíl je důležitý například u kódu:

```asm
LD (dangerousAddress),A
JP protectedAddress
```

Cíl skoku může být po zachycení odmítnut, ale předchozí účinek trasované
instrukce — pokud jediná instrukce sama zapisuje nebo mění stack — nelze vrátit
pouhým odmítnutím konečného PC.

Rekonstrukce toto slabší pořadí dokumentuje a zachovává bajtově přesně. Jeho
změna by byla funkčním redesignem monitoru.

**Klasifikace: S/D.**

## G.8 Nativní vykonávání obchází ochrany trasování

Několik příkazů monitoru záměrně opouští instruction-by-instruction engine:

- běh k trvalému nebo dočasnému breakpointu;
- nativní CALL přes `SS+H`;
- cíle CALL/RST vykonávané přímo v režimu DEF nebo ALL.

Při nativním vykonávání:

- vlastní okna READ se nekontrolují při každém čtení;
- vlastní okna WRITE se nekontrolují při každém zápisu;
- vlastní okna RUN se nekontrolují při každém cíli instrukce;
- časování T-stavů monitoru nepopisuje vnitřek nativního volání;
- emulace řízení instrukcí nemůže opravit nebo odmítnout každý vnitřní krok.

Při instalaci tříbajtového breakpointu se používá kontrola rezidentního výstupu,
tato jediná kontrola však není ekvivalentem trasování následně běžícího programu.

Nejlépe je tomu rozumět jako záměrnému úniku kvůli rychlosti a kompatibilitě,
nikoli jako jedinému univerzálnímu bezpečnostnímu modelu monitoru. Režim NON
udržuje volání pod monitorovanou simulací. DEF a ALL vyměňují dohled za přímé
vykonávání.

**Klasifikace: S; rozdíl oproti výkladu univerzální ochrany D.**

## G.9 Breakpoint může zůstat nainstalován navždy

Mechanismus dočasného breakpointu uloží přesně tři bajty, zapíše:

```asm
JP breakpointHitCaptureEntry
```

a spustí nativní vykonávání. Původní bajty se obnoví teprve tehdy, když program
dosáhne tohoto patche a vrátí se očekávanou zachycovací cestou.

Jestliže program:

- smyčkuje jinde;
- havaruje;
- skočí do ROM/BASICu a nevrátí se;
- přepíše patch;
- dojde k patchi s nepoužitelným stackem;

PROMETHEUS nemá asynchronní supervisor, který by znovu získal řízení a bajty
obnovil. Vytlačené bajty zůstávají jen v jediném ukládacím slotu.

Patch má vždy tři bajty a nemusí být zarovnán na hranici instrukce. Je bezpečný
pouze tehdy, když uživatel zvolí vhodnou adresu breakpointu.

**Klasifikace: S.** Jde o omezení, nikoli vadu rekonstrukce.

## G.10 Obnova breakpointu obchází kontrolu použitou při jeho instalaci

Instalace breakpointu používá chráněný byte emitter assembleru. Jeho obnova
používá surový tříbajtový `LDIR`.

Tato asymetrie dává v očekávané cestě smysl: monitor vrací bajty, které právě
odebral. Přesto znamená, že obnova není znovu ověřena proti aktuálnímu U-TOP ani
rezidentním hranicím. Kdyby se během nativního běhu poškodilo rozložení paměti
nebo uložená adresa patche, obnovovací kopie jim důvěřuje.

**Klasifikace: S; výklad rizika I.**

## G.11 RETN a RETI jsou spolehlivě modelovány jen částečně

Monitor rozpoznává tok řízení typu RET, RETN a RETI a dokáže získat návratový cíl
uložený na stacku. Po simulovaném návratu také posune uložený uživatelský SP o
dva. Cíl toku řízení a spotřeba stacku jsou tedy explicitní.

Nejistá je přesná sémantika stavu přerušení ve všech okrajových případech. `RETN`
má definovaný vztah mezi IFF2 a IFF1; `RETI` má navíc hardwarový a periferní
význam přesahující „popni PC“. PROMETHEUS rekonstruuje povolení přerušení ze
zachycených flags a svého mechanismu uloženého stavu, dochovaná cesta však
nedovoluje prokázat každou jemnost RETN/RETI jako věrný model všech situací Z80
a periferií.

Bezpečné tvrzení je:

```text
potvrzeno: cíl ze stacku a posun uloženého SP
silně naznačeno: společné zpracování návratovou trampolínou
ne zcela prokázáno: každý okrajový případ IFF1/IFF2 a pozorování RETI periferiemi
```

Proto kniha popisuje RETN/RETI konzervativně a netvrdí, že jde o úplný model
hardwarového debuggeru.

**Klasifikace: S pro cíl/SP; I pro úplnou sémantiku přerušení.**

## G.12 HALT s vypnutými přerušeními je zvláštní i při vypnutých kontrolách

Přepínač instruction controls je uložen obráceně:

```text
nula       kontroly READ/WRITE/RUN zapnuté
nenula     tyto konfigurovatelné kontroly vypnuté
```

Odmítnutí HALT při vypnutých přerušeních leží mimo tento přepínač. Vypnutí
kontrol tedy neznamená „vykonej naprosto cokoli“. Monitor se stále vyhne scratch
HALT, který by mohl zastavit navždy bez přerušení schopného jej uvolnit.

Jednoduchý status typu „controls off“ může tuto výjimku skrývat.

**Klasifikace: S.**

## G.13 MOVE, FILL, LOAD, SAVE a výpisové příkazy nesdílejí jeden zákon ochrany

Je lákavé představovat si pět oken READ/WRITE/RUN jako globální firewall paměti.
Nejsou jím.

| Operace | Skutečně použitá ochrana |
|---|---|
| trasovaná uživatelská instrukce | konfigurovatelné kontroly READ, WRITE a výsledného RUN, nejsou-li controls vypnuté |
| monitorové MOVE | kontrola rezidentního cíle a zdroje; žádná kontrola vlastního okna WRITE |
| monitorové FILL | kontrola rezidentního cíle a zdroje; žádná kontrola vlastního okna WRITE |
| monitorové načtení J | kontrola obrácení/wrapu a rezidentního cíle/zdroje; žádná kontrola vlastního okna WRITE |
| monitorové uložení S | žádná rezidentní kontrola ani kontrola vlastního okna READ |
| paměťový výpis L | přímé čtení; žádná kontrola konfigurovatelného okna READ |
| znakový výpis O | přímé čtení; žádná kontrola konfigurovatelného okna READ |
| maskovaný FIND G/N | přímé čtení; žádná kontrola konfigurovatelného okna READ |
| nativní breakpoint/CALL | žádné kontroly vlastních READ/WRITE/RUN pro každou instrukci |

Rozdíly mohou představovat záměrné oddělení „nedůvěryhodného kódu pod trasováním“
a „důvěryhodných příkazů výslovně vyžádaných operátorem“. Mohou také být
výsledkem organického vývoje. Pevně lze tvrdit, že neexistuje jediná vynucovací
brána pokrývající všechny paměťové operace.

**Klasifikace: S; celkový návrhový záměr I.**

## G.14 Monitorové SAVE přijímá obrácené a wrapující rozsahy

Příkaz S počítá:

```text
délka = Last - First + 1      modulo 65536
```

Neodmítá `Last < First`, nekonzultuje rezidentní ochranu a nezabraňuje nulovému
výsledku po wrapu. Výsledná šestnáctibitová délka je předána kazetové cestě.

J, MOVE a FILL provádějí silnější kontroly cíle nebo rozsahu, takže chování SAVE
nelze zobecnit na všechny blokové příkazy.

Mohlo to být přijato proto, že SAVE paměť pouze čte, nebo proto, že se očekávalo,
že okrajové chování určí ROM rutina. Kód sám neříká, které zdůvodnění autor
zamýšlel.

**Klasifikace: S; zdůvodnění I.**

## G.15 Monitorové J nemá smysluplný režim jména souboru

Společný prompt hodnot monitoru může vrátit buď:

- vyhodnocený číselný expression;
- nebo řetězcovou formu začínající dvojtečkou.

S interpretuje dvojtečkovou formu jako jméno souboru a sestaví standardní hlavičku
CODE. J nikoli. Jeho handler zachází s výsledným dolním bajtem jako s očekávaným
leaderem. Pozdější rychlá reference naznačující symetrický filename režim LOAD
tedy popisuje možnost, kterou cesta J neimplementuje.

Pro J používejte číselný leader. Pro načtení řízené hlavičkou použijte Y a po
zobrazení hlavičky stiskněte J.

**Klasifikace: S/D.**

## G.16 Y přijme libovolnou platnou standardní hlavičku a potom nabídne J

Y čte blok velikosti hlavičky s očekávaným flagem `$00`. Je-li tento fyzický blok
platnou hlavičkou Spectra, monitor zobrazí její pole. Následné stisknutí J použije:

```text
First  = parametr 1 hlavičky
Length = délka dat z hlavičky
Leader = $FF
```

Navazující cesta nejprve nevyžaduje, aby type byte hlavičky znamenal CODE. Použije
interpretaci podobnou CODE na libovolnou platnou standardní hlavičku. U hlavičky
BASICu, číselného pole nebo znakového pole má parametr 1 jiný dokumentovaný
význam, PROMETHEUS jej přesto může použít jako cílovou adresu.

Rozhraní je tedy nízkoúrovňovým inspektorem hlaviček s volitelným raw pokračováním,
nikoli type-safe loaderem souborů Spectra.

**Klasifikace: S; nesrovnalost s očekáváním uživatelského rozhraní D.**

## G.17 Obrácené disassemblování ponechá změněné zobrazování číselných adres

`SS+D` vybere sink vkládající zdroj a vypne číselné prefixy adres, aby generovaný
zdroj nezačínal monitorovými adresami. Příkaz tento flag následně neobnoví. Další
interaktivní disassembly tedy začíná se skrytými číselnými adresami, dokud je
uživatel znovu nezapne klávesou C.

Jde o malý trvalý vedlejší účinek, který by mohl být mylně považován za chybu
moderní rekonstrukce. Nachází se v historickém toku bajtů.

**Klasifikace: S.**

## G.18 Rozsahy zobrazení DEFB a DEFW klasifikují pouze počáteční adresu

Disassembly tabulka 1 a tabulka 2 označují oblasti, které se mají zobrazit jako
bajtová nebo slovní data. Klasifikační test používá počáteční adresu současné
položky. Nerozdělí vícebajtovou dekódovanou jednotku, když hranice rozsahu padne
dovnitř.

Například adresa klasifikovaná DEFW na posledním bajtu oblasti může vyvolat
dvoubajtové zobrazení slova, jehož druhý bajt leží mimo nominální rozsah. Stejně
tak se instrukce začínající mimo datový rozsah zpětně nerozdělí jen proto, že
uvnitř leží její operandový bajt.

Dekodér tak zůstává jednoduchý a deterministický. Tabulka rozsahů má být
zarovnána na zamýšlené hranice položek.

**Klasifikace: S.**

## G.19 Maskované hledání paměti nemá konec a wrapuje na `$FFFF`

G ukládá pět dvojic hodnota/maska. N pokračuje od uložené skenovací adresy.
Ukazatel kandidáta je šestnáctibitový a jednoduše se inkrementuje. Neexistuje
prompt Last ani stav „prohledána celá paměť“.

Důsledky:

- skenování může přejít z `$FFFF` na `$0000`;
- pětibajtové porovnání blízko horní hranice může samo wrapovat;
- chybějící vzor vede k nekonečně pokračujícímu hledání, nikoli ke konečnému
  výsledku not found;
- opakované N může po úplném oběhu adresního prostoru znovu najít tentýž vzor.

Jde o přesný důsledek kompaktní smyčky, nikoli slib, že wraparound byl záměrně
inzerovanou funkcí.

**Klasifikace: S; záměr I.**

## G.20 Skenování konce GENS může wrapovat při U-TOP `$FFFF`

Importer GENS/MASM hledá koncovou hranici cizího zdroje skenováním paměti. Sám
manuál varuje, že při U-TOP nastaveném na `$FFFF` může skenování wrapovat přes
šestnáctibitový adresní prostor, není-li nalezena očekávaná koncová podmínka.

To je jeden z důvodů, proč je zdánlivě pohodlné `U-TOP -1` nutné používat
opatrně. Odstraňuje přirozenou konečnou horní hranici, která by jinak zastavila
několik operací růstu paměti nebo skenování.

**Klasifikace: S/D pouze tam, kde uživatel očekává, že `$FFFF` je univerzálně
bezpečné nastavení „celá paměť“.**

## G.21 LOAD a GENS nejsou transakční

Moderní importer by mohl nejprve ověřit celý soubor a potom jej atomicky potvrdit.
PROMETHEUS pracuje s malým paměťovým rozpočtem a data transformuje už při
příchodu.

Nativní cesta LOAD už mohla přijmout a připravit část přenosu zdroje nebo symbolů,
než nastane pozdější chyba kazety. GENS rozbaluje a vkládá řádky postupně. Chyba
syntaxe, kapacity, kazety nebo koncové hranice proto může ponechat dřívější
materiál v paměti.

Program nabízí zotavení a chybové zprávy, ale nikoli rollback k přesnému obrazu
paměti před příkazem.

**Klasifikace: S.**

## G.22 VERIFY závisí na uchovaném stavu SAVE

VERIFY nerekonstruuje všechny parametry kazety z čerstvého příkazového řádku.
Znovu používá jméno souboru, délku zdroje a stav pomocného segmentu nastavený
předchozí cestou SAVE.

Zamýšlenou dvojicí je tedy `SAVE` následované bezprostředně `VERIFY`. Mezilehlé
operace, které znovu použijí příslušné samomodifikované operandy, mohou způsobit,
že pozdější VERIFY popíše něco jiného, než uživatel očekává.

Rozhraní je kompaktní a historicky pochopitelné, ale stavovější, než naznačuje
samotné slovo VERIFY.

**Klasifikace: S.**

## G.23 DEFS přijímá společný tvar naparsovaného seznamu

Dokumentace obvykle popisuje DEFS s jediným expressionem velikosti. Kód k němu
dochází přes společný mechanismus datových seznamů pseudo-instrukcí. Přijímaný
zakódovaný tvar proto může zpracovat seznamovou strukturu vytvořenou parserem,
namísto aby u samostatné vstupní brány vynucoval jedinečnou gramatiku jednoho
expressionu.

Bezpečná uživatelská forma zůstává:

```asm
DEFS size
```

Exotičtější použití oddělené čárkami je třeba považovat za chování implementace,
nikoli za přenositelnou záruku zdrojového jazyka.

**Klasifikace: S pro implementaci; historický záměr jazyka I.**

## G.24 Formy uvozovek DEFM jsou asymetrické

Dva oddělovače řetězce nejsou zaměnitelnou dekorací.

- dvojité uvozovky emitují obyčejné znakové bajty;
- apostrofová forma nastaví bit 7 posledního emitovaného znaku.

Je to užitečné pro řetězce s vysokým bitem ve stylu PROMETHEA, ale překvapivé pro
čtenáře, který očekává, že oba oddělovače vytvoří stejný literál. Parser má také
historické chování zdvojených oddělovačů patřící tomuto kompaktnímu assembleru,
nikoli obecnému modernímu standardu řetězců.

**Klasifikace: S.**

## G.25 Validace instalační adresy je minimální

Instalátor omezuje viditelné pole na pět desetinných číslic a brání kurzoru
překročit jeho oddělovače. Po ENTER číslice naparsuje, vybere úplný nebo suffixový
obraz, zvolí směr kopírování, zapíše konfiguraci, aplikuje relokaci a předá
řízení.

Neprovádí úplný moderní preflight dokazující, že:

- zvolený obraz se celý vejde do bezpečné RAM;
- cíl ve špatný okamžik nepřepíše obrazovku, systémové proměnné nebo potřebný
  stack;
- konečný workspace zdroje a symbolů bude mít užitečnou velikost;
- každá uživatelem zvolená adresa je provozně rozumná.

Samotný kopírovací engine zpracovává překryv správně, včetně kopírování zpět. To
není totéž jako ověřit rozumnost požadovaného cíle.

**Klasifikace: S; historický model odpovědnosti uživatele I.**

## G.26 Historické aliasy nejsou důkazem veřejných příkazů

Vektory příkazů obsahují duplicitní cíle:

- sloty G, I a J spojené s GENS/importem;
- sloty N a O spojené s NEW;
- sloty X a Y spojené s CLEAR;
- duplicitní cíle vektoru názvů pro některá příkazová slova.

Identita tabulky je jistá. Nedokazuje, že každý alias byl dosažitelný běžnou
tokenizací, vytištěný v každém manuálu nebo zamýšlený jako samostatná veřejná
funkce. Některé mohou být pozůstatky kompatibility, zkratky pro rozložení
klávesnice, nepoužité ordinalové sloty nebo historické úpravy.

Dodatek E je uvádí jako aliasy, ale pro běžné použití vyhrazuje dokumentovaný
název příkazu.

**Klasifikace: S pro identitu tabulky; I pro veřejnou dosažitelnost a záměr.**

## G.27 Neprůhledné bajty v oblasti interního stacku

Malá oblast tvořící podklad interního stacku obsahuje historické nenulové bajty,
které vypadají jako starý obsah stacku, data nebo nevyužitý zbytek. Jsou
zachovány, protože přesná shoda bajtů to vyžaduje a živý stack může oblast za běhu
přepsat.

Těmto bajtům nelze vymýšlet sebejistou sémantickou strukturu jen proto, že každý
bajt v binárním programu svádí k pojmenování. Jejich doložená role je:

```text
počáteční obsah úložiště později dostupného internímu stacku
```

Cokoli konkrétnějšího je provizorní, dokud to neprokáže vykonání nebo jiný
dochovaný zdroj.

**Klasifikace: S pro umístění a zachování; I pro význam původního obsahu.**

## G.28 Původní tabulky versus moderní generátory

Historický program obsahuje kompaktní runtime tabulky:

- delty konfiguračních patchů;
- relokační proudy;
- deskriptory instrukcí;
- vektory příkazů a textů.

Rekonstrukce přidává build-time generátory pro první dvě obtížné třídy. Mění se
tím vlastnictví zdroje, nikoli runtime reprezentace.

### Historický runtime mechanismus

Instalátor prochází malé delty a počty relokací. Nemá názvy symbolů, JSON,
Python objekty ani linker mapu. Provádí stejnou kompaktní aritmetiku, která běžela
historicky.

### Moderní mechanismus generování

Zdroj označuje sémantické cíle a výjimky. Generátor sestaví nebo analyzuje sondy
na více než jednom originu, určí, která slova se skutečně pohybují s rezidentním
obrazem, vytvoří historický kompaktní proud a odmítne nejednoznačné nebo
nebezpečné případy.

### Požadavek shody

Pro základ v042 se vygenerované bajty porovnávají s dochovanými historickými
bajty. Generátor nesmí vytvořit pouze ekvivalentní, ale jinak zakódovaný proud,
pokud release tvrdí historickou identitu.

Tedy:

```text
generátor a anotace           specifické pro rekonstrukci
kompaktní bajty ve výsledku   historické a bajtově shodné
dekodér instalátoru           historický
```

**Klasifikace: R pro způsob výroby; E/S pro shodu bajtů a runtime použití.**

## G.29 Labely konfiguračních patchů jsou moderní názvy historických cílů

Labely jako `configurationPatchTarget05...` explicitně pojmenovávají čtrnáct
rozptýlených cílů zápisu. Historický instalátor tyto bajty navštěvoval už dříve
procházením proudu signed delt. Labely nepřidaly nový patch; daly starému cíli
stabilní sémantické jméno.

Stejný rozdíl platí pro relokační výjimky. `@noreloc` zaznamenává, proč se slovo,
které vypadá jako adresa, nesmí posouvat. Původní binární program tuto skutečnost
vyjadřoval pouze vynecháním slova z relokačního proudu.

**Klasifikace: R pro anotaci; S pro základní historické chování.**

## G.30 Analýza na více originech je důkazní technika, nikoli historický nástroj

Z jediného sestaveného obrazu nelze vždy poznat, zda je slovo:

- relokovatelnou rezidentní adresou;
- adresou ROM Spectra;
- adresou obrazovky;
- konstantou, jejíž číselná hodnota náhodou připomíná adresu;
- offsetem pro origin nula, který je záměrně interpretován později.

Moderní generátor linkuje nebo analyzuje payload na více originech a porovnává
kandidátní slova. Slova posouvající se přesně o deltu originu jsou silnými
kandidáty relokace; explicitní sémantické výjimky řeší zbylé nejednoznačné
případy.

Program z roku 1990 tento experiment na Spectru neprováděl. Jde o clean-room
ověřovací metodu použitou k opětovnému objevení a ochraně jeho relokační množiny.

**Klasifikace: R.**

## G.31 Emulované startovní scénáře jsou moderní testy

Historický TAP obsahuje jednu běžnou instalační zkušenost. Rekonstrukce navíc
procvičuje umělá rozložení zvolená tak, aby vynutila:

- žádný škodlivý překryv;
- dopředné kopírování;
- zpětné kopírování.

Tyto scénáře ověřují větve, které nemusí být dosaženy nejběžnější adresou
načtení. Neznamenají, že přesně tato syntetická rozložení byla distribuována jako
samostatné historické produkty.

**Klasifikace: R pro scénáře; E pro jimi vykonané cesty kódu.**

## G.32 Labely zdroje, seskupení lokálních labelů a próza jsou výkladem

Rekonstrukce nahradila labely ve tvaru adres názvy jako
`moveMemoryBlockOverlapSafe` a vhodné soukromé cíle skoků převedla na lokální
labely s prefixem tečky. Tyto změny zachovávají bajty, ale přidávají výkladový
model.

Dobrý label je vyvratitelné tvrzení: volající, vstupy, výstupy a vedlejší účinky
jej mají podporovat. Stále nejde o původní identifikátor. Budoucí důkaz může
oprávnit přejmenování rutiny, aniž se změní historický program.

Stejná opatrnost platí pro hranice kapitol. PROMETHEUS neobsahuje runtime objekt
nazvaný „pipeline editoru“ nebo „atlas zdroje“. Jde o výukové struktury vložené
do propojeného assemblerového kódu.

**Klasifikace: R.**

## G.33 Komentáře „flow from“ nejsou chybějícími odkazy zdroje

Protože komentáře toku zaznamenávají pozorované příchody v emulátoru, odstranění
jejich hlučné inline podoby nemaže spustitelné hrany. Statické labely, odkazy v
operandech, dispatch tabulky a testy zůstávají. Naopak zachování jednoho komentáře
z něj nedělá úplný seznam volajících.

Když dodatek F uvádí „hlavní volající nebo konzumenty“, používá přímé statické
odkazy a seskupuje lokální tok pod globální rutinu. Je to jiný nástroj než
historické trace komentáře.

**Klasifikace: metodická poznámka R.**

## G.34 Překlad manuálu a terminologie

Dochovaná dokumentace může existovat v češtině, anglickém překladu nebo pozdější
rychlé referenci. Některé termíny mají více rozumných anglických převodů:

- „installation“ versus „relocation“ pro uživatelem zvolenou rezidentní adresu;
- „leader“ versus „flag“ pro první bajt kazetového bloku;
- „window“, „area“ nebo „range“ pro ochranné intervaly;
- „assembly“ jako příkaz, proces nebo vzniklý produkt;
- „monitor“ jako volitelný rezidentní prefix i interaktivní nástroj.

Tato kniha používá konzistentní technickou angličtinu založenou na chování.
Volba formulace není důkazem, že původní autor používal stejnou pojmovou hranici.

**Klasifikace: I/R.**

## G.35 Zdánlivé překlepy a zvláštnosti rozhraní zachované v obrazu

Některé viditelné řetězce a konvence vypadají modernímu čtenáři neobvykle:

- `Instalation address:` obsahuje historický pravopis;
- titul instalátoru a copyrightové řetězce používají kompaktní ukončení vysokým bitem;
- názvy stavů mohou být zkráceny, aby se vešly do pevných buněk panelu;
- aliasy příkazů a duplicitní vektory jsou zachovány;
- smyčka wildcardu jména opakuje jeden bajt desetkrát;
- počáteční podklad interního stacku obsahuje neprůhledné nenulové bajty.

Rekonstrukce „nečistí“ emitovaný text ani zdánlivě nepoužitá data, pokud by tím
změnila historický payload. Kniha může obecné anglické slovo psát správně, ale na
příslušných místech přesně cituje obrazovku.

**Klasifikace: S pro bajty; záměr se liší případ od případu.**

## G.36 Chyby, zvláštnosti a záměrné úspory

Slovo *bug* je třeba používat opatrně. Užitečné jsou tři kategorie:

### Potvrzená nesrovnalost

Implementace odporuje uvedenému pravidlu nebo zjevně neprovádí smyčku, kterou
její struktura oznamuje. Patří sem wildcard jména a kontrola RUN po vykonání.

### Konzistentní, ale překvapivá implementace

Kód se chová pravidelně, jen ne jako moderní rozhraní. Patří sem stavové VERIFY,
netransakční import a neomezené wrapující hledání v paměti.

### Úspora s obálkou rizika

Chování je kompaktním návrhem, který vyžaduje, aby operátor respektoval jeho
kontrakt. Patří sem tříbajtové breakpointy, minimální validace instalátoru,
samomodifikované operandy a nativní režim ALL.

Nazývat každou překvapivou úsporu chybou zakrývá návrhová omezení. Odmítat
pojmenovat jasné nesrovnalosti zakrývá stejně důležitý důkaz.

## G.37 Souhrnný přehled

| Téma | Třída | Bezpečné tvrzení |
|---|---|---|
| identita historického binárního programu/TAPu | **E/S** | v042 přesně reprodukuje dochovaný payload i TAP. |
| komentáře flow-from | **E/R** | pozorované původy v testech, nikoli úplný graf volajících. |
| wildcard jména souboru | **S/D** | mezera v prvním znaku znamená wildcard; test všech deseti mezer implementován není. |
| průchod EQU | **S/D** | EQU se přiřazuje v prvním průchodu. |
| pořadí ochrany RUN | **S/D** | výsledné PC se kontroluje po vykonání a zachycení; vedlejší účinky mohou zůstat. |
| nativní breakpoint/CALL režimy | **S** | obcházejí vlastní ochrany po instrukcích a časování. |
| nedosažený breakpoint | **S** | původní tři bajty se automaticky neobnoví. |
| RETN/RETI | **S/I** | cíl a oprava SP jsou jasné; úplná věrnost přerušení a periferií není plně prokázána. |
| controls OFF | **S** | konfigurovatelné kontroly READ/WRITE/RUN jsou vypnuté; riziko DI+HALT se stále odmítá. |
| MOVE/FILL/J versus okna WRITE | **S** | používají kontroly rezidentního cíle, nikoli vlastní rozsahy WRITE. |
| L/O/G versus okna READ | **S** | přímé inspekční čtení obchází vlastní rozsahy READ. |
| rozsah monitorového SAVE | **S** | obrácené a wrapující rozsahy se předají dál s aritmetikou délky modulo 16 bitů. |
| filename forma J | **S/D** | neexistuje smysluplná větev jména; pouze číselný leader. |
| pokračování hlavičky Y | **S** | libovolnou platnou hlavičku lze interpretovat přes parametr 1 a délku. |
| flag zobrazení po obráceném disassembly | **S** | potlačení číselných adres zůstává aktivní. |
| rozsahy zobrazení dat | **S** | klasifikace používá pouze počáteční adresu. |
| maskované hledání | **S/I** | nemá koncovou adresu; skenování i porovnání mohou wrapovat. |
| GENS s U-TOP `$FFFF` | **S** | skenování konce může wrapovat, není-li nalezen terminátor nebo hranice. |
| rollback LOAD/GENS | **S** | po selhání může zůstat částečně potvrzený import. |
| VERIFY | **S** | závisí na uchovaném stavu SAVE. |
| seznamová forma DEFS | **S/I** | společný tvar parseru je přijímán; přenositelná je forma s jedním expressionem. |
| validace instalátoru | **S/I** | pole je omezené, bezpečnost cíle zůstává z velké části odpovědností uživatele. |
| duplicitní sloty příkazů | **S/I** | stejné cíle tabulky nedokazují, že každý alias byl veřejný. |
| generované patch/relokační tabulky | **R + E/S** | moderní výroba, historický proud bajtů a historický runtime dekodér. |
| labely a struktura prózy | **R** | moderní vysvětlující názvy, nikoli obnovené původní identifikátory. |

## G.38 Pravidlo pro budoucí revize

Objeví-li se nový důkaz, aktualizujte klasifikaci dříve, než zesílíte formulaci.

```text
nové pozorování v emulátoru     může pro testovanou cestu povýšit I na E
nový statický důkaz             může povýšit I na S
nová stránka manuálu            může odhalit nebo vytvořit D
nový build generátor            zůstává R, i když je výstup historický
nový label nebo znění kapitoly  zůstává R, dokud je nepotvrdí historický zdroj
```

Cílem není udržovat knihu váhavou. Cílem je přesně uvádět, odkud její jistota
pochází. PROMETHEUS je dost působivý sám o sobě; není třeba měnit každý rozumný
odhad v legendu.
