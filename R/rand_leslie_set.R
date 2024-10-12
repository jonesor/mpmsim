#' Generate a set of random Leslie Matrix Population Models
#'
#' Generates a set of Leslie matrix population models (MPMs) based on defined
#' mortality and reproductive output models, and using model parameters randomly
#' drawn from specified distributions.
#'
#' @param n_models An integer indicating the number of MPMs to generate.
#' @param mortality_model A character string specifying the name of the
#'   mortality model to be used. Options are `gompertz`, `gompertzmakeham`,
#'   `exponential`, `siler`, `weibull`, and `weibullmakeham`. See
#'   `model_mortality`. These names are not case-sensitive.
#' @param fecundity_model A character string specifying the name of the model
#'   to be used for reproductive output. Options are `logistic`, `step`,
#'   `vonBertalanffy`, `normal` and `hadwiger.` See `?model_fecundity`.
#' @param mortality_params A two-column dataframe with a number of rows equal to
#'   the number of parameters in the mortality model. The required order of the
#'   parameters depends on the selected `mortality_model` (see
#'   `?model_mortality`):
#'   - For `gompertz` and `weibull`: \code{b_0}, \code{b_1}
#'   - For `gompertzmakeham` and `weibullmakeham`: \code{b_0}, \code{b_1},
#'   \code{C}
#'   - For `exponential`: \code{C}
#'   - For `siler`: \code{a_0}, \code{a_1}, \code{C}, \code{b_0}, \code{b_1}
#'   If `dist_type` is `uniform` these rows represent the lower and upper limits
#'   of the random uniform distribution from which the parameters are drawn. If
#'   `dist_type` is `normal`, the columns represent the mean and standard
#'   deviation of a random normal distribution from which the parameter values
#'   are drawn.
#' @param fecundity_params A two-column dataframe with a number of rows equal to
#'   the number of parameters in the fecundity model. The required order of the
#'   parameters depends on the selected `fecundity_model` (see
#'   `?model_fecundity`):
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
#' @param fecundity_maturity_params A vector with two elements defining the
#'   distribution from which age at maturity is drawn for the models. The models
#'   will coerce reproductive output to be zero before this point. If
#'   `dist_type` is `uniform` these values represent the lower and upper limits
#'   of the random uniform distribution from which the parameters are drawn. If
#'   `dist_type` is `normal`, the values represent the mean and standard
#'   deviation of a random normal distribution from which the parameter values
#'   are drawn.
#' @param dist_type A character string specifying the type of distribution to
#'   draw parameters from. Default is `uniform`. Supported types are `uniform`
#'   and `normal`.
#' @param output Character string indicating the type of output. Output can be
#'   one of the following types:
#'
#' * `Type1`: A `compadreDB` Object containing MPMs split into the submatrices
#'   (i.e. A, U, F and C).
#' * `Type2`: A `compadreDB` Object containing MPMs that are not split into
#'   submatrices (i.e. only the A matrix is included).
#' * `Type3`: A `list` of MPMs arranged so that each element of the list
#'   contains a model and associated submatrices (i.e. the nth element contains
#'   the nth A matrix alongside the nth U and F matrices).
#' * `Type4`: A `list` of MPMs arranged so that the list contains 3 lists for
#'   the A matrix and the U and F submatrices respectively.
#' * `Type5`: A `list` of MPMs, including only the A matrix.
#' * `Type6`: A `list` of life tables.
#'
#'   Default is `Type1`.
#'
#' @param scale_output A logical argument. If `TRUE` the resulting MPMs or life
#'   tables are scaled by adjusting reproductive output so that the population
#'   growth rate (lambda) is 1. Default is `FALSE`.
#'
#' @return Returns a `CompadreDB` object or `list` containing MPMs or life
#'   tables generated using the specified model with parameters drawn from
#'   random uniform or normal distributions. The format of the output MPMs
#'   depends on the arguments `output`. Outputs may optionally be scaled using
#'   the argument `scale_output` to ensure a population growth rate (lambda) of
#'   1.
#'
#'   If the output is a `CompadreDB` object, the parameters of the models used
#'   to produce the MPM are included in the metadata.
#'
#' @importFrom stats optim
#' @importFrom dplyr bind_rows bind_cols
#'
#' @family Leslie matrices
#' @author Owen Jones <jones@biology.sdu.dk>
#' @examples
#'
#' mortParams <- data.frame(
#'   minVal = c(0, 0.01, 0.1),
#'   maxVal = c(0.14, 0.15, 0.1)
#' )
#'
#' fecundityParams <- data.frame(
#'   minVal = c(10, 0.5, 8),
#'   maxVal = c(11, 0.9, 10)
#' )
#'
#' maturityParam <- c(0, 0)
#'
#' rand_leslie_set(
#'   n_models = 5,
#'   mortality_model = "gompertzmakeham",
#'   fecundity_model = "normal",
#'   mortality_params = mortParams,
#'   fecundity_params = fecundityParams,
#'   fecundity_maturity_params = maturityParam,
#'   dist_type = "uniform",
#'   output = "Type1"
#' )
#'
#' @export rand_leslie_set
#'

