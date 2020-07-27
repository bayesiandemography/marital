
library(dplyr)
library(tidyr)
library(magrittr)
library(readxl)
library(dembase)


lifeexp_un <- read_xlsx("data-raw/LifeExpectancy-20200727034920.xlsx",
                       sheet = 2,
                       skip = 1) %>%
    slice(-(1:4)) %>%
    select(sex = Sex, `1990 - 1995`:`2010 - 2015`) %>%
    gather(key = time, value = value, -sex) %>%
    separate(col = time, into = c("start", "end"), convert = TRUE) %>%
    mutate(time = paste(start - 1, end, sep = "-")) %>%
    filter(sex != "Both sexes combined") %>%
    dtabs(value ~ sex + time)

save(lifeexp_un,
     file = "data/lifeexp_un.rda")
