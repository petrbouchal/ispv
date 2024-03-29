% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pv_load_reg.R
\name{pv_reg_monthlypay_isco4}
\alias{pv_reg_monthlypay_isco4}
\title{Load regional data on monthly earnings by profession}
\format{
The function returns a data frame with 22 variables.
All earnings are monthly gross in CZK.
\describe{
\item{\code{kraj_id_ispv}}{character. Internal region code, appears in Excel file name}
\item{\code{file}}{character. File from which this row was read.}
\item{\code{isco4_full}}{character. 4-digit ISCO (occupation) code with Czech ISCO category name. CZSO codelist number \href{https://apl.czso.cz/iSMS/cisdet.jsp?kodcis=5708}{5708}}
\item{\code{fte_thous}}{double. Thousand FTEs in this ISCO-4 category - converted to FTE by months paid.}
\item{\code{pay_median}}{double. Median monthly earnings.}
\item{\code{pay_d1}}{double. 1st decile monthly earnings.}
\item{\code{pay_q1}}{double. 1st quartile monthly earnings.}
\item{\code{pay_q3}}{double. 3rd quartile monthly earnings.}
\item{\code{pay_d9}}{double. 9th decline monthly earnings.}
\item{\code{pay_mean}}{double. Mean earnings.}
\item{\code{bonus_perc}}{double. Bonuses ("odměny") as share of pay, as decimal}
\item{\code{supplements_perc}}{double. Supplements ("příplatky") as share of pay, as decimal.}
\item{\code{compensation_perc}}{double. Compensation ("náhrady") as share of pay, as decimal.}
\item{\code{hours_per_month}}{double. Monthly hours worked.}
\item{\code{sfera}}{character. Sphere - salary (\code{pls}) or wage (\code{mzs}), roughly equals public or private sector}
\item{\code{period}}{character. Time period as appears in file name, e.g. 204 is Q4 of 2020. Regional data only comes in Q4, i.e. for full year.}
\item{\code{year}}{character. Year, as 4-digit character vector}
\item{\code{isco4_id}}{character. 4-digit ISCO code.}
\item{\code{isco4_name}}{character. Czech name of 4-digit ISCO category}
\item{\code{kraj_id}}{character. non-NUTS ID of kraj (region, NUTS3).}
\item{\code{kraj_name}}{character. Czech name of kraj (region, NUTS3).}
\item{\code{kraj_id_nuts3}}{character. NUTS ID of kraj (region, NUTS3)..}
}
}
\usage{
pv_reg_monthlypay_isco4(path, sheet = 4)
}
\arguments{
\item{path}{path(s) to file(s), Will be file with "{Reg}_{YYQ}" and either "PLS" or "MZS" in the name.}

\item{sheet}{sheet number; you should be able to leave this as default (4) if using files downloaded from ISPV}
}
\value{
a tibble, see Format for details.
}
\description{
Loads data on monthly earnings by ISCO code from one or more local Excel files downloaded from ISPV links retrieved by \code{pv_list_reg()}.
}
\examples{
pv_reg_monthlypay_isco4(system.file("extdata", "Kar_204_mzs.xlsx", package = "ispv"))
pv_reg_monthlypay_isco4(system.file("extdata", "Kar_204_pls.xlsx", package = "ispv"))
}
