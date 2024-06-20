url_base <- "https://www.ispv.cz/"
user_agent_default <- "https://github.com/petrbouchal/ispv"

kraje <- tibble::tribble(
  ~kraj_id,                ~kraj_name, ~kraj_id_nuts3, ~kraj_id_ispv,
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
  "116",    "Jihomoravsk\\u00fd kraj",        "CZ064", "Jim",
  "124",       "Olomouck\\u00fd kraj",        "CZ071", "Olo",
  "132", "Moravskoslezsk\\u00fd kraj",        "CZ080", "Mos",
  "141",         "Zl\\u00ednsk\\u00fd kraj",        "CZ072", "Zli"
)

kraje$kraj_name <- stringi::stri_unescape_unicode(kraje$kraj_name)


kraj_id_pattern <- paste(paste0(kraje$kraj_id_ispv, "_"), collapse = "|")

add_metadata_reg <- function(ispv_all) {

  ispv_all$kraj_id_ispv <- regmatches(ispv_all$file, regexpr(kraj_id_pattern,
                                                             ispv_all$file))
  ispv_all$kraj_id_ispv <- substr(ispv_all$kraj_id_ispv, 1, 3)
  ispv_all <- merge(ispv_all, kraje, by = "kraj_id_ispv")

  return(ispv_all)
}

add_metadata_general <- function(ispv_all) {

  ispv_all$sfera <- regmatches(ispv_all$file, regexpr("mzs|pls", ispv_all$file, ignore.case = T))
  ispv_all$period <- regmatches(ispv_all$file, regexpr("(?<=\\_)[12][0-9][2,4](?=\\_)", ispv_all$file, perl = TRUE))
  ispv_all$year <- paste0("20", substr(ispv_all$period, 1, 2))
  ispv_all$quarter <- substr(ispv_all$period, 3, 3)

  return(ispv_all)
}

colnames_monthly_pay_noyoy <- c("fte_thous", "pay_median",
                         "pay_d1", "pay_q1", "pay_q3", "pay_d9",
                         "pay_mean",
                         "bonus_perc", "supplements_perc", "compensation_perc",
                         "hours_per_month")
colnames_monthly_pay_withmedianyoy <- c("fte_thous", "pay_median", "pay_median_yoy",
                         "pay_d1", "pay_q1", "pay_q3", "pay_d9",
                         "pay_mean",
                         "bonus_perc", "supplements_perc", "compensation_perc",
                         "hours_per_month")
colnames_monthly_pay_withmeanyoy <- c("fte_thous", "pay_median", "pay_median_yoy",
                         "pay_d1", "pay_q1", "pay_q3", "pay_d9",
                         "pay_mean", "pay_mean_yoy",
                         "bonus_perc", "supplements_perc", "compensation_perc",
                         "hours_per_month")
