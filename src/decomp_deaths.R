
library(methods)
library(demest)
library(dplyr)

deaths <- readRDS("out/deaths_un.rds")

population <- readRDS("out/population_cb.rds") %>%
    collapseIntervals(dimension = "age", breaks = seq(0, 65, 5)) %>%
    subarray(time <= 2010)

exposure <- population %>%
    exposure()

decomp_deaths <- (deaths / exposure) %>%
    decomposition()

saveRDS(decomp_deaths,
        file = "out/decomp_deaths.rds")
