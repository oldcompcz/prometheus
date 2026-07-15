# Kapitola 8: Rozhovor se Spectrem

PROMETHEUS nežije nad ZX Spectrem jako zdvořilá aplikace, která žádá operační systém, aby nakreslil okno nebo oznámil stisk klávesy. Není tu správce oken, grafická knihovna ani služba běžící na pozadí, která by každý hardwarový detail převáděla na pohodlný objekt.

Program mluví se strojem mnohem přímočařeji.

Zapisuje pixely znaků přímo do obrazové paměti.

Barvy zapisuje do samostatné oblasti atributů.

Žádá ROM Spectra, aby prohledala klávesnici, ale když potřebuje rychlejší odezvu, čte někdy klávesnicový port sám.

Rámeček obrazovky i reproduktor ovládá prostřednictvím téhož výstupního portu ULA.

Pro fyzické nahrávání a načítání používá kazetové rutiny ROM, kolem nich však staví vlastní souborové struktury vyšší úrovně.

Tato kapitola není úplným průvodcem hardwarem Spectra. Představuje pouze části potřebné k pochopení PROMETHEA. Podrobný převod kláves editoru patří do kapitoly 10 a kazetové pracovní postupy do části IV. Zde chceme porozumět společné vrstvě obrácené ke stroji, na níž tyto pozdější systémy stojí.

## Obrazovku tvoří dvě různé paměti

Viditelný obraz Spectra spojuje dvě oblasti:

```text
$4000-$57FF   pixely bitmapy
$5800-$5AFF   barevné atributy
```

Bitmapa obsahuje 6 144 bajtů. Každý bit představuje jeden pixel, takže jeden bajt popisuje osm vodorovných pixelů.

Oblast atributů obsahuje 768 bajtů, po jednom pro každou znakovou buňku 8×8 pixelů na obrazovce o 32 sloupcích a 24 řádcích.

Bajt atributu určuje:

- barvu inkoustu;
- barvu papíru;
- jas;
- blikání.

Toto rozdělení má důležitý důsledek. Nakreslit znak a obarvit jeho buňku jsou dvě různé operace.

PROMETHEUS tento rozdíl odráží ve dvou vrstvách:

- `displayCharacter` zapíše osm řádků bitmapy;
- `displayNormalCharacter` ji zavolá a poté zapíše odpovídající bajt atributu.

Některým volajícím stačí pixely. Jiní potřebují celou textovou buňku.

## Proč adresa v bitmapě vypadá podivně

Moderní lineární framebuffer by mohl ukládat řádky pixelů jeden za druhým. Bitmapa Spectra je prokládaná.

Uvnitř jedné znakové buňky jsou po sobě jdoucí řádky pixelů vzdáleny o `$0100`, nikoli o 32 bajtů. Také tři velké třetiny obrazovky jsou uspořádány způsobem, který činí jednoduché svislé výpočty překvapivými.

PROMETHEUS se vyhýbá opakovanému odvozování úplného obecného vzorce. Jeho vykreslovač znaků pracuje s reprezentací přirozeně odpovídající stroji:

- zvýšením dolního bajtu se posune o jeden znak doprava;
- zvýšením horního bajtu přejde na další pixelový řádek uvnitř glyfu 8×8;
- přičtením osmi k hornímu bajtu přejde po zalomení vodorovného řádku na další textový řádek;
- tam, kde to cyklus kurzoru vyžaduje, se z konce bitmapové paměti vrátí na `$4000`.

Podrobnosti jsou zakódovány v `displayCharacter`.

## Znak začíná ve fontu ROM

ROM Spectra obsahuje osmibajtovou bitmapu každého tisknutelného znaku. PROMETHEUS převede dolních sedm bitů kódu znaku na adresu ve fontu.

Nejvyšší bit má jiný úkol: volí inverzní zobrazení.

Začátek vykreslovače je kompaktní:

```asm
displayCharacter:
    add a,a
    ld h,00fh
    ld l,a
    sbc a,a
    ld c,a
    add hl,hl
    add hl,hl
```

Aritmetika sestaví adresu osmibajtového glyfu v ROM a zároveň převede původní nejvyšší bit na `$00` nebo `$FF` v registru `C`.

Hodnota `$00`/`$FF` slouží jako maska inverze:

```text
normální:  glyph XOR $00 = glyph
inverzní:  glyph XOR $FF = opačné pixely
```

Jde o užitečnou techniku Z80. Instrukce `SBC A,A` převede carry na masku přes celý bajt:

```text
carry vynulováno → A = $00
carry nastaveno  → A = $FF
```

Jediný příznak se změní na osm stejných bitů.

## Osm řádků, jeden znak

Aktuální cíl na obrazovce je uložen uvnitř této samomodifikující instrukce:

```asm
varcPrintingPosition:
    ld de,SECOND_LINE_ADDRESS
```

Vykreslovač si uloží počáteční cíl a osmkrát provede smyčku:

```asm
ld b,008h
.renderEightGlyphRowsLoop:
    ld a,(hl)
configurationPatchTarget01CharacterBoldTransform:
    nop
    or (hl)
    xor c
    ld (de),a
    inc hl
    inc d
    djnz .renderEightGlyphRowsLoop
```

Každý průchod:

1. načte jeden řádek fontu;
2. podle konfigurace jej zesílí;
3. podle konfigurace jej invertuje;
4. uloží jej do obrazové paměti;
5. přejde k dalšímu řádku fontu;
6. přejde k dalšímu pixelovému řádku Spectra.

Podivná dvojice:

```asm
nop
or (hl)
```

je konfigurovatelná transformace tučného písma představená v kapitole 5. Installer změní první bajt tak, aby se při vykonávání buď prakticky nic nestalo, nebo aby vznikla zesilující kombinace zvolená původním programem.

Podstatný není přesný vzhled. Důležité je, že instalační konfigurace změní instrukci uvnitř často prováděné vykreslovací smyčky a odstraní tak podmíněný skok z každého řádku glyfu.

## Posun textového kurzoru

Po vykreslení osmi obrazových řádků se PROMETHEUS posune o jednu znakovou buňku doprava:

```asm
inc l
jr nz,.commitNextCharacterBitmapPosition
```

Pokud se dolní bajt přetočí, vykreslovač překročil konec 32bajtového řádku bitmapy. Potom upraví horní bajt na následující textový řádek:

```asm
ld a,h
add a,008h
cp 058h
jr nz,.storeWrappedBitmapRowHighByte
ld a,040h
```

Nakonec se nový cíl zapíše zpět do operandu `varcPrintingPosition`.

V pseudokódu:

```text
nakresli osm řádků glyfu na printingPosition

printingPosition se posune o jeden bajt doprava
if vodorovný bajt přetekl:
    přejdi na další znakový řádek Spectra

zapamatuj novou printingPosition
```

Mnoho vykreslovacích rutin vyšší úrovně proto nepředává cíl pro každý znak. Jednou nastaví sdílený kurzor a opakovaně volají znakovou rutinu.

## Pixely a barvy se znovu spojí

`displayNormalCharacter` obklopí bitmapový vykreslovač ochranou alternativních registrů a výpočtem adresy atributu:

```asm
displayNormalCharacter:
    exx
    call displayCharacter
    ld a,h
    add a,00ah
    cp 05ah
    jr z,.storeTextAttribute
.mapBitmapRowToAttributeRowLoop:
    add a,007h
    cp 058h
    jr c,.mapBitmapRowToAttributeRowLoop
.storeTextAttribute:
    ld h,a
varcTextColor:
    ld (hl),038h
    exx
    ret
```

Mapovací aritmetika převede adresu bitmapy vrácenou pro znakovou buňku na její adresu atributu.

Přesná posloupnost vypadá podivně proto, že podivné je rozložení horního bajtu bitmapy Spectra. Výsledek je pojmově jednoduchý:

```text
attributeAddress = buňka atributu odpovídající právě vykreslenému glyfu
attribute[attributeAddress] = nakonfigurovaná barva textu
```

`varcTextColor` uchovává aktuální atribut v operandu instrukce. Různé části PROMETHEA jej před vykreslením zdroje, stavových informací, výběrů nebo polí monitoru přepíší.

## Bezpečný výstup znaku zachová druhou sadu registrů

Několik scannerů používá hlavní registry `HL` a `DE` k procházení textu nebo struktur zdroje. Pracovní registry však potřebuje také vykreslovač znaků.

