
library(methods)
library(dplyr)
library(dembase)

marital_status_df <- readRDS("data-raw/marital_status_df.rds")

marital_status_2000_2010 <- marital_status_df %>%
    filter(time != 1990) %>%
    dtabs(count ~ status + age + sex + time)


save(marital_status_2000_2010,
     file = "data/marital_status_2000_2010.rda")

           
