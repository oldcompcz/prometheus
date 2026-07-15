# Kapitola 51: Bootstrap odolný vůči relokaci

Bootstrap má obtížný úkol a téměř žádnou volnost.

Je prvním kódem vykonaným z instalačního obrazu, neví však, kam byl tento obraz
ve skutečnosti načten. Dosud nemůže použít absolutní adresu žádného vlastního
labelu. Musí si vytvořit dočasnou pracovní paměť, zjistit svůj fyzický základ,
najít bajty instalátoru, které jej v bloku CODE následují, zkopírovat je na
`$5000` a skočit tam.

To vše zvládne v pouhých několika desítkách bajtů.

Zde je úplný ústřední fragment:

```asm
bootstrapEntry:
    di
    ld hl,VRAM_ADDRESS
    ld de,VRAM_ADDRESS+1
    ld bc,00fffh
    ld (hl),l
    ldir
    call ROM_ImmediateRET

bootstrapRecoverLoadAddress:
    dec sp
    dec sp
    pop bc
    ld hl,bootstrapEntry-bootstrapRecoverLoadAddress
    add hl,bc
    ld sp,VRAM_ADDRESS+0x20
    push hl
    ld hl,00017h
    add hl,bc
    ld bc,relocationSecondStreamTerminatorAndLogoStart+1-installerEntryAt5000
    ldir
    jp LOADER_ADDRESS
```

Parafráze řádek po řádku by jeho eleganci spíše zakryla. Po dokončení
jednoho úkolu je několik registrů už nastaveno přesně pro následující. Vymazání
obrazovky připraví
současně oblast stacku i cíl instalátoru. `CALL` rutiny ROM, která nic nedělá,
vytvoří fyzickou adresu. Dokonce i návratová adresa, která už byla ze stacku
vyzvednuta, se znovu získá z nedotčených bajtů pod SP.

Rozvineme tuto posloupnost jako příběh.

## Omezení: vlastním labelům zatím nelze důvěřovat

Bootstrap je sestaven s:

```asm
org INSTALLATION_ADDRESS
```

kde `INSTALLATION_ADDRESS` historicky odpovídá `$5DC0`. Blok CODE však může být
načten i jinam.

Instrukce jako:

```asm
ld hl,someBootstrapLabel
```

by obsahovala adresu vypočtenou pro `$5DC0`, nikoli fyzickou adresu, na níž se
bajty právě vykonávají. Bootstrap se proto vyhýbá absolutním odkazům na své
vlastní umístění za běhu.

Bezpečně může používat adresy, které jsou na Spectru skutečně pevné:

- bitmapu obrazovky `$4000`;
- vstup ROM `$0052`;
- pevný dočasný cíl instalátoru `$5000`.

Může také používat **rozdíly mezi labely**. Posunou-li se dva labely společně,
jejich vzdálenost se nezmění.

Na tom stojí výpočet vlastní polohy.

## Krok 1: zakázat přerušení

První instrukce je:

```asm
    di
```

Bootstrap se chystá nahradit SP, vymazat pracovní paměť, znovu získat bajty pod
ukazatelem stacku a provést dlouhé kopírování. Maskovatelné přerušení během těchto
operací by vložilo návratovou adresu na právě aktivní dočasný stack a vstoupilo do
obsluhy přerušení ROM s napůl připraveným stavem.

Přerušení zůstávají zakázána po celou instalaci. Rezidentní program později
nastaví vlastní zamýšlenou politiku.

## Krok 2: vymazat 4KB workspace

Kód připraví standardní jednobajtové vyplnění pomocí `LDIR`:

```asm
    ld hl,VRAM_ADDRESS       ; $4000
    ld de,VRAM_ADDRESS+1     ; $4001
    ld bc,00fffh             ; 4095 following bytes
    ld (hl),l
    ldir
```

Protože HL je `$4000`, jeho dolní bajt L je nula. Instrukce:

```asm
ld (hl),l
```

tedy uloží nulu na `$4000`, aniž by potřebovala `XOR A` nebo samostatné načtení
literálu.

`LDIR` pak tuto nulu opakovaně kopíruje dopředu:

```text
$4000 -> $4001
$4001 -> $4002
$4002 -> $4003
...
```

