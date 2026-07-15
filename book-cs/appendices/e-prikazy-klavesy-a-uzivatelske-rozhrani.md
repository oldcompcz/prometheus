# Dodatek E: Reference příkazů, kláves a uživatelského rozhraní

Tento dodatek je rychlou referenční částí knihy. Popisuje, co může člověk napsat
nebo stisknout, aniž si musí pamatovat vnitřní cestu, kterou příkaz prochází.

PROMETHEUS má tři příbuzná rozhraní:

```text
instalátor                volba způsobu a místa instalace PROMETHEA
editor a assembler        vstup zdroje, správa symbolů, sestavení a ukládání
monitor                   prohlížení, změny a vykonávání strojového kódu
```

Stejná fyzická klávesa Spectra může mít v každém rozhraní jiný význam. Následující
tabulky proto vždy uvádějí současné rozhraní.

## E.1 Názvy používané pro shift klávesy Spectra

Spectrum má dvě shift klávesy:

- **CAPS SHIFT**, zkráceně `CS`;
- **SYMBOL SHIFT**, zkráceně `SS`.

Zápis `SS+W` znamená držet SYMBOL SHIFT a stisknout W. `CS+1` znamená kombinaci
EDIT Spectra. Pojmenované klávesy jako `ENTER`, `SPACE`, `DELETE` a čtyři
cursorové klávesy odkazují na jejich běžný význam ve Spectru.

PROMETHEUS klávesy před dispatch normalizuje. Některé komentáře ve zdroji a
interní tabulky proto obsahují hodnoty jako `$14` nebo `$3E`. Nejsou to znaky,
které se mají napsat; jsou to kompaktní interní kódy kláves programu.

## E.2 Obrazovka editoru a režimy

Hlavní obrazovka editoru obsahuje výpis zdroje, jeden zvýrazněný access line,
editovatelný vstupní řádek a stavový pruh. Access line určuje, který
komprimovaný zdrojový záznam je současný. Vstupní řádek je samostatná pracovní
kopie.

K dispozici jsou dvě politiky vkládání:

| Režim | Význam |
|---|---|
| INSERT | Odevzdání řádku vloží nový zdrojový záznam před aktivní pozici. |
| OVERWRITE | Odevzdání řádku nahradí aktivní zdrojový záznam. |

`SS+W` politiku přepíná. `CS+1` načte aktivní zdrojový řádek do vstupního bufferu
a vynutí, aby následující odevzdání tento řádek přepsalo.

Zobrazení čísel je také sdílené mezi editorem a monitorem:

| Režim | Typické zobrazení |
|---|---|
| decimal | `32768` |
| hexadecimal | `#8000` |

Příkaz editoru `H` a `SS+3` v monitoru tento režim přepínají.

## E.3 Okamžité klávesy editoru

Tyto klávesy pracují, aniž se nejprve stanou textovým příkazem.

| Klávesa | Akce |
|---|---|
| obyčejný tisknutelný znak | Vloží nebo přepíše znak na cursoru vstupu. |
| `ENTER` | Odešle vstupní řádek. Příkaz se dispatchuje; assemblerový řádek se zakóduje a vloží nebo přepíše. |
| `CS+5` / cursor vlevo | Posune cursor vstupu o jeden znak vlevo. |
| `CS+8` / cursor vpravo | Posune cursor vstupu o jeden znak vpravo. |
| `CS+0` / DELETE | Smaže znak bezprostředně před cursorem vstupu. |
| `CS+2` / CAPS LOCK | Přepne input case lock editoru. |
| `SPACE` | Vloží mezeru a tam, kde je to vhodné, automaticky přejde do dalšího pole zdroje. |
| `SS+O` | Vloží marker komentáře středníkem. |
| `SS+Q` | Opustí současný vstupní řádek a vrátí normální teplé zobrazení editoru. |
| `CS+1` / EDIT | Expanduje aktivní komprimovaný zdrojový záznam do vstupního řádku a zvolí overwrite mode. |
| `SS+W` | Přepne INSERT a OVERWRITE. |
| `CS+6` / cursor dolů | Zvolí další zdrojový záznam. |
| `CS+7` / cursor nahoru | Zvolí předchozí zdrojový záznam. |
| `CS+3` / TRUE VIDEO | Posune se o jednu stránku, dvacet zdrojových záznamů, dopředu. |
| `CS+4` / INVERSE VIDEO | Posune se o jednu stránku, dvacet zdrojových záznamů, dozadu. |
| `CS+9` | Smaže aktivní zdrojový řádek a zvolí předchozí řádek. |
| `CS+SS` | Nastaví nebo přesune jednu hranici vybraného bloku zdroje. |

