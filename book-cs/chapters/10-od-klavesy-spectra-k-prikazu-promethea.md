# Kapitola 10: Od klávesy Spectra k příkazu PROMETHEA

V předchozí kapitole jsme sledovali editor shora. Jeho hlavní smyčka jako by prováděla příjemně prostou operaci:

```text
přečti jednu klávesu
```

Za touto větou se skrývá nepříjemná skutečnost. Klávesnice ZX Spectra nepředá programu znak ASCII. Počítač nabízí matici elektrických spínačů. Současně mohou být stisknuty dvě klávesy. Klávesy SHIFT mění význam druhé klávesy. Jedna klávesa může zůstat fyzicky stisknutá po stovky průchodů procesorové smyčky. Editor musí rozhodnout, zda to znamená jediný znak, řídicí akci, nebo proud opakovaných akcí.

PROMETHEUS mění tuto neuspořádanou fyzickou událost v jediný čistý bajt.

Tento bajt může znamenat:

- obyčejný znak, například `a`;
- interpunkční znaménko, například `,`;
- ENTER nebo backspace;
- okamžitou řídicí akci editoru, například pohyb kurzoru nahoru;
- kompaktní příkazový token, například `$C1` pro `ASSEMBLY`.

Tato kapitola sleduje celý převod od klávesnicové matice až k dispatchi příkazu. Je to dobrá ukázka opakující se techniky PROMETHEA: několik vrstev postupně mění detail závislý na konkrétním stroji v malý interní jazyk.

## Celá cesta na jednom obrázku

Obyčejná klávesa editoru prochází těmito stupni:

```text
fyzické klávesy
    ↓
ROM scanner klávesnice Spectra
    ↓
surový index klávesy a třída modifikátoru
    ↓
překlad PROMETHEA
    ↓
pravidla CAPS LOCKu a velikosti písmen
    ↓
rozhodnutí nová klávesa / držená klávesa
    ↓
kliknutí a prodleva opakování
    ↓
jeden normalizovaný bajt
```

Příkaz zadaný pomocí SYMBOL SHIFTu může projít ještě jedním krokem:

```text
SYMBOL SHIFT + A na prázdném vstupním řádku
    ↓
písmeno A
    ↓
nastav bit 7
    ↓
příkazový token $C1
    ↓
commandHandlerTable[0]
    ↓
invokeAssembly
```

PROMETHEUS nepřenáší velkou strukturu popisující událost klávesnice. Nevrací oddělená pole pro „písmeno“, „modifikátor“ a „opakování“. Ve chvíli, kdy se `processKey` vrátí, jsou všechny tyto otázky již rozhodnuty.

## Matici ať skenuje ROM

Nejnižším wrapperem PROMETHEA je `getKeypressCodeOrZero`:

```asm
getKeypressCodeOrZero:
    push hl
    call ROM_KeyboardScanning
    pop hl
    jr z,.filterModifierOnlyKeypress
    xor a
    ret
```

Rutina používá scanner klávesnice v ROM Spectra, místo aby znovu implementovala celou klávesnicovou matici. Scanner vrací dvě důležité hodnoty:

- `E` určuje polohu klávesy;
- `D` popisuje stav modifikátorů.

Konvence ROM je úsporná, ale pro editor ještě není pohodlná. Dokáže vyjádřit „žádná klávesa“, samotnou klávesu SHIFT i kombinace s CAPS SHIFT nebo SYMBOL SHIFT. PROMETHEUS tyto případy filtruje, takže volající dostane jednoduchý test:

```text
A = 0      žádná použitelná událost klávesnice
A ≠ 0      E a D popisují použitelnou událost
```

Následující aritmetika vypadá záhadně, čteme-li ji jako obyčejné odčítání:

```asm
.filterModifierOnlyKeypress:
    ld a,e
    inc e
    ret z
    inc d
    ret nz
    ld a,e
    sub 019h
    ret z
    sub 00fh
    ret
```

Lépe se čte jako řetězec otázek nad zvláštními návratovými hodnotami ROM:

```text
Nebyla stisknuta vůbec žádná klávesa?
Je výsledkem pouze modifikátor?
Je to samotný SYMBOL SHIFT?
Je to samotný CAPS SHIFT?
```

Rutina nemusí vysvětlit, *která* obyčejná klávesa byla stisknuta. Pouze odmítne stavy, které samy o sobě nejsou užitečné.

To je první vrstva zjednodušení.

## Skutečným překladačem je `processKey`

