# Kapitola 1: Dílna uvnitř Spectra

Představte si, že na ZX Spectru píšete program ve strojovém kódu. Samotný počítač má pouze 48 KB RAM. Část této paměti musí zabírat obrazovka. Další část vývojový nástroj. Nástroj zároveň musí najít prostor pro zdrojový text, názvy symbolů, vytvářený strojový kód a dočasné buffery potřebné při editaci a překladu.

Na moderním počítači mohou editor, překladač a debugger zabírat každý mnoho megabajtů. PROMETHEUS vměstná všechny tři role do jediného rezidentního programu, který je stále dost malý na to, aby programátorovi ponechal použitelný prostor.

To je nejlepší první popis PROMETHEA: **dílna pro strojový kód uvnitř Spectra**.

## Tři hlavní nástroje, jeden sdílený svět

Dílna má tři velké místnosti.

### Editor zdrojového textu

Editor dovoluje uživateli zadávat a měnit zdrojový text v assembleru. Není to obecný textový editor, v němž se náhodou píše jazyk symbolických instrukcí. Rozumí stavbě řádku assembleru: labelům, mnemonikám, operandům, komentářům a direktivám assembleru.

To je důležité, protože PROMETHEUS neuchovává každý řádek zdroje jako obyčejný text. Text se příjemně zobrazuje, ale jeho ukládání je neúsporné. Jakmile je řádek přijat, editor jej rozebere a uloží jako kompaktní záznam. Když je třeba řádek znovu zobrazit, PROMETHEUS záznam rozvine zpět do čitelného textu.

Editor tedy provádí dva opačné překlady:

```text
co uživatel napíše      → kompaktní záznam zdroje
kompaktní záznam zdroje → co uživatel vidí
```

Tentýž kompaktní zdroj později zpracuje assembler a dokáže jej vytvářet dokonce i disassembler.

### Dvouprůchodový assembler

Assembler mění záznamy zdroje na strojové bajty. Používá dva průchody, protože label může být použit dříve, než je známa jeho hodnota.

Uvažujme skok dopředu:

```asm
        JP FINISH
        ; zde může být mnoho řádků
FINISH  RET
```

Když assembler poprvé narazí na `JP FINISH`, nemusí ještě znát adresu `FINISH`. V prvním průchodu spočítá, kam bude umístěn každý řádek, a zaznamená hodnoty labelů. Ve druhém průchodu už tyto hodnoty zná a může vytvořit konečné bajty.

PROMETHEUS také udržuje tabulku symbolů, vyhodnocuje výrazy, rozpoznává tvary instrukcí, kontroluje povolené rozsahy hodnot a hlásí chybu u záznamu zdroje, který ji způsobil.

### Monitor

Monitor dovoluje programátorovi zkoumat stroj po sestavení kódu. Umí zobrazit registry a příznaky, prohlížet paměť, měnit bajty, disassemblovat instrukce, hledat v paměti, ukládat a načítat bloky, nastavovat dočasné breakpointy a opatrně spouštět jiný program.

Slovo *monitor* může znít, jako by tato část pouze něco sledovala. V terminologii raných mikropočítačů byl monitor strojového kódu interaktivním ovládacím panelem procesoru a paměti.

Monitor PROMETHEA je mimořádně těsně propojen s assemblerem. Disassembler nevymýšlí vlastní oddělený textový formát. Vytvoří dočasný kompaktní záznam zdroje a požádá běžný expander zdroje, aby jej vykreslil. Disassemblovaná instrukce proto může vypadat jako řádek editoru, protože se jím uvnitř programu na okamžik skutečně stane.

## Dvoje dveře do rezidentního programu

Rezidentní obraz má dvě veřejné vstupní hranice:

```asm
ENTRY_POINT_WITH_MONITOR:
    jp startPrometheus
```

a přesně o 5 000 bajtů dále:

```asm
ENTRY_POINT_WITHOUT_MONITOR:
    jp startPrometheus
```

Zpočátku to působí podivně. Oba vstupy skáčou do editoru, nikoli do různých hlavních rutin.

Důvodem je možnost nainstalovat PROMETHEUS ve dvou podobách:

- **úplná instalace** — monitor společně s assemblerem a editorem;
- **instalace pouze assembleru** — pětitisícibajtový prefix monitoru je kvůli úspoře paměti vynechán.

V úplné podobě je první vstup základnou celého rezidentního obrazu. Monitor leží pod částí assembleru a editoru a později jej lze otevřít přes `startMonitor`.

Při instalaci samotného assembleru se kopírování zahájí druhým vstupem. Zkopíruje se přesně stejný suffix assembleru s editorem, ten se však stane začátkem nainstalovaného programu. Chybějící monitor vyrovná relokace a dvě záměrné opravy kódu.

