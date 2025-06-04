## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

library(mpmsim)
set.seed(42)

## -----------------------------------------------------------------------------
matU <- matrix(c(
  0.1, 0.0,
  0.2, 0.4
), byrow = TRUE, nrow = 2)

matF <- matrix(c(
  0.0, 5.0,
  0.0, 0.0
), byrow = TRUE, nrow = 2)

matA <- matU + matF

## -----------------------------------------------------------------------------
popdemo::eigs(matA, what = "lambda")

## -----------------------------------------------------------------------------
compute_ci(
  mat_U = matU, mat_F = matF, sample_size = 20,
  FUN = popdemo::eigs, what = "lambda"
)

## ----fig.height = 4, fig.width = 6, fig.align = "center", fig.alt="Histogram of lambda estimates with a sample size of 20"----
distLambda_20 <- compute_ci(
  mat_U = matU, mat_F = matF,
  sample_size = 20, FUN = popdemo::eigs, what = "lambda",
  dist.out = TRUE
)
hist(distLambda_20$estimates)

## -----------------------------------------------------------------------------
# Define the sample sizes for U
mat_U_ss <- matrix(c(
  40, 40,
  40, 40
), byrow = TRUE, nrow = 2)

# Define sample sizes for F
mat_F_ss <- matrix(c(
  0.0, 15,
  0.0, 0.0
), byrow = TRUE, nrow = 2)

# Combine sample sizes into list
sampleSizes <- list(mat_U_ss = mat_U_ss, mat_F_ss = mat_F_ss)

# Calculate CI for lambda
compute_ci(
  mat_U = matU, mat_F = matF, sample_size = sampleSizes,
  FUN = popdemo::eigs, what = "lambda"
)

## ----compareDist2, fig.height = 6, fig.width = 6, fig.align = "center", fig.alt="Histograms of lambda estimates with a sample size of 20 and 100"----
distLambda_100 <- compute_ci(
  mat_U = matU, mat_F = matF,
  sample_size = 100, FUN = popdemo::eigs, what = "lambda",
  dist.out = TRUE
)

par(mfrow = c(2, 1))
hist(distLambda_20$estimates, xlim = c(0, 1.75))
hist(distLambda_100$estimates, xlim = c(0, 1.75))

## ----poweranalysis, fig.height = 6, fig.width = 6, fig.align = "center", warning=FALSE, fig.alt="Effect of Sample Size on Lambda Estimate Precision"----
# Define sample sizes to iterate over
sample_sizes <- seq(10, 100, 10)

# Lambda value for reference
matA <- matF + matU
true_lambda <- popdemo::eigs(matA, what = "lambda")

# Initialize an empty data frame with predefined columns
ci_results <- data.frame(
  sample_size = sample_sizes,
  ci_lower = numeric(length(sample_sizes)),
  ci_upper = numeric(length(sample_sizes)),
  estimate_mean = numeric(length(sample_sizes))
)

# Loop through each sample size and calculate the CI for lambda
for (i in seq_along(sample_sizes)) {
  n <- sample_sizes[i]

  # Compute CI for the current sample size
  dist_lambda <- compute_ci(
    mat_U = matU, mat_F = matF,
    sample_size = n, FUN = popdemo::eigs, what = "lambda",
    dist.out = TRUE
  )

  # Calculate 95% CI from the distribution
  ci_results$ci_lower[i] <- quantile(dist_lambda$estimates, 0.025)
  ci_results$ci_upper[i] <- quantile(dist_lambda$estimates, 0.975)
  ci_results$estimate_mean[i] <- mean(dist_lambda$estimates)
}

# Calculate error bars
ci_lower_error <- ci_results$estimate_mean - ci_results$ci_lower
ci_upper_error <- ci_results$ci_upper - ci_results$estimate_mean

# Create the plot
plot(ci_results$sample_size, ci_results$estimate_mean,
  ylim = range(ci_results$ci_lower, ci_results$ci_upper),
  pch = 19, xlab = "Sample Size", ylab = "Lambda Estimate",
  main = "Effect of Sample Size on Lambda Estimate Precision"
)

# Add error bars and reference line
arrows(ci_results$sample_size, ci_results$ci_lower,
  ci_results$sample_size, ci_results$ci_upper,
  angle = 90, code = 3, length = 0.05, col = "blue"
)
abline(h = 1, lty = 2)

