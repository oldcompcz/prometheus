# Dodatek B: Služby ROM a systémové proměnné ZX Spectra

PROMETHEUS je z větší části soběstačný, ale v moderním smyslu nejde o čistý
bare-metal program. Volá vybrané rutiny v ROM 48K Spectra, čte jednu datovou
tabulku ROM, používá jednu systémovou proměnnou pro návrat do BASICu, zapisuje
přímo do obrazové paměti a komunikuje s ULA přes port `$FE`.

Tento dodatek dokumentuje smlouvu, na níž PROMETHEUS skutečně spoléhá. Nesnaží
se reprodukovat úplný disassembly ROM Spectra. Rutiny ROM často zničí více
registrů nebo systémových proměnných, než úzké místo volání zajímá; kde není
potřeba přesná široká smlouva ROM, uvádí následující položka konzervativní
smlouvu PROMETHEA.

Všechny adresy platí pro standardní ROM 48K Spectra předpokládanou historickým
programem.

## B.1 Souhrnná tabulka

| Jméno ve zdroji | Adresa | Druh | Použití v PROMETHEOVI |
|---|---:|---|---|
| `ROM_PrintACharacter` | `$0010` | restart service | vyšle ENTER do právě otevřeného proudu tiskárny/kanálu |
| `ROM_MaskableInterrupt` | `$0038` | vstup přerušení | není záměrně volána; bajty `$FF` se objevují jako data deskriptorů |
| `ROM_ImmediateRET` | `$0052` | jednobajtové ROM `RET` | získá fyzickou adresu načtení v bootstrapu |
| `ROM_Key_Tables` | `$0205` | datová tabulka ROM | převádí indexy klávesnice na obyčejné znaky |
| `ROM_KeyboardScanning` | `$028E` | scanner klávesnice | získá index klávesy a třídu modifieru |
| `ROM_KeyboardTest` | `$031E` | překlad/test klávesy | v instalátoru převede stabilní scan na použitelný kód |
| `ROM_SaveControl_4c6` | `$04C6` | řízení kazetového SAVE | zapisuje hlavičky a datové bloky |
| `ROM_SA_SET` | `$051A` | nastavení pokračování SAVE | zapíše navazující pomocný segment zdroje/symbolů |
| `ROM_LoadBytes_562` | `$0562` | kazetové LOAD/VERIFY | načtení bloku monitorem a LOAD/VERIFY zdroje editorem |
| `ROM_LD_MARKER` | `$05C8` | načtení navazujícího markeru | ověří/načte pomocný segment zapsaný SAVE |
| `ROM_NEWCommandRoutine` | `$11B7` | cesta příkazu BASICu | sloty příkazů N/O vstupují do chování ROM NEW |
| `ROM_ChannelOpen` | `$1601` | volba kanálu | otevře kanál 3 před výstupem PRINT |
| `ROM_StatementReturn` | `$1B76` | návrat ze statementu BASICu | bezpečně opustí PROMETHEA a obnoví BASIC |
| `ROM_BreakKey` | `$1F54` | test BREAK | zastaví pomalé a rychlé trasování |
| `ROM_PixelAddress_22b0` | `$22B0` | helper adresy displeje | převede pixelové/textové souřadnice na adresu bitmapy |
| `SYSVAR_ERR_SP` | `$5C3D` | systémová proměnná | před návratem obnoví error-stack pointer BASICu |
| port `$FE` | I/O port | ULA | matice klávesnice, border, speaker/MIC a vedlejší účinky stavu kazety |
| `$4000-$57FF` | RAM | bitmapa obrazovky | grafika editoru, monitoru a instalátoru a dočasný workspace instalátoru |
| `$5800-$5AFF` | RAM | attributes | barvy rozhraní a zvýraznění |

## B.2 `RST $10` — vytištění jednoho znaku

### Adresa

```text
$0010
```

### Jméno ve zdroji

```asm
ROM_PrintACharacter: equ 0x10
```

### Účel v ROM

Restart vstoupí do mechanismu výstupu znaků ROM. Interpretace znaku závisí na
právě zvoleném kanálu a na stavu výstupu ROM. Řídicí kódy mohou mít účinky
přesahující vykreslení glyphu.