Editor nevolá přímo rutinu ROM, ale `processKey`.

Na začátku čeká, dokud `getKeypressCodeOrZero` neohlásí použitelnou klávesu. Poté používá tabulky kláves v ROM pro obyčejné kombinace a vlastní tabulku pro interpunkci se SYMBOL SHIFTem.

Algoritmus na vyšší úrovni vypadá přibližně takto:

```text
repeat:
    oskenuj klávesnici

    if není použitelná klávesa:
        počkej na stabilní uvolnění
        vynuluj stav opakování
        continue

    přelož surový index klávesy a modifikátor
    použij inverzi velikosti písmen podle CAPS LOCKu

    if přeložená klávesa není platná:
        continue

    if je to stejná držená klávesa jako předtím:
        čekej do prahu opakování
    else:
        zapamatuj ji jako novou klávesu

    klikni
    proveď počáteční prodlevu
    return přeložený bajt
```

Důležité slovo je *přelož*. Opakování se řeší teprve poté, co se fyzická událost změnila v bajt zvolený editorem. `a`, `A`, pohyb kurzoru dolů i příkazový token tak mohou používat stejný základní mechanismus opakování.

## Obyčejné klávesy začínají v tabulkách ROM

PROMETHEUS připraví ukazatel těsně před tabulku kláves v ROM:

```asm
ld hl,ROM_Key_Tables-1
```

Index klávesy v `E` se stane offsetem do této tabulky. `-1` odpovídá jedničkovému číslování indexů používanému ROM.

Pro obyčejnou klávesu bez SHIFTu je kód v zásadě tento:

```text
znak = ROM_Key_Tables[indexKlávesy]
```

PROMETHEUS potom pro běžné psaní zdroje normalizuje písmena na malá:

```asm
set 5,a
```

V ASCII se kódy velkých a malých písmen liší bitem 5. Jeho nastavení změní `A` na `a`, `B` na `b` a tak dále. Totéž by změnilo i některé znaky, které nejsou písmeny, proto PROMETHEUS operaci provádí pouze ve větvi, kde je výsledek ROM znám jako obyčejná znaková třída.

Je to typická úspornost Z80. Moderní program by možná zavolal knihovní funkci pro převod znaků. PROMETHEUS použije jedinou bitovou operaci, protože reprezentace byla zvolena tak, aby to umožňovala.

## CAPS SHIFT vytváří řídicí kódy editoru

CAPS SHIFT nedělá pouze velké písmeno.

Doprovází-li číslici, PROMETHEUS převede kód číslice na malou řídicí hodnotu:

```asm
call isNumber
jr nz,.uppercaseCapsShiftLetter
sub 02dh
```

Například legendy kurzorových kláves Spectra jsou umístěny na číslicích. Překladač proto nevrátí viditelnou číslici, ale jeden z kompaktních řídicích kódů editoru.

Tyto kódy bezprostředně obslouží hlavní smyčka editoru nebo `updateInputBuffer`. Patří mezi ně například:

- kurzor doleva;
- kurzor doprava;
- kurzor nahoru;
- kurzor dolů;
- backspace;
- EDIT;
- CAPS LOCK;
- stránkový pohyb;
- smazání aktivního řádku zdroje.

Písmeno s CAPS SHIFTem jde jinou cestou:

```asm
call isLetter
jr nz,.applyCapsLockCaseInversion
res 5,a
```

Vynulování bitu 5 změní malé písmeno na velké.

CAPS SHIFT tedy není vrácen jako samostatný příznak. Jeho význam je již vložen do bajtu, který editor obdrží.

## CAPS LOCK PROMETHEA je záměrně neobvyklý

Spectrum již má známé chování velikosti písmen, PROMETHEUS však přidává vlastní trvalý stav CAPS LOCKu v operandu `varcCapsLockEnabled`:

```asm
varcCapsLockEnabled:
    ld a,000h
```

Po jinak dokončeném překladu písmene může tento stav obrátit jeho velikost:

```asm
call isLetter
jr nz,.compareLastPressedKey
ld a," "
xor b
```

Výraz působí zvláštně, dokud si nevšimneme, že se velká a malá písmena ASCII liší o `$20`, tedy o kód mezery. XOR s `$20` převrátí bit 5.

Stavový bajt se jinde přepíná mezi `$00` a `$F7`, nikoli mezi očekávatelnějšími `$00` a `$01`. Zde záleží pouze na tom, zda je nulový, nebo nenulový. Podivná hodnota `$F7` je zděděna z původní implementace.

