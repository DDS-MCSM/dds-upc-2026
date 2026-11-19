# Data Driven Security — UPC, edició 2026

Material de l'assignatura *Data Driven Security* del màster de ciberseguretat de la UPC. Aquest repositori és públic i conté només el que necessites com a alumne: el material de cada sessió, la plantilla d'exercici i les instruccions per lliurar.

Fil de l'assignatura: *les dades de ciberseguretat són els estàndards* (CVE, CPE, CWE, CAPEC, ATT&CK) → *un model sol no n'hi ha prou; un sistema fonamentat en aquests estàndards, sí*. Un mateix cas, `CVE-2021-44228` (Log4Shell), travessa les vuit sessions.

## Calendari

Vuit sessions de 3 h (18:30–21:30).

| Sessió | Data | Docent | Carpeta |
|---|---|---|---|
| S1 Data Science i entorn | dj 19/11 | Humbert | [`01-S1`](01-S1/) |
| S2 Anàlisi reproduïble | dl 30/11 | Humbert | [`02-S2`](02-S2/) |
| S3 Dades elegants = estàndards | dt 01/12 | Humbert | [`03-S3`](03-S3/) |
| S4 Exploració, gràfics i ML | dj 03/12 | Humbert | [`04-S4`](04-S4/) |
| S5 Quatre generacions de model | dj 10/12 | Humbert | [`05-S5`](05-S5/) |
| S6 Del model al sistema | dl 14/12 | Humbert | [`06-S6`](06-S6/) |
| S7 Fonamentar en coneixement: KGCS | dt 15/12 | Humbert | [`07-S7`](07-S7/) |
| S8 Hackathon | dj 17/12 | Humbert | [`08-S8`](08-S8/) |

Entre S4 i S5 hi ha un exercici-pont (festiu 07–08/12, lliurament el 09/12).

## Requisits de l'entorn

- **R ≥ 4.4**
- **RStudio**
- **git**
- **El paquet `mitre` de la branca `dds-2026`.** No instal·lis el de CRAN: porta una mostra molt petita i no conté el cas de l'assignatura. La guia d'instal·lació (via GitHub i via tarball) arriba amb el material de [`01-S1`](01-S1/). El tarball i el seu `SHA256SUMS` es publiquen a les [*releases*](https://github.com/DDS-MCSM/dds-upc-2026/releases).

## Com es lliura cada exercici

1. Parteix de la plantilla [`templates/dds-template.Rmd`](templates/dds-template.Rmd) i copia-la al teu repositori personal.
2. Escriu l'anàlisi al `.Rmd` i genera'n l'`.html` (*Knit*).
3. Puja al teu repositori personal el **`.Rmd` i l'`.html`**, amb un *commit* amb missatge clar.
4. Lliura l'enllaç al *commit* pel canal que indiqui el docent a la sessió.

## Dades i privadesa

Els inventaris de programari i qualsevol dataset personal **no es pugen mai** (vegeu [`data/`](data/)). Queden al teu portàtil.

## Estructura

```
01-S1 … 08-S8/   Una carpeta per sessió
templates/       Plantilla d'exercici (.Rmd)
data/            Sense dades: vegeu-hi el perquè
releases/        Sobre la publicació del paquet mitre
```

## Llicències

- **Material** (text, enunciats, presentacions): [CC BY-SA 4.0](LICENSE).
- **Codi**: [MIT](LICENSE-CODE).
