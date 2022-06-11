
#' Load ISPV Excel files with regional data
#'
#' Loads one or more local Excel files downloaded from ISPV links retrieved by `pv_list_reg()`.
#'
#' @param path path to one or more Excel files (character vector length one or more).
#'
#' @return a tibble, see Format for details.
#'
#' @format A data frame with 53940 rows and 10 variables:
#' \describe{
#'  \item{price}{price, in US dollars}
#'  \item{carat}{weight of the diamond, in carats}
#'   ...
#' }
#' @source \url{http://www.diamondse.info/}
#'
#' @export
#' @examples
#' pv_load_reg(system.file("extdata", "Kar_204_pls.xlsx", package = "ispv"))
pv_load_reg <- function(path) {

  names(path) <- path

  ispv_all <- purrr::map_dfr(path, function(x) {

    dt <- readxl::read_excel(x, sheet = 4, skip = 11,
                             col_names = c("isco4_full", "count", "pay_median",
                                           "d1", "q1", "q3", "d9", "pay_mean",
                                           "bonus_perc", "expenses_perc", "comp_perc",
                                           "hours_per_month"))

    return(dt)
  }, .id = "file")

  ispv_all$sfera <- regmatches(ispv_all$file, regexpr("mzs|pls", ispv_all$file))
  ispv_all$kraj <- regmatches(ispv_all$file, regexpr("[A-Z][a-z]{2}", ispv_all$file))
  ispv_all$period <- regmatches(ispv_all$file, regexpr("2[0-9]4", ispv_all$file))
  ispv_all$rok <- paste0("20", substr(ispv_all$period, 1, 2))
  ispv_all$isco4_kod <- substr(ispv_all$isco4_full, 1, 4)
  ispv_all$isco4_nazev <- substr(ispv_all$isco4_full, 6, length(ispv_all$isco4_full))

  ispv_all <- merge(ispv_all, kraje, by.x = "kraj", by.y = "kraj_kod_ispv")
  ispv_all <- tibble::as_tibble(ispv_all)

  return(ispv_all)
}

