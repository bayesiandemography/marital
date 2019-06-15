
library(methods)
library(dplyr)
library(tidyr)
library(readr)
library(dembase)
library(docopt)

'
Usage:
marriages_divorces_df.R [options]

Options:
--denom [default: 1000]
' -> doc
opts <- docopt(doc)
denom <- as.integer(opts$denom)

marriages_divorces_df <- read_csv("data/Marriage_Divorce.csv") %>%
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
           count = ifelse(event == "Divorce", (20000 / denom) * count, (10000 / denom) * count)) %>%
    mutate(count = as.integer(count)) %>%
    arrange(event, time)

saveRDS(marriages_divorces_df,
        file = "out/marriages_divorces_df.rds")
           
