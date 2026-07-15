# Kapitola 6: Malé datové jazyky PROMETHEA

Tabulka bajtů se nestane automaticky srozumitelnou jen proto, že vidíme její čísla.

Představme si, že v paměti najdeme tuto posloupnost:

```text
E0 50 C5 03 01 00 00
```

Je to řetězec? Strojová instrukce? Sedm nezávislých nastavení? Souřadnice na obrazovce následovaná příznaky? Bez rutiny, která data čte, bajty svůj příběh samy nevyprávějí.

PROMETHEUS obsahuje mnoho podobných kompaktních formátů. Každý je malým jazykem s vlastní gramatikou:

- jeden bit může označit poslední znak slova;
- jeden bajt může být posunem měřeným od adresy tohoto bajtu;
- uložený počet může být záměrně větší než počet viditelný;
- několik příznaků voleb může sdílet jeden bajt deskriptoru;
- hodnoty připomínající opcode Z80 mohou být ve skutečnosti položkami tabulky;
- token příkazu může být obyčejné písmeno se zapnutým bitem 7.

Program šetří paměť tím, že informace neukládá v nejzřejmější podobě. Abychom mu porozuměli, musíme se naučit rozpoznávat právě používaný malý jazyk.

## Terminátor nepotřebuje vlastní bajt

Běžným způsobem uložení řetězce je přidat za něj zvláštní bajt:

```text
P R O M E T H E U S 00
```

Nula není součástí viditelného slova. Existuje pouze proto, aby řekla „konec“.

PROMETHEUS se tomuto bajtu často vyhne tím, že si vypůjčí bit 7 posledního znaku:

```text
P R O M E T H E U S-s-nastaveným-bitem-7
```

Znaky ASCII se běžně vejdou do sedmi bitů, takže horní bit je k dispozici jako marker. Čtecí rutina provede s každým bajtem dvě operace:

```text
zobraz byte AND $7F
if byte má nastavený bit 7:
    stop
```

Přesně tak pracuje tisk řetězců installeru:

```asm
ld a,(hl)
and 07fh
; draw the character
...
ld a,(hl)
inc hl
rlca
jr nc,.installerPrintNextCharacter
```

`AND $7F` před vyhledáním glyfu odstraní marker. Později `RLCA` přesune původní bit 7 do carry. Vynulované carry znamená, že následuje další znak; nastavené carry znamená, že slovo skončilo.

Stejný nápad se používá na několika místech, mimo jiné u jmen symbolů a slov rozbalovaných z tokenů.

### Proč je to výhodný obchod

Jednobajtový terminátor vypadá bezvýznamně, ale program může obsahovat stovky krátkých slov. Má-li průměrné slovo jen čtyři nebo pět písmen, jeden bajt navíc na každé slovo je drahý.

Schéma s horním bitem dává PROMETHEU:

- žádný samostatný terminátor;
- žádný bajt délky;
- jednoduchou sekvenční čtecí rutinu;
- po odmaskování stále dostupný původní sedmibitový znak.

Cena spočívá v tom, že uložený text není obyčejné ASCII. Obecná řetězcová rutina by poslední znak zobrazila chybně, pokud by tuto konvenci neznala.

## Inline řetězce mění návratové adresy na ukazatele

Textová rutina installeru kombinuje marker horního bitu se zásobníkovou technikou z kapitoly 4.

Za voláním bezprostředně následují bajty řetězce:

```asm
ld hl,someBitmapAddress
call installerPrintInlineString
; packed characters are placed here
; execution continues after the marked final character
```

Rutina sejme ze zásobníku návratovou adresu volání a použije ji jako adresu prvního znaku. V proudu instrukcí není potřeba samostatné slovo s ukazatelem.

Formát lze popsat takto:

```text
CALL printer
znak
znak
poslední znak s nastaveným bitem 7
následující spustitelná instrukce
```

