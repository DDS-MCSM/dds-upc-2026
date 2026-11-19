# Guia d'instal·lació — Data Driven Security 2026

**Abans de la sessió 1 (19/11/2026).** Calen uns 30–40 minuts i una connexió estable (es baixen uns 36 MB de dades). Segueix els passos **en aquest ordre**. Si alguna cosa falla, anota el missatge d'error exacte i porta'l a classe: l'exercici 0 existeix per això.

Repositori de l'assignatura: <https://github.com/DDS-MCSM/dds-upc-2026>

## Què tindràs en acabar

| Peça | Versió | Per a què |
|---|---|---|
| R | ≥ 4.4 | el llenguatge |
| RStudio Desktop | qualsevol de recent | l'entorn de treball |
| git | qualsevol de recent | control de versions |
| Compte de GitHub + repositori personal **privat** | — | on lliuraràs els exercicis |
| Paquet `mitre`, **branca `dds-2026`** | `1.0.0.9100` | les dades dels estàndards (CVE, CPE, CWE, CAPEC, ATT&CK) |

> **Compte amb el paquet `mitre`.** El de CRAN (`install.packages("mitre")`, versió 1.0.0) **no serveix**: només té 25 CVE i no conté el cas de l'assignatura. Cal el de la branca `dds-2026` (versió `1.0.0.9100`, dades fins al 18/04/2025).
>
> No cal Rtools: `mitre` no té codi compilat.

## 1. R (≥ 4.4)

Descarrega'l de <https://cran.r-project.org/> i instal·la'l amb les opcions per defecte.

- **Windows:** «Download R for Windows» → «base».
- **macOS:** tria el `.pkg` que correspongui al teu processador (Apple Silicon o Intel).
- **Linux:** usa el gestor de paquets de la teva distribució o el repositori de CRAN (<https://cloud.r-project.org/bin/linux/>); comprova que la versió és ≥ 4.4.

Comprovació, a la consola d'R:

```r
R.version.string    # ha de dir R version 4.4.x o superior
```

## 2. RStudio

Instal·la **després d'R**: <https://posit.co/download/rstudio-desktop/>. En obrir-lo ha de trobar R sol; si no, *Tools → Global Options → General → R version*.

Recomanat (no obligatori): *Tools → Global Options → General*, desmarca «Restore .RData into workspace at startup» i posa «Save workspace to .RData on exit» a *Never*. Així cada sessió comença neta, que és el que farem servir a la S2.

## 3. git

Descarrega'l de <https://git-scm.com/downloads> (a Windows, «Git for Windows» amb les opcions per defecte). A macOS pot ser que ja el tinguis: obre un terminal i escriu `git --version`.

Comprovació, en un terminal:

```bash
git --version
```

Digues-li qui ets (una sola vegada per ordinador; usa el mateix correu que al compte de GitHub):

```bash
git config --global user.name "El teu Nom"
git config --global user.email "el.teu@correu.exemple"
```

## 4. Compte de GitHub i repositori personal privat

1. Si no en tens, crea un compte a <https://github.com/signup>. El nom d'usuari serà visible per al docent: tria'n un que no et faci vergonya.
2. Crea un repositori nou: *New repository*.
   - Nom: `dds-2026-<el-teu-usuari>` (o el que indiqui el docent a classe).
   - **Private**.
   - Marca «Add a README file».
3. Clona'l al teu ordinador. A RStudio: *File → New Project → Version Control → Git*, enganxa-hi l'URL del repositori (`https://github.com/<usuari>/<repo>.git`) i tria on guardar-lo. Des d'un terminal, el mateix:

```bash
git clone https://github.com/<usuari>/<repo>.git
```

GitHub ja no accepta la contrasenya per fer `push`: demanarà un *Personal Access Token* o et farà iniciar sessió pel navegador (el *Git Credential Manager* ve amb Git for Windows). Si surt un error d'autenticació, és el primer lloc on mirar; vegeu «Problemes coneguts».

> El docent et demanarà més endavant l'accés al teu repositori privat per poder corregir. No cal fer-ho ara.

## 5. Paquet `mitre`, branca `dds-2026`

Hi ha **dues vies**; tria'n **una**. La via 1 és la més curta; la via 2 és per si GitHub no et deixa instal·lar des d'R (xarxa de la feina, *proxy*…).

### Via 1 · Des de GitHub

```r
install.packages("remotes")
remotes::install_github("DDS-MCSM/mitre@dds-2026")
```

Desa 36 MB a la memòria cau de la sessió; pot trigar uns minuts.

### Via 2 · Tarball de la *release*

1. Descarrega `mitre_1.0.0.9100.tar.gz` i `SHA256SUMS` de <https://github.com/DDS-MCSM/dds-upc-2026/releases>.
2. **Comprova la suma** abans d'instal·lar-lo. La línia de `SHA256SUMS` ha de coincidir amb el que dona el teu sistema:

```bash
# Windows (PowerShell)
Get-FileHash .\mitre_1.0.0.9100.tar.gz -Algorithm SHA256

# macOS
shasum -a 256 mitre_1.0.0.9100.tar.gz

# Linux
sha256sum mitre_1.0.0.9100.tar.gz
```

3. Instal·la les dependències de CRAN i el tarball (des de la carpeta on l'has descarregat):

```r
install.packages(c("plyr", "tidyr", "dplyr", "igraph", "stringr", "stringi",
                   "jsonlite", "RJSONIO", "xml2", "rlang"))
install.packages("mitre_1.0.0.9100.tar.gz", repos = NULL, type = "source")
```

### Paquets de CRAN que farem servir a classe

Tant si has usat la via 1 com la 2:

```r
install.packages(c("tidyverse", "rmarkdown", "knitr"))
```

`lubridate`, `stringr`, `dplyr`, `ggplot2` i la resta vénen amb `tidyverse`. A l'exercici 0 només cal `lubridate`.

## 6. Comprovació

Reinicia la sessió d'R (*Session → Restart R*) i executa:

```r
library(mitre)
packageVersion("mitre")                                   # 1.0.0.9100
nrow(cve.nist)                                            # 210804
c("CVE-2021-44228", "CVE-2017-5645") %in% cve.nist$cve.id # TRUE TRUE
net <- build_network(as_igraph = TRUE)
igraph::vcount(net)                                       # 1010
```

| Si surt… | Vol dir… |
|---|---|
| `packageVersion` = `1.0.0` | Tens el `mitre` de CRAN. Desinstal·la'l (`remove.packages("mitre")`), reinicia R i repeteix el pas 5. |
| `nrow(cve.nist)` = `25` | El mateix: CRAN. |
| `TRUE TRUE` | Correcte: tens el cas. |
| Graf de `1010` nodes | Correcte. És el graf de **la mostra interna** del paquet (no conté el cas); el cas el construirem a la S4. |

Si les quatre comprovacions donen el que toca, ja ho tens. A classe farem l'**exercici 0**, que ho fa servir de debò i et deixa el primer *commit* fet.

## Problemes coneguts

*(Secció pendent: s'omplirà a mesura que la guia es provi en Windows, macOS i Linux.)*

---

**Mida i origen de les dades.** `cve.nist` és una taula de 210.804 CVE publicats fins al 18/04/2025. Les dades són públiques (NVD); a l'aula no se't demanarà res que no sigui públic. Més endavant (S3) farem un inventari del programari del teu portàtil: **aquelles dades no surten del teu ordinador** i el repositori d'alumnes ja ho té previst al `.gitignore`.
