
library(methods)
library(demest)
library(dplyr)
library(latticeExtra)
library(coda)
library(docopt)

'
Usage:
fig_mcmc.R [options]

Options:
--series [default: population]
' -> doc
opts <- docopt(doc)
series <- opts$series

series_mcmc <- fetchMCMC("out/model.est",
                         where = c("account", series),
                         nSample = Inf)
names_cells <- dimnames(series_mcmc[[1L]])[[2L]]

cell_levels <- fetch("out/model.est",
                     where = c("account", series)) %>%
    subarray(iteration == 1) %>%
    dimnames() %>%
    expand.grid(stringsAsFactors = FALSE) %>%
    split(f = select(., -age, -sex))

n_cell <- length(cell_levels)

ans <- vector(mode = "list", length = n_cell)
names(ans) <- names(cell_levels)
for (i in seq_len(n_cell)) {
    comb_factors <- cell_levels[[i]]
    names_cells_i <- do.call(function(...) paste(..., sep = "."), comb_factors)
    i_cells <- match(names_cells_i, names_cells, nomatch = 0L)
    if (any(i_cells > 0L)) {
        mcmc_list <- series_mcmc[, i_cells]
        mcmc_list <- as.mcmc.list(lapply(mcmc_list, as.mcmc))
        p <- xyplot(mcmc_list,
                    main = names(ans)[i],
                    layout = c(2, NA),
                    par.settings = list(fontsize = list(text = 6),
                                        strip.background = list(col = "grey90")),
                    as.table = TRUE)
        N <- dim(p)
        idx <- as.integer(t(matrix(seq_len(N), ncol = 2)))
        p <- p[idx]
        ans[[i]] <- p
    }
}

ans <- ans[!sapply(ans, is.null)]

file <- sprintf("out/fig_mcmc_%s.pdf",
                series)
pdf(file = file,
    paper = "a4",
    width = 0,
    height = 0)
for (i in seq_along(ans))
    plot(ans[[i]])
dev.off()