### Vstupní smlouva PROMETHEA

```text
A = kód znaku
current ROM channel already selected
interrupt environment suitable for ROM output
```

PROMETHEUS ji používá pouze po otevření kanálu 3 a po odeslání úplného
expandovaného řádku zdroje přes vlastní callback renderer. Do A vloží `$0D` a
provede:

```asm
    rst ROM_PrintACharacter
```

Účelem je ukončit tištěný řádek znakem ENTER.

### Výsledek a vedlejší účinky

PROMETHEUS nespoléhá na zachování obecných registrů ani flags. Cestu výstupu ROM
považujte za široce destruktivní, pokud bezprostřední volající výslovně neuloží,
co potřebuje. Může změnit stav kanálu ROM a stav související s cursorem.

### Kde se používá

`outputLineBufferToChannel3`, dosažená příkazem editoru `PRINT`.

### Důležité rozlišení

PROMETHEUS běžně vykresluje text sám do bitmapové paměti Spectra. `RST $10` není
jeho obecná rutina vykreslení znaku na obrazovku. Používá se pro výstup kanálu
ROM.

## B.3 `$0038` — vstup maskovatelného přerušení a past falešného volání

### Adresa

```text
$0038
```

### Jméno ve zdroji

```asm
ROM_MaskableInterrupt: equ 0x38
```

### Normální význam ve stroji

V interrupt mode 1 vede maskovatelné přerušení na `$0038`. Bajtový kód
`RST $38` je `$FF`.

### Použití v PROMETHEOVI

Tři příkazy `RST ROM_MaskableInterrupt` ve zdroji se nacházejí v tabulce
přepínání formátu čelního panelu. Nejsou určeny k vykonání jako volání
přerušení. Zdroj používá mnemonic assembleru ke kompaktnímu emitování bajtu
capabilities `$FF` a zachování historických bajtů.

Znamenají:

```text
všechny capability bits přepínání formátu povoleny
```

nikoli:

```text
zavolej handler přerušení Spectra
```

### Pravidlo čtení

Jde o nejjasnější příklad dat ve tvaru opcode. Samotný statický disassembly
nestačí k prokázání cesty vykonávání.

## B.4 `$0052` — ROM `RET` použitý jako lokalizační sonda

### Adresa

```text
$0052
```

### Jméno ve zdroji

```asm
ROM_ImmediateRET: equ 0x0052
```

### Chování ROM, na němž kód spoléhá

Bajt na tomto vstupu okamžitě vykoná prosté `RET`.

### Vstupní smlouva PROMETHEA

Žádné vstupní registry nejsou důležité. Volání musí být provedeno se stackem v
zapisovatelné RAM. Bootstrap už vypnul přerušení.

### Výsledek

Běžné `CALL $0052` vloží na stack adresu za voláním. ROM `RET` se na ni vrátí.
PROMETHEUS potom dvakrát sníží SP a sejme stále přítomné slovo do BC.

Získané slovo spojí s displacementem známým při sestavení a najde fyzickou
adresu `bootstrapEntry`.

### Vedlejší účinky a předpoklady

- paměť pod navráceným SP stále obsahuje spotřebované návratové slovo;
- mezi návratem z ROM a dvěma instrukcemi `DEC SP` nenastane přerušení ani
  vnořená práce se stackem;
- stack leží v zapisovatelné RAM;
- bajt ROM je v očekávané verzi ROM skutečně prosté `RET`.

### Kde se používá

Pouze v `bootstrapEntry` / `bootstrapRecoverLoadAddress`.

## B.5 `$0205` — překladové tabulky klávesnice v ROM

### Adresa

```text
$0205
```

### Jméno ve zdroji

```asm
ROM_Key_Tables: equ 0x0205
```

### Druh

Jde o data, nikoli volatelnou rutinu.

### Použití v PROMETHEOVI

`processKey` získá ze scanneru ROM index klávesy v E, vytvoří nulou rozšířený
index v BC a použije:

```asm
    ld hl,ROM_Key_Tables-1
    add hl,bc
    ld a,(hl)
```

