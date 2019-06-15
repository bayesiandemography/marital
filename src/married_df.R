
## Initial processing of data on distribution of population by marital status.

library(methods)
library(dembase)
library(dplyr)
library(tidyr)
library(readxl)
library(docopt)

'
Usage:
married_df.R [options]

Options:
--pc_imputed [default: 0.025]
' -> doc
opts <- docopt(doc)
pc_imputed <- opts$pc_imputed %>% as.numeric()

married_df <- read_xlsx("data/World_Marriage_Data_2015.xlsx") %>%
    select(time = "Year Start", age = "Age Group", sex = Sex,
           status = "Marital Status", percent = "Data Value") %>%
    filter(time >= 1990) %>%
    filter(time <= 2010) %>% # excludes data for 2013
    mutate(age = gsub("\\[|\\]", "", age)) %>%
    mutate(sex = factor(sex, levels = c("Women", "Men"), labels = c("Female", "Male"))) %>%
    mutate(status = recode(status, "Consensual union" = "Married"),
           status = factor(status, levels = c("Single", "Married", "Divorced", "Widowed")))

under15 <- crossing(time = unique(married_df$time),
                    age = c("0-4", "5-9", "10-14"),
                    sex = factor(levels(married_df$sex), levels = levels(married_df$sex)),
                    status = "Single",
                    percent = 100) %>%
    mutate(status = factor("Single", levels = levels(married_df$status)))

married_df <- married_df %>%
    bind_rows(under15)

## Assume that, for ages 15-24, values of 0 have been rounded
## down from a value less than 'pc_imputed'. We may revisit this
## assumption in future.

married_df <- married_df %>%
    mutate(percent = ifelse(age %in% c("15-19", "20-24") & percent == 0,
                            pc_imputed,
                            percent))

## check that, when summing across statuses, all age-sex-time cells
## for age < 60 within 0.2 of 100%

summed_statuses <- married_df %>%
    filter(!(age %in% c("60+", "60-64", "65+"))) %>%
    dtabs(percent ~ age + sex + time)
stopifnot(all(abs(summed_statuses - 100) <= 0.2))

## 60+ equal to 100 for 1990
summed_statuses <- married_df %>%
    filter(age == "60+") %>%
    filter(time == 1990) %>%
    dtabs(percent ~ age + sex + time)
stopifnot(all(abs(summed_statuses - 100) <= 0.2))

## 60-64, 65+ equal to 100 for 1995+
summed_statuses <- married_df %>%
    filter(age %in% c("60-64", "65+")) %>%
    filter(time > 1990) %>%
    dtabs(percent ~ age + sex + time)
stopifnot(all(abs(summed_statuses - 100) <= 0.2))

saveRDS(married_df,
        file = "out/married_df.rds")
           
