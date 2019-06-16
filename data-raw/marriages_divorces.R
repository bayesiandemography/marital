
library(dplyr)
library(tidyr)
library(dembase)

marriages_divorces_remarriages_df <- readRDS("data-raw/marriages_divorces_remarriages_df.rds")

levels_status <- c("Single",
                   "Married",
                   "Divorced",
                   "Widowed")

sex <- c("Female", "Male")
time <- unique(marriages_divorces_remarriages_df$time)

SS <- crossing(sex, time, status_orig = "Single", status_dest = "Single", count = 0)

SM <- crossing(sex, time, status_orig = "Single", status_dest = "Married") %>%
    left_join(filter(marriages_divorces_remarriages_df, event == "First marriage"), by = c("time" = "time")) %>%
    mutate(count = count / 2) %>% # because splitting between 2 sexes
    select(sex, time, status_orig, status_dest, count)

SD <- crossing(sex, time, status_orig = "Single", status_dest = "Divorced", count = 0)

SW <- crossing(sex, time, status_orig = "Single", status_dest = "Widowed", count = 0)

MS <- crossing(sex, time, status_orig = "Married", status_dest = "Single", count = 0)

MM <- crossing(sex, time, status_orig = "Married", status_dest = "Married", count = 0)

MD <- crossing(sex, time, status_orig = "Married", status_dest = "Divorced") %>%
    left_join(filter(marriages_divorces_remarriages_df, event == "Divorce"), by = c("time" = "time")) %>%
    mutate(count = count / 2) %>% # because splitting between 2 sexes
    select(sex, time, status_orig, status_dest, count)

MW <- crossing(sex, time, status_orig = "Married", status_dest = "Widowed", count = NA)

DS <- crossing(sex, time, status_orig = "Divorced", status_dest = "Single", count = 0)

DM <- crossing(sex, time, status_orig = "Divorced", status_dest = "Married", count = NA) # can't separated from widowed remarrying

DD <- crossing(sex, time, status_orig = "Divorced", status_dest = "Divorced", count = 0)

DW <- crossing(sex, time, status_orig = "Divorced", status_dest = "Widowed", count = 0)

WS <- crossing(sex, time, status_orig = "Widowed", status_dest = "Single", count = 0)

WM <- crossing(sex, time, status_orig = "Widowed", status_dest = "Married", count = NA) # can't separated from divorced remarrying

WD <- crossing(sex, time, status_orig = "Widowed", status_dest = "Divorced", count = 0)

WW <- crossing(sex, time, status_orig = "Widowed", status_dest = "Widowed", count = 0)

marriages_divorces <- bind_rows(SS, SM, SD, SW,
                                MS, MM, MD, MW,
                                DS, DM, DD, DW,
                                WS, WM, WD, WW) %>%
    mutate(status_orig = factor(status_orig, levels = levels_status),
           status_dest = factor(status_dest, levels = levels_status)) %>%
    dtabs(count ~ status_orig + status_dest + sex + time) %>%
    Counts(dimscales = c(time = "Intervals")) %>%
    collapseIntervals(dimension = "time", width = 5) %>%
    toInteger(force = TRUE)

save(marriages_divorces,
     file = "data/marriages_divorces.rda")








