# Kapitola 59: Paměťové hospodářství PROMETHEA

Spectrum se 48 KB působí velkoryse, pokud je dotyčným programem malá hra nebo
krátká utilita v BASICu. Mnohem méně velkoryse vypadá ve chvíli, kdy chce jediný
program být současně tímto vším:

- celoobrazovkovým editorem zdroje;
- dvouprůchodovým assemblerem;
- správcem symbolů;
- disassemblerem;
- prohlížečem a editorem paměti;
- správcem kazetových souborů;
- monitorem s breakpointy a trasováním;
- konfigurovatelným instalátorem;
- pracovním prostorem, v němž může růst uživatelův vlastní zdroj i generovaný kód.

Rezidentní payload PROMETHEA má v historickém buildu přesně 16 000 bajtů:

```text
5 000 bajtů   volitelný prefix monitoru
11 000 bajtů  suffix assembleru/editoru
```

Toto číslo nezahrnuje rostoucí uživatelův zdroj, symboly ani generovaný program.
Ty se musí o zbytek stroje podělit s ROM Spectra, obrazovkou, systémovými
proměnnými a stacky.

Zajímavá otázka proto nezní jen:

> Jak byly jednotlivé rutiny zkráceny?

Užitečnější otázka zní:

> Jak se PROMETHEUS vyhnul ukládání téhož významu dvakrát?

Jeho paměťová úspornost vychází z komprese, ale také ze sdílených reprezentací,
tabulkově řízeného chování, pohyblivých hranic, použití samotného Z80 jako
dočasného úložiště a ochoty nechat kódové bajty uchovávat stav.

## První úspora: vynechat celý subsystém, není-li požadován

Největší úspora je architektonická, nikoli triková.

Payload má pevnou hranici:

```text
ENTRY_POINT_WITH_MONITOR      offset $0000
ENTRY_POINT_WITHOUT_MONITOR   offset $1388
```

Prvních `$1388` bajtů — přesně 5 000 — obsahuje monitor. Uživatel, který chce
pouze editor a assembler, může samostatně nainstalovat 11 000bajtový suffix.

Toto uspořádání něco stojí. Absolutní adresy v suffixu byly slinkovány, jako by
prefix monitoru existoval, takže relokace varianty pouze s assemblerem potřebuje
jinou korekci. Příkaz MONITOR musí být přesměrován, protože jeho běžný cíl chybí.
Instalátor musí podporovat dvě délky kopírování a dva významy vstupního bodu.

Odměna je však značná: jediný distribuovaný obraz vytváří dva užitečné
rezidentní produkty bez údržby dvou nesouvisejících kódových základen.

Je to raný příklad principu, který se v PROMETHEU objevuje znovu a znovu:

> Sdílej všechno, co lze sdílet, ale zachovej jednu pečlivě zvolenou hranici,
> na níž může celá volitelná vlastnost zmizet.

## Záznamy zdroje uchovávají význam, nikoli vzhled

Lidsky čitelný zdroj je drahý. Uvažujme:

```asm
LOOP    DJNZ LOOP
```

Při doslovném uložení obsahuje opakovaná písmena, mezery zvolené pouze kvůli
vzhledu a mnemoniku, jejíž zápis už je obsažen ve slovníku PROMETHEA.

Trvalý záznam zdroje místo toho ukládá kompaktní fakta:

```text
existuje label
jeho ordinal symbolu je N
index mnemoniky znamená DJNZ
třída operandu znamená relativní expression
atom expressionu odkazuje na ordinal symbolu N
záznam zde končí; předchozí záznam má tuto délku
```

Přesné bajty závisí na podobě záznamu, princip úspory je však stálý. Řádek
neopakuje text `LOOP` dvakrát. Text `DJNZ` neopakuje vůbec. Nezachovává ozdobné
mezery.

Výsledkem je několik úspor najednou.

### Zdroj zabírá méně bajtů

Dlouhý program se snáze vejde pod U-TOP.

### Sestavení neopakuje lexikální práci

Jakmile je řádek přijat, první i druhý průchod pracují s jeho zakódovaným
významem. Při každém sestavení znovu neprohledávají slovník mnemonik a
neklasifikují stejné závorky.

