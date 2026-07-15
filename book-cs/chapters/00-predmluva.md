# Předmluva: Oheň uvnitř stroje

Napsat v roce 1990 na ZX Spectru seriózní program ve strojovém kódu znamenalo vměstnat několik velkých věcí do jediné velmi malé místnosti. Počítač musel současně uchovávat vývojový nástroj, zdrojový text, tabulku symbolů, vznikající strojový kód i prostředky, kterými bylo možné tento kód zkoumat, když nefungoval. Jediným trvalým úložištěm býval často kazetový magnetofon. Každý další kilobajt zabraný nástroji byl kilobajtem odebraným programu.

PROMETHEUS vznikl právě pro tento svět.

Napsal jej český programátor **Tomáš Vilím**, známý také pod jménem **Universum**, a v roce **1990** jej poprvé vydala ústecká společnost **Proxima – Software**. Původní vydání patří do světa počítačů Sinclair ZX Spectrum a tehdy již zavedeného Didaktiku Gama. Dochované katalogové záznamy zachycují původní 48K systém i pozdější 128K verze.[^predmluva-1]

Označit PROMETHEUS pouze za assembler je přesné asi tak, jako označit dílnu pouze za místnost. Jeho ústředním úkolem je překládat jazyk symbolických instrukcí procesoru Z80 do strojového kódu, kolem samotného překladače však stojí téměř vše, co je zapotřebí k vývoji programu přímo na počítači:

- editor zdrojového textu;
- dvouprůchodový assembler;
- tabulka symbolů průběžně udržovaná při úpravách zdroje;
- disassembler;
- monitor strojového kódu;
- trasování a krokování instrukcí;
- prohlížení, vyhledávání a změny paměti;
- ochranná okna pro sledované oblasti paměti;
- kazetové operace a v pozdějších vydáních také podpora disků;
- relokovatelný instalační program, který uživateli dovoluje zvolit, kde bude celý systém umístěn.

Výsledek lépe vystihuje označení používané v českých popisech programu: **integrovaný ladicí systém**. Editor, assembler a monitor neleží pouze vedle sebe na jedné kazetě. Sdílejí rutiny, datové formáty i znalosti o programu.

## Proč vznikl

Původní příručka nezačíná syntaxí instrukcí, ale srovnáním vývojových systémů, které již uživatelé Spectra znali. Probírá GENS a jeho rozšíření, OCP, Laser Genius, Memory Resident System, PIKASM, MON, MON2 a VAST. Každý z nich přinášel užitečné nápady, ale každý si také vybíral svou cenu v podobě spotřeby paměti, velikosti zdrojového textu, pohodlí nebo míry propojení jednotlivých částí.

Vilím z tohoto srovnání odvozuje dva hlavní požadavky na lepší systém:

1. zdrojový text musí být uložen co nejúsporněji;
2. assembler a monitor musí tvořit jeden propojený celek.

Tyto požadavky vysvětlují značnou část kódu, kterým se tato kniha zabývá. PROMETHEUS neuchovává řádky zdrojového programu jako obyčejný text. Rozebere je do kompaktních záznamů obsahujících identifikátory mnemonik, tvary operandů, odkazy na symboly a malé úseky doslovných dat. Tabulka symbolů je součástí živé struktury zdroje, místo aby se při každém překladu znovu budovala ve velké dočasné oblasti. Monitor znovu používá služby assembleru a disassembler dokáže vytvořit tentýž druh kompaktního záznamu, jaký editor později rozvine do čitelného textu.

Nejde o kompresi přidanou jako poslední optimalizace. Je to samotná architektura programu.

Podle údajů uvedených v příručce z roku 1990 zabíral 48K systém přibližně **11 KB pro assembler s editorem a 5 KB pro monitor**. Příručka uvádí obvyklý poměr velikosti zdrojového textu k výslednému kódu přibližně **3 : 1 až 4 : 1** a rychlost překladu zhruba **2–3 KB za sekundu**. Byly to propagační údaje autora a vydavatele, nikoli měření provedená pro tuto knihu, jejich priority však popisují zcela jasně: ponechat co nejvíce prostoru uživatelovu programu a nenutit uživatele zbytečně čekat.[^predmluva-2]