Protože každý nově zapsaný bajt je opět nula, operace vyplní nulami:

```text
$4000 až $4FFF
```

Jde o spodní dvě třetiny bitmapy Spectra, nikoli o soubor atributů. Na obrazovce
tím vymaže příslušnou zobrazovací oblast. Uvnitř programu vytvoří čistou dočasnou
RAM pro:

- soukromý stack instalátoru poblíž `$4020`;
- logo a zobrazovací práci instalátoru;
- pevný cíl instalátoru začínající na `$5000`, tedy přesně tam, kde po vyplnění
  skončí DE.

Tato konečná poloha registru přináší důležitou úsporu.

## Ukazatel cíle zdarma

Na začátku vyplňování:

```text
DE = $4001
BC = $0FFF
```

`LDIR` zvýší DE při každém zkopírovaném bajtu. Po 4 095 kopiích:

```text
DE = $5000
```

Následující hlavní operace potřebuje zkopírovat instalátor právě na `$5000`.
Bootstrap už neprovádí další `LD DE,$5000`; smyčka mazání obrazovky cílovou adresu
spočítala za něj.

To je typický trik PROMETHEA: konečná hodnota registru je součástí následujícího
algoritmu, nikoli bezcenným zbytkem po předchozím.

## Krok 3: požádat RET, aby prozradil fyzické PC

Z80 nemá běžnou instrukci ve významu „načti současný program counter do
registru“. `CALL` však nabízí nepřímou cestu.

Bootstrap vykoná:

```asm
    call ROM_ImmediateRET
```

`ROM_ImmediateRET` je adresa `$0052`, která obsahuje obyčejnou cestu přes `RET`
vhodnou právě pro tento účel.

`CALL` provede dvě věci:

1. uloží na stack adresu instrukce následující za `CALL`;
2. skočí na cíl.

ROM okamžitě vykoná `RET`, který stejnou adresu ze stacku vyzvedne a vrátí se.

Koncepčně:

```text
CALL uloží fyzickou adresu bootstrapRecoverLoadAddress
RET v ROM ji vyzvedne a pokračuje na ní
```

Užitečná adresa zdánlivě ze stacku zmizela. `POP` však mění SP; nemaže dva bajty
v RAM, v nichž bylo slovo uloženo.

Bootstrap ví, že tyto bajty stále leží těsně pod obnoveným SP.

## Krok 4: znovu otevřít spotřebované návratové slovo

Bezprostředně po návratu z ROM následuje:

```asm
bootstrapRecoverLoadAddress:
    dec sp
    dec sp
    pop bc
```

Dvě instrukce `DEC SP` posunou ukazatel stacku zpět na staré návratové slovo.
`POP BC` je znovu přečte.

BC nyní obsahuje **fyzickou** adresu `bootstrapRecoverLoadAddress`, protože právě
sem se skutečný `CALL` vrátil bez ohledu na základ načtení.

Tento trik je dost jemný na to, aby si zasloužil zopakování:

```text
CALL vyrobil fyzickou adresu kódu
RET ji logicky spotřeboval
bajty zůstaly v RAM
DEC SP dvakrát je znovu odkrylo
POP BC je získal zpět
```

Nebyla zapotřebí žádná systémová proměnná Spectra ani předpokládaná adresa
načtení.

## Krok 5: převést jeden fyzický label na základ obrazu

Assembler dokáže vypočítat konstantní rozdíl:

```asm
bootstrapEntry-bootstrapRecoverLoadAddress
```

Jde o záporný displacement, protože `bootstrapEntry` leží dříve. Rozdíl nezávisí
na poloze načtení.

Bootstrap jej přičte k fyzické adrese v BC:

```asm
    ld hl,bootstrapEntry-bootstrapRecoverLoadAddress
    add hl,bc
```

Tedy:

```text
HL = physicalAddress(bootstrapRecoverLoadAddress)
     + (bootstrapEntry - bootstrapRecoverLoadAddress)

HL = physicalAddress(bootstrapEntry)
```

HL nyní obsahuje `physicalLoadBase`.

Je to první okamžik, kdy program ví, kde instalační obraz skutečně začíná.

## Malý číselný příklad

