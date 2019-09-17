
library(methods)
library(dplyr)
library(readxl)
library(readr)
library(dembase)

## 2005

raw <- read_xls("data-raw/china_statistical_yearbook/CSYB2006_Table4.11.xls",
                skip = 6) %>%
    select(-(1:4)) %>%
    slice(1, 2, 5)

i_total <- seq(1, 13, 3)
status <- raw[1, i_total] %>%
    as.character() %>%
    rep(each = 2)
i_specific <- setdiff(1:15, i_total)
sex <- c(raw[2, i_specific[1:4]],
         raw[1, i_specific[5:10]]) %>%
    as.character()
count <- raw[3, i_specific] %>%
    as.integer()

popn_survey_05 <- data.frame(status, sex, count,
                             stringsAsFactors = FALSE) %>%
    mutate(status = case_when(status == "Never" ~ "Single",
                              status %in% c("First", "Re-married") ~ "Married",
                              TRUE ~ status)) %>%
    mutate(time = 2005L)


## 2015

popn_survey_15 <- read_csv("data-raw/china_statistical_yearbook/cyb2016_table_2.13.csv") %>%
    mutate(time = 2015L)


## Combine and save

popn_survey <- bind_rows(popn_survey_05, popn_survey_15) %>%
    mutate(status = factor(status, levels = c("Single", "Married", "Divorced", "Widowed"))) %>%
    mutate(age = "15+") %>%
    dtabs(count ~ age + sex + status + time)

save(popn_survey,
     file = "data/popn_survey.rda")