## Program, který se naučil sestavovat sám sebe

PROMETHEUS má také půvabně příhodný příběh svého vzniku.

Příručka uvádí, že při jeho raném vývoji byly používány systémy **GENS3E, GENS 3.1, MON, MON2 a VAST**. GENS zůstal assemblerem až do chvíle, kdy byl odladěn první použitelný assembler PROMETHEUS. Od té doby sestavovala novější verze vždy některá starší verze PROMETHEA. Monitor byl poté od samého začátku napsán přímo v PROMETHEU.[^predmluva-3]

Jinými slovy, nástroj překročil hranici dobře známou z dějin překladačů: stal se schopným vytvořit svého vlastního nástupce.

Autor uvádí konkrétní srovnání. Zdroj v systému GENS měl údajně zabírat asi 40 KB, musel být rozdělen na dvě části a jeho sestavení trvalo kolem čtyřiceti sekund. Po převodu do kompaktní reprezentace PROMETHEA zabíral přibližně 20 KB, vešel se do paměti jako jediný zdroj a sestavil se asi za tři sekundy. Také tato čísla pocházejí z původní příručky a je třeba je chápat jako dobovou zprávu autora. Jejich význam nespočívá v přesnosti benchmarku. Podstatné je, že se PROMETHEUS sám stal ukázkovým programem pro svůj způsob ukládání zdroje a rychlost assembleru.[^predmluva-3]

## 48K systém a jeho 128K potomci

Program byl nejprve určen pro běžné prostředí 48K Spectra. Jeho distribuovaný obraz obsahuje monitor, assembler s editorem a dočasnou instalační část s relokačními informacemi. Lze nainstalovat celý vývojový systém, nebo vynechat pětitisícibajtový prefix monitoru a ponechat pouze assembler s editorem. Nainstalovaný program je relokovatelný, takže uživatel může podle potřeb právě vyvíjeného projektu měnit množství paměti dostupné pod ním nebo nad ním.

Pozdější 128K vydání rozšířilo stejné myšlenky do stránkované paměti. Dochovaný dodatek k příručce uvádí, že zdroj mohl v RAM stránkách 1, 3, 4 a 6 zabírat až 64 KB. Popisuje tři varianty: krátkou verzi zaměřenou na diskové použití, střední verzi určenou především pro vývoj 48K programů a dlouhou verzi s úplnou sadou funkcí. 128K vydání dokázalo sestavovat a trasovat kód ve stránkované paměti a spolupracovat s diskovými systémy D40/D80 a Kompakt, přičemž si zachovalo možnost relokace.[^predmluva-4]

Tato kniha však sleduje rekonstruovaný **48K program**. Je dost malý na to, aby se vešel do jediného viditelného adresního prostoru, a přitom dost složitý, aby obsahoval téměř všechny problémy, které činí starý strojový kód tak zajímavým: sbalená data, relokaci, samomodifikující operandy instrukcí, vlastní zásobníky, alternativní sady registrů, sdílené buffery, volání ROM, přímý přístup k hardwaru i debugger, který musí na chvíli převzít vládu nad jiným programem, aniž by ztratil stav kteréhokoli z nich.

## Jméno

Mytologický Prométheus ukradl oheň a přinesl jej lidem. Jméno se pro programátorský nástroj hodilo už předtím, než se kdokoli podíval do jeho binárního obrazu: assembler dává programátorovi přístup k nejpřímější a nejnebezpečnější podobě výkonu stroje.

Uvnitř kódu se toto jméno stává ještě případnějším. PROMETHEUS Spectrum neskrývá za pohodlnou abstrakci. Učí uživatele pracovat s adresami, registry, příznaky, dobami instrukcí, obrazovou pamětí, kazetovými bloky a elektrickou skutečností portu `$FE`. Monitor může chránit oblasti paměti, ale nedokáže učinit strojový kód neškodným. Původní příručka uživatele opakovaně upozorňuje, že chybná adresa nebo nebezpečně umístěný breakpoint může zničit rozpracovanou práci.

