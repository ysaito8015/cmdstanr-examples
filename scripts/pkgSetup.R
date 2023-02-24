pkgs <-
    c(
        "posterior",
        "bayesplot",
    )

scriptDir <- getwd()  ## You may need to mod this to be in the top level of scriptDir
projectDir <- dirname(scriptDir)
pkgDir <- file.path(scriptDir, "pkg")
if (!dir.exists(pkgDir)) {
    dir.create(pkgDir)
}
libDir <- file.path(scriptDir, "lib")
if (!dir.exists(libDir)) {
    dir.create(libDir)
}

.libPaths(libDir)

Sys.setenv("PKG_CXXFLAGS"="-std=c++20 -DBOOST_PHOENIX_NO_VARIADIC_EXPRESSION")

# install package
install.packages(
    "cmdstanr",
    lib = libDir,
    contriburl = c(
        contrib.url("https://mc-stan.org/r-packages/", "source")
    ),
    destdir = pkgDir,
    type = "source",
    dependencies = c("Depends", "Imports", "LinkingTo"),
    INSTALL_opts = "--no-multiarch"
)

install.packages(
    pkgs,
    lib = libDir,
    contriburl = c(
        contrib.url("http://r-forge.r-project.org","source"),
        contrib.url("https://cran.rstudio.com/","source")
    ),
    destdir = pkgDir,
    type = "source",
    dependencies = c("Depends", "Imports", "LinkingTo"),
    INSTALL_opts = "--no-multiarch"
)


# load packages
library(cmdstanr)

check_cmdstan_toolchain(fix = TRUE, quiet = TRUE)
mc.cores = parallel::detectCores()
cmdstanr::install_cmdstan(
    dir = scriptDir,
    cores = getOption("mc.cores")
)

cmdstan_path() # scriptDir/cmdstan-*
cmdstan_version()
