
library(methods)

conc_marital_status <- data.frame(from = c("Single",
                                           "Married",
                                           "Divorced",
                                           "Widowed"),
                                  to = c("Single",
                                         "Married",
                                         "Divorced or widowed",
                                         "Divorced or widowed"))

save(conc_marital_status,
     file = "data/conc_marital_status.rda")








