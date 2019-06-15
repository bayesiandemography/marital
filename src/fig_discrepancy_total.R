
library(methods)
library(dembase)
library(dplyr)
library(magrittr)
library(ggplot2)
library(docopt)

'
Usage:
fig_discrepancy_total.R [options]

Options:
--denom [default: 1000]
' -> doc
opts <- docopt(doc)
denom <- opts$denom %>% as.integer()

married_census_1990 <- readRDS("out/married_1990.rds") %>%
    collapseDimension(dimension = "status")
married_census_1995_2010 <- readRDS("out/married_1995_2010.rds") %>%
    collapseDimension(dimension = "status") %>%
    collapseIntervals(dimension = "age", breaks = seq(0, 60, 5))

plot_theme <- readRDS("out/plot_theme.rds")

popn <- 


popn <- dbind(married_census_1990,
              married_census_1995_2010,
              along = "time") %>%
    as.data.frame(midpoints = "age") %>%
    mutate(cohort = time - age)



ggplot(popn, aes(x = time, y = count, color = sex)) +
    facet_wrap(vars(cohort)) +
    geom_line()