`-1` kompenzuje jedničkovou konvenci scanneru používanou touto cestou.
PROMETHEUS potom aplikuje vlastní pravidla pro CAPS SHIFT, SYMBOL SHIFT,
command-tokeny, CAPS LOCK a malá písmena.

### Předpoklady

- pořadí tabulky 48K ROM odpovídá hodnotám E ze scanneru;
- vlastní modifier logika PROMETHEA je navrstvena na obyčejnou znakovou tabulku
  ROM, nikoli úplnou náhradou scanování matice.

## B.6 `$028E` — scanování klávesnice

### Adresa

```text
$028E
```

### Jméno ve zdroji

```asm
ROM_KeyboardScanning: equ 0x028e
```

### Výsledná smlouva pozorovaná PROMETHEEM

Zdroj a okolní testy spoléhají na:

```text
E = raw key-table index or $FF-like no-key state
D = modifier/shift class
Z state distinguishes the ROM scanner's accepted/stable result from retry state
```

Instalátor opakuje smyčku, dokud scanner nenahlásí stav očekávaný jeho překladovou
cestou. Rezidentní wrapper editoru `getKeypressCodeOrZero` odmítá:

- žádnou klávesu;
- samotný SYMBOL SHIFT;
- samotný CAPS SHIFT.

### Vstupy

PROMETHEUS nepřipravuje žádný explicitní vstupní registr. Rutina sama čte matici
klávesnice ULA.

### Vedlejší účinky

AF, DE a klávesnicový scratch stav ROM považujte za změněné. Rezidentní wrapper
zachovává HL, protože volající jej může používat jako ukazatel zdroje nebo
displeje.

### Kde se používá

- klávesová smyčka instalátoru;
- `getKeypressCodeOrZero`, nízkoúrovňový rezidentní wrapper klávesnice.

### Proč PROMETHEUS také čte port `$FE` přímo

Scanner ROM se používá pro normalizovanou identitu klávesy. Přímé čtení ULA se
používá pro jednodušší otázky, kde by překlad byl zbytečný:

- je při rolování seznamu stále držena nějaká klávesa?
- byl stisknut SPACE pro přerušení?
- je při autorepeat stále aktivní konkrétní řádek?
- byly po BREAK uvolněny všechny klávesy?

## B.7 `$031E` — test/překlad klávesnice

### Adresa

```text
$031E
```

### Jméno ve zdroji

```asm
ROM_KeyboardTest: equ 0x031e
```

### Vstupní smlouva PROMETHEA

Instalátor tuto rutinu volá bezprostředně po úspěšném/stabilním výsledku
`ROM_KeyboardScanning`. Spoléhá na stav registrů zanechaný scannerem.

### Výsledná smlouva pozorovaná PROMETHEEM

```text
A = translated character code
carry set = usable translated key
B contains shift information used by the installer
```

Instalátor zvýší B a nulu považuje za případ bez shiftu. Shiftované kódy jsou
interně reprezentovány přičtením `$80` k A.

### Vedlejší účinky

AF a B spotřebuje normalizace instalátoru. Na jiné vedlejší účinky ROM se
nespoléhá.

### Kde se používá

Pouze v dočasném instalátoru. Rezidentní klávesnicová cesta používá tabulky ROM
přímočařeji a dodává vlastní mapování příkazů/modifierů.

## B.8 `$04C6` — řízení kazetového SAVE

### Adresa

```text
$04C6
```

### Jméno ve zdroji

```asm
ROM_SaveControl_4c6: equ 0x04c6
```

### Účel

Vstup do kazetového zapisovače ROM Spectra pro hlavičku nebo datový blok.

### Běžné vstupy PROMETHEA

Přesná vstupní konvence ROM je kompaktní a částečně zprostředkovaná předchozím
kódem ROM, ale místa volání stanovují tyto praktické vstupy:

```text
IX = start address of bytes to save
DE = byte length
A  = block flag/type state selected by caller
carry and related tape state prepared for SAVE
interrupt/tape timing environment owned by ROM
```

