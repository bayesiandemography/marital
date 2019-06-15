
library(methods)
library(docopt)
library(dplyr)
library(tidyr)
library(magrittr)
library(readxl)
library(dembase)

'
Usage:
deaths_un.R [options]

Options:
--age_max [default: 75]
' -> doc
opts <- docopt(doc)
age_max <- opts$age_max %>% as.integer()
    
age_breaks <- seq(0, age_max, 5)

deaths_un <- read_xlsx("data-raw/NumberDeaths-20171201121407.xlsx",
                       sheet = 2,
                       skip = 1) %>%
    filter(Location == "China") %>%
    gather(key = "age", value = "count", `0-4`:`95+`) %>%
    select(age = age, sex = Sex, time = Time, count) %>%
    tidyr::extract(col = time, into = c("start", "stop"),
                   regex = "([:digit:]+) - ([:digit:]+)",
                   convert = TRUE) %>%
    mutate(start = start + 1) %>%
    unite(col = time, start, stop, sep = "-", remove = TRUE) %>%
    dtabs(count ~ age + sex + time) %>%
    Counts() %>%
    multiply_by(1000) %>% # numbers reported in 1000s
    collapseIntervals(dimension = "age", breaks = age_breaks) %>%
    toInteger(force = TRUE) %>%
    as.array()

save(deaths_un,
     file = "data/deaths_un.rda")