Obě hranice bloku lze označit v libovolném pořadí. COPY, DELETE, PRINT, blokový
FIND a blokový SAVE je před použitím normalizují na dolní a horní adresu
zdrojového záznamu.

## E.4 Abeceda příkazů editoru

Příkaz se obvykle zadává tak, že prázdný vstupní řádek začne SYMBOL SHIFTem a
písmenem. Tokenizer převede příkazové slovo na jeden bajt v rozsahu `$C1` až
`$DA`; tabulka handlerů je uspořádána abecedně.

Následující tabulka uvádí potvrzené veřejné významy a také historické aliasové
sloty, které zůstávají v binárním obrazu.

| Písmeno | Příkaz | Účel |
|---|---|---|
| A | `ASSEMBLY` | Sestaví současný zdroj. |
| B | `BASIC` | Opustí PROMETHEA a vrátí se do BASICu Spectra. |
| C | `COPY` | Zkopíruje vybraný blok zdroje před aktivní cílový řádek. |
| D | `DELETE` | Smaže vybraný blok zdroje. |
| E | end | Zvolí poslední skutečný zdrojový záznam. |
| F | `FIND` | Hledá text ve zdroji s trvalým textem, rozsahem a stavem pokračování. |
| G | `GENS` | Importuje zdroj v podporované kazetové reprezentaci GENS/MASM. |
| H | přepnutí číselné báze | Přepne decimal a hexadecimal zobrazení. |
| I | historický alias GENS | Dispatchuje do cesty importu GENS; běžná dosažitelnost se nesmí usuzovat jen z položky tabulky. |
| J | historický alias GENS | Dispatchuje do cesty importu GENS; platí stejná opatrnost jako u I. |
| K | začátek zdroje | Zvolí první pozici zdroje. |
| L | `LOAD` | Načte soubor zdroje a symbolů PROMETHEA. |
| M | `MONITOR` | Vstoupí do rezidentního monitoru strojového kódu. |
| N | cesta `NEW` | Vstoupí do cesty ROM NEW Spectra. |
| O | historický alias NEW | Sdílí stejný handler jako N. |
| P | `PRINT` | Vytiskne zdroj, případně omezený na vybraný blok. |
| Q | `QUIT` | Opustí aktivní operaci přes quit path PROMETHEA. |
| R | `RUN` | Sestaví a spustí od adresy zvolené pomocí `ENT`. |
| S | `SAVE` | Uloží zdroj a symboly, celé nebo vybrané. |
| T | `TABLE` | Zobrazí nebo spravuje tabulku symbolů. |
| U | `U-TOP` | Nastaví nejvyšší adresu dostupnou zdroji, symbolům a generovanému výstupu. |
| V | `VERIFY` | Ověří blok popsaný stavem bezprostředně předchozího SAVE. |
| W | přepnutí režimu | Přepne INSERT a OVERWRITE; ekvivalent okamžité akce `SS+W`. |
| X | `CLEAR` | Vymaže workspace zdroje. |
| Y | historický alias CLEAR | Sdílí handler CLEAR. |
| Z | `REPLACE` | Nahrazuje shodný text na vybraných zdrojových řádcích a znovu používá stav FIND. |

Duplicitní položky jsou historickými fakty o dispatch tabulce. Nejsou důkazem,
že byl každý alias propagován nebo pohodlně zadatelný v každé dochované edici.

## E.5 Příkazy navigace zdrojem a editace

### Začátek a konec

| Akce | Vstup |
|---|---|
| přejít na první pozici zdroje | `K` |
| přejít na poslední skutečný řádek zdroje | `E` |
| předchozí/další řádek | cursor nahoru/dolů |
| předchozí/další stránka | `CS+4` / `CS+3` |

Příkaz konce nejprve získá sentinel konce zdroje a potom ustoupí na poslední
skutečný záznam. Samotný sentinel se jako assemblerový řádek nezobrazuje.

### Copy

`COPY` zduplikuje úplný komprimovaný bajtový rozsah od prvního vybraného záznamu
po druhý a vloží jej před aktivní řádek. Cíl nesmí ležet uvnitř vybraného
rozsahu.

Typické použití:

```text
1. označte jednu hranici pomocí CS+SS
2. přesuňte se na druhý konec
3. označte druhou hranici pomocí CS+SS
4. přesuňte se na místo vložení
5. zadejte COPY
```

Původní záznamy zůstanou. Nová kopie se automaticky nestane vybraným blokem.

### Delete

`DELETE` odstraní celý vybraný blok. Liší se od `CS+9`, které odstraní pouze
aktivní řádek.

### Clear

`CLEAR` odstraní současný workspace zdroje a znovu vytvoří prázdné uspořádání
zdroje a symbolů. Protože X a Y sdílejí handler, staré materiály mohou pro tuto
operaci uvádět více než jednu klávesu.

## E.6 Tvary FIND a REPLACE

FIND si pamatuje tři věci: text, scope a poslední pozici scan. Samotný FIND je
proto pokračovacím příkazem, nikoli neúplným příkazem.

| Tvar | Význam |
|---|---|
| `FIND s:text` | Uloží `text`; hledá celý zdroj od začátku. |
| `FIND b:text` | Uloží `text`; hledá vybraný blok od jeho začátku. |
| `FIND :text` | Uloží nový text; začne na současné pozici a zachová předchozí scope. |
| `FIND` | Znovu použije uložený text a scope a pokračuje za předchozím kandidátem. |

Porovnání nerozlišuje velikost písmen a pracuje s expandovaným viditelným
zdrojem, nikoli přímo s komprimovanými bajty.

REPLACE ukládá druhý trvalý řetězec. Operace náhrady expanduje aktivní záznam,
provede nepřekrývající se textové náhrady a odevzdá znovu sestavený řádek běžné
overwrite cestě. Komprimované zdrojové bajty neopravuje na místě.

Praktický rytmus je:

```text
FIND       prohlédni další odpovídající řádek
REPLACE    nahraď shody na tomto řádku a pokračuj
FIND       přeskoč řádek beze změny
REPLACE    přijmi další náhradu
```

Náhrada nesmí vytvořit řádek editoru delší než běžná kapacita vstupu 31 znaků.

## E.7 PRINT

| Tvar | Význam |
|---|---|
| `PRINT` | Vytiskne všechny expandované zdrojové záznamy od začátku. |
| `PRINT b` | Vytiskne pouze vybraný blok. |

PRINT používá kanál Spectra spojený s výstupem tiskárny. Každý komprimovaný
záznam expanduje stejným kanonickým expanderem jako editor, takže tiskárna
obdrží běžný čitelný zdroj, nikoli tokenové bajty a odkazy ordinalů.

## E.8 ASSEMBLY, RUN a BASIC

| Příkaz | Výsledek |
|---|---|
| `ASSEMBLY` | Provede první a druhý průchod a ponechá generovaný kód ve zvolené výstupní oblasti. |
| `RUN` | Sestaví a potom předá řízení na adresu nastavenou pomocí `ENT`. |
| `BASIC` | Vrátí se do BASICu Spectra. |
| `MONITOR` | Vstoupí do rezidentního monitoru, byla-li nainstalována edice s monitorem. |

Diagnostika sestavení se hlásí vůči zdrojovému záznamu, který ji způsobil. První
průchod určuje symboly a délky. Druhý průchod emituje bajty. Zdroj může pomocí
`ORG` a `PUT` oddělit logické adresy od fyzických výstupních adres.

## E.9 U-TOP

Za `U-TOP` následuje obyčejný expression PROMETHEA:

```text
U-TOP #BFFF
U-TOP 49151
U-TOP -1
```

Výsledná šestnáctibitová hodnota se stane nejvyšší adresou uživatelské paměti,
kterou přijmou kontroly prostoru zdroje, symbolů a výstupu. `U-TOP -1` se
přirozeně zalomí na `$FFFF`. Neopatrná hodnota může odstranit ochranu paměti,
kterou aplikace sama potřebuje; příkaz předpokládá informovaného uživatele
strojového kódu.

## E.10 Příkazy tabulky symbolů

Rodina TABLE pracuje s ordinal vectorem a abecedně seřazenými záznamy symbolů
popsanými v kapitolách 23 a 24.

| Tvar | Akce |
|---|---|
| `TABLE` | Zobrazí tabulku symbolů. |
| `TABLE P` | Použije tiskovou formu tabulky podporovanou parserem příkazů. |
| `TABLE L` | Zamkne každý současný symbol proti odstranění pomocí TABLE C. |
| `TABLE U` | Odemkne současné symboly. |
| `TABLE C` | Sesbírá nepoužívané symboly, zkomprimuje záznamy a vektory a přepíše ordinaly ve zdroji. |

