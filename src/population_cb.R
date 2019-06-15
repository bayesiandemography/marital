
library(methods)
library(docopt)
library(dplyr)
library(magrittr)
library(tidyr)
library(readr)
library(dembase)

## Data come from the US Census Bureau International Data Base,
## table "Mid-year Population by Five Year Age Groups and Sex",
## downloaded on 28 March 2019.


'
Usage:
population_cb.R [options]

Options:
--denom [default: 1000]
' -> doc
opts <- docopt(doc)
denom <- as.integer(opts$denom)


population_cb <- read_csv("data/census_data_20190327_5c9c3633ee912.csv",
                          skip = 1) %>%
    select(time = Year, age = Age, Male = `Male Population`, Female = `Female Population`) %>%
    filter(age != "Total") %>%
    gather(key = sex, value = count, Male, Female) %>%
    dtabs(count ~ age + sex + time) %>%
    Counts() %>%
    divide_by(denom)

saveRDS(population_cb,
        file = "out/population_cb.rds")
