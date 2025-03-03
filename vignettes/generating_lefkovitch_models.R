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

## -----------------------------------------------------------------------------
rand_lefko_mpm(n_stages = 3, fecundity = 5, archetype = 2)

## -----------------------------------------------------------------------------
lower_reprod <- matrix(c(
  0, 0, 0,
  0, 0, 0,
  0, 0, 0
), nrow = 3, ncol = 3, byrow = TRUE)
upper_reprod <- matrix(c(
  0, 4, 20,
  0, 0, 0,
  0, 0, 0
), nrow = 3, ncol = 3, byrow = TRUE)

rand_lefko_mpm(
  n_stages = 3, fecundity = list(lower_reprod, upper_reprod),
  archetype = 2
)

## -----------------------------------------------------------------------------
myMatrices <- rand_lefko_set(
  n = 100, n_stages = 3, fecundity = 12,
  archetype = 4, output = "Type1"
)

## -----------------------------------------------------------------------------
# Obtain the matrices
x <- matA(myMatrices)

# Calculate lambda for each matrix
lambdaVals <- sapply(x, popdemo::eigs, what = "lambda")
summary(lambdaVals)

## ----message=FALSE------------------------------------------------------------
library(popdemo)

constrain_df <- data.frame(
  fun = "eigs", arg = "lambda", lower = 0.9, upper = 1.1
)

myMatrices <- rand_lefko_set(
  n = 100, n_stages = 3, fecundity = 12, constraint = constrain_df,
  archetype = 4, output = "Type1"
)

## -----------------------------------------------------------------------------
# Obtain the matrices
x <- matA(myMatrices)

# Calculate lambda for each matrix
lambdaVals <- sapply(x, popdemo::eigs, what = "lambda")
summary(lambdaVals)

