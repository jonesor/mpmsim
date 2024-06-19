#' Generate a set of random Leslie Matrix Population Models
#'
#' Generates a set of Leslie matrix population models (MPMs) based on defined
#' mortality and fertility models, and using model parameters randomly drawn
#' from specified distributions.
#'
#' @param n_models An integer indicating the number of MPMs to generate.
#' @param mortality_model A character string specifying the name of the
#'   mortality model to be used. See `model_mortality`.
#' @param fertility_model A character string specifying the name of the
#'   fertility model to be used. See `model_fertility`.
#' @param mortality_params A two-column dataframe with a number of rows equal to
#'   the number of parameters in the mortality model. The required order of the
#'   parameters depends on the selected `mortality_model` (see
#'   `?model_mortality`):
#'   - For `Gompertz` and `Weibull`: \code{b_0}, \code{b_1}
#'   - For `GompertzMakeham` and `WeibullMakeham`: \code{b_0}, \code{b_1}, \code{C}
#'   - For `Exponential`: \code{C}
#'   - For `Siler`: \code{a_0}, \code{a_1}, \code{C}, \code{b_0}, \code{b_1}
#'   If `dist_type` is `uniform` these rows represent the lower and upper limits
#'   of the random uniform distribution from which the parameters are drawn. If
#'   `dist_type` is `normal`, the columns represent the mean and standard
#'   deviation of a random normal distribution from which the parameter values
#'   are drawn.
#' @param fertility_params A two-column dataframe with a number of rows equal to
#'   the number of parameters in the fertility model. The required order of the
#'   parameters depends on the selected `fertility_model` (see
#'   `?model_mortality`):
#'   - For `logistic`: \code{A}, \code{k}, \code{x_m}
#'   - For `step`: \code{A}
#'   - For `vonBertalanffy`: \code{A}, \code{k}
#'   - For `normal`: \code{A}, \code{mu}, \code{sd}
#'   - For `hadwiger`: \code{a}, \code{b}, \code{C}
#'   If `dist_type` is `uniform` these rows represent the lower and upper limits
#'   of the random uniform distribution from which the parameters are drawn. If
#'   `dist_type` is `normal`, the columns represent the mean and standard
#'   deviation of a random normal distribution from which the parameter values
#'   are drawn.
#' @param fertility_maturity_params A vector with two elements defining the
#'   distribution from which age at maturity is drawn for the models. The models
#'   will coerce fertility to be zero before this point. If `dist_type` is
#'   `uniform` these values represent the lower and upper limits of the random
#'   uniform distribution from which the parameters are drawn. If `dist_type` is
#'   `normal`, the values represent the mean and standard deviation of a random
#'   normal distribution from which the parameter values are drawn.
#' @param dist_type A character string specifying the type of distribution to
#'   draw parameters from. Default is `uniform`. Supported types are `uniform`
#'   and `normal`.
#' @param output Either `mpm` or `lifetable`, to output either as matrix
#'   population models or as life tables respectively. Default is `mpm`.
#' @param split A logical indicating whether to split MPMs into submatrices.
#'   Default is TRUE.Ignored if output is `lifetable`.
#' @param by_type A logical indicating whether the matrices should be returned
#'   in a list by type (A, U, F, C). If split is `FALSE`, then `by_type` must is
#'   coerced to be `FALSE`. Defaults to `TRUE`. Ignored if output is
#'   `lifetable`.
#' @param as_compadre A logical indicating whether the matrices should be
#'   returned as a `CompadreDB` object. Default is `TRUE`. If `FALSE`, the
#'   function returns a list. Ignored if output is `lifetable`.
#'
#' @return If output is `mpm`, this function returns a `compadreDB` object or
#'   list containing MPMs generated using the specified model with parameters
#'   drawn from random uniform or normal distributions. The format of the output
#'   MPMs depends on the arguments `by_type`, `split` and `as_compadre`. If
#'   output is `lifetable`, the function returns a list of life tables.
#'
#' @family Leslie matrices
#' @author Owen Jones <jones@biology.sdu.dk>
#' @examples
#'
#' mortParams <- data.frame(minVal = c(0, 0.01,0.1), maxVal = c(0.14, 0.15,0.1))
#' fertParams <- data.frame(minVal= c(10, 0.5, 8),maxVal=c(11, 0.9, 10))
#' maturityParam <- c(0, 0)
#'
#' rand_leslie_set(n_models = 5,
#'                 mortality_model = "GompertzMakeham",
#'                 fertility_model = "normal",
#'                 mortality_params = mortParams,
#'                 fertility_params = fertParams,
#'                 fertility_maturity_params = maturityParam,
#'                 dist_type="uniform",
#'                 output = "mpm")
#'
#' @export rand_leslie_set
#'

