# Top-level wrapper functions ---------------------------------------------

#' Get links to Excel files with regional data on ISPV website for a given year
#'
#' This function scrapes the relevant year's archive page for links to Excel files with
#' regional data and returns the result in a tibble.
#'
#' @param year Year, defaults to scraping page for latest available data. String or numeric in YYYY format of length >= 1.
#' @param base_url base url, defaults to [htps://ispv.cz](htps://ispv.cz)
#' @param user_agent User agent string, defaults to package URL on Github (`r user_agent`).
#'
#' @return a tibble with file name, URL and year. File name can be used to determine the time period and region.
#' @export
#' @examples
#' \dontrun{
#' pv_list_reg(year = 2019:2020)
#' }
pv_list_reg <- function(year = NULL, base_url = NULL, user_agent = NULL) {

  url <- pv_get_url(year, base_url)

  if(is.null(year)) {
    year <- format(Sys.time(), "%Y")
  }

  links_list <- purrr::map2(url, year, pv_list_reg_one, user_agent = user_agent)
  links <- do.call(rbind, links_list)

  return(links)
}

pv_list_cr <- function(year = NULL, base_url = NULL, user_agent = NULL) {

  url <- pv_get_url(year, base_url)

  if(is.null(year)) {
    year <- format(Sys.time(), "%Y")
  }

  links_list <- purrr::map2(url, year, pv_list_cr_one, user_agent = user_agent)
  links <- do.call(rbind, links_list)

  return(links)
}


# Compontent functions ----------------------------------------------------

pv_get_url <- function(year = NULL, base_url = NULL) {

  if(is.null(year)) {
    url_suffix <- "cz/Vysledky-setreni/Aktualni.aspx"
    year <- format(Sys.time(), "%Y")
  } else {
    stopifnot(all(as.numeric(year) > 1999))
    url_suffix <- paste0("cz/Vysledky-setreni/Archiv/", year, ".aspx")
  }
  if(is.null(base_url)) base_url <- url_base

  url <- paste0(base_url, url_suffix)
  return(url)
}

pv_get_page <- function(url, user_agent) {
  if(is.null(user_agent)) user_agent <- user_agent_default

  cli::cli_inform("Reading {.url {url}}")
  sess <- rvest::session(url, httr::user_agent(user_agent))
  page_html <- rvest::read_html(sess$response$content)
  return(page_html)
}

pv_get_links <- function(page_html, url, regional = FALSE) {

  ispv_links <- page_html |>
    rvest::html_elements("li.excel") |>
    rvest::html_elements("a")

  ispv_links_tbl <- tibble::tibble(
    name = ispv_links |> rvest::html_text(),
    url = ispv_links |> rvest::html_attr("href")
  )

  ispv_links_tbl$krajsky <- grepl(kraj_id_pattern, ispv_links_tbl$name)
  ispv_links_tbl$url_page <- url
  ispv_links$period <- regmatches(ispv_links$name, regexpr("2[0-9]4", ispv_links$name))
  ispv_links$year <- paste0("20", substr(ispv_links$period, 1, 2))

  ispv_links_tbl$url <- paste0(url_base, ispv_links_tbl$url)

  if(regional) {
    ispv_links_tbl <- ispv_links_tbl[ispv_links_tbl$krajsky,]
  } else {
    ispv_links_tbl <- ispv_links_tbl[!ispv_links_tbl$krajsky,]
    ispv_links_tbl <- ispv_links_tbl[grepl("^CR", ispv_links_tbl$name),]
  }

  ispv_links_tbl$krajsky <- NULL
  return(ispv_links_tbl)
}


# Functions used to iterate in top-level functions ------------------------



pv_list_reg_one <- function(url, year, user_agent) {

  page_html <- pv_get_page(url, user_agent)
  ispv_links_kraje <- pv_get_links(page_html, url, regional = TRUE)

  if(nrow(ispv_links_kraje) < 14) cli::cli_alert_info("No regional files available for year {.field {year}}")
  return(ispv_links_kraje)
}

pv_list_cr_one <- function(url, year, user_agent) {
  page_html <- pv_get_page(url, user_agent)
  ispv_links_cr <- pv_get_links(page_html, url, regional = FALSE)

  if(nrow(ispv_links_cr) < 1) cli::cli_alert_info("No data files available for year {.field {year}}")
  return(ispv_links_cr)
}
