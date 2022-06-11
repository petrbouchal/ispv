
#' Get links to Excel files with regional data on ISPV website for a given year
#'
#' This function scrapes the relevant year's archive page for links to Excel files with
#' regional data and returns the result in a tibble.
#'
#' @param year Year, defaults to scraping page for latest available data. String or numeric in YYYY format of length >= 1.
#' @param base_url base url, defaults to [htps://ispv.cz]
#' @param user_agent User agent string, defaults to package URL on Github (`r user_agent`).
#'
#' @return a tibble with file name, URL and year. File name can be used to determine the time period and region.
#' @export
#' @examples
#' \dontrun{
#' pv_list_reg(year = 2019:2020)
#' }
pv_list_reg <- function(year = NULL, base_url = NULL, user_agent = NULL) {
  if(is.null(year)) {
    url_suffix <- "cz/Vysledky-setreni/Aktualni.aspx"
    year <- format(Sys.time(), "%Y")
  } else {
    stopifnot(all(as.numeric(year) > 1999))
    url_suffix <- paste0("cz/Vysledky-setreni/Archiv/", year, ".aspx")
  }
  if(is.null(base_url)) base_url <- url_base
  if(is.null(user_agent)) user_agent <- user_agent

  url <- paste0(base_url, url_suffix)

  links <- purrr::map2_dfr(url, year, pv_list_reg_one)

  return(links)

}

pv_list_reg_one <- function(url, year) {

  sess <- rvest::session(url, httr::user_agent(user_agent))
  ispv_page <- rvest::read_html(sess$response$content)

  ispv_links <- ispv_page |>
    rvest::html_elements("li.excel") |>
    rvest::html_elements("a")

  ispv_links_tbl <- tibble::tibble(
    name = ispv_links |> rvest::html_text(),
    url = ispv_links |> rvest::html_attr("href")
  )

  ispv_links_tbl$krajsky <- grepl("[A-Z][a-z]{2}", ispv_links_tbl$name)

  ispv_links_kraje <- ispv_links_tbl[ispv_links_tbl$krajsky,]
  ispv_links_kraje$year <- year
  ispv_links_kraje$krajsky <- NULL

  if(nrow(ispv_links_kraje) < 14) cli::cli_alert_info("No regional files available for year {.field {year}}")

  return(ispv_links_kraje)
}