Vektor má LOCK bit a stavový bit. Během běžného sestavení stavový bit označuje
definici. Během TABLE C se dočasně znovu používá jako reachability mark. Symbol
přežije collection, když je zamčený nebo odkazovaný zachovaným zdrojem.

TABLE C je skutečná kompakční operace. Může přesunout fyzické záznamy symbolů,
přečíslovat ordinaly a přepsat každý komprimovaný zdrojový expression obsahující
některý z těchto ordinalů. Očekává se proto, že potrvá znatelně déle než prosté
zobrazení nebo zamčení.

## E.11 Pseudoinstrukce

PROMETHEUS rozpoznává obyčejné mnemonicy Z80 přes tabulku instrukcí a také
poskytuje následující slova řízení sestavení.

| Pseudoinstrukce | Účel | Chování v průchodech |
|---|---|---|
| `ENT expression` | Nastaví adresu, kterou RUN použije po úspěšném sestavení. | V prvním průchodu ignorováno; expression vyhodnocen ve druhém. |
| `EQU expression` | Definuje label řádku hodnotou expressionu. | Vyhodnoceno v prvním průchodu; ve druhém nic neemituje. |
| `ORG expression` | Nastaví logickou adresu sestavení i fyzický výstupní ukazatel. | Použito v obou průchodech. |
| `PUT expression` | Změní pouze fyzický výstupní ukazatel; zachová logickou adresu sestavení. | Použito v obou průchodech. |
| `DEFB expr[,expr...]` | Emituje jeden bajt pro každý expression. | Počítá v prvním průchodu; ve druhém emituje low bytes. |
| `DEFM string[,string...]` | Emituje znakové bajty. | Počítá v prvním průchodu; emituje ve druhém. |
| `DEFS expr[,expr...]` | Rezervuje prostor posunem adres bez zápisu bajtů. | Pouze posouvá. Implementace přijímá tvar položky parsovaný společným datovým seznamem. |
| `DEFW expr[,expr...]` | Emituje každou 16bitovou hodnotu low byte first. | Počítá dva bajty na položku, potom emituje little-endian slova. |

### ORG a PUT společně

```text
ORG #8000       logical = #8000, output = #8000
PUT #A000       logical remains #8000, output becomes #A000
```

Label a větev sestavené za PUT mají stále logické adresy poblíž `#8000`, ale
jejich bajty strojového kódu se zapisují poblíž `#A000`.

### Tvary uvozovek DEFM

PROMETHEUS zachovává své historické konvence uvozovek. V apostrofové formě
dostane poslední emitovaný znak bit 7; forma s dvojitými uvozovkami emituje
obyčejné znakové bajty. Zdvojené delimitery zpracovává parser řetězců. Jde o
kompaktní konvenci assembleru, nikoli obecnou syntaxi řetězců BASICu Spectra.

## E.12 SAVE, VERIFY a LOAD v editoru

Soubory zdroje PROMETHEA obsahují komprimovaný zdroj spolu s tabulkou symbolů
potřebnou k dekódování ordinalů symbolů.

| Příkaz | Účel |
|---|---|
| `SAVE` | Uloží současný obraz zdroje a symbolů. |
| `SAVE b` | Uloží vybraný blok zdroje a informace o symbolech, které potřebuje. |
| `VERIFY` | Porovná kazetu s parametry a filename zachovanými předchozím SAVE. |
| `LOAD` | Načte obraz zdroje a symbolů PROMETHEA. |
| `GENS` | Importuje podporovaný zdroj GENS/MASM místo nativního formátu. |

Filename následuje colon formu příkazu tam, kde jej prompt požaduje. Implementované
wildcard pravidlo je užší, než by se očekávalo: prázdný **první znak filename**
volí wildcard. Kód opakovaně testuje tento první bajt; nevyžaduje mezery ve všech
deseti pozicích názvu.

VERIFY je záměrně stavové. Není obecným příkazem s novou úplnou sadou parametrů.
Použijte jej bezprostředně po odpovídající operaci SAVE, dokud samomodifikované
parametry kazety stále popisují zamýšlený blok.

