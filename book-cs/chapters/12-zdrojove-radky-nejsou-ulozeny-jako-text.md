# Kapitola 12: Zdrojové řádky nejsou uloženy jako text

Editovatelný řádek je příjemný pro člověka. Pro 48K počítač však není úsporný.

Kdyby PROMETHEUS ukládal každý zdrojový řádek přesně tak, jak se zobrazuje, znovu a znovu by uchovával informace, které program už zná:

- zápis běžných mnemonic;
- zápis registrových operandů;
- mezery sloužící pouze k zarovnání;
- názvy symbolů opakované v mnoha výrazech;
- dostatek informací k opětovnému nalezení položky v tabulce instrukcí při každém sestavení.

PROMETHEUS proto ukládá zdroj ve vlastním kompaktním jazyce záznamů.

Záznam zdroje není strojový kód, ačkoli jeho prvním bajtem bývá skutečný opcode Z80. Není ani tokenizovaným textem ve smyslu BASICu, přestože názvy a instrukce reprezentuje kompaktně. Je připraveným popisem jednoho zdrojového řádku, navrženým tak, aby z něj editor mohl rekonstruovat čitelný text a assembler jej rychle zpracovat.

Tato kapitola popisuje trvalý formát. Kapitoly 13 a 14 ukážou, jak se do něj text kóduje a jak se z něj znovu rozbaluje.

## Proč vůbec zdroj komprimovat?

PROMETHEUS musí současně držet v paměti několik velkých věcí:

```text
rezidentní program
komprimovaný zdroj
tabulka symbolů
sestavený výstup
obrazovka Spectra
zásobníky a pracovní buffery
```

Zdroj se snadno stane největší strukturou, jejíž velikost ovládá uživatel. Ušetřit několik bajtů na každém řádku proto znamená víc než ušetřit několik bajtů v občas používané rutině.

Uvažujme obyčejný řádek:

```asm
LOOP     DJNZ LOOP
```

Jednoduchá textová reprezentace by mohla uložit dvacet viditelných znaků a terminátor. PROMETHEUS už však ví, že:

- `DJNZ` patří mezi podporované mnemonic;
- odpovídající instrukce má operand ve formě relativního výrazu;
- `LOOP` lze reprezentovat pořadovým číslem symbolu;
- mezery mezi poli lze rekonstruovat;
- konečný strojový opcode je známý z tabulky instrukcí.

Trvalý záznam uchovává tato fakta, nikoli úplnou viditelnou podobu řádku.

## Každý záznam začíná dvěma bajty

V trvalé paměti zdroje **není žádný úvodní bajt délky**.

Je to důležité, protože bezprostředně před nově vytvořeným záznamem existuje dočasný pracovní bajt nazvaný `encodedRecordStorageLength`. Ten říká vkládací rutině, kolik bajtů má zkopírovat. Do paměti zdroje se nekopíruje.

Trvalé uložení začíná na `encodedRecordHeader` a vždy má tuto pevnou hlavičku:

```text
offset +0    opcode nebo pseudo-opcode
offset +1    informační bajt
```

Vše za těmito dvěma bajty je volitelný proměnlivý materiál.

Záznam se tedy podobá spíše drobnému deskriptoru instrukce než běžnému textovému řádku.

## Bajt nula bývá skutečný opcode

U obyčejné strojové instrukce je bajt nula opcodem Z80 vybraným z tabulky instrukcí.

Řádek `RET` lze například reprezentovat jeho opcodem a informačním bajtem, který říká, že nenásleduje žádný výrazový payload.

Neznamená to, že lze záznam zdroje prostě vykonat. Prefixy, operandy, výrazy a labely stále vyžadují interpretaci. Uložení opcodu už v této fázi má však velkou výhodu:

> Nákladná práce s rozpoznáním mnemonic a formy operandu už proběhla při zadání řádku.

Během sestavení může PROMETHEUS začít od připravené identity instrukce, místo aby znovu analyzoval původní slova.

## Pseudo-opcody představují řádky, které nejsou instrukcemi Z80

Některé zdrojové řádky neodpovídají vykonatelné strojové instrukci. PROMETHEUS pro ně vyhrazuje hodnoty opcodu `$00` až `$09`:

| Hodnota | Podoba zdroje |
|---:|---|
| `$00` | prázdný řádek |
| `$01` | komentář |
| `$02` | `ENT` |
| `$03` | `EQU` |
| `$04` | `ORG` |
| `$05` | `PUT` |
| `$06` | `DEFB` |
| `$07` | `DEFM` |
| `$08` | `DEFS` |
| `$09` | `DEFW` |

Tyto hodnoty se nepoužívají samostatně. Informační bajt označuje záznam jako pseudo-instrukci kombinací prefixů, která v této tabulce nemůže popisovat skutečnou instrukci Z80.

PROMETHEUS tak dává řádkům určeným jen editoru i řádkům řídícím assembler stejný dvoubajtový začátek jako strojovým instrukcím. Procházení a dispatch mohou zacházet se všemi zdrojovými řádky jako s členy jedné rodiny záznamů.

## Informační bajt odpovídá na několik otázek

Bajt jedna je rozdělen do polí:

```text
bit 7       rodina CB
bit 6       rodina ED
bit 5       rodina DD
bit 4       rodina FD
bit 3       zdrojový řádek definuje label
bity 2–0    třída operandu nebo uložení
```

Horní čtyři bity určují rodinu prefixu instrukce.

U skutečné instrukce Z80 vznikají jen smysluplné kombinace. U pseudo-instrukcí slouží jinak nemožné současné označení DD a FD jako interní značka kategorie.

Bit 3 říká, zda zdrojový řádek obsahuje label. Je-li nastaven, následuje za hlavičkou dvoubajtové pořadové číslo symbolu.

Spodní tři bity popisují, jak je operand uložen nebo emitován:

| Třída | Význam |
|---:|---|
| `0` | žádný výrazový payload |
| `1` | jednobajtová hodnota |
| `2` | dvoubajtová hodnota |
| `3` | relativní bajt se znaménkem |
| `4` | indexový displacement `(IX/IY+d)` |
| `5` | indexový displacement a další bajt `(IX/IY+d),n` |
| `6` | operand `RST` složený přímo do opcodu |
| `7` | pseudo-instrukce nebo jiná nestrojová forma |

Informační bajt tedy kompaktně nese několik vrstev znalostí:

```text
ke které rodině instrukce patří?
definuje tento řádek label?
jaký druh proměnlivých dat následuje?
```

## Nejmenší záznam má jen dva bajty

Záznam, který má:

- žádný label zdrojového řádku;
- třídu operandu nebo uložení nula;

nepotřebuje za hlavičkou nic dalšího.

Má přesně dva bajty.

Počáteční prázdný zdrojový řádek je:

```text
$00,$30
```

Čtěme jej po jednotlivých polích:

```text
$00    pseudo-opcode prázdného řádku
$30    pseudo-značka DD a FD, bez labelu, třída nula
```

Za ním nenásleduje koncová značka, protože délka záznamu je už známá z informačního bajtu.

Pevnou dvoubajtovou podobu mohou mít i jiné jednoduché formy, například instrukce bez labelu a bez operandu.

Je to výrazná úspora, protože prázdné řádky a jednoduché instrukce se vyskytují často.

## Proměnlivé záznamy přidávají kompaktní payload

Záznam se stává proměnlivým, potřebuje-li za hlavičkou další materiál. Může jít o:

- pořadové číslo labelu zdrojového řádku;
- znaky výrazu;
- odkazy na symboly uvnitř výrazu;
- text komentáře;
- data definice;
- oddělovače několika výrazů.

Proměnlivý záznam končí zvláštní značkou, kterou si brzy popíšeme.

Jeho obecná podoba je:

```text
+0    opcode nebo pseudo-opcode
+1    informační bajt
+2    volitelný horní/tagový bajt pořadového čísla labelu
+3    volitelný spodní bajt pořadového čísla labelu
...   payload výrazu, komentáře nebo definice
last  koncová/zpětná značka
```

Ne každý proměnlivý záznam používá všechna pole. Informační bajt a pseudo-opcode říkají konzumentovi, jak má payload vykládat.

## Labely jsou pořadová čísla, ne pointery

Předpokládejme, že řádek začíná labelem `LOOP`.

