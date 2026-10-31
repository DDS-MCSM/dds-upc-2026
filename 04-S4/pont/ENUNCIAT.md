# Exercici-pont S4 → S5 — El graf del cas

**Per equip (3–4 persones) · setmana del 7/12 · lliurament: dimecres 09/12, 23:59**
**Lliurable:** un fitxer `.Rmd` i el seu `.html` al repo personal de l'equip, amb un `commit` que els contingui. Es lliura el mateix dia que l'exercici 3.

## Què has de fer

A la Part 1 has tractat el cas amb taules i gràfics. Aquí el tractes com un **graf**: els estàndards (CVE, CWE, CAPEC, ATT&CK, CPE i les defenses) són nodes, i les relacions entre ells són arestes. Construeixes el graf del cas, el travesses des de dos CVE (`CVE-2021-44228`, Log4Shell, i `CVE-2017-5645`, el CVE de control) i respons **cinc preguntes fixades, només amb el graf**. Per a cada pregunta has de dir si el graf hi arriba o no.

Aquesta taula és la **línia base de l'exercici 1 de la S5**, que hi contrasta un model de llenguatge, i es compara amb el graf de coneixement KGCS a la S7. Guarda-la bé.

L'informe ha de teixir-se (`knit`) d'una sola passada, des d'una sessió d'R nova.

## Punt de partida

- Plantilla: `plantilla-pont.Rmd` (feta a partir de `templates/dds-template.Rmd`). Té el Pas 0 ja escrit i la resta d'apartats amb *chunks* marcats `eval = FALSE`: hi escrius el codi i treus `eval = FALSE`.
- `mitre` de la branca `dds-2026` (`packageVersion("mitre")` ha de donar `1.0.0.9100`). Paquets: `tidyverse` i `igraph` (ve amb `mitre`).
- **Memòria.** `build_network()` amb les taules completes triga ≈ 8 s i arriba a ≈ 1,5 GB de memòria (mesurat a Windows, R 4.6, a l'equip del docent). Tanca el que no facis servir; amb menys de 4 GB lliures pot fallar. Si falla per memòria, digues-ho al docent: no és un problema del teu codi.

## Pas 0 (obligatori) — La llista `standards` del cas

`build_network()` **sense arguments no serveix**: usa una mostra interna aleatòria (≈ 0,2 % dels CVE, 30 % de CWE i CAPEC) que no conté el cas i on la cadena queda trencada. Has de construir la teva pròpia llista `standards` a partir de les taules completes i passar-la a `build_network(standards = …)`.

**Regla:** només es **filtren CVE i CPE**. CWE, CAPEC, ATT&CK, SHIELD, Engage i CAR es passen **completes**, amb els noms d'element de `data-raw/build_data.R` del paquet.

- CVE: `CVE-2021-44228`, `CVE-2017-5645` i els CVE amb `log4j` a `description`.
- CPE: `product == "log4j"`.

El codi és el de la S4. **Copia'l tal com és**; no el canviïs (si el canvies, el graf no serà el del cas):

```r
library(mitre)
cve <- dplyr::filter(cve.nist, cve.id %in% c("CVE-2021-44228", "CVE-2017-5645") |
                     grepl("log4j", description, ignore.case = TRUE))
# Sentinelles: build_cve2cwe_edges() (dds-2026) buida TOTES les arestes CVE-CWE si el conjunt
# no té cap 'NVD-CWE-noinfo' ni cap 'NVD-CWE-Other'. Les sentinelles no tenen arestes i el graf les descarta.
sent <- cve.nist[cve.nist$problem.type %in% c('["NVD-CWE-noinfo"]', '["NVD-CWE-Other"]') &
                 !cve.nist$cve.id %in% cve$cve.id, ]
cve <- rbind(cve, sent[!duplicated(sent$problem.type), ])
cpe <- dplyr::filter(cpe.nist, product == "log4j")
s <- list(
  cpe   = list(cpe.nist = cpe),
  cve   = list(cve.nist = cve),
  cwe   = list(cwe.views = cwe.views, cwe.categories = cwe.categories, cwe.weaknesses = cwe.weaknesses),
  capec = list(capec.views = capec.views, capec.categories = capec.categories,
               capec.patterns = capec.patterns, capec.relations = capec.relations),
  attck = list(attck.tactics = attck.tactics, attck.techniques = attck.techniques,
               attck.mitigations = attck.mitigations, attck.groups = attck.groups,
               attck.software = attck.software, attck.data_component = attck.data_component,
               attck.data_relations = attck.data_relations, attck.relations = attck.relations),
  shield = list(shield.tactics = shield.tactics, shield.techniques = shield.techniques,
                shield.procedures = shield.procedures, shield.use_cases = shield.use_cases,
                shield.opportunities = shield.opportunities, shield.relations = shield.relations),
  engage = list(engage.goals = engage.goals, engage.approaches = engage.approaches,
                engage.activities = engage.activities, engage.av = engage.av, engage.relations = engage.relations),
  car = list(car.analytics = car.analytics, car.model = car.model, car.coverage = car.coverage,
             car.implementations = car.implementations, car.sensors = car.sensors, car.relations = car.relations)
)
# build_capec_nodes() i build_cwe2cwe_edges() (dds-2026) llegeixen el 'standards' del paquet (la mostra)
# i no l'argument: sense això, CAPEC i CWE-CWE surten de la mostra i la cadena es trenca.
utils::assignInNamespace("standards", s, ns = "mitre")
net <- build_network(standards = s, as_igraph = TRUE)
```

**Per què hi ha tres línies que no esperaves** (les sentinelles del `cve` i `assignInNamespace`). `build_network()` de la branca `dds-2026` té dos errors que només es veuen amb una llista pròpia: (1) si el conjunt de CVE no té cap `NVD-CWE-Other`, esborra **totes** les arestes CVE → CWE; (2) els nodes CAPEC i les arestes CWE-CWE els llegeix del `standards` del paquet (la mostra) i no de l'argument. Aquestes línies ho eviten a l'aula; no cal que les modifiquis ni que corregeixis el paquet.

**Comprovació del Pas 0.** El graf ha de tenir **4.145 nodes i 30.230 arestes**. Si no, la llista no és la del cas: atura't i revisa-la abans de continuar. Anota també el temps i la memòria que ha costat al teu equip (a la plantilla hi ha el codi per al temps i el *heap* d'R).