LOAD a GENS nejsou transakčními moderními importery. Materiál transformují a
vkládají postupně. Pozdní selhání proto může ponechat již importovaný zdroj v
paměti.

## E.13 Vstup do monitoru a jeho opuštění

Použijte `MONITOR` z editoru. Monitor udržuje vlastní čelní panel a uložený obraz
procesoru. Stiskem `Q` se vrátíte do PROMETHEA.

Současná adresa monitoru je ústředním cursorem. Mnoho příkazů ji používá bez
promptu; shiftované varianty obvykle požádají o explicitní adresu First.

## E.14 Navigace po adresách monitoru

| Klávesa | Akce |
|---|---|
| `M` | Požádá o novou současnou adresu paměti. |
| cursor nahoru | Posune současnou adresu zpět o jeden bajt. |
| `ENTER` | Posune současnou adresu dopředu o jeden bajt. |
| cursor dolů | Dekóduje současnou instrukci a posune se o její délku. |
| cursor vpravo | Požádá o child adresu a uloží předchozí navigační úroveň. |
| cursor vlevo | Vrátí se k předchozí uložené navigační úrovni. |
| `CS+0` | Vymaže a obnoví zobrazení monitoru. |
| `Q` | Vrátí se do editoru. |

Mechanismus vlevo/vpravo je desetipoložkovým stackem adres. Hodí se při sledování
ukazatelů nebo volání: přejděte dolů na odkazovanou adresu a potom se bez jejího
nového psaní vraťte k předchozímu pohledu.

## E.15 Vstup expressionů monitoru

Prompty monitoru sdílejí evaluator expressionů assembleru pracující zleva
doprava. Přijímají:

```text
12345          decimal
#8000          hexadecimal
%10101010      binary
'A' nebo quoted hodnoty přijímané parserem
$              současná adresa sestavení/monitoru v aktivním kontextu
SYMBOL         existující symbol PROMETHEA
+ - * / ?      podporované operátory zleva doprava
```

Neexistuje konvenční hierarchie precedence. Používejte jazyk expressionů podle
kapitoly 22, nikoli podle pravidel moderního kompilátoru.

U kazetových příkazů se vstup začínající `:` vrátí jako forma filename místo
číselného vyhodnocení. Ne každý kazetový handler jí dává význam; monitor J
zejména očekává číselný leader.

`EDIT` opustí prompt monitoru a vrátí čelní panel.

## E.16 Ovládání čelního panelu monitoru

| Klávesa | Akce |
|---|---|
| `SS+W` | Vstoupí do editoru deskriptorů čelního panelu. |
| `SS+N` | Nastaví vybraný registr nebo zobrazenou hodnotu. |
| `SS+B` | Vymění primární a alternativní sady registrů v uloženém obrazu procesoru. |
| `SS+M` | Přepne uložený stav povolení přerušení. |
| `SS+3` | Přepne decimal/hexadecimal zobrazení čísel. |
| `SS+X` | Přepne zpracování řízení instrukcí. |
| `X` | Cyklí politiku přímého vykonávání přes NON, DEF a ALL. |
| `6` | Edituje seznam přímých cílů CALL/RST. |

Režimy přímého vykonávání znamenají:

| Režim | Význam během trasování |
|---|---|
| NON | Nevykonávat cíle CALL/RST nativně; ponechat je pod interpretací monitoru. |
| DEF | Vykonat nativně pouze cíl, který je v seznamu direct-call. |
| ALL | Vykonat nativně každý cíl CALL/RST. |

Tabulka direct-call přijímá až deset adres. V jejím editoru `I` vloží novou
adresu a číselné klávesy odstraní zobrazené položky podle číslovaného seznamu.

Nativní vykonávání je rychlé, ale leží mimo několik ochran po jednotlivých
instrukcích. Než budete režim ALL považovat za ekvivalent trasovaného vykonávání,
prostudujte dodatek G.

## E.17 Prohlížení a sestavování paměti

| Klávesa | Akce |
|---|---|
| `L` | Vypíše paměť od současné adresy. |
| `SS+L` | Požádá o adresu a potom vypíše paměť. |
| `O` | Vypíše znakovou interpretaci od současné adresy. |
| `SS+O` | Požádá o adresu a potom vypíše znaky. |
| `SPACE` | Sestaví jeden řádek do paměti na současné adrese. |
| `E` | Vstoupí do souvislého režimu sestavování paměti. |
| klávesa clear-list monitoru (`CS+2` v normalizované tabulce) | Vymaže listové okno čelního panelu. |

