
library(methods)
library(demest)

married_census_1990 <- readRDS("out/married_1990.rds")
married_census_1995_2010 <- readRDS("out/married_1995_2010.rds")
births_un <- readRDS("out/births_un.rds")
deaths_un <- readRDS("out/deaths_un.rds")
marriages_divorces <- readRDS("out/marriages_divorces.rds")
remarriages <- readRDS("out/remarriages.rds")

mean_married_census_1990 <- Values(married_census_1990,
                                   dimscales = c(time = "Points"))
mean_married_census_1990[] <- 1
sd_married_census_1990 <- 0.025 * Values(married_census_1990,
                                         dimscales = c(time = "Points"))
sd_married_census_1990[c("15-19", "20-24"),,,] <- sd_married_census_1990[c("15-19", "20-24"),,,] + 1
married_census_1990 <- Model(married_census_1990 ~ NormalFixed(mean = mean_married_census_1990,
                                                               sd = sd_married_census_1990),
                             series = "population")

mean_married_census_1995_2010 <- Values(married_census_1995_2010)
mean_married_census_1995_2010[] <- 1
sd_married_census_1995_2010 <- 0.025 * Values(married_census_1995_2010)
sd_married_census_1995_2010[c("15-19", "20-24"),,,] <- sd_married_census_1995_2010[c("15-19", "20-24"),,,] + 1
married_census_1995_2010 <- Model(married_census_1995_2010 ~ NormalFixed(mean = mean_married_census_1995_2010,
                                                                         sd = sd_married_census_1995_2010),
                                  series = "population")

mean_births_un <- Values(births_un)
mean_births_un[] <- 1
sd_births_un <- 0.025 * Values(births_un)
births_un <- Model(births_un ~ NormalFixed(mean = mean_births_un,
                                           sd = sd_births_un),
                   series = "births")

mean_deaths_un <- Values(deaths_un)
mean_deaths_un[] <- 1
sd_deaths_un <- 0.025 * Values(deaths_un)
deaths_un <- Model(deaths_un ~ NormalFixed(mean = mean_deaths_un,
                                           sd = sd_deaths_un),
                   series = "deaths")

mean_marriages_divorces <- Values(marriages_divorces)
mean_marriages_divorces[] <- 1
sd_marriages_divorces <- 0.025 * Values(marriages_divorces)
sd_marriages_divorces[is.na(sd_marriages_divorces)] <- 1
marriages_divorces <- Model(marriages_divorces ~ NormalFixed(mean = mean_marriages_divorces,
                                                             sd = sd_marriages_divorces),
                            series = "internal")

mean_remarriages <- Values(remarriages)
mean_remarriages[] <- 1
sd_remarriages <- 0.025 * Values(remarriages)
remarriages <- Model(remarriages ~ NormalFixed(mean = mean_remarriages,
                                               sd = sd_remarriages),
                     series = "internal")

data_models <- list(married_census_1990,
                    married_census_1995_2010,
                    births_un,
                    deaths_un,
                    marriages_divorces,
                    remarriages)

saveRDS(data_models,
        file = "out/data_models.rds")


                             




                






                 
