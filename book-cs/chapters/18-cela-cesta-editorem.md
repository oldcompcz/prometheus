# Kapitola 18: Celá cesta editorem

Editor jsme zkoumali po vrstvách:

- scanování klávesnice;
- příkazové tokeny;
- editovatelný řádek;
- komprimované záznamy zdroje;
- parsování textu do záznamu;
- rozbalování záznamu zpět na text;
- navigace ve zdroji;
- vkládání a mazání v paměti;
- blokové příkazy a pokračující hledání.

Nastal čas tyto vrstvy znovu složit dohromady.

Tato kapitola nepřináší žádnou zásadní novou datovou strukturu. Místo toho sleduje jedno malé editační sezení od prstů uživatele přes pohyblivou zabalenou oblast zdroje až zpět na obrazovku. Cílem je nahradit sbírku názvů rutin jediným souvislým mentálním obrazem.

Naším průběžným programem je:

```asm
        ORG 32768
START   LD B,5
LOOP    DJNZ LOOP
        RET
        ENT START
```

V této fázi nás zajímá, jak editor program ukládá a mění. Assemblerový význam `ORG`, `ENT`, labelů a opcodes rozvineme v části III.

## Před první klávesou

Po cold startu už dynamická oblast zdroje obsahuje dvacet platných prázdných záznamů:

```text
13 horních výplňových záznamů
1 záznam přístupového řádku
6 dolních výplňových záznamů
```

Aktivní ukazatel označuje `sourceBufferAccessLine`. Oba ukazatele vybraného bloku začínají rovněž na tomto místě. Za zdrojem následuje tabulka symbolů s nulovým počtem položek.

Obrazovka není paměťovým dumpem těchto záznamů. `renderVisibleSourceRecords` přejde od aktivního ukazatele o třináct záznamů zpět, postupně rozbalí dvacet záznamů do `lineBuffer` a vykreslí jejich textovou podobu.

Každý viditelný řádek zdroje je prázdný, editor však už používá svůj definitivní navigační algoritmus.

## Zadání `ORG 32768`

Uživatel píše znaky na klávesnici Spectra.

Při každém stisku:

```text
služba klávesnice ROM rozpozná klávesu
PROMETHEUS normalizuje shifty a CAPS LOCK
tisknutelný znak se vloží před značku kurzoru $01
značka kurzoru se posune doprava
editační řádek se překreslí
```

Dočasný buffer nakonec obsahuje viditelný text, jednu pohyblivou značku a nulami vyplněný konec.

Po stisku ENTER oznámí `updateInputBuffer` dokončený řádek. Hlavní smyčka skryje editační řádek a prohlédne první významný bajt.

Jde o obyčejný zdrojový text, nikoli příkazový token, takže řízení přejde na `parseAndInsertSourceLine`.

## Parser vytváří význam před uložením

Encoder oddělí pole, normalizuje zápis, vyhledá pseudo-operaci a ověří její operand.

Vytvoří připravený záznam obsahující:

- identifikátor opcode/pseudo-opcode;
- informační bity;
- zakódovaný výraz pro `32768`;
- koncovou značku záznamu proměnné délky;
- jeden úvodní bajt počtu kopírovaných bajtů mimo trvalý záznam.

Zdroj se v této chvíli ještě nezměnil. Parser připravil v dočasném pracovním prostoru úplného kandidáta.

Toto transakční pořadí je důležité:

```text
nejprve validuj
trvalou paměť přesuň až po úspěchu
```

Syntaktická chyba vrátí řízení editoru a stávající zdroj ponechá neporušený.

## První vložení

Editor si vyžádá záznam následující po aktivním prázdném řádku. Jeho adresa se stane bodem vložení.

`insertByteRangeAtHLFromDE`:

1. zkontroluje U-TOP;
2. posune zbývající prázdné záznamy zdroje a prázdnou tabulku symbolů vzhůru;
3. posune `varcSymbolTablePt` a `varcCodeEndPt`;
4. opraví ukazatele vybraného bloku, leží-li na mezeře nebo nad ní;
5. zkopíruje připravený záznam `ORG` do mezery.

Volající potom nastaví nový záznam jako aktivní.

