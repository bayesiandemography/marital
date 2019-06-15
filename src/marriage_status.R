
library(methods)
library(readr)
library(dplyr)
library(dembase)
library(assertr)

marriage_status_df <- read_csv("data/UNdata_Export_20190614_062418893.csv",
                               n_max = 1261) %>%
    select(time = Year,
           area = Area,
           sex = Sex,
           age = Age,
           status = "Marital status",
           count = Value) %>%
    filter(area == "Total") %>%
    select(-area) %>%
    filter(time != "1982") %>%
    filter(age != "15 +") %>%
    verify(!(age == "Unknown" & count > 0)) %>%
    filter(age != "Unknown") %>%
    mutate(age = cleanAgeGroup(age)) %>%
    filter(status != "Total") %>%
    mutate(status = ifelse(status == "In consensual union", "Married", status)) %>% ## small numbers, and only in 2000
    mutate(status = factor(status,
                           levels = c("Single (never married)",
                                      "Married",
                                      "Widowed and not remarried",
                                      "Divorced and not remarried"),
                           labels = c("Single",
                                      "Married",
                                      "Widowed",
                                      "Divorced"))) %>%
    mutate(count = ifelse(time %in% c(2000, 2010), count * 10, count)) ## marriage only asked on long form
                                                                       ## given to 10% of respondents

saveRDS(marriage_status_df,
        file = "out/marriage_status_df.rds")

           
