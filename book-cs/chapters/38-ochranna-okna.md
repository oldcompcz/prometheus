# Kapitola 38: Ochranná okna

Monitor strojového kódu svádí k nebezpečným pokusům. Uživatel jej může
nasměrovat na libovolnou adresu, měnit bajty, krokovat instrukce a volat rutiny,
jejichž chování ještě nemusí chápat. PROMETHEUS proto dovoluje popsat místa,
ze kterých trasovaný kód nesmí číst, do kterých nesmí zapisovat ani na nichž
nesmí vykonávat kód.

Stejný mechanismus rozsahů používá také k mírnějšímu účelu: disassembleru lze
sdělit, že určité adresy obsahují bajty nebo slova dat, nikoli instrukce.

Za klávesami 1 až 5 se skrývá pět editovatelných tabulek:

```text
1  zobrazovat jako DEFB
2  zobrazovat jako DEFW
3  neprovádět READ
4  neprovádět WRITE
5  neprovádět RUN
```

Na první pohled vypadají jako pět nesouvisejících funkcí. Uvnitř jde o pět
instancí jediného malého jazyka rozsahů a jeden společný editor tabulek.

## Viditelná myšlenka

Uživatelský rozsah obsahuje dva inkluzivní koncové body:

```text
First = $8000
Last  = $80FF
```

Rozsah zahrnuje 256 adres, včetně `$8000` i `$80FF`.

V každé tabulce může být uloženo až pět uživatelských rozsahů. Monitor je
zobrazuje jako očíslovaná okna 0 až 4. Nový rozsah se vloží klávesou I.
Číselná klávesa existující rozsah smaže.

Slovo *okno* je užitečné. Okno není samostatná oblast paměti ani zkopírovaný
buffer. Je to prostě dvojice čísel, skrze niž kontrola nahlíží na celý 64K
adresní prostor.

## Fyzická tabulka

Každá tabulka zabírá dvacet pět bajtů:

```text
+0      uložený počet
+1..4   skrytá dvojice First, Last
+5..8   uživatelské okno 0
+9..12  uživatelské okno 1
+13..16 uživatelské okno 2
+17..20 uživatelské okno 3
+21..24 uživatelské okno 4
```

Každá hodnota First nebo Last je little-endian slovo. Jedno uživatelské okno
proto zabírá čtyři bajty.

Zdroj tabulky READ začíná takto:

```asm
setReadProtectedAreas:
    defb 002h
    defw 0x0000, 0x0000
customReadProtectedAreas:
    defw 0x0000, 0x0000
    defw 0x0000, 0x0000
    defw 0x0000, 0x0000
    defw 0x0000, 0x0000
    defw 0x0000, 0x0000
```

WRITE a RUN používají stejný tvar. Stejně tak `defbDisassemblyAreaTable` a
`defwDisassemblyAreaTable`.

## Proč prázdná tabulka začíná dvojkou

Bajt s počtem obsahuje bias:

```text
uložený počet = 2 + počet viditelných uživatelských oken
```

Tedy:

```text
žádná uživatelská okna   uložený počet = 2
jedno uživatelské okno   uložený počet = 3
pět uživatelských oken   uložený počet = 7
```

Dvě přidané jednotky podporují dvě související interpretace.

Kód uživatelského rozhraní bias odečte a vidí:

```text
viditelný počet = uložený počet - 2
```

Kontrolní kód před každým testem jednou dekrementuje a vidí:

```text
počet testovaných rozsahů = uložený počet - 1
```

Proč jedna a nikoli nula, když je tabulka na obrazovce prázdná? Protože
obsahuje jeden skrytý rozsah.

## Neviditelné rezidentní okno

PROMETHEUS musí vždy chránit sám sebe, svůj komprimovaný zdroj a tabulku
symbolů. Jejich konečné adresy nejsou pevné:

- celý rezidentní obraz lze instalovat na jinou základní adresu;
- prefix monitoru lze vynechat;
- zdroj může růst;
- záznamy symbolů se mohou posouvat vzhůru.

