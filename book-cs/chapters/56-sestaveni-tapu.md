# Kapitola 56: Sestavení TAPu

Binární program pro Z80 sám o sobě ještě není úplným kazetovým programem pro
Spectrum.

Uživatel očekává, že napíše `LOAD ""`, počká na známé barevné pruhy v borderu a
počítač bude automaticky pokračovat. Aby se tak stalo, je PROMETHEUS obalen malým
BASICovým loaderem a uložen ve standardních kazetových blocích Spectra.

Vnější formát je mnohem jednodušší než program uvnitř. Přesto zajišťuje důležitou
souhru:

- BASIC rezervuje paměť;
- kazetový kód ROM načte blok strojového kódu;
- BASIC zavolá fyzickou adresu bootstrapu;
- bootstrap potom provede vlastní instalaci a relokaci PROMETHEA.

Tato kapitola rozlišuje tři vrstvy, kterým se často nepřesně říká jedním slovem
„loader“:

```text
BASICový loader Spectra
pozičně nezávislý bootstrap PROMETHEA
instalátor PROMETHEA na $5000
```

Jsou to tři samostatné programy se třemi samostatnými úkoly.

## Soubor TAP je seznam logických bloků

Soubor `.tap` není záznamem analogového průběhu kazetového signálu. Je to
kompaktní počítačová reprezentace kazetových bloků Spectra.

Každý blok je uložen jako:

```text
dvoubajtová little-endian délka bloku
flag byte
bajty payloadu
bajt XOR kontrolního součtu
```

Délka zahrnuje flag, payload a kontrolní součet, nikoli však dva bajty samotné
délky.

Kontrolní součet je zvolen tak, aby XOR všech bajtů od flagu až po závěrečný
kontrolní součet dal nulu:

```text
flag XOR payload[0] XOR ... XOR payload[n-1] XOR checksum = 0
```

Na běžných kazetách Spectra převládají dvě hodnoty flagu:

```text
$00  hlavičkový blok
$FF  datový blok
```

Hlavička oznamuje typ, název a velikost následujícího datového bloku. ROM potom
načte data podle smlouvy popsané touto hlavičkou.

## Hlavička a data cestují v páru

Payload standardní hlavičky Spectra má sedmnáct bajtů:

```text
bajt 0       typ souboru
bajty 1-10   desetiznakový název
bajty 11-12  délka dat
bajty 13-14  parametr 1
bajty 15-16  parametr 2
```

Pro BASICový program:

```text
typ         = 0
parametr 1  = řádek autostartu nebo sentinel znamenající žádný autostart
parametr 2  = informace o oblasti proměnných programu
```

Pro CODE:

```text
typ         = 3
parametr 1  = adresa načtení
parametr 2  = pomocná hodnota, obvykle zachovaná z nástroje, který soubor vytvořil
```

Samotný hlavičkový blok je:

```text
flag $00 + 17 bajtů hlavičky + kontrolní součet
```

Následující datový blok je:

```text
flag $FF + skutečné bajty programu + kontrolní součet
```

ROM nemusí hádat, kolik dat má načíst. Hlavička jí to už sdělila.

## Historická distribuční kazeta PROMETHEA

Obnovená kazeta obsahuje osm bloků neboli čtyři páry hlavička/data:

```text
0  hlavička BASIC  "PROMETHEUS"  54 bajtů, autostart 9999
1  data BASIC                      54 bajtů
2  hlavička CODE   "prometheus"   18 356 bajtů, načíst na 24 000
3  data CODE                       instalační obraz PROMETHEA
4  hlavička CODE   "skatecrazy"   7 291 bajtů
5  data CODE                       payload skatecrazy
6  hlavička CODE   "gensor    "      300 bajtů, načíst na 55 000
7  data CODE                       payload GENSOR
```

Poslední dva programy jsou dalším obsahem distribuce. Samotný PROMETHEUS používá
bloky 0 až 3.

Rozdíl ve velikosti písmen názvů je skutečný:

```text
BASIC: "PROMETHEUS"
CODE:  "prometheus"
```

Názvy Spectra mají v hlavičce přesně deset bajtů a kratší názvy jsou doplněny
mezerami.

