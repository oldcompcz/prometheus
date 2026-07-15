# Kapitola 53: Kopírování rezidentního obrazu

Stisknutí ENTER změní povahu instalátoru.

Až do této chvíle se choval jako malá interaktivní aplikace. Jeho
samomodifikované operandy popisují barvy, velikost písmen, tučné písmo, délku
kliknutí, volbu monitoru a zvolenou desetinnou adresu. Po ENTER se tato nastavení
potvrdí a instalátor provede nevratnou sekvenci:

```text
zkopírovat nastavení do fyzického payloadu
načíst cílovou adresu
zvolit úplný obraz nebo obraz pouze s assemblerem
připravit zvolené zdrojové rozložení
zkopírovat je na požadovaný cíl
relokovat interní absolutní slova
vytvořit rezidentní stack
vstoupit do nainstalovaného programu
```

Tato kapitola se soustředí na výběr a kopírování rezidentního obrazu. Příští
kapitola se podrobně vrátí k prvnímu kroku — konfiguračnímu patchování — protože
jeho průchod přes delty řízený stackem si zaslouží vlastní vysvětlení. Kapitola
55 potom otevře relokační proudy.

## Opuštění stroje překreslování

Každý běžný handler klávesy má na stacku syntetickou návratovou adresu. ENTER se
na ni nesmí vrátit:

```asm
.installerCheckEnterKey:
    cp 00dh
    ret nz
    pop af
```

Není-li A carriage return, `RET NZ` překreslí instalátor obvyklým způsobem.
Je-li klávesou ENTER, `POP AF` zahodí `installerRedrawAndWait`, syntetickou
návratovou adresu vloženou dispatcherem.

Dalším slovem na stacku je fyzický ukazatel payloadu, který se uchoval při první
výměně HL s `(SP)` v instalátoru:

```asm
    pop hl
    push hl
```

HL obdrží ukazatel pro okamžité konfigurační patchování. Znovu se uloží na stack,
protože jej bude později potřebovat fáze kopírování.

Toto slovo na stacku přežilo celou interaktivní relaci. Nebyla zapotřebí žádná
samostatná globální proměnná.

## Nastavení se potvrdí dříve, než se obraz přesune

Instalátor nyní navštíví čtrnáct označených bajtů nebo instrukcí uvnitř fyzického
payloadu s originem nula a změní je tak, aby odpovídaly náhledu. Udělá to *před*
kopírováním.

Toto pořadí je výhodné:

- stejná sekvence patchů funguje bez ohledu na konečný cíl;
- zvolené bajty se zkopírují spolu s rezidentním obrazem;
- žádnou konfigurační adresu není nutné nejprve relokovat;
- úplná kopie i kopie pouze s assemblerem obdrží všechna příslušná nastavení;
- cíle patchů lze vyjádřit relativně ke zdroji payloadu.

Po čtrnáctém patchi se obnoví dočasný stack konfigurační tabulky a desetinný cíl
se načte do HL.

## Načtení cíle

Znaky adresy jsou uloženy v `installationAddressString`. Čtení skončí na
podtržítku kurzoru:

```asm
.installerParseAddressDigit:
    ld a,(de)
    inc de
    cp 05fh
    jr z,.installerAddressParsed
```

Pro každou číslici:

```text
HL = HL * 10
HL = HL + číslice
```

Násobení používá pouze `ADD HL,HL` a jeden uložený mezivýsledek:

```asm
    add hl,hl
    push hl
    add hl,hl
    add hl,hl
    pop bc
    add hl,bc
```

Bylo-li původní HL rovno x:

```text
první ADD       -> 2x, později uloženo v BC
druhé ADD       -> 4x
třetí ADD       -> 8x
ADD uloženého 2x -> 10x
```

Potom se odečte ASCII `'0'` a číslice se přičte.

Výsledkem je šestnáctibitový cíl. Žádný samostatný typ rozsahu neexistuje;
přetečení se přetočí stejně jako při jakékoli jiné šestnáctibitové aritmetice
Z80.

## Obnovení rolí zdroje a cíle

Na `.installerAddressParsed` obsahuje HL požadovaný cíl. Uložený fyzický ukazatel
payloadu se vyzvedne do DE a registry se vymění:

```asm
.installerAddressParsed:
    pop de
    ex de,hl
```

Výsledkem je standardní konvence blokového kopírování Z80:

```text
HL = zdrojový payload
DE = cíl
```

Bajt volby monitoru se potom převede na carry:

```asm
    ld a,(varcMonitorInstallFlag+1-installerEntryAt5000+LOADER_ADDRESS)
    rrca
    push af
```