PROMETHEUS oddělí oba úkoly pomocí alternativní sady registrů:

```asm
displayCharacterSafely:
    exx
    call displayCharacter
    exx
    ret
```

Z pohledu volajícího důležité registry scanneru přežijí.

`displayCharacterAtHL` přidává podporu sbalených řetězců:

```asm
displayCharacterAtHL:
    ld a,(hl)
    and 07fh
```

Před vstupem do bezpečného vykreslovače odstraní high-bit terminátor.

Tato vrstva vysvětluje, proč může být mnoho textových smyček tak malých. Ukazatel drží v normální sadě registrů, zatímco vykreslovač pracuje v sadě alternativní.

## Vymazání řádku znamená vymazat osm oddělených řádků bitmapy

Textový řádek o 32 znacích netvoří v obrazové paměti 256 souvislých bajtů. Skládá se z osmi pixelových řádků po 32 bajtech, z nichž každý leží v jiné rovině bitmapy.

`clearBitmapTextRow` proto používá dvě smyčky:

```text
repeat 8 pixelových řádků:
    vymaž 32 bajtů
    přejdi do další pixelové roviny
```

Zdrojová rutina má právě tento tvar:

```asm
ld b,008h
.clearNextBitmapPlaneRow:
    push hl
    ld c,020h
.clearThirtyTwoBitmapBytesLoop:
    ld (hl),000h
    inc l
    dec c
    jr nz,.clearThirtyTwoBitmapBytesLoop
    pop hl
    inc h
    djnz .clearNextBitmapPlaneRow
```

Volající předá bitmapovou adresu prvního pixelového řádku textového řádku.

Jde o specializovanou operaci. Když je třeba odstranit pouze pixely, je rychlejší a srozumitelnější než třicetidvakrát volat plný vykreslovač znaků s mezerou.

## Vymazání celého editoru jeho vlastním vykreslovačem

PROMETHEUS má také obecnější vymazání displeje:

```asm
clearDisplayToSpaces:
    ld e,020h
clearDisplay:
    ld bc,00003h
.clearDisplayCharacterLoop:
    ld a,e
    call displayNormalCharacter
    djnz .clearDisplayCharacterLoop
    dec c
    jr nz,.clearDisplayCharacterLoop
    ret
```

Dvojice `BC=$0003` může vypadat jako počet tří, ale `DJNZ` s `B=0` provede 256 průchodů, než se `B` znovu dostane na nulu. Vnější smyčka v `C` to zopakuje třikrát:

```text
3 × 256 = 768 znakových buněk
```

To přesně odpovídá textové mřížce Spectra 32×24.

Jde o klasický trik s kompaktní smyčkou:

```text
B = 0 znamená při DJNZ 256 průchodů
```

`startPrometheus` vloží do `E` oddělovací znak, zatímco `clearDisplayToSpaces` tam vloží mezeru. Obě cesty používají stejnou smyčku přes celou obrazovku.

Rutina kreslí prostřednictvím běžného znakového a atributového mechanismu, takže nakonfigurovaný font a barvy vytvoří konzistentní počáteční stav obrazovky.

## Rychlý scrolling zdroje kopíruje existující pixely

Překreslovat po každém opakovaném stisku šipky dvacet rozvinutých řádků zdroje by bylo drahé. PROMETHEUS místo toho posune již vykreslené bitmapové řádky a nakreslí pouze nově odkrytý řádek.

`copyScreenTextRowAtYToDE` požádá rutinu ROM Spectra o převod souřadnice textového řádku na odpovídající adresu bitmapy:

```asm
ld c,000h
call ROM_PixelAddress_22b0
```

Poté `copyEightBitmapRows` zkopíruje všech osm pixelových rovin řádku:

```asm
copyEightBitmapRows:
    push hl
    push de
    ld b,008h
.copyNextBitmapRow:
    push hl
    push de
    ld c,020h
.copyNextByteInBitmapRow:
    ld a,(hl)
    ld (de),a
    inc l
    inc e
    dec c
    jr nz,.copyNextByteInBitmapRow
    pop de
    pop hl
    inc h
    inc d
    djnz .copyNextBitmapRow
```

