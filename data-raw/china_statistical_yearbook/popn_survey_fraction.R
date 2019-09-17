
popn_survey_fraction <- array(c(0.01325, 0.0155),
                              dim = 2,
                              dimnames = list(time = c(2005, 2015)))

save(popn_survey_fraction,
     file = "data/popn_survey_fraction.rda")
