# Guía de instalación — Data Driven Security 2026

**Antes de la sesión 1 (19/11/2026).** Hacen falta unos 30–40 minutos y una conexión estable (se descargan unos 36 MB de datos). Sigue los pasos **en este orden**. Si algo falla, anota el mensaje de error exacto y tráelo a clase: el ejercicio 0 existe para eso.

Repositorio de la asignatura: <https://github.com/DDS-MCSM/dds-upc-2026>

## Qué tendrás al acabar

| Pieza | Versión | Para qué |
|---|---|---|
| R | ≥ 4.4 | el lenguaje |
| RStudio Desktop | cualquiera reciente | el entorno de trabajo |
| git | cualquiera reciente | control de versiones |
| Cuenta de GitHub + repositorio personal **privado** | — | donde entregarás los ejercicios |
| Paquete `mitre`, **rama `dds-2026`** | `1.0.0.9100` | los datos de los estándares (CVE, CPE, CWE, CAPEC, ATT&CK) |

> **Cuidado con el paquete `mitre`.** El de CRAN (`install.packages("mitre")`, versión 1.0.0) **no sirve**: solo tiene 25 CVE y no contiene el caso de la asignatura. Hace falta el de la rama `dds-2026` (versión `1.0.0.9100`, datos hasta el 18/04/2025).
>
> No hace falta Rtools: `mitre` no tiene código compilado.

## 1. R (≥ 4.4)

Descárgalo de <https://cran.r-project.org/> e instálalo con las opciones por defecto.

- **Windows:** «Download R for Windows» → «base».
- **macOS:** elige el `.pkg` que corresponda a tu procesador (Apple Silicon o Intel).
- **Linux:** usa el gestor de paquetes de tu distribución o el repositorio de CRAN (<https://cloud.r-project.org/bin/linux/>); comprueba que la versión es ≥ 4.4.

Comprobación, en la consola de R:

```r
R.version.string    # tiene que decir R version 4.4.x o superior
```

## 2. RStudio

Instálalo **después de R**: <https://posit.co/download/rstudio-desktop/>. Al abrirlo tiene que encontrar R solo; si no, *Tools → Global Options → General → R version*.

Recomendado (no obligatorio): en *Tools → Global Options → General*, desmarca «Restore .RData into workspace at startup» y pon «Save workspace to .RData on exit» en *Never*. Así cada sesión empieza limpia, que es lo que usaremos en la S2.

## 3. git

Descárgalo de <https://git-scm.com/downloads> (en Windows, «Git for Windows» con las opciones por defecto). En macOS puede que ya lo tengas: abre un terminal y escribe `git --version`.

Comprobación, en un terminal:

```bash
git --version
```

Dile quién eres (una sola vez por ordenador; usa el mismo correo que en la cuenta de GitHub):

```bash
git config --global user.name "Tu Nombre"
git config --global user.email "tu@correo.ejemplo"
```

## 4. Cuenta de GitHub y repositorio personal privado

1. Si no tienes, crea una cuenta en <https://github.com/signup>. El nombre de usuario será visible para el docente: elige uno que no te dé vergüenza.
2. Crea un repositorio nuevo: *New repository*.
   - Nombre: `dds-2026-<tu-usuario>` (o el que indique el docente en clase).
   - **Private**.
   - Marca «Add a README file».
3. Clónalo en tu ordenador. En RStudio: *File → New Project → Version Control → Git*, pega la URL del repositorio (`https://github.com/<usuario>/<repo>.git`) y elige dónde guardarlo. Desde un terminal, lo mismo:

```bash
git clone https://github.com/<usuario>/<repo>.git
```

GitHub ya no acepta la contraseña para hacer `push`: pedirá un *Personal Access Token* o te hará iniciar sesión por el navegador (el *Git Credential Manager* viene con Git for Windows). Si sale un error de autenticación, es el primer sitio donde mirar; véase «Problemas conocidos».

> El docente te pedirá más adelante acceso a tu repositorio privado para poder corregir. No hace falta hacerlo ahora.

## 5. Paquete `mitre`, rama `dds-2026`

Hay **dos vías**; elige **una**. La vía 1 es la más corta; la vía 2 es por si GitHub no te deja instalar desde R (red del trabajo, *proxy*…).

### Vía 1 · Desde GitHub

```r
install.packages("remotes")
remotes::install_github("DDS-MCSM/mitre@dds-2026")
```

Guarda 36 MB en la caché de la sesión; puede tardar unos minutos.

### Vía 2 · Tarball de la *release*

1. Descarga `mitre_1.0.0.9100.tar.gz` y `SHA256SUMS` de <https://github.com/DDS-MCSM/dds-upc-2026/releases>.
2. **Comprueba la suma** antes de instalarlo. La línea de `SHA256SUMS` tiene que coincidir con lo que da tu sistema:

```bash
# Windows (PowerShell)
Get-FileHash .\mitre_1.0.0.9100.tar.gz -Algorithm SHA256

# macOS
shasum -a 256 mitre_1.0.0.9100.tar.gz

# Linux
sha256sum mitre_1.0.0.9100.tar.gz
```

3. Instala las dependencias de CRAN y el tarball (desde la carpeta donde lo has descargado):

```r
install.packages(c("plyr", "tidyr", "dplyr", "igraph", "stringr", "stringi",
                   "jsonlite", "RJSONIO", "xml2", "rlang"))
install.packages("mitre_1.0.0.9100.tar.gz", repos = NULL, type = "source")
```

### Paquetes de CRAN que usaremos en clase

Tanto si has usado la vía 1 como la 2:

```r
install.packages(c("tidyverse", "rmarkdown", "knitr"))
```

`lubridate`, `stringr`, `dplyr`, `ggplot2` y el resto vienen con `tidyverse`. En el ejercicio 0 solo hace falta `lubridate`.

## 6. Comprobación

Reinicia la sesión de R (*Session → Restart R*) y ejecuta:

```r
library(mitre)
packageVersion("mitre")                                   # 1.0.0.9100
nrow(cve.nist)                                            # 210804
c("CVE-2021-44228", "CVE-2017-5645") %in% cve.nist$cve.id # TRUE TRUE
net <- build_network(as_igraph = TRUE)
igraph::vcount(net)                                       # 1010
```

| Si sale… | Quiere decir… |
|---|---|
| `packageVersion` = `1.0.0` | Tienes el `mitre` de CRAN. Desinstálalo (`remove.packages("mitre")`), reinicia R y repite el paso 5. |
| `nrow(cve.nist)` = `25` | Lo mismo: CRAN. |
| `TRUE TRUE` | Correcto: tienes el caso. |
| Grafo de `1010` nodos | Correcto. Es el grafo de **la muestra interna** del paquete (no contiene el caso); el caso lo construiremos en la S4. |

Si las cuatro comprobaciones dan lo que toca, ya lo tienes. En clase haremos el **ejercicio 0**, que lo usa de verdad y te deja el primer *commit* hecho.

## Problemas conocidos

*(Sección pendiente: se irá rellenando a medida que la guía se pruebe en Windows, macOS y Linux.)*

---

**Tamaño y origen de los datos.** `cve.nist` es una tabla de 210.804 CVE publicados hasta el 18/04/2025. Los datos son públicos (NVD); en el aula no se te pedirá nada que no sea público. Más adelante (S3) haremos un inventario del software de tu portátil: **esos datos no salen de tu ordenador** y el repositorio de alumnos ya lo tiene previsto en el `.gitignore`.
