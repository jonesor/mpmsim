#' Generate random Lefkovitch matrix population models (MPMs) based on life
#' history archetypes
#'
#' Generates a random matrix population model (MPM) with element values based on
#' defined life history archetypes. Survival and transition/growth probabilities
#' from any particular stage are restricted to be less than or equal to 1 by
#' drawing from a Dirichlet distribution. The user can specify archetypes (from
#' Takada et al. 2018) to restrict the MPMs in other ways:
#' - Archetype 1: all elements are positive, although they may be very small.
#' Therefore, transition from/to any stage is possible. This model describes a
#' life history where individuals can progress and retrogress rapidly.
#' - Archetype 2: has the same form as archetype 1 (transition from/to any stage
#' is possible), but the survival probability (column sums of the survival
#' matrix) increases monotonously as the individuals advance to later stages.
#' This model, as the one in the first archetype, also allows for rapid
#' progression and retrogression, but is more realistic in that stage-specific
#' survival probability increases with stage advancement.
#' - Archetype 3: positive non-zero elements for survival are only allowed on
#' the diagonal and lower sub-diagonal of the matrix This model represents the
#' life cycle of a species where retrogression is not allowed, and progression
#' can only happen to the immediately larger/more developed stage (slow
#' progression, e.g., trees).
#' - Archetype 4: This archetype has the same general form as archetype 3, but
#' with the further assumption that stage-specific survival increases as
#' individuals increase in size/developmental stage. In this respect it is
#' similar to archetype 2.
#'
#' In all 4 of these Archetypes, reproductive output is placed as a
#' single element on the top right of the matrix, if it is a single value. If it
#' is a vector of length `n_stages` then the reproduction vector spans the entire
#' top row of the matrix.
#'
#' The function is constrained to only output ergodic matrices.
#'
#' @references
#'
#' Caswell, H. (2001). Matrix Population Models: Construction, Analysis, and
#' Interpretation. Sinauer.
#'
#' Lefkovitch, L. P. (1965). The study of population growth in organisms grouped
#' by stages. Biometrics, 21(1), 1.
#'
#' Takada, T., Kawai, Y., & Salguero-Gómez, R. (2018). A cautionary note on
#' elasticity analyses in a ternary plot using randomly generated population
#' matrices. Population Ecology, 60(1), 37–47.
#'
#' @param n_stages An integer defining the number of stages for the MPM.
#' @param reproduction Reproduction measures reproductive output as the average number
#'   of offspring produced.
#'   Values can be provided in 4 ways:
#'   - An numeric vector of length 1 to provide a single reproduction measure to
#'   the top right corner of the matrix model only.
#'   - A numeric vector of integers of length equal to `n_stages` to provide
#'   reproduction estimates for the whole top row of the matrix model. Use 0 for
#'   cases with no reproduction.
#'   - A matrix of numeric values of the same dimension as `n_stages` to provide
#'   reproduction estimates for the entire matrix model. Use 0 for cases with no
#'   reproduction.
#'   - A list of two matrices of numeric values, both with the same dimension as
#'   `n_stages`, to provide lower and upper limits of mean reproduction for the
#'   entire matrix model. Use 0 for both lower and upper limits in cases with no
#'   reproduction.
#'
#'   In the latter case, a reproduction value will be drawn from a uniform
#'   distribution for the defined range. If there is no reproduction in a
#'   particular age class, use a value of 0 for both the lower and upper limit.
#' @param archetype Indication of which life history archetype should be used,
#'   based on Takada et al. 2018. An integer between 1 and 4.
#' @param split `TRUE`/`FALSE`, indicating whether the matrix produced should be
#'   split into a survival matrix and a reproductive output matrix. If true,
#'   then the output becomes a list with a matrix in each element. Otherwise,
#'   the output is a single matrix. Default is `TRUE`.
#'
#' @return Returns a random matrix population model with characteristics
#'   determined by the archetype selected and reproduction vector. If split = TRUE,
#'   the matrix is split into separate reproductive output and growth/survival
#'   matrices, returned as a list.
#' @family Lefkovitch matrices
#' @author Owen Jones <jones@biology.sdu.dk>
#'
#' @importFrom popdemo isErgodic
#' @importFrom stats rgamma
#'
#' @examples
#' set.seed(42) # set seed for repeatability
#'
#' rand_lefko_mpm(n_stages = 2, reproduction = 20, archetype = 1, split = FALSE)
#' rand_lefko_mpm(n_stages = 2, reproduction = 20, archetype = 2, split = TRUE)
#' rand_lefko_mpm(n_stages = 3, reproduction = 20, archetype = 3, split = FALSE)
#' rand_lefko_mpm(n_stages = 4, reproduction = 20, archetype = 4, split = TRUE)
#' rand_lefko_mpm(
#'   n_stages = 5, reproduction = c(0, 0, 4, 8, 10), archetype = 4,
#'   split = TRUE
#' )
#' # Using a range of values for reproduction
#' rand_lefko_mpm(n_stages = 2, reproduction = 20, archetype = 1, split = TRUE)
#'
#' @seealso [rand_lefko_set()] which is a wrapper for this function allowing the
#'   generation of large numbers of random matrices of this type.
#' @export rand_lefko_mpm
#'


