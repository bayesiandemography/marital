
library(methods)
library(dplyr)
library(tidyr)
library(readr)
library(dembase)

levels_status <- c("Single",
                   "Married",
                   "Divorced",
                   "Widowed")

births_cb_1990_2009 <- read_csv("data-raw/census_data_20190327_5c9c35cc5727c.csv",
                                skip = 1) %>%
    select(time = Year, count = Births)

births_cb_2010_2015 <- read_csv("data-raw/census_data_20190327_5c9c35eb3d35a.csv",
                                skip = 1) %>%
    select(time = Year, count = Births)

births_cb <- bind_rows(births_cb_1990_2009, births_cb_2010_2015) %>%
    filter(time > 1990) %>%
    mutate(status_parent = factor("Married", levels = levels_status),
           status_child = factor("Single", levels = levels_status)) %>%
    complete(status_parent, status_child, time, fill = list(count = 0L)) %>%
    dtabs(count ~ status_parent + status_child + time) %>%
    Counts(dimscales = c(time = "Intervals")) %>%
    collapseIntervals(dimension = "time", width = 5) %>%
    toInteger(force = TRUE) %>%
    as.array()

save(births_cb,
     file = "data/births_cb.rda")