Pro standardní hlavičku PROMETHEUS dodá 17bajtovou hlavičku v IX, DE=`17` a
A=`0`. Pro následující datový blok dodá flag `$FF` a požadovaný rozsah paměti.

Monitor při raw SAVE bez hlavičky po přípravě leaderu/flag a rozsahu skočí do
tohoto vstupu ROM tail-jumpem.

### Vrácené hodnoty

PROMETHEUS nepoužívá bohatou návratovou strukturu. Rutina ROM buď dokončí
operaci, nebo následuje chování ROM pro chybu/zrušení. Editor SAVE potom
pokračuje dalším blokem nebo se vrátí přes operační cestu PROMETHEA.

### Vedlejší účinky a předpoklady

- kazetový kód ROM řídí časování a port `$FE`;
- zachování registrů se nesmí předpokládat;
- uživatel po promptu PROMETHEA spustil rekordér;
- stack a stav přerušení musí být kompatibilní s kódem ROM.

### Kde se používá

- `waitForKeyAndWriteTapeHeader`;
- datový blok SAVE zdroje/symbolů editoru;
- SAVE libovolného bloku monitorem.

## B.9 `$051A` — `SA_SET`, nastavení navazujícího SAVE

### Adresa

```text
$051A
```

### Jméno ve zdroji

```asm
ROM_SA_SET: equ 0x051a
```

### Účel v PROMETHEOVI

Po uložení hlavního segmentu zdroje zapíše PROMETHEUS pomocný segment obsahující
symbolovou část uložené reprezentace. Připraví IX, DE, stav markeru, B a carry a
potom zavolá `ROM_SA_SET`, aby vstoupil do nastavení navazujícího writeru ROM.

### Vstupy viditelné v místě volání

```text
IX = auxiliary segment start (adjusted as required by ROM convention)
DE = auxiliary length
AF/AF' = marker and flag state
B = ROM timing/state constant `$37`
carry set
```

Okolní manipulace s bajty jsou historickým nastavením protokolu ROM. Je třeba je
chápat jako jednu smlouvu, nikoli je nezávisle zjednodušovat.

### Výsledek a vedlejší účinky

Po operaci ROM se řízení vrátí ke kontrole přerušení pomocí SPACE v PROMETHEOVI.
Žádné běžné zachování registrů se nepředpokládá.

### Kde se používá

Pouze SAVE editoru.

## B.10 `$0562` — LOAD nebo VERIFY bajtů

### Adresa

```text
$0562
```

### Jméno ve zdroji

```asm
ROM_LoadBytes_562: equ 0x0562
```

### Účel

Načíst kazetový blok do paměti nebo jej porovnat s pamětí.

### Smlouva wrapperu PROMETHEA

`callRomTapeLoadOrVerify` přijímá:

```text
IX = destination or comparison address
DE = length
A  = expected block flag
carry set   = LOAD
carry clear = VERIFY
```

Přesune očekávaný flag a stav carry do `AF'`, vypne přerušení, zapíše `$0F` na
port `$FE` a zavolá ROM.

### Výsledek

```text
carry set   = ROM reports successful block operation
carry clear = failure/mismatch/wrong block according to ROM path
```

PROMETHEUS zachová toto carry během testu, zda je držen SPACE. SPACE vyvolá
okamžitý skok na právě nastavené abort continuation.

### Zvláštní použití příkazem Y

Příkaz Y monitoru volá `$0562` přímo s:

```text
IX = inputBufferStart
DE = 18
expected flag = $00 in AF'
LOAD mode
```

Bajt navíc dovolí, aby fyzický kazetový flag/leader zůstal na offsetu nula v
bufferu. Úspěšná standardní hlavička vyplní zbývajících 17 bajtů. Při chybě lze
první bajt stále zobrazit jako raw leader.

### Vedlejší účinky a předpoklady

- před vstupem jsou vypnuta přerušení;
- časování kazety ROM vlastní port `$FE`;
- `AF'` obsahuje soukromý flag/mode stav ROM;
- IX a DE mají přesný význam rozsahu bajtů;
- stack je platný po celou potenciálně dlouhou operaci ROM.

### Kde se používá

