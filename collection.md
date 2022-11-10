# Collection

## Runtime checks

I am interested in putting standard check (e.g. check data frame) in a separate function to reduce repeated code. Need to ensure message refers to the appropriate object name i.e. calling function may have different names for its data frame argument. An example of how to handle this is in dplyr with `check_length()`. See <https://github.com/tidyverse/dplyr/blob/6d22c0f0e1b0d945f2fff28cecb71d9cd548098b/R/utils-replace-with.R> and <https://github.com/tidyverse/dplyr/blob/main/R/na_if.R>.


## Check Installed Packages

I wrote a function `edwards::need()` for this. yihui's util package contains much more detailed functions for helping with attaching packages: <https://github.com/yihui/xfun/blob/main/R/packages.R>

<https://stackoverflow.com/questions/9341635/check-for-installed-packages-before-running-install-packages>

Check if loaded

* `if(!("tidyverse" %in% tolower(.packages())))`

These check if a package is installed:

* `nzchar(system.file(package = "rpart.plot"))`
* `library()$results[,1]`. `library()` returns a list which contains `results`, a data frame of installed package information.

https://rpubs.com/Mentors_Ubiqum/list_packages
* `search()` gives attached packages and R objects.
* `.packages()` gives packages on the search path.
* `loadedNamespaces()` lists loaded namespaces.

## Misc

`all(logical(0))` gives `TRUE`.