### Pohyb zpět je zakódován přímo v datech

Koncový bajt zároveň obsahuje třídu délky záznamu a informaci pro zpětný odkaz.
Editor dokáže najít předchozí záznam proměnné délky bez samostatného pole
ukazatelů na řádky.

### Zobrazení vzniká až tehdy, když je potřeba

Čitelný zdroj se rekonstruuje do dočasného řádkového bufferu pouze pro záznamy,
které se právě zobrazují, tisknou, textově prohledávají nebo editují.

Editor tedy uchovává drahý lidský pohled pouze přechodně a kompaktní sémantický
pohled trvale.

## Dvacet prázdných záznamů je levnější než výjimky všude

Počáteční zdroj obsahuje dvacet pevných prázdných záznamů:

```asm
sourceBufferStart:
    defb $00,$30
    ... twenty times ...
```

Na první pohled to působí plýtvavě. Proč utratit čtyřicet bajtů za řádky, které
nic neobsahují?

Protože tyto záznamy kupují jednoduchost v mnoha často používaných cestách.

Editor požaduje:

```text
13 platných záznamů nad aktivním řádkem
1 aktivní záznam
6 platných záznamů pod ním
```

Díky trvalému prázdnému paddingu mohou počáteční zobrazení a navigace poblíž
okrajů často používat stejné rutiny pro pohyb vpřed a vzad po záznamech jako
běžný zdroj. Program nepotřebuje velkou sadu testů říkajících „pokud neexistuje
předchozí řádek, vymysli prázdný řádek“.

Šest prázdných záznamů se po mazání obnovuje také pod živým koncem zdroje. Malý
pevný náklad na data odstraňuje opakovaný kód a větvení z hlavní cesty editoru.

Paměťová úspornost neznamená vždy „použij nejméně datových bajtů“. Několik
bajtů dat někdy ušetří více kódových bajtů a složitosti, než samo spotřebuje.

## Symboly používají ordinaly, takže se názvy ukládají jen jednou

Labely jsou dalším zdrojem opakování. Program může na `LOOP` odkazovat desítkykrát.
PROMETHEUS uloží název jednou do tabulky symbolů a do každého expressionu zdroje
vloží kompaktní ordinal.

Tabulka symbolů odděluje dvě potřeby:

```text
záznamy zdroje potřebují stabilní malé identity
lidé potřebují názvy v abecedním pořadí
```

Vektor indexovaný od jedné převádí ordinal na současný záznam hodnoty a názvu.
Samotné záznamy jsou kvůli vyhledávání a zobrazení uloženy abecedně.

Tato nepřímost znamená:

- odkazy ve zdroji zůstávají malé;
- názvy se neopakují v každém expressionu;
- abecední vložení může přesunout záznamy beze změny ordinalů;
- komprimace může odstranit jeden ordinal a systematicky přepsat pozdější odkazy;
- importovaný zdroj může převést cizí ordinaly přes názvy na živé ordinaly.

Vektor stojí dva bajty na symbol, zabraňuje však mnohem většímu opakování názvů
a odděluje identitu ve zdroji od fyzického pořadí tabulky.

## Sbalené řetězce nepotřebují samostatnou délku ani terminátor

PROMETHEUS často označuje poslední znak řetězce nastavením bitu 7. Například
název příkazu ASSEMBLY je koncepčně uložen takto:

```asm
defb "ASSEMBL", 'Y'|$80
```

Jediný bajt slouží dvěma účelům:

- jeho dolních sedm bitů tvoří poslední znak;
- jeho horní bit je značka konce.

Není potřeba samostatný nulový terminátor ani bajt délky.

Stejná konvence dovoluje také inline řetězce za voláním. Rutina může sejmout
návratovou adresu, použít ji jako ukazatel na řetězec, tisknout až po poslední
znak s nastaveným horním bitem a potom skočit na bajt za řetězcem. Tok kódu a
umístění dat sdílejí návratovou adresu, kterou už vytvořila instrukce `CALL`.

Modernímu čtenáři to připadá neobvyklé. Pro PROMETHEUS je to opakovaně používaný
způsob, jak u mnoha řetězců odstranit jeden bajt zde a jednu instrukci tam.

## Samorelativní vektory se vyhýbají úplným ukazatelům