Jednořádkový assembler je obyčejný tokenizer a dvouprůchodový engine PROMETHEA
vypůjčený pro dočasný řádek. Respektuje kontrolu výstupu do rezidentní paměti
používanou normální kompilací. Souvislý režim E po každém úspěšném řádku
aktualizuje origin.

Výpis paměti a znaků čte RAM přímo. Jsou to inspekční příkazy, nikoli simulované
uživatelské instrukce, a proto nemusí konzultovat konfigurovatelná okna READ.

## E.18 Ovládání disassembly

| Klávesa | Akce |
|---|---|
| `SS+4` | Vypíše disassembly od současné adresy monitoru. |
| `V` | Požádá o počáteční adresu a vypíše disassembly. |
| `D` | Pošle disassembly rozsahu na tiskárnu. |
| `SS+D` | Zpětně disassembluje rozsah do zdroje PROMETHEA. |
| `C` | Přepne zobrazení číselných adres v disassembly. |
| `SS+C` | Cyklí širší politiku tisku adres. |

Interaktivní listový výstup následuje konvenci pokračování monitoru: držení
klávesy streamuje řádky; uvolnění pozastaví; další klávesa kromě EDIT obnoví;
EDIT vrátí panel.

Zpětný disassembly používá stejný neutrální line buffer jako obrazovkový a
tiskový výstup a potom odevzdává každý generovaný řádek běžnému encoderu
zdrojových záznamů. Podléhá proto kapacitě zdroje a chybám parseru. Operace má
opravnou cestu pro neúspěšný generovaný řádek, nikoli samostatný soukromý writer
zdroje.

## E.19 Hledání v paměti

| Klávesa | Akce |
|---|---|
| `G` | Definuje a hledá pětibajtový maskovaný vzor. |
| `N` | Pokračuje k dalšímu výskytu uloženého vzoru. |

Pro každou z pěti pozic přijme prompt reprezentaci hodnoty a masky přes cestu
expressionu monitoru. Kompaktní hledání porovnává pouze bity zvolené maskou.
Wildcard bajt proto používá nulovou masku.

Scan postupuje šestnáctibitovým adresovým prostorem a může se zalomit přes
`$FFFF`. Nemá nezávislou koncovou adresu. Používejte N s vědomím, že další shoda
může být na druhé straně adresového wrapu.

## E.20 Přesouvání a vyplňování bloků

Každý rozsah používá inkluzivní koncové body First a Last, pokud shiftovaný
příkaz nepožaduje Length.

| Klávesa | Tvar | Akce |
|---|---|---|
| `I` | First, Last, To | Přesune blok se směrem bezpečně zvoleným pro překryv. |
| `SS+I` | First, Length, To | Stejná operace s délkou. |
| `P` | First, Last, Byte | Vyplní inkluzivní rozsah. |
| `SS+P` | First, Length, Byte | Vyplní podle délky. |

MOVE se chová jako `memmove`: podle překryvu volí dopředné nebo zpětné
kopírování. MOVE a FILL odmítají zápisy do rezidentní/zdrojové oblasti
PROMETHEA prostřednictvím kontroly rezidentu specifické pro příkaz. Nepoužívají
pět editovatelných oken WRITE, která řídí trasované programové instrukce.

## E.21 Tabulky ochrany a zobrazovaných oblastí

Číselné klávesy `1` až `5` otevírají pět příbuzných tabulek rozsahů:

| Klávesa | Tabulka |
|---|---|
| `1` | adresy zobrazované při disassembly jako oblasti `DEFB` |
| `2` | adresy zobrazované při disassembly jako oblasti `DEFW` |
| `3` | rozsahy chráněné pro READ trasovaných instrukcí |
| `4` | rozsahy chráněné pro WRITE trasovaných instrukcí |
| `5` | rozsahy chráněné pro RUN při trasovaném vykonávání |

Každá tabulka může obsahovat pět viditelných uživatelských rozsahů. V editoru:

| Klávesa | Akce |
|---|---|
| `I` | Požádá o First a inkluzivní Last a přidá rozsah. |
| `0`..`4` | Odstraní odpovídající očíslovaný viditelný rozsah. |
| `EDIT` nebo běžná výstupní akce | Vrátí se do monitoru. |

Tabulky READ, WRITE a RUN obsahují další skrytý dynamický rozsah chránící
samotného PROMETHEA. Není jednou z pěti zobrazených uživatelských položek.