PROMETHEUS neukládá:

- znaky `L`,`O`,`O`,`P` v každém záznamu, který jej zmiňuje;
- absolutní pointer do pohyblivé tabulky symbolů.

Ukládá jedničkově číslované pořadí symbolu.

Koncepčně:

```text
LOOP je symbol číslo 37
záznam uloží 37
```

Pozdější rutina vyhledá pořadí 37 v tabulce symbolů a získá aktuální adresu položky se jménem a hodnotou.

Oblast zdroje a tabulky symbolů se může při vkládání nebo mazání záznamů přesouvat. Absolutní pointer by přestal platit. Pořadové číslo si zachová význam, dokud se udržuje pořadí vektoru symbolů.

I díky tomu může PROMETHEUS přesunout celou oblast zdroje a symbolů, aniž by musel každý uložený odkaz na jméno přepisovat na novou adresu v paměti.

## Odkazy na symboly se ohlašují bitem 7

Pořadové číslo symbolu zabírá dva bajty.

Jeho první bajt je horní bajt pořadového čísla s nastaveným bitem 7. Druhý bajt je spodní část pořadového čísla:

```text
první bajt    $80 | ordinalHigh
druhý bajt    ordinalLow
```

Toto tagování vytváří uvnitř proměnlivého payloadu tři užitečné rozsahy bajtů:

```text
$00–$7F    doslovný text nebo bajt výrazu
$80–$BF    první bajt dvoubajtového odkazu na symbol
$C0–$FF    koncová/zpětná značka
```

Rozsahy se nepřekrývají.

Scanner může prozkoumat jediný bajt a rozhodnout:

```text
pod $80          zkopíruj nebo interpretuj jako literál
$80 až $BF       čti tento a následující bajt jako jedno pořadí symbolu
$C0 nebo více    konec tohoto proměnlivého záznamu
```

Není potřeba escape znak ani samostatný počet položek.

## Proč jsou úvodní bajty symbolů jen v rozsahu `$80` až `$BF`?

Bit 7 označuje odkaz na symbol, bity 7 a 6 však nesmějí být nastaveny oba současně. Hodnoty `$C0` až `$FF` jsou vyhrazeny koncovým značkám záznamů.

V horním bajtu pořadí tak zbývá šest užitečných bitů a ve spodním osm: dost pro 14bitový prostor pořadových čísel.

PROMETHEU mnohem pravděpodobněji dojde paměť Spectra, než že by potřeboval šestnáct tisíc různých symbolů. Tento kompaktní rozsah je tedy pro stroj velkorysý.

## Doslovné znaky výrazu zůstávají čitelnými bajty

Výraz jako:

```asm
2*LABEL+#23
```

se nepřevádí do moderního abstraktního syntaktického stromu. Operátory a znaky čísel mohou zůstat obyčejnými bajty. Pouze názvy symbolů se nahrazují pořadovými čísly.

Koncepčně se payload změní na:

```text
'2','*',symbolReference(LABEL),'+','#','2','3'
```

Má-li `LABEL` pořadové číslo `$0123`, bajty mohou schematicky vypadat takto:

```text
$32,$2A,$81,$23,$2B,$23,$32,$33
```

kde `$81,$23` je tagované pořadí.

Přesné číslo závisí na aktuální tabulce symbolů. Podstatná je směs:

```text
doslovná syntax zůstává doslovná
názvy se mění na kompaktní odkazy
```

Tak lze výraz znovu rekonstruovat, aniž by se opakovaně ukládal celý zápis symbolů.

## Značka zaznamenává proměnlivou délku odzadu

Proměnlivý záznam končí hodnotou:

```text
$C0 + payloadLength
```

`payloadLength` je počet bajtů za dvoubajtovou hlavičkou a před značkou.

Pro payload o osmi bajtech je značkou:

```text
$C8
```

Spodních šest bitů nese délku. Horní dva bity zařadí bajt do vyhrazeného rozsahu terminátorů.

Celková velikost proměnlivého záznamu je:

```text
2bajtová hlavička + payloadLength + 1bajtová značka
```

Značka vykonává dvě práce:

1. dopředné scannery vědí, kde proměnlivý materiál končí;
2. pohyb zpět může obnovit začátek předchozího záznamu.

Právě druhá práce je tou chytrou.

## Proč je délka uložena na konci

Kdyby každý záznam začínal bajtem délky, pohyb dopředu by byl snadný. Pohyb dozadu by stále vyžadoval index nebo scan od začátku.

PROMETHEUS umísťuje proměnlivou délku na konec záznamu. Když `HL` ukazuje na aktuální záznam, bajt bezprostředně před ním patří předchozímu záznamu.

Tento bajt odliší dva případy:

```text
bajt před aktuálním < $C0
    předchozí záznam měl pevnou dvoubajtovou podobu

bajt před aktuálním ≥ $C0
    předchozí záznam byl proměnlivý
    spodních šest bitů udává délku jeho payloadu
```

Formát tak obsahuje vlastní zpětný link, aniž by ukládal adresu.

Je to **relativní strukturální link**, nikoli pointer.

## Pohyb zpět v konstantním čase

`getPreviousSourceRecord` je krátká právě proto, že tomu byl formát přizpůsoben:

```asm
getPreviousSourceRecord:
    dec hl
    ld a,(hl)
    cp 0c0h
    jr c,.previousRecordIsFixedLength
    and 03fh
    ld e,a
    ld d,000h
    sbc hl,de
    dec hl
.previousRecordIsFixedLength:
    dec hl
    ret
```

Přečtěme si obě cesty.

### Předchozí záznam byl pevný

`HL` začíná na aktuálním záznamu.

```text
dec HL        ukazuje na druhý bajt předchozího pevného záznamu
hodnota < $C0 pevný případ
dec HL        ukazuje na první bajt předchozího záznamu
```

### Předchozí záznam byl proměnlivý

Po prvním decrementu ukazuje `HL` na značku.

```text
length = marker & $3F
HL -= length      přejdi zpět přes payload
HL--              přejdi zpět přes informační bajt
HL--              přejdi zpět přes bajt opcodu
```

Výsledkem je počáteční adresa předchozího záznamu.

Není potřeba číslo zdrojového řádku ani tabulka adres záznamů.

## Pohyb dopředu používá informační bajt

`getNextSourceRecord` začne načtením dvoubajtové hlavičky.

Nejprve přeskočí volitelné pořadové číslo labelu řádku, je-li nastaven bit 3.

Potom testuje pevnou podobu:

```asm
.testFixedLengthRecord:
    and 007h
    ret z
```

Není-li přítomen label a třída je nula, `HL` už ukazuje bezprostředně za dvoubajtový záznam.

Jinak rutina scanuje proměnlivý payload.

Scanner nesmí zaměnit druhý bajt pořadového čísla symbolu za koncovou značku. Hodnoty `$80` až `$BF` proto bere jako dvoubajtový celek:

```asm
.scanVariableLengthRecord:
    ld a,(hl)
    inc hl
    cp 0c0h
    ret nc
    cp 080h
    jr c,.scanVariableLengthRecord
    inc hl
    jr .scanVariableLengthRecord
```

V pseudokódu:

```text
while true:
    byte = *HL++

    if byte >= $C0:
        return HL

    if byte >= $80:
        HL++        přeskoč spodní bajt pořadí symbolu
```

Když se rutina vrátí, značku už překročila, takže `HL` ukazuje na další záznam.

## Pohyb dopředu a dozadu nejsou zrcadlové operace

Pohyb zpět má pro každý záznam konstantní čas, protože závěrečná značka ukládá délku payloadu.

Pohyb dopředu má konstantní čas u pevných záznamů, ale u proměnlivých musí payload proskenovat.

Tato nesymetrie dává smysl.

Proměnlivé záznamy jsou krátké, protože krátký je i editační řádek. Dopředný scan několika desítek bajtů je levný. Přidat úvodní pole délky kvůli konstantnímu pohybu dopředu by stálo jeden bajt v každém záznamu a zkomplikovalo kompaktní hlavičku.

PROMETHEUS utrácí bajty jen tam, kde kupují důležitou schopnost: pohyb zpět bez indexu řádků.

## Komentáře mají vlastní jednoduchou podobu záznamu

