
library(dplyr)
library(dembase)

marriages_divorces_remarriages_df <- readRDS("data-raw/marriages_divorces_remarriages_df.rds")

remarriages <- marriages_divorces_remarriages_df %>%
    filter(event == "Remarriage") %>%
    mutate(status_orig = "Divorced or widowed",
           status_dest = "Married") %>%
    dtabs(count ~ status_orig + status_dest + time) %>%
    Counts(dimscale = c(time = "Intervals")) %>%
    collapseIntervals(dimension = "time", width = 5) %>%
    toInteger()

save(remarriages,
     file = "data/remarriages.rda")








