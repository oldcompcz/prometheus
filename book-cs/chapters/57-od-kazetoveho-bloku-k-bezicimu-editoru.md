# Kapitola 57: Od kazetového bloku k běžícímu editoru

Nyní už známe každý hlavní mechanismus instalační cesty. Tato kapitola je znovu
spojí dohromady.

Nejde o to představit další tabulku nebo další trik Z80. Budeme sledovat, jak
úplný řetězec pracuje jako jediný program:

```text
kazetové bloky
BASICový loader
fyzický obraz CODE
bootstrap
instalátor
konfigurace
kopírování
relokace
rezidentní vstup
teplý start editoru
čekání na klávesu
```

Na začátku je PROMETHEUS pouhou posloupností bajtů za hlavičkou CODE. Na konci
je živým vývojovým systémem se zdrojem, symboly, stavem obrazovky, soukromým
stackem a příkazovou smyčkou.

## Fáze 1: ROM najde BASICový program

Uživatel začíná běžným příkazem Spectra:

```basic
LOAD ""
```

ROM načte BASICovou hlavičku pojmenovanou `PROMETHEUS`, zjistí, že program má 54
bajtů, a uvidí číslo řádku autostartu 9999. Potom načte následující BASICový
datový blok a tento řádek spustí.

Program v paměti vypadá takto:

```basic
1 RANDOMIZE USR 24e3: STOP
9999 CLEAR 23999: LOAD "prometheus" CODE : RUN
```

Zdánlivě obrácené pořadí řádků je prvním malým prvkem choreografie. Autostart
začne na řádku loaderu; pozdější `RUN` se vrátí k volání strojového kódu na
řádku 1.

## Fáze 2: BASIC uvolní místo a načte obraz CODE

Řádek 9999 vykoná:

```basic
CLEAR 23999
```

BASIC tím slíbí, že pro svůj běžný programový workspace nebude používat paměť
na adrese 24 000 a výše.

Následuje:

```basic
LOAD "prometheus" CODE
```

ROM prohledává kazetu, dokud nenajde hlavičku CODE:

```text
název          "prometheus"
délka          18 356
adresa načtení 24 000 = $5DC0
```

Následující datový blok zkopíruje na `$5DC0`.

V této chvíli paměť obsahuje **distribuovaný instalační obraz**, nikoli hotový
rezidentní editor:

```text
$5DC0                         bootstrapEntry
...                           bajty instalátoru a metadat
$66F4                         fyzicky načtený rezidentní payload pro origin nula
$66F4 + $1388 = $7A7C         fyzická hranice varianty pouze s assemblerem
$66F4 + $3E80                 fyzický konec rezidentního payloadu
```

Adresy `$66F4` a `$7A7C` popisují historické fyzické rozložení při načtení.
Nejsou ještě konečnými linkovanými adresami, které bude používat rezidentní kód.

## Fáze 3: BASIC zavolá bootstrap

Příkaz `RUN` v loaderu znovu začne na řádku 1:

```basic
RANDOMIZE USR 24e3
```

PC se nastaví na `$5DC0`, nominální fyzickou adresu CODE.

První strojová instrukce se nachází zde:

```asm
bootstrapEntry:
    di
```

Přerušení zůstávají zakázána během celé zranitelné posloupnosti přesouvání a
patchování.

Bootstrap vymaže `$4000-$4FFF`, čímž vytvoří:

- prázdný bitmapový workspace;
- bezpečnou oblast pro dočasný stack;
- DE přirozeně nastavené na `$5000` po dokončení `LDIR`.

Zavolá okamžité `RET` v ROM, znovu zpřístupní již spotřebovanou návratovou adresu
a vypočítá skutečný fyzický základ načtení. Na historické kazetě je to `$5DC0`,
ale výpočet se na tuto pevnou hodnotu nespoléhá.

Potom:

```text
uloží fyzický základ načtení na stack na $4020
najde bajty instalátoru relativním displacementem
zkopíruje pevný segment instalátoru na $5000
skočí na $5000
```

