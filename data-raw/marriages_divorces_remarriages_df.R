
library(methods)
library(dplyr)
library(tidyr)
library(readr)
library(dembase)

marriages_divorces_remarriages_df <- read_csv("data-raw/Marriage_Divorce.csv") %>%
    gather(key = "time", value = "count", `2015`:`1985`, convert = TRUE) %>%
    filter(time > 1990) %>%
    rename(event = X1) %>%
    filter(event %in% c("IMarriage_First_Mainland(10,000)",
                        "IMarriage_Re_Mainland(10,000)",
                        "PDivorce(10,000)")) %>%
    mutate(event = recode_factor(event,
                                 "IMarriage_First_Mainland(10,000)" = "First marriage",
                                 "IMarriage_Re_Mainland(10,000)" = "Remarriage",
                                 "PDivorce(10,000)" = "Divorce"),
           count = ifelse(event == "Divorce", 20000 * count, 10000 * count)) %>%
    mutate(count = as.integer(count)) %>%
    arrange(event, time)

saveRDS(marriages_divorces_remarriages_df,
        file = "data-raw/marriages_divorces_remarriages_df.rds")
           