- editor LOAD a VERIFY;
- LOAD bloku příkazem J monitoru;
- inspekce hlavičky/leaderu příkazem Y monitoru;
- cesty importovaného kódu/kazety, které znovu používají společný wrapper.

## B.11 `$05C8` — LOAD/VERIFY navazujícího markeru

### Adresa

```text
$05C8
```

### Jméno ve zdroji

```asm
ROM_LD_MARKER: equ 0x05c8
```

### Účel v PROMETHEOVI

Jde o čtecí protějšek nastavení pomocného navazujícího SAVE. VERIFY a LOAD jej
používají pro druhý uložený segment za hlavními daty zdroje.

### Vstupy viditelné v PROMETHEOVI

```text
IX = auxiliary destination/comparison start
DE = auxiliary length minus protocol adjustment
B = marker-state constant `$B0`
AF/AF' = expected flag and LOAD/VERIFY state
```

### Výsledek

Carry se normalizuje přes společnou cestu úspěchu/chyby kazety. SPACE může
operaci následně přerušit přes sdílený polling helper.

### Kde se používá

`invokeVerify` a odpovídající cesta LOAD zdroje.

## B.12 `$11B7` — cesta příkazu ROM NEW

### Adresa

```text
$11B7
```

### Jméno ve zdroji

```asm
ROM_NEWCommandRoutine: equ 0x11b7
```

### Použití v PROMETHEOVI

Položky command-tokenů N a O v `commandHandlerTable` ukazují přímo na tuto
rutinu ROM. Duplicitní sloty jsou zachované historické aliasy.

### Význam

Nejde o vlastní příkaz PROMETHEA „vymaž zdroj“. Vstupuje do cesty NEW v ROM
Spectra se širokými důsledky chování BASICového NEW a obsluhy chyb ROM.

### Vstupy, návrat a předpoklady

PROMETHEUS neposkytuje úzkou podprogramovou smlouvu a neočekává běžný návrat do
tabulky handlerů editoru. Jde o předání řízení příkazové logice ROM. Přesné
chování závisí na prostředí ROM a systémových proměnných.

### Kde se používá

Položky `$CE` a `$CF` v `commandHandlerTable`.

## B.13 `$1601` — otevření kanálu ROM

### Adresa

```text
$1601
```

### Jméno ve zdroji

```asm
ROM_ChannelOpen: equ 0x1601
```

### Vstupní smlouva PROMETHEA

```text
A = channel number
```

PROMETHEUS dodá A=`3` před tiskem zdroje přes výstupní systém ROM. Kanál 3 je ve
standardním uspořádání Spectra kanálem tiskárny.

### Výsledek a vedlejší účinky

ROM aktualizuje systémový stav současného kanálu. PROMETHEUS potom povolí
přerušení, vykreslí expandovaný řádek přes svůj výstupní callback a použije
`RST $10` pro ENTER. Obecné registry a flags nelze považovat za zachované nad
rámec toho, co místní volající výslovně obnoví.

### Kde se používá

`outputLineBufferToChannel3`.

## B.14 `$1B76` — návrat ze statementu BASICu

### Adresa

```text
$1B76
```

### Jméno ve zdroji

```asm
ROM_StatementReturn: equ 0x1b76
```

### Příprava PROMETHEA

`invokeBasic` provede:

```asm
    ld iy,05c3ah
    im 1
    ei
    ld sp,(SYSVAR_ERR_SP)
    jp ROM_StatementReturn
```

### Účel

PROMETHEUS obnoví ROM očekávanou bázi IY, interrupt mode a stav povolení
přerušení, potom obnoví error-return stack pointer BASICu a skočí do cesty
návratu ze statementu ROM.

### Výsledek

Řízení pokračuje v prostředí BASICu místo návratu k volajícímu PROMETHEA.

### Předpoklady

- standardní rozložení systémových proměnných 48K ROM;
- `SYSVAR_ERR_SP` stále popisuje platný kontext návratu do BASICu;
- IY=`$5C3A` je ROM očekávaná báze systémových proměnných;
- interrupt mode 1 je normálním prostředím Spectra.

### Kde se používá

