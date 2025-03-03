## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
set.seed(42)

## ----message=FALSE------------------------------------------------------------
library(mpmsim)
library(dplyr)
library(Rage)
library(ggplot2)
library(Rcompadre)

## ----echo = FALSE, message=FALSE, fig.height=4, fig.width =8------------------
require(patchwork)
A <- model_mortality(
  params = c(b_0 = 0.01, b_1 = 0.5),
  model = "Gompertz"
)

plotA <- ggplot(A, aes(x = x, y = hx)) +
  geom_line() +
  xlab("Age") +
  ylab("Hazard") +
  ggtitle("A) Gompertz")


B <- model_mortality(
  params = c(b_0 = 0.01, b_1 = 0.5, C = 0.2),
  model = "GompertzMakeham"
)

plotB <- ggplot(B, aes(x = x, y = hx)) +
  geom_line() +
  xlab("Age") +
  ylab("Hazard") +
  ggtitle("B) Gompertz-Makeham") +
  geom_hline(yintercept = 0.2, linetype = 2) +
  coord_cartesian(ylim = c(0, NA))


C <- model_mortality(
  params = c(a_0 = 0.15, a_1 = 0.3, C = -0.11, b_0 = 0.1, b_1 = 0.1),
  model = "Siler"
)

plotC <- ggplot(C, aes(x = x, y = hx)) +
  geom_line() +
  xlab("Age") +
  ylab("Hazard") +
  ggtitle("C) Siler") +
  coord_cartesian(ylim = c(0, NA))

D <- model_mortality(
  params = c(b_0 = 1.51, b_1 = 0.15),
  model = "Weibull"
)

plotD <- ggplot(D, aes(x = x, y = hx)) +
  geom_line() +
  xlab("Age") +
  ylab("Hazard") +
  ggtitle("D) Weibull")

E <- model_mortality(
  params = c(b_0 = 1.51, b_1 = 0.15, C = 0.05),
  model = "WeibullMakeham"
)

plotE <- ggplot(E, aes(x = x, y = hx)) +
  geom_line() +
  xlab("Age") +
  ylab("Hazard") +
  ggtitle("F) Weibull-Makeham") +
  geom_hline(yintercept = 0.05, linetype = 2) +
  coord_cartesian(ylim = c(0, NA))

FF <- model_mortality(
  params = c(b_0 = 0.1),
  model = "Exponential"
)

plotFF <- ggplot(FF, aes(x = x, y = hx)) +
  geom_line() +
  xlab("Age") +
  ylab("Hazard") +
  ggtitle("E) Exponential")


plotA + plotB + plotC + plotD + plotE + plotFF

## ----echo = FALSE, message=FALSE, fig.height=4, fig.width =8------------------
baseDF <- data.frame(x = 0:20)

# Compute fecundity using the step model
stepMod <- baseDF %>%
  mutate(fecundity = model_fecundity(
    age = x, params = c(A = 10), maturity = 6,
    model = "step"
  ))

plotA <- ggplot(stepMod, aes(x = x, y = fecundity)) +
  geom_line() +
  xlab("Age") +
  ylab("Fecundity") +
  ggtitle("A) Step")

# Compute fecundity using the logistic model
logisticMod <- baseDF %>%
  mutate(fecundity = model_fecundity(
    age = x, params = c(A = 10, k = 0.5, x_m = 8), maturity =
      0, model = "logistic"
  ))

plotB <- ggplot(logisticMod, aes(x = x, y = fecundity)) +
  geom_line() +
  xlab("Age") +
  ylab("Reproduction") +
  ggtitle("B) Logistic")

# Compute fecundity using the von Bertalanffy model

vonBertMod <- baseDF %>%
  mutate(fecundity = model_fecundity(
    age = x, params = c(A = 10, k = .5), maturity = 2, model =
      "vonbertalanffy"
  ))

plotC <- ggplot(vonBertMod, aes(x = x, y = fecundity)) +
  geom_line() +
  xlab("Age") +
  ylab("Reproduction") +
  ggtitle("C) von Bertalanffy")

# Compute fecundity using the normal model
normalMod <- baseDF %>%
  mutate(fecundity = model_fecundity(
    age = x, params = c(A = 10, mu = 4, sd = 2), maturity = 0,
    model = "normal"
  ))
plotD <- ggplot(normalMod, aes(x = x, y = fecundity)) +
  geom_line() +
  xlab("Age") +
  ylab("Reproduction") +
  ggtitle("D) Normal")

# Compute fecundity using the Hadwiger model
hadwigerMod <- data.frame(x = 0:50) %>%
  mutate(fecundity = model_fecundity(
    age = x, params = c(a = 0.91, b = 3.85, C = 29.78),
    maturity = 0, model = "hadwiger"
  ))
plotE <- ggplot(hadwigerMod, aes(x = x, y = fecundity)) +
  geom_line() +
  xlab("Age") +
  ylab("Reproduction") +
  ggtitle("E) hadwiger")


plotA + plotB + plotC + plotD + plotE

## -----------------------------------------------------------------------------
(lt1 <- model_mortality(params = c(b_0 = 0.1, b_1 = 0.2), model = "Gompertz"))

## ----echo = TRUE, message=FALSE, fig.height=4, fig.width =8-------------------
ggplot(lt1, aes(x = x, y = hx)) +
  geom_line() +
  ggtitle("Gompertz mortality (b_0 = 0.1, b_1 = 0.2)")

## -----------------------------------------------------------------------------
(lt1 <- lt1 |>
  mutate(fecundity = model_fecundity(
    age = x, params = c(A = 3),
    maturity = 3,
    model = "step"
  )))

## ----echo = TRUE, message=FALSE, fig.height=4, fig.width =8-------------------
ggplot(lt1, aes(x = x, y = fecundity)) +
  geom_line() +
  ggtitle("Step fecundity, maturity at age 3")

## -----------------------------------------------------------------------------
make_leslie_mpm(lifetable = lt1)

## -----------------------------------------------------------------------------
mortParams <- data.frame(
  minVal = c(0, 0.01, 0.1),
  maxVal = c(0.05, 0.15, 0.2)
)

fecundityParams <- data.frame(
  minVal = 2,
  maxVal = 10
)

maturityParam <- c(0, 0)

(myMatrices <- rand_leslie_set(
  n_models = 50,
  mortality_model = "GompertzMakeham",
  fecundity_model = "step",
  mortality_params = mortParams,
  fecundity_params = fecundityParams,
  fecundity_maturity_params = maturityParam,
  dist_type = "uniform",
  output = "Type1"
))

## -----------------------------------------------------------------------------
summarise_mpms(myMatrices)

## -----------------------------------------------------------------------------
# Obtain the matrices
x <- matA(myMatrices)

# Calculate lambda for each matrix
sapply(x, popdemo::eigs, what = "lambda")