Mnoho tabulek ukládá jednobajtové rozdíly namísto dvoubajtových absolutních
adres. Dispatch příkazů nebo skupina deskriptorů zná základ a přičte signed či
unsigned lokální deltu.

Je to úsporné, pokud jsou cíle blízko:

```text
úplná adresa na položku       2 bajty
jednobajtová relativní položka 1 bajt
```

Taková data také přežijí přesun celého rezidentního obrazu bez relokace, protože
zdroj i cíl se přesunou společně.

Cenou je omezený dosah a silnější závislost na pořadí tabulky. Rutinu nelze
libovolně přesunout daleko, aniž by se reprezentace rozšířila nebo skupina
přeskupila.

Proto může být zdánlivě neškodná změna pořadí tabulky nebezpečná. Fyzické
rozložení je někdy součástí zakódování.

## Jedna tabulka instrukcí slouží třem velkým subsystémům

Přiložená tabulka instrukcí obsahuje 687 pětibajtových záznamů. V 16KB payloadu
je to znatelná investice, nahrazuje však několik větších bloků zvláštního kódu.

Tabulka podporuje:

### Vstup zdroje

```text
index mnemoniky + třídy operandů -> odpovídající záznam instrukce
```

### Sestavení

```text
záznam -> prefix, opcode a recept emise operandů
```

### Disassembly

```text
vzor prefixu/opcode -> mnemonika a třídy operandů
```

### Vykonávání pod dohledem

Stejná dekódovaná struktura poskytuje:

- délku instrukce;
- základní časování a časování provedené cesty;
- klasifikaci toku řízení;
- shodu přístupů do paměti.

Důležitou úsporou není to, že je tabulka malá. Důležité je, že znalost instrukcí
je uložena jen jednou.

Bez ní by PROMETHEUS potřeboval jednu mapu opcodes pro sestavení, druhou pro
disassembly, další dekodér délek pro krokování a rozptýlenou logiku časování.
Tyto struktury by se časem nejen rozcházely, ale také spotřebovávaly paměť.

## Jeden parser zdroje obsluhuje několik vstupů

Běžný parser editoru se znovu používá pro operace, které na první pohled působí
nesouvisejícím dojmem.

### Nativní LOAD

Uložené komprimované záznamy nelze přímo zkopírovat, protože jejich ordinaly
odkazují do importované tabulky symbolů. Každý záznam se rozbalí na text s
použitím importovaných názvů a potom se odešle živým parserem, aby obdržel živé
ordinaly.

### Import GENS/MASM

Cizí text se normalizuje do vstupního řádku editoru a odešle stejným parserem.

### REPLACE

Vybraný záznam zdroje se rozbalí, textově změní a odešle běžnou cestou přepsání.

### Obrácené disassemblování

Dekódovaná paměť se změní na textový assembler a potom na běžný vstup zdroje.

### Jednořádkové sestavení v monitoru

Dočasný záznam se parsuje a posílá standardním handlerům průchodů, aniž by byl
vložen do trvalého zdroje.

Větší program by mohl implementovat pět přímých převodníků. PROMETHEUS udržuje
jedinou důvěryhodnou bránu:

```text
čitelný assemblerový text -> zkontrolovaný kompaktní záznam
```

Každá funkce, která dokáže takový text vytvořit, získává zdarma syntaktickou
kontrolu, vytváření symbolů i hledání instrukcí.

## Jeden řádek disassembly obsluhuje několik výstupů

Opačný směr používá stejnou úsporu.

`disassembleNextLineToBuffer` vytváří kanonický řádek. Různé callbacky jej
odesílají:

- na rolující obrazovku;
- na čelní panel;
- na tiskárnu;
- do vstupní cesty editoru.

Dekodér neví, zda se na obrazovku dívá člověk, nebo zda se řádek stane trvalým
zdrojem. Prezentace a cíl jsou oddělená pozdní rozhodnutí.

Je to stejný princip „jedna vnitřní pravda, několik pohledů“, který používají
záznamy zdroje a deskriptory instrukcí.

## Kódové bajty slouží zároveň jako proměnné

PROMETHEUS používá labely začínající `varc` pro stav vložený do operandů nebo
opcodes instrukcí.

