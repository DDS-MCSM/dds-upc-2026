# Ejercicio 0 — Entorno verificado y primera consulta

**Sesión 1 · Individual · 40 min en clase (20:20–21:00)**
**Entregable:** un script `.R` de 10 líneas y la salida de `sessionInfo()` en tu repositorio personal, con un *commit*. **No se evalúa**: sirve para detectar problemas de entorno antes de la S2.

## Qué tienes que hacer

1. Verificar el entorno (R, RStudio, git, `mitre` de la rama `dds-2026`).
2. Tener el repositorio personal privado clonado y funcionando.
3. Escribir un script `.R` de **10 líneas** que haga tu primera consulta sobre `cve.nist` y guardarlo en el repositorio.
4. Hacer el *commit* y el *push*.

## Punto de partida

Guía de instalación: [`01-S1/guia-instalacio.es.md`](../guia-instalacio.es.md), en este mismo repositorio. Debería estar hecha antes de clase; si no lo está, es el momento de saber por qué.

Compruébalo antes de nada:

```r
packageVersion("mitre")   # 1.0.0.9100
nrow(mitre::cve.nist)     # 210804
```

Si te sale `1.0.0` o una tabla de 25 filas, tienes el paquete de CRAN: desinstálalo (`remove.packages("mitre")`) y vuelve al paso 5 de la guía. Si no sale nada o da error, avisa al docente **ahora**, no en la S2.

## El script

Guárdalo en el repositorio personal como `ex0.R`. Tiene que contener, con comentarios, **cinco cosas** (puedes hacerlo en menos o más de 10 líneas, pero no muchas más):

| # | Qué | Pista |
|---|---|---|
| 1 | Cargar el paquete | `library(mitre)` |
| 2 | Cuántas filas tiene `cve.nist` | `nrow(cve.nist)` |
| 3 | Ver los primeros identificadores | `head(cve.nist$cve.id)` |
| 4 | **Cuántos CVE hay por año de publicación** | `lubridate::year(cve.nist$published.date)` y `table()` |
| 5 | Escribir el resultado | `print()` de la tabla y, si quieres, un `barplot()` |

Ejemplo del esqueleto (complétalo tú):

```r
library(mitre)
nrow(cve.nist)
head(cve.nist$cve.id)
any <- lubridate::year(cve.nist$published.date)
table(any)
```

Pruébalo en la consola, línea a línea, antes de guardarlo. Mira también qué columnas tiene la tabla: `names(cve.nist)` (la tabla no tiene página de ayuda, `?cve.nist` no sirve). En el esqueleto, `any` es solo el nombre de una variable: es «año» en catalán.

> **Dos cosas que verás:** (1) hay 3 CVE sin fecha de publicación, que `table()` ignora; (2) la tabla tiene poquísimos CVE antes de 2017. Fíjate, que es de lo que hablaremos en la puesta en común.
>
> El año puede cambiar en unos pocos CVE según la zona horaria de tu ordenador (`published.date` es un instante en el tiempo, no una fecha). No es un error tuyo; es el primer ejemplo de lo que veremos en la S2.

## Entrega

1. Guarda `ex0.R` en la carpeta de tu repositorio clonado.
2. En la consola de R, guarda tu sesión:

```r
writeLines(capture.output(sessionInfo()), "ex0-sessioninfo.txt")
```

3. Haz el *commit* y el *push*, desde RStudio (pestaña *Git*: marca los ficheros, *Commit*, *Push*) o desde el terminal:

```bash
git add ex0.R ex0-sessioninfo.txt
git commit -m "Ejercicio 0: entorno verificado y primera consulta a cve.nist"
git push
```

4. Abre el repositorio en el navegador (`github.com/<usuario>/<repo>`) y comprueba que ves los dos ficheros y el *commit*.

## Cómo se valida

| Comprobación | Cómo |
|---|---|
| El paquete es el bueno | `ex0-sessioninfo.txt` dice `mitre_1.0.0.9100` |
| El script funciona desde cero | Reinicia R (*Session → Restart R*), ejecútalo todo: sin errores |
| El repositorio es personal y privado | GitHub muestra el candado en «Private» |
| El *commit* está | `git log --oneline` muestra tu mensaje, y lo ves en GitHub |

## Criterios

**No se evalúa.** El docente solo mira, antes de la S2, si cada alumno tiene el entorno funcionando y un *commit* en el repositorio; quien no lo tenga recibirá ayuda individual.

| Criterio | Peso |
|---|---|
| Entorno verificado, `mitre` `1.0.0.9100` | sin nota (requisito para la S2) |
| Script de 10 líneas con la tabla de CVE por año | sin nota |
| *Commit* y *push* al repositorio personal | sin nota (requisito para la S2) |
