# Kapitola 11: Editovatelný řádek

Okno editoru se zdrojem vypadá jako text, ale právě tam se ve skutečnosti nepíše.

PROMETHEUS nabízí uživateli jeden dočasný editovatelný řádek ve spodní části obrazovky. Tento řádek je malým místem setkání několika druhů informací:

- obyčejných znaků;
- pohyblivé značky kurzoru;
- kompaktních příkazových tokenů;
- nulového terminátoru;
- automaticky vkládaných mezer mezi poli;
- zdrojového textu rekonstruovaného z komprimovaného záznamu;
- argumentů příkazů zadaných uživatelem.

Řádek je natolik jednoduchý, že se vejde do několika desítek bajtů, přesto podporuje zadávání a editaci zdroje, příkazy, výzvy monitoru, názvy souborů i několik generovaných forem textu.

Tato kapitola zkoumá právě tuto dočasnou reprezentaci. Kapitola 12 se potom obrátí k mnohem hustší podobě používané pro trvalé uložení zdroje.

## Tři podoby jednoho řádku

Uvažujme viditelný zdrojový řádek:

```asm
LOOP     DJNZ LOOP
```

V různých okamžicích může PROMETHEUS držet tři jeho podoby.

### Trvalý záznam zdroje

Jde o komprimovanou podobu orientovanou na stroj, uloženou mezi ostatními záznamy zdroje. Obsahuje opcode, informační bajt, kompaktní odkazy na symboly a zpětnou značku.

### Rozbalený zobrazovací řádek

Jde o 32bajtový řádek v `lineBuffer`. Pole jsou doplněna mezerami a názvy symbolů rozbaleny, aby bylo možné zdroj vykreslit nebo vytisknout.

### Editovatelný vstupní řádek

Jde o nulou ukončenou posloupnost na `inputBufferStart`, která obsahuje jednu značku kurzoru a případně kompaktní příkazový token.

Editovatelný řádek je pracovním prostorem uživatele. Není konečnou reprezentací zdroje.

```text
trvalý záznam
    → rozbalit pro EDIT
editovatelný řádek
    → uživatel jej změní
    → při ENTER analyzovat a zkomprimovat
trvalý záznam
```

## Kurzor je bajt uvnitř řetězce

Mnohé textové editory ukládají kurzor jako samostatné číslo:

```text
cursorColumn = 12
```

PROMETHEUS místo toho vloží bajt `$01` přímo do vstupní posloupnosti.

Prázdný řádek je:

```text
$01,$00
```

Řádek obsahující `abc` s kurzorem za `b` vypadá koncepčně takto:

```text
'a','b',$01,'c',$00
```

Kurzor lze posunout výměnou `$01` se sousedním bajtem.

Tím odpadají některé výpočty. Aktuální logická pozice vložení je vždy adresou značky. Text před ní leží před kurzorem, text za ní za kurzorem.

Renderer si tuto adresu pamatuje v samomodifikované instrukci:

```asm
varcInputBufferPosition:
    ld hl,inputBufferStart+1
```

Po každém překreslení obsahuje okamžitý operand skutečnou adresu `$01`.

## Před řádkem stojí ochranný bajt

Bezprostředně před `inputBufferStart` leží `inputBufferGuardByte`:

```asm
inputBufferGuardByte:
    defb 080h
inputBufferStart:
    ...
```

Ochranný bajt plní dva související účely.

Za prvé používá několik scannerů postup s předběžným inkrementem. Začnou jeden bajt před skutečnými daty, adresu zvětší a teprve potom čtou. Platná předchozí adresa činí tento idiom bezpečným už u prvního znaku.

Za druhé dává nastavený nejvyšší bit kódu pro pohyb vlevo a mazání chráněnou hranici. Kurzor nemůže putovat donekonečna do nesouvisející pracovní paměti.

Ochranný bajt není viditelným textem. Patří k bezpečnostnímu mechanismu bufferu.

## Fyzický pracovní prostor je sdílený

Labely následující za `inputBufferStart` odhalují několik dalších využití stejné paměti:

- vstup editoru a monitoru;
- hlavičku páskového bloku Spectra;
- text přiřazení registrů v monitoru;
- dočasné zachycení stavu přerušení.

Sdílení je bezpečné, protože tyto činnosti neprobíhají současně. Když řádek vlastní editor, bajty znamenají editovatelný text. Během páskové operace znamenají některé z týchž bajtů pole hlavičky.