Úloha BASICové vrstvy tím končí. I kdyby jiný loader umístil blok CODE jinam,
bootstrap by toto umístění objevil.

## Fáze 4: Instalátor najde rezidentní payload

Na `installerEntryAt5000` ukazuje HL do zbývajícího fyzického obrazu CODE.
Vykreslení dvou řádků loga spotřebuje přesně všechny zbývající bajty loga. HL se
potom ocitne na fyzickém začátku 16 000bajtového rezidentního payloadu.

Instalátor vymění tento ukazatel za fyzický základ načtení uložený na dočasném
stacku:

```text
HL       = fyzický základ načtení pro desetinné zobrazení
(SP)     = fyzický zdroj rezidentního payloadu pro ENTER
```

Výchozí hodnota pole adresy je:

```text
24000
```

protože historický obraz CODE byl načten na adresu 24 000.

Uživatel vidí instalátor a může změnit:

- konečnou instalační adresu;
- zahrnutí monitoru;
- vykreslování velikosti písmen;
- tučné vykreslování;
- délku kliknutí;
- normální a zvýrazňovací barvy;
- barvy související s borderem.

Každá přijatá klávesa se vrací přes syntetickou adresu překreslení, takže úplná
obrazovka vždy odpovídá současným samomodifikovaným nastavením.

## Fáze 5: ENTER převede viditelné volby na bajty payloadu

Po stisku ENTER instalátor analyzuje pět desetinných znaků adresy opakovaným
násobením deseti:

```text
hodnota = hodnota*10 + dalšíČíslice
```

Potom obnoví fyzický zdroj payloadu z dočasného stacku.

Před kopírováním projde čtrnáct vygenerovaných konfiguračních delt. Instalátor
zapíše vybrané opcodes, bajt prodlevy a atributy do fyzického payloadu
linkovaného pro origin nula.

Na tomto pořadí záleží:

```text
jednou opatchuj zdroj
potom zkopíruj vybrané rozložení
```

Stejná konfigurační posloupnost slouží úplné variantě i variantě pouze s
assemblerem. Cíle ležící pouze v monitoru lze opatchovat i tehdy, když budou
vzápětí vynechány; je to levnější než je obcházet větvením.

## Fáze 6A: Běžná úplná instalace

Ve výchozím nastavení je monitor povolen. Jestliže uživatel pouze stiskne ENTER,
vybere se toto rozložení:

```text
zdroj       fyzický rezidentní payload na $66F4
délka       16 000 bajtů
vstup       offset úplného payloadu $0000
```

Historickým výchozím cílem je `$5DC0`.

Protože cíl leží pod zdrojem, je dopředné `LDIR` bezpečné:

```text
zkopíruj $66F4-$A573 dolů na $5DC0-$9C3F
```

Přesný konec závisí na tom, zda používáme inkluzivní nebo exkluzivní zápis;
kopírovaná délka je `$3E80` bajtů.

Po přesunu začínají bajty na `$5DC0` takto:

```asm
ENTRY_POINT_WITH_MONITOR:
    jp startPrometheus
```

operand JP však stále obsahuje offset `$1F09` platný pro origin nula. Před
spuštěním jej musí opravit relokace.

## Fáze 6B: Varianta pouze s assemblerem

Jestliže uživatel přepne `Monitor:No`, instalátor nejprve provede předkopírovací
úpravu kompatibility přípony. Potom zvolí:

```text
zdroj       fyzický payload + $1388
délka       11 000 bajtů
vstup       původní ENTRY_POINT_WITHOUT_MONITOR
```

Tato původní přípona se zkopíruje na cílový offset nula.

Na historickém cíli `$5DC0` jsou prvními zkopírovanými bajty původní:

```asm
ENTRY_POINT_WITHOUT_MONITOR:
    jp startPrometheus
```

Pět tisíc bajtů monitoru chybí. Všechny bajty assembleru a editoru si zachovají
vzájemné relativní pořadí.

## Fáze 7: Zkopírovaná slova se naučí své skutečné adresy

