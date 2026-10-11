# Responsible AI Governance and National Wealth

**A cross-national analysis of 135 countries using the Global Index on Responsible AI (GIRAI) 2026**

Lauren Tranisi · STAT C1000H: Introduction to Statistics (Honors), Section 1850 · MiraCosta College · Fall 2026
Faculty mentor: Professor Shawn Firouzian

## Research questions

**Primary:** Among the 135 countries assessed in the GIRAI 2026 edition, is the overall responsible-AI index score associated with GDP per capita?

**Secondary:** Do mean GIRAI scores differ by

1. Least Developed Country (LDC) status
2. UN developing vs. developed status
3. World Bank income group
4. World region

## Summary of findings

_[Add a short summary of your results here once the final report is done.]_

## Repository structure

```
├── R/
│   └── Tranisi_Final_Project.R      # full script: cleaning, summaries, plots, regressions, tests
├── data/
│   ├── raw/                         # original GIRAI files (see data/raw/README.md)
│   └── processed/
│       └── Tranisi_GIRAI_clean.csv  # analysis-ready data: 135 rows x 8 columns
├── docs/
│   └── data_dictionary.md           # every variable, its type, unit, and coding
├── figures/                         # exported plots
└── girai-analysis.Rproj             # open this in RStudio / Posit Cloud
```

## How to reproduce

1. Open `girai-analysis.Rproj` (or, in Posit Cloud: **New Project → New Project from Git Repository** and paste this repo's URL).
2. Put the two original Excel files in `data/raw/` (see `data/raw/README.md`).
3. Install packages once: `install.packages(c("tidyverse", "readxl", "janitor"))`
4. Open `R/Tranisi_Final_Project.R` and click **Source**. The script runs top to bottom and rewrites `data/processed/Tranisi_GIRAI_clean.csv`.

The cleaned CSV is already included, so the analysis sections can be explored without the raw files.

## Methods

- Linear regression of GIRAI score on each explanatory variable (GDP per capita on a log2 scale)
- Supporting tests: Welch two-sample *t*-tests, one-way ANOVA, and Welch's ANOVA
- Significance level α = .05
- Condition checks with residual and Q-Q plots

## Data source

Adams, R., Adeleke, F., Alayande, A., Abdella, S. E., Florido, A., Grossman, N., & Junck, L. (2026). *Global Index on Responsible AI 2026: Responsible AI governance data for 135 countries* (Version 1) [Data set]. Harvard Dataverse. https://doi.org/10.7910/DVN/YKNAZX

The data are released under [CC0 1.0 Universal](https://creativecommons.org/publicdomain/zero/1.0/) (public domain), so they may be shared and modified freely. They contain country-level information only, with no data about individuals.

## AI use disclosure

Claude (Anthropic) was used to help troubleshoot R code, explain statistical methods, and organize this repository. All analysis was run and verified by the author.
