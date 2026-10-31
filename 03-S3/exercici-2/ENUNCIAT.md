# Exercici 2 — L'inventari i el cas

**Sessió 3 · 2a individual, 2b per equip (3–4 persones) · 2a: 25 min a classe · 2b: 30 min a classe, la resta a casa**
**Lliurable:** un fitxer `.Rmd` i el seu `.html` al teu repo personal, amb un `commit` que els contingui.

## Què has de fer

Dues feines amb dades diferents i una conclusió comuna:

- **2a (individual).** Convertir l'inventari de programari del teu portàtil (un JSON) en un data frame **tidy**.
- **2b (per equip).** Descriure Log4Shell i el seu CVE de control amb les dades de `mitre`, i després **casar el teu inventari amb els CPE** i mesurar quant en queda sense casar.

L'informe ha de teixir-se (`knit`) d'una sola passada, des d'una sessió d'R nova, com a l'exercici 1.

## Punt de partida

- Plantilla de l'assignatura (`templates/dds-template.Rmd`) i `mitre` de la branca `dds-2026` (`packageVersion("mitre")` ha de donar `1.0.0.9100`). El mateix kit de l'exercici 1.
- Paquets: `jsonlite`, `tidyr`, `dplyr`, `stringr` (tot això ve amb `tidyverse`, més `jsonlite`).
- **L'inventari.** Dues opcions:
  1. **El teu inventari (recomanat):** executa `03-S3/tools/collect-software.ps1` al teu portàtil Windows abans de classe. Les instruccions, què recull i què no, i la regla de privadesa són a [`03-S3/tools/README.md`](../tools/README.md). Resultat: `outputs\raw-software.json`.
  2. **La mostra anònima** (82 programes d'un PC Windows): `03-S3/tools/data-sample/inventory-sample.json`. És la via si tens macOS o Linux, o no vols executar res.

**Regla: el JSON no es puja enlloc.** L'inventari és un perfil de la teva màquina i de tu. El fitxer es queda al teu portàtil (el `.gitignore` l'exclou). Al lliurable només hi van **agregats** (recomptes, percentatges) i **una mostra de 20 files triades per tu**; mai els títols crus sencers.

Posa la ruta de l'inventari en un paràmetre del YAML (`params: inventari: ...`) i fes-la **relativa**: així canviar de la mostra al teu inventari és canviar una línia, i el projecte continua portable (cap `C:\...`, cap `setwd()`).

## 2a — De l'inventari a un data frame tidy