Klasifikace zobrazované oblasti se řídí počáteční adresou dekódované položky.
Vícebajtová položka překračující hranici rozsahu se nerozdělí do dvou odlišných
formátů disassembly.

## E.22 Ovládání vykonávání a trasování

| Klávesa | Akce |
|---|---|
| `SS+Z` | Vykoná jednu monitorovanou instrukci na současné adrese. |
| `T` | Trasuje pomalu a zobrazuje každý krok. |
| `SS+T` | Trasuje rychle do zadané adresy. |
| `W` | Nastaví nebo použije trvalé řízení breakpoint/start běhu. |
| `SS+U` | Běží nativně k dočasnému breakpointu. |
| `SS+H` | Zavolá zadaný podprogram s uloženým stavem uživatelských registrů. |

Single-step mode zkopíruje vhodnou instrukci do scratch trampoline, vykoná ji,
zachytí stav procesoru a opraví tok řízení tam, kde záleží na původní adrese
kopírované instrukce. CALL, návraty, relativní skoky, návraty z přerušení a
blokové operace vyžadují zvláštní zpracování.

Pomalé a rychlé trasování používá stejný krokovací engine s odlišnou politikou
prezentace a zastavení. Uložený stav přerušení lze nezávisle přepnout pomocí
`SS+M`.

Trvalé a dočasné nativní breakpointy nahradí cílový bajt trap instrukcí a po
zásahu jej obnoví. Breakpoint, kterého se nikdy nedosáhne, zůstane nainstalovaný,
dokud jej neobnoví nebo nenahradí jiná cesta; i proto je nutné nativní vykonávání
používat opatrně.

## E.23 Kazetové příkazy monitoru

### Uložení libovolné paměti

| Klávesa | Prompty |
|---|---|
| `S` | First, Last, potom Leader nebo `:filename` |
| `SS+S` | First, Length, potom Leader nebo `:filename` |

Číselný Leader uloží jeden raw blok s tímto low-byte flagem a bez hlavičky
Spectra. `:filename` vytvoří standardní sedmnáctibajtovou hlavičku CODE, počká na
kazetu běžnou cestou hlavičky a potom uloží datový blok `$FF`. Adresou načtení v
hlavičce je First.

Monitor SAVE záměrně neodmítá obrácené nebo wrapující rozsahy a nevolá checker
rezidentního rozsahu. Šestnáctibitové odčítání jednoduše dodá délku přijatou
cestou ROM.

### Načtení libovolné paměti

| Klávesa | Prompty |
|---|---|
| `J` | First, Last, číselný Leader |
| `SS+J` | First, Length, číselný Leader |

J odmítne obrácený/wrapující cíl a cíl protínající rezidentní oblast
PROMETHEA/zdroje. Potom načte přesně jeden raw blok, jehož flag odpovídá Leaderu.
Handler nemá smysluplnou větev filename; použijte číselný leader.

### Prohlédnutí kazetové hlavičky nebo leaderu

`Y` přečte další kazetový blok jako objekt velikosti hlavičky.

- Pro platnou hlavičku `$00` zobrazí filename, délku a oba parametry hlavičky.
  Následující stisk `J` načte bezprostředně následující datový blok na adresu v
  parametru 1, se zobrazenou délkou a flagem `$FF`.
- Pro blok bez hlavičky oznámí pozorovaný leader/flag a vrátí se.

Cesta Y následovaná J považuje parametr 1 a délku za cíl ve stylu CODE. Před
nabídnutím této raw následné interpretace neomezuje zobrazený typ hlavičky na
sémantickou hlavičku CODE.

## E.24 Pokračování listového výstupu monitoru

Seznamy paměti, znaků a disassembly sdílejí jeden protokol pokračování:

```text
držet klávesu       pokračovat ve vytváření řádků
uvolnit klávesu     pozastavit
stisknout non-EDIT  obnovit
stisknout EDIT      zastavit a vrátit panel
```

To umožňuje rychlé streamování i prohlížení po jednotlivých řádcích bez
samostatných pause příkazů.

## E.25 Ovládání instalátoru

Dočasný instalátor běží na `$5000`. Zobrazuje navrženou pětimístnou instalační
adresu, volbu Monitor Yes/No, normální a zvýrazněné barvy, styl textu a keyboard
echo. Každá přijatá změna nastavení se vrací přes syntetickou adresu překreslení,
takže celý panel okamžitě odráží výsledek.