Jak vysvětlila kapitola 52:

```text
$4D -> bit 0 je 1 -> carry nastaveno   -> úplný obraz
$00 -> bit 0 je 0 -> carry vynulováno -> pouze assembler
```

AF se uloží, protože kopírování a relokace budou tuto podmínku později znovu
potřebovat.

## Úplný obraz je jediný objekt s originem nula

Při úplné instalaci začíná zdroj na:

```asm
ENTRY_POINT_WITH_MONITOR
```

a končí na:

```asm
relocatablePayloadEnd
```

Současný rekonstruovaný zdroj vyjadřuje délku symbolicky:

```asm
    ld bc,relocatablePayloadEnd-ENTRY_POINT_WITH_MONITOR
```

V historickém obrazu je to:

```text
$3E80 = 16 000 bajtů
```

Jeho pojmové rozložení je:

```text
offset payloadu $0000          vstup monitoru a prefix monitoru
offset payloadu $1388          vstup assembleru/editoru
offset payloadu $3E80          konec
```

Sestavení od originu nula znamená, že slova ukazující dovnitř obrazu zpočátku
obsahují offsety. Kopírování tyto offsety zachová. Relokace později přičte zvolený
cílový základ ke všem slovům, která skutečně představují interní adresy.

Je-li carry nastaveno, není nutná žádná práce s výběrem zdroje:

```asm
    jr c,.installerCopyImage
```

HL už ukazuje na první bajt payloadu a BC už obsahuje 16 000.

## Obraz pouze s assemblerem je přípona

Je-li carry vynulováno, prvních 5 000 bajtů se vynechá. Zachovaný zdroj začíná
na:

```asm
ENTRY_POINT_WITHOUT_MONITOR
```

Velikost prefixu vyjadřuje:

```asm
ENTRY_POINT_WITHOUT_MONITOR-ENTRY_POINT_WITH_MONITOR
```

Historicky je to:

```text
$1388 = 5 000 bajtů
```

Délka přípony je:

```asm
relocatablePayloadEnd-ENTRY_POINT_WITHOUT_MONITOR
```

neboli historicky:

```text
$2AF8 = 11 000 bajtů
```

Důležité není pouze to, že se kopíruje méně bajtů. Přípona byla linkována jako
součást úplného obrazu s originem nula a začíná na logickém offsetu `$1388`.
Když se nainstaluje samostatně, její první bajt se stane rezidentním offsetem
nula. Několik předpokladů proto vyžaduje záměrnou opravu.

## První oprava varianty pouze s assemblerem proběhne ve zdrojovém payloadu

Než se HL posune za prefix monitoru, instalátor patchuje jedno slovo ve fyzickém
zdrojovém obrazu:

```asm
installerPrepareAssemblerOnlyImage:
    push hl
    push de
    ld bc,emitByteAtAssemblyOutput+1-ENTRY_POINT_WITH_MONITOR
    add hl,bc
    ld e,(hl)
    inc hl
    ld d,(hl)
    ex de,hl
    ld bc,ENTRY_POINT_WITHOUT_MONITOR-ENTRY_POINT_WITH_MONITOR
    add hl,bc
    ex de,hl
    ld (hl),d
    dec hl
    ld (hl),e
    pop de
    pop hl
```

Kód najde slovo uložené v operandu na `emitByteAtAssemblyOutput+1`, přičte délku
prefixu monitoru a zapíše je zpět.

Nejde o obecnou relokační operaci. Je to převod rozložení potřebný proto, aby
stejné zachované tělo assembleru fungovalo i po odstranění jeho běžného kontextu
úplného obrazu.

Zdrojový i cílový ukazatel se kolem patche uchovají. Potom:

```asm
    add hl,bc
```

posune fyzický zdroj od začátku úplného payloadu ke vstupu varianty pouze s
assemblerem. BC se následně nahradí délkou přípony 11 000 bajtů.

V pseudokódu:

```text
if pouze_assembler:
    specialWord += monitorPrefixLength
    source       += monitorPrefixLength
    length        = assemblerSuffixLength
```

Druhý záměrný patch varianty pouze s assemblerem se provede po relokaci. Setkáme
se s ním v kapitole 55, protože jeho adresa se hledá relativně ke konečnému cíli
relokace.

## Proč nesestavit dva nesouvisející binární obrazy?

PROMETHEUS mohl na kazetě nést dva samostatně linkované rezidentní programy.
Instalace by byla jednodušší, ale kazetový obraz by se zvětšil a téměř veškerý
kód by se duplikoval.

