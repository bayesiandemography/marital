
library(methods)
library(demest)

conc_remarriage <- readRDS("out/conc_remarriage.rds")

concordances <- list(remarriages = list(status_orig = conc_remarriage))

saveRDS(concordances,
        file = "out/concordances.rds")
                   