Trvalá dvojice natvrdo zapsaných koncových bodů by brzy přestala platit.

Před každou kontrolou kód nahradí skrytou dvojici hodnotami:

```text
First = relokovaný začátek rezidentního PROMETHEA
Last  = současný konec rezidentního kódu + zdroje + symbolů
```

Tyto hodnoty pocházejí ze dvou samomodifikovaných operandů:

```asm
    ld hl,(emitByteAtAssemblyOutput+1)
    ld hl,(varcCodeEndPt+1)
```

První název může čtenáře zmást. `emitByteAtAssemblyOutput+1` se zde používá
proto, že operand na tomto místě obsahuje relokovaný začátek rezidentního
obrazu. Instalátor jej upravuje při přesunu PROMETHEA i při vynechání prefixu
monitoru.

`varcCodeEndPt+1` sleduje současný horní konec živého úložiště rezidentní
dílny.

Skryté okno tedy roste společně se zdrojem:

```text
rezidentní začátek  [ kód | zdroj | symboly ]  současný konec
^                                                        ^
First                                                    Last
```

Uživateli se nezobrazuje a nelze je smazat.

## Jeden editor pro všech pět tabulek

`testKeysForAreas` přijímá klávesy 1 až 5 a indexuje
`monitorRangeTablePointers`:

```asm
monitorRangeTablePointers:
    defw defbDisassemblyAreaTable
    defw defwDisassemblyAreaTable
    defw setReadProtectedAreas
    defw setWriteProtectedAreas
    defw setExecutionProtectedAreas
```

Vybraná adresa se poté předá stejnému mechanismu zobrazení a editace.

Jde o běžný návrhový vzor PROMETHEA:

```text
malá tabulka vybírá data
jedna obecná rutina je interpretuje
```

Přidání šestého druhu rozsahu by vyžadovalo především další tabulku a další
pointer, nikoli nový kompletní editor.

## Nadpis je uložen vedle tabulky

Bajt bezprostředně před každou tabulkou je textový token monitoru pro její
nadpis. Zobrazovací rutina se může od adresy počtu posunout o jeden bajt zpět a
vypsat správný název, aniž dostane další parametr.

Rozložení například koncepčně vypadá takto:

```text
[token "No READ"] [počet] [skrytá dvojice] [pět uživatelských dvojic]
```

Tabulka nese ve svém bezprostředním okolí dost kontextu, aby se sama představila.

## Zobrazení pouze uživatelských oken

`displayAndEditFiveRangeTable` přeskočí skrytou čtyřbajtovou dvojici. Hodnotu
`uložený počet - 2` chápe jako počet viditelných položek a každou vypíše takto:

```text
0  First  Last
1  First  Last
...
```

Formát čísel odpovídá současnému desítkovému nebo šestnáctkovému nastavení
monitoru. Pro seznam rozsahů se znovu použije tentýž řádkový buffer a mechanismus
seznamového okna jako pro výpisy paměti.

Skrytý rozsah se účastní kontrol, ale nikoli zobrazení. Právě toto oddělení
ukazuje, že bias počtu není jen úsporná kuriozita: udržuje synchronizované dva
pohledy na stejnou tabulku.

## Vložení okna

Stisk I v editoru rozsahů se zeptá na First a Last prostřednictvím běžného
čteče expressionů monitoru.

Postup je:

```text
if již existuje pět uživatelských oken:
    return do monitoru

vyžádej First
vyžádej Last
ulož obě hodnoty do dalšího nepoužitého slotu

if First <= Last:
    zvyš uložený počet
else:
    ponech počet beze změny

překresli tabulku
```

Dvojice se fyzicky zapíše ještě před potvrzením platnosti. Je-li First nad Last,
počet se nezvýší, takže slot zůstane logicky nepoužitý. Příští vložení jej
přepíše.

Tím se ušetří dočasný čtyřbajtový buffer. Dočasným bufferem je sám další
nepoužitý slot.

