#' Generate lists of Lefkovitch matrix population models (MPMs) based on life
#' history archetypes
#'
#' This function is deprecated. Use `rand_lefko_set` instead.
#'
#' This function generates a list of `n` MPMs according to the specified
#' criteria. Criteria include the `archetype`, and the acceptable constraining
#' criteria, which could include lambda, generation time or any other metric
#' derived from an A matrix.
#' The function attempts to find matrices that fulfil the criteria, discarding
#' unacceptable matrices. By default, if it takes more than 1000 attempts to
#' find a suitable matrix model, then an error is produced. However, the number
#' of attempts can be altered with the `attempts` parameter.
#'
#' @param n The number of MPMs to generate. Default is 10.
#' @param n_stages The number of stages for the MPMs. Default is 3.
#' @param archetype The archetype of the MPMs. Default is 1.
#' @param fecundity A vector of fecundities for the MPMs. Default is 1.5.
#' @param split A logical indicating whether to split into submatrices. Default
#'   is TRUE.
#' @param by_type A logical indicating whether the matrices should be returned
#'   in a list by type (A, U, F, C). If split is `FALSE`, then `by_type` must
#'   is coerced to be `FALSE`. Defaults to `TRUE`.
#' @param as_compadre A logical indicating whether the matrices should be
#'   returned as a `CompadreDB` object. Default is `TRUE`. If `FALSE`, the
#'   function returns a list.
#' @param max_surv The maximum acceptable survival value, calculated across all
#'   transitions from a stage. Defaults to 0.99. This is only used if `split =
#'   TRUE`.
#' @param constraint An optional data frame with 4 columns named `fun`, `arg`,
#'   `lower` and `upper`. These columns specify (1) a function that outputs a
#'   metric derived from an A matrix and (2) an argument for the function (`NA`,
#'   if no argument supplied) (3) the lower acceptable bound for the metric and
#'   (4) upper acceptable bound for the metric. This could be used to specify
#' @param attempts An integer indicating the number of attempts To be made when
#'   simulating matrix model. The default is 1000. If it takes more than 1000
#'   attempts to make a matrix that satisfies the conditions set by the other
#'   arguments, then a warning is produced.
#' @return A list of MPMs that meet the specified criteria.
#'
#' @author Owen Jones <jones@biology.sdu.dk>
#' @examples
#' set.seed(42) # set seed for repeatability
#'
#' # Basic operation, without splitting matrices and with no constraints
#' generate_mpm_set(
#'   n = 10, n_stages = 5, fecundity = c(0, 0, 4, 8, 10),
#'   archetype = 4, split = FALSE, by_type = FALSE, as_compadre = FALSE
#' )
#'
#' # Constrain outputs to A matrices with lambda between 0.9 and 1.1
#' library(popbio)
#' constrain_df <- data.frame(
#'   fun = "lambda", arg = NA, lower = 0.9, upper =
#'     1.1
#' )
#' generate_mpm_set(
#'   n = 10, n_stages = 5, fecundity = c(0, 0, 4, 8, 10),
#'   archetype = 4, constraint = constrain_df, as_compadre = FALSE
#' )
#'
#' # As above, but using popdemo::eigs function instead of popbio::lambda
#' # to illustrate use of argument
#' library(popdemo)
#' constrain_df <- data.frame(
#'   fun = "eigs", arg = "lambda", lower = 0.9, upper =
#'     1.1
#' )
#' generate_mpm_set(
#'   n = 10, n_stages = 5, fecundity = c(0, 0, 4, 8, 10),
#'   archetype = 4, constraint = constrain_df, as_compadre = FALSE
#' )
#'
#' # Multiple constraints
#' # Constrain outputs to A matrices with lambda between 0.9 and 1.1, generation
#' # time between 3 and 5 and damping ratio between 1 and 7.
#' library(popbio)
#' constrain_df <- data.frame(
#'   fun = c("lambda", "generation.time", "damping.ratio"),
#'   arg = c(NA, NA, NA),
#'   lower = c(0.9, 3.0, 1.0),
#'   upper = c(1.1, 5.0, 7.0)
#' )
#' generate_mpm_set(
#'   n = 10, n_stages = 5, fecundity = c(0, 0, 4, 8, 10),
#'   archetype = 4, constraint = constrain_df, as_compadre = FALSE
#' )
#'
#' @seealso [random_mpm()] which this function is essentially a wrapper for.
#' @family Lefkovitch matrices
#' @importFrom Rcompadre cdb_build_cdb
#' @export generate_mpm_set