Místo toho ukládá jeden úplný payload s originem nula a menší variantu z něj
odvozuje takto:

- vynechá prefix monitoru;
- změní aditivní relokační základ pro společnou příponu;
- provede dva záměrné kompatibilní patche.

Jde o prostorově úsporný design. Zároveň to znamená, že kód assembleru/editoru v
obou produktech tvoří doslova stejné bajty s výjimkou zdokumentovaných
patchovaných slov.

## Volba směru kopírování

Zdrojový payload je stále umístěn někde v načteném bloku CODE. Požadovaný
rezidentní cíl může ležet:

- pod ním;
- na stejné adrese;
- nad ním bez překryvu;
- nad ním s překryvem.

Naivní `LDIR` není v posledním případě bezpečné. Kopírování směrem vpřed by mohlo
přepsat zdrojové bajty dříve, než se přečtou.

PROMETHEUS porovná počáteční adresy:

```asm
.installerCopyImage:
    push de
    push hl
    xor a
    sbc hl,de
    pop hl
    jr c,.installerCopyImageBackward
    ldir
    jr .installerRelocateCopiedImage
```

Po `SBC HL,DE` je carry nastaveno, když zdroj leží pod cílem. Instalátor potom
zvolí kopírování směrem dozadu.

Pravidlo je o něco konzervativnější než úplný test překryvu:

```text
if destination <= source:
    kopíruj vpřed
else:
    kopíruj vzad
```

Leží-li cíl nad zdrojem, ale dostatečně daleko, aby se nepřekrýval, není zpětné
kopírování nutné, stále je však správné. Jednodušší porovnání šetří kód a pokrývá
nebezpečný případ.

## Kopírování vpřed

Když cíl neleží nad zdrojem, je `LDIR` bezpečné:

```asm
    ldir
```

Opakovaně provádí:

```text
(DE) = (HL)
HL++
DE++
BC--
```

dokud BC neklesne na nulu.

Tím se obslouží cíle pod zdrojem, včetně překrývajících se přesunů směrem dolů.
Bajt se přečte dříve, než jej může cokoli následujícího přepsat.

## Kopírování vzad

Pro cíl nad zdrojem se oba počáteční ukazatele převedou na inkluzivní koncové
ukazatele:

```asm
.installerCopyImageBackward:
    add hl,bc
    dec hl
    ex de,hl
    add hl,bc
    dec hl
    ex de,hl
    lddr
```

Pojmově:

```text
sourceEnd      = sourceStart + length - 1
destinationEnd = destinationStart + length - 1
kopíruj vzad
```

`LDDR` potom po každém bajtu ukazatele sníží. Bajty na horním konci se zajistí
dříve, než spodní konec cíle může přepsat jejich původní zdrojové pozice.

Jde o stejný princip `memmove`, který představila kapitola 7, nyní použitý na
vlastní rezidentní tělo programu.

## Původní cíl přežije kopírování

Před porovnáním ukazatelů instalátor provede:

```asm
    push de
```

Tento uložený cíl se po blokovém přesunu později vyzvedne do BC:

```asm
.installerRelocateCopiedImage:
    pop bc
    ld d,b
    ld e,c
```

Blokové instrukce zanechají HL a DE v pozicích závislých na směru. Uložené slovo
obnoví stabilní referenci:

```text
BC = nainstalovaný základ uchovaný pro aritmetiku a konečný vstup
DE = průběžný ukazatel cíle relokace, zpočátku na nainstalovaném základu
```

To je další důvod, proč neodvozovat sémantický význam z konečného stavu registrů
po `LDIR` nebo `LDDR`. Instalátor si hodnotu, kterou skutečně potřebuje, uchová
ještě před zahájením přesunu.

## Kopírování ještě nevytvořilo spustitelný obraz

Po přesunu jsou bajty na zvoleném fyzickém místě, ale absolutní interní slova
stále obsahují hodnoty s originem nula nebo offsety úplného obrazu.

Obsahuje-li například zkopírovaná instrukce slovo znamenající:

```text
adresa rezidentní rutiny na offsetu payloadu $2500
```

potom úplná instalace na `$8000` potřebuje:

```text
$2500 + $8000 = $A500
```

Instalace pouze assembleru potřebuje jinou opravu, protože její zkopírovaná
přípona se posunula dolů o `$1388`:

```text
offset úplného obrazu + cíl - $1388
```

Relokační proudy přesně kódují, ke kterým slovům se mají tyto hodnoty přičíst.
Displacementy JR a DJNZ, adresy ROM, adresy obrazovky, konstanty a označená data,
která pouze vypadají jako adresy, se měnit nesmějí.

