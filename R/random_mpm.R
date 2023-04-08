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
#' In all 4 of these Archetypes, fecundity is placed as a single element on the
#' top right of the matrix, if it is a single value. If it is a vector of length
#' `n_stages` then the fertility vector spans the entire top row of the matrix.
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
#' @param fecundity Mean fecundity. This value is the lambda value for a Poisson
#'   distribution from which a value for fecundity is drawn. An integer of
#'   length 1 or a vector of integers of length equal to the number of stages.
#'   If there is no reproduction in a particular age class, use a value of 0.
#' @param archetype Indication of which life history archetype should be used,
#'   based on Takada et al. 2018. An integer between 1 and 4.
#' @param split TRUE/FALSE, indicating whether the matrix produced should be
#'   split into a survival matrix and a fertility matrix. Yeah true, then the
#'   output becomes a list with a matrix in each element. Otherwise, the output
#'   is a single matrix.
#'
#' @return Returns a random matrix population model with characteristics
#'   determined by the archetype selected and fecundity vector. If split = TRUE,
#'   the matrix is split into separate fertility and a growth/survival matrices,
#'   returned as a list.
#' @family simulation
#' @author Owen Jones <jones@biology.sdu.dk>
#'
#' @importFrom MCMCpack rdirichlet
#' @importFrom popdemo isErgodic
#'
#' @examples
#' random_mpm(n_stages = 2, fecundity = 20, archetype = 1, split = FALSE)
#' random_mpm(n_stages = 2, fecundity = 20, archetype = 2, split = TRUE)
#' random_mpm(n_stages = 3, fecundity = 20, archetype = 3, split = FALSE)
#' random_mpm(n_stages = 4, fecundity = 20, archetype = 4, split = TRUE)
#' random_mpm(
#'   n_stages = 5, fecundity = c(0, 0, 4, 8, 10), archetype = 4,
#'   split = TRUE
#' )
#' @seealso [generate_mpm_set()] which is a wrapper for this function allowing
#'   the generation of large numbers of random matrices of this type.
#' @export random_mpm
#'


random_mpm <- function(n_stages,
                       fecundity,
                       archetype = 1,
                       split = FALSE) {
  # Check that n_stages is an integer greater than 0
  if (!min(abs(c(n_stages %% 1, n_stages %% 1 - 1))) <
    .Machine$double.eps^0.5 || n_stages <= 0) {
    stop("n_stages must be an integer greater than 0.")
  }

  # Check that fecundity is a numeric vector of length 1 or n_stages
  if (!is.numeric(fecundity) || !(length(fecundity) %in% c(1, n_stages))) {
    stop("fecundity must be a numeric vector of length 1 or n_stages.")
  }

  # Check that split is a logical value
  if (!is.logical(split)) {
    stop("split must be a logical value (TRUE/FALSE).")
  }

  # Check that archetype is an integer between 1 and 4
  if (!min(abs(c(archetype %% 1, archetype %% 1 - 1))) <
    .Machine$double.eps^0.5 || archetype < 1 || archetype > 4) {
    stop("archetype must be an integer between 1 and 4.")
  }
  ergodicity <- FALSE
  while (ergodicity == FALSE) {
    # Archetype 1: all elements are positive, allowing for rapid progression and
    # retrogression
    if (archetype == 1) {
      mat_U <- t(rdirichlet(n_stages + 1, rep(1, n_stages + 1)))
      # remove the "death" stage that is necessary when using the Dirichlet
      # distribution.
      mat_U <- mat_U[1:n_stages, 1:n_stages]
    }

    # Archetype 2 - when survival rates increase. i.e. where the column sums
    # increase moving from left to right.
    if (archetype == 2) {
      mat_U <- t(rdirichlet(n_stages + 1, rep(1, n_stages + 1)))
      # remove the "death" stage that is necessary when using the Dirichlet
      # distribution.
      mat_U <- mat_U[1:n_stages, 1:n_stages]
      b <- mat_U
      mat_U <- mat_U[, order(colSums(b))]
    }
    # Archetype 3 - Fertility is in top right corner only. Non-zero transitions
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
        mat_U[i, ] <- rdirichlet(1, x[, i])
      }
      mat_U <- t(mat_U)
      mat_U <- mat_U[1:n_stages, 1:n_stages]
    }

    # Archetype 4 - As in archetype 3, Fertility is in top right corner only.
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
      surv <- t(rdirichlet(n_stages, rep(1, 3)))
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

    # Calculate Fecundity and place in top row.
    # In the Takada archetypes, fecundity is ONLY placed in the top right. Here,
    # if the length of the fecundity vector (fecundity) is 1, then that is
    # exactly what we do...
    mat_F <- matrix(0, nrow = n_stages, ncol = n_stages)

    if (length(fecundity) == 1) {
      mat_F[1, n_stages] <- rpois(n = 1, lambda = fecundity)
    }

    # ... if the length is >1, then the fecundity vector of length n_stages is
    # added to the top row.
    if (length(fecundity) > 1) {
      fecundity_vector <- rpois(n = n_stages, lambda = fecundity)
      mat_F[1, ] <- fecundity_vector
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
