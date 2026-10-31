# Exercici 0 — Entorn verificat i primera consulta

**Sessió 1 · Individual · 40 min a classe (20:20–21:00)**
**Lliurable:** un script `.R` de 10 línies i la sortida de `sessionInfo()` al teu repositori personal, amb un *commit*. **No s'avalua**: serveix per detectar problemes d'entorn abans de la S2.

## Què has de fer

1. Verificar l'entorn (R, RStudio, git, `mitre` de la branca `dds-2026`).
2. Tenir el repositori personal privat clonat i funcionant.
3. Escriure un script `.R` de **10 línies** que faci la teva primera consulta sobre `cve.nist` i la guardi al repositori.
4. Fer-ne el *commit* i el *push*.

## Punt de partida

Guia d'instal·lació: [`01-S1/guia-instalacio.md`](../guia-instalacio.md), en aquest mateix repositori. Hauria d'estar feta abans de classe; si no ho està, és el moment de saber per què.

Comprova-ho abans de res:

```r
packageVersion("mitre")   # 1.0.0.9100
nrow(mitre::cve.nist)     # 210804
```

Si et surt `1.0.0` o una taula de 25 files, tens el paquet de CRAN: desinstal·la'l (`remove.packages("mitre")`) i torna al pas 5 de la guia. Si no surt res o dona error, avisa el docent **ara**, no a la S2.

## L'script

Desa'l al repositori personal com a `ex0.R`. Ha de contenir, amb comentaris, **cinc coses** (pots fer-ho en menys o més de 10 línies, però no gaires més):

| # | Què | Pista |
|---|---|---|
| 1 | Carregar el paquet | `library(mitre)` |
| 2 | Quantes files té `cve.nist` | `nrow(cve.nist)` |
| 3 | Veure els primers identificadors | `head(cve.nist$cve.id)` |
| 4 | **Quants CVE hi ha per any de publicació** | `lubridate::year(cve.nist$published.date)` i `table()` |
| 5 | Escriure el resultat | `print()` de la taula i, si vols, un `barplot()` |

Exemple de l'esquelet (completa'l tu):

```r
library(mitre)
nrow(cve.nist)
head(cve.nist$cve.id)
any <- lubridate::year(cve.nist$published.date)
table(any)
```

Prova-ho a la consola, línia per línia, abans de desar-ho. Mira també quines columnes té la taula: `names(cve.nist)` (la taula no té pàgina d'ajuda, `?cve.nist` no hi serveix).

> **Dues coses que veuràs:** (1) hi ha 3 CVE sense data de publicació, que `table()` ignora; (2) la taula té poquíssims CVE abans del 2017. Fixa-t'hi, que és de què parlarem a la posada en comú.
>
> L'any pot canviar en uns pocs CVE segons la zona horària del teu ordinador (`published.date` és un instant en el temps, no una data). No és un error teu; és el primer exemple del que veurem a la S2.

## Lliurament

1. Desa `ex0.R` a la carpeta del teu repositori clonat.
2. A la consola d'R, desa la teva sessió:

```r
writeLines(capture.output(sessionInfo()), "ex0-sessioninfo.txt")
```

3. Fes el *commit* i el *push*, des de RStudio (pestanya *Git*: marca els fitxers, *Commit*, *Push*) o des del terminal:

```bash
git add ex0.R ex0-sessioninfo.txt
git commit -m "Exercici 0: entorn verificat i primera consulta a cve.nist"
git push
```

4. Obre el repositori al navegador (`github.com/<usuari>/<repo>`) i comprova que hi veus els dos fitxers i el *commit*.

## Com es valida

| Comprovació | Com |
|---|---|
| El paquet és el bo | `ex0-sessioninfo.txt` diu `mitre_1.0.0.9100` |
| L'script funciona de zero | Reinicia R (*Session → Restart R*), executa-ho tot: sense errors |
| El repositori és personal i privat | GitHub mostra el cadenat a «Private» |
| El *commit* hi és | `git log --oneline` mostra el teu missatge, i el veus a GitHub |

## Criteris

**No s'avalua.** El docent només mira, abans de la S2, si cada alumne té l'entorn funcionant i un *commit* al repositori; qui no ho tingui rebrà ajuda individual.

| Criteri | Pes |
|---|---|
| Entorn verificat, `mitre` `1.0.0.9100` | sense nota (requisit per a la S2) |
| Script de 10 línies amb la taula de CVE per any | sense nota |
| *Commit* i *push* al repositori personal | sense nota (requisit per a la S2) |