Moderní program by mohl vyhradit zvláštní strukturu pro každý účel. PROMETHEUS znovu používá jednu scratch oblast, protože rezidentní paměť je drahocenná.

Důležité pravidlo je časové:

> Jeden bajt může mít během života programu několik významů, ale v konkrétním okamžiku pouze jeden.

## Překreslení kurzor znovu objeví

`repaintEditLine` vybere tabulku tokenů assembleru a spodní bitmapový řádek:

```asm
repaintEditLine:
    ld hl,l96a4-1
    ld (varcTokenExpansionTableBase+1),hl
    ld hl,BOTTOM_LINE_VRAM_ADDRESS
```

Potom vstoupí do společného rendereru `renderInputLineAtBitmapAddress`.

Renderer řádek vymaže a začne u ochranného bajtu:

```asm
ld hl,inputBufferGuardByte
.renderNextInputBufferElement:
    inc hl
    ...
    ld a,(hl)
```

Pro každý prvek provede jednu ze tří akcí:

```text
$00        skonči
$01        vykresli kurzor a zapamatuj jeho adresu
ostatní    zobraz znak nebo rozbal token
```

Větev pro kurzor vypadá takto:

```asm
.renderInputCursorMarker:
    ld (varcInputBufferPosition+1),hl
    push hl
    ld a,(varcCapsLockEnabled+1)
    add a,0cch
    call displayNormalCharacter
    pop hl
```

Glyph se mění podle stavu CAPS LOCK. Stavový bajt je buď nula, nebo nenulová hodnota, takže jeho přičtení k `$CC` vybere podle původního uspořádání fontu správnou vizuální podobu.

Důležitý není přesný kód glyphu. Podstatné je, že překreslení vykoná dvě práce současně:

1. vykreslí řádek;
2. znovu vytvoří cache adresy kurzoru.

Před další editační operací není potřeba žádný samostatný scan.

## Ukládá se také sloupec obrazovky

Před načtením každého prvku bufferu renderer zaznamená aktuální fyzický výstupní sloupec:

```asm
ld a,(varcPrintingPosition+1)
and 01fh
ld (varcInputColumnAfterCursor+1),a
```

Protože `varcPrintingPosition` ukazuje na další bitmapovou buňku, jeho spodních pět bitů odhaluje vodorovný sloupec ve 32znakovém řádku.

Když renderer narazí na značku kurzoru, hodnota ponechaná v `varcInputColumnAfterCursor` popisuje fyzickou pozici za glyphem kurzoru. Pozdější vkládání ji kontroluje:

```asm
varcInputColumnAfterCursor:
    ld a,007h
    or a
    jr z,.incAAndRet
```

Nula znamená, že renderer přešel za poslední sloupec. PROMETHEUS odmítne vložit další znak, místo aby dovolil editovatelnému řádku přetéct do další obrazovkové řádky.

Kapacitu vstupu tedy neurčuje jen hrubá velikost pracovního prostoru, ale i viditelné 32sloupcové rozhraní.

## Tokeny vypadají jako slova

Bajt menší než `$80` se zobrazí jako jeden znak. Bajt rovný nebo větší než `$80` je kompaktní token.

`displayInputTokenOrCharacter` použije hodnotu tokenu jako index do volajícím zvolené samorelativní tabulky:

```asm
varcTokenExpansionTableBase:
    ld hl,08d6fh
    ld d,000h
    ld e,a
    add hl,de
    ld e,(hl)
    add hl,de
```

Výsledná adresa ukazuje na slovo ukončené nastaveným nejvyšším bitem. Renderer vypíše jeho znaky a přidá jednu mezeru.

Jeden fyzický vstupní bajt proto může zabrat mnoho obrazovkových sloupců:

```text
bajt bufferu $C1
    ↓
viditelné "ASSEMBLY "
```

Právě proto záleží na cachovaném *fyzickém* sloupci. Samotná délka bufferu neřekne, zda se řádek ještě vejde na obrazovku.

## ENTER je signalizován příznakem zero

První test v `updateInputBuffer` je záměrně drobný:

```asm
cp 00dh
ret z
```

Je-li klávesou ENTER, rutina se okamžitě vrátí s nastaveným příznakem zero.

Hlavní smyčka editoru používá tento příznak jako výsledek:

```text
Z clear    pokračuj v editaci
Z set      odešli řádek
```