Els nodes d'`igraph` porten l'identificador (`CVE-2021-44228`, `CWE-20`, `T1574.007`…) a `V(net)$label`; `name` és un número intern. La família és `V(net)$group` (`cve`, `cwe`, `capec`, `attck`, `cpe`, `shield`, `engage`, `car`) i el tipus `V(net)$type`.

## Què entrega l'informe

1. **(a) El subgraf del cas.** Els dos CVE i el que hi arriba en tres passes; nodes i arestes, per família.
2. **(b) Les llistes trobades.** Els CWE, els CAPEC i les tècniques ATT&CK que troba la cadena CVE → CWE → CAPEC → ATT&CK per a cada CVE.
3. **(c) Les cinc preguntes**, per als **dos** CVE:

   | # | Pregunta |
   |---|---|
   | 1 | Quins CWE té el CVE? |
   | 2 | Quins patrons d'atac (CAPEC) demostren aquests CWE? |
   | 3 | Quines tècniques ATT&CK implementen aquests patrons? |
   | 4 | Quins productes/plataformes (CPE) són afectats? |
   | 5 | Quines mitigacions o defenses hi ha enllaçades? |

4. **Una taula base** (`taula_pont`): una fila per CVE i pregunta, amb les columnes `cve`, `pregunta`, `n`, `el graf hi arriba?` i `elements`, **desada també a `taula_pont.csv`** al costat de l'`.Rmd` (`readr::write_csv(taula_pont, "taula_pont.csv")`) i pujada al repo: els exercicis de la S5 i la S7 la llegeixen amb aquest nom.
5. **Lectura**: per pregunta, què diu el graf i què no es pot concloure.

