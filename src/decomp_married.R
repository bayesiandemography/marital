
library(methods)
library(demest)
library(dplyr)

married_census_1990 <- readRDS("out/married_1990.rds")
married_census_1995_2010 <- readRDS("out/married_1995_2010.rds")

married <- dbind(married_census_1990, married_census_1995_2010, along = "time")

decomp_married <- married %>%
    subarray(age > 15) %>%
    prop.table(margin = c("age", "sex", "time")) %>%
    decomposition()

saveRDS(decomp_married,
        file = "out/decomp_married.rds")
