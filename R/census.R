
#' Chinese census population counts by age, sex, and marital status,
#'
#' Census data on population counts by age, sex, and marital status,
#' for 1990, 2000, and 2010. The marital statuses are 
#' "Single", "Married", "Divorced", and "Widowed".
#' The maximum age group is 60+.
#'
#' We created the dataset by combining data obtained from two
#' UN online database. One database had counts by age and sex,
#' for all ages, and the other had counts by age, sex,
#' and marital status for ages 15+. The totals for age and sex
#' from the second database were slightly lower than those from
#' the first in 2000 and 2010. We have scaled the counts
#' from the second database to match those from the first.
#' 
#' @format An array with dimensions "age",
#' "sex", "status", and "time".
#'
#' @source Derived from table "Population by age, sex
#' and urban/rural residence"
#' in the United Nations Statistics Division online database
#' "Population Censuses Datasets (1995 - Present)", 
#' downloaded on 21 January 2018, and table "Population by marital status,
#' age, sex and urban/rural residence"
#' in the United Nations Statistics Division online database
#' "Demographic Statistics Database", downloaded on 14 June 2019.
"census"