## Dvouřádkový BASICový loader

Po dekódování pomocí tabulky tokenů Sinclair BASICu vypadá 54bajtový program
takto:

```basic
1 RANDOMIZE USR 24e3: STOP
9999 CLEAR 23999: LOAD "prometheus" CODE : RUN
```

`24e3` je zápis čísla 24 000 ve vědecké notaci, jak jej tiskne Sinclair BASIC.

Program se automaticky spouští na řádku 9999, nikoli na řádku 1. Toto pořadí je
záměrné.

Řádek 9999 provede tři kroky:

```basic
CLEAR 23999
LOAD "prometheus" CODE
RUN
```

`CLEAR 23999` přesune hranici RAM BASICu pod adresu 24 000, na kterou se načítá
CODE. Zabrání tak tomu, aby proměnné a workspace BASICu rostly do obrazu
strojového kódu.

`LOAD "prometheus" CODE` požádá ROM, aby našla pojmenovanou hlavičku CODE a
načetla následující datový blok na adresu uloženou v této hlavičce.

`RUN` znovu spustí BASICový program od jeho prvního řádku. Vykonávání pak dojde
k:

```basic
1 RANDOMIZE USR 24e3
```

což zavolá strojový kód na adrese 24 000. Kdyby se tento strojový kód nečekaně
vrátil, `STOP` zabrání BASICu pokračovat k řádku loaderu a pokusit se načíst
kazetu znovu.

V pseudokódu:

```text
autostart na řádku 9999
rezervuj paměť pod adresou 24000
načti CODE na adresu 24000
znovu spusť BASIC od řádku 1
call strojový kód na adrese 24000
zastav, pokud se vrátí
```

## Proč BASIC volá fyzickou adresu načtení

Hlavička CODE říká:

```text
adresa načtení = 24 000 = $5DC0
```

To je nominální fyzické umístění `bootstrapEntry`, nikoli nutně konečný domov
rezidentního editoru.

Posloupnost vypadá takto:

```text
BASIC USR $5DC0
    -> pozičně nezávislý bootstrap
    -> instalátor zkopírovaný na $5000
    -> rezidentní cíl vybraný uživatelem
    -> relokace
    -> rezidentní entry point
```

BASICový loader neví nic o konečné instalační adrese. Pouze vstoupí do bootstrapu
první fáze na místě, kam ROM uložila celý blok CODE.

Právě toto oddělení dovoluje PROMETHEU nabídnout instalační adresu interaktivně,
aniž by musel vytvářet nový BASICový text.

## Hlavička CODE

Historická hlavička CODE PROMETHEA obsahuje:

```text
typ             CODE (3)
název           "prometheus"
délka           18 356 bajtů
adresa načtení  24 000 ($5DC0)
parametr 2      32 768 ($8000)
```

Data CODE o velikosti 18 356 bajtů jsou větší než 16 000bajtový rezidentní
payload.

Rozdíl tvoří dočasný instalační aparát:

```text
 18 356 celkových bajtů CODE
-16 000 bajtů rezidentního payloadu
= 2 356 bajtů bootstrapu/instalátoru/metadat/loga
```

Těchto prvních 2 356 bajtů se do konečného rezidentního programu nekopíruje
všechno. Patří mezi ně:

- fyzický bootstrap;
- instalátor vykonávaný z `$5000`;
- konfigurační a relokační proudy;
- data loga instalátoru.

Rezidentní payload začíná ve fyzických datech CODE později. Při historické adrese
načtení `$5DC0` je jeho fyzický začátek `$66F4`.

Instalátor potom může zkopírovat všech 16 000 bajtů nebo jejich suffix na konečný
cíl.

## Proč musí úplný binární obraz zůstat souvislý

Bootstrap nachází instalátor a payload pomocí rozdílů mezi labely vypočtených při
sestavení. Instalátor dokončí kreslení bajtů loga a přirozeně dospěje k ukazateli
na payload. Relokační a konfigurační tabulky leží ve stejném instalačním obrazu.

Blok CODE proto není volnou kolekcí samostatně načitatelných částí. Jeho rozložení
tvoří jedinou souvislou konstrukci:

```text
bootstrap
bajty instalátoru pro pevnou adresu
konfigurační metadata
relokační metadata
konec loga
rezidentní payload s originem nula
```

Zdroj používá `ORG` k popisu různých logických adres vykonávání, výstup assembleru
však jejich bajty stále ukládá za sebou do dat CODE.

To je nenápadný, ale důležitý bod:

> Logická adresa sestavení a fyzická pozice v kazetovém bloku nejsou vždy totéž.

Samolokalizační aritmetika bootstrapu je za běhu znovu propojí.

## Znovusestavení jednoho bloku TAP

Datový blok se ze sestaveného binárního obrazu zakóduje takto:

```text
bodyWithoutChecksum = $FF + binary
checksum            = XOR z bodyWithoutChecksum
body                 = bodyWithoutChecksum + checksum
storedBlock          = littleEndian(len(body)) + body
```

Pro historický binární obraz:

```text
bajty payloadu       18 356
flag byte                 1
bajt kontrolního součtu   1
tělo bloku TAP        18 358
plus pole délky            2
```

Stejný postup platí pro hlavičky, pouze flag je `$00` a payloadem je
sedmnáctibajtová hlavička.

Parser může blok ověřit, aniž by znal jeho význam: zkontroluje, že je k dispozici
uložený počet bajtů a že XOR celého těla je nula.

## Proč změna délky binárního obrazu ovlivní dva bloky

Předpokládejme, že rezidentní zdroj naroste o dva bajty. Úplný sestavený
instalační obraz naroste rovněž o dva bajty.

Builder TAPu musí aktualizovat:

1. bajty 11-12 payloadu odpovídající hlavičky CODE;
2. kontrolní součet hlavičky;
3. pole délky následujícího datového bloku CODE;
4. kontrolní součet dat;
5. celkovou délku souboru.

Nestačí pouze připojit bajty ke starému datovému bloku. ROM důvěřuje délce v
hlavičce a čtečky TAPů důvěřují vnějšímu poli délky bloku.

Například mutační test relokace vytvoří:

```text
binární obraz  18 356 -> 18 358 bajtů
TAP            26 101 -> 26 103 bajtů
```

Celkový růst o dva bajty je možný proto, že blok hlavičky CODE má pevnou fyzickou
velikost; změní se pouze jeho pole a kontrolní součet, zatímco datový blok získá
dva bajty payloadu.

## Builder TAPu s proměnnou délkou ve vzkříšení

Rekonstrukce obsahuje nástroj pro hostitelský počítač, který přijímá:

```text
historický šablonový TAP
čerstvě sestavený binární obraz
cestu výstupního TAPu
název CODE, obvykle "prometheus"
```

Nástroj parsuje každý blok a zkontroluje každý kontrolní součet. Potom vyhledá
standardní hlavičku splňující:

```text
flag = $00
typ hlavičky = 3
název = "prometheus" doplněný na deset bajtů
flag následujícího bloku = $FF
```

Změní se pouze nalezený pár.

Princip je tento:

```text
blocks = parseAndValidate(template)

najdi hlavičku CODE pojmenovanou "prometheus"
header.length = len(newBinary)
znovu vytvoř kontrolní součet hlavičky

nahraď payload následujícího datového bloku hodnotou newBinary
znovu vytvoř délku datového bloku a kontrolní součet

zkopíruj každý ostatní blok bajt po bajtu
parseAndValidate(result)
zapiš result
```

Tím zůstanou BASICový loader, `skatecrazy`, `gensor`, jejich hlavičky i každý
nesouvisející kontrolní součet přesně zachovány.

Nástroj rovněž odmítne:

- poškozené nebo zkrácené bloky;
- neplatné XOR kontrolní součty;
- chybějící odpovídající hlavičku CODE;
- odpovídající hlavičku, za níž nenásledují data;
- binární obrazy delší, než dovoluje šestnáctibitové pole délky v hlavičce
  Spectra.

## Původní mechanismus a nástroje rekonstrukce

Původní zdroj PROMETHEA soubor TAP nevytváří. Je payloadem, který do obrazu
kazety vložil externí vývojový nástroj.

Moderní builder TAPu patří projektu vzkříšení. Jeho účelem je umožnit
reprodukovatelné změny zdroje bez závislosti na přesném historickém toolchainu
hostitelského počítače.

