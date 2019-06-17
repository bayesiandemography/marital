
library(methods)
library(dembase)
library(dplyr)
library(readr)
library(docopt)

'
Usage:
population_un.R [options]

Options:
--age_max [default: 75]
' -> doc
opts <- docopt(doc)
age_max <- opts$age_max %>% as.integer()
    
age_breaks <- seq(0, age_max, 5)

age_levels <- c(0:99, "100+")

population_un <- read_csv("data-raw/UNdata_Export_20180121_001507260.csv",
                                    n_max = 734) %>%
    select(age = Age, sex = Sex, time = Year, count = Value) %>%
    mutate(age = gsub("100 \\+", "100+", age)) %>%
    filter(age %in% age_levels) %>%
    mutate(age = factor(age, levels = age_levels)) %>%
    dtabs(count ~ age + sex + time) %>%
    Counts() %>%
    collapseIntervals(dimension = "age", breaks = age_breaks) %>%
    toInteger(force = TRUE) %>%
    as.array()

save(population_un,
     file = "data/population_un.rda")
