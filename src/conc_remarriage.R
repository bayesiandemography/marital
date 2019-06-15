
library(dplyr)
library(dembase)

conc_remarriage <- data.frame(from = c("Single", "Married", "Divorced", "Widowed"),
                              to = c("Single", "Married", "Divorced or widowed", "Divorced or widowed")) %>%
    Concordance()

saveRDS(conc_remarriage,
        file = "out/conc_remarriage.rds")








