# min_n dev and bench

# sort() with partial errors when there are not enough non-NA values in the input.
# e.g. sort(c(1:3, NA), partial = 4, na.last = TRUE)
# It seems to remove the NA then think position 4 is out-of-bounds.
# In v1 below I check for this and give an error (better message).
# The others all check and do not use partial if there will be a problem.
# v2 avoids partial whenever there is an NA. v3 and v4 check the length of non-NAs.
# v4 is better for speed but v2 is safer for memory.

# Also see `topn()` from https://cran.r-project.org/web/packages/kit/index.html
# https://stackoverflow.com/questions/2453326/fastest-way-to-find-second-third-highest-lowest-value-in-vector-or-column

# sort() bench-------
#partial is only used if length(n) < 10
library(bench)
nn <- 1e6
x <- rnorm(nn)
n <- seq(1e3, nn, length.out = 5)
n <- 1:5
mark(f1 = sort(x, partial = n)[n],
     f2 = sort(x, partial = 1:nn)[n],
     f3 = sort(x)[n])


#-----------------

min_n1 <- function(x, n = 2L, na.rm = FALSE){
  if (!is.numeric(n)){
    stop("`n` must be numeric.", call. = FALSE)
  }
  if ((max(n) > length(x)) | (min(n) < 1L))
    stop('All elements of `n` must be between 1 and `length(x)`.', call. = FALSE)
  if (!na.rm && any(is.na(x))) return (x[is.na(x)][1]) # match class of x
  if (na.rm) x <- x[!is.na(x)]
  if (max(n) >= length(x) + 1)
    stop("All elements of `n` must be no greater than the number of non-missing values
         in `x`.", call. = FALSE)
  sort(x, partial = n)[n]
}

min_n2 <- function(x, n = 2L, na.rm = FALSE){
  if (!is.numeric(n)){
    stop("`n` must be numeric.", call. = FALSE)
  }
  if ((max(n) > length(x)) | (min(n) < 1L))
    stop('All elements of `n` must be between 1 and `length(x)`.', call. = FALSE)
  if (any(is.na(x))){
    return(sort(x, na.last = TRUE)[n])
  }
  sort(x, partial = n)[n]
}

min_n3 <- function(x, n = 2L, na.rm = FALSE){
  if (!is.numeric(n)){
    stop("`n` must be numeric.", call. = FALSE)
  }
  if ((max(n) > length(x)) | (min(n) < 1L))
    stop('All elements of `n` must be between 1 and `length(x)`.', call. = FALSE)
  if (length(na.omit(x)) < max(n)){
    return(sort(x, na.last = TRUE)[n])
  }
  sort(x, partial = n)[n]
}

min_n4 <- function(x, n = 2L, na.rm = FALSE){
  if (!is.numeric(n)){
    stop("`n` must be numeric.", call. = FALSE)
  }
  if ((max(n) > length(x)) | (min(n) < 1L))
    stop('All elements of `n` must be between 1 and `length(x)`.', call. = FALSE)
  if (sum(!is.na(x)) < max(n)){
    return(sort(x, na.last = TRUE)[n])
  }
  sort(x, partial = n)[n]
}

x <- c(3, 2, 10, 1, NA)
sort(x, decreasing = T, na.last = T)

min_n1(x, 1:5, na.rm = T)
min_n2(x, 1:5)

library(bench)
nn <- 1e6
x <- rnorm(nn)
x[1e6] <- NA
n <- 1
mark(f1 = min_n1(x, n, na.rm = T),
     f2 = min_n2(x, n),
     f3 = min_n3(x, n),
     f4 = min_n4(x, n),
     filter_gc = F, iterations = 15)

bm <- mark(f2 = min_n2(x, n),
           f3 = min_n3(x, n),
           f4 = min_n4(x, n), iterations = 15, filter_gc = F)
plot(bm)
bm

max_n1 <- function(x, n = 2L, na.rm = FALSE){
  if (!is.numeric(n)){
    stop("`n` must be numeric.", call. = FALSE)
  }
  if ((max(n) > length(x)) | (min(n) < 1L))
    stop('All elements of `n` must be between 1 and `length(x)`.', call. = FALSE)
  len <- length(x)
  if (any(is.na(x))){
    return(sort(x, na.last = FALSE)[len - n + 1])
  }
  sort(x, partial = len - n + 1)[len - n + 1]
}

max_n2 <- function(x, n = 2L, na.rm = FALSE){
  if (!is.numeric(n)){
    stop("`n` must be numeric.", call. = FALSE)
  }
  if ((max(n) > length(x)) | (min(n) < 1L))
    stop('All elements of `n` must be between 1 and `length(x)`.', call. = FALSE)
  len <- length(x)
  if (any(is.na(x))){
    return(sort(x, decreasing = TRUE, na.last = TRUE)[n])
  }
  sort(x, partial = len - n + 1)[len - n + 1]
}

#incorrect - see later
max_n3 <- function(x, n = 2L, na.rm = FALSE){
  if (!is.numeric(n)){
    stop("`n` must be numeric.", call. = FALSE)
  }
  if ((max(n) > length(x)) | (min(n) < 1L))
    stop('All elements of `n` must be between 1 and `length(x)`.', call. = FALSE)
  len <- length(x)
  if (sum(!is.na(x)) < max(len - n + 1)){
    return(sort(x, decreasing = TRUE, na.last = TRUE)[n])
  }
  sort(x, partial = len - n + 1, na.last = FALSE)[len - n + 1]
}

max_n3 <- function(x, n = 2L, na.rm = FALSE){
  if (!is.numeric(n)){
    stop("`n` must be numeric.", call. = FALSE)
  }
  if ((max(n) > length(x)) | (min(n) < 1L))
    stop('All elements of `n` must be between 1 and `length(x)`.', call. = FALSE)
  sort(x, decreasing = TRUE, na.last = TRUE)[n]
}

nn <- 1e6
x <- rnorm(nn)
x[1e6] <- NA
n <- 10
mark(f1 = max_n1(x, n),
     f2 = max_n2(x, n),
     f3 = max_n3(x, n),
     iterations = 15, filter_gc = F)
plot(bm)
bm
