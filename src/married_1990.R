
library(methods)
library(dembase)
library(dplyr)
library(readxl)

married_df <- readRDS("out/married_df.rds")
popn_df <- readRDS("out/popn_df.rds")

married_1990 <- married_df %>%
    filter(time == 1990) %>%
    dtabs(percent ~ age + sex + status + time) %>%
    Counts(dimscales = c(time = "Points"))    

popn_1990 <- popn_df %>%
    filter(time == 1990) %>%
    dtabs(count ~ age + sex + time) %>%
    Counts(dimscales = c(time = "Points")) %>%
    toInteger(force = TRUE)

married_1990 <- popn_1990 %>%
    redistribute(weights = married_1990, means = TRUE) %>%
    toInteger(force = TRUE)

saveRDS(married_1990,
        file = "out/married_1990.rds")
           
