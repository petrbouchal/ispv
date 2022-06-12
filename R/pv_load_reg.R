
#' Load ISPV Excel files with regional data on monthly earnings by ISCO code
#'
#' Loads data on monthly earnings by ISCO code from one or more local Excel files downloaded from ISPV links retrieved by `pv_list_reg()`.
#'
#' @param path path to one or more Excel files (character vector length one or more).
#'
#' @return a tibble, see Format for details.
#'
#' @format The function returns a data frame with 22 variables.
#'     All earnings are monthly gross in CZK.
#' \describe{
#'   \item{\code{kraj_id_ispv}}{character. Internal region code, appears in Excel file name}
#'   \item{\code{file}}{character. File from which this row was read.}
#'   \item{\code{isco4_full}}{character. 4-digit ISCO (occupation) code with Czech ISCO category name. CZSO codelist number [5708](https://apl.czso.cz/iSMS/cisdet.jsp?kodcis=5708)}
#'   \item{\code{fte_thous}}{double. Thousand FTEs in this ISCO-4 category - converted to FTE by months paid.}
#'   \item{\code{pay_median}}{double. Median monthly earnings.}
#'   \item{\code{pay_d1}}{double. 1st decile monthly earnings.}
#'   \item{\code{pay_q1}}{double. 1st quartile monthly earnings.}
#'   \item{\code{pay_q3}}{double. 3rd quartile monthly earnings.}
#'   \item{\code{pay_d9}}{double. 9th decline monthly earnings.}
#'   \item{\code{pay_mean}}{double. Mean earnings.}
#'   \item{\code{bonus_perc}}{double. Bonuses ("odměny") as share of pay, as decimal}
#'   \item{\code{supplements_perc}}{double. Supplements ("příplatky") as share of pay, as decimal.}
#'   \item{\code{compensation_perc}}{double. Compensation ("náhrady") as share of pay, as decimal.}
#'   \item{\code{hours_per_month}}{double. Monthly hours worked.}
#'   \item{\code{sfera}}{character. Sphere - salary (`pls`) or wage (`mzs`), roughly equals public or private sector}
#'   \item{\code{period}}{character. Time period as appears in file name, e.g. 204 is Q4 of 2020. Regional data only comes in Q4, i.e. for full year.}
#'   \item{\code{year}}{character. Year, as 4-digit character vector}
#'   \item{\code{isco4_id}}{character. 4-digit ISCO code.}
#'   \item{\code{isco4_name}}{character. Czech name of 4-digit ISCO category}
#'   \item{\code{kraj_id}}{character. non-NUTS ID of kraj (region, NUTS3).}
#'   \item{\code{kraj_name}}{character. Czech name of kraj (region, NUTS3).}
#'   \item{\code{kraj_id_nuts3}}{character. NUTS ID of kraj (region, NUTS3)..}
#' }
#'
#' @export
#' @examples
#' pv_reg_monthlypay_isco4(system.file("extdata", "Kar_204_pls.xlsx", package = "ispv"))
pv_reg_monthlypay_isco4 <- function(path) {

  names(path) <- path

  ispv_all_list <- purrr::map(path, function(x) {

    dt <- readxl::read_excel(x, sheet = 4, skip = 11,
                             col_names = c("isco4_full", colnames_monthly_pay_noyoy))
    dt$file <- x

    return(dt)
  })

  ispv_all <- do.call(rbind, ispv_all_list)
  ispv_all <- add_metadata_general(ispv_all)
  ispv_all <- add_metadata_reg(ispv_all)

  ispv_all$isco4_id <- substr(ispv_all$isco4_full, 1, 4)
  ispv_all$isco4_name <- substr(ispv_all$isco4_full, 6, length(ispv_all$isco4_full))

  ispv_all <- tibble::as_tibble(ispv_all)
  return(ispv_all)
}

pv_reg_monthlypay_age_gender <- function(path) {

  names(path) <- path

  ispv_all_list <- purrr::map(path, function(x) {

    dt <- readxl::read_excel(x, sheet = 2, skip = 11, n_max = 34-11,
                             col_names = c("category", "blank1", "blank2",
                                           colnames_monthly_pay_withmedianyoy))
    dt$file <- x
    dt <- dt[!is.na(dt$category),]
    dt$blank1 <- NULL
    dt$blank2 <- NULL
    dt$group <- c(rep("All", 7), rep("Male", 7), rep("Female", 7))

    dt[,3:13] <- suppressWarnings(sapply(dt[,3:13], as.numeric))

    return(dt)
  })

  ispv_all <- do.call(rbind, ispv_all_list)
  ispv_all <- add_metadata_general(ispv_all)
  ispv_all <- add_metadata_reg(ispv_all)
  ispv_all <- tibble::as_tibble(ispv_all)

  return(ispv_all)
}