Zabalený zdroj nyní vypadá přibližně takto:

```text
13 horních prázdných záznamů
původní prázdný záznam přístupového řádku
záznam ORG              ← aktivní
zbývající dolní prázdné záznamy
tabulka symbolů
```

Warm start znovu sestaví viditelné okno. Nově rozbalený řádek `ORG 32768` se objeví na přístupovém řádku.

## Zadání zbývajících řádků

Každý následující řádek zdroje opakuje stejnou obecnou cestu:

```text
klávesy
→ vstupní buffer
→ parser polí
→ vyhledání mnemonic/operandu
→ připravený komprimovaný záznam
→ vložení mezery za aktivním záznamem
→ nový záznam se stane aktivním
→ obrazovka se znovu sestaví
```

U `START LD B,5` parser narazí také na label `START`. Získá nebo vytvoří kompaktní pořadové číslo symbolu a místo opakování celého jména uloží do komprimovaného záznamu právě toto pořadové číslo.

U `LOOP DJNZ LOOP` se stejné jméno objeví jako definice i jako odkaz v operandu. Podrobný životní cyklus tabulky symbolů patří do kapitol 23 a 24, skutečnost důležitá pro editor je však už nyní zřejmá:

```text
viditelné jméno LOOP
    ↕
malé pořadové číslo uvnitř záznamů zdroje
    ↕
trvalá položka tabulky symbolů obsahující zápis jména
```

`RET` může použít krátký pevný záznam. `ENT START` používá záznam pseudo-operace se zakódovaným odkazem na symbol.

Délky záznamů se liší, navigaci to však nezajímá. Každý záznam čte podle jeho vlastní hlavičky a koncové značky.

## Jak zdroj fyzicky vypadá

Zjednodušený pohled může vypadat takto:

```text
$....  prázdný výplňový záznam
$....  prázdný přístupový záznam
$....  záznam ORG                  proměnná délka
$....  záznam START / LD B,5       proměnná délka
$....  záznam LOOP / DJNZ LOOP     proměnná délka
$....  záznam RET                  pevná nebo krátká strukturovaná podoba
$....  záznam ENT START            proměnná délka
$....  prázdné koncové záznamy
$....  počet položek tabulky symbolů
$....  vektory symbolů
$....  jména a hodnoty symbolů
$....  chráněný konec oblasti
```

Záznamy neoddělují žádné znaky nového řádku. Pohyb dopředu i dozadu umožňuje jejich vlastní struktura.

Vedle nich se neukládá ani text ve formátu obrazovky. Text se rekonstruuje teprve tehdy, když je zapotřebí.

## Pohyb vzhůru k editaci `LD B,5`

Uživatel několikrát stiskne šipku nahoru.

Každý pohyb:

```text
načte ukazatel aktivního záznamu
použije poslední bajt předchozího záznamu jako zpětný odkaz
zkontroluje nejčasnější povolenou aktivní pozici
uloží kandidátní ukazatel
odscrolluje bitmapu nebo překreslí okno zdroje
```

Když se `START LD B,5` stane aktivním, stisk EDIT rozbalí tento komprimovaný záznam do kanonického textu.

Cesta je opakem zadávání zdroje:

```text
hlavička záznamu
→ pořadové číslo labelu se převede na START
→ descriptor instrukce se převede na LD
→ descriptory operandů se rozbalí na B a 5
→ pole se zapíší do lineBuffer
→ text se zkopíruje do editovatelného vstupního bufferu
→ nainstaluje se značka kurzoru $01
```

Uživatel vidí zdroj, nikoli pořadová čísla a indexy tabulek.

## Ruční změna 5 na 8

Předpokládejme, že uživatel posune kurzor doleva, smaže `5`, napíše `8` a při aktivním režimu OVERWRITE stiskne ENTER.

Nový text se parsuje od začátku. PROMETHEUS se nepokouší opravit starý bajt číselného výrazu na místě.

Sekvence commitu je:

```text
zakóduj nový záznam LD B,8
vlož jej za starý záznam LD B,5
nastav nový záznam jako aktivní
vrať se o záznam zpět ke starému záznamu
smaž starý záznam
nový záznam sklouzne na jeho původní místo
obnov výchozí režim INSERT
warm start
```

