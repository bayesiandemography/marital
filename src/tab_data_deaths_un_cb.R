
library(methods)
library(dembase)
library(dplyr)
library(xtable)
library(docopt)

'
Usage:
fig_data_deaths_un.R [options]

Options:
--denom [default: 1000]
' -> doc
opts <- docopt(doc)
denom <- opts$denom %>% as.integer()

data_un <- readRDS("out/deaths_un.rds") %>%
    collapseDimension(margin = "time") %>%
    as.data.frame() %>%
    mutate(count = count * denom * 1e-6) %>%
    rename("United Nations" = count)

data_cb <- readRDS("out/deaths_cb.rds") %>%
    as.data.frame() %>%
    mutate(count = count * denom * 1e-6) %>%
    rename("Census Bureau" = count)

data <- left_join(data_un, data_cb, by = "time") %>%
    rename(Period = time)

xt <- xtable(data,
             label = "tab:data_deaths_un_cb",
             caption = "United Nations and US Census Bureau estimates of deaths",
             digits = 1)

print(xt,
      file = "out/tab_data_deaths_un_cb.tex",
      include.rownames = FALSE,
      caption.placement = "top")