Předpokládejme, že blok CODE byl načten na `$8000` místo `$5DC0`.

Představme si, že `bootstrapRecoverLoadAddress` leží 16 bajtů za začátkem. Trik s
ROM vrátí:

```text
BC = $8010
```

Assemblerem vypočtený rozdíl labelů je:

```text
bootstrapEntry-bootstrapRecoverLoadAddress = -16 = $FFF0
```

Po sečtení:

```text
$8010 + $FFF0 = $8000    modulo 65536
```

Tentýž kód by získal `$5DC0`, `$6000`, `$A000` nebo jakýkoli jiný použitelný
základ načtení.

## Krok 6: vytvořit soukromý stack

Bootstrap nyní opustí stack volajícího:

```asm
    ld sp,VRAM_ADDRESS+0x20
```

Tím nastaví:

```text
SP = $4020
```

Vymazaná paměť obrazovky pod touto adresou se stane soukromým stackem. Bootstrap
pak uloží nově zjištěný fyzický základ načtení:

```asm
    push hl
```

Slovo se uloží na `$401E-$401F` a SP se změní na `$401E`.

Proč je uchovávat?

Instalátor zobrazí zjištěnou adresu načtení a později potřebuje fyzický ukazatel
na payload. Stack je levný způsob, jak hodnotu přenést přes počáteční kopírování
loga bez vyhrazení samostatné proměnné.

## Krok 7: fyzicky najít bajty instalátoru

BC stále obsahuje fyzickou adresu `bootstrapRecoverLoadAddress`, tedy instrukce
bezprostředně následující za `CALL` do ROM. Fyzické pořadí bajtů zdroje je při
buildu známé, takže k prvnímu bajtu segmentu instalátoru stačí malý konstantní
displacement:

```asm
    ld hl,00017h
    add hl,bc
```

Historická hodnota `$17` je vzdálenost od získané adresy za `CALL` k prvnímu
fyzickému bajtu kopírovanému jako instalátor.

Nejde o absolutní adresu. Je to offset uvnitř stejného načteného bloku CODE, takže
zůstává platný bez ohledu na to, kam blok dopadne.

Po přičtení:

```text
HL = fyzická zdrojová adresa bajtů instalátoru
DE = $5000, zděděné z LDIR mazajícího obrazovku
```

Zdroj i cíl jsou připraveny.

## Krok 8: vypočítat délku kopie symbolicky

Počet bajtů je zapsán jako výraz labelů:

```asm
    ld bc,relocationSecondStreamTerminatorAndLogoStart+1-installerEntryAt5000
```

Labely patří do logického pohledu instalátoru na `$5000`, jejich rozdíl je však
pouhou délkou v bajtech. Rozdíly na originu nezávisí.

V historickém obrazu činí tato délka `$07CD`, tedy 1 997 bajtů.

Kopírovaná oblast zahrnuje:

- kód instalátoru a interaktivní text;
- dekodér konfiguračních patchů;
- dekodér relokace a kompaktní proudy;
- počáteční část ocasu loga potřebnou pro rozložení instalátoru.

Přesná hranice je zvolena tak, aby měl kód vykonávaný na `$5000` k dispozici
všechen absolutní interní materiál, který tam potřebuje, zatímco HL po kopii
ukazuje na zbývající fyzická data loga a payloadu.

## Krok 9: zkopírovat na `$5000`

Druhé `LDIR` provede relokaci samotného instalátoru:

```asm
    ldir
```

Tato kopie je bezpečná, protože cílem je pevný workspace začínající na `$5000` a
zdrojem načtený instalační obraz na jeho fyzické adrese.

Poté platí:

```text
$5000...    obsahuje instalátor sestavený pro $5000
HL          ukazuje za zkopírovaný segment instalátoru ve fyzickém obrazu
DE          ukazuje za zkopírovaný instalátor na $5000
SP          je soukromý stack v paměti obrazovky
[SP]        stále obsahuje physicalLoadBase
interrupts  jsou zakázána
```

Na rozdíl od velkého kopírování rezidentního payloadu má tato bootstrapová kopie
jediný pevný cíl a malou známou délku.

## Krok 10: skočit, nikoli volat

Poslední instrukce je:

```asm
    jp LOADER_ADDRESS
```