Není to obecná rutina `moveMemoryBlockOverlapSafe`, protože textový řádek není jediný souvislý blok o 256 bajtech. Každý z jeho osmi 32bajtových úseků má jiný horní bajt adresy.

Rutina se v každém úseku posouvá vodorovně a potom zvýší horní bajty pro další rovinu.

Při scrollingu drženou šipkou editor opakovaně volá tuto primitivu, posouvá viditelné řádky nahoru nebo dolů, vymaže jediný nově odkrytý řádek a vykreslí do něj pouze jeden komprimovaný záznam zdroje.

Jde o raný příklad optimalizace zvolené podle rozložení obrazovky Spectra, nikoli podle abstraktní představy textových řádků.

## Přístupový řádek se barví samostatně

Bitmapový text aktivního přístupového řádku editoru a jeho pás atributů jsou spravovány odděleně.

Při warm startu:

```asm
ld hl,ACCESS_LINE_ATTRIBUTE_ADDRESS
ld bc,02000h+HIGHLIGHT_COLOR
call atHLrepeatBTimesC
```

Sdílená plnicí rutina interpretuje:

```text
B = 32 buněk
C = atribut zvýraznění
```

a zapíše hodnotu atributu přes celý řádek.

Je to levné, protože atributy jsou lineární: jeden bajt na znakovou buňku. Složité rozložení bitmapy se jich netýká.

Později, když má být odeslaný editační řádek před parsováním skryt, jiná 32bajtová výplň atributů nastaví inkoust a papír na stejnou barvu. Pixely není třeba nejprve mazat; atributy je během operace zneviditelní.

Oddělená barevná paměť Spectra tedy není jen omezením. PROMETHEUS ji používá jako rychlou vrstvu řízení displeje.

## Klávesnici lze číst na dvou úrovních

PROMETHEUS běžně volá scanner klávesnice v ROM:

```asm
call ROM_KeyboardScanning
```

ROM vrátí index v tabulce kláves a informaci o modifikátorech. Kapitola 10 bude sledovat úplný převod na písmena, příkazy, šipky, chování CAPS LOCKu, debounce a autorepeat.

Na této úrovni je důležitý kontrakt:

```text
scanner ROM → index fyzické klávesy + třída modifikátoru
PROMETHEUS  → normalizovaný kód editoru nebo monitoru
```

Editor však někdy úplný převod obejde a čte port `$FE` přímo:

```asm
ld a,0efh
in a,(0feh)
```

Děje se to při rychlém scrollingu. Kód už přijal příkaz šipky dolů nebo nahoru a nyní potřebuje pouze jednoduchou odpověď:

```text
Je tato fyzická klávesa stále držena?
```

Spouštět po každém zkopírovaném řádku obrazovky celý překladač příkazů by bylo zbytečné. Přímý test řádku matice je rychlejší.

Program používá takovou úroveň abstrakce, která odpovídá otázce:

- scan ROM pro novou obecnou klávesovou událost;
- přímé čtení portu pro známou drženou klávesu;
- jiné přímé čtení při dlouhých importech, které zjišťuje SPACE/BREAK nebo požadavek na obnovení displeje.

## Aktivně nízké bity klávesnice

Čtení klávesnicové matice Spectra je aktivní v nule:

```text
bit 0 → klávesa stisknuta
bit 1 → klávesa uvolněna
```

Proto zdroj po čtení portu `$FE` někdy používá `CPL`. Komplementování bajtu převede stisknuté klávesy na nastavené bity, které se snadněji testují běžnými maskami.

Mladý čtenář může přirozeně očekávat, že „stisknuto“ znamená jedničku. Hardware takovou konvenci neslibuje. Elektrický význam určuje zapojení a software se přizpůsobí.

## Jeden port ULA ovládá rámeček i zvuk

Výstupní port ULA Spectra je rovněž `$FE`.

Dolní bity volí barvu rámečku. Jiný bit ovládá cestu k malému reproduktoru.

PROMETHEUS obnovuje nakonfigurovanou barvu rámečku takto:

```asm
setBorderColor:
    ld a,007h
    out (0feh),a
    ret
```

Skutečný bezprostřední bajt je hodnota nastavená installerem.

Kliknutí klávesy i obecný beep používají stejný port:

```asm
.beepToggleLoop:
    ld b,e
    xor 010h
.beepPulseDelayLoop:
    out (0feh),a
    djnz .beepPulseDelayLoop
```

`XOR $10` přepíná bit reproduktoru. Vnitřní čekací smyčka drží jednu fázi po dobu zvolenou v `E`. Opakováním fází vzniká obdélníkový průběh.

Bity rámečku zůstávají v témže výstupním bajtu, a proto rutina beeperu nese také nakonfigurovanou barvu rámečku. Bez této opatrnosti by zvukový výstup mohl rámeček nečekaně přebarvit.

## Zvuk vzniká časovacími smyčkami

Neběží zde žádný zvukový syntezátor na pozadí. Samotný procesor střídá výstupní bit a tráví čas v čekacích smyčkách.

Pojmově:

```text
repeat po požadovanou celkovou dobu:
    přepni výstup reproduktoru
    opakovaně zapisuj na port ULA po dobu jedné půlvlny
```

Výška tónu závisí na délce každé fáze. Celková délka pípnutí závisí na počtu vytvořených fází.

Protože je CPU během pípnutí zaměstnáno, udržuje PROMETHEUS kliknutí klávesy krátké. Je to zpětná vazba, nikoli hudební vystoupení.

To také vysvětluje, proč se přesné časování může změnit se změnou cesty kódem. Počet taktů je součástí výsledku.

## Rutiny ROM jsou služby s kontraktem

PROMETHEUS kombinuje přímý přístup k hardwaru s voláním ROM Spectra.

Příklady:

- `ROM_KeyboardScanning` — scan klávesnicové matice;
- `ROM_PixelAddress_22b0` — převod souřadnic na adresu bitmapy;
- `ROM_ChannelOpen` a `RST $10` — tisk prostřednictvím kanálů Spectra;
- vstupní body pro načítání a ukládání na kazetu;
- `ROM_StatementReturn` — návrat do BASICu;
- `ROM_NEWCommandRoutine` — vstup do cesty příkazu NEW v ROM.

Adresu ROM nelze chápat jako magické zaklínadlo. Každé volání má implicitní volací konvenci:

```text
vstupy v určitých registrech nebo systémových proměnných
výsledek v určitých registrech a příznacích
některé registry nebo paměť mohou být změněny
může záležet na stavu přerušení
```

Rekonstrukce dává těmto adresám popisná jména, aby čtenář mohl uvažovat o službě místo memorování hexadecimálních čísel.

Například odchod z PROMETHEA do BASICu není pouhým skokem na adresu ROM:

```asm
invokeBasic:
    ld iy,05c3ah
    im 1
    ei
    ld sp,(SYSVAR_ERR_SP)
    jp ROM_StatementReturn
```

Rutina obnoví předpoklady očekávané ROM:

- `IY` ukazuje do oblasti systémových proměnných Spectra;
- je aktivní režim přerušení 1;
- maskovatelná přerušení jsou povolena;
- zásobník používá návratovou pozici pro chyby uloženou ROM.

Teprve potom lze bezpečně vstoupit do návratové cesty příkazu ROM.

## PROMETHEUS obvykle ponechává přerušení zakázaná

`startPrometheus` začíná instrukcí:

```asm
di
```

Rezidentní editor a monitor často používají alternativní registry, samomodifikující stav, přesné časování a vlastní uspořádání zásobníku. Běžná obsluha přerušení Spectra by mohla tyto předpoklady narušit.

Když PROMETHEUS záměrně používá službu ROM, která přerušení očekává, lokálně je povolí. Tisk zdroje přes kanál ROM 3 například obsahuje:

```asm
call ROM_ChannelOpen
ei
...
rst ROM_PrintACharacter
```

Návrat do BASICu obnoví běžné prostředí přerušení natrvalo.

Pravidlo tedy není prosté „přerušení jsou vždy vypnuta“. Přesněji:

```text
rezidentní PROMETHEUS vlastní stroj a obvykle zakazuje přerušení
cesty používající ROM obnoví prostředí požadované ROM
```

## Zásobník je rovněž součástí rozhraní stroje

Při každém warm startu editor nastaví:

```asm
ld sp,internalStackTop
```

Tím zahodí všechna opuštěná vnitřní volání a znovu ustaví známý soukromý zásobník.

