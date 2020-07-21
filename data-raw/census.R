
library(dembase)
library(dplyr)
library(readr)

levels_age_exclude <- c("Total",
                        "Unknown",
                        0:99)

census <- read_csv("data-raw/UNdata_Export_20180121_001507260.csv",
                           n_max = 734) %>%
    select(age = Age, sex = Sex, time = Year, count = Value) %>%
    mutate(age = if_else((time %in% c(1990, 2000)) & (age %in% c("0", "1 - 4")),
                         "0 - 4",
                         age)) %>%
    filter(!(age %in% levels_age_exclude)) %>%
    mutate(age = cleanAgeGroup(age)) %>%
    dtabs(count ~ age + sex + time) %>%
    Counts() %>%
    collapseIntervals(dimension = "age", breaks = seq(0, 80, 5)) %>%
    toInteger()

expected <- read_csv("data-raw/UNdata_Export_20180121_001507260.csv",
                         n_max = 734) %>%
    select(age = Age, sex = Sex, time = Year, count = Value) %>%
    filter(age == "Total") %>%
    dtabs(count ~ sex + time)
obtained <- census %>%
    collapseDimension(margin = c("sex", "time")) %>%
    as.array()
stopifnot(all.equal(expected, obtained))

save(census,
     file = "data/census.rda")