Přesun a relokace jsou proto dvě samostatné operace:

```text
kopírování -> mění, kde bajty leží
relokace   -> mění vybraná adresní slova uvnitř těchto bajtů
```

## Vstup do nainstalovaného programu

Po relokaci a konečném kompatibilním patchi varianty pouze s assemblerem vytvoří
instalátor nový stack uvnitř rezidentního obrazu:

```asm
.installerStartRelocatedProgram:
    ld hl,00104h
    add hl,de
    ld sp,hl
    push bc
    ret
```

V tomto okamžiku je DE průběžný relokační ukazatel ponechaný na konečném cíli
druhého proudu a BC bylo obnoveno na zvolenou rezidentní vstupní adresu. Přičtení
`$0104` k tomuto konečnému cíli dosáhne v obou rozloženích na rezidentní
`internalStackTop`.

Sekvence:

```asm
    push bc
    ret
```

je kompaktní nepřímý skok. RET vyzvedne právě uložené slovo do PC.

V historickém úplném rozložení je konečným cílem rezidentní offset `$2CDD`, takže
stack vznikne na rezidentním offsetu `$2DE1`. V rozložení pouze s assemblerem se
obě pozice posunou dolů o vynechaný prefix `$1388`. Hodnota `$0104` je tedy
relativní ke konečnému cíli relokace, nikoli přímo k základu obrazu.

Stack je nyní uvnitř rezidentního programu, nikoli v dočasném workspace bitmapy.
Instalátor skončil a na jeho kódu na `$5000` už nezáleží.

Přerušení jsou stále zakázána bootstrapem. Rezidentní vstupní kód přebírá
odpovědnost za vytvoření runtime prostředí vhodného pro monitor nebo
assembler/editor.

## Fáze kopírování v pseudokódu

Pomineme-li detaily konfigurace a relokace, fáze výběru obrazu vypadá takto:

```text
destination = parseDecimalAddress()
source      = physicalPayloadStart

if monitorEnabled:
    length = payloadEnd - monitorEntry
    layout = FULL
else:
    uprav jedno zachované slovo assembleru pro použití přípony
    source += assemblerEntry - monitorEntry
    length  = payloadEnd - assemblerEntry
    layout  = ASSEMBLER_ONLY

ulož destination

if destination <= source:
    zkopírujVpřed(source, destination, length)
else:
    zkopírujVzad(source, destination, length)

obnov destination
relokuj podle layout
if je to potřebné, proveď zbývající kompatibilní patch varianty pouze s assemblerem
vytvoř rezidentní stack
skoč na nainstalovaný vstup
```

## Co se změnilo v paměti

Na konci fáze kopírování:

- fyzický payload obdržel zvolené konfigurační bajty;
- režim pouze s assemblerem změnil jedno slovo ve fyzickém zdroji přípony;
- na požadovaný cíl se zkopírovalo buď 16 000, nebo 11 000 bajtů;
- cíl se může bezpečně překrývat s původním blokem CODE;
- slova s originem nula uvnitř kopie stále čekají na relokaci;
- dočasný instalátor a logo zůstávají na `$5000` a v paměti obrazovky, po
  přenosu už však nejsou zapotřebí.

## Důležité labely, s nimiž jsme se setkali

- `.installerCheckEnterKey`
- `.installerParseAddressDigit`
- `.installerAddressParsed`
- `varcMonitorInstallFlag`
- `ENTRY_POINT_WITH_MONITOR`
- `ENTRY_POINT_WITHOUT_MONITOR`
- `relocatablePayloadEnd`
- `installerPrepareAssemblerOnlyImage`
- `emitByteAtAssemblyOutput`
- `.installerCopyImage`
- `.installerCopyImageBackward`
- `.installerRelocateCopiedImage`
- `.installerStartRelocatedProgram`

## Zpět k celému stroji

PROMETHEUS nyní existuje ve své konečné paměťové oblasti, ale zatím pouze jako
zkopírované bajty. Instalátor vyřešil problém fyzického přesunu a zvolil buď
úplnou dílnu, nebo její příponu assembleru/editoru.

Kopii obklopují dva druhy interních oprav:

1. **konfigurační patchování**, které zapíše uživatelem zvolené chování a vzhled
   do čtrnácti označených cílů;
2. **relokace**, která přepočítá každou skutečnou interní absolutní adresu na nový
   základ.

První vysvětlí následující kapitola. Druhá je tématem kapitoly 55.
