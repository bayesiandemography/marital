
library(methods)
library(dembase)
library(docopt)
library(dplyr)
library(tidyr)
library(readxl)

'
Usage:
popn_df.R [options]

Options:
--denom [default: 1000]
' -> doc
opts <- docopt(doc)
denom <- opts$denom %>% as.integer()

sixty_plus <- c("60-64", "65-69", "70-74", "75-79", "80-84", "85-89", "90-94", "95-99", "100+")
sixty_five_plus <- sixty_plus[-1]
popn_df <- read_xlsx("data/PopulationAgeSex-20171128124220.xlsx",
                     sheet = 2,
                     skip = 1) %>%
    filter(Location == "China") %>%
    filter(Time %in% seq(1990, 2010, 5)) %>%
    gather(key = "age", value = "count", `0-4`:`100+`) %>%
    select(age, sex = Sex, time = Time, count) %>%
    mutate(count = count * 1000 / denom) %>%
    mutate(age = ifelse((time == 1990) & (age %in% sixty_plus), "60+", age)) %>%
    mutate(age = ifelse((time > 1990) & (age %in% sixty_five_plus), "65+", age)) %>%
    group_by(age, sex, time) %>%
    summarise(count = sum(count))

saveRDS(popn_df,
        file = "out/popn_df.rds")
           