kde `LOADER_ADDRESS` je `$5000`.

`CALL` by uložil návratovou adresu ze starého fyzického bootstrapu na soukromý
stack. Instalátor se tam nikdy nechce vrátit a takové slovo by narušilo záměrně
uložený základ načtení. `JP` čistě předá řízení zkopírovanému instalátoru.

Od této chvíle lze absolutním labelům instalátoru důvěřovat, protože jejich bajty
nyní leží přesně tam, pro které byly sestaveny.

## Bootstrap v prostém pseudokódu

```pseudocode
interruptsOff()

fillMemory($4000, $5000, 0)
# vedlejší účinek: ukazatel cíle nyní ukazuje na $5000

physicalAfterCall = callKnownROMRetAndRecoverOldStackBytes()
physicalLoadBase = physicalAfterCall +
                   (bootstrapEntry - bootstrapRecoverLoadAddress)

SP = $4020
push(physicalLoadBase)

installerSource = physicalAfterCall + $17
installerDestination = $5000
installerLength = installerLogicalEnd - installerLogicalStart
copyForward(installerSource, installerDestination, installerLength)

jump($5000)
```

Jediná fyzicky proměnná veličina je odvozena z návratové adresy `CALL`. Všechno
ostatní je:

- pevná adresa Spectra;
- pevný dočasný cíl;
- rozdíl mezi labely;
- offset uvnitř načteného obrazu.

Právě proto je bootstrap odolný vůči relokaci.

## První instrukce na `$5000`

Zkopírovaný instalátor začíná na `installerEntryAt5000`. Při vstupu HL stále
ukazuje do fyzického načteného obrazu za zkopírovaný segment. Instalátor nejprve
vykreslí dva řádky loga, čímž spotřebuje zbývající bajty loga a posune HL na
začátek rezidentního payloadu.

Poté vykoná:

```asm
    ex (sp),hl
```

Před výměnou:

```text
HL     = fyzická adresa rezidentního payloadu
[SP]   = fyzický základ načtení
```

Po výměně:

```text
HL     = fyzický základ načtení použitý pro desítkové zobrazení
[SP]   = fyzická adresa payloadu uchovaná až do stisku ENTER
```

Stack opět slouží jako nepatrná dvouhodnotová komunikační struktura mezi etapami.
Instalátor může zobrazit, kde byl blok CODE nalezen, a přitom zachovat přesný
zdrojový ukazatel potřebný pro konečné kopírování.

Kapitola 52 bude pokračovat od této výměny a prozkoumá interaktivní obrazovku i
její samomodifikovaná nastavení.

## Proč adresu nezískat ze systémových proměnných Spectra?

Loader mohl uložit adresu načtení do známé proměnné nebo ji předat v registru.
PROMETHEUS však na takové spolupráci nezávisí.

Trik s `CALL`/`RET` činí blok CODE samolokalizujícím i tehdy, když je spuštěn
jiným BASICovým loaderem nebo ručně načten na jinou adresu — za předpokladu, že
vykonávání začne jeho prvním bajtem.

Snižuje tím počet předpokladů za cenu chytré posloupnosti operací se stackem.

## Proč používat obrazovku jako stack?

Běžný stack patří prostředí volajícího a může ležet poblíž neznámého obsahu RAM.
Instalátor potřebuje známý bezpečný stack, zatímco přesouvá velké bloky a mění
adresy.

Bitmapa obrazovky je:

- pevně umístěna na `$4000`;
- zapisovatelná;
- okamžitě dostupná;
- už tak mazána pro instalační obrazovku;
- dočasná, dokud se nespustí rezidentní aplikace.

Použití `$4020` je proto úsporné. Vizuální vedlejší účinek je jednoduše součástí
přípravy obrazovky instalátoru.

## Kompaktní choreografie registrů

Úspornost bootstrapu lépe vynikne na časové ose registrů:

```text
počáteční stav
    HL,DE,BC neurčené

příprava vyplnění
    HL=$4000  zdrojová nula
    DE=$4001  cíl
    BC=$0FFF  počet

po vyplnění
    HL=$4FFF
    DE=$5000  už připravený cíl instalátoru
    BC=0

po získání adresy návratu z ROM
    BC=fyzická adresa bootstrapRecoverLoadAddress

po výpočtu základu
    HL=fyzická adresa bootstrapEntry

soukromý stack
    SP=$4020
    push HL uchová fyzický základ načtení

nalezení zdroje instalátoru
    HL=BC+$17
    DE stále $5000
    BC=počet bajtů instalátoru

po kopírování
    HL=fyzický bajt za zkopírovaným segmentem
    DE=$5000+délka instalátoru
```

Žádný registr se zbytečně znovu nenačítá, když jej předchozí úkol může zanechat s
hodnotou potřebnou pro úkol následující.

## Předpoklady selhání

Bootstrap je kompaktní mimo jiné proto, že předpokládá platné prostředí.

Očekává:

- zapisovatelnou RAM na `$4000-$57CC` pro obrazovkový workspace a instalátor;
- úplný blok CODE přítomný souvisle v paměti;
- zahájení vykonávání na `bootstrapEntry`;
- aby se zdroj a cíl `$5000` při tomto malém dopředném kopírování nepřekrývaly
  destruktivně;
- aby se vstup ROM `$0052` choval jako známý okamžitý návrat;
- žádné maskovatelné přerušení, protože bylo provedeno `DI`.

Nezobrazuje chyby ani nevyjednává alternativy. Interaktivní instalátor může
později hlásit stav a přijímat volby; bootstrap však nejprve musí vytvořit stabilní
místo, z něhož lze takový bohatší kód spustit.

## Zpět k celému stroji

Bootstrap řeší zdánlivě kruhový problém:

```text
aby mohl kód používat labely, musí vědět, kde je
aby zjistil, kde je, zdánlivě potřebuje labely
```

Kruh přeruší tím, že používá pouze:

- fyzickou návratovou adresu vytvořenou instrukcí `CALL`;
- relativní rozdíly mezi labely;
- pevné adresy Spectra;
- fyzické offsety uvnitř souvislého obrazu.

Výsledkem je běžný absolutní program na `$5000`.

Překročili jsme první instalační hranici:

```text
neznámé fyzické umístění
        -> samolokalizující bootstrap
        -> známá dočasná adresa instalátoru
```

Zbývající hranice jsou snazší, protože instalátor už má stabilní origin, soukromý
stack, ukazatel na rezidentní payload a skutečný základ načtení dostupný pro
zobrazení.

## Co se změnilo v paměti

Bootstrap změní:

- `$4000-$4FFF`, vymazané na nulu;
- SP, přesunutý na `$4020` a poté snížený uloženým slovem;
- `$401E-$401F`, obsahující fyzický základ načtení před výměnou v instalátoru;
- `$5000` a další adresy, vyplněné zkopírovaným segmentem instalátoru;
- HL, které končí na fyzickém bajtu za tímto segmentem;
- DE, které končí za zkopírovaným cílem instalátoru;
- stav přerušení, vynucený na DI.

Rezidentní payload zatím nekopíruje ani nerelokuje.

## Důležité labely, s nimiž jsme se setkali

- `INSTALLATION_ADDRESS`
- `VRAM_ADDRESS`
- `LOADER_ADDRESS`
- `ROM_ImmediateRET`
- `bootstrapEntry`
- `bootstrapRecoverLoadAddress`
- `bootstrapCopiedFragmentEnd`
- `installerEntryAt5000`
- `relocationSecondStreamTerminatorAndLogoStart`
- `installerDrawLogoRow`
- `installationAddressString`

## Myšlenky potřebné v dalších kapitolách

- `CALL` následovaný známým `RET` dokáže vyrobit fyzickou adresu kódu.
- Bajty vyzvednuté ze stacku zůstávají v paměti a lze je získat zpět posunutím SP.
- Rozdíly labelů zůstávají platné, když se celý fragment přesune.
- Vymazání obrazovky zanechá DE přesně na cíli instalátoru `$5000`.
- Vymazaná bitmapa poskytne soukromý dočasný stack.
- Výměna se stackem přenáší mezi bootstrapem a instalátorem fyzický základ načtení
  a zdrojový ukazatel payloadu.
- Po zkopírování na `$5000` může instalátor používat běžné absolutní labely.