Stejný postup funguje i tehdy, když se zakódovaná délka změní.

Viditelná operace zní „nahraď tento řádek“. Paměťová operace zní „vlož nový platný záznam a potom odstraň starý“.

## Vyhledání `LOOP`

Uživatel zadá:

```text
FIND s:loop
```

První bajt je příkazovým tokenem, takže odeslání pokračuje přes `commandHandlerTable`, nikoli přes parser zdroje.

FIND:

```text
uloží vzor "loop" převedený na malá písmena
nastaví rozsah na celý zdroj
umístí scanovací kurzor před první skutečný záznam
postupuje po jednom záznamu
každý rozbalí do lineBuffer
porovnává viditelné znaky a přeskakuje oddělovače $01
```

Prvním úspěšným záznamem může být řádek definice:

```asm
LOOP    DJNZ LOOP
```

Tento komprimovaný záznam se stane aktivním. Warm start jej umístí na přístupový řádek.

Všimněme si, kolik reprezentací spolupracuje:

- příkazový řádek je tokenizovaný vstup editoru;
- vyhledávací vzor je text malými písmeny s prefixem délky;
- zdroj tvoří komprimované sémantické záznamy;
- každý kandidát se rozbalí na kanonický text řádku;
- porovnávání ignoruje formátovací značky;
- úspěch se vrací pomocí carry;
- ukazatel záznamu se stane stavem editoru.

Žádná reprezentace není nucena dělat práci jiné reprezentace.

## Nahrazení jedné hodnoty příkazovou cestou

Předpokládejme, že uživatel nejprve najde `5` na řádku `LD B,5` a zadá:

```text
REPLACE :8
```

REPLACE rozbalí aktivní záznam, provede textovou náhradu při sestavování běžného vstupního řádku a odešle tento řádek stejnému parseru, který používá ruční editace.

Commit je tedy stejnou cestou OVERWRITE, jakou jsme popsali výše. Jediným novým prvkem je continuation po příkazu, která po návratu parseru znovu spustí FIND.

Ruční editace a příkazová náhrada se spojí ještě před změnou trvalého zdroje:

```text
ruční klávesy ──────────────┐
                            ├→ inputBuffer → parser → připravený záznam → commit
rekonstrukce REPLACE ───────┘
```

Toto sjednocení patří k nejsilnějším rozhodnutím návrhu editoru. Validaci i kódování zdroje drží na jediném místě.

## Označení bloku

Chce-li uživatel vybrat dva prostřední řádky, navštíví jeden konec a stiskne klávesu okraje bloku, potom přejde na druhý konec a stiskne ji znovu.

Speciální operace klávesy přesune starou horní hranici do dolního slotu a uloží aktuální aktivní záznam jako novou horní hranici.

Po normalizaci může blok vypadat takto:

```text
low  = LOOP / DJNZ LOOP
high = RET
```

Samotné záznamy se nezměnily. Při překreslení rozpozná `testSourceRecordOutsideSelectedBlock` záznamy uvnitř inkluzivního adresového rozsahu a před vykreslením vloží do `lineBuffer` dočasnou značku.

Výběr existuje ve stavu editoru a na obrazovce, nikoli v trvalých bajtech zdroje.

## Zkopírování bloku

Uživatel přesune aktivní řádek na `ENT START` a vyvolá COPY.

COPY:

```text
normalizuje hranice bloku
postoupí jednou za RET
spočítá počet vybraných bajtů
ověří, že bod vložení neleží přísně uvnitř výběru
otevře mezeru před ENT START
opraví zdrojový ukazatel, pokud pohyb mezery přesunul původní blok
zkopíruje do mezery přesné komprimované bajty
```

Fyzickým výsledkem je:

```asm
        ORG 32768
START   LD B,8
LOOP    DJNZ LOOP
        RET
LOOP    DJNZ LOOP      ; copied bytes, same symbol ordinals
        RET
        ENT START
```

Editoru nevadí, že je nyní `LOOP` definováno dvakrát. COPY je strukturální operace editoru. Diagnostika duplicitního labelu patří assembleru.

Tato hranice odpovědností je zdravá:

