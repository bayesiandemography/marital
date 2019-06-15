
library(methods)
library(demest)
library(dplyr)
library(latticeExtra)
library(docopt)

'
Usage:
fig_est_internal_count.R [options]

Options:
--status_orig [default: Single]
--status_dest [default: Married]
' -> doc
opts <- docopt(doc)
STATUS_ORIG <- opts$status_orig
STATUS_DEST <- opts$status_dest

internal <- fetch("out/model.est",
                  where = c("account", "internal"))

p <- dplot(~ age | factor(time) + sex,
           data = internal,
           subarray = status_orig == STATUS_ORIG & status_dest == STATUS_DEST,
           main = sprintf("Estimated internal counts : \"%s\" to \"%s\"", STATUS_ORIG, STATUS_DEST),
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


file <- sprintf("out/fig_est_internal_count_%s_%s.pdf",
                tolower(STATUS_ORIG), tolower(STATUS_DEST))
pdf(file = file,
    w = 4.5,
    h = 3.4)
plot(p)
dev.off()