Například:

```asm
varcAssemblyOutputPointer:
    ld hl,0000h
```

Dva bajty operandu jsou současně:

- součástí spustitelné instrukce `LD HL,nn`;
- trvalým úložištěm současného ukazatele výstupu.

Konvenční návrh by mohl vyžadovat:

```asm
assemblyOutputPointer:
    defw 0

    ld hl,(assemblyOutputPointer)
```

Samomodifikovaná podoba šetří samostatnou buňku a může šetřit instrukce při
každém čtení. Podobná pole si pamatují:

- ukazatele na zdroj a konec kódu;
- callbacky;
- handlery průchodů;
- continuation skoky;
- režimy editoru;
- stav opakování klávesnice;
- adresy monitoru;
- opcodes rendereru instalátoru;
- politiku vykonávání.

Někdy je nastavením celý opcode. `NOP` proti `RRCA`, `DI` proti `EI` nebo jeden
patchovaný cíl `JP` mohou vyjádřit režim bez větvení a samostatného flagu.

Cena je intelektuální, nikoli prostorová. Čtenář musí chápat, že změna tvaru
instrukce může zničit proměnnou. Přesun kódu musí zachovat relokační a patchovací
labely. Přerušení nebo reentrance by mohly být nebezpečné, kdyby dvě použití
soutěžila o stejný patchovaný operand — PROMETHEUS se tomu z velké části vyhýbá
tím, že je jednouživatelskou jednovláknovou dílnou.

## Registry a flags jsou krátkodobým úložištěm

PROMETHEUS nemá univerzální calling convention. To ztěžuje čtení, ale v programu
navrženém kolem pečlivě lokálních smluv je to úsporné.

Helper může vracet:

- ukazatel v HL;
- počet v BC;
- klasifikaci v A;
- úspěch nebo inkluzivní porovnání v carry;
- „řádek byl odeslán“ v Z;
- alternativní hodnotu ve stínové bance registrů.

Pokud volající hodnotu stejně potřebuje pro následující operaci, její zápis do
trvalé proměnné a opětovné načtení by plýtvaly bajty i časem.

Také stack slouží jako přechodný záznam:

- průchod zdrojem ukládá současný a následující ukazatel;
- importer zachovává kontext připravené tabulky během odeslání parseru;
- instalátor používá SP jako čtečku konfiguračních delt;
- kontroly ochranných tabulek dočasně promění tabulku rozsahů ve stack;
- uložený stav uživatelského procesoru je záměrně uspořádán pro obnovu přes POP.

Tato úspora funguje, protože smlouvy jsou úzké a stroj neprovádí preemptivní
multitasking.

## Alternativní registry poskytují druhý malý workspace

`EXX` a `EX AF,AF'` dovolují PROMETHEU přepnout na druhé BC, DE, HL a AF, aniž
by je kopíroval do RAM.

Nejviditelněji z toho těží engine vykonávání monitoru. Musí zachovat jeden obraz
procesoru a současně používat druhou sadu registrů k sestavení trampoline a
dohledu nad ní. Další banku využívají také kazetové a vykreslovací cesty, když
musí současně zůstat živých několik ukazatelů.

Alternativní registry nejsou zadarmo: znesnadňují sledování toku řízení a
přerušení nebo ROMová rutina mohou zavést další pravidla. V 16KB assemblerovém
programu však představují šest bajtů rychlého implicitního úložiště vestavěného
do CPU.

## Bitmapa se stává workspace instalátoru

Při instalaci PROMETHEUS vymaže `$4000-$4FFF`. Tato oblast je běžně horní částí
bitmapové paměti Spectra, ale obyčejný editor ještě neběží.

Bootstrap ji používá pro:

- soukromý stack kolem `$4020`;
- dočasný stav;
- čistou zobrazovací oblast instalátoru.

Obrazovka tedy není pouze výstupním zařízením. Před vznikem rezidentní dílny je
to dostupná RAM s výhodnou známou adresou.

Po instalaci si editor a monitor tutéž fyzickou obrazovku přirozeně vezmou zpět
pro viditelné použití.

Jde o sdílení v čase, nikoli o překryv současně živých dat. Tytéž bajty slouží v
různých fázích života programu různým účelům.