rand_leslie_set <- function(n_models = 5, mortality_model = "gompertz",
                            fecundity_model = "step",
                            mortality_params, fecundity_params,
                            fecundity_maturity_params,
                            dist_type = "uniform", output = "type1",
                            scale_output = FALSE) {
  # Argument Validation -----------

  mortality_model <- tolower(mortality_model)
  fecundity_model <- tolower(fecundity_model)

  # Validate n_models
  if (!is.numeric(n_models) || length(n_models) != 1 || n_models <= 0) {
    stop("n_models must be a positive integer")
  }

  # Validate mortality_model
  valid_mortality_models <- c(
    "gompertz", "weibull", "gompertzmakeham",
    "weibullmakeham", "exponential", "siler"
  )
  if (!is.character(mortality_model) || !(mortality_model %in%
    valid_mortality_models)) {
    stop("mortality_model must be one of ", paste(valid_mortality_models,
      collapse = ", "
    ))
  }

  # Validate fecundity_model
  valid_fecundity_models <- c(
    "logistic", "step", "vonbertalanffy",
    "normal", "hadwiger"
  )
  if (!is.character(fecundity_model) || !(fecundity_model %in%
    valid_fecundity_models)) {
    stop("fecundity_model must be one of ", paste(valid_fecundity_models,
      collapse = ", "
    ))
  }

  # Validate mortality_params
  expected_rows <- switch(mortality_model,
    "gompertz" = 2,
    "weibull" = 2,
    "gompertzmakeham" = 3,
    "weibullmakeham" = 3,
    "exponential" = 1,
    "siler" = 5,
    stop("Invalid mortality_model")
  )
  if (!is.data.frame(mortality_params) || ncol(mortality_params) != 2 ||
    nrow(mortality_params) != expected_rows) {
    stop(paste(
      "mortality_params must be a dataframe with 2 columns and",
      expected_rows, "rows for the", mortality_model,
      "mortality_model"
    ))
  }


  # Validate fecundity_params
  expected_fecundity_rows <- switch(fecundity_model,
    "logistic" = 3,
    "step" = 1,
    "vonbertalanffy" = 2,
    "normal" = 3,
    "hadwiger" = 3,
    stop("Invalid fecundity_model")
  )
  if (!is.data.frame(fecundity_params) || ncol(fecundity_params) != 2 ||
    nrow(fecundity_params) != expected_fecundity_rows) {
    stop(paste(
      "fecundity_params must be a dataframe with 2 columns and",
      expected_fecundity_rows, "rows for the", fecundity_model,
      "fecundity_model"
    ))
  }

  # Validate fecundity_maturity_params
  if (!is.numeric(fecundity_maturity_params) ||
    length(fecundity_maturity_params) != 2) {
    stop("fecundity_maturity_params must be a numeric vector with two elements")
  }

  # Validate dist_type
  valid_dist_types <- c("uniform", "normal")
  if (!is.character(dist_type) || !(dist_type %in% valid_dist_types)) {
    stop("dist_type must be one of ", paste(valid_dist_types, collapse = ", "))
  }

  # Validate output
  valid_outputs <- c(
    "Type1",
    "Type2",
    "Type3",
    "Type4",
    "Type5",
    "Type6"
  )
  if (!is.character(output) || !(output %in% valid_outputs)) {
    stop("output must be Type1 to Type6")
  }

  # Function begins -----
  # Set up null lists to hold outputs
  lifeTables <- list()

  mortalityParameters <- list()
  fecundityParameters <- list()
  maturityParameters <- list()
  scaling_factorParameters <- list()

  if (output != "Type6") {
    leslieMatrices <- list()
  }

  for (i in 1:n_models) {
    # Mortality part:

    # Parameters...
    # Gompertz, Weibull, GompertzMakeham, WeibullMakeham, Exponential,
    # Siler

    if (mortality_model %in% c("gompertz", "weibull")) {
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

    if (mortality_model %in% c("gompertzmakeham", "weibullmakeham")) {
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

    if (mortality_model == "exponential") {
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

    if (mortality_model == "siler") {
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

    # Add the mortality model parameters to a parameters data frame
    mortalityParameters[[i]] <- mortality_params_draw

    if (nrow(lifeTables[[i]]) <= 1) {
      warning("The mortality parameters produced a life table where almost
      all individuals die within 1 year.")
    }

    # fecundity part:
    # Logistic, Step, vonBertalanffy, Normal, Hadwiger
    if (fecundity_model == "logistic") {
      if (dist_type == "uniform") {
        fecundity_params_draw <- c(
          A = runif(1,
            min = fecundity_params[1, 1],
            max = fecundity_params[1, 2]
          ),
          k = runif(1,
            min = fecundity_params[1, 1],
            max = fecundity_params[1, 2]
          ),
          x_m = runif(1,
            min = fecundity_params[1, 1],
            max = fecundity_params[1, 2]
          )
        )

        fecundity_maturity_params_draw <- runif(1,
          min = fecundity_maturity_params[1],
          max = fecundity_maturity_params[2]
        )
      }
      if (dist_type == "normal") {
        fecundity_params_draw <- c(
          A = rnorm(1,
            mean = fecundity_params[1, 1],
            sd = fecundity_params[1, 2]
          ),
          k = rnorm(1,
            mean = fecundity_params[1, 1],
            sd = fecundity_params[1, 2]
          ),
          x_m = rnorm(1,
            mean = fecundity_params[1, 1],
            sd = fecundity_params[1, 2]
          )
        )

        fecundity_maturity_params_draw <- rnorm(1,
          mean = fecundity_maturity_params[1],
          sd = fecundity_maturity_params[2]
        )
      }
    }


    if (fecundity_model == "step") {
      if (dist_type == "uniform") {
        fecundity_params_draw <- c(A = runif(1,
          min = fecundity_params[1, 1],
          max = fecundity_params[1, 2]
        ))
        fecundity_maturity_params_draw <- runif(1,
          min = fecundity_maturity_params[1],
          max = fecundity_maturity_params[2]
        )
      }
      if (dist_type == "normal") {
        fecundity_params_draw <- c(A = rnorm(1,
          mean = fecundity_params[1, 1],
          sd = fecundity_params[1, 2]
        ))
        fecundity_maturity_params_draw <- rnorm(1,
          mean = fecundity_maturity_params[1],
          sd = fecundity_maturity_params[2]
        )
      }
    }

    if (fecundity_model == "vonbertalanffy") {
      if (dist_type == "uniform") {
        fecundity_params_draw <- c(
          A = runif(1,
            min = fecundity_params[1, 1],
            max = fecundity_params[1, 2]
          ),
          k = runif(1,
            min = fecundity_params[1, 1],
            max = fecundity_params[1, 2]
          )
        )

        fecundity_maturity_params_draw <- runif(1,
          min = fecundity_maturity_params[1],
          max = fecundity_maturity_params[2]
        )
      }
      if (dist_type == "normal") {
        fecundity_params_draw <- c(
          A = rnorm(1,
            mean = fecundity_params[1, 1],
            sd = fecundity_params[1, 2]
          ),
          k = rnorm(1,
            mean = fecundity_params[1, 1],
            sd = fecundity_params[1, 2]
          )
        )

        fecundity_maturity_params_draw <- rnorm(1,
          mean = fecundity_maturity_params[1],
          sd = fecundity_maturity_params[2]
        )
      }
    }

    if (fecundity_model == "normal") {
      if (dist_type == "uniform") {
        fecundity_params_draw <- c(
          A = runif(1,
            min = fecundity_params[1, 1],
            max = fecundity_params[1, 2]
          ),
          mu = runif(1,
            min = fecundity_params[1, 1],
            max = fecundity_params[1, 2]
          ),
          sd = runif(1,
            min = fecundity_params[1, 1],
            max = fecundity_params[1, 2]
          )
        )

        fecundity_maturity_params_draw <- runif(1,
          min = fecundity_maturity_params[1],
          max = fecundity_maturity_params[2]
        )
      }
      if (dist_type == "normal") {
        fecundity_params_draw <- c(
          A = rnorm(1,
            mean = fecundity_params[1, 1],
            sd = fecundity_params[1, 2]
          ),
          mu = rnorm(1,
            mean = fecundity_params[1, 1],
            sd = fecundity_params[1, 2]
          ),
          sd = rnorm(1,
            mean = fecundity_params[1, 1],
            sd = fecundity_params[1, 2]
          )
        )

        fecundity_maturity_params_draw <- rnorm(1,
          mean = fecundity_maturity_params[1],
          sd = fecundity_maturity_params[2]
        )
      }
    }

    if (fecundity_model == "hadwiger") {
      if (dist_type == "uniform") {
        fecundity_params_draw <- c(
          a = runif(1,
            min = fecundity_params[1, 1],
            max = fecundity_params[1, 2]
          ),
          b = runif(1,
            min = fecundity_params[1, 1],
            max = fecundity_params[1, 2]
          ),
          C = runif(1,
            min = fecundity_params[1, 1],
            max = fecundity_params[1, 2]
          )
        )

        fecundity_maturity_params_draw <- runif(1,
          min = fecundity_maturity_params[1],
          max = fecundity_maturity_params[2]
        )
      }
      if (dist_type == "normal") {
        fecundity_params_draw <- c(
          a = rnorm(1,
            mean = fecundity_params[1, 1],
            sd = fecundity_params[1, 2]
          ),
          b = rnorm(1,
            mean = fecundity_params[1, 1],
            sd = fecundity_params[1, 2]
          ),
          C = rnorm(1,
            mean = fecundity_params[1, 1],
            sd = fecundity_params[1, 2]
          )
        )

        fecundity_maturity_params_draw <- rnorm(1,
          mean = fecundity_maturity_params[1],
          sd = fecundity_maturity_params[2]
        )
      }
    }



    # Add fecundity to life table
    lifeTables[[i]] <- lifeTables[[i]] |>
      mutate(fecundity = model_fecundity(
        age = x,
        params = fecundity_params_draw,
        maturity = fecundity_maturity_params_draw,
        model = fecundity_model
      ))

    # Add the fecundity parameters to a parameters data frame
    fecundityParameters[[i]] <- fecundity_params_draw
    maturityParameters[[i]] <- fecundity_maturity_params_draw


    # Scale fecundity to ensure population growth is at the target
    if (scale_output == TRUE && output == "Type6") {
      # Calculate R0
      R0 <- sum(lifeTables[[i]]$lx * lifeTables[[i]]$fecundity)

      # Calculate T
      genTime <- sum(lifeTables[[i]]$x * lifeTables[[i]]$lx *
        lifeTables[[i]]$fecundity) / R0

      # Calculate the target R0 for the desired lambda
      targetLambda <- 1
      target_R0 <- targetLambda^genTime

      # Determine the scaling factor
      scaling_factor <- target_R0 / R0

      lifeTables[[i]]$fecundity <- lifeTables[[i]]$fecundity * scaling_factor

      # Add the scaling parameter to a parameters data frame
      scaling_factorParameters[[i]] <- scaling_factor
    }

    # Here we deal with lifetables that are too short (all die within year)

    if (output != "Type6") {
      leslieMatrices[[i]] <- make_leslie_mpm(
        survival = lifeTables[[i]]$px,
        fecundity = lifeTables[[i]]$fecundity,
        n_stages = nrow(lifeTables[[i]]),
        split = TRUE
      )

      if (scale_output == TRUE) {
        mpm <- leslieMatrices[[i]]

        objective_function <- function(scaling_factor, Umat, Fmat,
                                       lambda_target = 1) {
          Fmat_scaled <- scaling_factor * Fmat
          Amat_scaled <- Umat + Fmat_scaled
          lambda_scaled <- max(Mod(eigen(Amat_scaled)$values))
          return(abs(lambda_scaled - lambda_target))
        }

        result <- optim(1, objective_function,
          Umat = mpm$mat_U,
          Fmat = mpm$mat_F,
          method = "L-BFGS-B",
          lower = 0
        )

        optimized_scaling_factor <- result$par
        mpm$mat_F <- optimized_scaling_factor * mpm$mat_F
        mpm$mat_A <- mpm$mat_U + mpm$mat_F

        # Add the scaling parameter to a parameters data frame
        scaling_factorParameters[[i]] <- optimized_scaling_factor


        leslieMatrices[[i]] <- mpm
      }
    }
  }

  if (scale_output == FALSE) {
    scaling_factorParameters[[i]] <- 1
  }

  # Output the matrices or life tables.
  # If the output is Type1 or Type2, make a dataframe of metadata to be added to
  # the CompadreDB
  if (output %in% c("Type1", "Type2")) {
    mortalityParameters_df <- as.data.frame(do.call(rbind, mortalityParameters))
    fecundityParameterss_df <- as.data.frame(do.call(
      rbind,
      fecundityParameters
    ))
    maturityParameters_df <- as.data.frame(do.call(rbind, maturityParameters))
    scaling_factorParameters_df <- as.data.frame(
      do.call(rbind, scaling_factorParameters)
    )

    colnames(maturityParameters_df) <- "age_at_maturity"
    colnames(scaling_factorParameters_df) <- "fecundity_scaling"

    compadre_metadata <- bind_cols(
      mortality_model = mortality_model,
      mortalityParameters_df,
      fecundity_model = fecundity_model,
      fecundityParameterss_df,
      scaling_factorParameters_df
    )
  }


  # Split matrices
  # `Type1`: A `compadreDB` Object containing MPMs split into the submatrices

  if (output == "Type1") {
    U_list <- lapply(leslieMatrices, function(x) x$mat_U)
    F_list <- lapply(leslieMatrices, function(x) x$mat_F)

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
    A_list <- lapply(leslieMatrices, function(x) x$mat_A)

    compadreObject <- suppressWarnings(
      cdb_build_cdb(mat_a = A_list, metadata = compadre_metadata)
    )

    return(compadreObject)
  }

  # `Type3`: A `list` of MPMs arranged so that each element of the list contains
  # a model and associated submatrices

  if (output == "Type3") {
    return(leslieMatrices)
  }

  # `Type4`: A `list` of MPMs arranged so that the list contains 3 lists for the
  # A matrix and the U and F submatrices respectively.

  if (output == "Type4") {
    A_list <- lapply(leslieMatrices, function(x) x$mat_A)
    U_list <- lapply(leslieMatrices, function(x) x$mat_U)
    F_list <- lapply(leslieMatrices, function(x) x$mat_F)

    output_list_by_type <- list(
      "A_list" = A_list,
      "U_list" = U_list,
      "F_list" = F_list
    )
    return(output_list_by_type)
  }
  # `Type5`: A `list` of MPMs, including the main A matrix only.
  if (output == "Type5") {
    A_list <- lapply(leslieMatrices, function(x) x$mat_A)
    return(A_list)
  }

  # Type6: life tables
  if (output == "Type6") {
    return(lifeTables)
  }
}