```text
editor se ptá: jsou to platné záznamy zdroje a je paměť strukturálně v pořádku?
assembler se ptá: má celý program platné definice a významy?
```

## Smazání zkopírovaného bloku

Po označení duplikovaného dvouřádkového rozsahu uživatel vyvolá DELETE. Původní výběr po COPY zůstal na původních záznamech; výběr následuje přesunuté bajty, COPY však automaticky nevybere nový duplikát.

DELETE spočítá dva záznamy, zhutní veškerý pozdější zdroj i bajty tabulky symbolů směrem dolů, vyčistí uvolněný konec a obnoví případné požadované prázdné záznamy.

Potom zvolí nejbližší přeživší řádek, zúží na něj oba blokové ukazatele a nastaví jej jako aktivní.

Zdroj se vrátí do podoby:

```asm
        ORG 32768
START   LD B,8
LOOP    DJNZ LOOP
        RET
        ENT START
```

Obrazovka se z opraveného řetězce záznamů znovu sestaví. Nezůstane žádná stará značka výběru, protože stav bloku byl výslovně resetován.

## Vytištění programu

PRINT neprochází řádky obrazovky. Prochází komprimované záznamy od začátku zdroje.

Pro každý záznam:

```text
rozbal do lineBuffer
otvři/použij kanál 3
odešli viditelný kanonický text
odešli carriage return
pokračuj
```

Volba omezená na blok požádá stejný scanner, aby kandidáty filtroval pomocnou rutinou vybraného bloku.

Zdroj na papíře nebo externím výstupu se tedy znovu generuje ze sémantických záznamů stejně jako zdroj na obrazovce.

## Obrazovka je vždy jen projekcí

Během celého sezení text na obrazovce opakovaně mizel a znovu se sestavoval. Nejde o ztrátu dat, protože obrazovka není primárním modelem zdroje.

Směr autority je:

```text
trvalé komprimované záznamy
        ↓ expanze
lineBuffer
        ↓ vykreslení
bitmapa a atributy Spectra
```

Editační řádek je dočasnou výjimkou. Během psaní je `inputBufferStart` aktivním pracovním prostorem čitelným člověkem. Autoritativním se stane teprve poté, co parser ověří a uloží nový záznam.

Tento model brání běžné třídě chyb editorů: není nutné synchronizovat řádek na obrazovce, editovatelný řádek a uložený textový řádek jako tři dlouhodobě existující kopie.

## Tabulka symbolů se pohybuje, i když se symboly nemění

Přidání, kopírování nebo mazání zdroje posouvá tabulku symbolů, protože je zabalená bezprostředně za záznamy zdroje.

K tomu může dojít i tehdy, když se logická množina symbolů nezmění. COPY například duplikuje záznamy zdroje, které používají existující pořadová čísla. Bajty tabulky se posunou vzhůru, počet položek i jména však mohou zůstat totožné.

Proto je `varcSymbolTablePt` součástí každého strukturálního vložení a mazání. Editor musí fyzickou tabulku následovat, i když se sémantika symbolů nezměnila.

Část III ukáže, že samotná tabulka obsahuje dvě související uspořádání — vektory pořadových čísel a abecedně řazené položky. Prozatím je důležité, že se celá struktura pohybuje jako jediný suffix.

## Chybové cesty zachovávají starý zdroj

Několik operací může selhat před commitem:

- zdrojový řádek má neplatnou syntaxi;
- číslo je příliš velké;
- kombinace mnemonic/operandu není známa;
- náhrada by překročila 31 viditelných znaků;
- vložení by překročilo U-TOP;
- cíl COPY leží uvnitř vybraného rozsahu.

Kód je uspořádán tak, aby tyto chyby nastaly před trvalou změnou — nebo na kontrolované hranici uvnitř ní.

Parser dokončí připravený záznam před vložením. U-TOP se ověří před posunem bajtů. COPY zkontroluje cíl před otevřením mezery. REPLACE vytvoří omezený vstupní řádek před jeho odesláním parseru.

Když se chybová cesta vrátí do editoru, invarianty řetězce zdroje zůstávají platné.

## Kompaktní pseudokódový model editoru

