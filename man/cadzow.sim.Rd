\name{cadzow.sim}
\alias{cadzow.sim}
\docType{data}
\title{
  Accuracy of weighted Cadzow approximation
}
\description{
  Comparison of Cadzow(alpha) and Cadzow(1) iterations
}
\usage{data("cadzow.sim")}
\format{
  A data frame with 1 observations on the following 2 variables.
  \describe{
    \item{\code{err}}{a numeric vector}
    \item{\code{err.alpha}}{a numeric vector}
  }
}
\details{
  See Section 3.4.3.3 for discussion.
  
  Generated as follows:

\preformatted{library("Rssa")
set.seed(3)
L <- 20
N <- 2 * L
K <- N - L + 1
alpha <- 0.01

sigma <- 1
signal <- 5 * sin(2 * pi * (1:N) / 6)

weights <- vector(len = K)
weights[1:K] <- alpha
weights[seq(1, K, L)] <- 1

M <- 1000
norm.meansq <- function(x) mean(x^2)
RMSE <- sqrt(rowMeans(replicate(M, {
x <- signal + sigma * rnorm(N)
  s.alpha <- ssa(x, L = L, column.oblique = NULL, 
                 row.oblique = weights)
  c.alpha <- cadzow(s.alpha, rank = 2, tol = 1.e-8, 
                    norm = norm.meansq, 
                    correct = FALSE)
  s <- ssa(x, L = L)
  cc <- cadzow(s, rank = 2, norm = norm.meansq, tol = 1.e-8, 
               correct = FALSE)
  c("err" = mean((cc - signal)^2),
    "err.alpha" = mean((c.alpha - signal)^2))
})))
cadzow.sim <- as.data.frame(t(RMSE))
}
}

\examples{
data(cadzow.sim)
print(cadzow.sim)
}
\keyword{datasets}