Instalátor obnoví cíl a flag rozložení ze svého stacku.

### Úplná cesta

Pro úplnou instalaci platí:

```text
DE = rezidentní základ
BC = rezidentní základ
```

Instalátor použije proud 571 cílů monitoru, překlene mezeru od posledního cíle
monitoru `$11C0` k hranici assembleru `$1388` a potom použije proud 722 cílů
přípony.

Úvodní vstupní slovo se změní z:

```text
$1F09
```

na:

```text
$1F09 + $5DC0 = $7CC9
```

První instrukce na `$5DC0` se tedy stane:

```asm
jp $7CC9
```

`$7CC9` je historická adresa `startPrometheus` v úplném rozložení.

### Cesta pouze s assemblerem

Při instalaci pouze assembleru se proud monitoru přeskočí. Addend je:

```text
$5DC0 - $1388 = $4A38
```

Linkované slovo `startPrometheus` `$1F09` se změní na:

```text
$1F09 + $4A38 = $6941
```

To přesně odpovídá:

```text
cíl assembleru $5DC0
+ relativní offset přípony ($1F09-$1388)
```

Fallback slovo příkazu MONITOR se potom změní na `$5DC0`, takže volba MONITOR
nemůže skočit do chybějícího prefixu.

## Fáze 8: Dočasný instalátor předá řízení

Po druhém proudu ukazuje DE na poslední relokované slovo. Přičtení `$0104` vybere
rezidentní `internalStackTop` pro zvolené rozložení.

Instalátor obnoví BC na vybranou vstupní adresu a vykoná:

```asm
    ld sp,hl
    push bc
    ret
```

Instrukce RET se nevrátí do BASICu. Ze stacku načte právě vloženou rezidentní
vstupní adresu do PC.

Dočasný instalátor na `$5000` dokončil svou práci. Jeho obrazovkový workspace,
dočasný stack a destruktivně spotřebovaná relokační tabulka už nejsou součástí
běžícího programu.

## Fáze 9: Obě rozložení se setkají ve `startPrometheus`

Úplný vstup je:

```asm
ENTRY_POINT_WITH_MONITOR:
    jp startPrometheus
```

Vstup pouze s assemblerem je:

```asm
ENTRY_POINT_WITHOUT_MONITOR:
    jp startPrometheus
```

Jejich operandy JP byly relokovány různě, ale oba dosáhnou stejné logické rutiny
v bajtech, které byly skutečně zkopírovány.

Pro historický cíl platí:

```text
adresa startPrometheus v úplném rozložení          $7CC9
adresa startPrometheus pouze s assemblerem          $6941
```

Rozdíl přesně odpovídá vynechanému prefixu monitoru `$1388`.

Od této chvíle nemusí kód assembleru a editoru vědět, které rozložení jej
vytvořilo, s výjimkou opatchovaného fallbacku příkazu MONITOR.

## Fáze 10: Rezidentní startup převezme vlastnictví stroje

Společný vstup začíná:

```asm
startPrometheus:
    di
    ld e,SEPARATOR_CHARCODE
    call clearDisplay
```

Přerušení zůstávají zakázána. Rezidentní renderer vymaže obrazovku pomocí vlastní
nakonfigurované znakové a atributové infrastruktury.

Potom vykonávání propadne do:

```asm
prometheusWarmStart:
```

Cesta teplého startu:

1. vyplní atributy přístupového řádku nakonfigurovanou zvýrazňovací barvou;
2. vybere copyrightovou/stavovou zprávu;
3. vymaže sdílené buffery řádku, vstupu, operandů a formátování;
4. obnoví pohyblivý marker kurzoru `$01` ve vstupním bufferu;
5. obnoví jeho ochranný bajt `$80`;
6. znovu nastaví SP na `internalStackTop`;
7. vykreslí dvacet viditelných záznamů zdroje.

Oblast zdroje už obsahuje dvacet prázdných komprimovaných záznamů a prázdnou
tabulku symbolů, takže hned první výpis je strukturálně platný bez zvláštního
případu „dosud žádný program“.