Darem je moc, nikoli bezpečí.

## Širší svět PROMETHEA

PROMETHEUS nebyl osamělou technickou kuriozitou. Vilím vytvořil pod jménem Universum a prostřednictvím Proximy i další software pro Spectrum a později napsal dvoudílnou českou knihu *Assembler a ZX Spectrum*, vydanou Proximou v roce 1992. Ukázkové zdrojové programy v těchto knihách byly připraveny pro PROMETHEUS, který se tak stal středem malého ekosystému softwaru, dokumentace a výukových materiálů.[^predmluva-5]

Archivní servery i po desetiletích uchovávají 48K a 128K kazetové obrazy, diskové obrazy, skeny příručky a katalogové záznamy. Toto přežití je důležité. Většina uživatelů poznala PROMETHEUS pouze jako neprůhledný blok strojového kódu. Vývojový zdroj se nezachoval v podobě, kterou by bylo možné jednoduše otevřít, znovu sestavit a opatřit komentáři.

Projekt vzkříšení, z něhož tato kniha vychází, proto začal u dochovaného obrazu programu. Jeho rekonstruovaný zdroj v assembleru byl opakovaně porovnáván s historickým binárním souborem a obrazem TAP, dokud je nezačal reprodukovat bajt po bajtu. Popisné labely a vysvětlující komentáře jsou moderní doplňky, ale výsledný strojový kód zůstává původním programem.

Toto rozlišení je pro následující stránky zásadní. U mnoha rutin můžeme přesně určit, co dělají. Můžeme v emulátoru pozorovat skutečně provedené cesty. Můžeme porovnávat implementaci s příručkou. Můžeme rozpoznat návrhové vzory, které se systémem opakovaně vracejí. Neměli bychom však předstírat, že každý rekonstruovaný label zvolil Tomáš Vilím nebo že se každý odvozený záměr zachoval jako doložený historický fakt.

Účelem této knihy není nahradit původní příručku ani proměnit zdroj v muzejní exponát. Jejím cílem je znovu učinit celý mechanismus čitelným.

PROMETHEUS byl praktický nástroj vytvořený pod tvrdými omezeními. Jeho komprimované záznamy, relokační proudy, syntetická volání a trasovací mechanismy nebyly hlavolamy určenými budoucím reverzním inženýrům. Byly řešením každodenního problému: jak na malém počítači vytvářet rozsáhlejší programy pro Z80.

Zdroj je spletitý, protože úkol byl ambiciózní. Stojí za přečtení, protože jeho řešení zůstávají důmyslná.

Nyní můžeme stroj otevřít a následovat oheň dovnitř.

---

## Historické prameny k této předmluvě

[^predmluva-1]: Uživatelská příručka *PROMETHEUS*, Proxima, Ústí nad Labem, 1990, titulní strana; katalogové záznamy World of Spectrum a ZXDB pro PROMETHEUS, které uvádějí Tomáše Vilíma jako autora a zachycují 48K a 128K vydání. Jméno Universum se zachovalo v českých katalogových a biografických záznamech.
[^predmluva-2]: Uživatelská příručka *PROMETHEUS*, oddíl „Trocha sebechvály aneb odkud to přišlo“, zejména dobový přehled vlastností a výkonu.
[^predmluva-3]: Tamtéž, popis vývojového procesu a přechodu od GENS k PROMETHEU schopnému sestavovat vlastní zdroj.
[^predmluva-4]: Tamtéž, „Poznámky k verzi 128“, popisující využití paměťových stránek a varianty `sht`, `mdm` a `lng`.
[^predmluva-5]: Katalogové záznamy Tomáše Vilíma a dvoudílné knihy *Assembler a ZX Spectrum* (Proxima, 1992); dochované popisy uvádějí, že její ukázkové zdrojové texty byly připraveny pro PROMETHEUS.
