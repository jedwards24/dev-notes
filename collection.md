# Collection

## Runtime checks

I am interested in putting standard check (e.g. check data frame) in a separate function to reduce repeated code. Need to ensure message refers to the appropriate object name i.e. calling function may have different names for its data frame argument. An example of how to handle this is in dplyr with `check_length()`. See https://github.com/tidyverse/dplyr/blob/6d22c0f0e1b0d945f2fff28cecb71d9cd548098b/R/utils-replace-with.R and https://github.com/tidyverse/dplyr/blob/main/R/na_if.R.

## Misc

`all(logical(0))` gives `TRUE`.