Komentář začíná středníkem a obchází parser labelu, mnemonic a operandů.

Jeho hlavička je:

```text
$01,$37
```

Čteno jako:

```text
$01    pseudo-opcode komentáře
$37    pseudo-značka DD+FD, bez labelu, třída 7
```

Payload obsahuje text komentáře včetně úvodního středníku a za ním značku `$C0+n`.

Například komentář:

```asm
;wait for key
```

má koncepčně podobu:

```text
$01,$37,
';','w','a','i','t',' ','f','o','r',' ','k','e','y',
terminalMarker
```

Komentáře se nepřevádějí na malá písmena, netokenizují jako mnemonic ani nehledají v tabulce instrukcí. Jejich text se zachová, protože pro libovolnou prózu neexistuje kratší sémantická reprezentace, která by ji uchovala.

Jde o důležitý princip komprese:

> Komprimuj strukturu, když jí program rozumí; zachovej doslovná data, když jí nerozumí.

## Řádky obsahující pouze label jsou stále proměnlivé

Řádek může definovat label, aniž by obsahoval instrukci.

Opcode může zůstat pseudo-opcodem prázdného řádku, informační bit 3 se však nastaví a za hlavičkou následuje dvoubajtové pořadí labelu.

Protože nyní existují proměnlivé bajty, záznam potřebuje také koncovou značku.

Koncepčně:

```text
$00, infoWithLabelBit,
labelOrdinalHighTagged, labelOrdinalLow,
$C2
```

Spodních šest bitů značky říká, že payload obsahuje dva bajty.

Je z toho vidět, proč „prázdný řádek“ a „dvoubajtový záznam“ nejsou totožné pojmy. Prázdný řádek bez labelu je pevný. Vizuálně prázdný řádek obsahující pouze label používá pseudo-opcode prázdného řádku, ale nese proměnlivé informace o labelu.

## Skutečné instrukce mohou být také pevné nebo proměnlivé

`RET` bez labelu nepotřebuje výrazový payload:

```text
opcode RET, informační třída 0
```

Může být pevným dvoubajtovým záznamem.

`JP ADDRESS` bez labelu potřebuje výrazový payload. Jeho třída označuje dvoubajtovou hodnotu a za hlavičkou následuje zakódovaný výraz zakončený značkou.

`RET` s labelem nepotřebuje operandový výraz, stále však nese pořadí labelu, a proto se stává proměnlivým.

Velikost záznamu tedy určuje uložená informace, nikoli jen to, zda instrukce působí jednoduše na člověka.

## Prefixové bity šetří opakované dekódování

Horní bity informačního bajtu zaznamenávají, zda instrukce patří do rodiny CB, ED, DD nebo FD.

To je důležité, protože instrukci Z80 neurčuje samotný jeden opcode. Stejný následující bajt může po různých prefixech znamenat odlišné věci.

Místo uložení původního textu mnemonic a jeho pozdějšího opětovného třídění zaznamená záznam přímo vybranou rodinu.

U forem IX a IY může tabulka instrukcí sdílet velkou část klasifikace. Při vytváření záznamu zdroje vybere samostatný bit DD nebo FD.

Kompaktní záznam tak leží napůl mezi zdrojovým textem a konečnými bajty:

```text
sémantičtější než strojový kód
připravenější než text
```

## Třídy operandů vysvětlují, jak má assembler výraz použít

Spodní tři bity nejsou pouhým počtem bajtů.

Třída 3 například říká, že výraz je cílem relativní větve se znaménkem. Během sestavení musí PROMETHEUS vypočítat:

```text
displacement = target - addressAfterInstruction
```

a ověřit, že se výsledek vejde do bajtu se znaménkem.

Třída 2 říká, že se výraz změní na dvoubajtovou hodnotu.

Třída 4 říká, že výraz je displacementem IX/IY a patří dovnitř indexové adresovací formy.

Záznam zdroje tedy zachovává *roli* výrazu, nikoli jen jeho znaky.

Díky tomu může být sestavovací průchod menší a rychlejší.

## Záznamy definic uchovávají seznamy a řetězce

`DEFB`, `DEFS` a `DEFW` mohou obsahovat výrazy oddělené čárkami. Jejich payload uchovává zakódovaný výrazový materiál a oddělovací čárky.