El JSON té cinc blocs: `CollectedAt`, `Tools` (eines de línia d'ordres), `Appx` (paquets de la Store), `Programs` (programes instal·lats) i `Errors`. Llegeix-lo amb `jsonlite::fromJSON()`.

1. **Una fila per programa.** Ajunta `Programs` i `Appx` en **un sol** data frame amb aquestes columnes:

   | Columna | Contingut |
   |---|---|
   | `vendor` | l'editor, de `Publisher`, net |
   | `product` | el nom, de `DisplayName` (o `Name` a `Appx`), net de versió i d'arquitectura |
   | `version` | `DisplayVersion` (o `Version`) |
   | `source` | `programs` o `appx` |

   Pistes: `Tools` no hi entra. A `Appx` l'editor és un certificat (`CN=…, O=…, L=…`): `tidyr::extract()` o una expressió regular hi treuen l'organització. `tidyr::unnest()` serveix per apilar dues taules.
2. **Neteja.** `product` no ha de portar la versió (`7-Zip 26.05 (x64 edition)` → `7-zip`) ni l'arquitectura (`x64`, `64-bit`). Escriu les regles com a funcions i digues al text quines són.
3. **Els casos difícils es queden.** Tot camp pot ser `null` (`NA` a R): no s'esborren files ni s'inventen valors. `Errors` pot venir buit i no és cap problema.
4. **Descriu el resultat** amb tres xifres (totes amb codi en línia): quantes files, quantes de cada `source`, quantes amb `vendor` o `version` a `NA`.

Amb l'inventari propi el resultat és **el mateix format** que amb la mostra: les mateixes quatre columnes.

## 2b — El cas i el casament amb CPE

### El cas (Log4Shell i el control)

Filtra `cve.nist` a `CVE-2021-44228` i `CVE-2017-5645`.

1. **CWE.** Extreu-los de `problem.type` amb `stringr::str_extract_all(problem.type, "CWE-\\d+")`; deixa **una fila per parella CVE–CWE** (`tidyr::unnest_longer()`) i afegeix el nom de cada CWE des de `mitre::cwe.weaknesses`.
2. **Plataformes.** Compta les entrades `apache:log4j` de cada CVE amb `str_count(vulnerable.configuration, "cpe:2.3:a:apache:log4j")`. **No parsegis el JSON**: Log4Shell en té uns 49 KB, i comptar la cadena és prou. Explica en una frase què compta realment aquest número.
3. **Gravetat.** CVSS v3 (`cvss3.score`, `cvss3.severity`).
4. **Taula del cas:** CVE, CWE, plataformes (`apache:log4j`) i CVSS, amb `knitr::kable()`.

### L'inventari i `cpe.nist`

`cpe.nist` té 1,39 milions de files (una per versió) i ocupa uns 400 MB a memòria. **No hi facis el join directament.**

1. Redueix-la a parells únics: `distinct(cpe.nist, vendor, product)` (uns 140.000).
2. Escriu `vendor` i `product` de l'inventari com ho fa CPE (minúscules, guions baixos) i fes un `left_join` de l'inventari de 2a amb aquests parells.
3. Calcula el **% de files casades** (les que tenen parell a CPE) i, a part, el % de files on **almenys el vendor** existeix a CPE.
4. **Un resultat on la majoria de files queden a `NA` és l'esperat.** No és un error: és el punt de partida de la S6. Aquí es tracta de **mesurar-ho i explicar-ho**, no d'arreglar-ho.

## Preguntes que has de respondre al text

- Quants CWE cita cada CVE del cas? Quin és comú? (Xifres amb codi en línia.)
- Quantes entrades `apache:log4j` té cada CVE, i per què no vol dir «quants productes vulnerables»?
- Quin % de les files de l'inventari casen amb un parell *vendor-product* de CPE, i quin % tenen almenys el vendor a CPE? Què et diu la diferència?
- Dóna **tres motius concrets**, amb exemples del teu inventari, pels quals un títol no casa.
- *De qui és aquest inventari?* Què en diu de tu i què en pots publicar? (Dues frases.)

## Què porta el lliurable

| Apartat | Contingut |
|---|---|
| (a) | El data frame tidy: **estructura** (`str()` o `glimpse()`), recomptes i una **mostra de 20 files triades per tu** (amb una línia de per què les has triades). Cap taula amb tot l'inventari |
| (b) | La taula del cas (CVE, CWE amb nom, plataformes, CVSS) i el % de files casades amb CPE |
| Text | Les respostes de dalt, amb limitacions honestes |
| Procedència | `sessionInfo()` amb la versió de `mitre`; `params$inventari` sense ruta absoluta |

El lliurable **no inclou** els títols crus de l'inventari, ni el JSON, ni el nom d'usuari o de la màquina.

## Les regles de privadesa, aplicades

| Regla | Comprovació |
|---|---|
| El JSON no es puja | `git status` no mostra `outputs/` ni cap `.json` d'inventari |
| Només agregats i 20 files triades | Cap `print(inventari)` ni taula sencera al `.html` |
| Cap ruta absoluta | `params$inventari` és relatiu; cap ruta d'unitat de disc ni de carpeta d'usuari al text |

## Com es valida

1. Tanca RStudio, obre'l de nou, **Knit**. Si falla o canvia el resultat, no és reproduïble.
2. Canvia `params$inventari` de la mostra al teu JSON (o a l'inrevés): l'informe ha de teixir igual, amb altres xifres.
3. Algú altre ha de poder fer el mateix amb el teu repo (amb la mostra, que és pública) i obtenir el mateix HTML llevat de la data.

## Criteris

| Criteri | Pes |
|---|---|
| Teixeix sense errors des d'una sessió nova, amb la mostra i amb l'inventari propi | 20 % |
| 2a · Data frame tidy: una fila per programa, quatre columnes, `source`, neteja amb regles escrites | 25 % |
| 2b · Taula del cas correcta: CWE amb nom, plataformes `apache:log4j`, CVSS | 20 % |
| 2b · Casament amb CPE: join contra parells únics, % de files casades i diagnòstic | 15 % |
| Interpretació: per què casen tan poques i què diu l'inventari de tu | 10 % |
| Privadesa i versionat: sense JSON ni títols crus, sense rutes absolutes, amb `commit` | 10 % |

Pot formar part d'una pràctica si l'avaluació ho preveu: el pes dins l'avaluació s'anunciarà a classe. Aquest lliurable és l'entrada de la S4 i del pont.