Výsledek lze nejsnáze vyjádřit větou:

> PROMETHEUS nejprve uplatní význam fyzické kombinace se SHIFTem a teprve potom může jeho vlastní CAPS LOCK obrátit výslednou velikost písmene.

To se mírně liší od představy, že CAPS LOCK pouze znamená „drž CAPS SHIFT navždy“.

## SYMBOL SHIFT má dvě osobnosti

SYMBOL SHIFT obvykle vytváří interpunkci. PROMETHEUS ukládá tyto překlady v `symbolCharacters`:

```asm
symbolCharacters:
    defb "*", "^", "[", "&", "%", ">", "}", "/", ",", "-"
    defb "]", "'", "$", "<", "{", "?", ".", "+", 0x7f, "("
    ...
```

Přesné pořadí sleduje indexy kláves v ROM, nikoli abecední nebo vizuální pořadí. Tabulka obsahuje interpunkci, editační řídicí kódy a několik nulových položek pro kombinace, které PROMETHEUS nepoužívá.

SYMBOL SHIFT má však ještě druhou osobnost: na začátku jinak prázdného editačního řádku může SYMBOL SHIFT s písmenem vytvořit příkazový token.

Test je nádherně malý:

```asm
ld hl,inputBufferStart
ld a,(hl)
dec a
jr nz,.standardKeyPlusSSPressed
inc hl
or (hl)
jr nz,.standardKeyPlusSSPressed
```

Prázdný vstupní řádek editoru začíná:

```text
$01,$00
```

To znamená „značka kurzoru, potom terminátor“.

Kód odečte jedničku od prvního bajtu a výsledek ORuje s druhým bajtem. Konečný výsledek je nulový pouze pro `$01,$00`. Zvláštní překlad na příkazový token je tedy dostupný jen na skutečně prázdném řádku.

Přeložené písmeno potom dostane nastavený bit 7:

```asm
set 7,a
```

Je-li původním písmenem `A` až `Z`, vznikne `$C1` až `$DA`:

```text
'A' = $41    → $C1
'B' = $42    → $C2
...
'Z' = $5A    → $DA
```

Není to náhoda. Dispatcher tak získá hustý rozsah 26 položek indexovaných přímo abecedou.

## Proč jsou příkazy tokeny, a ne text

Představme si, že uživatel stiskne SYMBOL SHIFT+A.

Do vstupního bufferu se neuloží osm znaků slova `ASSEMBLY`. Uloží se jediný bajt:

```text
$C1
```

Při vykreslení řádku `displayInputTokenOrCharacter` rozvine tento bajt pomocí self-relative tabulky a vytiskne viditelné slovo.

Přináší to několik výhod:

- příkaz se zadá jedinou kombinací kláves;
- vstupní buffer spotřebuje jeden bajt místo celého slova;
- dispatch nemusí porovnávat řetězce;
- za příkazem lze stále zadat obyčejné argumenty;
- displej může zobrazit celý čitelný název příkazu.

Pohled uživatele a interní reprezentace se liší:

```text
obrazovka:    SAVE filename
buffer:       $D3 " filename" $01 $00
```

Je to stejná návrhová myšlenka, s níž se setkáme u komprimovaných záznamů zdroje: zachovat čitelné rozhraní, ale uvnitř ukládat reprezentaci optimalizovanou pro stroj.

## Několik příkazových tokenů se provede okamžitě

Ne každý příkaz čeká na ENTER.

Při vkládání do editačního bufferu kontroluje `updateInputBuffer` čtyři hodnoty tokenů:

```asm
cp 0c5h
ret z
cp 0c8h
ret z
cp 0cbh
ret z
cp 0d7h
ret z
```

Jsou to:

```text
$C5  E   přejdi na konec zdroje
$C8  H   přepni desítkové/hexadecimální zobrazení
$CB  K   přejdi na začátek zdroje
$D7  W   přepni režim vkládání/přepisování zdroje
```

`updateInputBuffer` se normálně vrací s vynulovaným zero flagem, což znamená „pokračuj v editaci“. Úspěšné porovnání ponechá zero flag nastavený a hlavní smyčka editoru to vyloží jako „odešli řádek právě teď“.

Tyto čtyři příkazy nepotřebují argument. Uživatel stiskne kombinaci kláves a výsledek uvidí okamžitě.

Ostatní tokeny zůstanou ve vstupním bufferu, aby mohl uživatel před stiskem ENTERu zadat parametry:

