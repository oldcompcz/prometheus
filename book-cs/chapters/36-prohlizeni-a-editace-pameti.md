# Kapitola 36: Prohlížení a editace paměti

Monitor si své jméno zaslouží tím, že zviditelňuje jinak neviditelný stav
stroje. Na nejnižší úrovni to znamená paměť.

PROMETHEUS nabízí tři související způsoby, jak bajty prohlížet nebo měnit:

1. malé živé pohledy do paměti vložené přímo do čelního panelu;
2. rolující číselné nebo znakové výpisy v konfigurovatelném okně výpisu;
3. interaktivní jednořádkový assembler, který zapisuje nový strojový kód na
   zvolenou adresu.

Nejde o tři kopie jedné rutiny. Panel používá interpret deskriptorů z kapitoly
34. Výpisy sestavují přesné dvaatřicetiznakové řádky ve sdíleném bufferu.
Editace vrací zadaný text do běžného řetězce zpracování assembleru.

Tato kapitola sleduje každou z těchto cest a nakonec je znovu spojí do jednoho
pracovního postupu pro prohlížení paměti.

## Nejmenší pohled už je na panelu

Deskriptory jako `(BC)`, `(DE)`, `(HL)`, `(SP)`, `(IX)`, `(IY)`, X a Y jsou
nepřímé paměťové položky.

Například pro `(HL)` platí:

```text
descriptor ukazuje na savedRegisterHL
renderer přečte slovo uložené na tomto místě
toto slovo se stane zdrojovou adresou v paměti
zobrazí se jedna nebo více hodnot
```

Pohled na panelu je užitečný pro zachování souvislostí. Může ukázat slovo na
zásobníku poblíž SP, bajt, na který ukazuje HL, nebo krátkou svislou oblast
začínající na X.

Jeho slabinou je prostor. Ani konfigurovatelná obrazovka 32 krát 24 znaků
nedokáže vedle registrů a disassembly výpisu zobrazit rozsáhlý dump. Delší
prohlížení proto používá okno výpisu.

## Jedno sdílené rolující okno výpisu

Obecná oblast monitoru pro výpisy je popsána deskriptorem
`frontPanelListWindowItem`. Její počátek na obrazovce a výška uložená v dolních
pěti bitech se čtou právě ve chvíli, kdy se přidává každý řádek.

Každá operace výpisu začíná takto:

```asm
beginMonitorListOutputWithBlankLine:
    call clearMonitorLineBuffer
```

Prázdný řádek se připojí jednou jako oddělovač od předchozího výstupu.

Další řádky procházejí rutinou `appendLineBufferToMonitorListWindow`. Ta:

1. zarovná nakonfigurovaný počátek na řádek o 32 sloupcích;
2. přečte nakonfigurovanou výšku;
3. posune existující bitmapové řádky nahoru;
4. zvolí nově odkrytý spodní řádek;
5. vykreslí přesně 32 bajtů z `lineBuffer`.

V pseudokódu:

```text
if listWindow.height == 0:
    return do monitoru

posuň řádky 1..height-1 do řádků 0..height-2
vykresli lineBuffer do spodního řádku
```

Mechanismus výpisu neví nic o paměťových bajtech, dekódovaných instrukcích ani
o položkách tabulek rozsahů. Volající pouze připraví řádek o 32 znacích.

Změna polohy nebo výšky deskriptoru panelu proto změní všechny příkazy výpisu,
aniž by bylo nutné měnit kterýkoli z nich.

## Sdílené je i pokračování

Po připojení řádku zavádí `outputMonitorListLineAndPollContinuation` rytmus
výpisů monitoru:

- držená klávesa nechá proudit další řádky;
- její uvolnění výpis pozastaví;
- další klávesa kromě EDIT pokračuje;
- EDIT se vrátí do monitoru.

Číselné, znakové i disassembly výpisy dědí stejné chování. Producent vrátí v HL
adresu další části paměti; výstupní smyčka rozhodne, kdy jej požádat o další
řádek.

Toto oddělení je užitečné:

```text
producent:  převeď stav na řádek o 32 sloupcích
spotřebitel: posuň okno, zobraz řádek a zeptej se, zda pokračovat
```

