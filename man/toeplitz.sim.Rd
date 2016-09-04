\name{toeplitz.sim}
\alias{toeplitz.sim}
\docType{data}
\title{
  Simulation: comparison of Toeplitz and Basic SSA
}
\description{
 Dependence of the reconstruction accuracy on the exponential rate for
 usual 1D SSA and Toeplitz SSA.
}
\usage{data("toeplitz.sim")}
\format{
  A data frame with 11 observations on the following 2 variables.
  \describe{
    \item{\samp{1d-ssa}}{a numeric vector}
    \item{\code{toeplitz}}{a numeric vector}
  }
}
\details{
  See Section 2.2.3.3 for discussion.
  
  Generated as follows:

\preformatted{library("Rssa")
N <- 100
sigma <- 0.5
set.seed(1)
alpha <- seq(0.0, 0.01, 0.001)
L <- 50
Q <- 1000
RMSE <-
  sapply(alpha,
         function(a) {
           sqrt(rowMeans(replicate(Q, {
             S <- exp(a * (1:N)) * sin(2 * pi * (1:N) / 7)
             F <- S + sigma * rnorm(N)
             Fcenter <- F - mean(F)
             st <- ssa(Fcenter, L = L, kind = "toeplitz-ssa")
             s <- ssa(F, L = L, kind = "1d-ssa")
             rec <- reconstruct(s, groups = list(1:2))$F1
             rec.t <- reconstruct(st, groups = list(1:2))$F1
             c("1d-ssa" = mean((rec - S)^2),
               "toeplitz" = mean((rec.t - S)^2))
           })))
         })    
toeplitz.sim <- as.data.frame(t(RMSE))
}
}

\examples{
data(toeplitz.sim)
alpha <- seq(0.0, 0.01, 0.001)
matplot(alpha, toeplitz.sim, type = 'l', ylim = c(0, 0.25))
}
\keyword{datasets}