Dekodér tiskové rutiny je zároveň mechanismem toku řízení. Nalezení posledního označeného znaku mu řekne, kde musí vykonávání pokračovat.

Jde o miniaturní vložený jazyk uvnitř proudu instrukcí:

```text
CALL znamená „následující bajty jsou text, dokud bit 7 neřekne stop“
```

Disassembler, který tento jazyk nezná, může textové bajty mylně dekódovat jako instrukce.

## Symboly používají tentýž marker k jinému účelu

Když PROMETHEUS čte identifikátor, převede písmena na velká a uloží jméno s bitem 7 na posledním znaku.

Pojmově:

```text
LOOP   →  L O O P|$80
START  →  S T A R T|$80
```

Zdrojová rutina nemusí u každého trvalého jména vyhradit bajt délky. Porovnávání pokračuje znak po znaku, dokud se pravopis neliší nebo se nedosáhne označeného posledního znaku.

Je to užitečné poučení: stejné nízkoúrovňové kódování může sloužit různým vyšším systémům.

- V installeru označený znak ukončuje inline zobrazovaný text.
- V editoru ukončuje slovo tokenu.
- V tabulce symbolů ukončuje pravopis identifikátoru.

Význam bitu je lokálně jednotný — „toto je poslední znak“ — zatímco okolní struktury se liší.

## Token může nahradit celé slovo

Buffer editovaného řádku může obsahovat obyčejné znaky, ale také bajty od `$80` výše. Takový bajt představuje celé slovo nebo token příkazu.

Společný renderer rozhoduje, o který případ jde:

```asm
displayInputTokenOrCharacter:
    cp 080h
    jr c,displayUninvertedCharacter
    ...
```

Bajt pod `$80` se zobrazí přímo. Bajt od `$80` výše indexuje tabulku posunů tokenů.

V pseudokódu:

```text
if byte < $80:
    zobraz byte
else:
    word = najdiPackedWordProToken(byte)
    zobraz word až po poslední znak s horním bitem
    zobraz jednu následující mezeru
```

Vstupní řádek tak může uchovávat příkaz nebo assemblerové slovo v jediném bajtu místo opakování všech jeho písmen.

Kompaktní podoba není užitečná jen kvůli úspoře místa. Parseru také říká, že slovo už bylo rozpoznáno jako známý token.

## Tabulka posunů ukazuje sama od sebe

Renderer tokenů neukládá pro každé slovo plný šestnáctibitový ukazatel. Používá jednobajtový relativní posun:

```asm
varcTokenExpansionTableBase:
    ld hl,08d6fh
    ld d,000h
    ld e,a
    add hl,de
    ld e,(hl)
    add hl,de
```

Po výběru položky tabulky načte jeden bajt a přičte jej k vlastní adrese položky. Výsledkem je sbalené slovo.

Pojmově:

```text
entryAddress = tableBase + tokenIndex
wordAddress  = entryAddress + memory[entryAddress]
```

Jde o **samorelativní ukazatel**. Jeho hodnota má smysl pouze vzhledem k místu, kde je bajt uložen.

Proč používat jeden bajt místo dvoubajtové adresy?

- každá položka tabulky má poloviční velikost;
- pokud se tabulka a slova přesunou společně, není potřeba relokace;
- blízké řetězce jsou dosažitelné levně;
- dekodér zabírá jen několik instrukcí.

Omezením je vzdálenost. Cíl musí být dostatečně blízko, aby se vešel do zvoleného jednobajtového výkladu. Rozložení zdroje je proto součástí formátu.

## Některé bajty posunů jsou náhodou platnými instrukcemi Z80

Disassembler používá další samorelativní tabulku:

```asm
disassemblyOperandHandlerOffsets:
    ld e,c
    ld d,e
    daa
    add hl,de
    nop
    dec b
    ld c,h
    daa
```

Vypadá to jako osm zvláštních instrukcí. Ve skutečnosti jde o osm datových bajtů.

