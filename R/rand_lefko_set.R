#' Generate lists of Lefkovitch matrix population models (MPMs) based on life
#' history archetypes
#'
#' This function generates a list of `n` MPMs according to the specified
#' criteria. Criteria include the `archetype`, and the acceptable constraining
#' criteria, which could include lambda, generation time or any other metric
#' derived from an A matrix. The function attempts to find matrices that fulfil
#' the criteria, discarding unacceptable matrices. By default, if it takes more
#' than 1000 attempts to find a suitable matrix model, then an error is
#' produced. However, the number of attempts can be altered with the `attempts`
#' parameter.
#'
#' @param n_models An integer indicating the number of MPMs to generate.
#' @param n_stages The number of stages for the MPMs. Default is `3`.
#' @param archetype The archetype of the MPMs. Default is `1`.
#' @param fecundity The average number of offspring produced (fecundity).
#'   Values can be provided in 4 ways:
#'   - An numeric vector of length 1 providing a single measure of fecundity
#'   to the top right corner of the matrix model only.
#'   - A numeric vector of integers of length equal to `n_stages` to provide
#'   fecundity estimates for the whole top row of the matrix model. Use 0 for
#'   cases with no fecundity.
#'   - A matrix of numeric values of the same dimension as `n_stages` to provide
#'   fecundity estimates for the entire matrix model. Use 0 for cases with no
#'   fecundity.
#'   - A list of two matrices of numeric values, both with the same dimension as
#'   `n_stages`, to provide lower and upper limits of mean fecundity for the
#'   entire matrix model.
#'
#'   In the latter case, a fecundity value will be drawn from a uniform
#'   distribution for the defined range. If there is no fecundity in a
#'   particular age class, use a value of 0 for both the lower and upper limit.
#'
#' @param output Character string indicating the type of output.
#'
#' * `Type1`: A `compadreDB` Object containing MPMs split into the submatrices
#'   (i.e. A, U, F and C).
#' * `Type2`: A `compadreDB` Object containing MPMs that are not split into
#' submatrices (i.e. only the A matrix is included).
#' * `Type3`: A `list` of MPMs arranged so that each element of the list
#' contains a model and associated submatrices (i.e. the nth element contains
#' the nth A matrix alongside the nth U and F matrices).
#' * `Type4`: A `list` of MPMs arranged so that the list contains 3 lists for
#' the A  matrix and the U and F submatrices respectively.
#' * `Type5`: A `list` of MPMs, including only the A matrix.
#'
#'
#' @param max_surv The maximum acceptable survival value, calculated across all
#'   transitions from a stage. Defaults to `0.99`. This is only used the output
#'   splits a matrix into the submatrices.
#'
#' @param constraint An optional data frame with 4 columns named `fun`, `arg`,
#'   `lower` and `upper`. These columns specify (1) a function that outputs a
#'   metric derived from an A matrix and (2) an argument for the function (`NA`,
#'   if no argument supplied) (3) the lower acceptable bound for the metric and
#'   (4) upper acceptable bound for the metric.
#' @param attempts An integer indicating the number of attempts To be made when
#'   simulating matrix model. The default is 1000. If it takes more than 1000
#'   attempts to make a matrix that satisfies the conditions set by the other
#'   arguments, then a warning is produced.
#' @return A `compadreDB` object or list of MPMs that meet the specified
#'   criteria.
#'
#' @author Owen Jones <jones@biology.sdu.dk>
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
#' @examples
#' set.seed(42) # set seed for repeatability
#'
#' # Basic operation, without splitting matrices and with no constraints
#' rand_lefko_set(
#'   n_models = 3, n_stages = 5, fecundity = c(0, 0, 4, 8, 10),
#'   archetype = 4, output = "Type5"
#' )
#'
#' # Constrain outputs to A matrices with lambda between 0.9 and 1.1
#' library(popbio)
#' constrain_df <- data.frame(
#'   fun = "lambda", arg = NA, lower = 0.9, upper =
#'     1.1
#' )
#' rand_lefko_set(
#'   n_models = 10, n_stages = 5, fecundity = c(0, 0, 4, 8, 10),
#'   archetype = 4, constraint = constrain_df, output = "Type5"
#' )
#'
#' # As above, but using popdemo::eigs function instead of popbio::lambda
#' # to illustrate use of argument
#' library(popdemo)
#' constrain_df <- data.frame(
#'   fun = "eigs", arg = "lambda", lower = 0.9, upper = 1.1
#' )
#'
#' rand_lefko_set(
#'   n_models = 10, n_stages = 5, fecundity = c(0, 0, 4, 8, 10),
#'   archetype = 4, constraint = constrain_df, output = "Type5"
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
#' rand_lefko_set(
#'   n_models = 10, n_stages = 5, fecundity = c(0, 0, 4, 8, 10),
#'   archetype = 4, constraint = constrain_df, output = "Type5"
#' )
#'
#' @seealso [rand_lefko_mpm()] which this function is essentially a wrapper for.
#' @family Lefkovitch matrices
#' @importFrom Rcompadre cdb_build_cdb
#' @importFrom dplyr bind_cols
#' @export rand_lefko_set

