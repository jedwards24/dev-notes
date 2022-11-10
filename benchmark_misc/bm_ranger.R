# benchmarking ranger

create_data_norm <- function(nr, nc) {
  x <- matrix(rnorm(nr * nc), ncol = nc)
  colnames(x) <- paste0("x", 1:nc)
  as_tibble(x)
}

# Could do with fixing seed
# Not sure this is worth doing - just call press directly
press_ranger <- function(rows, cols, mtry = floor(sqrt(cols)), threads = 1,
                         ..., interations = 5) {
  press(
    rows = rows,
    cols = cols,
    mtry = mtry,
    threads = threads,
    {
      dat <- create_data_norm(rows, cols) %>%
        mutate(y = rnorm(norw(.)))
      bench::mark(
        rang = ranger(y ~ ., data = dat, ..., num.threads = threads, mtry = mtry),
        interations = interations,
        memory = F,
        check = F,
        filter_gc = F
      )
    }
  )
}
