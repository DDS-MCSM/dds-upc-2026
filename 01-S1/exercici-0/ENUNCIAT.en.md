# Exercise 0 — Environment verified and first query

**Session 1 · Individual · 40 min in class (20:20–21:00)**
**Deliverable:** a 10-line `.R` script and the output of `sessionInfo()` in your personal repository, with a *commit*. **Not graded**: its purpose is to catch environment problems before S2.

## What you have to do

1. Verify your environment (R, RStudio, git, `mitre` from the `dds-2026` branch).
2. Have your private personal repository cloned and working.
3. Write a **10-line** `.R` script that runs your first query on `cve.nist` and save it in the repository.
4. *Commit* and *push* it.

## Starting point

Installation guide: [`01-S1/guia-instalacio.en.md`](../guia-instalacio.en.md), in this same repository. It should be done before class; if it is not, now is the time to find out why.

Check this before anything else:

```r
packageVersion("mitre")   # 1.0.0.9100
nrow(mitre::cve.nist)     # 210804
```

If you get `1.0.0` or a 25-row table, you have the CRAN package: uninstall it (`remove.packages("mitre")`) and go back to step 5 of the guide. If nothing comes out or you get an error, tell the lecturer **now**, not in S2.

## The script

Save it in your personal repository as `ex0.R`. It must contain, with comments, **five things** (you can do it in fewer or more than 10 lines, but not many more):

| # | What | Hint |
|---|---|---|
| 1 | Load the package | `library(mitre)` |
| 2 | How many rows `cve.nist` has | `nrow(cve.nist)` |
| 3 | Look at the first identifiers | `head(cve.nist$cve.id)` |
| 4 | **How many CVEs there are per year of publication** | `lubridate::year(cve.nist$published.date)` and `table()` |
| 5 | Write out the result | `print()` the table and, if you like, a `barplot()` |

Example skeleton (complete it yourself):

```r
library(mitre)
nrow(cve.nist)
head(cve.nist$cve.id)
any <- lubridate::year(cve.nist$published.date)
table(any)
```

Try it in the console, line by line, before saving it. Also look at which columns the table has: `names(cve.nist)` (the table has no help page, so `?cve.nist` will not help). In the skeleton, `any` is just a variable name: it is Catalan for "year".

> **Two things you will see:** (1) there are 3 CVEs with no publication date, which `table()` ignores; (2) the table has very few CVEs before 2017. Take note: that is what we will talk about in the wrap-up discussion.
>
> The year can change for a few CVEs depending on your computer's time zone (`published.date` is an instant in time, not a date). It is not your mistake; it is the first example of what we will see in S2.

## Submission

1. Save `ex0.R` in the folder of your cloned repository.
2. In the R console, save your session:

```r
writeLines(capture.output(sessionInfo()), "ex0-sessioninfo.txt")
```

3. *Commit* and *push*, from RStudio (*Git* tab: tick the files, *Commit*, *Push*) or from the terminal:

```bash
git add ex0.R ex0-sessioninfo.txt
git commit -m "Exercise 0: environment verified and first query on cve.nist"
git push
```

4. Open the repository in your browser (`github.com/<user>/<repo>`) and check that you can see both files and the *commit*.

## How it is validated

| Check | How |
|---|---|
| The package is the right one | `ex0-sessioninfo.txt` says `mitre_1.0.0.9100` |
| The script runs from scratch | Restart R (*Session → Restart R*), run everything: no errors |
| The repository is personal and private | GitHub shows the padlock with "Private" |
| The *commit* is there | `git log --oneline` shows your message, and you can see it on GitHub |

## Criteria

**Not graded.** Before S2 the lecturer only checks whether each student has a working environment and a *commit* in the repository; anyone who does not will get individual help.

| Criterion | Weight |
|---|---|
| Environment verified, `mitre` `1.0.0.9100` | no mark (required for S2) |
| 10-line script with the table of CVEs per year | no mark |
| *Commit* and *push* to the personal repository | no mark (required for S2) |