Editor nyní můžeme popsat bez detailů registrů Z80:

```text
initialize:
    active = trvalý přístupový záznam
    selection = active..active

main loop:
    vykresli dvacet záznamů zdroje kolem active
    vykresli stav a editační řádek
    key = přečti normalizovanou klávesu

    if key naviguje:
        candidate = adjacentRecord(active)
        if candidate zachovává výplň zobrazení:
            active = candidate
        continue

    if key upravuje dočasný řádek:
        změň inputBuffer a značku kurzoru
        continue

    if key odesílá obyčejný zdroj:
        staged = parseAndEncode(inputBuffer)
        vlož staged za active
        active = záznam staged
        if overwrite:
            smaž předchozí záznam
        continue

    if key odesílá příkaz:
        dispatch příkazový token
        příkaz může scanovat, rozbalovat, vkládat, mazat, tisknout nebo měnit stav
        continue
```

Tento model vynechává mnoho užitečných detailů, zachycuje však tep editoru.

## Spirála shora dolů, zdola nahoru a znovu shora dolů

Na začátku části II vypadal editor jako jednoduchá smyčka:

```text
vykresli
přečti klávesu
proveď akci
opakuj
```

Potom jsme sestoupili k:

- hlášením klávesnice ROM;
- příkazovým tokenům;
- in-band značce kurzoru;
- kompaktním hlavičkám záznamů;
- descriptorům instrukcí a operandů;
- pořadovým číslům symbolů;
- značkám zpětných odkazů;
- přesunu překrývající se paměti;
- samomodifikovaným ukazatelům;
- scanům řízeným callbackem.

Nyní se můžeme k jednoduché smyčce vrátit, aniž bychom ji považovali za magii.

„Proveď akci“ může znamenat posunout jediný ukazatel záznamu. Může také znamenat rozbalit záznam, znovu sestavit editovatelný řádek, naparsovat jej, přesunout celou tabulku symbolů a smazat starý záznam. Nebo může znamenat změnit jedinou adresu callbacku a nechat obecný scanner vytisknout celý zdroj.

Viditelný editor zůstává soudržný, protože všechny tyto mechanismy respektují několik invariantů.

## Ústřední invarianty editoru

Při každém běžném warm startu platí:

```text
1. activeLine ukazuje na první bajt platného záznamu zdroje
2. selectedBlockStart a selectedBlockEnd ukazují na začátky platných záznamů
3. záznamy zdroje jsou těsně zabalené bez mezer
4. každý proměnný záznam má platnou koncovou značku / zpětný odkaz
5. symbolTablePt ukazuje bezprostředně za oblast zdroje
6. codeEnd ohraničuje živou společnou oblast zdroje a symbolů
7. nad nejčasnějším aktivním řádkem existuje třináct platných výplňových záznamů
8. pod nejpozdějším aktivním řádkem zůstává šest platných záznamů
9. inputBuffer při editaci obsahuje jednu pohyblivou značku kurzoru
10. lineBuffer je dočasný a může být kdykoli znovu sestaven
```

Jednotlivé rutiny jsou krátké, protože těmto podmínkám mohou důvěřovat.

`getPreviousSourceRecord` nehledá poškození. Vkládací rutina se neptá, zda `HL` leží na hranici záznamu. Renderer netestuje chybějícího třináctého předchůdce. Návrh spoléhá na to, že každý zapisující zachová společný formát.

## Co editor ještě nevysvětluje

Editor umí uložit:

```asm
LOOP    DJNZ LOOP
```

stále jsme však úplně neodpověděli:

- jak `LOOP` získá číselnou hodnotu;
- jak zůstává dopředný odkaz v prvním průchodu nevyřešený;
- jak se `DJNZ` najde v tabulce instrukcí;
- jak se vypočítá relativní displacement;
- jak se chyby připojí k záznamům zdroje;
- kam se zapisují výsledné bajty strojového kódu.

Tyto otázky patří do části III.

Přechod je přirozený. Editor už převedl lidský zdroj do kompaktní sémantické podoby. Assembler může nad touto podobou pracovat, aniž by znovu parsoval text obrazovky.

## Poslední cesta: od klávesy k trvalému záznamu a zpět

