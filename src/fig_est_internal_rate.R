
library(methods)
library(demest)
library(dplyr)
library(latticeExtra)
library(docopt)

'
Usage:
fig_est_internal_rate.R [options]

Options:
--status_orig [default: Single]
--status_dest [default: Married]
' -> doc
opts <- docopt(doc)
STATUS_ORIG <- opts$status_orig
STATUS_DEST <- opts$status_dest

exposure <- fetch("out/model.est",
                  where = c("account", "population")) %>%
    addPair(base = "status") %>%
    subarray(status_orig == STATUS_ORIG) %>%
    subarray(status == STATUS_DEST) %>%
    exposure(triangles = TRUE)


internal <- fetch("out/model.est",
                  where = c("system", "internal", "likelihood", "rate"))

p <- dplot(~ age | factor(time) + sex,
           data = internal,
           weights = exposure,
           subarray = status_orig == STATUS_ORIG & status_dest == STATUS_DEST,
           main = sprintf("Estimated internal rates : \"%s\" to \"%s\"", STATUS_ORIG, STATUS_DEST),
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


file <- sprintf("out/fig_est_internal_rate_%s_%s.pdf",
                tolower(STATUS_ORIG), tolower(STATUS_DEST))
pdf(file = file,
    w = 4.5,
    h = 3.4)
plot(p)
dev.off()
