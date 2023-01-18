#' Simulate survival probability
#'
#' @param probSurv true survival probability
#' @param sample_size sample size
#' @return mean survival probability based on the simulated data
#' @examples
#' simSurv(0.8, 100)
#' simSurv(0.5, 1000)
#' @noRd
simSurv <- function(probSurv,sample_size){mean(rbinom(sample_size,1,probSurv))}

#' Simulate reproduction (fecundity)
#'
#' @param meanFec mean value for reproductive output
#' @param sample_size sample size
#' @return mean fecundity based on the simulated data
#' @examples
#' simFec(2, 100)
#' simFec(5, 1000)
#' @noRd
simFec <- function(meanFec,sample_size){mean(rpois(sample_size,meanFec))}

#' Simulate matrix population model
#'
#' @param matU matrix of survival probabilities
#' @param matF matrix of mean fecundity values
#' @param sample_size sample size
#' @param split logical, whether to split the output into survival and fecundity matrices or not
#' @return list of matrices of survival and fecundity if split = TRUE, otherwise a single matrix of the sum of survival and fecundity
#' @examples
#' mats <- make_leslie_matrix(survival = c(0.1,0.2,0.5),
#'                            fertility = c(0,1.2, 2.4),
#'                            n_stages = 3, split = TRUE)
#' ssMat <- matrix(10, nrow = 3, ncol = 3)
#'
#' simulate_mpm(matU = mats$matU, matF = mats$matF,
#'              sample_size = ssMat, split = TRUE)
#' @export simulate_mpm
#'
simulate_mpm <- function(matU, matF, sample_size, split = TRUE){

  #Validation
  if(!inherits(matU, "matrix")){
    stop("matU needs to be a matrix")
  }

  if(!inherits(matF, "matrix")){
    stop("matF needs to be a matrix")
  }

  if(!inherits(sample_size, "matrix")||length(sample_size) == 1){
    stop("matF needs to be a matrix, or an integer with length 1")
  }

  if(!all(matU>=0)){
    stop("matU must include only values >= 0")
  }

  if(!all(matF>=0)){
    stop("matF must include only values >= 0")
  }

  if(!all(sample_size>0)){
    stop("sample_size must include only values > 0")
  }

  if (!is.logical(split)) {
    stop("split must be a logical value (TRUE/FALSE).")
  }

  #Convert the matrix into a vector
  vectU <- as.vector(matU)
  vectF <- as.vector(matF)
  vectSampleSize <- as.vector(sample_size)

  #Simulate the matrix based on the information provided
  survResults <- mapply(FUN = simSurv, probSurv = vectU,
                         sample_size = vectSampleSize)

  fecResults <- mapply(FUN = simFec, meanFec = vectF, sample_size = vectSampleSize)

  matU_out <- matrix(survResults,nrow = sqrt(length(vectU)),ncol = sqrt(length(vectU)))
  matF_out <- matrix(fecResults,nrow = sqrt(length(vectF)),ncol = sqrt(length(vectU)))

  if(split){
  return(list(matU = matU_out, matF = matF_out))
} else {return (matU_out+matF_out)}
}

