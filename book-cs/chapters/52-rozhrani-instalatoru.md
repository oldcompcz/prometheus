# Kapitola 52: Rozhraní instalátoru

Bootstrap z předchozí kapitoly byl téměř neviditelný. Vymazal paměť, našel sám
sebe, zkopíroval malého pomocníka na `$5000` a skočil tam. Teď se program náhle
stane viditelným. Objeví se logo, vytiskne se zjištěná adresa a předtím, než se
PROMETHEUS usadí ve svém trvalém domově, lze změnit malou skupinu voleb.

To je rozhraní instalátoru.

Instalátor svádí k tomu, abychom jej považovali za bezvýznamnou předsíň. Jakmile
instalace skončí, opravdu zmizí. Jeho zdroj však představuje koncentrovanou lekci
designových návyků používaných v celém PROMETHEU:

- registry zůstávají v užitečných stavech pro následující operaci;
- současná nastavení jsou uložena uvnitř operandů instrukcí;
- syntetická návratová adresa nahrazuje větší dispatch smyčku;
- řetězce leží bezprostředně za svými instrukcemi `CALL`;
- úplné instrukce Z80 se kopírují jako konfigurační šablony;
- bitmapa Spectra se adresuje podle svého neobvyklého fyzického rozložení;
- jediná obecná rutina pro maskované pole edituje několik nesouvisejících
  kompaktně uložených nastavení.

Instalátor je malý, protože téměř každý bajt vykonává více než jednu práci.

## Co dorazí na `$5000`

Na konci bootstrapu dorazí vykonávání na:

```asm
installerEntryAt5000:
```

Důležitý stav už je připraven:

```text
HL = první z 320 zbývajících bajtů loga ve fyzickém obrazu CODE
SP = soukromý stack poblíž $4020
horní slovo stacku = fyzický začátek úplného rezidentního payloadu s originem nula
následující slovo stacku = fyzický základ načtení instalačního bloku CODE
```

Rozdíl mezi posledními dvěma adresami je důležitý.

**Fyzický základ načtení** je místo, kde začal samotný bootstrap. **Začátek
payloadu** leží dále v témže bloku CODE, za bootstrapem, instalátorem, relokačními
metadaty a materiálem loga. Instalátor musí první adresu zobrazit jako užitečnou
výchozí hodnotu, později však musí kopírovat z druhé.

PROMETHEUS si uchovává obě bez vytvoření formální struktury.

## Vykreslení dvouřádkového loga

První kód v pevném instalátoru je:

```asm
installerEntryAt5000:
    ld de,VRAM_ADDRESS+0x26
    call installerDrawLogoRow
    ld e,046h
    call installerDrawLogoRow
```

Každý řádek loga má šířku dvaceti znakových sloupců a výšku osmi pixelových
řádků. Zdroj je lineární: osm bajtů pro první sloupec, osm pro následující a tak
dále. Obrazovka Spectra však tímto způsobem lineární není. Uvnitř jedné znakové
buňky leží další pixelový řádek o `$0100` bajtů dále.

Kreslicí rutina proto zachází s D a E jako se dvěma odlišnými rozměry:

```asm
installerDrawLogoRow:
    ld c,014h
.installerDrawNextLogoColumn:
    ld b,008h
    push de
.installerCopyLogoColumnRows:
    ld a,(hl)
    ld (de),a
    inc hl
    inc d
    djnz .installerCopyLogoColumnRows
    pop de
    inc e
    dec c
    jr nz,.installerDrawNextLogoColumn
    ret
```

Pro jeden sloupec:

```text
zvýšit D -> přejít dolů o jeden pixelový řádek
obnovit DE -> vrátit se na vrchol sloupce
zvýšit E -> přejít o jeden bajt doprava
```

Je to úspornější než pro každý bajt znovu počítat adresu bitmapy Spectra. Po dvou
voláních se HL posunulo přesně o 320 bajtů a nyní ukazuje na rezidentní payload ve
fyzickém obrazu CODE.

Instalátor použil logo současně jako dekoraci i jako aritmetiku ukazatele.

## Výměna dvou důležitých adres

Další instrukce je:

```asm
    ex (sp),hl
```

Bezprostředně před ní:

```text
HL       = fyzický začátek payloadu
(SP)     = fyzický základ načtení
```

Bezprostředně po ní:

```text
HL       = fyzický základ načtení
(SP)     = fyzický začátek payloadu
```