`DEFM` zachovává bajty znaků v uvozovkách, protože samotné znaky jsou daty, která se mají emitovat.

Tyto záznamy používají stejné vnější rámování:

```text
pseudo-opcode
informační bajt
volitelné pořadí labelu
zakódovaný materiál definice
koncová značka
```

Význam proměnlivého proudu závisí na pseudo-opcodu. Jazyk záznamů je kompaktní, nikoli však dokonale jednotný; specializovaní konzumenti vědí, jak jednotlivé rodiny interpretovat.

Je to rozumné. Jediný univerzální strom výrazů by vyžadoval více kódu a bajtů, než jednoduché formy zdroje potřebují.

## Mezery polí se neukládají jako metadata záznamu

Editor zobrazuje zdroj v pevných polích:

```text
label       9 sloupců
mnemonic    5 sloupců
operand     zbývající sloupce
```

Tyto šířky polí se neukládají v každém záznamu.

Při rozbalení záznamu PROMETHEUS vyřeší volitelné pořadí labelu na jméno, rekonstruuje mnemonic z tabulky instrukcí a doplní pole v `lineBuffer` mezerami.

Viditelné mezery jsou prezentací.

Toto oddělení stojí za zdůraznění:

```text
záznam zdroje ukládá význam
lineBuffer ukládá jednu naformátovanou podobu
```

Ani značka vybraného bloku se do záznamu neukládá. Do rozbaleného řádku se přidává podle dvou externích pointerů hranic.

## Počáteční zdroj tvoří dvacet drobných záznamů

Na konci rezidentního payloadu obsahuje `sourceBufferStart` dvacet kopií:

```text
$00,$30
```

Jde o skutečné prázdné záznamy zdroje, nikoli o nulami vyplněnou nevyužitou paměť.

Proč dvacet?

Editor chce mít od prvního vykreslení platné záznamy nad i pod aktivním přístupovým řádkem. Počáteční uspořádání poskytuje:

- třináct záznamů před aktivním řádkem;
- samotný aktivní řádek;
- šest záznamů za ním.

To přesně vyplní dvacet řádků okna zdroje popsaného v kapitole 9.

Labely `sourceBufferPreviousLine` a `sourceBufferAccessLine` označují užitečné pozice uvnitř tohoto počátečního řetězce.

Jak uživatel vkládá zdroj, oblast roste směrem vzhůru a tabulka symbolů se pohybuje s ní. Prázdné koncové záznamy zároveň vytvářejí v editoru volný prostor kolem aktuálního textu.

## Konec zdroje je strukturální hranicí, nikoli textovým sentinelem

Oblast komprimovaného zdroje končí tam, kde začíná tabulka symbolů. `varcSymbolTablePt` proto slouží jako hranice konce zdroje.

Navigační rutiny porovnávají kandidátní adresy záznamů s dynamickými pointery společné oblasti. Nehledají zvláštní znak „konec souboru“ vložený do textu zdroje.

Je to důležité, protože nula je zcela platným bajtem uvnitř hlaviček i doslovného výrazového materiálu. Zdroj určují struktura záznamů a pohyblivé pointery oblasti, nikoli pravidla řetězců ve stylu jazyka C.

## Jazyk záznamů se chrání před nejednoznačností

Rozsahy bajtů byly vybrány tak, aby každý scanner mohl rozhodovat místně:

```text
hlavička říká, zda existuje volitelný label
nultá třída říká, zda je záznam bez labelu pevný
úvodní bajt symbolu říká scanneru, že má přeskočit ještě jeden bajt
rozsah terminátorů říká, kde proměnlivý záznam končí
spodní bity terminátoru říkají zpětnému scanneru, jak daleko se vrátit
```

K nalezení dalšího řádku není nutné analyzovat gramatiku výrazu.

To je znakem dobrého kompaktního formátu: navigace může probíhat bez porozumění každému sémantickému detailu.

## Schematický záznam běžného příkladu

Vezměme:

```asm
LOOP     DJNZ LOOP
```

Přesné bajty závisí na pořadovém čísle přiděleném symbolu `LOOP` a na kódování tabulky instrukcí. Koncepčně má záznam tuto podobu:

