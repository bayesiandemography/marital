
library(methods)
library(dembase)
library(dplyr)
library(magrittr)
library(ggplot2)
library(docopt)

'
Usage:
fig_data_births_un.R [options]

Options:
--denom [default: 1000]
' -> doc
opts <- docopt(doc)
denom <- opts$denom %>% as.integer()

data <- readRDS("out/births_un.rds") %>%
    collapseDimension(margin = c("age", "time")) %>%
    as.data.frame(midpoints = "age") %>%
    mutate(count = count * denom * 1e-6)

plot_theme <- readRDS("out/plot_theme.rds")

p <- ggplot(data, aes(x = age, y = count)) +
    facet_wrap(vars(time), nrow = 1) +
    geom_line() +
    ylim(0, NA) +
    xlab("Age") +
    ylab("Births (millions)") +
    plot_theme

graphics.off()
pdf(file = "out/fig_data_births_un.pdf",
    width = 4.8,
    height = 2.1)
plot(p)
dev.off()

