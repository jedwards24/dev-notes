# Some functions to explore dependencies
# Might use it at work
# Not sure where this end up

# Renv has a function to explore dependencies in a project
# https://rstudio.github.io/renv/reference/dependencies.html
# I want to explore outside projects too

library(tidyverse)

# Count namespace use in files
namespaces <- function(path, pattern = ".") {
  read_lines(path = path, pattern = pattern) %>%
    str_extract_all("\\w*:{2,3}[\\w.-]") %>%
    unlist() %>%
    edwards::vcount() %>%
    separate(value, into = c("package", "fun"), sep = ":{2,3}")
}

# Count library use in files
libs <- function(path, pattern = ".") {
  read_lines(path = path, pattern = pattern) %>%
    str_extract_all("library *\\(.*\\)") %>%
    unlist() %>%
    edwards::vcount()
}

# Reuse some code
# Read lines from R/Rmd files in `path` directory matching `pattern`.
read_lines <- function(path, pattern = ".") {
  fs::dir_ls(path, recurse = TRUE) %>%
    str_subset(regex("\\.(r|rmd)$", ignore_case = TRUE)) %>%
    str_subset(pattern) %>%
    map(readLines) %>%
    unlist()
}

# The next few functions also get namespaces and libs but with more detail

# Load lines and put in a tibble
get_lines <- function(path, pattern = ".", keep_comments = FALSE) {
  path <- fs::as_fs_path(path)
  tb <-  fs::dir_ls(path, recurse = TRUE) %>%
    str_subset(regex("\\.(r|rmd)$", ignore_case = TRUE)) %>%
    str_subset(pattern) %>%
    setNames(., str_remove(., path)) %>%
    map(readLines) %>%
    enframe(name = "file", value = "line") %>%
    unchop(line) %>%
    select(line, file) %>%
    group_by(file) %>%
    mutate(line_no = row_number()) %>%
    ungroup() %>%
    filter(line != "") %>%
    mutate(type = if_else(str_to_upper(str_sub(file, -1)) == "R", "r", "rmd"))
  if (keep_comments){
    return(tb)
  }
  filter(tb, !str_detect(line, "^ *#"))
}

namespaces_lines <- function(x) {
  filter(x, str_detect(line, ":{2,3}")) %>%
    mutate(fun = str_extract_all(line, "\\w*:{2,3}[\\w.-]")) %>%
    unchop(fun) %>%
    separate(fun, into = c("package", "fun"), sep = ":{2,3}") %>%
    select(package, fun, everything())
}

libs_lines <- function(x) {
  filter(x, str_detect(line, ":{2,3}")) %>%
    mutate(lib = str_extract_all("library *\\(.*\\)")) %>%
    unchop(lib) %>%
    mutate(lib = str_squish(lib)) %>%
    select(lib, everything())
}

# This code relate to quick exploration of data columns.
# Motivation is finding "personal" data columns (by name not contents)
# Data file Extensions: csv, rds, rdata, xlsx, xls, sas7bdat, sav, json, rda, qs ...?
#
# Use dir_files() and filter by these extensions.

# Then pipe into e.g
x %>%
  filter(str_to_lower(ext) == "csv") %>%
  mutate(sample = map(path, ~read_csv(., n_max = 15))) %>%
  mutate(cols = map(sample, colnames))

# the extract "personal". `pattern` is something like "email|dob|name"
x %>%
  mutate(cols_pers = map(cols, ~str_subset(., regex(pattern, ignore_case = TRUE)))) %>%
  mutate(n_pers = map_int(cols_pers, length)) %>%
  mutate(data_pers = map2(data_sample, pers_cols, ~select(.x, all_of(.y))))

# Other --------
# Regex for function calls?: "[\\w._]+ *{?=\\()"}
# \\w includes _ (check)
# See ?make.names for allowable names