Zhušťme vše do jediného cyklu.

Uživatel napíše:

```asm
LOOP    DJNZ LOOP
```

### Cesta dolů

```text
fyzické klávesy
→ kód klávesy ROM
→ normalizované tisknutelné znaky
→ inputBuffer se značkou kurzoru
→ parser polí
→ descriptory mnemonic a operandů
→ pořadové číslo symbolu pro LOOP
→ připravený komprimovaný záznam
→ kontrola kapacity vůči U-TOP
→ zabalený suffix se posune vzhůru
→ záznam se zkopíruje do zdroje
→ aktivní ukazatel se aktualizuje
```

### Cesta vzhůru

Později potřebuje editor stejný řádek zobrazit:

```text
aktivní komprimovaný záznam
→ dekódování hlavičky a payloadu
→ pořadové číslo symbolu se převede na LOOP
→ descriptor mnemonic se převede na DJNZ
→ výraz operandu se rozbalí
→ kanonický lineBuffer
→ v případě potřeby se přidá značka výběru
→ glyph renderer zapíše bitmapu Spectra
```

Text, který uživatel vidí, se rekonstruuje z významu komprimovaného při zadání.

To je ústřední výkon editoru PROMETHEA. Není pouhým textovým polem připojeným k assembleru. Je kompaktní databází strukturovaného zdroje, rendererem, parserem a správcem pohyblivé paměti navrženými jako jediný systém.

## Co se změnilo během celého sezení?

Na konci příkladu:

- mezi trvalou výplní existuje pět smysluplných komprimovaných záznamů zdroje;
- `START` a `LOOP` mají pořadová čísla symbolů a položky tabulky;
- aktivní ukazatel prošel několika záznamy;
- ukazatele vybraného bloku byly nastaveny, sledovaly přesunuté bajty a po smazání se zúžily;
- oblast zdroje několikrát vzrostla a zmenšila se;
- tabulka symbolů se s ní fyzicky pohybovala;
- `lineBuffer` se opakovaně znovu sestavoval;
- `inputBuffer` sloužil ruční editaci i REPLACE;
- vytištěný zdroj se znovu vygeneroval stejnou expanzní cestou;
- konečná obrazovka je pouze nejnovější projekcí trvalých záznamů.

## Důležité myšlenky přenesené do části III

- zadávání zdroje provádí sémantickou kompresi před trvalým commitem;
- assembler dostává už klasifikované záznamy, nikoli syrový text obrazovky;
- jména symbolů jsou v záznamech reprezentována pořadovými čísly;
- záznamy zdroje lze procházet nezávisle na délce jejich textu;
- pseudo-operace a strojové instrukce sdílejí jediný proud záznamů;
- paměť zdroje a tabulka symbolů tvoří jednu pohyblivou zabalenou oblast;
- callbacky a samomodifikované operandy poskytují kompaktní znovupoužitelná workflow;
- chyby je vhodné odhalit před strukturální změnou, kdykoli je to možné;
- platnost editoru vyjadřují společné invarianty, nikoli obranné kontroly v každé rutině;
- dalším krokem je převést sémantické záznamy zdroje na adresy a bajty.

## Znovu navštívené zdrojové kotvy

- `startPrometheus`
- `prometheusWarmStart`
- `processKey`
- `updateInputBuffer`
- `submitInputLineOrDispatchCommand`
- `commandHandlerTable`
- `encodeInputLineToSourceRecord`
- `encodedRecordStorageLength`
- `parseAndInsertSourceLine`
- `varcInsertMode`
- `insertByteRangeAtHLFromDE`
- `deleteSourceLinesAtHL`
- `deleteSourceLinesAndRestoreTailPadding`
- `varcSourceBufferActiveLine`
- `getNextSourceRecord`
- `getPreviousSourceRecord`
- `expandSourceRecordToLineBuffer`
- `lineBuffer`
- `inputBufferStart`
- `varcSelectedBlockStart`
- `varcSelectedBlockEnd`
- `invokeFind`
- `invokeReplace`
- `invokeCopy`
- `invokeDelete`
- `invokePrint`
- `varcSymbolTablePt`
- `varcCodeEndPt`
