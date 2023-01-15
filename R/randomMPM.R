#' Generate random matrix population models (MPMs).
#'
#' Generates random matrix population models (MPMs) with element values based on defined life history archetypes. Survival and transition/growth probabilities from any particular stage are restricted to be less than or equal to 1 by drawing from a Dirichlet distribution. The user can specify archetypes to restrict the MPMs in other ways:
#' - Archetype 1: all elements are positive, although they may be very small. Therefore, transition from/to any stage is possible. This model describes a life history where individuals can progress and retrogress rapidly.
#' - Archetype 2: has the same form as archetype 1 (transition from/to any stage is possible), but the survival probability (column sums of the survival matrix) increases monotonously as the individuals advance to later stages. This model, as the one in the first archetype, also allows for rapid progression and retrogression, but is more realistic in that stage-specific survival probability increases with stage advancement.
#' - Archetype 3: positive non-zero elements for survival are only allowed on the diagonal and lower sub-diagonal of the matrix This model represents the life cycle of a species where retrogression is not allowed, and progression can only happen to the immediately larger/more developed stage (slow progression, e.g., trees).
#' - Archetype 4: This archetype has the same general form as archetype 3, but with the further assumption that stage-specific survival increases as individuals increase in size/developmental stage. In this respect it is similar to archetype 2.
#'
#' In all 4 of these Archetypes, fecundity is placed as a single element on the top right of the matrix, if it is a single value. If it is a vector of length `nStage` then the fertility vector spans the entire top row of the matrix.
#'
#' Based on the paper: Takada, T., Kawai, Y., & Salguero-Gómez, R. (2018). A cautionary
#' note on elasticity analyses in a ternary plot using randomly generated population
#' matrices. Population Ecology, 60(1), 37–47.
#'
#' @param nStage An integer defining the number of stages for the MPM.
#' @param Fec Mean fecundity. This value is the lambda value for a Poisson distribution from which a value for fecundity is drawn. An integer of length 1 or a vector of integers of length equal to the number of stages. If there is no reproduction in a particular age class, use a value of 0.
#' @param archetype Indication of which life history archetype should be used, based on Takada et al. 2018. An integer between 1 and 4.
#' @param split TRUE/FALSE, indicating whether the matrix produced should be split into a survival matrix and a fertility matrix. Yeah true, then the output becomes a list with a matrix in each element. Otherwise, the output is a single matrix.
#'
#' @return Returns a random matrix population model with characteristics determined by the archetype selected and fecundity vector. If split = TRUE, the matrix is split into separate fertility and a growth/survival matrices, returned as a list.
#'
#' @author Owen Jones <jones@biology.sdu.dk>
#'
#' @keywords utilities
#'
#' @importFrom MCMCpack rdirichlet
#'
#' @examples
#' randomMPM(nStage = 2, Fec = 20, archetype = 1, split = FALSE)
#' randomMPM(nStage = 2, Fec = 20, archetype = 2, split = TRUE)
#' randomMPM(nStage = 3, Fec = 20, archetype = 3, split = FALSE)
#' randomMPM(nStage = 4, Fec = 20, archetype = 4, split = TRUE)
#' randomMPM(nStage = 5, Fec = c(0,0,4,8,10), archetype = 4, split = TRUE)
#'
#' @export randomMPM
#'


randomMPM <- function(nStage,
                      Fec,
                      archetype = 1,
                      split = FALSE) {

  # Check that nStage is an integer greater than 0
  if (!min(abs(c(nStage %% 1, nStage %% 1 - 1))) < .Machine$double.eps^0.5 || nStage <= 0) {
    stop("nStage must be an integer greater than 0.")
  }

  # Check that Fec is a numeric vector of length 1 or nStage
  if (!is.numeric(Fec) || !(length(Fec) %in% c(1, nStage))) {
    stop("Fec must be a numeric vector of length 1 or nStage.")
  }

  # Check that split is a logical value
  if (!is.logical(split)) {
    stop("split must be a logical value (TRUE/FALSE).")
  }


  # Check that archetype is an integer between 1 and 4
  if (!min(abs(c(archetype %% 1, archetype %% 1 - 1))) < .Machine$double.eps^0.5 || archetype < 1 || archetype > 4) {
    stop("archetype must be an integer between 1 and 4.")
  }

  # Archetype 1: all elements are positive, allowing for rapid progression and
  # retrogression
  if (archetype == 1) {
    matU <- t(rdirichlet(nStage + 1, rep(1, nStage + 1)))
    # remove the "death" stage that is necessary when using the Dirichlet
    # distribution.
    matU <- matU[1:nStage, 1:nStage]
  }

  # Archetype 2 - when survival rates increase. i.e. where the column sums
  # increase moving from left to right.
  if (archetype == 2) {
    matU <- t(rdirichlet(nStage + 1, rep(1, nStage + 1)))
    # remove the "death" stage that is necessary when using the Dirichlet
    # distribution.
    matU <- matU[1:nStage, 1:nStage]
    B <- matU
    matU <- matU[, order(colSums(B))]
  }
  # Archetype 3 - Fertility is in top right corner only. Non-zero transitions
  # only on diagonal and subdiagonal.
  if (archetype == 3) {
    if (nStage == 2) {
      stop("Archetype 3 does not exist for 2x2 MPMs")
    }

    x <- diag(nStage + 1)
    x[row(x) == col(x) + 1] <- 1
    x[nrow(x), ] <- 1

    matU <- matrix(ncol = nStage + 1, nrow = nStage + 1)
    for (i in 1:(nStage + 1)) {
      matU[i, ] <- rdirichlet(1, x[, i])
    }
    matU <- t(matU)
    matU <- matU[1:nStage, 1:nStage]
  }

  # Archetype 4 - As in archetype 3, Fertility is in top right corner only.
  # Non-zero transitions only on diagonal and subdiagonal. However in addiiton,
  # there is also a rule of increasing survival from stage to stage as in
  # Archetype 2.
  if (archetype == 4) {
    if (nStage == 2) {
      stop("Archetype 4 does not exist for 2x2 MPMs")
    }

    x <- diag(nStage + 1)
    x[row(x) == col(x) + 1] <- 1
    x[nrow(x), ] <- 1
    surv <- t(rdirichlet(nStage, rep(1, 3)))
    surv <- surv[, 1:(nStage - 1)]

    # Order by colsums for the first two rows.
    surv <- surv[1:2, order(colSums(surv[1:2, ]))]
    surv <- as.vector(surv)
    last2 <- ((nStage - 1) * 2 - 1):((nStage - 1) * 2)
    finalStageSurv <- runif(1, sum(surv[last2]), 1)
    surv <- c(surv, finalStageSurv)
    matU <- x[1:nStage, 1:nStage]
    matU[matU == 1] <- surv
  }

  # Calculate Fecundity and place in top row.
  # In the Takada archetypes, fecundity is ONLY placed in the top right. Here,
  # if the length of the fecundity vector (Fec) is 1, then that is exactly what
  # we do...
  matF <- matrix(0, nrow = nStage, ncol = nStage)

  if (length(Fec) == 1) {
    matF[1, nStage] <- rpois(n = 1, lambda = Fec)
  }

  # ... if the length is >1, then the fecundity vector of length nStage is added
  # to the top row.
  if (length(Fec) > 1) {
    fecVect <- rpois(n = nStage, lambda = Fec)
    matF[1, ] <- fecVect
  }

  # Output the results
  if (split) {
    matA_split <- list(matU = matU, matF = matF)
    return(matA_split)
  } else {
    matA <- matU + matF
    return(matA)
  }
}
