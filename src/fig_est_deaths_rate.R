
library(methods)
library(demest)
library(dplyr)
library(latticeExtra)
library(docopt)

'
Usage:
fig_est_deaths_rate.R [options]

Options:
--status [default: Single]
' -> doc
opts <- docopt(doc)
STATUS <- opts$status

deaths <- fetch("out/model.est",
                where = c("system", "deaths", "likelihood", "rate"))

exposure <- fetch("out/model.est",
                  where = c("account", "population")) %>%
    subarray(status == STATUS) %>%
    exposure(triangles = TRUE)


p <- dplot(~ age | factor(time) + sex,
           data = deaths,
           weights = exposure,
           subarray = status == STATUS,
           main = sprintf("Estimated death rates : \"%s\"", STATUS),
           midpoints = "age",
           col = "dark blue",
           xlab = "",
           ylab = "",
           as.table = TRUE,
           na.rm = TRUE,
           par.settings = list(fontsize = list(text = 6),
                               strip.background = list(col = "grey90"))) %>%
    useOuterStrips() +
    latticeExtra::layer(panel.grid(h = -1, v = -1), under = TRUE)


file <- sprintf("out/fig_est_deaths_rate_%s.pdf",
                tolower(STATUS))
pdf(file = file,
    w = 4.5,
    h = 3.4)
plot(p)
dev.off()