Komentáře odhalují jejich skutečný účel: bajt opcode každé zapsané instrukce je číselně roven vzdálenosti od `formatIndexedDisplacementOperand` k jednomu z osmi handlerů operandů.

Dispatch logika přečte vybraný bajt jako data:

```asm
ld hl,disassemblyOperandHandlerOffsets
add hl,bc
ld c,(hl)
ld hl,formatIndexedDisplacementOperand
add hl,bc
jp (hl)
```

V pseudokódu:

```text
offset = operandHandlerOffsets[operandClass]
handler = firstOperandHandler + offset
jump handler
```

Proč tabulku zapisovat mnemonikami instrukcí místo hodnot `DEFB`?

Historický binární obraz se stará pouze o bajty. V rekonstruovaném zdroji může mnemonika opcode zachovat přesný bajt a současně názorně ukázat, proč zde naivní disassembler kdysi viděl spustitelně vypadající instrukce. Okolní komentář je nezbytný: bez něj by se čtenář snažil vymyslet nesmyslnou cestu vykonávání přes `LD E,C`, `DAA` a `NOP`.

Jde o opakující se varování:

> Bajty nejsou kódem jen proto, že je lze dekódovat jako platné instrukce.

Na osmibitovém procesoru lze většinu hodnot bajtu dekódovat jako něco.

## Samorelativní struktury se přesouvají jako celek

Představme si, že položka tabulky na adrese `$8000` obsahuje `$20`. Jejím cílem je:

```text
$8000 + $20 = $8020
```

Přesune-li se celá tabulka i cíl o `$1000`, položka leží na `$9000` a cíl na `$9020`. Uložený bajt `$20` zůstává správný.

Proto jsou samorelativní data přirozeně relokovatelná.

Absolutní ukazatel:

```text
ulož $8020
při přesunu musí být opraven
```

Samorelativní posun:

```text
ulož $20
zůstane správný, když se obě části přesunou společně
```

PROMETHEUS této vlastnosti využívá ke snížení spotřeby paměti i množství relokační práce.

## Počet může obsahovat neviditelný bias

Tabulky ochrany a oblastí disassembly v monitoru začínají bajtem počtu, ale toto číslo není prostě počtem rozsahů zadaných uživatelem.

Například:

```asm
defbDisassemblyAreaTable:
    defb 002h
    defw $5DC0,$9C38
```

Počáteční viditelný počet vlastních rozsahů je nula, přesto je uložená hodnota dvě.

Jazyk tabulky říká:

```text
uložený počet = 2 + počet uživatelských rozsahů
```

Jde o **posunutý počet** neboli biased count.

Proč začínat dvěma?

Consumer používá hodnotu v kompaktní smyčce, která současně započítává skrytý dynamický rezidentní rozsah a vlastní ukončovací konvenci. Zahájení v posunuté reprezentaci odstraňuje potřebu zvláštního kódu při každém průchodu tabulkou.

Uživatel uvažuje ve viditelných rozsazích:

```text
0, 1, 2, 3, 4 nebo 5 vlastních rozsahů
```

Tabulka ukládá:

```text
2, 3, 4, 5, 6 nebo 7
```

Program vymění malou mentální komplikaci za jednodušší strojový kód.

## Skryté a viditelné položky mohou sdílet jednu tabulku

První slova rozsahu v ochranných tabulkách jsou placeholdery. Při kontrole paměti je PROMETHEUS dočasně nahradí současným dynamickým rezidentním intervalem:

```text
First = začátek relokovaného PROMETHEA
Last  = současný konec rezidentního kódu, zdroje a symbolů
```

Za tímto skrytým intervalem následují uživatelsky editovatelné rozsahy.

Celý pojmový formát je:

```text
byte 0      posunutý počet
bytes 1-2   placeholder skrytého First
bytes 3-4   placeholder skrytého Last
next 4      uživatelský rozsah 1
next 4      uživatelský rozsah 2
...
```

Jeden dekodér tak může kontrolovat povinnou ochranu programu i volitelnou uživatelskou ochranu.

