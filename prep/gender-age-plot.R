library(ispv)
library(ggplot2)
library(stringr)
library(dplyr)
library(forcats)

links <- pv_list_reg(2020)

paths <- file.path(getwd(), links$name)
purrr::walk2(links$url, paths, curl::curl_download)

data <- pv_reg_monthlypay_age_gender(paths)

data_plot <- data |>
  filter(!str_detect(category, "^[A-ZŽ]"), group != "All") |>
  mutate(category = str_remove(category, " let") |>
           str_replace(" - ", "-") |>
           as.factor() |>
           fct_relevel("do 20"))

ggplot(data_plot, aes(category, colour = group, y = pay_median,
                      group = paste(group, sfera), linetype = sfera)) +
  geom_line() +
  facet_wrap(~kraj_name)