## Només amb el graf, i què vol dir «hi arriba»

Les respostes de (c) han de sortir d'`igraph` (`neighbors()`, `adjacent_vertices()`, `neighborhood()`, `distances()`, `shortest_paths()`), **no** de tornar a filtrar `cve.nist` ni cap altra taula. Les taules només entren al Pas 0.

Per a cada pregunta i cada CVE, la resposta té **tres estats possibles**, i els tres són respostes vàlides si són certs:

- **Sí, hi arriba:** el graf dona elements per aquest salt. Digues quants i quins.
- **No, no hi arriba:** el graf no dona res per aquest salt. Digues fins on arriba la cadena (l'últim salt amb elements) i **per què creus que s'atura** (falta una aresta? la font no ho enllaça?).
- **Hi arriba per un altre camí:** la cadena que s'esperava no hi és, però el graf connecta igualment el CVE amb la resposta per una altra via. **Mesura-ho:** la distància mínima (`igraph::distances()`), per on passa el camí (`igraph::shortest_paths()`) i si aquest camí és *evidència sobre aquest CVE* o *herència* d'una categoria més general. Una distància curta i una de llarga no són la mateixa resposta.

Dues pistes sobre la direcció de les arestes: les preguntes 1–4 es responen seguint les arestes en sentit de sortida (`mode = "out"`), però algunes defenses (pregunta 5) pengen de les tècniques en sentit **entrant** (`mode = "in"`). Una resposta «cap defensa» pot venir d'haver mirat només una direcció.

No es val a respondre «no» perquè el codi no ha donat res sense mirar per què.

## Què porta el lliurable

| Apartat | Contingut |
|---|---|
| Objectiu i dades | Una frase de pregunta; paquet, versió i taules; data de les dades |
| Pas 0 | La llista `standards` idèntica a la de l'enunciat, amb la comprovació 4.145 / 30.230 i el cost (temps, memòria) del teu equip |
| (a), (b) | El subgraf i les llistes, amb el codi visible (`echo = TRUE`) |
| (c) | Les cinc preguntes × dos CVE, cada una amb el seu estat (sí / no / altre camí) |
| Taula base | `taula_pont`, una fila per CVE i pregunta, i el fitxer `taula_pont.csv` al repo |
| Lectura i limitacions | Què no es pot concloure; xifres amb codi en línia |
| Procedència | `sessionInfo()` amb la versió de `mitre` i d'`igraph` |

## Com es valida

1. Tanca RStudio, obre'l de nou, **Knit**. Si falla o canvia el resultat, no és reproduïble.
2. Algú altre de l'equip ha de poder fer el mateix amb el repo i obtenir el mateix HTML llevat de la data.
3. El Pas 0 es compara amb la llista de l'enunciat: ha de ser la mateixa.

## Criteris

| Criteri | Pes |
|---|---|
| Teixeix sense errors des d'una sessió nova | 15 % |
| Pas 0: llista idèntica a la de l'enunciat, comprovació 4.145 / 30.230 i cost anotat | 15 % |
| (a) i (b): subgraf i llistes de CWE, CAPEC i tècniques | 15 % |
| (c): les cinc preguntes × dos CVE, només amb el graf, amb la xifra correcta | 25 % |
| (c): per a cada una, l'estat honest (sí / no / altre camí), i el cas del control tractat amb criteri | 15 % |
| Taula base: forma demanada i reutilitzable | 5 % |
| Lectura i limitacions: què no es pot concloure; xifres amb codi en línia | 5 % |
| Reproduïbilitat i versionat: sense rutes absolutes ni xifres escrites a mà, amb `commit` | 5 % |

Pot formar part d'una pràctica si l'avaluació ho preveu: el pes dins l'avaluació s'anunciarà a classe. L'exercici 3 el prepara; l'exercici 1 de la S5 el reprèn.