Rutina nevrací zvláštní stavový bajt ani výsledek neukládá do paměti. Stačí příznak po porovnání.

Několik okamžitých příkazových tokenů záměrně používá stejnou konvenci, jak vysvětlila kapitola 10. Porovnání s `$C5`, `$C8`, `$CB` nebo `$D7` vrátí zero, a proto příkaz odešle bez čekání na ENTER.

## Pohyb kurzoru vlevo je jedna výměna

Při vstupu ukazuje `HL` na značku kurzoru.

Pohyb vlevo přečte bajt před ní a oba bajty vymění:

```asm
ld b,(hl)
dec hl
ld a,(hl)
rlca
jr c,.incAAndRet
ld c,(hl)
ld (hl),b
inc hl
ld (hl),c
```

Protože `B` obsahuje `$01`, je výsledkem:

```text
před:  x,$01

po:    $01,x
```

`RLCA` testuje nejvyšší bit předchozího bajtu. Token s nastaveným nejvyšším bitem působí jako levá hranice pohybu kurzoru. Uživatel nemůže umístit kurzor dovnitř rozbaleného zápisu tokenu, protože tento zápis se v bufferu fyzicky nenachází.

Například:

```text
buffer:     $D3,' ','F','I','L','E',$01,$00
obrazovka:  SAVE FILE_
```

Kurzor se může pohybovat mezi znaky argumentu, nikoli však mezi zobrazenými písmeny `SAVE`.

Token je jediným nedělitelným vnitřním prvkem, přestože zabírá několik viditelných sloupců.

## Pohyb kurzoru vpravo je zrcadlová operace

Pohyb vpravo zkoumá bajt za značkou:

```asm
ld b,(hl)
inc hl
ld a,(hl)
and a
jr z,.incAAndRet
ld (hl),b
dec hl
ld (hl),a
ret
```

Je-li další bajt nulový, kurzor už je na konci a nepohne se.

Jinak:

```text
před:  $01,x

po:    x,$01
```

Ani zde se neaktualizuje žádná číselná pozice kurzoru. Pohybuje se samotná značka.

## Backspace uzavírá mezeru

Backspace odstraní bajt před kurzorem. Nastaví dva pointery:

```text
HL = bajt před kurzorem
DE = kurzor
```

Potom kopíruje zbytek doleva, dokud nepřesune také nulový terminátor:

```asm
.shiftInputTailLeftAfterDeleteLoop:
    ld a,(de)
    ld (hl),a
    inc hl
    inc de
    or a
    jr nz,.shiftInputTailLeftAfterDeleteLoop
```

Předpokládejme buffer:

```text
'a','b','c',$01,'d',$00
```

Backspace vytvoří:

```text
'a','b',$01,'d',$00
```

Kurzor zůstane na stejném logickém místě vzhledem k přeživšímu textu, protože značka se kopíruje doleva společně se zbytkem.

Je-li bajtem před kurzorem ochranná hodnota `$80`, mazání se odmítne. Příkazový token lze smazat jako jeden celý bajt, což je užitečné pro zrušení příkazu a návrat k obyčejnému zadávání zdroje.

## Vložení tisknutelného znaku je putující výměna

Nejzajímavějším trikem editovatelného řádku je vkládání.

Běžná implementace by posunula celý zbytek o jeden bajt doprava a potom uložila nový znak. PROMETHEUS místo toho nese jeden vytlačený bajt podél řádku.

Na začátku:

```text
A  = nový znak
HL = značka kurzoru
```

Smyčka vymění bajt v `A` s bajtem na `HL`, postoupí dál a opakuje postup s vytlačeným bajtem.

Koncepčně:

```text
carry = newCharacter
position = cursor

repeat:
    displaced = buffer[position]
    buffer[position] = carry
    carry = displaced
    position++

until starý nulový terminátor byl zapsán
```

Při vložení `X` do:

```text
'a','b',$01,'c',$00
```

můžeme sledovat nesenou hodnotu:

```text
zapiš X, nes $01
zapiš $01, nes c
zapiš c, nes $00
zapiš $00, skonči
```

Výsledek:

```text
'a','b','X',$01,'c',$00
```

Kurzor se posunul o jednu pozici doprava a zůstal za vloženým znakem.

Skutečná smyčka Z80 používá alternativní akumulátor přes `EX AF,AF'`, aby mohla držet jak nesený bajt, tak právě načtený bajt, aniž by spotřebovala další obecný registr.

