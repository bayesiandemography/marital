
library(methods)
library(dplyr)
library(tidyr)
library(readr)
library(dembase)
library(docopt)

'
Usage:
population_cb.R [options]

Options:
--age_max [default: 75]
' -> doc
opts <- docopt(doc)
age_max <- opts$age_max %>% as.integer()
    
age_breaks <- seq(0, age_max, 5)

population_cb <- read_csv("data-raw/census_data_20190327_5c9c3633ee912.csv",
                          skip = 1) %>%
    select(time = Year, age = Age, Male = `Male Population`, Female = `Female Population`) %>%
    filter(age != "Total") %>%
    gather(key = sex, value = count, Male, Female) %>%
    dtabs(count ~ age + sex + time) %>%
    Counts() %>%
    collapseIntervals(dimension = "age", breaks = age_breaks) %>%
    as.array()

save(population_cb,
     file = "data/population_cb.rda")
