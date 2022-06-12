
#' Codelist (registry) of regions
#'
#' Used in `pv_reg_*()` to add proper region IDs and names.
#'
#' @format A data frame with 14 rows and 4 variables:
#' \describe{
#'   \item{\code{kraj_id_ispv}}{character. Internal region code, appears in Excel file name}
#'   \item{\code{kraj_id}}{character. non-NUTS ID of kraj (region, NUTS3).}
#'   \item{\code{kraj_name}}{character. Czech name of kraj (region, NUTS3).}
#'   \item{\code{kraj_id_nuts3}}{character. NUTS ID of kraj (region, NUTS3)..}
#' }
"kraje"
