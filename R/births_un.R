
#' Estimates of births in China from the UN Population Division
#'
#' Total numbers of births in China, by age and 5-year period, as estimated
#' by the United Nations Population Division.
#'
#' We assume that children are born single, and that all births
#' are to married women. Because married
#' women must be aged 20 or higher, we recode births to 15-19 year
#' olds as births to 20-24 year olds.
#'
#' @format An array with dimensions "status_parent",
#' "status_child", "age", and "time"
#'
#' @source Table "Number of births by age of mother (thousands)"
#' in the United Nations Population Division online database
#' "World Population Prospects".
#' Data  downloaded on 30 November 2017.
"births_un"
