# Exercici 3 — Exploració visual del cas

**Sessió 4 · Per equip (3–4 persones) · 20 min a classe, la resta a casa**
**Lliurable:** un fitxer `.Rmd` i el seu `.html` al repo de l'equip, amb un `commit` que els contingui. Es lliura el mateix dia que el pont (09/12, 23:59).

## Què has de fer

Mirar el cas del curs amb **gràfics**, no amb taules. Parteixes de l'exercici 2b: el cas (Log4Shell i el CVE de control) i el recompte de plataformes ja els tens; **no els refacis**, reutilitza'ls. Després fas **almenys tres gràfics amb `ggplot2`** sobre `cve.nist` i els interpretes.

L'informe ha de teixir-se (`knit`) d'una sola passada, des d'una sessió d'R nova, com als exercicis 1 i 2.

## Punt de partida

- Plantilla de l'assignatura (`templates/dds-template.Rmd`) i `mitre` de la branca `dds-2026` (`packageVersion("mitre")` ha de donar `1.0.0.9100`). Paquets: `tidyverse` (porta `ggplot2`, `dplyr`, `tidyr`, `stringr`) i `lubridate`.
- **La taula del cas del 2b.** Copia al teu `.Rmd` els *chunks* `cas` i `plataformes` de l'exercici 2b (filtrar `cve.nist` a `CVE-2021-44228` i `CVE-2017-5645`, i comptar les entrades `apache:log4j` amb `str_count()`). És el punt d'entrada: aquí no es refà.
- **Columnes que faràs servir** (totes són a `cve.nist`):

  | Columna | Contingut |
  |---|---|
  | `cvss3.score` | nota CVSS v3 (0–10); `NA` si el CVE no en té |
  | `cvss3.vector` | el vector de la nota (`CVSS:3.1/AV:N/AC:L/…`); és a la S4 i al pont, aquí és opcional |
  | `published.date` | data i hora de publicació (zona horària: converteix-la a UTC, com a la S2) |
  | `description` | text de la descripció |
  | `problem.type` | cadena amb els CWE (`["CWE-20","CWE-400","CWE-502"]`) |

## Els gràfics

Tres gràfics, un per cada pregunta. Cadascun amb **títol, etiquetes d'eix amb unitats** i el tipus de gràfic que correspon al tipus de variable (una quantitativa: histograma; una quantitativa per categories: diagrama de caixa; el temps a l'eix X: punts o línia).

1. **El CVSS de Log4Shell contra la distribució global.** Distribució de `cvss3.score` de tots els CVE amb nota, amb el lloc dels dos CVE del cas marcat. Treu els `NA` i explica en una frase quants en són.
2. **Els CVE que comparteixen CWE amb el cas.** Passa `problem.type` a una fila per parella CVE–CWE (la mateixa expressió regular del 2b i `tidyr::unnest_longer()`), queda't amb els CWE de Log4Shell i mira la nota CVSS dels CVE de **cada** CWE, amb els dos CVE del cas ressaltats.
3. **La línia temporal dels CVE que parlen de `log4j`.** Filtra `description` amb `grepl("log4j", description, ignore.case = TRUE)` i dibuixa'ls per data de publicació, amb la nota a l'eix Y i els dos CVE del cas etiquetats.

*Un quart gràfic és opcional* (no suma punts, però el docent el llegirà): per exemple, el mateix gràfic 3 amb color segons si la configuració vulnerable porta `apache:log4j` (el recompte del 2b aplicat a tots els CVE del filtre).

## Preguntes que has de respondre al text

Una frase per gràfic, en dues parts: **què es veu** i **què no es pot concloure**. Totes les xifres, amb codi en línia (cap número escrit a mà).

- Gràfic 1: quants CVE tenen exactament la nota de Log4Shell, i quin % dels CVE amb nota tenen 9,0 o més?
- Gràfic 2: quants CVE comparteixen almenys un CWE amb Log4Shell? Quants en comparteixen els tres?
- Gràfic 3: quants CVE mencionen `log4j`? Quants es publiquen entre desembre de 2021 i gener de 2022? Hi són tots perquè afecten Log4j?
- *Un gràfic en suggereix tres de noves.* Escriu **una** pregunta que el gràfic que més t'ha sorprès et deixi oberta.

## Què porta el lliurable

| Apartat | Contingut |
|---|---|
| Entrada | Els *chunks* `cas` i `plataformes` del 2b, reutilitzats |
| Gràfics | Els tres (o quatre) gràfics, amb el codi visible (`echo = TRUE`) |
| Text | Les respostes de dalt, amb limitacions honestes |
| Procedència | `sessionInfo()` amb la versió de `mitre` i de `ggplot2` |

## Com es valida

1. Tanca RStudio, obre'l de nou, **Knit**. Si falla o canvia el resultat, no és reproduïble.
2. Algú altre de l'equip ha de poder fer el mateix amb el repo i obtenir el mateix HTML llevat de la data.
3. Cada gràfic s'entén **sense llegir el codi**: títol, eixos amb unitats, llegenda si hi ha color.

## Criteris

| Criteri | Pes |
|---|---|
| Teixeix sense errors des d'una sessió nova | 20 % |
| Gràfic 1 · CVSS del cas contra la distribució: geom adequat, `NA` tractats, casos marcats, títol i eixos | 15 % |
| Gràfic 2 · CVE amb els mateixos CWE: dades en files tidy, un grup per CWE, casos ressaltats | 15 % |
| Gràfic 3 · Línia temporal dels CVE de `log4j`: data en UTC, casos etiquetats, filtre per text correcte | 15 % |
| Entrada: reutilitza la taula del cas del 2b (no la refà) | 10 % |
| Lectura: per gràfic, què es veu i què no es pot concloure; xifres amb codi en línia | 15 % |
| Reproduïbilitat i versionat: sense rutes absolutes ni xifres escrites a mà, amb `commit` | 10 % |

Pot formar part d'una pràctica si l'avaluació ho preveu: el pes dins l'avaluació s'anunciarà a classe. Aquest lliurable continua el 2b i prepara el pont.
