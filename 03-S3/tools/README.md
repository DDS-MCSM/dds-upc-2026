# Eines d'inventari de programari (S3, exercici 2a)

Per a l'exercici 2a de la S3 necessites un **inventari del programari del teu portàtil** en format JSON. Aquesta carpeta té tot el que cal:

| Fitxer | Què és |
|---|---|
| `collect-software.ps1` | Script per a Windows: recull el programari instal·lat i escriu `outputs\raw-software.json` |
| `data-sample/inventory-sample.json` | Inventari anònim de mostra d'un PC Windows (82 programes), per a qui no vulgui executar res |

L'script no necessita res instal·lat. **Només llegeix**: no modifica res del sistema, no demana permisos d'administrador i no envia res per xarxa.

**Si no tens Windows** (macOS o Linux), treballa amb `data-sample/inventory-sample.json`: l'exercici es fa igual.

## Regla: el JSON no es puja enlloc

L'inventari de programari és un perfil de la teva màquina i de tu (què fas servir, quines versions, quines rutes). Per això:

- el fitxer `outputs\raw-software.json` **es queda al teu portàtil**: no el pugis al repo, ni el comparteixis, ni el posis al lliurable;
- el `.gitignore` del repo exclou `outputs/` i `*.json` (llevat de la mostra anònima) perquè no es pugi per error;
- al lliurable només hi van **agregats** (recomptes, percentatges) i una **mostra de 20 títols triats per tu**.

## Com s'executa (Windows, PowerShell 5.1 o 7)

Des de la carpeta on vulguis que quedi `outputs\`:

```powershell
powershell -ExecutionPolicy Bypass -File .\collect-software.ps1
```

O amb una ruta de sortida pròpia: `... -File .\collect-software.ps1 -OutputPath .\el-meu-inventari.json` (es crea la carpeta si cal). Si has descarregat el fitxer des del navegador i Windows el bloqueja, fes clic dret → Propietats → «Desbloqueja», o usa `-ExecutionPolicy Bypass` com a dalt.

Sortida per defecte: `.\outputs\raw-software.json`. En acabar, l'script escriu una línia amb els recomptes.

## Estructura del JSON

Tots els camps poden ser `null` (dada no disponible).

| Bloc | Contingut |
|---|---|
| `CollectedAt` | Data i hora local ISO 8601 amb desfasament (`2026-10-31T12:00:00.0000000+01:00`) |
| `Tools` | `Name`, `Available`, `Path`, `Version` de: git, python, node, npm, az, azd, docker, kubectl, rg, pwsh |
| `Appx` | Paquets de la Microsoft Store: `Name`, `Version`, `Publisher`, `InstallLocation` |
| `Programs` | Programes del registre d'*Uninstall*: `DisplayName`, `DisplayVersion`, `Publisher`, `InstallDate` (`AAAAMMDD` o `null`; molts programes no la declaren) |
| `Errors` | Llista de `{Source, Message}`; buida si tot ha anat bé |

`DisplayName` és el que l'instal·lador va registrar, i pot ser brut (`vs_communityx64msi`, `${{arpDisplayName}}`) o localitzat (`NVIDIA Controlador de gráficos`). Per això casar-lo amb un CPE és difícil.

## Què NO recull

- **Programes instal·lats només per a l'usuari** (clau `HKCU` del registre; p. ex. alguns Chrome, VS Code, Teams instal·lats «per a mi»). Només es llegeix `HKLM` (64 i 32 bits).
- **Aplicacions portables** (un `.exe` descomprimit sense instal·lador) i programes copiats a mà.
- **Biblioteques i paquets de llenguatge**: `pip`, `npm`, paquets de R, JARs… Només hi surten les eines de la llista `Tools`, no el que hi ha dins.
- **Contenidors, màquines virtuals i WSL**: l'inventari és del sistema amfitrió. (Windows Subsystem for Linux apareix com un programa; el seu interior, no.)
- **Fitxers, usuaris, comptes, configuració, serveis en marxa, ports o claus de llicència.**
- **Actualitzacions de Windows** (*hotfixes*, KB) i controladors que no estiguin registrats com a programa.
- **`Appx` de tots els usuaris**, si no ets administrador: l'script en recull només els del teu usuari i ho deixa dit a `Errors`. No és un error de l'inventari. El missatge ve del sistema i pot sortir en el teu idioma.
- **Versió de les eines que no són `.exe`** (`.bat`, `.ps1`): `Version` queda a `null`.

## El dataset de mostra

`data-sample/inventory-sample.json` té el mateix format que produeix l'script.

- **82 programes** a `Programs` (de 317 d'un PC Windows de desenvolupament), 15 paquets de sistema a `Appx` i les 10 eines de `Tools`.
- Els títols, versions, editors i dates d'instal·lació són els reals de la màquina. S'hi veuen les coses que fan difícil casar un títol amb un CPE: duplicats amb versions diferents, noms interns, noms localitzats, versions dins el nom (`7-Zip 26.05 (x64 edition)`), editors buits o que no són una empresa (`https://go.dev`), un nom trencat (`${{arpDisplayName}}`).
- **Anonimitzat:** no hi ha nom d'usuari, noms de màquina ni cap ruta personal (les rutes de `Tools` fora de `Program Files` s'han reduït a `C:\Tools\<fitxer>`; les d'`Appx`, a `C:\Program Files\WindowsApps\…`). S'han retirat els programes que perfilen una persona (jocs, eines d'identitat i claus, comptes de núvol). `CollectedAt` és una data fixa, no la de la captura real. L'ordre de les files és aleatori.
- No és representatiu d'un PC d'oficina: és un portàtil amb eines de desenvolupament. Serveix per practicar el *tidy*, no per treure conclusions sobre «el programari típic».

## Llegir-lo des de R

```r
library(jsonlite)
inv <- fromJSON("outputs/raw-software.json")   # o "data-sample/inventory-sample.json"
programs <- tibble::as_tibble(inv$Programs)
```

Els fitxers no porten BOM i són UTF-8, així que `fromJSON()` els llegeix directament.