```text
+0  opcode DJNZ
+1  informace:
        žádná rodina prefixu
        nastaven bit přítomnosti labelu
        třída relativního výrazu
+2  tagovaný horní bajt pořadí řádkového labelu LOOP
+3  spodní bajt pořadí řádkového labelu LOOP
+4  tagovaný horní bajt pořadí operandového symbolu LOOP
+5  spodní bajt pořadí operandového symbolu LOOP
+6  koncová značka $C4 pro čtyři bajty payloadu
```

Stejný symbol se objevuje dvakrát ze dvou různých důvodů:

- poprvé jako jméno definované tímto řádkem;
- podruhé jako výraz cíle větve.

Obě použití sdílejí stejnou reprezentaci pořadovým číslem.

Záznam **neukládá**:

- písmena `D`,`J`,`N`,`Z`;
- doplnění labelu do šířky devíti sloupců;
- mezeru před operandem;
- písmena `L`,`O`,`O`,`P` dvakrát.

Při zobrazení se všechny tyto podrobnosti určené člověku znovu vytvoří.

## Schematická pevná instrukce

Pro:

```asm
        RET
```

neexistuje label ani výrazový payload.

Koncepční záznam je prostě:

```text
opcode RET, informační bajt třídy nula
```

Dva bajty popisují celý zdrojový řádek.

Je zřejmé, proč tento formát dokáže v instrukčně bohatém zdroji ušetřit významné množství paměti.

## Schematický komentář

Pro:

```asm
;main loop
```

nemůže PROMETHEUS nahradit prózu opcodem ani pořadovým číslem symbolu. Ukládá:

```text
pseudo-opcode komentáře
informační bajt pseudo/třídy
doslovné znaky ";main loop"
koncovou/zpětnou značku
```

Komentáře zůstávají poměrně drahé. Je to cena za zachování libovolného lidského vysvětlení.

## Jak by vypadalo poškození

Protože bajty záznamu tvoří kompaktní jazyk, může mít poškození následky přesahující jeden viditelný znak.

Změněný informační bajt může:

- nepravdivě tvrdit, že následuje pořadí labelu;
- vybrat nesprávnou rodinu prefixu;
- změnit třídu operandu;
- způsobit, že pevný záznam začne vypadat jako proměnlivý.

Změněná koncová značka může přimět zpětnou navigaci skočit na nesprávnou adresu.

Poškozený úvodní bajt symbolu může přimět dopředný scanner přeskočit nesprávný následující bajt.

PROMETHEUS obsahuje cesty pro chybu zdroje, když nelze sladit opcode a informační data s tabulkou instrukcí. Kompaktnost však znamená, že formát obsahuje méně redundantních informací, z nichž by se dalo zotavit po libovolném poškození paměti.

Je to běžný kompromis softwaru pro malé stroje: paměťová úspornost vítězí nad propracovanou odolností proti chybám.

## Proč formát vyhovuje editoru i assembleru

Editor potřebuje:

- pohybovat se mezi řádky dopředu i dozadu;
- rekonstruovat čitelný zdroj;
- vkládat a mazat proměnlivé záznamy;
- nacházet odkazy na symboly;
- označovat vybrané řádky, aniž by je měnil.

Assembler potřebuje:

- znát rodinu instrukce a roli operandu;
- vyhodnocovat výrazy a symboly;
- v prvním průchodu počítat výstupní bajty;
- ve druhém průchodu emitovat konečné bajty.

Záznam zdroje poskytuje dost připravené struktury oběma.

Není optimalizován pro jedinou operaci. Je kompaktním společným jazykem spojujícím editor, tabulku symbolů a assembler.

## Úplný příklad navigace

Představme si tři po sobě jdoucí záznamy:

```text
A: pevný dvoubajtový záznam RET
B: proměnlivý záznam JP LABEL s délkou payloadu 5
C: pevný dvoubajtový prázdný záznam
```

Jejich podoba v paměti je:

```text
A: [header0][header1]
B: [header0][header1][pět bajtů payloadu][$C5]
C: [header0][header1]
```

Přechod z A do B:

