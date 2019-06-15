
library(methods)
library(dembase)
library(dplyr)
library(magrittr)
library(ggplot2)
library(docopt)

'
Usage:
fig_discrepancy_married.R [options]

Options:
--denom [default: 1000]
' -> doc
opts <- docopt(doc)
denom <- opts$denom %>% as.integer()

levels_status <- c("Single", "Married", "Divorced", "Widowed", "Total")

married_census_1990 <- readRDS("out/married_1990.rds")
married_census_1995_2010 <- readRDS("out/married_1995_2010.rds")

plot_theme <- readRDS("out/plot_theme.rds")

married <- dbind(married_census_1990,
                 married_census_1995_2010,
                 along = "time")


    as.data.frame(midpoints = "age") %>%
    mutate(cohort = time - age)

marriages_divorces <- readRDS("out/marriages_divorces_df.rds") %>%
    mutate(time2 = cut(time, breaks = seq(1991, 2016, 5), right = FALSE)) %>%
    count(event, time2, wt = count)





ggplot(filter(married, status == "Single" & age != "62.5"), aes(x = time, y = count, color = sex)) +
    facet_wrap(vars(cohort)) +
    geom_line()
