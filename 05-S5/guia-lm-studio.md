# Guia d'instal·lació — LM Studio (Ollama com a alternativa)

**Abans de la sessió 5 (10/12/2026).** Calen uns 30 minuts i una connexió estable (el model pesa entre 0,8 i 2,5 GB). A la S5 interrogarem un model de llenguatge que corre **al teu portàtil**, sense cap compte ni servei extern. Aquesta guia el deixa instal·lat, el fa respondre una pregunta fixa i activa el servidor local perquè l'exercici 1 el pugui cridar des d'R o Python.

Si algun pas falla, anota el missatge d'error exacte i porta'l a classe. Si el portàtil no pot amb el model més petit, no passa res: a la S5 treballareu **en parella** amb algú que sí que el tingui.

Repositori de l'assignatura: <https://github.com/DDS-MCSM/dds-upc-2026>

## Què tindràs en acabar

| Peça | Per a què |
|---|---|
| LM Studio (Windows) | programa que descarrega i executa models en local |
| Un model petit (`qwen3`, 0,6b, 1,7b o 4b) | el model que interrogaràs a l'exercici 1 |
| La resposta a una pregunta de prova, desada | prova que tot funciona i punt de comparació |
| Servidor local actiu (`http://localhost:1234/v1`) | API compatible amb OpenAI, des d'R o Python |

> **No cal cap compte** (ni de LM Studio, ni d'Hugging Face, ni de cap servei d'IA al núvol). Si un programa te'n demana un, salta aquest pas. El model cloud que es pugui veure a la demo de la S5 el posa el docent: no és cosa teva.

## 1. Tria el model segons el teu equip

