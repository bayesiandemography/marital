
library(methods)
library(ggplot2)

plot_theme <- theme(legend.title = element_blank(),
                    legend.position = "top",
                    text = element_text(size = 8),
                    axis.text = element_text(size = 6),
                    axis.title = element_text(size = 7))

saveRDS(plot_theme,
        file = "out/plot_theme.rds")