Příkaz B / `BASIC` editoru.

## B.15 `$1F54` — test klávesy BREAK

### Adresa

```text
$1F54
```

### Jméno ve zdroji

```asm
ROM_BreakKey: equ 0x1f54
```

### Výsledná smlouva pozorovaná PROMETHEEM

Smyčky trasování interpretují:

```text
carry set   = BREAK is not requesting termination; continue tracing
carry clear = BREAK detected; stop and wait for key release
```

Pomalé trasování opakuje smyčku, dokud carry zůstává nastavené. Rychlé trasování
při vynulování carry větví do čekání na uvolnění kláves.

### Vstupy

Není připraven žádný explicitní vstupní registr. Rutina testuje kombinaci BREAK
Spectra, obvykle CAPS SHIFT+SPACE.

### Vedlejší účinky

AF se změní. PROMETHEUS nespoléhá na zachování jiného scratch stavu ROM.

### Kde se používá

- `monSlowTracing`;
- `monFastTracingToAddress`.

## B.16 `$22B0` — převod souřadnic na adresu bitmapy

### Adresa

```text
$22B0
```

### Jméno ve zdroji

```asm
ROM_PixelAddress_22b0: equ 0x22b0
```

### Vstupní smlouva PROMETHEA

Místa volání používají registry souřadnic takto:

```text
B or A-derived row state = vertical pixel/text-row coordinate as prepared by caller
C = horizontal pixel coordinate, commonly 0
```

Přesná konvence ROM je zděděna každým volajícím; PROMETHEUS obvykle nastaví
C=`0` a dodá řádkovou souřadnici již ve tvaru očekávaném helperem ROM.

### Výsledek

```text
HL = address in `$4000-$57FF` corresponding to the requested pixel position
```

PROMETHEUS potom použije výsledek jako první bajt řádku znaku, operace mazání
nebo kopie obrazovkového řádku.

### Vedlejší účinky

AF a další scratch registry se mohou změnit. Volající ukládají souřadnice, které
potřebují později.

### Kde se používá

- vymazání jednoho 32znakového řádku bitmapy;
- kopie textového řádku při rychlém rolování zdroje;
- umístění vykreslování monitoru/editoru na vypočtené souřadnice obrazovky.

### Proč zde použít ROM, ale ne pro vykreslování znaků

Uspořádání řádků bitmapy Spectra je nepříjemné. ROM už obsahuje spolehlivý
výpočet souřadnice na adresu. PROMETHEUS tento výpočet znovu použije a potom
provede vlastní rychlé kreslení na úrovni bajtů.

## B.17 `SYSVAR_ERR_SP` na `$5C3D`

### Adresa

```text
$5C3D-$5C3E
```

### Jméno ve zdroji

```asm
SYSVAR_ERR_SP: equ 05c3dh
```

### Význam

Slovo označuje polohu stacku používanou mechanismem návratu z chyby/statementu
ROM.

### Použití v PROMETHEOVI

Před návratem do BASICu PROMETHEUS načte:

```asm
    ld sp,(SYSVAR_ERR_SP)
```

Potom skočí na `ROM_StatementReturn`.

### Předpoklady a nebezpečí

Nejde o soukromou proměnnou PROMETHEA. Její přepsání nebo návrat s
nekompatibilním kontextem ROM by mohl poslat BASIC na neplatný stack frame.
PROMETHEUS ji pouze čte během pečlivě připraveného odchodu do BASICu.

## B.18 Port `$FE` — sdílený klávesnicový/výstupní port ULA

Port `$FE` kombinuje několik nesouvisejících hardwarových funkcí. Důležitá
funkce závisí na tom, zda Z80 vykonává `IN` nebo `OUT`, a na adrese umístěné na
horních linkách sběrnice.

### B.18.1 Výstupní rozložení používané PROMETHEEM

Pro `OUT ($FE),A` dolní bity přibližně řídí:

```text
bits 0-2  border colour
bit 3     microphone/tape output
bit 4     speaker output
```

PROMETHEUS používá port pro:

- nastavení nebo obnovení nakonfigurovaného borderu;
- přepínání bitu 4 pro kliknutí kláves a beep;
- nastavení stavu border/MIC očekávaného ROM před LOAD/VERIFY;
- zrcadlení jednoho kompaktního bajtu režimu disassembly jako historického
  vedlejšího účinku zpětné vazby příkazu.

Protože jeden zápis ovlivní všechny dolní výstupní funkce současně, zvukové
rutiny odvodí základní bajt obsahující požadovaný border a přepínají pouze bit 4
speakeru.

### B.18.2 Vstup klávesnice

Matice klávesnice je active low. Zvolený řádek se umístí na horní adresové linky
a pět bitů kláves se čte v bitech 0–4 A.

Typický vzor PROMETHEA:

```asm
    in a,(0feh)
    cpl
    and 01fh
```

Po komplementování nenulová hodnota znamená, že je stisknuta alespoň jedna
klávesa ve zvoleném řádku.

Konkrétní použití zahrnuje:

- streamování při držení libovolné klávesy během dlouhých seznamů monitoru;
- čekání na uvolnění všech kláves po BREAK;
- přerušení SPACE pomocí selektoru řádku `$7F` a bitu 0;
- opakování držené klávesy editoru ve zvoleném řádku;
- polling zrušení instalátoru/importu.

### B.18.3 Vedlejší účinky a časování

`IN` a `OUT` samy ROM nevolají, časování je však důležité:

- výšku a délku zvuku vytváří časování instrukčních smyček;
- kazetový kód ROM předpokládá vhodný stav portu a přerušení;
- řádky klávesnice jsou active low a musí se podle toho interpretovat;
- změna delay smyčky může slyšitelně změnit chování.

## B.19 Bitmapa obrazovky `$4000-$57FF`

### Rozložení

Bitmapa o 6 144 bajtech obsahuje 256 × 192 pixelů, ale pořadí řádků je
prokládané. Přičtení 32 posune jeden bajtový řádek vodorovně/uvnitř logického
pásma, ne vždy na další viditelný řádek znaku. PROMETHEUS často zvyšuje H pro
pohyb mezi osmi pixelovými řádky znakové buňky a pro větší převody souřadnic
používá helper adresy pixelu ROM.

### Použití v PROMETHEOVI

- běžný displej editoru a monitoru;
- vlastní vykreslování znaků z dat fontu ROM;
- rolování řádků a kopírování řádků;
- pole čelního panelu monitoru;
- logo instalátoru;
- `$4000-$4FFF` jako dočasný workspace bootstrapu a oblast stacku.

### Destrukce bootstrapem

Instalátor začíná vymazáním `$4000-$4FFF`. Záměrně tím zničí velkou část
viditelné bitmapy, aby mohla sloužit jako čistý workspace a dočasný stack.
Instalátor potom nakreslí vlastní rozhraní.

## B.20 Attribute RAM `$5800-$5AFF`

Každý attribute bajt popisuje jednu znakovou buňku 8×8:

```text
bits 0-2  INK
bits 3-5  PAPER
bit 6     BRIGHT
bit 7     FLASH
```

PROMETHEUS ukládá běžné attributes, například:

```asm
TEXT_COLOR:               equ 038h
HIGHLIGHT_COLOR:          equ 030h
FRONT_PANEL_EDITOR_COLOR: equ 039h
```

Instalátor dovoluje uživateli editovat INK, PAPER a BRIGHT normálního a
zvýrazněného textu. Rezidentní obrazovkové rutiny kopírují nebo transformují
attributes nezávisle na bitmapě.

## B.21 Font ROM

Vlastní renderer PROMETHEA používá glyph bajty z fontu ROM Spectra místo volání
ROM print pro běžný obrazovkový výstup. Přesná báze fontu se dosáhne zavedenou
konvencí ROM/fontu v zobrazovacích rutinách. Pro každý znak se načte osm řádků
bitmapy, v instalátoru se případně transformují podle case/bold a zapíší se do
prokládaného displeje.

PROMETHEUS tím získává:

- předvídatelné umístění ve 32 sloupcích;
- vlastní vykreslení cursoru a tokenů;
- přímou kontrolu attributes;
- rychlost nezávislou na systému kanálů ROM.

