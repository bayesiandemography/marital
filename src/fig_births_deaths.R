
library(methods)
library(docopt)
library(dembase)
library(dplyr)
library(latticeExtra)

'
Usage:
fig_popn.R [options]

Options:
--denom [default: 1000]
' -> doc
opts <- docopt(doc)
denom <- opts$denom %>% as.integer()

births <- readRDS("out/births_un.rds") %>%
    collapseDimension(dimension = "age")

deaths <- readRDS("out/deaths_un.rds") %>%
    collapseDimension(dimension = c("age", "sex"))

births_deaths <- dbind(Births = births,
                       Deaths = deaths,
                       along = "variant")
births_deaths <- (1/5) * births_deaths # convert to annual
births_deaths <- 1e-6 * denom * births_deaths

col <- c("black", "dark grey")
p <- dplot(count ~ time,
           data = births_deaths,
           subarray = variant == "Births",
           col = col[1],
           ylim = c(-1, 26),
           xlab = "",
           ylab = "",
           lwd = 1,
           scales = list(tck = 0.4),
           as.table = TRUE,
           par.settings = list(fontsize = list(text = 6),
                               strip.background = list(col = "grey90")),
           key = list(text = dimnames(births_deaths)["variant"],
                      lines = list(col = col),
                      space = "top"))
p <- p + as.layer(dplot(count ~ time,
                        data = births_deaths,
                        subarray = variant == "Deaths",
                        lwd = 1.5,
                        col = col[2]))

             
pdf(file = "out/fig_births_deaths.pdf",
    w = 2.3,
    h = 1.6)
plot(p)
dev.off()