Jediná výměna poskytne zobrazovacímu kódu číslo, které potřebuje, a přitom nechá
pozdější zdroj kopírování bezpečně na stacku.

Fyzický základ načtení se převede na pět desetinných číslic opakovanými voláními
`installerEmitDecimalDigit`:

```asm
    ld bc,installationAddressString
    ld de,02710h
    call installerEmitDecimalDigit
    ld de,003e8h
    call installerEmitDecimalDigit
    ld de,00064h
    call installerEmitDecimalDigit
    ld e,00ah
    call installerEmitDecimalDigit
    ld e,001h
    call installerEmitDecimalDigit
```

Děliteli jsou 10 000, 1 000, 100, 10 a 1. Pomocná rutina opakovaně odečítá
současný dělitel a počet úspěšných odečtení počítá jako ASCII číslici:

```asm
installerEmitDecimalDigit:
    ld a,02fh
.installerDecimalSubtractLoop:
    inc a
    and a
    sbc hl,de
    jr nc,.installerDecimalSubtractLoop
    add hl,de
    ld (bc),a
    inc bc
    ret
```

A začíná na `'/'`, tedy jeden znak před `'0'`, takže první inkrement vytvoří
správnou číslici. Poslední neúspěšné odečtení napraví `ADD HL,DE` a ponechá
zbytek pro následující desetinné místo.

Zjištěná fyzická adresa načtení se tak stane počáteční navrženou instalační
adresou. Uživatel ji může přijmout beze změny nebo upravit.

## Po každé přijaté klávese se instalátor překreslí

Hlavní rozhraní začíná na:

```asm
installerRedrawAndWait:
```

Vytiskne titul, řádek copyrightu, pokyn, pole adresy a volbu monitoru. Potom
znovu sestaví rozložení atributů, vydá nastavené kliknutí, čeká na klávesu a
provede její dispatch.

Neobsahuje velkou konvenční smyčku tohoto druhu:

```text
while ne ENTER:
    vykresli obrazovku
    key = přečti klávesu
    proveď akci
```

Dispatcher místo toho uloží adresu překreslení na stack, jako by šlo o návratovou
adresu:

```asm
.installerDispatchKey:
    ld hl,installerRedrawAndWait
    push hl
    ...
```

Většina handlerů končí obyčejným `RET`. Tento RET se nevrací na řádek za nějakým
CALL. Vyzvedne syntetickou adresu a skočí zpět na úplnou cestu překreslení.

V pseudokódu:

```text
push adresa_překreslení
obsluž_key
RET                    ; znamená znovu překreslit a čekat
```

Výjimkou je ENTER. Záměrně odstraní tuto syntetickou návratovou adresu a místo
návratu do rozhraní pokračuje do instalace.

Jde o stejnou obecnou myšlenku, kterou jsme v PROMETHEU viděli i jinde: stack
neslouží pouze k vnořování podprogramů. Může také uchovávat následující stav
kompaktního stavového automatu.

## Inline řetězce spotřebují vlastní návratovou adresu

Text instalátoru se ve zdroji objevuje takto:

```asm
    ld hl,04082h
    call installerPrintInlineString
    defb "Spectrum Z80 Turbo Assemble",0xf2
```

Poslední znak má nastavený bit 7. Zdánlivá návratová adresa CALL proto zpočátku
není kódem; ukazuje na řetězec.

`installerPrintInlineString` provede tuto transformaci:

```text
pop návratovou adresu CALL -> ukazatel na zdrojový řetězec
vykresluj bajty, dokud některý nemá nastavený bit 7
skoč na bajt za řetězcem
```

Podprogram nakonec použije:

```asm
    jp (hl)
```

místo RET, protože HL už postoupilo za označený poslední znak.

Tento formát ušetří pro každý řetězec samostatné slovo ukazatele a ponechá text
vedle kódu, který jej používá. Hodí se zvlášť dobře pro malý dočasný program,
jehož řetězce se nikdy samostatně nevyhledávají.

## Soukromý renderer znaků

Instalátor nevolá rezidentní textový renderer PROMETHEA; ten ještě nebyl
nainstalován. Obsahuje proto vlastní malý renderer.

Pro každý znak:

1. odstraní high-bitový značkovač konce;
2. volitelně změní velikost písmen;
3. vypočítá odpovídající adresu fontu v ROM Spectra;
4. zkopíruje osm řádků glyfu do bitmapy;
5. volitelně každý řádek zesílí;
6. postoupí na následující znakovou buňku.

