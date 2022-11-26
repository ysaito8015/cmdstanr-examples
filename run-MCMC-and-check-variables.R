pacman::p_load(cmdstanr, bayesplot, rstan)

# Compiling Model
file <- file.path(cmdstan_path(), "examples", "bernoulli", "bernoulli.stan")
model <- cmdstan_model(file)

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

# Posterior Summary Statistics
print(fit$summary())
print("")

## Specify some variables
print(fit$summary(variables = c("theta", "lp__"), "mean", "sd"))
print("")

# Draw Posterior
draws_array <- fit$draws()
str(draws_array)
print("")

draws_df <- fit$draws(format = "df")
str(draws_df)


# Plotting draws
mcmc_hist(fit$draws("theta"))
print("")

# Create a stanfit object
stanfit <- rstan::read_stan_csv(fit$output_files())
