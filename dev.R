
# Remove NAs
# na_remove?
remove_na <- function(x) {
  if (any(ina <- is.na(x))) {
    x <- x[!ina]
  }
  x
}

x <- c(1:2, NA, 3)
remove_na(x)


# Check columns in data frame
# Column names in the error message will be in lower case. Add arg option?
# Name of data in calling function may be incorrect. Could add data_name arg (or do it properly).
check_columns <- function(data, cols) {
  miss <- setdiff(str_to_lower(cols), str_to_lower(names(data)))
  stop("The following columns must be in `data` but are missing:\n",
       paste0(miss, collapse = ", "), call. = FALSE)
}
