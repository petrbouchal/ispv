library(dplyr)

pv_cr_monthlypay_isco(system.file("extdata", "CR_204_MZS.xlsx", package = "ispv"), 7)
pv_cr_monthlypay_isco(system.file("extdata", "CR_204_PLS.xlsx", package = "ispv"), 7)

mzs_cr <- pv_cr_monthlypay_isco(system.file("extdata", "CR_204_MZS_M8r.xlsx", package = "ispv"), 1)
pls_cr <- pv_cr_monthlypay_isco(system.file("extdata", "CR_204_PLS_M8r.xlsx", package = "ispv"), 1)
pls_kv <- pv_reg_monthlypay_isco4(system.file("extdata", "Kar_204_pls.xlsx", package = "ispv"))
mzs_kv <- pv_reg_monthlypay_isco4(system.file("extdata", "Kar_204_mzs.xlsx", package = "ispv"))

pv_list_cr(2020)

bind_rows(mzs_cr, pls_cr) |>
  count(file, wt = fte_thous)

bind_rows(mzs_cr, pls_cr) |>
  count(sfera, isco_digits, wt = fte_thous)

bind_rows(mzs_kv, pls_kv) |>
  count(sfera, wt = fte_thous)

all_cr <- pv_cr_monthlypay_isco(c(
  "~/cc/msmt/data-input/ispv/2021/CR_212_MZS_M8r.xlsx",
  "~/cc/msmt/data-input/ispv/2021/CR_212_MZS_M8r.xlsx",
  "~/cc/msmt/data-input/ispv/2021/CR_214_PLS_M8r.xlsx",
  "~/cc/msmt/data-input/ispv/2021/CR_214_PLS_M8r.xlsx"),
  1)