Nulově dlouhá okna neexistují, protože koncové body jsou inkluzivní. Rozsah s
`First == Last` chrání právě jednu adresu a je platný.

## Smazání okna

Klávesy 0 až 4 vybírají viditelné sloty. Vybraný slot a všechny následující
dvojice se pomocí `LDIR` posunou o čtyři bajty dolů a uložený počet se poté
sníží.

Viditelný index je třeba přeložit přes skrytou dvojici. Proto klávesa 0 mapuje
na fyzický offset +5, nikoli +1.

V pseudokódu:

```text
if selectedNumber >= visibleCount:
    ignoruj klávesu
else:
    přesuň pozdější čtyřbajtové dvojice dolů přes vybranou dvojici
    storedCount--
    překresli
```

Bajty ponechané v nepoužitém konci tabulky nejsou důležité. O tom, které dvojice
žijí, rozhoduje počet.

## Otázka překryvu rozsahů

Hlavní kontrola rozsahu dostává:

```text
BC = query First
DE = query Last
HL = adresa bajtu s počtem vybrané tabulky
```

Musí odpovědět na otázku:

> Dotýká se některá část query First..Last některého chráněného First..Last?

Dva platné inkluzivní rozsahy A a B jsou oddělené pouze tehdy, když:

```text
A.Last < B.First
or
B.Last < A.First
```

Každý jiný vztah znamená překryv, včetně rovnosti na kterémkoli koncovém bodě.

PROMETHEUS také považuje obrácený dotaz, v němž je query First nad query Last,
za chybu.

Srozumitelnější vysokoúrovňová verze rutiny vypadá takto:

```text
instaluj dynamický rezidentní rozsah do skrytého slotu

for each skrytý nebo uživatelský chráněný rozsah:
    if queryFirst > queryLast:
        return carry set

    if queryLast < protectedFirst:
        continue

    if protectedLast < queryFirst:
        continue

    return carry set

return carry clear
```

Nastavený carry znamená kolizi nebo chybný rozsah. Vynulovaný carry znamená, že
je dotaz vzhledem k této tabulce bezpečný.

## Tabulka se na chvíli stane stackem

Skutečná implementace používá odvážný trik Z80. Přesměruje SP do tabulky:

```asm
checkRangeAgainstProtectionTable:
    ld (restoreProtectionCheckStackAndReturn+1),sp
    ld a,(hl)
    inc hl
    ld sp,hl
```

Dvojice First/Last potom efektivně čte instrukcemi POP.

Než to udělá, zapíše skutečný SP volajícího do operandu pozdější instrukce:

```asm
restoreProtectionCheckStackAndReturn:
    ld sp,00000h
    ret
```

Nulové slovo se za běhu opraví. Každá výstupní cesta dospěje k této instrukci a
obnoví skutečný stack monitoru.

Postup lze chápat takto:

```text
zapamatuj skutečný SP uvnitř kódu
nasměruj SP na tabulku rozsahů
POP jednu dvojici za druhou
obnov skutečný SP z opraveného LD SP,nn
proveď běžné RET
```

V programu s přerušeními nebo nekontrolovaným opakovaným vstupem by to bylo
bezohledné. Monitor však přerušení zakazuje a vlastní soukromý stack, takže trik
zůstává uzavřený v bezpečném prostředí.

## Instalace skryté dvojice pomocí PUSH

Jakmile SP ukazuje na první dvojici, rutina zahodí placeholderová slova a poté
na přesně stejné místo vloží pomocí PUSH současné dynamické Last a First.

Tabulka se tedy před každou kontrolou skutečně přepisuje. Skryté bajty jsou
pracovní prostor, nikoli autoritativní konfigurace.

To je další důvod, proč se uživateli nezobrazují: jejich hodnoty jsou dočasné a
znovu se vytvářejí z živého stavu.

## Kontrola jediné adresy

Krokovací engine často potřebuje jednodušší otázku:

> Leží tato jediná adresa uvnitř některého zakázaného okna?

`checkAddressAgainstProtectionTable` dostane kandidáta v DE a použije stejnou
přípravu tabulky:

```text
nahraď skrytou dvojici současnými rezidentními hranicemi
prohledej skrytý rozsah a každý custom rozsah
return carry, pokud First <= address <= Last
```

Také přesměruje SP do tabulky a obnoví jej výstupem přes opravené `LD SP,nn`.

Obě kontroly záměrně sdílejí reprezentaci, ale nikoli veškerý porovnávací kód:

```text
kontrola rozsahu   používá se, když operace pokrývá First..Last
kontrola adresy    používá se pro jeden program counter nebo efektivní adresu
```

## Kde se prosazují READ, WRITE a RUN

Vlastní ochranná okna začnou působit v enginu trasovaných instrukcí, jsou-li
zapnuty kontroly instrukcí.

Před vykonáním uživatelské instrukce PROMETHEUS, jak ukážou pozdější kapitoly:

1. dekóduje instrukci;
2. určí, zda čte nebo zapisuje paměť;
3. vypočítá efektivní adresu;
4. zkontroluje tuto adresu proti tabulkám READ nebo WRITE;
5. zkontroluje cíle vykonávání proti tabulce RUN.

Výsledné zprávy jsou:

```text
Read/Write ERROR
Run ERROR
```

Samotná kontrola neví, proč byla zavolána. Pouze vrací carry. Krokovací engine
vybírá tabulku a chybový text.

## DEFB a DEFW používají stejná okna jinak

První dvě tabulky přístup nezakazují. Klasifikují paměť pro disassembler.

Na každé adrese se disassembler postupně ptá:

```text
uvnitř tabulky DEFB?  -> spotřebuj jeden bajt jako data
else uvnitř DEFW?     -> spotřebuj dva bajty jako little-endian slovo
else                  -> pokus se dekódovat instrukci Z80
```

Protože obě tabulky dostávají skrytý rezidentní/zdrojový rozsah a DEFB se
testuje jako první, vlastní bajty PROMETHEA se vždy zobrazují jako `DEFB` a
nikdy se nedekódují jako instrukce.

To odpovídá na otázku, která při zkoumání monitoru často vzniká:
**blokování nastává v `disassembleNextLineToBuffer`, ve větvi na carry po
`checkAddressAgainstProtectionTable` nad `defbDisassemblyAreaTable`.**

Příslušný tvar kódu je:

```asm
    ld hl,defbDisassemblyAreaTable
    call checkAddressAgainstProtectionTable
    jr c,.buildDefbDisassemblyRecord

    ld hl,defwDisassemblyAreaTable
    call checkAddressAgainstProtectionTable
    jr c,.buildDefwDisassemblyRecord
```

Rezidentní bajty se tím nestávají nečitelnými. Disassembler je pouze považuje za
data.

## Klasifikuje se jen počáteční adresa

Zásah DEFB spotřebuje jeden bajt. Zásah DEFW spotřebuje dva bajty. Kód testuje
pouze počáteční adresu položky.

Definuje-li tedy uživatel:

```text
okno DEFW $9000..$9000
```

slovo začínající na `$9000` přesto přečte svůj horní bajt z `$9001`, mimo okno.

Neexistuje ani požadavek na sudou adresu. Položka DEFW může začínat na `$9001`.

Okna říkají:

```text
když dekódování začne zde, zvol tento typ položky
```

Netvrdí, že vlastní každý bajt spotřebovaný touto položkou.

## Kontrola pouze rezidentní oblasti

Kapitola 37 představila `checkRangeAgainstResidentRegionOnly`. Ta si půjčuje
skrytý slot tabulky WRITE, ale dodává natvrdo zadaný biasovaný počet dvě.

To znamená, že se testuje přesně jeden syntetizovaný rozsah:

```text
začátek PROMETHEA .. současný konec kódu/zdroje/symbolů
```

