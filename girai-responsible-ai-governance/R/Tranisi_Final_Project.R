# Lauren Tranisi - STAT C1000H - 1850
# Honors Final Project: GIRAI 2026
###### PART 1: Cleaning Code ######
library(janitor)
library(tidyverse)
library(readxl)

#used clean_names() from janitor package to make all column names standard and lowercase
country_classifications <- clean_names(read_excel("data/raw/GIRAI_rankings_and_scores.xlsx",
                              sheet = "country_classifications"))
all_indicators <- clean_names(read_excel("data/raw/GIRAI_rankings_and_scores.xlsx",
                           sheet = "all_indicators"))
girai_regions <- clean_names(read_excel("data/raw/GIRAI_regions_and_subregions.xlsx",
                                        sheet = "girai_regions_2026"))

#check that merger columns are consistent
names(country_classifications)
names(all_indicators)
names(girai_regions)

#narrow down columns i want
all_indicators_narrowed <- all_indicators |> select(iso3, girai)
country_classifications_narrowed <- country_classifications |> select(-subregion)
ldc_countries <- girai_regions |> 
  filter(!is.na(country)) |> 
  select(iso3, least_developed_countries) |> 
  mutate(least_developed_countries = replace_na(least_developed_countries, "Non-LDC"))

#left join based on iso3
girai_clean <- left_join(country_classifications_narrowed, 
                         all_indicators_narrowed,
                         by = "iso3") |> left_join(ldc_countries, by = "iso3")

#check dimensions of cleaned file is 135 x 8
dim(girai_clean)

#check if any NA (should be 0)
sum(is.na(girai_clean))

#write new dataset into a csv file
write_csv(girai_clean, "data/processed/Tranisi_GIRAI_clean.csv")

###### PART 2: Summaries and Plots ######

#summary of girai values
summary(girai_clean$girai)
sd(girai_clean$girai)

#summary of gdp values
summary(girai_clean$gdp_per_capita_ppp)
sd(girai_clean$gdp_per_capita_ppp)

girai_clean |>
  group_by(region) |>
  summarise(n = n(), mean = mean(girai), sd = sd(girai))

#Label groups do sort scatterplot points
#Using log function for gdp since most papers did
girai_clean <- girai_clean |>
mutate(wb_income_group = factor(wb_income_group,
                                levels = c("Low income", "Lower middle income",
                                           "Upper middle income", "High income")),
       least_developed_countries = factor(least_developed_countries,
                                          levels = c("Non-LDC", "LDC")),
       log2_gdp = log2(gdp_per_capita_ppp))

#Raw GDP, fits linear regression line
ggplot(girai_clean, aes(x = gdp_per_capita_ppp, y = girai)) +
  #adds colors based on income group
  geom_point(aes(color = wb_income_group)) +
  geom_smooth(method = "lm") +
  labs(title = "GIRAI vs. GDP per capita (raw)",
       x = "GDP per capita, PPP (int'l $)", y = "GIRAI score")

#Log GDP
#Log GDP (log2 spacing, axis labeled in dollars)
ggplot(girai_clean, aes(x = gdp_per_capita_ppp, y = girai)) +
  geom_point(aes(color = wb_income_group)) +
  geom_smooth(method = "lm", formula = y ~ x, color = "black") +
  #log scaled but still shows as gdp numbers
  scale_x_continuous(trans = "log2", labels = scales::label_dollar()) +
  labs(title = "GIRAI vs. GDP per capita (log2 scale)",
       x = "GDP per capita, PPP (int'l $, log2 scale)", y = "GIRAI score",
       color = "Income group")

#Check Correlations Between Raw and Log
cor(girai_clean$girai, girai_clean$gdp_per_capita_ppp)
cor(girai_clean$girai, girai_clean$log2_gdp)

girai_clean |>
  group_by(developing_status) |>
  summarise(n = n(), mean = mean(girai), median = median(girai),
            sd = sd(girai), IQR = IQR(girai), min = min(girai), max = max(girai))

ggplot(girai_clean, aes(x = developing_status, y = girai)) +
  geom_boxplot() +
  labs(title = "GIRAI by developing status", x = NULL, y = "GIRAI score")

#World Bank income group
girai_clean |>
  group_by(wb_income_group) |>
  summarise(n = n(), mean = mean(girai), median = median(girai),
            sd = sd(girai), IQR = IQR(girai), min = min(girai), max = max(girai))

ggplot(girai_clean, aes(x = wb_income_group, y = girai)) +
  geom_boxplot() +
  labs(title = "GIRAI by World Bank income group", x = NULL, y = "GIRAI score")

#region sorted by mean
girai_clean |>
  group_by(region) |>
  summarise(n = n(), mean = mean(girai), median = median(girai),
            sd = sd(girai), IQR = IQR(girai), min = min(girai), max = max(girai)) |>
  arrange(desc(mean))

ggplot(girai_clean, aes(x = reorder(region, girai), y = girai)) +
  geom_boxplot() +
  labs(title = "GIRAI by region", x = NULL, y = "GIRAI score")

#Least Developed Countries
girai_clean |>
  group_by(least_developed_countries) |>
  summarise(n = n(), mean = mean(girai), median = median(girai),
            sd = sd(girai), IQR = IQR(girai), min = min(girai), max = max(girai))

ggplot(girai_clean, aes(x = least_developed_countries, y = girai)) +
  geom_boxplot() +
  labs(title = "GIRAI by LDC status", x = NULL, y = "GIRAI score")

table(girai_clean$wb_income_group, girai_clean$least_developed_countries)
table(girai_clean$wb_income_group, girai_clean$developing_status)

###### PART 3: Regression for each research question ######

#Make linear model from log data and see fit
model <- lm(girai ~ log2_gdp, data = girai_clean)
summary(model)
confint(model)
#Check conditions
plot(model, which = 1)
plot(model, which = 2)

model_dev <- lm(girai ~ developing_status, data = girai_clean)
model_ldc <- lm(girai ~ least_developed_countries, data = girai_clean)
model_income <- lm(girai ~ wb_income_group, data = girai_clean)
model_region <- lm(girai ~ region, data = girai_clean)

summary(model_dev)
confint(model_dev)
summary(model_ldc)
confint(model_ldc)
summary(model_income)
confint(model_income)
summary(model_region)
confint(model_region)

#Find over and under performers
girai_clean <- girai_clean |> mutate(resid = resid(model))
girai_clean |> arrange(desc(resid)) |> select(country, girai, resid) |> head(8)
girai_clean |> arrange(resid) |> select(country, girai, resid) |> head(8)

###### PART 4: Supporting Tests ######
#Welch T-Tests because 2 groups
t.test(girai ~ developing_status, data = girai_clean)
t.test(girai ~ least_developed_countries, data = girai_clean)
#One-Way ANOVA since 4 groups spread similar
income_aov <- aov(girai ~ wb_income_group, data = girai_clean)
summary(income_aov)
#Welch ANOVA since 7 groups with very different spreads
oneway.test(girai ~ region, data = girai_clean)
