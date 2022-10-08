# length(unique() vs n_distinct()

# I found a bug (from calling `var_summary()`) where `unique()` errors when a data frame column
# contains a column of zero width
# df (encountered on work data coming from a json). Error:
# > Error in mapply(FUN = f, ..., SIMPLIFY = FALSE) :
# >  zero-length inputs cannot be mixed with those of non-zero length
#
# That was version 4.0.3 but it seems ok in 4.2.1.
# It led to changing var_summary() anyway to use n_distinct() which is more appropriate (see below).

x <- tibble(a = 1:5, b = data.frame()[1:5, ])
x <- tibble(a = 1:5, b = character(0))
unique(x)
map(x, unique)

# `dplyr::n_distinct()` and `vctrs::vec_unique_count()` do work.
# The rows of the df col are treated as elements here but `unique()` compares columns.

x <- tibble(a = 1:5)
length(unique(x))
n_distinct(x)

# In a data frame context (as here) the n_distinct behaviour is better since the rows in a df
# column line up with rows of the parent df.

#Note this does not error:
x <- list(a = 1:5, b = data.frame()[1:5, ])
unique(x)

x <- tibble(a = 1:5, b = tibble(c = c(1:4, 1), d = c(1, 2, 3, 1, 1)))

var_summary(x)
purrr::map_int(x, dplyr::n_distinct)


library(tidyverse)
x <- tibble::tibble(a = 1:5, b = data.frame()[1:5, ])
data.frame(a = 1:5, b = data.frame()[1:5, ])
unique(x)
map(x, unique)

edwards::var_summary(x)
map_int(x, ~length(unique(.)))
purrr::map_int(x, dplyr::n_distinct)
purrr::map(x, unique)


x <- tibble(a = 1:5, b = list(1, 2, 3, 1, 1))
x <- tibble(a = c(1:4, 1), b = tibble(c = c(1:3, 1, 1), d = c(1, 2, 3, 1, 1)))
str(x)
var_summary(x)
purrr::map_int(x, dplyr::n_distinct)
map(x, unique)
map(x, vctrs::vec_unique)
map(x, vctrs::vec_unique_count)
?vctrs::vec_unique_count

y <- data.frame(a = 1:5, b = data.frame(c = 1:5, d = 1))
str(y)
map(y, vctrs::vec_unique_count)
y2 <- tibble(a = 1:5, b = data.frame(c = 1:5, d = 1))
str(y2)
map(y2, vctrs::vec_unique_count)

z <- tibble(c = c(1:3, 1, 1), d = c(1, 2, 3, 1, 1))
vctrs::vec_unique_count(z)
length(unique(z))
n_distinct(z)
