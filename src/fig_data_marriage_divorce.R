
library(methods)
library(dembase)
library(dplyr)
library(magrittr)
library(ggplot2)
library(docopt)

'
Usage:
fig_data_marriage_divorce_widow.R [options]

Options:
--denom [default: 1000]
' -> doc
opts <- docopt(doc)
denom <- opts$denom %>% as.integer()

marriages_divorces <- readRDS("out/marriages_divorces_df.rds") %>%
    mutate(count = 1e-6 * denom * count)

plot_theme <- readRDS("out/plot_theme.rds")

p <- ggplot(marriages_divorces, aes(x = time, y = count, linetype = event)) +
    geom_line() +
    xlab("Year") +
    ylab("Events (millions)") +
    plot_theme

graphics.off()
pdf(file = "out/fig_data_marriage_divorce.pdf",
    width = 4.2,
    height = 2.5)
plot(p)
dev.off()