Tabulka není jen seznamem, který uživatel vidí. Je jazykem sdíleným interfacem a bezpečnostním mechanismem.

## Deskriptor je věta stlačená do pevných polí

Přední panel monitoru obsahuje 34 sedmibajtových deskriptorů. Každý říká obecnému rendereru, co má umístit na obrazovku.

Zjednodušené rozložení:

```text
+0,+1  bitmapová adresa
+2     nadpis nebo zvláštní selector
+3     příznaky formátu a zdroje
+4     příznaky velikosti a schopností
+5,+6  adresa zobrazované hodnoty
```

Uvažujme deskriptor okna seznamu:

```asm
frontPanelListWindowItem:
    defb 000h
    defb 040h
    defb 0a0h
    defb 003h
frontPanelListWindowSizeFlags:
    defb 08bh
    defw 0
```

Těchto sedm bajtů říká přibližně:

```text
umísti tuto zvláštní oblast na bitmapovou adresu $4000
použij selector $A0
vykresli ji jako zvláštní oblast panelu
povol proměnlivou velikost
zobraz jedenáct řádků
není potřeba obyčejný ukazatel na hodnotu
```

Bajt `$8B` kombinuje dvě myšlenky:

```text
bit 7       proměnlivá velikost je povolena
dolních 5 bitů = 11 viditelných řádků
```

Renderer dokáže zpracovat mnoho různých položek panelu, protože každý deskriptor je malou instrukcí pro renderer.

Jde o datově řízené programování. Místo samostatného vykreslovacího kódu pro `BC`, `DE`, `HL`, `IX`, `IY`, paměťová okna a počty cyklů ukládá PROMETHEUS jejich rozdíly do záznamů a znovu používá společný kód.

## Bitová pole dovolují jednomu bajtu odpovědět na několik otázek

Bajt deskriptoru `+3` obsahuje několik nezávislých voleb:

```text
bit 7  desetinné zobrazení
bit 6  šestnáctkové zobrazení
bit 5  binární zobrazení
bit 4  znakové zobrazení
bit 3  jednobajtová nebo dvoubajtová hodnota
bit 2  vodorovné nebo svislé rozložení
bits 1..0 třída zdroje/vykreslování
```

Je to malá sada přepínačů sbalená do jednoho bajtu.

Šestnáctkový režim lze testovat:

```asm
bit 6,(ix+3)
```

Pouze třídu zdroje lze ponechat:

```asm
ld a,(ix+3)
and 003h
```

Jednu volbu lze přepnout:

```text
descriptorByte = descriptorByte XOR optionBit
```

Tentýž bajt má smysl pouze proto, že reader a writer souhlasí s přiřazením bitů. Tato dohoda je gramatikou jazyka deskriptorů.

## Pevná velikost deskriptorů zlevňuje navigaci

Každá položka předního panelu zabírá přesně sedm bajtů. Editor panelu ukládá posun do tabulky, takže přechod k další položce znamená přičíst sedm.

```text
posun současného deskriptoru + 7 = další deskriptor
posun současného deskriptoru - 7 = předchozí deskriptor
```

Není potřeba tabulka ukazatelů. Není nutné přeskakovat záznamy proměnlivé délky. Pevná velikost záznamu se stává součástí navigačního algoritmu.

Jde o běžný obchod PROMETHEA:

- v některých záznamech může zůstat trochu nevyužitého místa;
- na oplátku jsou indexování a průchod mimořádně malé.

## Bajty příkazů kombinují znak a kategorii

PROMETHEUS někdy změní písmeno na token příkazu nastavením bitu 7:

```asm
set 7,a
```

Obyčejné malé písmeno může být:

```text
'a' = $61
```

Jeho podoba jako token příkazu se stane:

```text
$E1
```

Dolních sedm bitů stále určuje znak, zatímco bit 7 říká „vykládej to jako token, nikoli jako doslovný text“.

