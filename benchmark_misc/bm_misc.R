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