## Číselný výpis paměti

Příkaz L začíná na současné adrese monitoru. SYMBOL SHIFT+L se nejprve zeptá na
`First` a pak použije stejnou rutinu výpisu.

Každý řádek ukazuje pět bajtů v číselné a znakové podobě.

V šestnáctkovém režimu má přibližně tento tvar:

```text
#8000  #06 #05 #10 #FE #C9  .....
```

V desítkovém režimu vypadá podobně jako:

```text
32768  006 005 016 254 201  .....
```

Přesné mezery jsou zvoleny tak, aby výsledek zabral 32 sloupců.

Řádek začíná svou první adresou. Desítkové bajty mají vždy tři číslice.
Šestnáctkové bajty používají `#` a dvě číslice. Posledních pět polí ukazuje
stejné bajty jako znaky.

Algoritmus na vysoké úrovni je:

```text
repeat forever:
    vypiš počáteční adresu řádku

    repeat 5 times:
        vypiš další bajt jako desítkové nebo šestnáctkové číslo s pevnou šířkou

    vrať ukazatel na začátek řádku

    repeat 5 times:
        vypiš stejný bajt jako normalizovaný znak

    připoj řádek do okna výpisu
    pokračuj od adresy + 5
```

Návrat ukazatele je nutný, protože číselné formátování spotřebuje pět
paměťových bajtů dříve, než se začne sestavovat znaková polovina řádku.

## Podivný samostatný `$DD`

Rutina obsahuje:

```asm
    defb 0ddh
    ld hl,lineBuffer
```

Lineární čtení by mohlo `$DD` označit za zatoulaná data následovaná instrukcí
`LD HL,nn`. Z80 však `$DD` chápe jako prefix IX, takže se bajty vykonají jako:

```asm
    ld ix,lineBuffer
```

Zdroj ponechává prefix odděleně, protože stejná podoba bajtů je užitečná pro
rekonstrukci a protože původní rozložení musí zůstat přesné. Je to kompaktní
trik na rozhraní kódu a dat, nikoli náhodný neplatný bajt.

IX pak slouží jako cíl znaků, zatímco HL zůstává k dispozici jako ukazatel do
paměti nebo číselná hodnota.

## Na pevné šířce formátu záleží

Rolující dump paměti se čte obtížně, pokud pole mění svou šířku. PROMETHEUS
proto používá specializované pomocné rutiny s pevnou šířkou:

```text
adresa       5 desítkových číslic nebo # a 4 šestnáctkové číslice
bajt         3 desítkové číslice nebo # a 2 šestnáctkové číslice
```

Běžná rutina pro tisk desítkového čísla může vynechat počáteční nuly, ale
sloupce bajtů v dumpu to udělat nesmějí. `006` musí zabírat stejný prostor jako
`254`.

Jde o dobrý příklad zobrazovacího kódu, který prosazuje strukturální invariant:

```text
každý řádek má přesně 32 zobrazovacích buněk
```

Renderer okna výpisu vždy spotřebuje 32 bajtů, takže chybné mezery by nejen
vypadaly neupraveně; také by posunuly nebo ořízly znakovou polovinu.

## Normalizace znaků

`appendMemoryByteAsDisplayCharacter` zavádí stejnou politiku jako znakový
formátovač čelního panelu:

```text
dolních sedm bitů pod $20  → tečka
jinak                      → původní znak
původní bit 7              → zachová se jako stav inverzního obrazu
```

Kód přečte bajt dvakrát, aby mohl klasifikovat dolních sedm bitů a přitom
zachovat původní horní bit.

Příklady:

```text
$41  → A
$01  → .
$C1  → inverzní A
$81  → inverzní .
```

Řídicí bajty tak dostanou viditelnou náhradu, aniž by se ztratila informace
nesená bitem 7.

## Pouze znakový výpis

Příkaz O zahájí znakový výpis od současné adresy. SYMBOL SHIFT+O se nejprve
zeptá na počáteční adresu.

Řádek obsahuje jednu adresu a dvacet pět znakových buněk:

```text
#8000  HELLO.................
```

Přesný obsah samozřejmě závisí na paměti. Důležité jsou rozměry:

```text
pole adresy s pevnou šířkou
2 mezery
25 normalizovaných znaků z paměti
=
32 sloupců
```

Producent je jednodušší než u číselného dumpu:

```text
vypiš adresu řádku
repeat 25 times:
    připoj normalizovaný znak z paměti
připoj řádek
pokračuj od adresy + 25
```

Oba druhy výpisu se přirozeně přetočí z `$FFFF` na `$0000`. Žádné zvláštní
zastavení na konci paměti není potřeba, protože šestnáctibitová aritmetika sama
činí adresový prostor Z80 kruhovým.

## Výpisy čtou paměť přímo

Příkazy číselného a znakového výpisu nepoužívají konfigurovatelná ochranná okna
READ.

Po setkání s oblastmi „No read“ v datech monitoru může být tato skutečnost
překvapivá. Tyto tabulky patří především k mechanismu řízeného vykonávání
instrukcí, v němž PROMETHEUS předpovídá a kontroluje paměťové přístupy uživatelské
instrukce. Samostatné zobrazovací příkazy mají vlastní chování a v tomto případě
prostě přečtou požadované bajty.

Kapitola 38 ochranné politiky pečlivě rozliší. Prozatím si pamatujte:

```text
příkaz monitoru může paměť přímo prohlížet
    ≠
sledovaná uživatelská instrukce smí tuto paměť číst
```

Monitor sám je důvěryhodný; pod kontrolou je kód, který se krokuje.

## Změna paměti prostřednictvím assembleru

PROMETHEUS neposkytuje jen primitivní editor typu „zadej jeden bajt“. SPACE a E
promění editační řádek monitoru v jednořádkový assembler.

SPACE provede jednu editaci na současné adrese monitoru.

E zahájí souvislou editaci paměti: po sestavení každého zadaného řádku se
následující logická adresa stane počátkem dalšího řádku.

Je to mocná volba. Uživatel může zadat:

```asm
LD A,5
CALL ROUTINE
DEFB #00,#FF
```

místo aby každou instrukci ručně převáděl na bajty.

## SPACE: jednorázové sestavení

`monMemoryEditingOneShot` uloží současnou adresu do operandu instrukce:

```asm
initializeMonitorLineAssembler:
    ld hl,00000h
```

Potom vstoupí do `editOneMonitorAssemblyLine`.

Jak popsala kapitola 35, tato rutina změní `monitorInputCompletionDispatch` z
`JP nn` na `LD HL,nn`. Zadaný řádek se proto nevyhodnotí jako číselný expression.
Řízení propadne do `assembleMonitorInputLine`.

Cesta na vysoké úrovni vypadá takto:

```text
origin = současná adresa monitoru
edituj jeden běžný řádek zdroje assembleru
zakóduj jej do dočasného bufferu záznamu
spusť na tomto záznamu handler prvního průchodu
obnov origin
spusť handler druhého průchodu a emituj bajty
return do monitoru
```

Do uživatelova programu se nevloží žádný záznam zdroje. Běžným handlerům
assembleru stačí dočasný `encodedRecordHeader`.

## Znovu se používá běžný parser

Zadaný řádek prochází:

```asm
    call encodeInputLineToSourceRecord
```

přičemž zůstává vyhrazeno obvyklé devítisloupcové pole labelu. Monitorový
assembler proto přijímá stejný zápis instrukcí, třídy operandů, expressiony,
symboly a pseudo-instrukce, jaké už popsaly části II a III.

Také rutiny prvního a druhého průchodu jsou ty běžné:

```asm
    call firstPassProcessSourceRecord
    ...
    call secondPassEmitSourceRecord
```

Monitor nemá vlastní zjednodušený assembler.

Příkaz tím téměř zdarma získává jednotné chování:

- rozpoznávání mnemonic je totožné;
- odkazy na symboly jsou totožné;
- relativní posuny se počítají totožně;
- indexované instrukce CB dostávají stejnou opravu pořadí bajtů;
- výstup používá stejnou chráněnou cestu emise.

## Logický a fyzický origin jsou zde stejné

`initializeMonitorLineAssembler` zapíše zvolenou adresu do obou proměnných:

```text
varcAddressCounter
varcAssemblyOutputPointer
```