## Zdroj, symboly a generovaný kód sdílejí jednu pohyblivou hranici

Rezidentní suffix začíná tímto:

```text
statické slovníky a tabulka instrukcí
20 počátečních komprimovaných záznamů zdroje
počet symbolů a malý počáteční suffix symbolů/konce kódu
```

Když roste zdroj, základ tabulky symbolů se posouvá vzhůru. Když rostou záznamy
symbolů, společný konec se posouvá vzhůru. Výchozí generovaný výstup začíná těsně
nad tímto koncem.

Koncepčně:

```text
nízké adresy
    rezidentní PROMETHEUS
    komprimované záznamy zdroje       rostou vzhůru
    tabulka symbolů                   přesouvá se a roste vzhůru
    značka konce kódu
    bajty generovaného programu       umístěny ve volné paměti
    ...
    U-TOP
vysoké adresy
```

Uspořádání se vyhýbá pevným rezervacím typu „4 KB pro zdroj, 2 KB pro symboly,
8 KB pro kód“, z nichž by některá mohla zůstávat nevyužita, zatímco jiné
kategorii dojde místo.

Poměr místo toho určuje současný program.

Cenou je nutnost přesouvat paměť a opravovat ukazatele při vložení a růstu
symbolů. `insertByteRangeAtHLFromDE`, pomocné rutiny mazání a rutiny tabulky
symbolů tvoří malého správce paměti, který tuto pružnou hranici umožňuje.

## Ochrana je soustředěna do úzkých hrdel

Kompaktní programy mohou být nebezpečné, pokud si každý volající musí pamatovat
každé pravidlo paměti. PROMETHEUS místo toho umisťuje kontroly tam, kde se
sbíhají účinky.

Patří mezi ně:

- všechny generované bajty procházejí `emitByteAtAssemblyOutput`;
- růst zdroje a symbolů prochází kontrolami U-TOP;
- trasované instrukce procházejí predikcí READ/WRITE;
- generátor relokace odmítá nepodporované formy adresních bajtů;
- kazetové bloky používají společnou přípravu parametrů ROM;
- chyby parseru se vracejí přes uložený error stack.

Centrální kontrola stojí kód pouze jednou a chrání mnoho funkcí. Zároveň snižuje
počet mírně odlišných bezpečnostních implementací, které by bylo nutné udržovat.

## Posunuté počty a značky v datech šetří režii reprezentace

Několik formátů se vyhýbá samostatnému poli „typ“ nebo „prázdné“ volbou posunuté
hodnoty.

Příklady zahrnují:

- počty rozsahů ochranné tabulky;
- příkazy opakování v relokačním proudu;
- koncové bajty záznamů zdroje;
- délky deskriptorů;
- značku kurzoru `$01` uvnitř editovatelného řádku.

Konzument dat už zná kontext, takže jinak nevyužitá hodnota nebo bit mohou nést
řídicí informaci.

Je to kompaktní, lokální bajty se však bez čtecí rutiny obtížně interpretují.
Správná otázka nezní „co znamená `$30` všude?“, nýbrž „co zde s `$30` dělá
walker záznamů zdroje?“

## Program platí složitostí za úsporu paměti

Volby PROMETHEA nejsou zadarmo.

### Komprimovaný zdroj

Šetří paměť a opakované parsování, vyžaduje však encoder a expander.

### Ordinaly symbolů

Šetří opakované názvy, vyžadují však vektory, komprimaci a opravu ordinalů.

### Sdílená tabulka instrukcí

Zabraňuje duplicitní znalosti instrukcí, používá však husté deskriptory a pečlivá
pravidla vyhledávání.

### Samomodifikovaný stav

Šetří proměnné a instrukce, váže však význam dat na přesný tvar kódu.

### Pohyblivá oblast zdroje a symbolů

Pružně využívá volnou RAM, každé vložení však může přesunout rozsáhlý suffix.

### Volitelný prefix monitoru

Šetří 5 000 rezidentních bajtů, komplikuje však relokaci a patchování vstupu.

### Jeden parser pro mnoho funkcí

Vyhýbá se duplicitním front endům, import a obrácené disassemblování však musí
podstoupit nepřímou cestu přes text.