## B.22 Předpoklady o přerušení

Program mění stav přerušení podle potřeb subsystému.

### Instalace

Bootstrap začíná `DI`. Samolokalizace, použití obrazovky jako stacku,
kopírování, konfigurační patchování a relokace nesmějí být přerušeny, dokud jsou
kontexty kódu a stacku přechodné.

### Kazeta

Společný wrapper LOAD/VERIFY vykoná `DI` před časováním kazety ROM. ROM vlastní
operaci až do návratu.

### Vykonávání monitoru

Monitor ukládá stav povolení přerušení uživatele a jako první scratch instrukci
sestaví `DI` nebo `EI`. Stav přerušení je součástí simulovaného uživatelského
procesoru, nikoli pouhým nastavením monitoru.

### Návrat do BASICu

`invokeBasic` obnoví IM 1 a vykoná `EI` před vstupem do návratu ze statementu
ROM.

### Kanál tiskárny ROM

PROMETHEUS po otevření kanálu 3 povolí přerušení před použitím výstupu ROM.

## B.23 Předpoklady stacku podle služby

| Služba | Požadavek na stack v PROMETHEOVI |
|---|---|
| immediate RET `$0052` | návratové slovo musí zůstat čitelné; nesmí nastat mezilehlá aktivita stacku |
| klávesnicová volání ROM | platný běžný rezidentní/instalační stack |
| kazetová volání ROM | stabilní zapisovatelný stack pro dlouhou časově citlivou rutinu |
| channel/print ROM | stack kompatibilní s ROM a vhodný stav přerušení |
| návrat do BASICu | SP obnoven z `ERR_SP`; nejde o běžný návrat z podprogramu |
| nativní CALL monitoru | uložený uživatelský SP musí být zapisovatelný a sémanticky platný |

## B.24 Závislost na verzi ROM

Pojmenované adresy programu předpokládají standardní rozložení ROM 48K Spectra.
Kompatibilní klon ROM musí zachovat nejen veřejné vstupní body, ale také konkrétní
interní vstupy a tabulku na `$0052`, `$0205`, `$028E`, `$031E`, `$04C6`, `$051A`,
`$0562`, `$05C8` a `$22B0`.

Stroj, který pouze poskytuje chování kompatibilní s BASICem, ale přesune tyto
interní rutiny, není binárně kompatibilní s PROMETHEEM.

## B.25 Tabulka rychlé diagnostiky

Když rekonstruovaný build selže pouze v jedné oblasti, jsou tyto externí smlouvy
přirozenými podezřelými:

| Příznak | První externí smlouvy ke kontrole |
|---|---|
| instalátor nedokáže rozpoznat klávesy | `$028E`, `$031E`, port `$FE` |
| rezidentní příkazy mají chybná písmena | `$0205`, `$028E`, mapování modifierů |
| řádky obrazovky jsou pomíchané | `$22B0`, předpoklady prokládání bitmapy |
| není slyšet kliknutí nebo je chybný border | port `$FE`, nakonfigurovaný výstupní bajt, delay smyčky |
| SAVE zapisuje chybnou sekvenci bloků | `$04C6`, `$051A`, AF' a nastavení markeru |
| LOAD/VERIFY vždy selže | `$0562`, `$05C8`, konvence IX/DE/flag/carry |
| PRINT míří do chybného cíle | `$1601`, současný kanál ROM, `RST $10` |
| návrat do BASICu havaruje | IY=`$5C3A`, IM 1, `ERR_SP`, `$1B76` |
| trasování se nikdy nezastaví na BREAK | interpretace carry z `$1F54` |
| bootstrap kopíruje z chybného místa | `$0052` musí být okamžité `RET` |

Obecnější poučení je, že PROMETHEUS používá ROM selektivně. Nepředává aplikaci
BASICu, ale ani neduplikuje každou službu. Často používané zobrazování, editaci a
sestavování drží pod vlastní kontrolou a vypůjčuje si pečlivě zvolené služby
stroje, jejichž přesné adresy tvoří část platformní smlouvy programu.