Tento rozdíl připomíná generovanou relokační tabulku:

```text
původní runtime návrh:
    Sinclair BASIC a ROM načtou standardní blok CODE
    bootstrap/instalátor Z80 relokuje rezidentní program

moderní podpora rekonstrukce:
    hostitelské skripty znovu generují metadata a sestavují platné kontejnery TAP
```

Nové nástroje nenahrazují původní chování Spectra. Připravují bajty, které toto
původní chování očekává.

## Historická identita jako silnější test

Pro nezměněný zdroj je čerstvě sestavený binární obraz přesně:

```text
velikost  18 356 bajtů
SHA-256   940f793ad99351507d857b1d96a79bfcf3395d2e1577d633595ab7eaa67edce8
```

Nahrazení historického datového bloku tímto binárním obrazem a přepočítání jeho
kontrolního součtu zrekonstruuje úplnou původní kazetu:

```text
velikost  26 101 bajtů
SHA-256   29111b19fb680199b6ed3eee07bbd62757a25a8baefe2454a497d2f35c46a93f
```

Toto tvrzení je silnější než věta „assembler vytvořil ekvivalentní kód“.
Znamená, že:

- každý binární bajt PROMETHEA se shoduje;
- metadata hlavičky CODE se shodují;
- celý datový blok s předřazenou délkou se shoduje;
- všech osm bloků tvoří stejnou distribuční kazetu.

U změněného zdroje se přesná historická identita už neočekává. Podstatnými
zárukami se stávají strukturální platnost, správné délky a kontrolní součty a
úspěšné vykonání po relokaci.

## Co automatizované testy záměrně nereprodukují

Soubor TAP reprezentuje logické kazetové bloky, nikoli analogový signál, motor
magnetofonu, šum, časování ani úplnou interakci s loaderem v ROM.

Testovací prostředí pro vykonávání začíná až poté, co byla data CODE umístěna do
paměti. Modeluje pouze malou množinu smluv ROM potřebných pro start PROMETHEA a
vykonává skutečný bootstrap, instalátor i rezidentní program.

Věrný end-to-end test od fyzického průběhu kazetového signálu přes původní
autorsky chráněnou 48K ROM je samostatný problém.

Tato hranice je poctivá a užitečná:

```text
testy builderu TAPu:
    struktura bloků, pole hlaviček, délky dat, kontrolní součty

testy startu v emulátoru:
    bootstrap, instalátor, kopírování, dekódování metadat, relokace, vstup do editoru

zde se automaticky netestuje:
    analogový kazetový signál a úplná cesta kazety přes původní ROM
```

## Co se v souboru změnilo

Sestavení upraveného TAPu může změnit:

- pole délky v hlavičce CODE PROMETHEA;
- XOR kontrolní součet tohoto hlavičkového bloku;
- pole délky následujícího datového bloku;
- datové bajty PROMETHEA;
- XOR kontrolní součet tohoto datového bloku;
- celkovou délku souboru TAP.

Všechny nesouvisející bloky zůstanou nezměněny bajt po bajtu.

## Důležité navštívené artefakty

- hlavička BASIC `"PROMETHEUS"`
- datový blok BASIC s řádky 1 a 9999
- hlavička CODE `"prometheus"`
- datový blok CODE začínající fyzicky na `$5DC0`
- `bootstrapEntry`
- `build_tap_from_template.py`
- `verify_tap_compatibility.py`
- kanonická osmibloková distribuční kazeta

## Zpět k celému stroji

Kazeta nyní obsahuje každou vrstvu potřebnou ke spuštění:

```text
BASICový program
    -> načte úplný obraz CODE

obraz CODE
    -> zjistí vlastní umístění
    -> nainstaluje a nakonfiguruje PROMETHEUS
    -> relokuje vybrané rezidentní rozložení

rezidentní obraz
    -> vstoupí do editoru
```

Příští kapitola sleduje tuto cestu souvisle, bez přerušování výkladem nového
mechanismu. Je posledním návratem shora dolů v části VII: od první instrukce
autostartu BASICu až k prvnímu čekání editoru na klávesu.