Návrh tedy není „chytré triky všude jen pro ně samé“. Je to síť záměrných
výměn:

```text
více lokální složitosti
výměnou za
méně duplicitního trvalého stavu a kódu
```

## Co PROMETHEUS nekomprimuje

Stejně poučné je všimnout si, kde program bajty utrácí.

- Dvacet prázdných záznamů zdroje zjednodušuje model okrajů editoru.
- Tabulka instrukcí je velká, protože sdílená deklarativní znalost stojí za uložení.
- Čelní panel má třicet čtyři deskriptorů, aby jediný renderer nahradil mnoho natvrdo napsané zobrazovací logiky.
- Chybová hlášení a názvy příkazů zůstávají dostatečně čitelné pro lidský nástroj.
- Monitor uchovává úplný obraz procesoru, protože vynechání alternativních registrů nebo stavu přerušení by činilo krokování zavádějícím.
- Relokační a konfigurační proudy existují, protože pohyblivá instalace je hlavní vlastností, nikoli dodatečným nápadem.

Dobré paměťové hospodářství neznamená nejmenší možný soubor. Znamená utrácet
bajty tam, kde odstraní větší náklady nebo zachovají podstatné chování.

## Stručný rozpočet myšlenek

```text
Šetři celé oblasti       volitelný 5 000bajtový prefix monitoru
Šetři opakovaný zápis    komprimovaný zdroj + ordinaly symbolů
Šetři duplicitní logiku  sdílený parser, expander, dekodér a tabulka instrukcí
Šetři šířku ukazatelů    samorelativní vektory a lokální delty
Šetři buňky proměnných   samomodifikované operandy/opcodes
Šetři dočasnou RAM       registry, alternativní banky a stack
Zabraň pevné režii       pohyblivá hranice zdroje/symbolů/kódu
Utrácej strategicky      padding záznamů, deskriptory, obraz procesoru, tabulky
```

## Co se změnilo v paměti

Tato kapitola nesledovala jediný příkaz, takže žádná jednotlivá operace paměť
nemění. Určila vlastnický model celého rezidentního systému:

- statické rezidentní bajty obsahují kód, tabulky a zapisovatelné operandy instrukcí;
- zdrojový text trvale existuje pouze jako komprimované záznamy;
- názvy symbolů existují jednou za vektory ordinalů;
- rozbalené řádky jsou dočasné;
- výstupní kód zabírá libovolnou bezpečnou oblast za dynamickým koncem zdroje a symbolů;
- oblasti obrazovky a stacku mění účel mezi instalací a rezidentním během;
- volitelná instalace může prefix monitoru zcela vynechat.

## Znovu propojené důležité labely a struktury

- `ENTRY_POINT_WITH_MONITOR`
- `ENTRY_POINT_WITHOUT_MONITOR`
- `sourceBufferStart`
- `sourceBufferAccessLine`
- `symbolTableDefaultPt`
- `varcSymbolTablePt`
- `varcCodeEndPt`
- `insertByteRangeAtHLFromDE`
- `lineBuffer`
- `encodeInputLineToSourceRecord`
- `expandSourceRecordToLineBuffer`
- `instructionTable.asm`
- `varcAssemblyOutputPointer`
- `emitByteAtAssemblyOutput`
- alternativní registry a struktury uloženého procesoru
- `internalStackTop`
- `relocatablePayloadEnd`

## Zpět k celému stroji

PROMETHEUS se vejde, protože jen zřídka uchovává současně nějaký fakt a všechny
možné podoby jeho prezentace.

Uchovává jeden název symbolu a mnoho malých ordinalů. Uchovává jeden popis
instrukce a používá jej v několika směrech. Uchovává kompaktní zdroj a text
rekonstruuje pouze tehdy, když jej potřebuje člověk. Uchovává stav procesoru jako
data a oživí jej pouze na okamžik vykonání.

Tato úspornost je zároveň hlavním zdrojem nebezpečí při úpravách programu. Bajt,
který vypadá nadbytečně, může nést druhý význam; rutina, která působí soukromě,
může sloužit třem subsystémům; pořadí tabulky může být součástí zakódování.

Následující kapitola promění tato pozorování v praktická pravidla úprav.
