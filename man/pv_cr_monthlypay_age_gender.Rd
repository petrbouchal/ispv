% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pv_load_cr.R
\name{pv_cr_monthlypay_age_gender}
\alias{pv_cr_monthlypay_age_gender}
\title{Load country-wide data by gender and age}
\usage{
pv_cr_monthlypay_age_gender(path, sheet = 2)
}
\arguments{
\item{path}{path(s) to file(s), Will be file with "CR_{YYQ}D and either "PLS" or "MZS" in the name.}

\item{sheet}{sheet number; you should be able to leave this as default (2) if using files downloaded from ISPV}
}
\value{
a tibble
}
\description{
Load country-wide data by gender and age (age in 6 bins)
}
\examples{
pv_cr_monthlypay_age_gender(system.file("extdata", "CR_204_MZS.xlsx", package = "ispv"))
pv_cr_monthlypay_age_gender(system.file("extdata", "CR_204_PLS.xlsx", package = "ispv"))
}