Editovaný řádek tak může obsahovat zároveň to, co uživatel napsal, i to, co už program rozpoznal.

To také vysvětluje, proč několik rutin chrání bajty s nastaveným bitem 7. Přesun kurzoru doprostřed jednobajtového tokenu a zacházení s ním jako s viditelným znakem by poškodilo gramatiku řádku.

## Marker může být součástí editovaných dat

Buffer editovaného řádku obsahuje další vyhrazený bajt:

```text
$01 = marker kurzoru
$00 = konec řádku
```

Kurzor není uložen jen v samostatné proměnné. Fyzicky cestuje bufferem tím, že si vyměňuje místo se sousedními bajty.

Zjednodušený řádek může vypadat takto:

```text
L D [cursor=$01] mezera A čárka B 00
```

Renderer vykládá `$01` jako glyph kurzoru. Pohyb doleva a doprava tento marker prohazuje se sousedními znaky. Vložení posouvá marker i koncový terminátor pomocí řetězce výměn přímo na místě.

Buffer je tedy malým jazykem obsahujícím:

- obyčejné bajty znaků;
- kompaktní bajty tokenů `$80+`;
- jeden marker kurzoru `$01`;
- jeden nulový terminátor.

Surové bajty nejsou totožné s viditelným řádkem.

## Dvojice hodnota–maska popisují vyhledávací vzor

Pětibajtové hledání monitoru ukládá deset bajtů jako pět dvojic:

```text
(value, mask)
(value, mask)
(value, mask)
(value, mask)
(value, mask)
```

Běžný požadovaný bajt používá:

```text
mask = $FF
```

Wildcard používá:

```text
mask = $00
```

Porovnání je:

```text
(memoryByte XOR value) AND mask
```

Je-li výsledek nula, pozice odpovídá.

Proč nulová maska vytváří wildcard?

```text
cokoli AND $00 = 0
```

Bajt hodnoty se stává bezvýznamným.

Tento dvoubajtový minijazyk dokáže jednou porovnávací smyčkou popsat přesné bajty i pozice „nezáleží na hodnotě“.

## Mnoho malých jazyků jsou ve skutečnosti malé interpretery

Formát je užitečný pouze proto, že jej nějaká rutina interpretuje.

Mezi dosud viděné příklady patří:

| Datový jazyk | Interpreter |
|---|---|
| řetězec s horním bitem | smyčka vykreslování sbalených znaků |
| tabulka posunů tokenů | `displayInputTokenOrCharacter` |
| posuny handlerů operandů | dispatch logika disassembleru |
| posunutá tabulka rozsahů | checker ochrany a rozsahů |
| sedmibajtový deskriptor panelu | obecný renderer předního panelu |
| editační buffer s kurzorem a tokeny | společný renderer a mutátor vstupního řádku |
| dvojice hodnota/maska | vyhledávač paměti monitoru |

Tabulka a rutina tvoří dvojici. Čtení pouze jedné části většinou vede ke zmatku.

Při setkání s neznámými bajty je dobré položit otázku:

> Který kód touto strukturou prochází a co dělá po každém poli?

Právě tento kód je učebnicí gramatiky.

## Proč PROMETHEUS vymýšlí několik formátů místo jediného univerzálního

Univerzální systém záznamů by se dokumentoval snáze, ale pravděpodobně by byl větší.

PROMETHEUS volí formát podle konkrétní práce:

- sekvenční text používá bit posledního znaku;
- blízké cíle používají jednobajtové relativní posuny;
- opakované zobrazovací objekty používají pevné sedmibajtové deskriptory;
- paměťové rozsahy používají posunutý počet a čtyřbajtové položky;
- editovaný text potřebuje in-band markery kurzoru a tokenů;
- vyhledávací vzory používají dvojice hodnota/maska.

Každý jazyk je malý, protože podporuje pouze operace požadované svým consumerem.

