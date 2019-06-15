
library(methods)
library(demest)
library(dplyr)
library(latticeExtra)
library(docopt)

'
Usage:
fig_est_population.R [options]

Options:
--status [default: Single]
' -> doc
opts <- docopt(doc)
STATUS <- opts$status

population <- fetch("out/model.est",
                    where = c("account", "population"))

p <- dplot(~ age | factor(time) + sex,
           data = population,
           subarray = status == STATUS,
           main = sprintf("Estimated population : \"%s\"", STATUS),
           midpoints = "age",
           col = "dark blue",
           prob = c(0.025, 0.975),
           xlab = "",
           ylab = "",
           as.table = TRUE,
           na.rm = TRUE,
           par.settings = list(fontsize = list(text = 6),
                               strip.background = list(col = "grey90"))) %>%
    useOuterStrips() +
    latticeExtra::layer(panel.grid(h = -1, v = -1), under = TRUE)


file <- sprintf("out/fig_est_population_%s.pdf",
                tolower(STATUS))
pdf(file = file,
    w = 4.5,
    h = 3.4)
plot(p)
dev.off()
