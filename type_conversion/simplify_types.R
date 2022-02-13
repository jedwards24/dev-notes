
# simplify_columns() --------
# Output is tibble with one row per column
# Checks for:
#  - character to numeric/integer.
#  - double to integer.
#  - datetime to date?
#  - logical from character/numeric (0/1)
#  - potential binary cols
# Option to treat "" as missing.
# Default is to keep column type as is.
# Need funcs `possible_int()` etc.
#
# Plan:
#  - check sequentially for character -> double -> integer -> logical.
#  - output lowest of these.
#  - need to check class too since do not want to treat date as double/integer.
#  - Done this way, logical will only be output when col is entirely 1/0/NA (i.e. not TRUE/FALSE).
#  - Separately check for possible binary (max two values, not inc NA). Add values as two cols.
# Cols in output: var, type, simplest_type, all_missing, binary, value_1, value_2.
# show_all arg. If FALSE just show cols where type != simplest_type or binary == TRUE.
#
# Edge cases:
# char with leading zeroes - will convert to double but indicate in column `leading_zeroes`.
# "9.0" - I'm okay with this converting to double and integer.
# Small decimal tolerances
# Integers outside 32 bit bounds - test and do not convert?
#
# Check with as.double(x)==x, as.integer(x)==x, as.logical(x)==x
# These are done in sequence i.e. double is fed into as.integer and integer into as.logical.
# This changes outcomes:
as.logical("1")
as.integer("9.0") == "9"
as.double("07") == "07"
x <- c("1", "1.0", "1.0001")
as.double(x) == x
as.integer(x) == x
x == as.double(x)
library(readr)
parse_double(x)
parse_integer(x)
as.integer(x)
as.double(x)
y <- "1.0"
y <- 2^33
as.integer(y) == as.double(y)
as.double("0xa")
parse_number("0x")
parse_number("potato7")


# guess_parser has option to guess integer. Calls C code

guess_parser(x)
guess_parser(x[-3])
guess_parser("07")
guess_parser("1.0", guess_integer = T)
guess_parser("1", guess_integer = T)
guess_parser("0xa")
readr::type_convert(x)


# var_simplify()?

col_simplify <- function(data) {
  leading_zero <- purrr::map_lgl(data, ~is.character(.) & any(stringr::str_detect(., "^0")))
  tibble(col = names(data),
         class = purrr::map_chr(data, ~class(.)[1]),
         simplest_class = purrr::map_chr(data, simplest_class),
         leading_zero)
}

simplest_class <- function(x) {
  out <- class(x)[1]
  if (class(x)== "character"){
    x <- stringr::str_remove(x, "^0*")
    if (all(as.double(x) == x)) out <- "numeric"
  }
  if (out == "numeric" || class(x) == "numeric"){
    if (all(as.integer(as.double(x)) == x)) out <- "integer"
  }
  out
}

x <- tibble(a = 1:3,
            b = lubridate::today()+ 1:3,
            c = as.character(1:3),
            d = as.character(c(1, 2, 3)),
            e = c(1.0, 2, 3),
            f = e + 0.1,
            g = c("0123", "123", "00123"))

purrr::map_chr(x, simplest_class)

simplest_class(c(1.0, 2, 3) + 0.1)
test <- col_simplify(x)
new <- col_simplify(x)
new
identical(new, test)
debugonce(col_simplify)

g = c("0123", "123", "00123")
simplest_class(g)
maybe_double(g)
as.double(g) == g


# simplify_datetime() --------------
# Wrapper for following but print which cols are converted.
# mutate_if(dt, is_simple_datetime, ~as.Date(.))