Návrat do BASICu naproti tomu načte `SP` ze `SYSVAR_ERR_SP`, protože ROM očekává vlastní zásobníkový rámec a řetězec návratu z chyby.

Ukazatel zásobníku tedy není pouze místní implementační detail. Pomáhá určit, který softwarový svět právě vlastní stroj:

- rezidentní zásobník PROMETHEA;
- zásobník uživatelského programu uložený monitorem;
- zásobník ROM/BASICu Spectra.

Pozdější kapitoly ukážou, jak monitor při krokování jiného programu mezi těmito světy přepíná.

## Přístup ke kazetě má dvě vrstvy

Fyzické kazetové rutiny Spectra rozumějí signálu, zaváděcímu tónu, hlavičkám, příznakům, kontrolním součtům a blokům bajtů. PROMETHEUS tyto služby ROM volá, místo aby znovu vytvářel dekodér pulzů.

Nad touto vrstvou PROMETHEUS určuje vlastní význam bajtů:

- editorový SAVE balí zdroj a symboly;
- LOAD a VERIFY tento balík interpretují;
- import z GENS považuje payload za cizí text členěný po řádcích;
- monitor ukládá nebo načítá surové bloky paměti;
- distribuovaný TAP obsahuje BASICový loader a instalovatelný obraz kódu.

Jde o další opakující se architektonické rozdělení:

```text
ROM:        přenáší fyzické bajty na kazetu nebo z kazety
PROMETHEUS: rozhoduje, co tyto bajty znamenají
```

Vrátíme se k němu v kapitolách 29–32 a 41.

## Proč editor nepoužívá textový výstup ROM?

ROM umí tisknout znaky, proč si tedy PROMETHEUS nese vlastní vykreslovač fontu?

Ze zdroje vyplývá několik důvodů:

- PROMETHEUS chce přesně řídit cílové adresy bitmapy;
- používá několik nezávislých oblastí obrazovky místo jediného kurzoru ROM;
- mění velikost písmen ve zdroji, aniž by měnil citovaný text;
- podporuje volitelné normální nebo tučné vykreslování;
- kreslí inverzní a zvláštní značkovací znaky;
- scrolluje řádky zdroje kopírováním rovin bitmapy;
- obvykle běží se zakázanými přerušeními a mimo standardní kanálové prostředí ROM;
- front panel monitoru používá kompaktní deskriptory a přímé pozice.

ROM zůstává užitečná pro občasný externí tisk a převod souřadnic, interaktivní rozhraní má však vlastní zobrazovací systém.

## Úplná cesta výstupu jednoho znaku

Představme si, že chce editor zobrazit písmeno `A` ve výpisu zdroje.

Cesta je přibližně tato:

```text
scanner rozvinutého zdroje získá 'A'
    ↓
displayCharacterSafely ochrání registry scanneru
    ↓
displayCharacter najde glyph v ROM
    ↓
osm řádků glyfu se transformuje a zapíše do bitmapy
    ↓
printing position se posune
    ↓
displayNormalCharacter převede buňku na paměť atributů
    ↓
uloží se nakonfigurovaný atribut textu
```

Pochází-li znak ze sbaleného high-bit řetězce, `displayCharacterAtHL` nejprve odmaskuje bit terminátoru.

Jde-li o tokenový bajt místo znaku, `displayInputTokenOrCharacter` rozvine token na sbalené slovo a odešle každý znak stejnou výstupní cestou.

## Úplný scrolling drženou šipkou

Pro drženou šipku dolů:

```text
processKey přijme příkaz dolů
    ↓
ukazatel aktivního záznamu zdroje postoupí
    ↓
existující viditelné řádky bitmapy se zkopírují vzhůru
    ↓
nově odkrytý spodní řádek se vymaže
    ↓
příslušný komprimovaný záznam zdroje se rozvine a vykreslí
    ↓
port $FE se přečte přímo
    ↓
repeat, dokud zůstává fyzická šipka stisknuta
```

Tím se při každém opakování nemusí znovu vytvářet všech dvacet řádků zdroje.

Editor stále provede úplné překreslení warm startem, kdykoli je to nutné, nejběžnější případ držené klávesy však dostává rychlou cestu přizpůsobenou hardwaru.