Dva vstupy tedy nepřipomínají dvoje odlišné hlavní dveře. Jsou spíše dvěma dovolenými místy, kde lze tutéž budovu odříznout.

## Editor je obvyklou domovskou obrazovkou

Po instalaci vstoupí `startPrometheus` do editoru:

```asm
startPrometheus:
    di
    ld e,SEPARATOR_CHARCODE
    call clearDisplay
prometheusWarmStart:
    ld hl,ACCESS_LINE_ATTRIBUTE_ADDRESS
    ld bc,02000h+HIGHLIGHT_COLOR
    call atHLrepeatBTimesC
    ld a,MESSAGE_COPYRIGHT
```

Zatím nemusíme rozumět každé instrukci. Celková činnost je jednoduchá:

1. zabránit tomu, aby inicializaci narušilo přerušení;
2. vymazat obrazovku;
3. zvýraznit aktivní vstupní řádek;
4. zobrazit stavovou zprávu;
5. vyčistit dočasné editační buffery;
6. nastavit vlastní zásobník programu;
7. vykreslit viditelné řádky zdroje;
8. vstoupit do smyčky zpracování kláves.

V pseudokódu:

```text
start editor:
    dočasně zakaž přerušení
    vymaž obrazovku
    připrav barvy a buffery
    obnov zásobník editoru
    zobraz aktuální okno zdroje

    repeat forever:
        vykresli editovatelný řádek
        přečti jednu normalizovanou klávesu
        proveď požadovanou editační akci
```

Skutečná smyčka je složitější, protože klávesy mohou zůstat stisknuté, kombinace s modifikátory mají zvláštní význam a některé příkazy nahrazují obvyklou pokračovací cestu. Toto je však její stabilní vnější uspořádání.

## Do monitoru se vstupuje zevnitř dílny

Úplná instalace obsahuje `startMonitor`, samostatný teplý vstup monitoru. Ten obnoví soukromý pracovní stav monitoru, vybere slovník a handlery monitoru, vykreslí čelní panel, přečte příkaz a předá jej odpovídající rutině.

Monitor není zcela oddělený program připojený jediným voláním. S editorem sdílí mnoho služeb:

- formátování čísel;
- vykreslování textu;
- vstup z klávesnice;
- přístup ke kazetě;
- znalost výrazů a symbolů;
- expanzi zdrojových záznamů;
- znovupoužitelné pomocné rutiny pro rozsahy paměti.

Sdílení šetří paměť, ale zároveň vysvětluje některé neobvyklé části zdroje. Společná rutina může být jednou použita při klidné operaci editoru a později v cestě monitoru, kde byly dočasně přesměrovány registry, callbacky nebo zpracování chyb.

## Co může uživatel udělat během jednoho sezení

Typické sezení může vypadat takto:

1. Zadat několik řádků assembleru.
2. Opravit chybný operand.
3. Označit blok zdroje.
4. Sestavit celý zdroj nebo pouze označený blok.
5. Spustit vytvořený program prostřednictvím vstupní direktivy `ENT`.
6. Vstoupit do monitoru.
7. Prohlédnout vytvořené bajty.
8. Disassemblovat je zpět do textu podobného zdroji.
9. Změnit bajt nebo registr.
10. Krokovat instrukci.
11. Uložit zdroj, symboly nebo surový blok paměti na kazetu.
12. Vrátit se k editaci.

Tyto činnosti nejsou izolovanými příkazy dodatečně připevněnými k nabídce. Jsou různými pohledy na tytéž informace.

Label napsaný v editoru se stane položkou tabulky symbolů. Assembler jej použije při vytváření adresy. Monitor může toto jméno symbolu zobrazit při disassemblování dané adresy. Disassemblovanou instrukci lze vložit zpět do zdroje. Příkaz RUN použije adresu vybranou direktivou `ENT`. Monitor chrání rezidentní oblast zdroje a symbolů, protože ví, kde právě končí dynamická paměť editoru.

Dílnu propojují sdílené reprezentace.

## Program, který si pamatuje přepisováním sebe sama

Jedním z prvních překvapení ve zdroji je množství labelů začínajících `varc`. Označují trvalé hodnoty uložené přímo v bajtech instrukcí.

Rutina může například obsahovat:

```asm
varcAssemblyOutputPointer:
    ld hl,00000h
```

Jiná rutina zapíše nové slovo do operandu za opcode `LD`. Při příštím vykonání tato instrukce načte zapamatovaný ukazatel.

