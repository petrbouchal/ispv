
#' DATASET_TITLE
#'
#' DATASET_DESCRIPTION
#'
#' @format A data frame with 14 rows and 4 variables:
#' \describe{
#'   \item{\code{kraj_kod}}{character. DESCRIPTION.}
#'   \item{\code{kraj_nazev}}{character. DESCRIPTION.}
#'   \item{\code{kraj_kod_nuts3}}{character. DESCRIPTION.}
#'   \item{\code{kraj_kod_ispv}}{character. DESCRIPTION.}
#' }
"kraje" <- tibble::tribble(
  ~kraj_kod,                ~kraj_nazev, ~kraj_kod_nuts3, ~kraj_kod_ispv,
  "19",   "Hlavn\\u00ed m\\u011bsto Praha",         "CZ010", "Pra",
  "27",     "St\\u0159edo\\u010desk\\u00fd kraj",         "CZ020", "Str",
  "35",       "Jiho\\u010desk\\u00fd kraj",         "CZ031", "Jic",
  "43",        "Plze\\u0148sk\\u00fd kraj",         "CZ032", "Plz",
  "51",     "Karlovarsk\\u00fd kraj",         "CZ041", "Kar",
  "60",         "\\u00dasteck\\u00fd kraj",         "CZ042", "Ust",
  "78",       "Libereck\\u00fd kraj",         "CZ051", "Lib",
  "86", "Kr\\u00e1lov\\u00e9hradeck\\u00fd kraj",         "CZ052", "Kra",
  "94",      "Pardubick\\u00fd kraj",         "CZ053", "Par",
  "108",        "Kraj Vyso\\u010dina",        "CZ063", "Vys",
  "116",    "Jihomoravsk\\u00fd kraj",        "CZ064", "Jih",
  "124",       "Olomouck\\u00fd kraj",        "CZ071", "Olo",
  "132", "Moravskoslezsk\\u00fd kraj",        "CZ080", "Mos",
  "141",         "Zl\\u00ednsk\\u00fd kraj",        "CZ072", "Zli"
)

kraje$kraj_nazev <- stringi::stri_unescape_unicode(kraje$kraj_nazev)

usethis::use_data(kraje, overwrite = TRUE)