Je to výborný příklad nízkoúrovňového triku sloužícího jednoduchému vysokoúrovňovému pravidlu.

## Editovatelný řádek vždy vkládá znaky

Rozhraní používá slova INSERT a OVERWRITE, snadno však lze zaměnit dvě odlišné otázky.

### Vkládání znaků uvnitř dočasného řádku

Psaní tisknutelného znaku vždy posune zbytek doprava. V `updateInputBuffer` neexistuje žádná větev pro přepsání znaku.

### Vložení záznamu zdroje proti jeho nahrazení

`varcInsertMode` rozhoduje, co se stane při odeslání hotového řádku:

- nula: vloží nový komprimovaný záznam zdroje za aktivní záznam;
- jedna: vloží nový záznam a smaže starý aktivní záznam, čímž jej prakticky nahradí.

Klávesa EDIT nastaví `varcInsertMode` na jednu, protože uživatel mění existující zdrojový řádek. Příkaz W přepíná režim pro odeslání zdrojového řádku.

Režim „insert/overwrite“ se tedy v PROMETHEU týká především **řádků v komprimovaném zdroji**, nikoli znaků v dočasném editačním bufferu.

Tento rozdíl lze snadno přehlédnout, čteme-li pouze labely nebo text uživatelského rozhraní.

## SPACE zná pole zdrojového řádku

Při obyčejném zadávání zdroje se SPACE nevkládá vždy jako jediná doslovná mezera.

Editor používá tradiční uspořádání assembleru:

```text
sloupce 0–8      pole labelu, šířka 9
sloupce 9–13     pole mnemonic, šířka 5
sloupce 14–31    operandy a oblast komentáře
```

Je-li řádek obyčejným zdrojem a kurzor leží před sloupcem 14, SPACE doplní mezery až k následující hranici pole.

Kód změří posun značky kurzoru od `inputBufferStart` a odvodí jeden ze dvou cílů:

```text
před sloupcem 9       doplň do sloupce 9
sloupce 9 až 13       doplň do sloupce 14
sloupec 14 nebo dál   vlož jednu běžnou mezeru
```

Komentáře a řádky s příkazovým tokenem toto tabulování obcházejí:

```asm
ld a,(de)
cp ";"
jr z,.insertCharacterAtInputCursor
rlca
jr c,.insertCharacterAtInputCursor
```

Je-li prvním znakem `;`, zbytek řádku je volným textem komentáře.

Má-li první bajt nastaven bit 7, řádek začíná příkazovým tokenem. Argumenty příkazu se nemají násilně rovnat do polí zdroje assembleru.

U zdroje dovoluje automatické doplňování uživateli napsat:

```text
LOOP SPACE DJNZ SPACE LOOP
```

a získat vizuální uspořádání:

```asm
LOOP     DJNZ LOOP
```

Buffer obsahuje skutečné doplňovací mezery. Pozdější parser také rozumí značce kurzoru a hranicím polí, ale viditelné zarovnání už v bufferu existuje.

## EDIT rekonstruuje řádek do bufferu

Stisk kombinace EDIT na Spectru způsobí, že editor načte aktivní komprimovaný záznam do dočasné vstupní oblasti:

```asm
ld ix,(varcSourceBufferActiveLine+1)
ld hl,inputBufferStart
...
call expandSourceRecordToHL
ld a,001h
ld (varcInsertMode+1),a
```

Vstupní buffer se nejprve vymaže. Expander záznamu zdroje potom vytvoří editovatelný text, místo aby kreslil přímo na obrazovku.

Toto opětovné použití je důležité. PROMETHEUS neudržuje druhou trvalou textovou kopii zdroje. Má-li se řádek editovat, čitelný text se rekonstruuje až na požádání.

Režim se nastaví na overwrite, aby odeslání výsledku nahradilo původní záznam, místo aby vedle něj pouze vložilo duplikát.

## Odeslání vybírá mezi zdrojem a příkazem

Když ENTER nebo okamžitý token přiměje `updateInputBuffer` vrátit zero, editor skryje editační řádek a prozkoumá první logický vstupní bajt.

```asm
ld hl,inputBufferStart
call atHLorNextIfOne
cp 080h
jr c,parseAndInsertSourceLine
```

`atHLorNextIfOne` přeskočí značku kurzoru, pokud náhodou leží na začátku. Prázdný nebo obyčejný textový řádek se proto klasifikuje podle prvního skutečného znaku.

