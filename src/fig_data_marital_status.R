
library(methods)
library(dembase)
library(dplyr)
library(magrittr)
library(ggplot2)
library(docopt)

'
Usage:
fig_data_married.R [options]

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
Total <- married %>%
    collapseDimension(dimension = "status")

married <- dbind(married,
                 Total,
                 along = "status") %>%
    multiply_by(1e-6 * denom) %>%
    as.data.frame(midpoints = "age", stringsAsFactors = FALSE) %>%
    mutate(status = factor(status, levels = levels_status))

p <- ggplot(married, aes(x = age, y = count, linetype = sex)) +
    facet_grid(rows = vars(status), cols = vars(time), scales = "free_y") +
    geom_line() +
    ylim(0, NA) +
    xlab("Age") +
    ylab("Population (millions)") +
    plot_theme

graphics.off()
pdf(file = "out/fig_data_marital_status.pdf",
    width = 4.8,
    height = 4.8)
plot(p)
dev.off()

