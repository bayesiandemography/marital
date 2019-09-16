
library(methods)
library(dembase)
library(dplyr)
library(readr)

## Get counts disaggregated by age, sex, and time, for age
## groups 0-4, 5-9, ...,  60+

levels_age_exclude <- c("Total",
                        "Unknown",
                        0:99)

age_sex_totals <- read_csv("data-raw/UNdata_Export_20180121_001507260.csv",
                           n_max = 734) %>%
    select(age = Age, sex = Sex, time = Year, count = Value) %>%
    mutate(age = if_else((time %in% c(1990, 2000)) & (age %in% c("0", "1 - 4")),
                         "0 - 4",
                         age)) %>%
    filter(!(age %in% levels_age_exclude)) %>%
    mutate(age = cleanAgeGroup(age)) %>%
    dtabs(count ~ age + sex + time) %>%
    Counts() %>%
    collapseIntervals(dimension = "age", breaks = seq(0, 60, 5)) %>%
    toInteger()

expected <- read_csv("data-raw/UNdata_Export_20180121_001507260.csv",
                         n_max = 734) %>%
    select(age = Age, sex = Sex, time = Year, count = Value) %>%
    filter(age == "Total") %>%
    dtabs(count ~ sex + time)
obtained <- age_sex_totals %>%
    collapseDimension(margin = c("sex", "time")) %>%
    as.array()
stopifnot(all.equal(expected, obtained))


## Get counts disaggregated by age, sex, time, and marital status,
## for age groups 20-24, ..., 60+

marital_status <- read_csv("data-raw/UNdata_Export_20190614_062418893.csv",
                           n_max = 1261) %>%
    select(time = Year,
           area = Area,
           sex = Sex,
           age = Age,
           status = "Marital status",
           count = Value) %>%
    filter(area == "Total") %>%
    select(-area) %>%
    filter(time != "1982") %>%
    filter(age != "15 +") %>%
    filter(age != "Unknown") %>%
    mutate(age = cleanAgeGroup(age)) %>%
    filter(status != "Total") %>%
    mutate(status = ifelse(status == "In consensual union", "Married", status)) %>% ## small numbers, and only in 2000
    mutate(status = factor(status,
                           levels = c("Single (never married)",
                                      "Married",
                                      "Widowed and not remarried",
                                      "Divorced and not remarried"),
                           labels = c("Single",
                                      "Married",
                                      "Widowed",
                                      "Divorced"))) %>%
    mutate(count = ifelse(time %in% c(2000, 2010), count * 10, count)) %>% ## marriage qu on long form given to 10% of respondents
    filter(age != "15-19") %>% ## legal marriage age is 20
    mutate(age = if_else(age %in% c("60-64", "65+"), "60+", age)) %>%
    dtabs(count ~ age + sex + status + time) %>%
    Counts()


## Population aged 0-19

young <- age_sex_totals %>%
    subarray(age < 20) %>%
    addDimension(name = "status",
                 labels = c("Single", "Married", "Widowed", "Divorced"),
                 scale = c(1, 0, 0, 0)) %>%
    toInteger()

## Population aged 20+

old <- age_sex_totals %>%
    subarray(age > 20) %>%
    redistribute(weights = marital_status,
                 means = TRUE) %>%
    toInteger(force = TRUE)


## Combine and save

census <- dbind(young, old, along = "age") %>%
    as.array()

save(census,
     file = "data/census.rda")
