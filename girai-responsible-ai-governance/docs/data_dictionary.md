# Data dictionary: `Tranisi_GIRAI_clean.csv`

One row per country (135 rows), one column per variable (8 columns).

| Variable | Meaning | Type | Unit | Allowed values / coding | Source sheet |
| --- | --- | --- | --- | --- | --- |
| `country` | Country name | Text | — | 135 unique names | country_classifications |
| `iso3` | Three-letter country code; merge key | Text | — | 135 unique codes (Kosovo = XKX, not an official ISO code) | country_classifications |
| `region` | GIRAI geographical region | Categorical | — | Africa, Asia and Oceania, Caribbean, Europe, Middle East, Northern America, South and Central America | country_classifications |
| `developing_status` | UN M49 developed/developing grouping (statistical convenience only) | Categorical | — | Developed, Developing | country_classifications |
| `wb_income_group` | World Bank FY2026 income group (GNI per capita, Atlas method) | Categorical, ordered | — | Low income, Lower middle income, Upper middle income, High income | country_classifications |
| `gdp_per_capita_ppp` | GDP per capita, PPP (World Bank NY.GDP.PCAP.PP.CD); 2024 values for 131 countries, 2023 for 3, 2015 for 1 | Numeric | Current international dollars | Observed 1,154.89 to 150,689.30 | country_classifications |
| `girai` | Overall GIRAI 2026 score after the URAI penalty | Numeric | Index points | 0–100; observed 4.04 to 75.26 | all_indicators |
| `least_developed_countries` | UN Least Developed Country designation | Categorical | — | LDC (31), Non-LDC (104) | girai_regions_2026 |

## Missing values

Missing values are coded `NA`. The cleaned file contains none (`sum(is.na(girai_clean))` returns 0). The only blanks in the source were in `least_developed_countries`, where a blank means "not designated," so they were recoded to `Non-LDC`.

## Derived variable (created in the script, not saved to the CSV)

- `log2_gdp` = log base 2 of `gdp_per_capita_ppp`. An increase of 1 means GDP per capita doubles.