## Úplné kliknutí klávesy

```text
normalizovaná klávesa přijata
    ↓
keypressBeep načte nakonfigurovanou délku
    ↓
beep spojí nakonfigurované bity rámečku se stavem reproduktoru
    ↓
bit reproduktoru se střídá v časovaných smyčkách OUT ($FE),A
    ↓
pokračuje běžné zpracování editoru
```

Tentýž zápis do ULA ovládá dvě viditelné či slyšitelné vlastnosti, takže rutina musí zachovat jejich zamýšlenou kombinaci.

## Zpět k celému stroji

PROMETHEUS není od Spectra oddělen silnou softwarovou vrstvou. Jeho návrh sleduje fyzický stroj.

Prokládaná bitmapa vede k osmiplošnému vykreslovači znaků a specializovanému kopírování řádků.

Oddělené atributy umožňují levné změny barevných pásů a skrývání pomocí stejné barvy inkoustu a papíru.

Klávesnicová matice vede k převodní cestě ROM pro obecné události a přímým testům portu pro známé držené klávesy.

Společný port rámečku a reproduktoru vyžaduje pečlivé sestavení výstupního bajtu.

ROM podporuje selektivní znovupoužití: PROMETHEUS si půjčuje vyzrálé služby, například kazetu a scan klávesnice, ale zachovává si kontrolu nad interaktivním displejem a interními daty.

Pochopení tohoto vztahu chrání před běžnou chybou při čtení zdroje. Podivná smyčka nebo výpočet adresy nemusí být soukromým vynálezem PROMETHEA. Může to být tvar hardwaru Spectra, který prosvítá kódem.

## Co se změnilo v paměti nebo hardwaru?

Po vykreslení jednoho běžného znaku:

- bylo zapsáno osm bajtů bitmapy v oddělených řádcích pixelových rovin;
- byl přiřazen jeden bajt atributu;
- `varcPrintingPosition` ukazuje na další znakovou buňku.

Po rychlém zkopírování řádku:

- se přesunulo osm skupin po třiceti dvou bajtech bitmapy;
- atributy zůstaly okolní logice editoru, protože barevné rozložení okna zdroje je stabilní.

Po zápisu barvy rámečku:

- ULA okamžitě změní viditelnou barvu rámečku.

Během pípnutí:

- bit ovládající reproduktor se střídá, zatímco bity rámečku zůstávají přítomny ve výstupním bajtu.

Během volání ROM:

- registry, příznaky, systémové proměnné, zásobník a stav přerušení musí splňovat kontrakt služby.

## Důležité myšlenky pro pozdější kapitoly

- Pixely a barvy Spectra leží v oddělených oblastech paměti.
- Textový řádek není jediný souvislý blok bitmapy.
- `varcPrintingPosition` je sdílený rezidentní kurzor obrazovky.
- Nejvyšší bit znaku může volit inverzní vykreslení.
- Alternativní registry chrání textové scannery před vykreslovačem.
- Přímý přístup k portu a služby ROM existují vedle sebe; každý se používá tam, kde se hodí.
- Tentýž port `$FE` se účastní vstupu klávesnice, výstupu rámečku i zvukového výstupu; směr a zvolené řádky určuje konkrétní operace.
- Rezidentní PROMETHEUS obvykle vlastní stroj se zakázanými přerušeními, ale cesty obrácené k ROM obnovují její předpoklady.

## Vysvětlené orientační labely zdroje

- `displayCharacter`
- `displayNormalCharacter`
- `displayCharacterSafely`
- `displayCharacterAtHL`
- `displayUninvertedCharacter`
- `varcPrintingPosition`
- `varcTextColor`
- `configurationPatchTarget01CharacterBoldTransform`
- `clearBitmapTextRow`
- `clearLineAtHL`
- `clearDisplay`
- `clearDisplayToSpaces`
- `copyScreenTextRowAtYToDE`
- `copyEightBitmapRows`
- `setBorderColor`
- `keypressBeep`
- `beep`
- `getKeypressCodeOrZero` na úrovni rozhraní
- `ROM_KeyboardScanning`
- `ROM_PixelAddress_22b0`
- `ROM_ChannelOpen`
- `ROM_PrintACharacter`
- `invokeBasic`
- `internalStackTop`
