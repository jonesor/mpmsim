#' Simulate survival probability
#'
#' @param probSurv true survival probability
#' @param sample_size sample size
#' @return mean survival probability based on the simulated data
#' @examples
#' simSurv(0.8, 100)
#' simSurv(0.5, 1000)
#' @noRd
simSurv <- function(probSurv, sample_size) {
  mean(rbinom(sample_size, 1, probSurv))
}

#' Simulate reproduction (fecundity)
#'
#' @param meanFec mean value for reproductive output
#' @param sample_size sample size
#' @return mean fecundity based on the simulated data
#' @examples
#' simFec(2, 100)
#' simFec(5, 1000)
#' @noRd
simFec <- function(meanFec, sample_size) {
  mean(rpois(sample_size, meanFec))
}

#' Simulate matrix population models (MPMs) based on expected transition rates
#' and sample sizes
#'
#' Simulates a matrix population model based on expected values in the
#' transition matrix. The expected values are provided in two matrices `matU`
#' for the growth/development and survival transitions and `matF` for the
#' fecundity transitions.The `matU` values are simulated based on expected
#' probabilities, assuming a binomial process with a sample size defined by
#' `sample_size`. The `matF` values are simulated using a Poisson process with a
#' sample size defined by `sample_size`.Thus users can expect that large sample
#' sizes will result in simulated matrices that match closely with the
#' expectations, while simulated matrices with small sample sizes will be more
#' variable.
#'
#' @param matU matrix of survival probabilities
#' @param matF matrix of mean fecundity values
#' @param sample_size matrix of sample size for each element of the matrix, or a
#'   single value applied to the whole matrix
#' @param split logical, whether to split the output into survival and fecundity
#'   matrices or not
#' @return list of matrices of survival and fecundity if split = TRUE, otherwise
#'   a single matrix of the sum of survival and fecundity
#' @examples
#' mats <- make_leslie_matrix(
#'   survival = c(0.1, 0.2, 0.5),
#'   fertility = c(0, 1.2, 2.4),
#'   n_stages = 3, split = TRUE
#' )
#' ssMat <- matrix(10, nrow = 3, ncol = 3)
#'
#' simulate_mpm(
#'   matU = mats$matU, matF = mats$matF,
#'   sample_size = ssMat, split = TRUE
#' )
#' @export simulate_mpm
#'
simulate_mpm <- function(matU, matF, sample_size, split = TRUE) {

  # Validation
  if (!inherits(matU, "matrix")) {
    stop("matU needs to be a matrix")
  }

  if (!inherits(matF, "matrix")) {
    stop("matF needs to be a matrix")
  }

  if (nrow(matU) != nrow(matF)) {
    stop("the dimensions of matU and matF are not equal")
  }

  if (nrow(matU) != ncol(matU)) {
    stop("matU is not a square matrix")
  }

  if (nrow(matF) != ncol(matF)) {
    stop("matU is not a square matrix")
  }


  if (!(inherits(sample_size, "matrix") || length(sample_size) == 1)) {
    stop("sample_size needs to be a matrix, or an integer with length 1")
  }

  if (inherits(sample_size, "matrix")) {
    if (nrow(sample_size) != nrow(matU)) {
      stop("if sample_size is a matrix, it needs to be of the same dimension as matU")
    }
  }

  if (!all(matU >= 0)) {
    stop("matU must include only values >= 0")
  }

  if (!all(matF >= 0)) {
    stop("matF must include only values >= 0")
  }

  if (!all(sample_size > 0)) {
    stop("sample_size must include only values > 0")
  }

  if (!is.logical(split)) {
    stop("split must be a logical value (TRUE/FALSE).")
  }

  if (!min(abs(c(sample_size %% 1, sample_size %% 1 - 1))) < .Machine$double.eps^0.5) {
    stop("sample_size must be integer value(s)")
  }

  if (!min(sample_size) > 0) {
    stop("sample_size must be > 0")
  }

  # Convert the matrix into a vector
  vectU <- as.vector(matU)
  vectF <- as.vector(matF)

  if (length(sample_size) == 1) {
    sample_size <- matrix(sample_size, ncol = ncol(matU), nrow = nrow(matU))
  }

  vectSampleSize <- as.vector(sample_size)

  # Simulate the matrix based on the information provided
  survResults <- mapply(
    FUN = simSurv, probSurv = vectU,
    sample_size = vectSampleSize
  )

  fecResults <- mapply(
    FUN = simFec, meanFec = vectF,
    sample_size = vectSampleSize
  )

  matU_out <- matrix(survResults,
    nrow = sqrt(length(vectU)),
    ncol = sqrt(length(vectU))
  )
  matF_out <- matrix(fecResults,
    nrow = sqrt(length(vectF)),
    ncol = sqrt(length(vectU))
  )

  if (split) {
    return(list(matU = matU_out, matF = matF_out))
  } else {
    return(matU_out + matF_out)
  }
}
