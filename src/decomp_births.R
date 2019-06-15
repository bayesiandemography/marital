
library(methods)
library(demest)
library(dplyr)

births_un <- readRDS("out/births_un.rds")
population <- readRDS("out/population_cb.rds")

births <- births_un %>% 
    collapseDimension(dimension = "status")

exposure <- population %>%
    exposureBirths(births = births)

decomp_births <- (births / exposure) %>%
    decomposition()

saveRDS(decomp_births,
        file = "out/decomp_births.rds")
