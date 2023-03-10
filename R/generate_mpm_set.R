#' Generate lists of matrix population models (MPMs) based on life history
#' archetypes
#'
#' This function generates a list of `n` MPMs according to the specified
#' criteria. Criteria include the `archetype`, and the acceptable lambda values.
#' The function attempts to find matrices that fulfill the lambda criteria,
#' discarding unacceptable matrices. If it takes more than 1000 attempts to find
#' a suitable matrix model, then an error is produced.
#'
#' @param n The number of MPMs to generate. Default is 10.
#' @param lower_lambda The lower bound for acceptable lambda values. Default is
#'   0.9.
#' @param upper_lambda The upper bound for acceptable lambda values. Default is
#'   1.1.
#' @param n_stages The number of stages for the MPMs. Default is 3.
#' @param archetype The archetype of the MPMs. Default is 1.
#' @param fecundity A vector of fecundities for the MPMs. Default is 1.5.
#' @param split A logical indicating whether to split matrices. Default is
#'   FALSE.
#' @return A list of MPMs that meet the specified criteria.
#'
#' @importFrom popdemo eigs
#' @author Owen Jones <jones@biology.sdu.dk>
#' @examples
#' generate_mpm_set(
#'   n = 10, lower_lambda = 0.9, upper_lambda = 1.1,
#'   n_stages = 5, fecundity = c(0, 0, 4, 8, 10), archetype = 4, split = TRUE
#' )
#'
#' @seealso [random_mpm()] which this function is essentially a wrapper for.
#' @export generate_mpm_set

generate_mpm_set <- function(n = 10, lower_lambda = 0.9, upper_lambda = 1.1,
                             n_stages = 3, archetype = 1, fecundity = 1.5,
                             split = FALSE) {
  # Check if n is a positive integer
  if (!min(abs(c(n %% 1, n %% 1 - 1))) < .Machine$double.eps^0.5 || n <= 0) {
    stop("n must be a positive integer")
  }

  # Check if lower_lambda is positive and less than upper_lambda
  if (lower_lambda <= 0 || lower_lambda >= upper_lambda) {
    stop("lower_lambda must be positive and less than upper_lambda")
  }

  # Check if upper_lambda is positive and greater than lower_lambda
  if (upper_lambda <= 0) {
    stop("upper_lambda must be positive")
  }

  # Check if upper_lambda is positive and greater than lower_lambda
  if (upper_lambda <= lower_lambda) {
    stop("upper_lambda must greater than lower_lambda")
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

    # Get lambda value
    if (split == TRUE) {
      lambda_value <- eigs(mpm_out$mat_U + mpm_out$mat_F, what = "lambda")
    } else {
      lambda_value <- eigs(mpm_out, what = "lambda")
    }

    # Check whether lambda value is acceptable
    lambda_value_accepted <- lambda_value < upper_lambda &
      lambda_value > lower_lambda

    if (lambda_value_accepted) {
      # if the lambda is acceptable, add the matrix to the output_list
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
    }
    attempt <- attempt + 1
    if (attempt > 1000) {
      stop("It is taking a long time to find an acceptable matrix.\n
           Consider changing your criteria.")
    }
  }
  return(output_list)
}