Moderní čtenář často považuje kód a data za přísně oddělené. Na Spectru leží obojí ve stejné zapisovatelné RAM. PROMETHEUS této skutečnosti využívá.

Tento styl může ušetřit instrukce i samostatné buňky proměnných. Zároveň umožňuje velmi kompaktní dispatch: cíl instrukce `CALL` lze změnit mezi prvním a druhým průchodem assembleru nebo může samotný opcode vyjadřovat aktuální režim.

Cenou je dvojí role zdánlivě obyčejné instrukce:

- nyní vykoná určitou činnost;
- současně uchová stav pro pozdější použití.

Této technice věnujeme celou kapitolu. Prozatím si zapamatujme, že program své instrukce nejen *vykonává*. Také *používá jejich bajty jako paměť*.

## Tabulky jako malé specializované jazyky

PROMETHEUS je plný tabulek, ale ne všechny jsou obyčejnými seznamy.

Tabulka může popisovat:

- položku čelního panelu monitoru;
- zápis mnemoniky;
- třídu operandu;
- kódování instrukce;
- handler příkazu;
- chráněný rozsah adres;
- kompaktní řetězec;
- záznam zdroje;
- relokační cíl.

Každá tabulka je malým jazykem, kterému rozumí jedna nebo více interpretačních rutin. Bajt může znamenat „zobraz tuto hodnotu šestnáctkově“, „právě dorazil poslední znak“, „skoč o tento počet bajtů zpět ke skutečnému řetězci“ nebo „následující dva bajty obsahují pořadové číslo symbolu“.

To vede k jednomu z nejdůležitějších čtenářských návyků pro celý zdroj:

> Když blok bajtů vypadá záhadně, najděte nejprve rutinu, která jej čte.

Význam obvykle leží ve vztahu mezi tabulkou a jejím konzumentem, nikoli v samotných bajtech.

## Proč je zdroj jedním velkým souborem

Rekonstruovaný zdroj je z velké části monolitický. To neznamená, že program nemá subsystémy. Znamená to, že výsledný obraz těsně spojuje:

- spustitelné rutiny;
- zapisovatelné operandy instrukcí;
- počáteční buffery;
- kompaktní řetězce;
- tabulky deskriptorů;
- generovaná metadata;
- dvě možné rezidentní hranice.

Mechanické rozdělení takového souboru může skrýt fyzické vztahy, na nichž záleží. K bajtu se může přistupovat samorelativním posunem. Pořadí tabulky může být zakódováno jako číslo tokenu. Vstup samotného assembleru musí zůstat přesně na hranici mezi částí monitoru a částí editoru, pokud nebude instalační program přestavěn tak, aby dokázal sledovat jeho nové umístění.

Kniha bude pojmy organizovat svobodněji než binární obraz, ale vždy se vrátí k fyzickému zdroji.

## Zpět k celému stroji

Nyní můžeme nakreslit první užitečný obrázek:

```text
                  ┌────────────────────────┐
                  │    editor zdrojového   │
klávesnice ─────► │  textu a čitelný řádek│
                  └───────────┬────────────┘
                              │ komprimované záznamy
                              ▼
                  ┌────────────────────────┐
                  │ dvouprůchodový assembler│
                  │   symboly + výrazy     │
                  └───────────┬────────────┘
                              │ strojové bajty
                              ▼
                  ┌────────────────────────┐
                  │        monitor         │
                  │ prohlížet / měnit / run│
                  └───────────┬────────────┘
                              │ disassemblované záznamy
                              └──────────────► editor
```

Obrázek je stále jednoduchý, ale každému pozdějšímu mechanismu poskytuje domov.

V následující kapitole projde celým tímto okruhem jediný malý zdrojový program. Ještě nebudeme zkoumat každý bajt jeho formátu. Nejprve uvidíme, proč takové formáty vůbec musí existovat.

## Co se změnilo v paměti?

Po běžném spuštění editoru:

- rezidentní obraz PROMETHEA je již nainstalovaný a relokovaný;
- bitmapa obrazovky a atributy byly inicializovány;
- editační a formátovací buffery byly vyčištěny;
- vnitřní ukazatel zásobníku byl obnoven;
- aktuální komprimovaný zdroj zůstává ve své rezidentní oblasti;
- editor čeká v cestě zpracování kláves.

Žádný uživatelský program ještě nebyl sestaven. Dílna je otevřená, ale pracovní stůl zůstává prázdný.

## Představené zdrojové labely

- `ENTRY_POINT_WITH_MONITOR`
- `ENTRY_POINT_WITHOUT_MONITOR`
- `startPrometheus`
- `prometheusWarmStart`
- `startMonitor`
- `processKey`
- `varcAssemblyOutputPointer`
