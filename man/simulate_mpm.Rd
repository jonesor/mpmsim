% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/simulate_mpm.R
\name{simulate_mpm}
\alias{simulate_mpm}
\title{Simulate matrix population models (MPMs) based on expected transition rates
and sample sizes}
\usage{
simulate_mpm(mat_U, mat_F, sample_size, split = TRUE)
}
\arguments{
\item{mat_U}{matrix of survival probabilities}

\item{mat_F}{matrix of mean fecundity values}

\item{sample_size}{matrix of sample size for each element of the matrix, or a
single value applied to the whole matrix}

\item{split}{logical, whether to split the output into survival and fecundity
matrices or not}
}
\value{
list of matrices of survival and fecundity if split = TRUE, otherwise
a single matrix of the sum of survival and fecundity
}
\description{
Simulates a matrix population model based on expected values in the
transition matrix. The expected values are provided in two matrices \code{mat_U}
for the growth/development and survival transitions and \code{mat_F} for the
fecundity transitions.The \code{mat_U} values are simulated based on expected
probabilities, assuming a binomial process with a sample size defined by
\code{sample_size}. The \code{mat_F} values are simulated using a Poisson process with
a sample size defined by \code{sample_size}.Thus users can expect that large
sample sizes will result in simulated matrices that match closely with the
expectations, while simulated matrices with small sample sizes will be more
variable.
}
\examples{
mats <- make_leslie_matrix(
  survival = c(0.1, 0.2, 0.5),
  fertility = c(0, 1.2, 2.4),
  n_stages = 3, split = TRUE
)
ssMat <- matrix(10, nrow = 3, ncol = 3)

simulate_mpm(
  mat_U = mats$mat_U, mat_F = mats$mat_F,
  sample_size = ssMat, split = TRUE
)
}
\author{
Owen Jones \href{mailto:jones@biology.sdu.dk}{jones@biology.sdu.dk}
}
