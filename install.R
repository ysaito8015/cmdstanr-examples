# install package
install.packages("cmdstanr", repos = c("https://mc-stan.org/r-packages/", getOption("repos")))

# load packages
pacman::p_load(cmdstanr)
check_cmdstan_toolchain(fix = TRUE, quiet = TRUE)
pacman::p_load(posterior, bayesplot, parallel)
color_scheme_set("brightblue")

cmdstanr::install_cmdstan(cores = parallel::detectCores())

# set path
# cmdstanr::set_cmdstan_path("/home/ysaito/.cmdstan/cmdstan-2.30.1")

cmdstan_path() # [1] "/home/ysaito/.cmdstan/cmdstan-2.30.1"
cmdstan_version() # [1] "2.30.1"
