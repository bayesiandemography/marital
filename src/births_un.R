
library(methods)
library(docopt)
library(dplyr)
library(magrittr)
library(tidyr)
library(readxl)
library(dembase)

'
Usage:
births_un.R [options]

Options:
--denom [default: 1000]
' -> doc
opts <- docopt(doc)
denom <- opts$denom %>% as.integer()

births_un <- read_xlsx("data/NumberBirthsAgeMother-20171130020714.xlsx",
                       sheet = 2,
                       skip = 1) %>%
    filter(Location == "China") %>%
    gather(key = "age", value = "count", `15-19`:`45-49`) %>%
    select(age = age, time = Time, count) %>%
    tidyr::extract(col = time, into = c("start", "stop"),
                   regex = "([:digit:]+) - ([:digit:]+)",
                   convert = TRUE) %>%
    mutate(start = start + 1) %>%
    unite(col = time, start, stop, sep = "-", remove = TRUE) %>%
    dtabs(count ~ age + time) %>%
    Counts() %>%
    multiply_by(1000) %>% # births reported in thousands
    divide_by(denom) %>%
    toInteger(force = TRUE)

## Assume that births only occur to married women,
## and that all children are born single
births_un <- births_un %>%
    addDimension(name = c("status_parent", "status_child"),
                 labels = c("Single", "Married", "Divorced", "Widowed"))
slab(births_un,
     dimension = "status_parent",
     elements = c("Single", "Divorced", "Widowed")) <- 0L
slab(births_un,
     dimension = "status_child",
     elements = c("Married", "Divorced", "Widowed")) <- 0L

saveRDS(births_un,
        file = "out/births_un.rds")