Jde o stejnou hospodárnost, jakou jsme viděli u samomodifikujícího stavu. PROMETHEUS jen zřídka platí za obecnost, kterou nepotřebuje.

## Jak se nenechat zmást tabulkami

Když některá oblast zdroje vypadá podivně, použijte tento postup.

### 1. Najděte label na začátku

Popisný label často určuje consumera nebo účel.

### 2. Najděte všechny odkazy na label

Tabulce používané jedinou rutinou nejlépe porozumíme právě z této rutiny.

### 3. Určete jednotku pohybu

Zvyšuje reader adresu o jeden, dva, čtyři nebo sedm bajtů?

### 4. Hledejte masky a posuny

Operace jako `AND`, `BIT`, `RLCA` a `ADD` často odhalují sbalená pole.

### 5. Ptejte se, zda jsou hodnoty absolutní nebo relativní

Bajt přičítaný ke své vlastní adrese není obyčejným číslem.

### 6. Hledejte posunuté hodnoty a sentinely

Uložená nula, jednička nebo dvojka může znamenat „prázdné“, nikoli doslovný počet.

### 7. Nedůvěřujte náhodné disassembly

Platné opcode mohou být čistými daty.

## Zpět k celému stroji

Dřívější přehled popsal PROMETHEUS jako editor, assembler a monitor. Nyní vidíme, že je zároveň sbírkou malých interpreterů.

Editor interpretuje smíšený proud znaků, tokenů, markeru kurzoru a terminátoru.

Mechanismus symbolů interpretuje jména ukončená horním bitem a ordinal vectors.

Monitor interpretuje sedmibajtové zobrazovací deskriptory a posunuté ochranné rozsahy.

Disassembler interpretuje tabulky opcode a samorelativní posuny formátovačů.

Installer interpretuje inline řetězce, konfigurační delty a relokační proudy.

Program zůstává kompaktní, protože značnou část chování přesouvá z opakovaného kódu do hustých dat, kterým rozumějí sdílené rutiny.

Tím končí první vrstva naší výbavy pro přežití se Z80. Umíme sledovat role registrů, víme, jak mohou instrukce sloužit jako proměnné, a rozumíme tomu, jak kompaktní tabulky fungují jako malé jazyky. Následující dvě kapitoly tyto myšlenky použijí při vysvětlení bezpečného pohybu pamětí a přímé komunikace s hardwarem Spectra.

## Co se změnilo v paměti?

Formáty popsané v této kapitole zabírají několik druhů paměti:

- sbalené řetězce končí označením horního bitu posledního znaku;
- tabulky tokenů ukládají jednobajtové posuny k blízkým sbaleným slovům;
- dispatch operandů ukládá osm samorelativních posunů handlerů;
- ochranné tabulky obsahují posunutý počet, jeden skrytý dynamický rozsah a uživatelské rozsahy;
- položky předního panelu zabírají pevné sedmibajtové záznamy;
- editační buffer obsahuje znaky, tokeny, kurzor a terminátor;
- vzory pro hledání v paměti zabírají pět dvojic hodnota/maska.

Většina těchto struktur se mění pouze rutinami, které rozumějí jejich gramatice. Úprava jednotlivých bajtů bez tohoto kontextu může tabulku vnitřně porušit.

## Uvedené orientační labely zdroje

- `installerPrintInlineString`
- `parseSymbolNameAndFindOrdinal`
- `displayInputTokenOrCharacter`
- `varcTokenExpansionTableBase`
- `disassemblyOperandHandlerOffsets`
- `dispatchDisassemblyOperandHandler`
- `defbDisassemblyAreaTable`
- `defwDisassemblyAreaTable`
- `checkRangeAgainstProtectionTable`
- `checkAddressAgainstProtectionTable`
- `frontPanelItemDescriptors`
- `frontPanelListWindowItem`
- `frontPanelListWindowSizeFlags`
- `inputBufferStart`
- `varcInputBufferPosition`
- `monitorFindByteMaskPairs`