rand_lefko_set <- function(n_models = 5, n_stages = 3, archetype = 1,
                           fecundity = 1.5,
                           output = "Type1", max_surv = 0.99,
                           constraint = NULL, attempts = 1000) {
  # Check if n is a positive integer
  if (!min(abs(c(n_models %% 1, n_models %% 1 - 1))) <
    .Machine$double.eps^0.5 || n_models <= 0) {
    stop("n_models must be a positive integer")
  }

  # Set up empty list of desired length
  output_list <- vector("list", n_models)
  archetypeParameters <- list()

  attempt <- 1

  if (output %in% c("Type1", "Type3", "Type4")) {
    splitValue <- TRUE
  } else {
    splitValue <- FALSE
  }

  while (any(vapply(output_list, is.null, logical(1)))) {
    # Generate an MPM
    mpm_out <- rand_lefko_mpm(
      n_stages = n_stages, archetype = archetype,
      fecundity = fecundity, split = splitValue
    )

    # Check whether survival values are acceptable
    if (output %in% c("Type1", "Type3", "Type4") == TRUE) {
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

      if (output %in% c("Type1", "Type3", "Type4")) {
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

      # output the archetype to the list
      archetypeParameters[[i]] <- archetype

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

  # If the output is Type1 or Type2, make a dataframe of metadata to be added to
  # the CompadreDB
  if (output %in% c("Type1", "Type2")) {
    archetype_df <- as.data.frame(do.call(rbind, archetypeParameters))
    colnames(archetype_df) <- "archetype"
    compadre_metadata <- bind_cols(archetype_df)
  }


  # `Type1`: A `compadreDB` Object containing MPMs split into the submatrices
  if (output == "Type1") {
    U_list <- lapply(output_list, function(x) x$mat_U)
    F_list <- lapply(output_list, function(x) x$mat_F)

    compadreObject <- suppressWarnings(
      cdb_build_cdb(
        mat_u = U_list, mat_f = F_list,
        metadata = compadre_metadata
      )
    )

    return(compadreObject)
  }

  # `Type2`: A `compadreDB` Object containing MPMs that are not split into
  # submatrices
  if (output == "Type2") {
    compadreObject <- suppressWarnings(
      cdb_build_cdb(mat_a = output_list, metadata = compadre_metadata)
    )
    return(compadreObject)
  }

  # `Type3`: A `list` of MPMs arranged so that each element of the list contains
  # a model and associated submatrices (i.e. the nth element contains the nth A
  # matrix alongside the nth U and F matrices).
  if (output == "Type3") {
    return(output_list)
  }

  # `Type4`: A `list` of MPMs arranged so the list contains 3 lists for the A, U
  # and F matrices.
  if (output == "Type4") {
    A_list <- lapply(output_list, function(x) x$mat_A)
    U_list <- lapply(output_list, function(x) x$mat_U)
    F_list <- lapply(output_list, function(x) x$mat_F)
    output_list_by_type <- list(
      "A_list" = A_list,
      "U_list" = U_list,
      "F_list" = F_list
    )
    return(output_list_by_type)
  }

  # `Type5`: A `list` of MPMs, including only the A matrix.
  if (output == "Type5") {
    return(output_list)
  }
}
