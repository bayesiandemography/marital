
library(dembase)
library(dplyr)
library(readr)


load("data/census.rda") ## loads 'census'
census <- census %>%
    collapseIntervals(dimension = "age", breaks = seq(0, 60, 5))


## Get counts disaggregated by age, sex, time, and marital status,
## for age groups 15-19, 20-24, ..., 60+

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
    mutate(age = if_else(age %in% c("60-64", "65+"), "60+", age)) %>%
    dtabs(count ~ age + sex + status + time) %>%
    Counts()


## Population aged 0-14

young <- census %>%
    subarray(age < 15) %>%
    addDimension(name = "status",
                 labels = c("Single", "Married", "Widowed", "Divorced"),
                 scale = c(1, 0, 0, 0)) %>%
    toInteger()

## Population aged 15+

old <- census %>%
    subarray(age > 15) %>%
    redistribute(weights = marital_status,
                 means = TRUE) %>%
    toInteger(force = TRUE)


## Combine and save

census_status <- dbind(young, old, along = "age") %>%
    as.array()

save(census_status,
     file = "data/census_status.rda")