```text
přečti informační bajt A
třída nula a žádný label → vrať adresu za dvěma bajty
```

Přechod z B do C:

```text
přečti informační bajt B
proměnlivá forma → scanuj payload
úvodní bajty symbolu přeskočí spodní části pořadí
naraz na $C5 → vrať adresu za značkou
```

Přechod z C zpět do B:

```text
prozkoumej bajt před C → $C5
délka payloadu = 5
odečti payload, značku a hlavičku
dojdi na B
```

Přechod z B zpět do A:

```text
prozkoumej bajt před B → informační bajt A, menší než $C0
odečti dva bajty
dojdi na A
```

Záznamy nepotřebují žádný vnější index řádků.

## Zpět k celému stroji

Nyní můžeme zpřesnit cyklus editoru z kapitoly 9:

```text
komprimovaný záznam
    obsahuje připravenou identitu instrukce a kompaktní odkazy

expand
    vyřeší jména a zrekonstruuje zobrazovací pole

editovatelný řádek
    obsahuje znaky, tokeny, značku kurzoru a terminátor

submit
    rozpozná syntaxi a vybere položku tabulky instrukcí

compress
    zapíše hlavičku, pořadová čísla, bajty výrazu a značku

insert
    přesune oblast zdroje a symbolů a opraví pointery
```

Záznam zdroje je stabilním středem tohoto cyklu. Obrazovka a editační buffer jsou dočasné pohledy. Výstup assembleru je pozdějším produktem. Záznam je tím, co PROMETHEUS uchovává jako uživatelův program.

## Co se změnilo v paměti?

Pouhé procházení záznamů nemění žádný bajt zdroje. `HL` se vypočítává z hlaviček a koncových značek.

Když se vloží nový pevný záznam:

- přidají se dva trvalé bajty;
- následující zdroj a paměť symbolů se posunou vzhůru;
- dynamické pointery se upraví.

Když se vloží proměnlivý záznam:

- přidá se jeho dvoubajtová hlavička, payload a koncová značka;
- značka zaznamená délku payloadu pro budoucí pohyb zpět.

Když se použije jméno symbolu:

- záznam zdroje dostane pořadové číslo, nikoli pointer nebo celý zápis;
- jméno a hodnotu vlastní odděleně tabulka symbolů.

Když se řádek vybere:

- záznam zůstane beze změny;
- značka se přidá pouze do dočasného rozbaleného zobrazovacího řádku.

## Důležité myšlenky pro další kapitoly

- `encodedRecordStorageLength` je dočasný počet kopírovaných bajtů, nikoli součást trvalého zdroje;
- každý trvalý záznam začíná opcodem či pseudo-opcodem a informačním bajtem;
- záznamy bez labelu s třídou nula mají pevně dva bajty;
- proměnlivé záznamy končí hodnotou `$C0+payloadLength`;
- závěrečná značka umožňuje pohyb zpět v konstantním čase;
- názvy symbolů se nahrazují tagovanými dvoubajtovými pořadovými čísly;
- rozsahy bajtů payloadu odlišují literály, začátky odkazů na symboly a koncové značky;
- mezery polí a značky výběru bloku patří do rozbalených pohledů, nikoli do záznamů;
- pseudo-instrukce sdílejí rámec záznamu se skutečnými instrukcemi Z80;
- formát ukládá dost sémantické přípravy, aby sloužil editoru i assembleru.

## Vysvětlené body ve zdroji

- `encodedRecordStorageLength`
- `encodedRecordHeader`
- `encodedRecordInfoByte`
- `encodedRecordPayload`
- `encodedRecordPayloadAfterLabel`
- `encodedRecordPayloadWorkspace`
- `sourceBufferStart`
- `sourceBufferPreviousLine`
- `sourceBufferAccessLine`
- `getPreviousSourceRecord`
- `getNextSourceRecord`
- `getRecordBeforeActiveLine`
- `getRecordAfterActiveLine`
- `varcSymbolTablePt` na úrovni hranice zdroje
- `varcSelectedBlockStart` a `varcSelectedBlockEnd` jako vnější stav pohledu
- `renderSourceRecord` na hranici záznamu a pohledu
- `expandSourceRecordToLineBuffer` na úrovni rozhraní