Mira la memòria del teu equip: *Gestor de tasques → Rendiment*. Necessites dues dades: **RAM** i, si en tens, **memòria dedicada de la GPU** (la «VRAM» d'una targeta NVIDIA o AMD). També cal tenir **uns 5 GB lliures al disc**.

Els tres models són de la família Qwen3. Les mides són les del catàleg de models que veurem a la S5:

| Model (el que cerques) | Quantització | Fitxer | Memòria que cal (regla pràctica) |
|---|---|---|---|
| `qwen3-0.6b` | Q8_0 | 0,8 GB | qualsevol equip; amb 8 GB de RAM sobra |
| `qwen3-1.7b` | Q6_K | 1,7 GB | ≥ 3 GB de VRAM, o ≥ 8 GB de RAM sense GPU |
| `qwen3-4b-instruct-2507` | Q4_K_M | 2,5 GB | ≥ 6 GB de VRAM, o ≥ 16 GB de RAM sense GPU |

La «memòria que cal» és la mida del fitxer més 1–2 GB per al context: és una regla pràctica, **no s'ha mesurat en equips d'aula**.

**Quin tries:**

- **Amb GPU de 6 GB o més:** el `qwen3-4b-instruct-2507`, o el `1.7b` si el prefereixes més ràpid.
- **Amb GPU de 3–6 GB:** el `qwen3-1.7b`.
- **Sense GPU dedicada** (gràfica integrada): el `qwen3-1.7b` si tens 16 GB de RAM; el `qwen3-0.6b` si en tens 8. Corre en CPU: **és lent, però funciona**. Si no va, **parelles a classe**.
- **Si dubtes:** el `qwen3-1.7b` és l'opció per defecte de la sessió.

Un model més gran no és «millor» per a l'exercici: el que importa és que sigui el teu i que n'anotis el nom i la quantització (pas 4).

## 2. Instal·la LM Studio

1. Descarrega l'instal·lador per a Windows de <https://lmstudio.ai/> i executa'l amb les opcions per defecte.
2. En obrir-lo la primera vegada pot oferir-te un model o un tutorial: tanca'l, el triarem nosaltres.
3. A la part de baix a l'esquerra hi ha el selector de mode (*User / Power User / Developer*). Posa **Developer**: així veuràs la pestanya del servidor.

> Els noms de menú que surten aquí són els de la versió actual; poden canviar lleugerament en una versió posterior.

## 3. Descarrega el model

1. A la barra lateral, obre la cerca de models (la lupa, *Discover*).
2. Escriu el nom del pas 1 (per exemple `qwen3-1.7b`).
3. Tria el resultat de l'editor **`lmstudio-community`** i comprova la **mida** que mostra abans de descarregar: ha de ser propera a la de la taula. La quantització per defecte que proposa LM Studio pot ser més petita que la de la taula: és vàlid, només cal anotar-la.
4. Prem *Download* i espera que acabi. Ho veuràs a *My Models* (la carpeta).

Els models es desen a `%USERPROFILE%\.lmstudio\models` per defecte.

## 4. Carrega el model i fes la pregunta de prova

1. Obre *Chat* (la bombolla), tria el model dalt de tot i espera que es carregui.
2. Al panell de la dreta (paràmetres), posa **Temperature a 0**. Així la resposta és el més estable possible.
3. Escriu **exactament** aquesta pregunta (és la primera de les cinc del pont, sobre Log4Shell):

```
Quins CWE té el CVE-2021-44228?
```

4. Espera la resposta. Els models Qwen3 poden mostrar abans un bloc de «pensament» o *reasoning*: la resposta és el que ve després.
5. **Desa-la.** Al teu repositori personal, crea `s5/prova-lm-studio.md` amb aquestes línies i la resposta enganxada:

```markdown
# Prova de LM Studio
- Data:
- Model (nom exacte que mostra LM Studio):
- Quantització (p. ex. Q6_K):
- Temperatura: 0
- Pregunta: Quins CWE té el CVE-2021-44228?

## Resposta
(enganxa aquí la resposta sencera)
```

> **No cal que la resposta sigui correcta.** Un model tan petit pot respondre en castellà, donar un CWE que no existeix o dir una cosa amb molta seguretat i equivocada: és exactament el que mirarem a la S5. Si en repeteixes la pregunta, la resposta pot canviar.

## 5. Activa el servidor local

1. Obre la pestanya **Developer** (la icona `>_`).
2. Posa l'interruptor *Status* a **Running**.
3. Comprova a la configuració del servidor que el **port** és `1234` (el per defecte) i que *Serve on Local Network* està **desactivat**: el servidor només ha de ser accessible des del teu equip. Si Windows demana permís de xarxa, el servidor no el necessita: pots cancel·lar.

L'adreça base de l'API (compatible amb OpenAI) és:

```
http://localhost:1234/v1
```

Comprova que respon, en un terminal de PowerShell:

```powershell
Invoke-RestMethod http://localhost:1234/v1/models
```

Ha de tornar una llista (`data`) amb els models, cadascun amb un camp **`id`**. Aquest `id` és el nom que posaràs a `model` a les crides següents. Si el model no està carregat, LM Studio el carrega en rebre la primera crida (pot trigar uns segons).

## 6. Crida el model des d'R o Python

L'exercici 1 farà això mateix amb les cinc preguntes. Aquí només comprovem la crida.

### R

```r
install.packages("httr2")   # una sola vegada
library(httr2)

resposta <- request("http://localhost:1234/v1/chat/completions") |>
  req_body_json(list(
    model = "qwen3-1.7b",          # el teu id, del pas 5
    temperature = 0,
    max_tokens = 1500,
    messages = list(list(role = "user",
                         content = "Quins CWE té el CVE-2021-44228?"))
  )) |>
  req_perform() |>
  resp_body_json()

cat(resposta$choices[[1]]$message$content)
str(resposta$usage)
```

### Python (alternativa)

```python
import requests

r = requests.post("http://localhost:1234/v1/chat/completions", json={
    "model": "qwen3-1.7b",         # el teu id, del pas 5
    "temperature": 0,
    "max_tokens": 1500,
    "messages": [{"role": "user", "content": "Quins CWE té el CVE-2021-44228?"}],
}, timeout=300)
r.raise_for_status()
print(r.json()["choices"][0]["message"]["content"])
```

Deixa `max_tokens` alt (1500 o més): els models Qwen3 gasten part dels *tokens* en «pensar», i amb un límit baix la resposta pot arribar **buida**.

## 7. Comprovació final

| Què comproves | Resultat esperat |
|---|---|
| El model es veu a *My Models* amb la mida de la taula del pas 1 | sí |
| *Chat* contesta la pregunta de prova | text en una o dues parts (pensament + resposta); pot ser equivocat |
| `s5/prova-lm-studio.md` existeix al teu repositori personal | model, quantització, pregunta i resposta omplerts |
| `Invoke-RestMethod http://localhost:1234/v1/models` | llista amb almenys el teu model (`id`) |
| El fragment d'R (o de Python) del pas 6 | imprimeix una resposta de text no buida i, a R, `usage` amb `prompt_tokens`, `completion_tokens` i `total_tokens` |

Si les cinc coses són certes, ja ho tens. Si la última falla i la resta no, mira «Problemes coneguts».

## Alternativa: Ollama

Fes servir Ollama **només si LM Studio no et va**. És el mateix servei (un model local darrere una API compatible amb OpenAI) i el codi de l'exercici és igual.

1. Instal·la Ollama per a Windows de <https://ollama.com/download> (opcions per defecte). Queda en segon pla.
2. En un terminal, descarrega i prova un model:

```powershell
ollama pull qwen3:1.7b
ollama run qwen3:1.7b
```

Tria `qwen3:0.6b`, `qwen3:1.7b` o `qwen3:4b` amb el mateix criteri del pas 1. La mida real la mostra `ollama pull`, i la quantització és la que posa Ollama (no la de la taula): **anota-la igualment**. Escriu la pregunta del pas 4 i desa la resposta a `s5/prova-lm-studio.md` (canvia el títol si vols). Surt amb `/bye`.

3. El servidor ja està actiu: l'adreça base és `http://localhost:11434/v1`.

```powershell
Invoke-RestMethod http://localhost:11434/v1/models
```

4. Als fragments del pas 6 només canvien dues coses: l'URL (`http://localhost:11434/v1/chat/completions`) i el nom del model (`"qwen3:1.7b"`).

## Problemes coneguts

*(Servidor local i crides d'R i Python comprovats a Windows (31/10); la instal·lació de zero en un equip net no s'ha seguit encara. macOS i Linux fora d'abast: l'aula té equips Windows.)*

| Símptoma | Causa probable | Què fer |
|---|---|---|
| L'instal·lador o la descàrrega del model es bloquegen, o surt un avís de SmartScreen o de l'antivirus | Protecció de l'equip | **No desactivis l'antivirus.** Si és un equip gestionat, avisa el docent abans de la sessió; treballaràs en parella. |
| «No hi ha espai» o la descàrrega s'atura | Disc ple | Cal ~5 GB lliures. Allibera espai o canvia la carpeta de models a *My Models* (la carpeta) a un altre disc. |
| El model no es carrega, error de «recursos»/«memòria insuficient», o l'equip es queda penjat | Memòria justa | Tanca navegadors i altres programes; baixa de mida (4b → 1,7b → 0,6b); a la configuració del model, redueix la *Context Length* (p. ex. a 4096). |
| El model respon molt lent | Corre en CPU | Normal sense GPU. Usa el `0.6b` o el `1.7b`; si segueix inservible, parelles a classe. |
| La descàrrega de models no avança o dóna error de xarxa | *Proxy* o tallafocs que bloqueja el lloc de descàrrega (Hugging Face) | Prova una altra xarxa (per exemple, les dades del mòbil). Si no pots, avisa el docent. |
| R o Python no arriben a `localhost:1234` però el navegador sí | *Proxy* del sistema que intercepta `localhost` | A R: `Sys.setenv(NO_PROXY = "localhost,127.0.0.1")` abans de la crida. |
| `Connection refused` / «no es pot connectar» | Servidor aturat, o port diferent | Comprova que *Status* és *Running* a *Developer* i que el port és el de l'URL. |
| El port `1234` ja està en ús | Una altra aplicació el fa servir | Canvia el port a la configuració del servidor i el mateix número a l'URL. |
| «model not found» o error amb el nom del model | El valor de `model` no és un `id` vàlid | Copia l'`id` tal com surt a `/v1/models`. |
| La resposta de l'API arriba buida | `max_tokens` massa baix: tot s'ha gastat en «pensar» | Puja `max_tokens` a 1500 o més. |
| El model respon en castellà o anglès encara que la pregunta sigui en català | Models petits | Normal. No és un error teu; anota-ho a la resposta. |
| Windows demana permís de xarxa en activar el servidor | Avís habitual del tallafocs | No cal: el servidor és local. Pots cancel·lar. |

---

**Dades.** Tot el que preguntis al model corre al teu equip. No pugis al repositori res que no sigui la teva prova i la teva taula d'errors; i recorda que les dades d'inventari de la S3 no surten del teu ordinador.