rand_leslie_set <- function(n_models = 5, mortality_model = "gompertz", fertility_model = "step",
                            mortality_params, fertility_params, fertility_maturity_params,
                            dist_type="uniform", output = "mpm",
                            split = TRUE, by_type = TRUE, as_compadre = TRUE) {

  # Argument Validation -----------

  if (split == FALSE) {
    if(by_type == TRUE){
      by_type <- FALSE
      warning("Split is set to FALSE; by_type has been coerced to be FALSE")
    }
  }

  # Validate n_models
  if (!is.numeric(n_models) || length(n_models) != 1 || n_models <= 0) {
    stop("n_models must be a positive integer")
  }

  # Validate mortality_model
  valid_mortality_models <- c("Gompertz", "Weibull", "GompertzMakeham", "WeibullMakeham", "Exponential", "Siler")
  if (!is.character(mortality_model) || !(mortality_model %in% valid_mortality_models)) {
    stop("mortality_model must be one of ", paste(valid_mortality_models, collapse = ", "))
  }

  # Validate fertility_model
  valid_fertility_models <- c("logistic", "step", "vonbertalanffy", "normal", "hadwiger")
  if (!is.character(fertility_model) || !(fertility_model %in% valid_fertility_models)) {
    stop("fertility_model must be one of ", paste(valid_fertility_models, collapse = ", "))
  }

  # Validate mortality_params
  expected_rows <- switch(mortality_model,
                          "Gompertz" = 2,
                          "Weibull" = 2,
                          "GompertzMakeham" = 3,
                          "WeibullMakeham" = 3,
                          "Exponential" = 1,
                          "Siler" = 5,
                          stop("Invalid mortality_model"))
  if (!is.data.frame(mortality_params) || ncol(mortality_params) != 2 || nrow(mortality_params) != expected_rows) {
    stop(paste("mortality_params must be a dataframe with 2 columns and", expected_rows, "rows for the", mortality_model, "mortality_model"))
  }


  # Validate fertility_params
  expected_fertility_rows <- switch(fertility_model,
                                    "logistic" = 3,
                                    "step" = 1,
                                    "vonbertalanffy" = 2,
                                    "normal" = 3,
                                    "hadwiger" = 3,
                                    stop("Invalid fertility_model"))
  if (!is.data.frame(fertility_params) || ncol(fertility_params) != 2 || nrow(fertility_params) != expected_fertility_rows) {
    stop(paste("fertility_params must be a dataframe with 2 columns and", expected_fertility_rows, "rows for the", fertility_model, "fertility_model"))
  }

  # Validate fertility_maturity_params
  if (!is.numeric(fertility_maturity_params) || length(fertility_maturity_params) != 2) {
    stop("fertility_maturity_params must be a numeric vector with two elements")
  }

  # Validate dist_type
  valid_dist_types <- c("uniform", "normal")
  if (!is.character(dist_type) || !(dist_type %in% valid_dist_types)) {
    stop("dist_type must be one of ", paste(valid_dist_types, collapse = ", "))
  }

  # Validate output
  valid_outputs <- c("mpm", "lifetable")
  if (!is.character(output) || !(output %in% valid_outputs)) {
    stop("output must be either 'mpm' or 'lifetable'")
  }
 # Function begins -----
  # Set up null lists to hold outputs
  lifeTables <- list()
  if(output == "mpm"){
    leslieMatrices <- list()}

  for (i in 1:n_models) {
    # Mortality part:

    # Parameters...
    # Gompertz, Weibull, GompertzMakeham, WeibullMakeham, Exponential,
    # Siler,

    if (mortality_model %in% c("Gompertz", "Weibull")) {
      if (dist_type == "uniform") {
        mortality_params_draw <- c(
          b_0 = runif(1,
                      min = mortality_params[1, 1],
                      max = mortality_params[1, 2]
          ),
          b_1 = runif(1,
                      min = mortality_params[2, 1],
                      max = mortality_params[2, 2]
          )
        )
      }
      if (dist_type == "normal") {
        mortality_params_draw <- c(
          b_0 = rnorm(1,
                      mean = mortality_params[1, 1],
                      sd = mortality_params[1, 2]
          ),
          b_1 = rnorm(1,
                      mean = mortality_params[2, 1],
                      sd = mortality_params[2, 2]
          )
        )
      }
    }

    if (mortality_model %in% c("GompertzMakeham", "WeibullMakeham")) {
      if (dist_type == "uniform") {
        mortality_params_draw <- c(
          b_0 = runif(1,
                      min = mortality_params[1, 1],
                      max = mortality_params[1, 2]
          ),
          b_1 = runif(1,
                      min = mortality_params[2, 1],
                      max = mortality_params[2, 2]
          ),
          C = runif(1,
                    min = mortality_params[3, 1],
                    max = mortality_params[3, 2]
          )
        )
      }
      if (dist_type == "normal") {
        mortality_params_draw <- c(
          b_0 = rnorm(1,
                      mean = mortality_params[1, 1],
                      sd = mortality_params[1, 2]
          ),
          b_1 = rnorm(1,
                      mean = mortality_params[2, 1],
                      sd = mortality_params[2, 2]
          ),
          C = rnorm(1,
                    mean = mortality_params[3, 1],
                    sd = mortality_params[3, 2]
          )
        )
      }
    }

    if (mortality_model == "Exponential") {
      if (dist_type == "uniform") {
        mortality_params_draw <- c(C = runif(1,
                                             min = mortality_params[1, 1],
                                             max = mortality_params[1, 2]
        ))
      }
      if (dist_type == "normal") {
        mortality_params_draw <- c(C = rnorm(1,
                                             mean = mortality_params[1, 1],
                                             sd = mortality_params[1, 2]
        ))
      }
    }

    if (mortality_model == "Siler") {
      if (dist_type == "uniform") {
        mortality_params_draw <- c(
          a_0 = runif(1,
                      min = mortality_params[1, 1],
                      max = mortality_params[1, 2]
          ),
          a_1 = runif(1,
                      min = mortality_params[2, 1],
                      max = mortality_params[2, 2]
          ),
          C = runif(1,
                    min = mortality_params[3, 1],
                    max = mortality_params[3, 2]
          ),
          b_0 = runif(1,
                      min = mortality_params[1, 1],
                      max = mortality_params[1, 2]
          ),
          b_1 = runif(1,
                      min = mortality_params[2, 1],
                      max = mortality_params[2, 2]
          )
        )
      }
      if (dist_type == "normal") {
        mortality_params_draw <- c(
          a_0 = rnorm(1,
                      mean = mortality_params[1, 1],
                      sd = mortality_params[1, 2]
          ),
          a_1 = rnorm(1,
                      mean = mortality_params[2, 1],
                      sd = mortality_params[2, 2]
          ),
          C = rnorm(1,
                    mean = mortality_params[3, 1],
                    sd = mortality_params[3, 2]
          ),
          b_0 = rnorm(1,
                      mean = mortality_params[1, 1],
                      sd = mortality_params[1, 2]
          ),
          b_1 = rnorm(1,
                      mean = mortality_params[2, 1],
                      sd = mortality_params[2, 2]
          )
        )
      }
    }


    lifeTables[[i]] <- model_mortality(
      params = mortality_params_draw,
      model = mortality_model
    )

    # Fertility part:
    # Logistic, Step, vonBertalanffy, Normal, Hadwiger
    if (fertility_model == "logistic") {
      if (dist_type == "uniform") {
        fertility_params_draw <- c(A = runif(1,
                                             min = fertility_params[1, 1],
                                             max = fertility_params[1, 2]),
                                   k = runif(1,
                                             min = fertility_params[1, 1],
                                             max = fertility_params[1, 2]),
                                   x_m = runif(1,
                                               min = fertility_params[1, 1],
                                               max = fertility_params[1, 2]
                                   )
        )

        fertility_maturity_params_draw <- runif(1,
                                                min = fertility_maturity_params[1],
                                                max = fertility_maturity_params[2]
        )
      }
    }


    if (fertility_model == "step") {
      if (dist_type == "uniform") {
        fertility_params_draw <- c(A = runif(1,
                                             min = fertility_params[1, 1],
                                             max = fertility_params[1, 2]
        ))
        fertility_maturity_params_draw <- runif(1,
                                                min = fertility_maturity_params[1],
                                                max = fertility_maturity_params[2]
        )
      }
      if (dist_type == "normal") {
        fertility_params_draw <- c(A = rnorm(1,
                                             mean = fertility_params[1, 1],
                                             sd = fertility_params[1, 2]
        ))
        fertility_maturity_params_draw <- rnorm(1,
                                                mean = fertility_maturity_params[1],
                                                sd = fertility_maturity_params[2]
        )
      }
    }

    if (fertility_model == "vonbertalanffy") {
      if (dist_type == "uniform") {
        fertility_params_draw <- c(
          A = runif(1,
                    min = fertility_params[1, 1],
                    max = fertility_params[1, 2]
          ),
          k = runif(1,
                    min = fertility_params[1, 1],
                    max = fertility_params[1, 2]
          )
        )

        fertility_maturity_params_draw <- runif(1,
                                                min = fertility_maturity_params[1],
                                                max = fertility_maturity_params[2]
        )
      }
      if (dist_type == "normal") {
        fertility_params_draw <- c(
          A = rnorm(1,
                    mean = fertility_params[1, 1],
                    sd = fertility_params[1, 2]
          ),
          k = rnorm(1,
                    mean = fertility_params[1, 1],
                    sd = fertility_params[1, 2]
          )
        )

        fertility_maturity_params_draw <- rnorm(1,
                                                mean = fertility_maturity_params[1],
                                                sd = fertility_maturity_params[2]
        )
      }
    }

    if (fertility_model == "normal") {
      if (dist_type == "uniform") {
        fertility_params_draw <- c(
          A = runif(1,
                    min = fertility_params[1, 1],
                    max = fertility_params[1, 2]
          ),
          mu = runif(1,
                     min = fertility_params[1, 1],
                     max = fertility_params[1, 2]
          ),
          sd = runif(1,
                     min = fertility_params[1, 1],
                     max = fertility_params[1, 2]
          )
        )

        fertility_maturity_params_draw <- runif(1,
                                                min = fertility_maturity_params[1],
                                                max = fertility_maturity_params[2]
        )
      }
      if (dist_type == "normal") {
        fertility_params_draw <- c(
          A = rnorm(1,
                    mean = fertility_params[1, 1],
                    sd = fertility_params[1, 2]
          ),
          mu = rnorm(1,
                     mean = fertility_params[1, 1],
                     sd = fertility_params[1, 2]
          ),
          sd = rnorm(1,
                     mean = fertility_params[1, 1],
                     sd = fertility_params[1, 2]
          )
        )

        fertility_maturity_params_draw <- rnorm(1,
                                                mean = fertility_maturity_params[1],
                                                sd = fertility_maturity_params[2]
        )
      }
    }

    if (fertility_model == "hadwiger") {
      if (dist_type == "uniform") {
        fertility_params_draw <- c(
          a = runif(1,
                    min = fertility_params[1, 1],
                    max = fertility_params[1, 2]
          ),
          b = runif(1,
                    min = fertility_params[1, 1],
                    max = fertility_params[1, 2]
          ),
          C = runif(1,
                    min = fertility_params[1, 1],
                    max = fertility_params[1, 2]
          )
        )

        fertility_maturity_params_draw <- runif(1,
                                                min = fertility_maturity_params[1],
                                                max = fertility_maturity_params[2]
        )
      }
      if (dist_type == "normal") {
        fertility_params_draw <- c(
          a = rnorm(1,
                    mean = fertility_params[1, 1],
                    sd = fertility_params[1, 2]
          ),
          b = rnorm(1,
                    mean = fertility_params[1, 1],
                    sd = fertility_params[1, 2]
          ),
          C = rnorm(1,
                    mean = fertility_params[1, 1],
                    sd = fertility_params[1, 2]
          )
        )
        # Currently ignored
        fertility_maturity_params_draw <- rnorm(1,
                                                mean = fertility_maturity_params[1],
                                                sd = fertility_maturity_params[2]
        )
      }
    }



    # Add fertility to life table
    lifeTables[[i]] <- lifeTables[[i]] |>
      mutate(fert = model_fertility(
        age = x,
        params = fertility_params_draw,
        maturity = fertility_maturity_params_draw,
        model = fertility_model
      ))

    if(output == "mpm"){

    leslieMatrices[[i]] <- make_leslie_mpm(
      survival = lifeTables[[i]]$px,
      fertility = lifeTables[[i]]$fert,
      n_stages = nrow(lifeTables[[i]]), split = TRUE
    )}
  }

  # Output the matrices or life tables.

  if(output == "mpm"){
    output_list <- leslieMatrices
    if (split) {
      if (by_type) {
        if (as_compadre) {

          # Code for split = TRUE, by_type = TRUE, as_compadre = TRUE
          A_list <- lapply(output_list, function(x) x$mat_A)
          U_list <- lapply(output_list, function(x) x$mat_U)
          F_list <- lapply(output_list, function(x) x$mat_F)

          return(cdb_build_cdb(mat_u = U_list, mat_f = F_list))

        } else {
          # Code for split = TRUE, by_type = TRUE, as_compadre = FALSE
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
      } else {
        if (as_compadre) {

          # Code for split = TRUE, by_type = FALSE, as_compadre = TRUE
          A_list <- lapply(output_list, function(x) x$mat_A)
          U_list <- lapply(output_list, function(x) x$mat_U)
          F_list <- lapply(output_list, function(x) x$mat_F)

          return(cdb_build_cdb(mat_a = A_list))
          } else {
          # Code for split = TRUE, by_type = FALSE, as_compadre = FALSE
            return(output_list)
        }
      }
    } else {
      if (by_type) {
        if (as_compadre) {
          # Code for split = FALSE, by_type = TRUE, as_compadre = TRUE
          A_list <- lapply(output_list, function(x) x$mat_A)
          U_list <- lapply(output_list, function(x) x$mat_U)
          F_list <- lapply(output_list, function(x) x$mat_F)

          output_list_by_type <- list(
            "A_list" = A_list
          )
          return(cdb_build_cdb(mat_a = A_list))

        } else {
          # Code for split = FALSE, by_type = TRUE, as_compadre = FALSE

          A_list <- lapply(output_list, function(x) x$mat_A)
          U_list <- lapply(output_list, function(x) x$mat_U)
          F_list <- lapply(output_list, function(x) x$mat_F)

          output_list_by_type <- list(
            "A_list" = A_list
          )
          return(output_list_by_type)

        }
      } else {
        if (as_compadre) {
          # Code for split = FALSE, by_type = FALSE, as_compadre = TRUE
          A_list <- lapply(output_list, function(x) x$mat_A)
          U_list <- lapply(output_list, function(x) x$mat_U)
          F_list <- lapply(output_list, function(x) x$mat_F)


          return(cdb_build_cdb(mat_a = A_list))

        } else {
          # Code for split = FALSE, by_type = FALSE, as_compadre = FALSE
          A_list <- lapply(output_list, function(x) x$mat_A)
          U_list <- lapply(output_list, function(x) x$mat_U)
          F_list <- lapply(output_list, function(x) x$mat_F)

          return(A_list)
        }
      }
    }


  }

    if(output == "lifetable"){
    return(lifeTables)
  }


}
