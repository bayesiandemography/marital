
library(dplyr)
library(magrittr)
library(tidyr)
library(readxl)
library(dembase)

levels_status <- c("Single",
                   "Married",
                   "Divorced",
                   "Widowed")

births_un <- read_xlsx("data-raw/NumberBirthsAgeMother-20171130020714.xlsx",
                       sheet = 2,
                       skip = 1) %>%
    filter(Location == "China") %>%
    gather(key = "age", value = "count", `15-19`:`45-49`) %>%
    select(age = age, time = Time, count) %>%
    tidyr::extract(col = time, into = c("start", "stop"),
                   regex = "([:digit:]+) - ([:digit:]+)",
                   convert = TRUE) %>%
    mutate(start = start + 1) %>% # change from 1990-1995 format to 1991-1995 format
    unite(col = time, start, stop, sep = "-", remove = TRUE) %>%
    mutate(status_parent = factor("Married", levels = levels_status),
           status_child = factor("Single", levels = levels_status)) %>%
    complete(status_parent, status_child, age, time, fill = list(count = 0L)) %>%
    dtabs(count ~ status_parent + status_child + age + time) %>%
    Counts() %>%
    multiply_by(1000) %>% # births reported in thousands
    toInteger(force = TRUE) %>%
    as.array()

save(births_un,
    file = "data/births_un.rda")
