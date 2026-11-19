# Installation guide — Data Driven Security 2026

**Before session 1 (19 Nov 2026).** You need about 30–40 minutes and a stable connection (around 36 MB of data are downloaded). Follow the steps **in this order**. If something fails, write down the exact error message and bring it to class: Exercise 0 exists for that.

Course repository: <https://github.com/DDS-MCSM/dds-upc-2026>

## What you will have at the end

| Piece | Version | What for |
|---|---|---|
| R | ≥ 4.4 | the language |
| RStudio Desktop | any recent one | the working environment |
| git | any recent one | version control |
| GitHub account + **private** personal repository | — | where you will submit the exercises |
| `mitre` package, **`dds-2026` branch** | `1.0.0.9100` | the standards data (CVE, CPE, CWE, CAPEC, ATT&CK) |

> **Careful with the `mitre` package.** The CRAN one (`install.packages("mitre")`, version 1.0.0) **is no good**: it only has 25 CVEs and does not contain the course case. You need the one from the `dds-2026` branch (version `1.0.0.9100`, data up to 18 April 2025).
>
> Rtools is not needed: `mitre` has no compiled code.

## 1. R (≥ 4.4)

Download it from <https://cran.r-project.org/> and install it with the default options.

- **Windows:** "Download R for Windows" → "base".
- **macOS:** pick the `.pkg` that matches your processor (Apple Silicon or Intel).
- **Linux:** use your distribution's package manager or the CRAN repository (<https://cloud.r-project.org/bin/linux/>); check that the version is ≥ 4.4.

Check, in the R console:

```r
R.version.string    # must say R version 4.4.x or higher
```

## 2. RStudio

Install it **after R**: <https://posit.co/download/rstudio-desktop/>. When you open it, it should find R by itself; if not, *Tools → Global Options → General → R version*.

Recommended (not mandatory): in *Tools → Global Options → General*, untick "Restore .RData into workspace at startup" and set "Save workspace to .RData on exit" to *Never*. That way every session starts clean, which is what we will rely on in S2.

## 3. git

Download it from <https://git-scm.com/downloads> (on Windows, "Git for Windows" with the default options). On macOS you may already have it: open a terminal and type `git --version`.

Check, in a terminal:

```bash
git --version
```

Tell it who you are (once per computer; use the same e-mail as in your GitHub account):

```bash
git config --global user.name "Your Name"
git config --global user.email "your@email.example"
```

## 4. GitHub account and private personal repository

1. If you do not have one, create an account at <https://github.com/signup>. Your username will be visible to the lecturer: pick one you are comfortable with.
2. Create a new repository: *New repository*.
   - Name: `dds-2026-<your-username>` (or whatever the lecturer says in class).
   - **Private**.
   - Tick "Add a README file".
3. Clone it to your computer. In RStudio: *File → New Project → Version Control → Git*, paste the repository URL (`https://github.com/<user>/<repo>.git`) and choose where to keep it. From a terminal, the same thing:

```bash
git clone https://github.com/<user>/<repo>.git
```

GitHub no longer accepts your password for `push`: it will ask for a *Personal Access Token* or make you sign in through the browser (the *Git Credential Manager* ships with Git for Windows). If you get an authentication error, that is the first place to look; see "Known issues".

> Later on the lecturer will ask you for access to your private repository in order to mark your work. You do not need to do it now.

## 5. `mitre` package, `dds-2026` branch

There are **two routes**; pick **one**. Route 1 is the shortest; route 2 is for when GitHub will not let you install from R (work network, *proxy*…).

### Route 1 · From GitHub

```r
install.packages("remotes")
remotes::install_github("DDS-MCSM/mitre@dds-2026")
```

It saves 36 MB to the session cache; it may take a few minutes.

### Route 2 · *Release* tarball

1. Download `mitre_1.0.0.9100.tar.gz` and `SHA256SUMS` from <https://github.com/DDS-MCSM/dds-upc-2026/releases>.
2. **Check the checksum** before installing it. The line in `SHA256SUMS` must match what your system returns:

```bash
# Windows (PowerShell)
Get-FileHash .\mitre_1.0.0.9100.tar.gz -Algorithm SHA256

# macOS
shasum -a 256 mitre_1.0.0.9100.tar.gz

# Linux
sha256sum mitre_1.0.0.9100.tar.gz
```

3. Install the CRAN dependencies and the tarball (from the folder where you downloaded it):

```r
install.packages(c("plyr", "tidyr", "dplyr", "igraph", "stringr", "stringi",
                   "jsonlite", "RJSONIO", "xml2", "rlang"))
install.packages("mitre_1.0.0.9100.tar.gz", repos = NULL, type = "source")
```

### CRAN packages we will use in class

Whether you took route 1 or route 2:

```r
install.packages(c("tidyverse", "rmarkdown", "knitr"))
```

`lubridate`, `stringr`, `dplyr`, `ggplot2` and the rest come with `tidyverse`. Exercise 0 only needs `lubridate`.

## 6. Check

Restart the R session (*Session → Restart R*) and run:

```r
library(mitre)
packageVersion("mitre")                                   # 1.0.0.9100
nrow(cve.nist)                                            # 210804
c("CVE-2021-44228", "CVE-2017-5645") %in% cve.nist$cve.id # TRUE TRUE
net <- build_network(as_igraph = TRUE)
igraph::vcount(net)                                       # 1010
```

| If you get… | It means… |
|---|---|
| `packageVersion` = `1.0.0` | You have the CRAN `mitre`. Uninstall it (`remove.packages("mitre")`), restart R and repeat step 5. |
| `nrow(cve.nist)` = `25` | Same thing: CRAN. |
| `TRUE TRUE` | Correct: you have the case. |
| A graph with `1010` nodes | Correct. It is the graph of the package's **internal sample** (it does not contain the case); we will build the case in S4. |

If all four checks return what they should, you are done. In class we will do **Exercise 0**, which puts it to real use and leaves you with your first *commit*.

## Known issues

*(Section pending: it will be filled in as the guide is tested on Windows, macOS and Linux.)*

---

**Size and origin of the data.** `cve.nist` is a table of 210,804 CVEs published up to 18 April 2025. The data is public (NVD); in class you will not be asked for anything that is not public. Later on (S3) we will build an inventory of the software on your laptop: **that data does not leave your computer**, and the student repository already provides for it in its `.gitignore`.
