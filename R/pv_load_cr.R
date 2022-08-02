
#' FUNCTION_TITLE
#'
#' FUNCTION_DESCRIPTION
#'
#' @param path path to one or more Excel files (character vector length one or more)
#'
#' @return a tibble
#' @examples
#' # ADD_EXAMPLES_HERE
pv_cr_monthlypay_age_gender <- function(path) {

  names(path) <- path

  ispv_all_list <- purrr::map(path, function(x) {

    dt <- readxl::read_excel(x, sheet = 2, skip = 8, n_max = 31 - 8,
                             col_names = c("category",
                                           colnames_monthly_pay_withmeanyoy))
    dt$file <- x
    dt <- dt[!is.na(dt$category), ]
    dt$blank1 <- NULL
    dt$blank2 <- NULL
    dt$group <- c(rep("All", 7), rep("Male", 7), rep("Female", 7))

    dt[,3:13] <- suppressWarnings(sapply(dt[,3:13], as.numeric))

    return(dt)
  })

  ispv_all <- do.call(rbind, ispv_all_list)
  ispv_all <- add_metadata_general(ispv_all)
  ispv_all <- tibble::as_tibble(ispv_all)

  return(ispv_all)
}


#' Load country-wide data by ISCO
#'
#' Load country-wide data by ISCO
#'
#' @param path path to one or more Excel files (character vector length one or more). Will be file with "CR_" and either "PLS" or "MZS" in the name
#' @param sheet which sheet to open. Will be 1 in files with only one sheet ("CR_204_MZS_M8r.xlsx")
#' and 7 in comprehensive file ("CR_204_MZS.xlsx")
#'
#' @return a tibble
#' @examples
#' pv_cr_monthlypay_isco(system.file("extdata", "CR_204_MZS_M8r.xlsx", package = "ispv"), 1)
#' pv_cr_monthlypay_isco(system.file("extdata", "CR_204_MZS.xlsx", package = "ispv"), 7)
#' pv_cr_monthlypay_isco(system.file("extdata", "CR_204_PLS_M8r.xlsx", package = "ispv"), 1)
#' pv_cr_monthlypay_isco(system.file("extdata", "CR_204_PLS.xlsx", package = "ispv"), 7)
#' @export
pv_cr_monthlypay_isco <- function(path, sheet = 1) {
  names(path) <- path

  ispv_all_list <- purrr::map(path, function(x) {

    if (grepl("_PLS", path, ignore.case = T)) {
      col_names_final <- c("isco_full", colnames_monthly_pay_noyoy)
    }  else {
      col_names_final <- c("isco_full", colnames_monthly_pay_noyoy, "estimate_quality")
    }

    print(col_names_final)

    dt <- readxl::read_excel(x, sheet = sheet, skip = 9,
                             col_names = col_names_final)
    dt$file <- x

    dt[, 2:12] <- suppressWarnings(sapply(dt[,2:12], as.numeric))

    return(dt)
  })


  ispv_all <- do.call(rbind, ispv_all_list)

  ispv_all <- add_metadata_general(ispv_all)

  ispv_all$isco_digits <- ifelse(grepl("[0-9]{5}", ispv_all$isco_full), 5, 4)


  ispv_all$isco_id <- ifelse(ispv_all$isco_digits == 5,
                              substr(ispv_all$isco_full, 1, 5),
                              substr(ispv_all$isco_full, 1, 4))
  ispv_all$isco_name <- ifelse(ispv_all$isco_digits == 5,
                                substr(ispv_all$isco_full, 7, length(ispv_all$isco_full)),
                                substr(ispv_all$isco_full, 6, length(ispv_all$isco_full)))

  ispv_all <- tibble::as_tibble(ispv_all)

  return(ispv_all)
}
