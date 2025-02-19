# This script builds both the HTML and PDF versions of your CV

# If you want to speed up rendering for googlesheets driven CVs you can cache a
# version of your data This avoids having to fetch from google sheets twice and
# will speed up rendering. It will also make things nicer if you have a
# non-public sheet and want to take care of the authentication in an interactive
# mode.
# To use, simply uncomment the following lines and run them once.
# If you need to update your data delete the "ddcv_cache.rds" file and re-run

library(tidyverse)
source("cv_printing_functions.R")
cv_data <- create_CV_object(
  data_location = "https://docs.google.com/spreadsheets/d/15Dlu_GRHEvsxBDYGC7k2T0WT_GEduKGtx-_QPKx6_oY/edit?gid=917338460#gid=917338460"
)

readr::write_rds(cv_data, 'cached_positions.rds')
cache_data <- TRUE


# Knit the HTML version
rmarkdown::render("cv_lave.Rmd",
                  params = list(pdf_mode = FALSE, cache_data = cache_data),
                  output_file = "cv.html")

# Knit the PDF version to temporary html location
tmp_html_cv_loc <- fs::file_temp(ext = ".html")
rmarkdown::render("cv_lave.Rmd",
                  params = list(pdf_mode = TRUE, cache_data = cache_data),
                  output_file = tmp_html_cv_loc)

# Convert to PDF using Pagedown
pagedown::chrome_print(input = tmp_html_cv_loc,
                       output = "cv_lave.pdf")