```text
FIND label
SAVE MYFILE
U-TOP 50000
```

Rozdíl není uložen v samostatné tabulce vlastností příkazů, ale ve čtyřech porovnáních uvnitř vkládací smyčky.

## Dispatch příkazu je aritmetika, nikoli hledání

Když ENTER odešle řádek, `submitInputLineOrDispatchCommand` přečte jeho první logický bajt.

Je-li bajt menší než `$80`, jde o obyčejný zdrojový text a řízení přejde do `parseAndInsertSourceLine`.

Je-li bajt `$C1` nebo vyšší, jde o příkazový token. Dispatcher vypočte adresu v `commandHandlerTable`:

```asm
ld h,0
ld l,a
ld de,commandHandlerTable-($c1*2)
add hl,hl
add hl,de
ld a,(hl)
inc hl
ld h,(hl)
ld l,a
jp (hl)
```

Čteno jako pseudokód:

```text
index = token - $C1
handlerAddress = wordAt(commandHandlerTable + index*2)
jump handlerAddress
```

Zdroj provádí odečtení nepřímo posunutím báze tabulky. Tím ušetří instrukce na často používané cestě.

Jakmile známe účel tabulky, je sama o sobě jasná:

```asm
commandHandlerTable:
    defw invokeAssembly
    defw invokeBasic
    defw invokeCopy
    defw invokeDelete
    ...
    defw invokeReplace
```

Indexem je abeceda:

```text
A → ASSEMBLY
B → BASIC
C → COPY
D → DELETE
...
Z → REPLACE
```

Některá písmena jsou aliasy nebo okamžité navigační operace. Tabulka zachovává jejich historické pozice, místo aby se snažila dát každému písmenu jedinečný význam.

## Připravená návratová adresa

Dispatcher používá `JP (HL)`, nikoli `CALL (HL)`. Z80 nemá pohodlnou obecnou instrukci nepřímého `CALL`.

PROMETHEUS vytvoří stejný efekt tím, že nejprve uloží na zásobník běžný návratový cíl:

```asm
ld hl,prometheusWarmStart
push hl
...
jp (hl)
```

Jednoduchý handler příkazu nyní může skončit instrukcí `RET`. Adresou vyzvednutou ze zásobníku je `prometheusWarmStart`, takže editor překreslí obrazovku a čeká na další klávesu.

Je to malý, ale důležitý vzor pro Z80:

```text
push požadovanou návratovou adresu
skoč nepřímo do vybrané rutiny
rutina se přes RET vrátí na připravenou adresu
```

Tabulka skoků se tak chová jako tabulka volání podprogramů.

## Opakování začíná porovnáním normalizovaných bajtů

PROMETHEUS si pamatuje poslední přijatou klávesu v samomodifikovaných operandech:

```asm
varcLastPressedKey:
    ld a,022h
varcLastPressedKeyComparisonValue:
    cp 022h
```

Operand první instrukce uchovává přeloženou klávesu. Operand druhé instrukce uchovává hodnotu, s níž se provede další porovnání.

Přesné uspořádání je kompaktní a trochu nepřímé, jeho účel je však prostý:

```text
if currentNormalizedKey == previousNormalizedKey:
    považuj ji za drženou klávesu
else:
    přijmi ji jako novou klávesu
```

Porovnání probíhá až po převodu velikosti písmen a po vytvoření příkazového tokenu. Držení SYMBOL SHIFT+A tedy opakuje `$C1`, nikoli surový index v matici.

## Prodleva opakování je počet průchodů smyčkou, nikoli hodiny

Držená klávesa vstoupí do `.advanceHeldKeyRepeatCounter`:

```asm
varcHeldKeyRepeatScanCounter:
    ld hl,00000h
    inc hl
    ld (varcHeldKeyRepeatScanCounter+1),hl
    ld a,h
    cp 005h
    jr nz,processKey
```

Čítač se zvýší při každém opakovaném skenu. Zapamatovaná klávesa se znovu vydá teprve tehdy, když horní bajt dosáhne pěti.

Nejde o měření času v milisekundách. Je to prodleva vyjádřená průchody procesorovou smyčkou. Její skutečná délka závisí na konkrétní cestě instrukcemi a na rychlosti stroje.

Nově přijatá klávesa také projde počáteční zpožďovací smyčkou. Příkazové tokeny s nastaveným bitem 7 dostanou ještě delší prodlevu:

```asm
bit 7,a
ld (varcRepeatedKeyCode+1),a
ret z
```

Proč zdržovat příkazy více? Opakované písmeno ve zdroji může být užitečné. Nechtěné zopakování celého příkazového tokenu je podstatně ničivější. Delší pauza toto riziko snižuje.

## Uvolnění musí být stabilní

Mechanické kontakty kláves a jednotlivé skeny nejsou dokonale čisté. PROMETHEUS nevynuluje stav opakování po jediném skenu, který náhodou neohlásí žádnou klávesu. Čeká v malé smyčce pro debounce uvolnění:

```text
opakovaně skenuj
if se klávesa znovu objeví, pokračuj ve zpracování držené klávesy
if zůstane dostatečně dlouho nepřítomná, vynuluj stav předchozí klávesy
```

Tím se zabrání tomu, aby byla držená klávesa kvůli krátkému výpadku vyložena jako mnoho samostatných nových stisků.

Implementace používá vnořené dekrementační smyčky místo timer interruptu, protože PROMETHEUS normálně běží se zakázanými přerušeními a chce mít nad strojem úplnou kontrolu.

## Každá přijatá klávesa klikne

Nová nebo opakovaná klávesa dojde do `.acceptNormalizedKeyAndBeep`:

```asm
push af
call keypressBeep
pop af
```

Bajt klávesy je zachován, zatímco nakonfigurovaná rutina kliknutí přepne reproduktor Spectra.

Zvuk je tedy součástí přijetí události, nikoli fyzického skenování. Neplatné stavy, samotné modifikátory ani potlačené skeny držené klávesy nekliknou.

Je to užitečná zpětná vazba: kliknutí znamená, že PROMETHEUS se rozhodl předat klávesu editoru.

## Monitor používá wrapper

Monitor často volá `readKeyCode` místo přímého volání `processKey`:

```asm
readKeyCode:
    exx
    call processKey
    exx
    call isLetter
    ret nz
    or 020h
    ret
```

Přidává dvě další zásady:

1. kolem překladače orientovaného na editor se chrání alternativní sada registrů;
2. písmena jsou pro dispatch příkazů monitoru vynucena na malá.

Je to další vrstva přizpůsobení. `processKey` poskytne obecnou normalizovanou událost. `readKeyCode` ji zúží podle očekávání monitoru.

## Rychlé držené šipky část mechanismu obcházejí

Kapitola 9 ukázala, že posun okna zdroje může pokračovat, dokud zůstává šipka stisknuta. Po první normalizované události šipky čte rychlá scrollovací smyčka přímo port klávesnice `$FE`.

Není to rozpor.

První událost stále prochází celou překladovou cestou:

```text
matice → scanner ROM → řídicí kód
```

Jakmile editor přesně ví, že opakuje kurzor dolů nebo nahoru, může levně testovat jedinou známou fyzickou klávesu v matici:

```text
Je tato konkrétní šipka stále stisknutá?
```

Není nutné pro každý posunutý bitmapový řádek znovu provádět převod příkazových tokenů, CAPS LOCK, vyhledání interpunkce ani obecný debounce.

PROMETHEUS používá obecnou službu k rozpoznání události a specializovanou službu k urychlení známého pokračování.

## Úplná cesta obyčejného písmene

Představme si, že uživatel při psaní zdroje stiskne `L` bez SHIFTu.

```text
1. ROM_KeyboardScanning vrátí index klávesy E a běžnou třídu modifikátoru D.
2. getKeypressCodeOrZero událost přijme.
3. processKey indexuje ROM_Key_Tables.
4. písmeno se normalizuje na malé: 'l'.
5. CAPS LOCK je může obrátit.
6. bajt se porovná s předchozí přijatou klávesou.
7. je-li nový, zazní kliknutí a inicializuje se stav opakování.
8. processKey vrátí 'l'.
9. editor je předá do updateInputBuffer.
```

V této chvíli už klávesnice není důležitá. Editor vidí jediný bajt.

## Úplná cesta příkazového tokenu

Představme si, že je vstupní řádek prázdný a uživatel stiskne SYMBOL SHIFT+S.

```text
1. Scanner ROM ohlásí S se SYMBOL SHIFTem.
2. processKey ověří, že inputBufferStart obsahuje $01,$00.
3. Kód písmene 'S' dostane bit 7 a změní se na $D3.
4. Klávesa klikne a je vrácena.
5. updateInputBuffer vloží $D3 před značku kurzoru.
6. repaintEditLine rozvine $D3 do viditelného slova SAVE.
7. Uživatel napíše jméno souboru a stiskne ENTER.
8. submitInputLineOrDispatchCommand rozpozná první bajt s nastaveným horním bitem.
9. $D3 vybere položku S v commandHandlerTable.
10. Řízení skočí do invokeSave.
```

