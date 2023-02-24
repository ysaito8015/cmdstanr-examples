scriptDir <- getwd()  ## You may need to mod this to be in the top level of scriptDir
projectDir <- dirname(scriptDir)
stanDir <- file.path(projectDir, "stan_codes")
if (!dir.exists(stanDir)) {
    dir.create(stanDir)
}
figDir <- file.path(projectDir, "outputs", "figures")
if (!dir.exists(figDir)) {
    dir.create(figDir, recursive = TRUE)
}

modelName <- "Bernoulli"

.libPaths("./lib")

library(cmdstanr)
library(posterior)
library(bayesplot)
color_scheme_set("brightblue")

# Compiling Model
file <-
    file.path(
        cmdstan_path(),
        "examples",
        "bernoulli",
        "bernoulli.stan"
    )
system2("cp", c("-a", file, file.path(projectDir, "stan_codes")))
model <- cmdstan_model(file.path(stanDir, "bernoulli.stan"))

model$print()
print(model$exe_file())

# Running MCMC
data_list <- list(N = 10, y = c(0, 1, 0, 0, 0, 0, 0, 0, 0, 1))

fit <- model$sample( # Create R6 CmdStanMCMC objects
    data = data_list,
    seed = 123,
    chains = 4,
    parallel_chains = 4,
    refresh = 500 # print update every 500 iterations
)

cat("\n\n")
# Posterior Summary Statistics
print(fit$summary())

cat("\n\n")
## Specify some variables
print(fit$summary(variables = c("theta", "lp__"), "mean", "sd"))

cat("\n\n")
# Draw Posterior
draws_array <- fit$draws()
str(draws_array)

cat("\n\n")
draws_df <- fit$draws(format = "df")
str(draws_df)


# Plotting draws
pdf(file = file.path(figDir, paste(modelName, "-plot001.pdf", sep = "")))
  mcmc_hist(fit$draws("theta"))
dev.off()

# Create a stanfit object
#fit.stan <- rstan::read_stan_csv(fit$output_files())
