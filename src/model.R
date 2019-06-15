
library(methods)
library(demest)
library(docopt)

account <- readRDS("out/account.rds")
system_models <- readRDS("out/system_models.rds")
datasets <- readRDS("out/datasets.rds")
data_models <- readRDS("out/data_models.rds")
concordances <- readRDS("out/concordances.rds")

'
Usage:
model.R [options]

Options:
--n_burnin [default: 5]
--n_sim [default: 5]
--n_chain [default: 4]
--n_thin [default: 1]
' -> doc
opts <- docopt(doc)
n_burnin <- as.integer(opts$n_burnin)
n_sim <- as.integer(opts$n_sim)
n_chain <- as.integer(opts$n_chain)
n_thin <- as.integer(opts$n_thin)

set.seed(0)

filename <- "out/model.est"

Sys.time()
estimateAccount(account = account,
                systemModels = system_models,
                datasets = datasets,
                dataModels = data_models,
                concordances = concordances,
                filename = filename,
                nBurnin = n_burnin,
                nSim = n_sim,
                nChain = n_chain,
                nThin = n_thin)
Sys.time()
options(width = 120)
fetchSummary(filename)
                   
