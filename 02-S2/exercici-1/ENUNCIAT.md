# Exercici 1 — El teu primer informe reproduïble

**Sessió 2 · Individual · 90 min (1a: 15 min a classe, 1b: 30 min a classe, la resta a casa)**
**Lliurable:** un fitxer `.Rmd` i el seu `.html` al teu repo personal, amb un `commit` que els contingui.

## Què has de fer

Construeix un informe en R Markdown que respongui, amb dades reals de vulnerabilitats, tres preguntes. L'informe ha de teixir-se (`knit`) a HTML **d'una sola passada**, sense tocar res a mà, des d'una sessió d'R nova.

## Punt de partida

Fes servir la plantilla de l'assignatura (`templates/dds-template.Rmd`; còpia al teu repo). Les dades són la taula `cve.nist` del paquet `mitre`, branca `dds-2026` (versió `1.0.0.9100`; **no** la de CRAN). Instal·lació i comprovació: la guia d'instal·lació de [`01-S1`](../../01-S1/guia-instalacio.md).

Comprova-ho abans de res:

```r
packageVersion("mitre")   # 1.0.0.9100
nrow(mitre::cve.nist)     # 210804
```

Si et surt `1.0.0` o una taula amb 25 files, tens el paquet de CRAN: desinstal·la'l i segueix el kit.

## 1a — Histograma de la gravetat (CVSS v3)

El README de `mitre` mostra l'exemple mínim:

```r
hist(mitre::cve.nist$cvss3.score)
```

1. Posa'l en un *chunk* de l'informe i teixeix-lo. Ha de funcionar tal qual.
2. Millora'l: títol, noms d'eixos en anglès o català (tria'n un i mantén-lo), amplada de barra raonada (`breaks` o `binwidth`).
3. Escriu **dues frases** que interpretin la forma de la distribució. Les xifres que hi citis (quants CVE hi ha al gràfic, quants s'han exclòs) han de venir de **codi en línia** (`` `r ...` ``), no d'haver-les copiat a mà.

> Pista: no tots els CVE tenen puntuació v3. Mira què fa el gràfic amb els que no en tenen i digues-ho al text.

## 1b — Ampliació: CVE per any i CWE més freqüents

1. **CVE per any de publicació.** Treu l'any de `published.date` amb `lubridate::year()` i compta quants CVE hi ha cada any. Mostra'ls en un gràfic i en una taula.
2. **Top 10 de CWE.** La columna `problem.type` és una cadena de text amb format JSON, per exemple `["CWE-20","CWE-400","CWE-502"]`. Extreu-ne els identificadors amb `stringr::str_extract_all(cve.nist$problem.type, "CWE-\\d+")`, desa'ls en un sol vector i compta'ls amb `table()`. Mostra els deu més freqüents en una taula amb `knitr::kable()` (amb el nom de cada CWE: el trobaràs a `mitre::cwe.weaknesses`).
3. **El cas.** Cerca a `cve.nist` els dos CVE del cas del curs (`CVE-2021-44228` i `CVE-2017-5645`) i mostra'n el `cve.id`, el `problem.type` i la puntuació v3 en una taula.
4. **Limitacions.** Escriu tres punts sobre què **no** et diu aquest informe (vegeu les preguntes de sota).

## Preguntes que has de respondre al text

- Quants CVE tens en total, quants tenen puntuació v3 i quants tenen almenys un CWE? (Tres xifres, totes amb codi en línia.)
- El 2025 té menys CVE que el 2024. Vol dir que hi ha menys vulnerabilitats? Què diu `max(published.date)`?
- Mira els anys anteriors al 2017. Et sembla que la xifra descriu la realitat o el *sample*? Com ho podries comprovar?
- Els CWE que has comptat, són CWE per **CVE** o per **menció**? Quina diferència fa?

## Les quatre regles, aplicades

Abans de lliurar, comprova que el teu informe les compleix:

| Regla | Comprovació |
|---|---|
| Projecte portable | Cap ruta absoluta (`C:\...`); cap `setwd()`. |
| Cap manipulació manual de dades | Cap número copiat de la consola al text; res d'Excel pel mig. |
| Resultats connectats amb el text | Cada xifra del text és codi en línia. |
| Control de versions | `git log` mostra el `.Rmd` i el `.html` en un `commit`. |

## Com es valida

1. Tanca RStudio, obre'l de nou, **Knit**. Si falla o canvia el resultat, no és reproduïble.
2. Algú altre (el docent, un company) ha de poder fer el mateix amb el teu repo i obtenir el mateix HTML llevat de la data.
3. La secció *Procedència* (`sessionInfo()`) ha de dir la versió de `mitre`.

## Criteris

| Criteri | Pes |
|---|---|
| Teixeix sense errors des d'una sessió nova | 30 % |
| ≥ 1 gràfic i ≥ 1 taula sobre `cve.nist`, correctes | 25 % |
| Xifres del text connectades amb el codi | 20 % |
| Interpretació i limitacions honestes | 15 % |
| Versionat a git, sense rutes absolutes | 10 % |

El pes d'aquest exercici dins l'avaluació de l'assignatura s'anunciarà a classe.