Instrukce zadaná v monitoru se tedy sestaví, jako by ležela na adrese, na kterou
se její bajty fyzicky zapisují.

To je důležité pro:

- expressiony s `$`;
- relativní skoky;
- labely nebo `EQU` uvnitř dočasného řádku;
- direktivy, jejichž výsledek závisí na čítači adresy.

Samostatný cíl ve stylu `PUT` neexistuje, ledaže zadaná direktiva sama změní
běžný stav assembleru.

## E: souvislé sestavování

`monMemoryEditing` začne jednorázovým nastavením a potom opakuje:

```text
načti zapamatovaný další origin
překresli disassembly panelu od tohoto originu
edituj a sestav jeden řádek
zapamatuj výsledný čítač adresy
repeat
```

Po úspěšném sestavení zkopíruje `assembleMonitorInputLine` novou logickou adresu
zpět do `initializeMonitorLineAssembler+1`. Byla-li na `$8000` zapsána
dvoubajtová instrukce, další prompt režimu E začne na `$8002`.

V pseudokódu:

```text
origin = currentAddress

loop:
    zobraz disassembly na origin
    line = editAssemblyLine()
    origin = assembleOneLine(line, origin)
```

EDIT opustí režim přes vstupní smyčku monitoru a vrátí se do `startMonitor`.

E tak působí jako malý sekvenční editor strojového kódu, přestože se každý
řádek samostatně zakóduje do dočasného záznamu.

## Proč se překresluje od postupující adresy?

Před každým řádkem souvislé editace volá PROMETHEUS
`redrawFrontPanelFromDisassemblyAddress` se zapamatovaným originem.

Trvalá současná adresa monitoru se nemusí po každém řádku potvrdit. Okno
disassembly výpisu přesto může ukazovat místo, které se bude právě editovat.

Toto rozlišení je užitečné:

```text
současná adresa monitoru      stabilní ohnisko navigace
origin souvislého sestavování pohybující se editační kurzor
```

Renderer přijímá právě proto explicitní vstup v HL, aby mohl zobrazit editační
kurzor bez změny celého stavu monitoru.

## Chyby zůstávají editovatelné

Chybná instrukce, neplatný operand nebo relativní posun mimo rozsah odejde přes
běžný chybový mechanismus assembleru. Monitorové pokračování po chybě z kapitoly
35 obnoví uložený zásobník promptu, zobrazí zprávu na editačním řádku panelu a
umožní tentýž řádek opravit.

Uživatel nespadne zpět do editoru zdroje jen proto, že se znovu použil běžný
encoder zdroje a handlery průchodů.

Příkaz mění cíl chyby, nikoli parser.

## Jaká paměť je při editaci chráněna?

Jednořádkový assembler monitoru emituje bajty stejnou cestou
`emitByteAtAssemblyOutput` jako sestavení zdroje. Tato cesta brání kolizi
výstupu s rezidentním obrazem PROMETHEA, komprimovaným zdrojem, tabulkou symbolů
a nakonfigurovaným horním limitem uživatelské paměti.

To se liší od konfigurovatelné tabulky ochrany WRITE monitoru, která se používá
při kontrole krokovaných uživatelských instrukcí. Jednořádkový assembler se řídí
vlastními pravidly bezpečnosti výstupu assembleru.

Na rozdílu opět záleží:

```text
bezpečnost výstupu assembleru
    chrání PROMETHEUS a jeho uložené programové struktury

okna WRITE monitoru
    omezují předpovězené paměťové účinky krokovaného uživatelského kódu
```

Oba systémy sledují příbuzný cíl, ale slouží jiným uživatelům.

## Praktická cesta prohlédnutí a opravy

Předpokládejme, že současná adresa je `$8000` a obsahuje:

```text
06 05 10 FE C9
```

Disassembly na panelu ukáže:

```asm
LD B,5
DJNZ #8002
```

Stisk L zobrazí bajty číselně i jako znaky. Stisk O nabídne širší pouze znakový
pohled, který je užitečnější, pokud oblast obsahuje text místo kódu.

Nyní předpokládejme, že první instrukce má načíst 10 místo 5. SPACE otevře
jednořádkový assembler na `$8000` a uživatel zadá:

