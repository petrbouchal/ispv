
#' Load country-wide data by gender and age
#'
#' Load country-wide data by gender and age (age in 6 bins)
#'
#' @param path path(s) to file(s), Will be file with "CR_{YYQ}D and either "PLS" or "MZS" in the name.
#' @param sheet sheet number; you should be able to leave this as default (2) if using files downloaded from ISPV
#'
#' @return a tibble
#' @examples
#' pv_cr_monthlypay_age_gender(system.file("extdata", "CR_204_MZS.xlsx", package = "ispv"))
#' pv_cr_monthlypay_age_gender(system.file("extdata", "CR_204_PLS.xlsx", package = "ispv"))
#' @export
pv_cr_monthlypay_age_gender <- function(path, sheet = 2) {

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
#' Load country-wide data by ISCO  (profession classification) at 4 and 5 digits
#'
#' @inheritParams pv_cr_monthlypay_age_gender
#' @param sheet which sheet to open. Will be 1 (the default) in files with only one sheet ("CR_204_MZS_M8r.xlsx")
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

    if (grepl("_PLS", x, ignore.case = T)) {
      col_names_final <- c("isco_full", colnames_monthly_pay_noyoy)
    }  else {
      col_names_final <- c("isco_full", colnames_monthly_pay_noyoy, "estimate_quality")
    }

    dt <- readxl::read_excel(x, sheet = sheet, skip = 9,
                             col_names = col_names_final)
    dt$file <- x

    dt[, 2:12] <- suppressWarnings(sapply(dt[,2:12], as.numeric))
    if(! "estimate_quality" %in% names(dt)) dt$estimate_quality <- NA

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


#' Load country-wide data by NACE
#'
#' Load country-wide data by NACE (single-letter industry codes)
#'
#' @inheritParams pv_cr_monthlypay_age_gender
#' @param sheet sheet number; you should be able to leave this as default (5) if using files downloaded from ISPV
#'
#' @return a tibble
#' @examples
#' pv_cr_monthlypay_nace(system.file("extdata", "CR_204_MZS.xlsx", package = "ispv"))
#' pv_cr_monthlypay_nace(system.file("extdata", "CR_204_PLS.xlsx", package = "ispv"))
#' @export
pv_cr_monthlypay_nace <- function(path, sheet = 5) {
  names(path) <- path

  ispv_all_list <- purrr::map(path, function(x) {
    col_names_final <- c("nace_id", "nace_nazev", colnames_monthly_pay_withmeanyoy)
    dt <- readxl::read_excel(x, sheet = sheet, skip = 25,
                             col_names = col_names_final)
    dt$file <- x
    dt[, 3:15] <- suppressWarnings(sapply(dt[,3:15], as.numeric))
    return(dt)
  })

  ispv_all <- do.call(rbind, ispv_all_list)

  ispv_all <- add_metadata_general(ispv_all)

  ispv_all <- tibble::as_tibble(ispv_all)
  ispv_all <- ispv_all[!grepl("^CELKEM", ispv_all$nace_id),]

  return(ispv_all)
}

#' Load country-wide data on monthly earnings by education
#'
#' Loads data on monthly earnings by education level from one or more local Excel files downloaded from ISPV links retrieved by `pv_list_reg()`.
#'
#' @inheritParams pv_cr_monthlypay_isco
#' @param sheet sheet number; you should be able to leave this as default (3) if using files downloaded from ISPV
#'
#' @return a tibble
#' @examples
#' pv_cr_monthlypay_education(system.file("extdata", "CR_204_PLS.xlsx", package = "ispv"))
#' pv_cr_monthlypay_education(system.file("extdata", "CR_204_MZS.xlsx", package = "ispv"))
#' @export
pv_cr_monthlypay_education <- function(path, sheet = 3) {

  names(path) <- path

  ispv_all_list <- purrr::map(path, function(x) {

    dt <- readxl::read_excel(x, sheet = sheet,
                             # skip = 9, n_max = 15-9,
                             range = "A9:P15",
                             col_names = c("category", "blank1", "code",
                                           colnames_monthly_pay_withmeanyoy))
    dt$file <- x
    dt <- dt[!is.na(dt$category),]
    dt$blank1 <- NULL

    dt[,3:14] <- suppressWarnings(sapply(dt[,3:14], as.numeric))

    return(dt)
  })

  ispv_all <- do.call(rbind, ispv_all_list)
  ispv_all <- add_metadata_general(ispv_all)
  ispv_all <- tibble::as_tibble(ispv_all)

  return(ispv_all)
}