## Fáze 11: Objeví se první obraz editoru

Viditelný stav editoru se skládá z mechanismů popsaných mnohem dříve v knize:

```text
komprimované prázdné záznamy zdroje
    -> procházení záznamů
    -> rozbalení záznamu
    -> vykreslení znaků do bitmapy Spectra

nakonfigurované atributy
    -> normální řádky, zvýrazněný přístupový řádek, stavový řádek

vstupní buffer
    -> ochranný bajt, marker kurzoru, prázdný editovatelný řádek
```

Instalační kapitoly nevytvořily samostatné uživatelské rozhraní pro spuštění.
Předaly řízení stejnému běžnému mechanismu teplého startu editoru, který se
používá také po mnoha příkazech a návratech z monitoru.

Právě díky tomuto opětovnému použití působí přechod okamžitě: instalátor zmizí a
běžný editor jednoduše vykreslí svůj současný stav.

## Fáze 12: PROMETHEUS čeká v `processKey`

Hlavní smyčka editoru znovu vykreslí editovaný řádek, obnoví border a zavolá:

```asm
processKey:
```

Klávesnicová rutina vstoupí do skenování a opakovací logiky ROM. V této chvíli
je instalace dokončena.

Úplná historická cesta dosáhla přibližně těchto adres:

```text
entry point  $5DC0
start        $7CC9
processKey   $8639
```

Historická cesta pouze s assemblerem dosáhne:

```text
entry point  $5DC0
start        $6941
processKey   $72B1
```

Fyzický obraz CODE může podle zvoleného cíle a překryvu stále zůstávat jinde v
paměti, ale živý program už na své instalační kopii nezávisí.

Uživatel nyní může:

- zadávat zdroj;
- sestavovat jej;
- ukládat a načítat jej;
- prohlížet paměť;
- používat monitor, pokud byl nainstalován;
- vykonávat nebo trasovat vygenerovaný kód.

Celá vývojová dílna ožila.

## Úplná cesta v pseudokódu

```text
ROM načte BASICový program
BASIC spustí autostart na řádku 9999

CLEAR 23999
LOAD "prometheus" CODE na adresu z hlavičky $5DC0
RUN
RANDOMIZE USR $5DC0

bootstrap:
    zakaž přerušení
    vymaž dočasný obrazovkový workspace
    zjisti skutečnou fyzickou adresu CODE
    zkopíruj instalátor na $5000
    skoč na $5000

installer:
    vykresli logo a volby
    nech uživatele zvolit cíl/nastavení/rozložení
    použij 14 konfiguračních patchů na fyzický payload

    if full:
        source = payloadStart
        length = 16000
    else:
        opatchuj slovo kompatibility přípony
        source = payloadStart + $1388
        length = 11000

    memmove(source, destination, length)

    if full:
        relokuj proud monitoru s addendem destination
        relokuj proud přípony s addendem destination
    else:
        relokuj proud přípony s addendem destination-$1388
        opatchuj fallback MONITOR na destination

    nastav SP na rezidentní internalStackTop
    skoč na vybraný rezidentní vstup

resident entry:
    JP na relokovaný startPrometheus

startPrometheus:
    vymaž obrazovku
    inicializuj teplý stav editoru
    vykresli okno zdroje
    čekej na první klávesu
```

## Stejný mechanismus funguje i mimo historické adresy

Rekonstruovaný testovací harness vykonal obě rozložení s několika kombinacemi
fyzické adresy načtení a cíle:

```text
načtení $5DC0 -> cíl $5DC0
načtení $5DC0 -> cíl $8000
načtení $8000 -> cíl $6000
načtení $8000 -> cíl $A000
```

Tyto případy pokrývají:

- historické umístění;
- dopředné kopírování;
- cíl nad zdrojem vyžadující zpětné kopírování;
- fyzické načtení na nehistorické adrese;
- úplnou relokaci i relokaci pouze assembleru.

