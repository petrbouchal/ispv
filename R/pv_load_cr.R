pv_cr_monthlypay_age_gender <- function(path) {

  names(path) <- path

  ispv_all_list <- purrr::map(path, function(x) {

    dt <- readxl::read_excel(x, sheet = 2, skip = 8, n_max = 31-8,
                             col_names = c("category",
                                           colnames_monthly_pay_withmeanyoy))
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
  ispv_all <- tibble::as_tibble(ispv_all)

  return(ispv_all)
}