| Klávesa | Akce instalátoru |
|---|---|
| číslice `0`..`9` | Nahradí současnou číslici adresy a posune underscore cursor vpravo. |
| DELETE | Smaže předchozí číslici adresy a posune cursor vlevo. |
| `ENTER` | Potvrdí nastavení, zkopíruje zvolený rezidentní obraz, patchuje jej, relokuje a spustí. |
| `M` | Přepne Monitor Yes/No. |
| `I` | Cyklí INK normálního textu. |
| `P` | Cyklí PAPER normálního textu. |
| `B` | Přepne BRIGHT normálního textu. |
| `CS+I` | Cyklí INK zvýrazněného řádku. |
| `CS+P` | Cyklí PAPER zvýrazněného řádku. |
| `CS+B` | Přepne BRIGHT zvýrazněného řádku. |
| `D` | Přepne tučné vykreslování glyphů. |
| `C` | Cyklí mixed case, forced lower case a forced upper case. |
| `X` | Zvýší délku kliknutí klávesnice. |
| `CS+X` | Sníží délku kliknutí klávesnice. |

Editor adresy přijímá přesně pět desetinných číslic. Jeho hlavní ochranou je tvar
pole: odmítne překročit dvojtečku vlevo nebo terminátor řetězce s high bitem
vpravo. Neprovádí komplexní validaci překryvu a rozložení stroje očekávanou od
moderního instalátoru. Uživatel odpovídá za volbu cíle, kde může žít zvolený
16 000bajtový nebo 11 000bajtový obraz.

## E.26 Běžná pravidla zotavení

V PROMETHEOVI se opakuje několik pravidel rozhraní:

- `EDIT` obecně opustí současný prompt nebo listovou operaci monitoru.
- Syntax error v expressionu monitoru po zobrazení chyby znovu otevře stejný
  prompt.
- `SS+Q` editoru opustí současný vstupní řádek, nikoli zdroj.
- Příkaz měnící packed zdroj nebo symboly nejprve zkontroluje příslušnou kapacitu
  nebo hranici rezidentu, ale příkazy nesdílejí jedinou univerzální politiku
  ochrany.
- Decimal/hex mode ovlivňuje prezentaci, nikoli uložené strojové hodnoty.
- Koncové body bloku zdroje a First/Last monitoru jsou inkluzivní.

## E.27 Jednostránková zkrácená reference

```text
EDITOR
  CS+1 edit active line       SS+W insert/overwrite
  CS+6 next line              CS+7 previous line
  CS+3 next page              CS+4 previous page
  CS+9 delete active line     CS+SS mark block boundary
  SS+Q abandon input          ENTER submit

  A ASSEMBLY   B BASIC      C COPY       D DELETE
  E END        F FIND       G GENS       H HEX/DEC
  K START      L LOAD       M MONITOR     N NEW
  P PRINT      Q QUIT       R RUN         S SAVE
  T TABLE      U U-TOP      V VERIFY      X CLEAR
  Z REPLACE

ASSEMBLER CONTROL
  ENT EQU ORG PUT DEFB DEFM DEFS DEFW

MONITOR NAVIGATION
  M set address   up/down byte-or-instruction navigation
  left/right navigation stack   Q editor   CS+0 clear display

MONITOR MEMORY/DISASSEMBLY
  L/SS+L memory list             O/SS+O character list
  SPACE one-line assemble        E continuous assemble
  SS+4/V disassembly             D printer disassembly
  SS+D reverse disassembly       G find pattern, N next
  I/SS+I move                    P/SS+P fill

MONITOR EXECUTION
  SS+Z step   T slow trace   SS+T fast trace
  W breakpoint/run start     SS+U temporary breakpoint
  SS+H native call           X NON/DEF/ALL
  6 direct-call list         3/4/5 READ/WRITE/RUN windows

MONITOR TAPE
  S/SS+S save First/Last or First/Length
  J/SS+J load First/Last or First/Length
  Y inspect header/leader; J after a header loads its data

INSTALLER
  digits/DELETE address      ENTER install
  M monitor                  I/P/B normal colour
  CS+I/P/B highlight colour  D bold   C case
  X/CS+X click duration
```

Zkrácená stránka je užitečná vedle emulátoru. Předchozí oddíly zůstávají autoritou
tam, kde má příkaz stavovou nebo historicky překvapivou okrajovou podmínku.
