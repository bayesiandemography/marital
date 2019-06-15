
library(methods)
library(demest)
library(dplyr)
library(latticeExtra)

births <- fetch("out/model.est",
                where = c("system", "births", "likelihood", "rate"))

exposure <- fetch("out/model.est",
                  where = c("account", "population")) %>%
    subarray(sex == "Female") %>%
    subarray(status == "Married") %>%
    subarray(age > 15 & age < 50) %>%
    exposure(triangles = TRUE)


p <- dplot(~ age | factor(time) + sex,
           data = births,
           subarray = status_parent == "Married" & status_child == "Single",
           weights = exposure,
           main = "Estimated birth rates",
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


file <- "out/fig_est_births_rate.pdf"
pdf(file = file,
    w = 4.5,
    h = 3.4)
plot(p)
dev.off()