```asm
LD B,10
```

PROMETHEUS zakóduje dočasný záznam zdroje, provede oba běžné průchody assembleru
a zapíše:

```text
06 0A
```

Po návratu do monitoru se změna okamžitě projeví v překresleném disassembly
výpisu. Nový výpis L potvrdí změnu bajtu.

Celá interakce vypadá takto:

```text
panel poskytne místní souvislosti
    ↓
L nebo O nabídne delší pohled do paměti
    ↓
SPACE nebo E přijme text assembleru
    ↓
běžný parser a assembler emitují bajty
    ↓
panel a výpisy odhalí výsledek
```

Monitor není pouhý hexadecimální dump s příkazem POKE. Spojuje prohlížení paměti
přímo s jazykem assembleru.

## Proč se zadaný řádek neukládá do zdroje?

Oprava provedená v monitoru bývá často experimentální nebo dočasná. Automatické
vložení do komprimovaného zdroje editoru by přineslo několik problémů:

- na kterou pozici ve zdroji se má vložit?
- má nahradit existující záznam?
- co když adresa leží mimo sestavený program?
- má se dočasná oprava breakpointu stát trvalou součástí zdroje?

PROMETHEUS proto obě operace odděluje:

```text
sestavení v editoru zdroje  → trvalý záznam zdroje, sestavený později
sestavení řádku v monitoru  → dočasný záznam, okamžitá emise bajtů
```

Kapitola 40 ukáže opačnou operaci: disassemblovanou paměť lze na výslovnou
žádost uživatele převést do zdroje.

## Buffer výpisu jako rozhraní

Číselný i znakový výpis sestavují své řádky v `lineBuffer` ještě před výstupem
na obrazovku. Toto rozhraní má několik výhod:

- formátování nemusí znát současnou bitmapovou adresu okna výpisu;
- rolování nemusí vědět, jak byl řádek vytvořen;
- tiskové a disassembly cesty mohou znovu používat podobnou tvorbu řádků s
  pevnou šířkou;
- dotaz na pokračování proběhne až po dokončení jednoho logického řádku.

V celém PROMETHEU se opakuje stejný architektonický vzor:

```text
vytvoř kanonickou mezilehlou podobu
    ↓
předej ji sdílenému mechanismu cíle
```

U zdroje byla kanonickou podobou komprimovaný záznam nebo editovatelný řádek. U
výpisů monitoru je jí řádek o 32 znacích.

## Co se změnilo v paměti?

Číselné a znakové výpisy mění:

- `lineBuffer`;
- bitmapové buňky okna výpisu;
- sdílený stav polohy tisku;
- dočasné formátovací buffery.

Paměť, kterou vypisují, nemění.

SPACE a E navíc mění:

- `encodedRecordHeader` a dočasné úložiště parseru;
- operandy originu jednořádkového assembleru monitoru;
- běžné čítače assembleru a ukazatele výstupu;
- cílové paměťové bajty emitované sestaveným řádkem.

Souvislý režim E uchovává další origin uvnitř
`initializeMonitorLineAssembler+1`.

## Myšlenky potřebné v dalších kapitolách

- Okno výpisu je obecný rolující cíl o 32 sloupcích.
- Příkazy přímého výpisu paměti obcházejí okna READ pro vykonávání.
- Monitorové sestavování používá běžný parser zdroje a oba běžné handlery
  průchodů.
- Monitor rozlišuje ohnisko navigace od pohybujícího se originu souvislé
  editace.
- Další producenti budou moci paměť vyhledávat, přesouvat, vyplňovat, chránit a
  disassemblovat se stejnými konvencemi adres a výpisů.

## Pokrytí zdroje

Tato kapitola vysvětluje `frontPanelListWindowItem`,
`beginMonitorListOutputWithBlankLine`, `appendLineBufferToMonitorListWindow`,
`renderLineBufferAtMonitorListCursor`, číselný výpis paměti, znakový výpis
paměti, `appendMemoryByteAsDisplayCharacter`, `monMemoryEditingOneShot`,
`editOneMonitorAssemblyLine`, `initializeMonitorLineAssembler`,
`assembleMonitorInputLine` a souvislý `monMemoryEditing`.

---