rand_lefko_mpm <- function(n_stages,
                           reproduction,
                           archetype = 1,
                           split = TRUE) {
  # Check that n_stages is an integer greater than 0
  if (!min(abs(c(n_stages %% 1, n_stages %% 1 - 1))) <
    .Machine$double.eps^0.5 || n_stages <= 0) {
    stop("n_stages must be an integer greater than 0.")
  }

  # Check that split is a logical value
  if (!is.logical(split)) {
    stop("split must be a logical value.")
  }

  # Check that archetype is an integer between 1 and 4
  if (!min(abs(c(archetype %% 1, archetype %% 1 - 1))) <
    .Machine$double.eps^0.5 || archetype < 1 || archetype > 4) {
    stop("archetype must be an integer between 1 and 4.")
  }

  # Function to validate reproduction argument
  validate_reproduction <- function(reproduction, n_stages) {
    # Check if reproduction is a single numeric value
    if (is.numeric(reproduction) && length(reproduction) == 1) {
      return(TRUE)
    }

    # Check if reproduction is a numeric vector of length n_stages
    if (is.numeric(reproduction) && length(reproduction) == n_stages) {
      return(TRUE)
    }

    # Check if reproduction is a square matrix with dimension n_stages
    if (is.matrix(reproduction) && all(dim(reproduction) == c(n_stages, n_stages))) {
      return(TRUE)
    }

    # Check if reproduction is a list of two matrices, each with dimension n_stages
    if (is.list(reproduction) && length(reproduction) == 2 &&
      is.matrix(reproduction[[1]]) && all(dim(reproduction[[1]]) ==
      c(n_stages, n_stages)) &&
      is.matrix(reproduction[[2]]) &&
      all(dim(reproduction[[2]]) == c(n_stages, n_stages))) {
      return(TRUE)
    }

    # If none of the above conditions are satisfied, return FALSE
    return(FALSE)
  }

  if (!validate_reproduction(reproduction, n_stages)) {
    stop("Invalid reproduction input. See ?rand_lefko_mpm")
  }

  if (inherits(reproduction, "list")) {
    if (!all(reproduction[[2]] - reproduction[[1]] >= 0)) {
      stop("Invalid matrix input: the values in the lower bound reproduction matrix
      should be less than or equal to the values in the upper bound reproduction
           matrix.")
    }
  }

  if (inherits(reproduction, "matrix")) {
    if (!all(reproduction >= 0)) {
      stop("Invalid matrix input: reproduction values must not be negative.")
    }
  }

  ergodicity <- FALSE
  while (ergodicity == FALSE) {
    # Archetype 1: all elements are positive, allowing for rapid progression and
    # retrogression
    if (archetype == 1) {
      mat_U <- t(r_dirichlet(n_stages + 1, rep(1, n_stages + 1)))
      # remove the "death" stage that is necessary when using the Dirichlet
      # distribution.
      mat_U <- mat_U[1:n_stages, 1:n_stages]
    }

    # Archetype 2 - when survival rates increase. i.e. where the column sums
    # increase moving from left to right.
    if (archetype == 2) {
      mat_U <- t(r_dirichlet(n_stages + 1, rep(1, n_stages + 1)))
      # remove the "death" stage that is necessary when using the Dirichlet
      # distribution.
      mat_U <- mat_U[1:n_stages, 1:n_stages]
      b <- mat_U
      mat_U <- mat_U[, order(colSums(b))]
    }
    # Archetype 3 - reproduction is in top right corner only. Non-zero transitions
    # only on diagonal and subdiagonal.
    if (archetype == 3) {
      if (n_stages == 2) {
        stop("Archetype 3 does not exist for 2x2 MPMs")
      }

      x <- diag(n_stages + 1)
      x[row(x) == col(x) + 1] <- 1
      x[nrow(x), ] <- 1

      mat_U <- matrix(ncol = n_stages + 1, nrow = n_stages + 1)
      for (i in 1:(n_stages + 1)) {
        mat_U[i, ] <- r_dirichlet(1, x[, i])
      }
      mat_U <- t(mat_U)
      mat_U <- mat_U[1:n_stages, 1:n_stages]
    }

    # Archetype 4 - As in archetype 3, reproduction is in top right corner only.
    # Non-zero transitions only on diagonal and subdiagonal. However in
    # addition, there is also a rule of increasing survival from stage to stage
    # as in Archetype 2.
    if (archetype == 4) {
      if (n_stages == 2) {
        stop("Archetype 4 does not exist for 2x2 MPMs")
      }

      x <- diag(n_stages + 1)
      x[row(x) == col(x) + 1] <- 1
      x[nrow(x), ] <- 1
      surv <- t(r_dirichlet(n_stages, rep(1, 3)))
      surv <- surv[, 1:(n_stages - 1)]

      # Order by colsums for the first two rows.
      surv <- surv[1:2, order(colSums(surv[1:2, ]))]
      surv <- as.vector(surv)
      last2 <- ((n_stages - 1) * 2 - 1):((n_stages - 1) * 2)
      final_stage_surv <- runif(1, sum(surv[last2]), 1)
      surv <- c(surv, final_stage_surv)
      mat_U <- x[1:n_stages, 1:n_stages]
      mat_U[mat_U == 1] <- surv
    }

    # reproduction
    if (inherits(reproduction, "numeric")) {
      # Create an empty matrix to initialise.
      mat_F <- matrix(0, nrow = n_stages, ncol = n_stages)
      # Calculate reproduction and place in top row. In the Takada archetypes,
      # reproduction is ONLY placed in the top right. Here, if the length of the
      # reproduction vector (reproduction) is 1, then that is exactly what we do...

      if (length(reproduction) == 1) {
        mat_F[1, n_stages] <- reproduction
      }

      # ... if the length is >1, then the reproduction vector of length n_stages is
      # added to the top row.
      if (length(reproduction) > 1) {
        mat_F[1, ] <- reproduction
      }
    }

    # if reproduction is a list of matrices (lower and upper values for reproduction)
    # then values for mean reproduction are drawn from a uniform distribution.
    if (inherits(reproduction, "list")) {
      mat_F <- matrix(
        runif(n_stages^2,
          min = reproduction[[1]],
          max = reproduction[[2]]
        ),
        nrow = n_stages, ncol = n_stages
      )
    }

    # if reproduction is a matrix (of mean reproduction values))
    # we just use that matrix
    if (inherits(reproduction, "matrix")) {
      mat_F <- reproduction
    }

    # Check ergodicity
    mat_A_temp <- mat_U + mat_F
    ergodicity <- isErgodic(mat_A_temp)
  }
  # Output the results
  if (split) {
    mat_A_split <- list(mat_A = mat_U + mat_F, mat_U = mat_U, mat_F = mat_F)
    return(mat_A_split)
  } else {
    mat_A <- mat_U + mat_F
    return(mat_A)
  }
}


#' Generate Samples from a Dirichlet Distribution
#'
#' This function generates random samples from a Dirichlet distribution. The
#' Dirichlet distribution is a multivariate generalization of the beta
#' distribution, defined by a vector of positive concentration parameters
#' (alpha). These parameters influence the shape and concentration of the
#' distribution across its dimensions. Specifically, an alpha value of 1
#' signifies a uniform distribution over the simplex, indicating equal
#' likelihood for all outcomes and a lack of prior bias or information.
#'
#' @param n Integer, the number of samples to generate.
#' @param alpha Numeric vector, the concentration parameters for the Dirichlet
#'   distribution. Each element must be positive. The length of the vector
#'   determines the dimensionality of the Dirichlet distribution. Higher values
#'   in the alpha vector indicate a higher concentration of the distribution
#'   towards the corresponding dimension, while lower values indicate less
#'   concentration. An alpha value of 1 for all parameters implies a uniform
#'   distribution over the simplex, reflecting equal likelihood for all
#'   combinations of outcomes that sum to 1. This represents a state of complete
#'   ignorance or lack of prior information in Bayesian terms, akin to a
#'   non-informative prior.
#'
#' @return A matrix with n rows and length(alpha) columns, where each row is a
#'   sample from the Dirichlet distribution.
#'
#' @examples
#' n <- 5 # Size of the sample
#' alpha <- c(1, 1, 1) # Example concentration parameters
#' r_dirichlet(n, alpha)
#'
#' @noRd
r_dirichlet <- function(n, alpha) {
  result <- matrix(NA, nrow = n, ncol = length(alpha))

  for (i in 1:n) {
    gamma_samples <- rgamma(length(alpha), shape = alpha, rate = 1)
    result[i, ] <- gamma_samples / sum(gamma_samples)
  }

  return(result)
}
