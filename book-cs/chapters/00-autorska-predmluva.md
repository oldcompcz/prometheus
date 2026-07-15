# Autorská předmluva: Jak tuto knihu číst

Rozsáhlý program v assembleru může na první pohled působit zvláštně. I když je každá instrukce platná a každý label má smysluplný název, stránka může připomínat spíše inventář skladu než příběh. Do registru se vloží hodnota, otestuje se příznak, posune se ukazatel, zkopírují se tři bajty — a kód náhle skočí někam, co zdánlivě patří ke zcela jinému tématu.

U PROMETHEA je tento dojem ještě silnější než u většiny programů. Není to jediná jednoduchá rutina opakovaná v mnoha obměnách. Je to editor, assembler, disassembler, debugger, kazetový nástroj, obrazovkové rozhraní a relokovatelný instalační program, které sdílejí jeden malý počítač. Některé instrukce současně slouží jako proměnné. Některé tabulky vypadají jako instrukce, přestože jsou daty. Některá data obsahují drobné posuny, které dávají smysl pouze vzhledem k adrese bajtu, v němž jsou uloženy. Několik subsystémů si půjčuje stejné buffery a dočasně nahrazuje adresy callbacků jiných částí programu.

Zdroj lze číst přímo, ale takové čtení je nákladné. Pro pochopení jedné rutiny často potřebujeme znát formát definovaný o tisíce řádků později. Pro pochopení formátu zase potřebujeme znát rutinu, která jej používá. Tato kniha má tento kruh přerušit.

## Nemusíte být odborníkem na Z80

Předpokládáme pouze, že čtenář zná základní myšlenky assembleru:

- procesor má registry;
- instrukce přesouvají a mění hodnoty;
- labely pojmenovávají adresy;
- skoky mění následující vykonanou instrukci;
- zásobník podporuje volání rutin a dočasné ukládání hodnot;
- strojový kód je bajtová podoba instrukcí.

To pro začátek stačí.

Kdykoli PROMETHEUS použije méně známou vlastnost Z80 — alternativní registry, `EXX`, příznak carry jako návratovou logickou hodnotu, samomodifikované operandy instrukcí nebo trik s ukazatelem zásobníku — vysvětlíme ji v okamžiku, kdy začne být užitečná. Nebudeme před setkáním s programem zastavovat kvůli úplnému kurzu Z80. Technika se pamatuje snáze, když už víme, jaký problém řeší.

## Pořadí se záměrně liší od zdrojového souboru

Fyzický zdroj začíná instalací a relokací. Pro výsledný binární obraz je toto pořadí správné, pro výuku však nikoli. Relokace je odpovědí na otázku, kterou si nový čtenář ještě nepoložil: *co přesně se přesouvá a proč je nutné opravit tolik vnitřních adres?*

Začneme proto běžícím programem. Nejprve se podíváme na editor, assembler a monitor jako na propojenou dílnu. Potom touto dílnou provedeme malý program. Teprve pak zmapujeme paměť, v níž všechno žije.

Pozdější části budou opakovat stejný rytmus:

```text
podívej se na funkci shora
        ↓
poznej její malé mechanismy
        ↓
znovu projdi celou funkci
```

Část o editoru například začne tím, co se stane po stisku klávesy. Potom sestoupí k normalizaci klávesnice, editovatelným bufferům, komprimovaným záznamům zdroje a přesouvání paměti. Nakonec projdeme jediný upravený řádek od klávesové matice až k jeho trvalé komprimované podobě.

Část o monitoru bude postupovat stejně. Nejprve uvidíme čelní panel a okno disassembleru. Teprve později prozkoumáme deskriptory instrukcí, chráněné rozsahy paměti, uložený stav procesoru a pomocný kód používaný při krokování.

## Skutečný kód, nikoli komentář ke každému řádku

Kniha používá skutečné úryvky, například:

```asm
ENTRY_POINT_WITH_MONITOR:
    jp startPrometheus
```

Úryvek uvádíme tehdy, když záleží na přesné technice Z80, když potřebujeme diskusi ukotvit ke skutečnému labelu nebo když je kód srozumitelnější než slovní popis.

