# Comparing == and %in%
# The difference in memory use is notable

library(bench)
x <- sample(letters, 1e6, replace = T)
value <- "a"
bm <- mark(equals = sum(x == value),
     inop = sum(x %in% value))
plot(bm)
bm
bm2 <- mark(equals = sum(x == value),
           inop = sum(x %in% value),
           filter_gc = F)
plot(bm2)
bm2

x3 <- sample(letters, 1e7, replace = T)
value <- "a"
bm3 <- mark(equals = sum(x3 == value),
           inop = sum(x3 %in% value),
           iterations = 10)
plot(bm3)
bm3

# na_if benchmarking ----------
# Can be deleted

library(tidyverse)
library(bench)

f1 <- function(x, y) {
  x[x %in% y] <- NA
  x
}

f2 <- function(x, y) {
  for (i in seq_along(y)){
    x <- na_if(x, y[i])
  }
  x
}

x <- rpois(10000, 1.5)
y <- 2:5
bm <- mark(f1(x, y), f2(x, y))
plot(bm)
bm

na_if_any <- function(x, y) {
  x[x %in% y] <- NA
  x
}

na_if_string <- function(data, na_strings = string_missing()) {
  if (length(na_strings) == 1){
    return(mutate_if(data, is.character, ~na_if(., na_strings)))
  }
  mutate_if(data, is.character, ~na_if_any(., na_strings))
}

na_if_string2 <- function(data, na_strings = string_missing()) {
  mutate_if(data, is.character, ~na_if_any(., na_strings))
}

create_df <- function(rows, cols) {
  as.data.frame(setNames(
    replicate(cols, sample(letters, rows, replace = TRUE), simplify = FALSE),
    rep_len(c("x", letters), cols)))
}
create_df(10, 5)
bm <- press(
  rows = c(1e6),
  cols = c(30),
  nn = 1:2,
  {
    dat <- create_df(rows, cols)
    strings <- letters[1:nn]
    bench::mark(
      na_if_string(dat, strings),
      na_if_string2(dat, strings),
      check = FALSE,
      iterations = 15,
      filter_gc = F
    )
  }
)
bm
plot(bm)