Výpočet adresy glyfu v ROM je kompaktní:

```asm
.installerLocateRomGlyph:
    add a,a
    ld h,00fh
    ld l,a
    add hl,hl
    add hl,hl
```

Výsledkem je adresa generátoru znaků ROM pro zvolený tisknutelný znak. Cíl se
pamatuje v immediate operandu:

```asm
varcInstallerStringDestination:
    ld de,04000h
```

Po vykreslení jednoho znaku rutina změní operand této instrukce `LD DE`, aby
příští iterace začala o jeden sloupec vpravo.

Kód opět slouží jako stav.

## Tři politiky velikosti písmen jsou úplné instrukce

Stisk C cyklicky přepíná mezi třemi způsoby zobrazení:

```text
0 = zachovat velikost písmen zdroje
1 = vynutit malá písmena
2 = vynutit velká písmena
```

Politiky jsou představovány skutečnými dvoubajtovými instrukcemi:

```asm
installerCaseModeInstructionTable:
    and 0ffh
    or 020h
    and 0dfh
```

`AND $FF` ponechá A beze změny. `OR $20` u písmen vynutí bit malých písmen.
`AND $DF` jej vynuluje.

Zvolená dvojice bajtů se zkopíruje přes:

```asm
varcInstallerCaseTransform:
    and 0ffh
```

Vykreslovací smyčka potom vybranou operaci přímo vykoná. Pro každý znak nemusí
načítat bajt režimu a větvit třemi cestami.

Pseudokód změny nastavení je:

```text
mode = (mode + 1) modulo 3
template = caseInstructionTable[mode]
přepiš caseTransformInstruction pomocí template
```

Samotný index režimu velikosti písmen je uložen v immediate operandu další
instrukce:

```asm
varcInstallerCaseMode:
    ld a,000h
```

Neexistuje samostatný záznam nastavení instalátoru. Záznamem *jsou* spustitelné
bajty.

## Tučný text je jednobajtový přepínač kódu

Renderer načte jeden řádek glyfu ROM do A. Potom dorazí na:

```asm
varcInstallerBoldTransform:
    nop
    or (hl)
```

V normálním režimu NOP ponechá řádek beze změny a `OR (HL)` pouze provede OR
bajtu se sebou samým.

Po stisku D se opcode NOP `$00` XORuje s `$0F` a změní se na `RRCA`:

```text
RRCA řádek
OR původní řádek
```

Pixel a jeho otočení o jednu pozici se sloučí, takže tahy vypadají dva pixely
silné.

Další stisk D provede XOR s `$0F` podruhé a obnoví NOP.

Stejný jednobajtový XOR helper přepíná také volbu monitoru, pouze s jinou maskou:

```asm
.installerXorToggleByte:
    xor (hl)
    ld (hl),a
    ret
```

Pro tučné písmo obsahuje A `$0F`. Pro flag monitoru obsahuje A `$4D`.

## Volba monitoru je záměrně zakódována jako písmeno M

Nastavení monitoru je uloženo zde:

```asm
varcMonitorInstallFlag:
    ld a,04dh
```

`$4D` je ASCII M. Stisk M XORuje operand s `$4D`, takže se střídá mezi:

```text
$4D -> monitor zahrnut
$00 -> pouze assembler
```

Instalace později použije `RRCA`. Bit 0 hodnoty `$4D` přejde do carry, zatímco
nula ponechá carry vynulované. Tentýž bajt je tedy současně:

- vhodnou XOR maskou;
- čitelnou připomínkou klávesy M;
- booleovskou hodnotou;
- budoucím zdrojem carry flagu, který vybere rozložení obrazu.

Jde o drobný, ale charakteristický příklad víceúčelového kódování.

## Barevná nastavení jsou kompaktně uložené atributy Spectra

Atributový bajt Spectra obsahuje několik polí:

```text
bity 0-2  INK
bity 3-5  PAPER
bit  6    BRIGHT
bit  7    FLASH
```

Instalátor ukládá dvě editovatelné hodnoty atributu uvnitř instrukcí:

```asm
varcInstallerTextAttribute:
    ld (hl),038h

varcInstallerHighlightAttribute:
    ld (hl),030h
```

I, P a B bez shiftu mění atribut běžného textu. I, P a B se shiftem editují
atribut zvýrazněného řádku.

Všechna tato pole upravuje jediný helper:

```asm
.installerAdjustMaskedSetting:
    ld a,e
    cpl
    and (hl)
    ld c,a
    ld a,(hl)
    add a,d
    and e
    or c
    ld (hl),a
    ret
```

Jeho matematický význam je:

```text
preserved = old AND NOT mask
changed   = (old + step) AND mask
new       = preserved OR changed
```

Volající vybere pole pomocí D a E:

```text
INK:    step $01, mask $07
PAPER:  step $08, mask $38
BRIGHT: step $40, mask $40
```

Protože se změněná hodnota maskuje, cyklicky se přetáčí uvnitř vlastního pole,
aniž by ovlivnila sousední nastavení.

Stejná rutina dokonce upravuje délku kliknutí klávesnice:

```text
step +1 nebo -1
mask $3F
```

Data jsou odlišná, operace s kompaktním polem však zůstává stejná.

## Některé barvy se odvozují, místo aby se volily přímo

PROMETHEUS někdy potřebuje neviditelný text při zachování barvy jeho pozadí.
Helper:

```asm
attributeCopyPaperColourToInk:
```

zkopíruje tři bity PAPER dolů do pole INK. Koncepčně:

```text
result = zachovej horní bity atributu
         OR paperColour umístěná do bitů INK
```

INK a PAPER se pak shodují, takže pixely glyfu zmizí na pozadí buňky.

Instalátor tuto odvozenou hodnotu používá pro malé skryté nebo okrajům podobné
buňky a po stisku ENTER také pro několik rezidentních konfiguračních cílů.

Odvodí z ní i barvu okraje ULA tím, že po převodu PAPER na INK ponechá pouze tři
spodní barevné bity.

## Zvuk klávesy je skutečný tón ULA

Současná délka kliknutí je uložena zde:

```asm
varcKeyboardEchoDelay:
    ld e,00ah
```

Instalátor odvodí výstupní bity související s okrajem ze zvolené barvy PAPER a
opakovaně přepíná bit 4 při zápisu na port `$FE`:

```asm
.installerEchoTonePulseLoop:
    out (0feh),a
    djnz .installerEchoTonePulseLoop
```

Bit 4 ovládá reproduktor Spectra. X zvětšuje šestibitovou délku a CAPS SHIFT+X
ji zmenšuje. Upravené kliknutí se ozve před načtením další klávesy, takže lze
nastavení okamžitě vyzkoušet.

Jde o dobrou konstrukci rozhraní v přísných omezeních: uživatel nepotřebuje
samostatný příkaz „test zvuku“.

## Čtení a normalizace klávesy

Instalátor používá klávesnicové služby ROM Spectra:

```asm
.installerWaitForKey:
    call ROM_KeyboardScanning
    jr nz,.installerWaitForKey
    call ROM_KeyboardTest
    jr nc,.installerWaitForKey
```

ROM také hlásí stav shiftu. PROMETHEUS reprezentuje klávesu instalátoru se
shiftem přičtením `$80` k přeloženému kódu znaku. Hodnoty jako následující lze
proto přímo porovnávat:

```text
CAPS SHIFT+I -> $C9
CAPS SHIFT+P -> $D0
CAPS SHIFT+B -> $C2
CAPS SHIFT+X -> $D8
DELETE       -> $B0
```

Jde o soukromou konvenci instalátoru. Není to tentýž úplný systém klávesových
tokenů, který později používá editor.

## Editace pětimístné adresy

Pole adresy je vloženo do inline řetězce:

```asm
installationAddressString:
    defb "00000_",0xa0
```

Podtržítko představuje kurzor. Jeho současná poloha se pamatuje v operandu:

```asm
varcInstallationAddressCursor:
    ld hl,installationAddressString+5-installerEntryAt5000+LOADER_ADDRESS
```

Číslice přepíše podtržítko a posune je doprava. DELETE je posune doleva, starý
kurzor změní na mezeru a podtržítko zapíše na nové místo. Immediate operand se
opraví tak, aby si výsledek pamatoval.

Bajt za pětimístným polem má nastavený bit 7, protože ukončuje inline řetězec.
Test tohoto bitu zabrání zadání šesté číslice.

Levou hranici program rozpozná podle dvojtečky před polem. Kód odmítne posunout
DELETE přes ni.

Editor později používá mnohem bohatší kurzorový mechanismus. Zde stačí ukazatel,
podtržítko a dva sentinely.

## Kontrola cíle téměř neexistuje

Pole obsahuje nejvýše pět desetinných číslic. Po ENTER se zpracuje opakovaným
násobením deseti:

```text
value = value * 10 + nextDigit
```

Násobení se sestaví z posunů:

```asm
    add hl,hl       ; old * 2
    push hl
    add hl,hl       ; old * 4
    add hl,hl       ; old * 8
    pop bc
    add hl,bc       ; old * 10
```

Aritmetika je šestnáctibitová, a proto se přirozeně přetáčí. Malý instalátor
neprovádí rozsáhlé kontroly kolizí používané rezidentním editorem a assemblerem.
Předpokládá, že uživatel zvolí rozumný cíl.

Pro moderního čtenáře je to historicky pochopitelné, ale důležité: možnost zadat
adresu sama o sobě neznamená, že je tato adresa bezpečná.

## Rozhraní v pseudokódu

Celé viditelné rozhraní instalátoru lze nyní zapsat bez detailů registrů:

```text
vykresli dvouřádkové logo
vyměň ukazatel payloadu za fyzický základ načtení
naformátuj fyzický základ načtení jako výchozí desetinný cíl

repeat:
    vykresli všechny řetězce instalátoru
    vykresli Yes nebo No pro volbu monitoru
    znovu sestav barevné atributy
    vydej kliknutí pomocí zvolené délky a barvy
    čekej na přeloženou klávesu

    if key edituje běžnou barvu:
        uprav zvolené pole kompaktního atributu
    else if key se shiftem edituje barvu zvýraznění:
        uprav zvolené pole kompaktního atributu
    else if key je D:
        přepni opcode tučného písma
    else if key je M:
        přepni operand volby monitoru
    else if key je X nebo X se shiftem:
        změň délku kliknutí
    else if key je C:
        zkopíruj další šablonu instrukce velikosti písmen do rendereru
    else if key je DELETE nebo číslice:
        edituj řetězec desetinného cíle
    else if key je ENTER:
        opusť rozhraní a potvrď instalaci
```

Kód nedrží tyto volby v konvenční struktuře. Později je čte z upravených
instrukcí, které současně realizovaly jejich náhled.

## Co se změnilo v paměti

Během jednoho průchodu rozhraním může PROMETHEUS změnit:

- bitmapu obsahující logo a text;
- atributový soubor obsahující barvy loga, běžného textu a zvýraznění;
- inline řetězec desetinné adresy;
- operand `varcInstallationAddressCursor`;
- operand `varcInstallerTextAttribute`;
- operand `varcInstallerHighlightAttribute`;
- operand `varcKeyboardEchoDelay`;
- operand `varcMonitorInstallFlag`;
- operand `varcInstallerCaseMode`;
- úplnou instrukci na `varcInstallerCaseTransform`;
- opcode na `varcInstallerBoldTransform`;
- operand `varcInstallerStringDestination` během vykreslování textu.

Jsou to dočasné bajty instalátoru na `$5000`, nikoli ještě rezidentní payload.
Následující dvě kapitoly vysvětlí, jak se vybrané hodnoty zkopírují do tohoto
payloadu a jak se požadovaný rezidentní obraz přesune na konečnou adresu.

## Důležité labely, s nimiž jsme se setkali

- `installerEntryAt5000`
- `installerDrawLogoRow`
- `installerEmitDecimalDigit`
- `installerRedrawAndWait`
- `installerPrintInlineString`
- `varcInstallerStringDestination`
- `varcInstallerCaseTransform`
- `varcInstallerBoldTransform`
- `varcInstallerCaseMode`
- `varcMonitorInstallFlag`
- `varcInstallerTextAttribute`
- `varcInstallerHighlightAttribute`
- `varcKeyboardEchoDelay`
- `varcInstallationAddressCursor`
- `.installerAdjustMaskedSetting`
- `attributeCopyPaperColourToInk`

## Zpět k celému stroji

Instalátor je náhledem rezidentní aplikace. Už ukazuje vlastní vykreslování textu,
kompaktní řetězce, přímý přístup k obrazovce, kompaktní atributy Spectra, normalizaci
klávesnice a samomodifikovaný stav. Nastavení však zatím existují pouze v
dočasné kopii na `$5000`.

Stisk ENTER zahájí odlišnou fázi. Obrazovka přestane být rozhraním a instalátor
se změní v transformační engine: zapíše zvolená nastavení do payloadu s originem
nula, vybere jedno ze dvou rozložení payloadu, bezpečně je zkopíruje, relokuje
jeho interní adresy a předá řízení výsledku.