Žádné uživatelské okno WRITE se neprojde.

Tento specializovaný wrapper používají důvěryhodné blokové operace jako MOVE a
FILL. Ukazuje, že sdílení formátu tabulky neznamená, že každý volající používá
každou její položku.

## Zotavení po chybě vrací čistý monitor

Při chybě ochrany PROMETHEUS neudělá jen to, že vypíše text a vrátí se přes
hluboký řetězec volání. Společný handler:

- sestaví příslušný tokenizovaný chybový řádek;
- překreslí jej v oblasti panelu;
- vyčistí příslušný stav monitoru;
- obnoví panel;
- pípne;
- čeká na stisknutí a uvolnění klávesy;
- znovu vstoupí do `startMonitor` s čerstvým soukromým stackem.

Poslední krok je důležitý, protože kontrola rozsahů a simulace instrukcí
používají neobvyklá uspořádání stacku. Teplý restart je bezpečnější než věřit,
že se každý vnořený řetězec volání po odmítnutém vykonání správně odvine.

## Zpět k celé funkci

Představme si, že uživatel chce prohlížet datovou tabulku a přitom bezpečně
krokovat rutinu:

```text
1. Klávesa 1: přidej $9000..$90FF jako DEFB.
2. Klávesa 3: přidej $9000..$90FF jako No READ.
3. Klávesa 4: přidej $9100..$91FF jako No WRITE.
4. Klávesa 5: přidej $5DC0..$9FFF jako No RUN.
5. Vypiš disassembly kolem $9000.
6. Krokuj kód, který se k těmto oblastem přibližuje.
```

Tatáž reprezentace čtyřbajtovou dvojicí nyní slouží dvěma různým příběhům:

```text
příběh disassembleru:
    adresy v tomto okně jsou data

příběh řízení vykonávání:
    trasovaný kód zde nesmí provádět tento druh přístupu
```

Skryté rezidentní okno se do obou příběhů přidává automaticky. V prvním brání
nesmyslnému disassemblování sebe sama. Ve druhém brání trasovanému programu
pošlapat vlastní monitor.

## Co se změnilo v paměti

Po vložení uživatelského okna:

- další nepoužitá čtyřbajtová dvojice uloží First a Last;
- biasovaný počet tabulky se zvýší o jednu.

Po smazání okna:

- pozdější dvojice se posunou o čtyři bajty dolů;
- počet se sníží;
- staré bajty za novým logickým koncem se ignorují.

Během každé kontroly:

- skrytá dvojice se přepíše současnými rezidentními First a Last;
- SP dočasně ukazuje do tabulky;
- skutečný SP se před návratem obnoví.

## Důležité navštívené labely

- `defbDisassemblyAreaTable`
- `defwDisassemblyAreaTable`
- `setReadProtectedAreas`
- `setWriteProtectedAreas`
- `setExecutionProtectedAreas`
- `customDefbDisassemblyAreas`
- `customDefwDisassemblyAreas`
- `customReadProtectedAreas`
- `customWriteProtectedAreas`
- `customExecutionProtectedAreas`
- `monitorRangeTablePointers`
- `testKeysForAreas`
- `displayAndEditFiveRangeTable`
- `checkRangeAgainstResidentRegionOnly`
- `checkRangeAgainstProtectionTable`
- `checkAddressAgainstProtectionTable`
- `restoreProtectionCheckStackAndReturn`
- `restoreAddressCheckStackAndReturn`

## Myšlenky potřebné v dalších kapitolách

- Chování trasovaných přístupů do paměti popisují kompaktní tabulky
  opcodů/přístupů a kontroluje se proti těmto oknům.
- Disassembler používá klasifikaci DEFB/DEFW před dekódováním instrukce.
- Skrytý rezidentní rozsah automaticky sleduje relokaci i růst zdroje.
- PROMETHEUS někdy promění obyčejnou datovou tabulku v dočasný stack Z80, aby
  ušetřil kód a zjednodušil iteraci.

---