Každý scénář dosáhne relokovaného vstupu, `startPrometheus`, úvodního vykreslení
obrazovky a rezidentní smyčky `processKey`.

Samostatný test změněného rozložení vloží bajty do prefixu monitoru i do části
assembleru. Znovu vygeneruje obě tabulky metadat, sestaví delší TAP a opět vykoná
oba instalační režimy. Dokazuje tak, že úspěšná cesta už nezávisí na zachování
každé historické adresy ve zdroji.

## Tři programy si předávají řízení

Úplný startup lze chápat jako postupné předávání vlastnictví:

### BASIC vlastní stroj

Rezervuje paměť, načte blok CODE a zavolá `$5DC0`.

### Dočasný instalátor vlastní stroj

Zakáže přerušení, použije obrazovkovou RAM jako workspace, vybere rezidentní
rozložení, opatchuje je, zkopíruje a relokuje.

### Rezidentní PROMETHEUS vlastní stroj

Založí svůj trvalý stack a dynamické paměťové struktury, vykreslí editor a čeká
na příkazy.

Žádný z těchto tří programů nemusí znát všechny podrobnosti následujícího.
Dohodnou se na úzkých smlouvách:

```text
BASIC -> fyzický vstup CODE
bootstrap -> instalátor na $5000 s uloženými fyzickými ukazateli
instalátor -> relokovaný rezidentní vstup s platným stackem
rezidentní vstup -> běžný teplý start editoru
```

Jde o kompaktní podobu vícestupňového načítání z doby dávno předtím, než byly na
domácích počítačích běžné moderní loadery spustitelných souborů a obrazy procesů
operačního systému.

## Co se změnilo v paměti

Během celé cesty:

- BASIC přesune svou hranici pod adresu 24 000;
- ROM umístí 18 356 bajtů CODE na fyzickou adresu načtení;
- `$4000-$4FFF` se stane dočasným workspace bootstrapu a instalátoru;
- instalátor se zkopíruje na `$5000`;
- čtrnáct fyzických polí payloadu dostane zvolené konfigurační hodnoty;
- 16 000 nebo 11 000 rezidentních bajtů se zkopíruje do vybraného cíle;
- 1 293 nebo 722 interních slov se přebázuje;
- podle potřeby se opatchují slova kompatibility varianty pouze s assemblerem;
- SP se přesune na rezidentní `internalStackTop`;
- zdroj, symboly a buffery editoru začínají ve svém počátečním rezidentním stavu;
- obrazovka se stane běžným editorem PROMETHEA.

## Důležité labely a vrstvy na cestě

- BASICový řádek 9999
- BASICový řádek 1
- adresa načtení CODE `$5DC0`
- `bootstrapEntry`
- `installerEntryAt5000`
- `relocatablePayloadStart`
- `ENTRY_POINT_WITH_MONITOR`
- `ENTRY_POINT_WITHOUT_MONITOR`
- `.installerRelocateCopiedImage`
- `installerApplyRelocationTable`
- `.installerStartRelocatedProgram`
- `startPrometheus`
- `prometheusWarmStart`
- `internalStackTop`
- `processKey`

## Zpět k celému stroji

Část VII začala otázkou: proč nelze PROMETHEUS jednoduše načíst a spustit?

Odpověď je nyní úplná. Kazeta nese distribuovaný instalační obraz, nikoli pevný
rezidentní executable. BASIC jej načte, pozičně nezávislý bootstrap zjistí jeho
polohu, instalátor vytvoří jedno ze dvou rezidentních rozložení, generovaná
metadata najdou konfigurační pole a pole citlivá na adresu a kompaktní dekodér
přebázuje vybraný obraz.

Teprve potom se spustí editor.

Zbývající hlavní kapitoly už nemusí odhalovat další velký subsystém. Mohou
ustoupit o krok zpět a prozkoumat celý návrh: jak editor, assembler, monitor,
vykonávací engine a instalátor opakovaně používají stejné kompaktní reprezentace
a jak se budoucí programátor může orientovat v úplném zdroji a upravovat jej,
aniž by tyto vazby ztratil.
