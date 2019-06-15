
library(methods)
library(dembase)
library(dplyr)

population_cb <- readRDS("out/population_cb.rds")
married_census_1990 <- readRDS("out/married_1990.rds")
married_census_1995_2010 <- readRDS("out/married_1995_2010.rds")
births_un <- readRDS("out/births_un.rds")
births_cb <- readRDS("out/births_cb.rds")
deaths_un <- readRDS("out/deaths_un.rds")
deaths_un <- readRDS("out/deaths_cb.rds")
marriages_divorces <- readRDS("out/marriages_divorces.rds")
remarriages <- readRDS("out/remarriages.rds")


datasets <- list(married_census_1990 = married_census_1990,
                 married_census_1995_2010 = married_census_1995_2010,
                 births_un = births_un,
                 deaths_un = deaths_un,
                 marriages_divorces = marriages_divorces,
                 remarriages = remarriages)

saveRDS(datasets,
        file = "out/datasets.rds")