generate_mpm_set <- function(n = 10,
                             n_stages = 3,
                             archetype = 1,
                             fecundity = 1.5,
                             split = TRUE,
                             by_type = TRUE,
                             as_compadre = TRUE,
                             max_surv = 0.99,
                             constraint = NULL,
                             attempts = 1000) {
  .Deprecated("rand_lefko_set")

  # Check if n is a positive integer
  if (!min(abs(c(n %% 1, n %% 1 - 1))) < .Machine$double.eps^0.5 || n <= 0) {
    stop("n must be a positive integer")
  }

  if (split == FALSE) {
    if (by_type == TRUE) {
      by_type <- FALSE
      warning("Split is set to FALSE; by_type has been coerced to be FALSE")
    }
  }

  # Set up empty list of desired length
  output_list <- vector("list", n)

  attempt <- 1
  while (any(vapply(output_list, is.null, logical(1)))) {
    # Generate an MPM
    mpm_out <- random_mpm(
      n_stages = n_stages, archetype = archetype,
      fecundity = fecundity, split = split
    )

    # Check whether survival values are acceptable
    if (split == TRUE) {
      survival_value_accepted <- max(colSums(mpm_out$mat_U)) < max_surv
    } else {
      survival_value_accepted <- TRUE
    }

    # Check whether optional function output is acceptable

    if (is.null(constraint)) {
      fun_output_accepted <- TRUE
    }

    if (!is.null(constraint)) {
      nConstraints <- nrow(constraint)
      constraint_OK <- rep(NA, nConstraints)

      if (split == TRUE) {
        mat_A_temp <- mpm_out$mat_U + mpm_out$mat_F
      } else {
        mat_A_temp <- mpm_out
      }

      for (k in 1:nConstraints) {
        constraint_focal <- constraint[k, ]
        constraint_function <- match.fun(constraint_focal[, 1])

        if (is.na(constraint_focal[, 2])) {
          args_list <- list(mat_A_temp)
        } else {
          args_list <- list(A = mat_A_temp, constraint_focal[, 2])
        }
        fun_output <- do.call(constraint_function, args_list)

        # Check that the fun_output is acceptable.
        lower_bound <- constraint_focal[3]
        upper_bound <- constraint_focal[4]

        fun_output_accepted <- fun_output < upper_bound &
          fun_output > lower_bound

        constraint_OK[k] <- fun_output_accepted
      }
    }

    if (survival_value_accepted && fun_output_accepted) {
      # if values are acceptable, add the matrix to the output_list
      # (otherwise do nothing)

      # If this is the first attempt, and the list is all NULL, then set i = 1
      if (all(vapply(output_list, is.null, logical(1)))) {
        i <- 1
      }

      # put the matrix (which may be split into mat_U and mat_F) into the list
      output_list[[i]] <- mpm_out

      # increment the i value
      i <- i + 1
      # set attempts back to 0
      attempt <- 0

      # check survival values are acceptable.
    }
    attempt <- attempt + 1
    if (attempt > attempts) {
      stop("It is taking a long time to find an acceptable matrix.\n
           Consider changing your criteria, or increase `attempts` argument.")
    }
  }

  if (by_type == TRUE) {
    A_list <- lapply(output_list, function(x) x$mat_A)
    U_list <- lapply(output_list, function(x) x$mat_U)
    F_list <- lapply(output_list, function(x) x$mat_F)
    output_list_by_type <- list(
      "A_list" = A_list,
      "U_list" = U_list,
      "F_list" = F_list
    )
    if (as_compadre == FALSE) {
      return(output_list_by_type)
    } else {
      return(cdb_build_cdb(mat_u = U_list, mat_f = F_list))
    }
  }
  if (by_type == FALSE) {
    if (as_compadre == FALSE) {
      return(output_list)
    } else {
      return(cdb_build_cdb(mat_a = output_list))
    }
  }
}