Uživatel myslí ve slovech. PROMETHEUS myslí v jednobajtových slovesech.

## Úplná cesta držené klávesy

Představme si, že uživatel drží `x`.

```text
první sken:
    přelož na 'x'
    předchozí klávesa je jiná
    klikni
    zapamatuj 'x'
    počáteční prodleva
    return 'x'

následující skeny:
    přelož na 'x'
    předchozí klávesa se shoduje
    zvyš čítač opakování
    nic nevracej až do dosažení prahu

sken na prahu:
    return zapamatované 'x'
    znovu klikni

uvolnění:
    vyžaduj stabilní nepřítomnost
    vynuluj porovnání a čítač
```

Tento návrh brání zaplnění řádku plnou rychlostí procesoru a zároveň umožňuje užitečné opakování.

## Zpět k celému stroji

Klávesnicová vrstva je malý interpret.

Její vstupní jazyk tvoří:

- polohy v matici;
- stavy modifikátorů;
- čas vyjádřený opakovanými skeny.

Její výstupní jazyk tvoří:

- znaky podobné ASCII;
- řídicí bajty editoru;
- příkazové tokeny.

Výstup je záměrně tvarován pro následující vrstvy. Kódy kurzoru jsou dost malé pro přímá porovnání. Příkazové tokeny tvoří hustý abecední rozsah. Písmena dodržují pravidla velikosti znaků editoru. Opakování je již zpomaleno na lidskou rychlost.

Toto oddělení je důležité. Rutina editačního řádku neví, jak funguje klávesnicová matice Spectra. Dispatcher příkazů neví, zda token vznikl kombinací kláves, nebo jej vytvořila jiná rutina. Každá vrstva dostane reprezentaci vhodnou pro svou práci.

## Co se změnilo v paměti nebo hardwaru?

Po přijetí nové klávesy:

- `varcLastPressedKey` si zapamatuje přeložený bajt;
- `varcLastPressedKeyComparisonValue` se aktualizuje;
- `varcRepeatedKeyCode` dostane bajt pro budoucí opakování;
- `varcHeldKeyRepeatScanCounter` se vynuluje;
- bit reproduktoru v ULA se přepne a vytvoří kliknutí.

Dokud klávesa zůstává stisknuta:

- čítač opakování roste;
- vstupní buffer se nezmění, dokud práh nevytvoří další událost.

Po stabilním uvolnění:

- porovnávací bajt předchozí klávesy se vynuluje;
- další stisk bude považován za nový.

Pro příkazový token platí:

- vrací se pouze jeden bajt s nastaveným horním bitem;
- viditelné rozvinutí a dispatch handleru proběhnou později.

## Důležité myšlenky pro pozdější kapitoly

- ROM Spectra vrací index klávesy a třídu modifikátoru, nikoli hotový znak pro editor;
- `processKey` skládá fyzické modifikátory, CAPS LOCK, opakování a zadání příkazu do jediného bajtu;
- bit 7 odlišuje příkazové tokeny od obyčejného vstupního textu;
- `$C1` až `$DA` se mapují přímo na písmena A až Z;
- slova příkazů se zobrazují rozvinutím, nikoli uložením celého textu;
- některé příkazy bez argumentu se odešlou okamžitě samy;
- nepřímý dispatch příkazu se provádí uložením návratové adresy na zásobník a skokem přes tabulku wordů;
- časování opakování je založeno na procesorových smyčkách a opakovaných skenech, nikoli na přerušeních nebo hodinách.

## Vysvětlené orientační labely zdroje

- `getKeypressCodeOrZero`
- `processKey`
- `readKeyCode`
- `ROM_KeyboardScanning`
- `.keyCombinationWithSS`
- `symbolCharacters`
- `varcCapsLockEnabled`
- `varcLastPressedKey`
- `varcLastPressedKeyComparisonValue`
- `varcRepeatedKeyCode`
- `varcHeldKeyRepeatScanCounter`
- `resetLastPressedKeyComparison`
- `keypressBeep`
- `isNumber`
- `isLetter`
- `submitInputLineOrDispatchCommand` na úrovni dispatch příkazů
- `commandHandlerTable`