Pravidlo zní:

```text
první logický bajt < $80     zdrojový text
první logický bajt ≥ $80     tokenizovaný příkaz
```

Funguje to proto, že znaky zdroje jsou běžným sedmibitovým textem, zatímco příkazové tokeny záměrně obsazují oblast s nastaveným nejvyšším bitem.

Není třeba úplné porovnávání názvů příkazů.

## Vložení zdrojového řádku

Zdrojová cesta nejprve sestaví dočasný komprimovaný záznam:

```asm
call encodeInputLineToSourceRecord
```

Potom zvolí pozici za aktivním záznamem zdroje, otevře mezeru ve společné oblasti zdroje a symbolů a zkopíruje do ní bajty záznamu.

Nový záznam se stane aktivním.

Je-li `varcInsertMode` jedna, starý aktivní záznam se poté odstraní, takže se operace změní v nahrazení.

Ve zjednodušeném pseudokódu:

```text
newRecord = encode(editBuffer)
insertPosition = recordAfter(activeRecord)
insert newRecord at insertPosition
activeRecord = insertPosition

if overwriteMode:
    oldRecord = recordBefore(activeRecord)
    activeRecord = oldRecord
    delete oldRecord

reset mode to INSERT
go to warm start
```

Pořadí může působit nepřímo, vložení napřed však zaručuje, že nový záznam existuje dříve, než se odstraní starý. Zároveň dovoluje společnému mechanismu vkládání konzistentně upravit pohyblivé pointery.

## Proč buffer nemá explicitní délku

Řádek je ukončen nulou.

Značka kurzoru se při renderování najde a její adresa se uloží do cache. Vložení přesune starou nulu o jeden bajt doprava. Mazání kopíruje nulu o jeden bajt doleva. Scannery končí na nule.

Explicitní délkový bajt by se musel aktualizovat po každé editaci. PROMETHEUS místo toho nechává terminátor cestovat společně s textem.

Kontrola šířky obrazovky brání editoru, aby sdílený pracovní prostor plnil bez omezení, takže scan k nule zůstává levný.

## Řádek obsahující token není obyčejný text

Uvažujme:

```text
bajty bufferu:
    $D5,' ','5','0','0','0','0',$01,$00
```

Viditelný řádek:

```text
U-TOP 50000_
```

Kurzor vlevo se může pohybovat mezi číslicemi a mezerou, nemůže však vstoupit mezi viditelná písmena tokenu. Backspace na první pozici argumentu může token odstranit jako jediný celek. Příkazový dispatcher později přečte `$D5`, nikoli zobrazené slovo.

Vzniká tak užitečný dvouúrovňový model editace:

```text
obyčejné znaky      editovatelné po jednom
příkazový token     editovatelný jako jedno nedělitelné slovo
```

PROMETHEUS získává část pohodlí tokenizovaného BASICu a současně dovoluje obyčejné textové argumenty.

## Úplné zadání jednoho zdrojového řádku

Předpokládejme prázdný řádek a uživatel zadá:

```asm
START    LD A,1
```

Cesta uvnitř dočasného bufferu vypadá přibližně takto:

```text
počátek:
    $01,$00

napiš START:
    'S','T','A','R','T',$01,$00

stiskni SPACE:
    'S','T','A','R','T',' ',' ',' ',' ',$01,$00

zadej LD a SPACE:
    ... 'L','D',' ',' ',' ',$01,$00

zadej A,1:
    ... 'A',',','1',$01,$00
```

Překreslování opakovaně najde značku, vykreslí řádek a uloží viditelný sloupec do cache.

ENTER tyto bajty neuloží přímo do paměti zdroje. Předá je encoderu zdroje, který nahradí názvy a syntaxi kompaktním záznamem.

## Úplná operace EDIT

Předpokládejme, že aktivní trvalý záznam zdroje představuje:

```asm
LOOP     DJNZ LOOP
```

Stisk EDIT provede:

```text
1. vymaž vstupní pracovní prostor
2. rozbal komprimovaný záznam do čitelných polí
3. vlož značku kurzoru do rekonstruovaného řádku
4. nastav režim odeslání zdroje na overwrite
5. překresli editor s aktivním řádkem v editačním řádku
```

Uživatel změní `LOOP` na `AGAIN` a stiskne ENTER.

PROMETHEUS potom:

```text
1. analyzuje a zkomprimuje upravený text
2. vloží nový záznam
3. smaže starý záznam
4. vrátí režim na insert
5. překreslí zdroj z nové komprimované reprezentace
```

Bitmapa okna zdroje není nikdy považována za editovatelné úložiště.

## Úplný okamžitý příkaz

Předpokládejme prázdný řádek a uživatel stiskne SYMBOL SHIFT+H.

```text
1. processKey vrátí token $C8.
2. vkládací smyčka zapíše $C8 přes pozici kurzoru.
3. porovnání s $C8 se vrátí s nastaveným zero.
4. hlavní smyčka řádek okamžitě odešle.
5. command dispatch vybere invokeToggleNumberBase.
6. handler přepne varcHexMode a přes RET se vrátí na warm start.
```

Vstupní řádek není třeba překreslit se slovem `H` ani čekat na ENTER. Token je událostí stejně jako bajtem textu.

## Zpět k celému stroji

Editovatelný řádek je adaptérem mezi lidmi a komprimovanými strukturami.

Pro uživatele se chová jako krátký textový editor.

Pro renderer je proudem znaků a rozbalitelných tokenů.

Pro vrstvu klávesnice je cílem normalizovaných bajtů.

Pro command dispatcher je jeho první bajt s nastaveným nejvyšším bitem přímým indexem slovesa.

Pro encoder zdroje je čitelným textem labelu, mnemonic a operandů.

Pro páskové rutiny a monitor je stejná paměť vhodnou scratch oblastí.

Návrh zůstává zvládnutelný, protože každý výklad má jasný okamžik a jasný terminátor.

## Co se změnilo v paměti?

Po překreslení:

- `varcInputBufferPosition` ukazuje na značku `$01`;
- `varcInputColumnAfterCursor` zaznamenává příslušný fyzický sloupec;
- bitmapové bajty a atributy editačního řádku byly obnoveny;
- samotné vstupní bajty zůstaly beze změny.

Po pohybu kurzoru:

- `$01` si vyměnila místo s jedním sousedním bajtem;
- žádné explicitní číslo pozice kurzoru se nezměnilo.

Po vložení:

- nový bajt obsadil bývalou pozici kurzoru;
- kurzor i zbytek se posunuly doprava;
- nulový terminátor se posunul o jeden bajt doprava.

Po Backspace:

- zbytek, kurzor a terminátor se posunuly doleva;
- jeden bajt textu zmizel.

Po odeslání zdroje:

- jinde se vytvoří dočasný záznam;
- trvalá paměť zdroje se může přesunout;
- vstupní buffer se při warm start resetuje.

## Důležité myšlenky pro další kapitoly

- `$01` je pohyblivá značka kurzoru uvnitř editovatelného řetězce;
- `$00` ukončuje vstupní řádek;
- bajt před řádkem je chráněným předstupněm scanneru;
- bajty tokenů se rozbalují na slova pouze při renderování;
- vkládání omezuje fyzická šířka obrazovky, nikoli jen délka pracovního prostoru;
- pohyb kurzoru vyměňuje bajty místo změny číselného sloupce;
- vkládání je putující výměna využívající alternativní akumulátor;
- SPACE doplňuje obyčejný zdroj k hranicím polí labelu a mnemonic;
- editace znaků vždy vkládá, zatímco `varcInsertMode` řídí vložení nebo nahrazení záznamu zdroje;
- ENTER vrací svůj význam příznakem zero;
- první logický bajt rozhoduje, zda se odesílá zdroj, nebo příkaz.

## Vysvětlené body ve zdroji

- `inputBufferGuardByte`
- `inputBufferStart`
- `repaintEditLine`
- `renderInputLineAtBitmapAddress`
- `varcInputBufferPosition`
- `varcInputColumnAfterCursor`
- `varcTokenExpansionTableBase`
- `displayInputTokenOrCharacter`
- `atHLorNextIfOne`
- `updateInputBuffer`
- `.shiftInputTailLeftAfterDeleteLoop`
- `.shiftInputTailRightForInsertionLoop`
- `varcCapsLockEnabled` na úrovni editačního řádku
- `varcInsertMode`
- `invokeToggleInsertOverwrite`
- `submitInputLineOrDispatchCommand`
- `parseAndInsertSourceLine` na úrovni vkládání
- `encodedRecordStorageLength` na úrovni rozhraní
- `varcPostCommandContinuationJump` na přehledové úrovni