Nepomohlo by zkopírovat padesát řádků rutiny a každou instrukci nahradit českou větou. Zdroj už instrukce obsahuje. Úkolem knihy je odhalit větší děj.

Celé algoritmy proto často znovu vyjádříme pseudokódem:

```text
for each záznam zdroje:
    if toto je první průchod:
        urči adresy a definuj labely
    else:
        vytvoř konečné bajty instrukce
```

Tento pseudokód není alternativní implementací. Je mapou. Jakmile je mapa jasná, skutečná cesta na úrovni registrů se sleduje mnohem snáze.

## Pravidlo pro pseudokód v českém překladu

Řídicí klíčová slova pseudokódu zůstávají anglicky: například `if`, `else`, `for each`, `while`, `repeat`, `until`, `return` a `call`. Zbytek se překládá do češtiny, pokud nejde o skutečný label, název rutiny, proměnnou, konstantu, datový formát nebo jiný zavedený identifikátor.

Vzniká tím úmyslně smíšený zápis:

```text
repeat:
    key = načtiNormalizovanouKlávesu()
    if key je příkaz editoru:
        call příslušný handler
until uživatel opustí editor
```

Anglická klíčová slova drží pseudokód vizuálně blízko běžným programovacím jazykům. Český popis činností naopak umožňuje číst algoritmus bez zbytečného překládání v hlavě. Skutečné identifikátory ze zdroje se nikdy nepřekládají.

## Rekonstruované názvy a historická fakta

Dochovaný strojový obraz nepřišel se všemi popisnými labely používanými v dnešním repozitáři. Mnohé názvy byly rekonstruovány z toku řízení, používání dat, stop z emulátoru, příruček a opakovaného ověřování. Label jako `disassembleNextLineToBuffer` říká, co rutina prokazatelně dělá; netvrdí, že původní programátor použil právě toto slovní spojení.

Projekt rozlišuje také několik druhů jistoty:

- **Bajtová identita** znamená, že rekonstruovaný zdroj vytváří přesně stejné historické strojové bajty.
- **Statická analýza** znamená, že chování vyplývá z instrukcí a toku dat.
- **Důkaz během vykonávání** znamená, že cesta byla pozorována v emulátoru nebo v testovacím prostředí CPU.
- **Interpretace** znamená, že máme silné vysvětlení, proč byla určitá technika zvolena, ale nedochoval se komentář původního autora, který by tento záměr výslovně potvrzoval.

Kde je toto rozlišení důležité, kniha to řekne. Je lepší ponechat malou nejistotu viditelnou než proměnit věrohodný odhad ve falešnou historii.

## Labely jsou užitečnější než čísla řádků

Soubor se bude dále vyvíjet. Čísla řádků jsou proto špatnými dlouhodobými odkazy. Kapitoly odkazují především na labely:

- `startPrometheus`
- `processCompilation`
- `sourceBufferStart`
- `disassembleNextLineToBuffer`

Label přežije přidávání komentářů a obvykle přímo vyjadřuje pojem, o němž se mluví. Přehled pokrytí zdroje zaznamenává, kde je každý důležitý label náležitě vysvětlen.

## Ústřední otázka

Téměř každému návrhovému rozhodnutí v PROMETHEU lze porozumět pomocí jediné otázky:

> Jak lze tuto funkci učinit užitečnou a přitom spotřebovat jen velmi málo paměti?

Odpověď je někdy elegantní a jindy neúprosná. Řádky zdroje jsou komprimovány. Jména zastupují kompaktní pořadová čísla. Řetězce často používají nejvyšší bit posledního znaku jako značku konce. Operandy instrukcí současně slouží jako zapisovatelné proměnné. Tabulky nahrazují opakovaný rozhodovací kód. Monitor znovu používá expander zdroje k vytvoření textu disassemblovaných instrukcí. Instalační program relokuje celý systém, takže uživatel není nucen držet jej na jediné pevné adrese.

Nejde o izolované triky. Společně tvoří osobnost programu.

První kapitola nyní představí dílnu, kterou tato rozhodnutí vytvořila.
