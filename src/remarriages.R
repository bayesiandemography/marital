
library(dplyr)
library(dembase)

marriages_divorces_df <- readRDS("out/marriages_divorces_df.rds")

remarriages <- marriages_divorces_df %>%
    filter(event == "Remarriage") %>%
    mutate(status_orig = "Divorced or widowed",
           status_dest = "Married") %>%
    xtabs(count ~ status_orig + status_dest + time, .) %>%
    Counts(dimscale = c(time = "Intervals")) %>%
    collapseIntervals(dimension = "time", width = 5) %>%
    toInteger()

saveRDS(remarriages,
        file = "out/remarriages.rds")








