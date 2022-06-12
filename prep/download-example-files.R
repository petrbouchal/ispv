links <- pv_list_cr(2020)

paths <- file.path("ispv-files", links$name)
purrr::walk2(links$url, paths, curl::curl_download)

links <- pv_list_reg(2020)

paths <- file.path("ispv-files", links$name)
purrr::walk2(links$url, paths, curl::curl_download)
