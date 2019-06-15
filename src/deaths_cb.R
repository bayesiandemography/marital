
library(methods)
library(docopt)
library(dplyr)
library(magrittr)
library(readr)
library(dembase)

## Data come from the US Census Bureau International Data Base,
## table "Components of Population Growth",
## downloaded on 28 March 2019.

'
Usage:
deaths_cb.R [options]

Options:
--denom [default: 1000]
' -> doc
opts <- docopt(doc)
denom <- opts$denom %>% as.integer()

deaths_cb_1990_2009 <- read_csv("data/census_data_20190327_5c9c35cc5727c.csv",
                                skip = 1) %>%
    select(time = Year, count = Deaths)

deaths_cb_2010_2015 <- read_csv("data/census_data_20190327_5c9c35eb3d35a.csv",
                                skip = 1) %>%
    select(time = Year, count = Deaths)

deaths_cb <- bind_rows(deaths_cb_1990_2009, deaths_cb_2010_2015) %>%
    filter(time > 1990) %>%
    dtabs(count ~ time) %>%
    Counts(dimscales = c(time = "Intervals")) %>%
    collapseIntervals(dimension = "time", width = 5) %>%
    divide_by(denom) %>%
    toInteger(force = TRUE)

saveRDS(deaths_cb,
        file = "out/deaths_cb.rds")
