\name{iossa.err}
\alias{iossa.err}
\docType{data}
\title{
  Simulated example: Separability of sine waves with close frequencies
  via IOSSA.
}
\description{
  Basic SSA separates well the sinusoids with close frequencies from
  noise, but cannot separate these sinusoids from each other. 
  Thus, Iterative O-SSA, applied to the estimated signal subspace,
  should be used.

  The dataset shows the dependence on the distance between the
  frequencies of RMSE of their estimates after IOSSA as
  well as number of IOSSA iterations.
}
\usage{data("iossa.err")}
\format{
  The format is:
List of 4
 $ iter.est : Estimated number of IOSSA iterations
 $ iter.real: Real number of IOSSA iterations
 $ err1     : RMSE of omega_1
 $ err2     : RMSE of omega_2
}
\details{
  See Section 2.4.4.3 for discussion.
  
  Generated as follows:

\preformatted{  library("Rssa")

  N <- 150
  L <- 70
  omega2 <- 0.06

  lseq <- c(seq(0.03, 0.058, 0.002), seq(0.062, 0.1, 0.002))
  F2.real <- 1.2 * sin(2 * pi * omega2 * (1:N))
  iter0 <-
    sapply(lseq,
           function(omega1) {
             F <- sin(2 * pi * omega1 * (1:N)) + F2.real
             iossa(ssa(F, L),
                   nested.groups = list(1:2, 3:4),
                   kappa = 2, maxiter = 200,
                   trace = FALSE)$iossa.result$iter
           })

  M <- 1000
  set.seed(1)
  est.err <- function() {
    noise <- rnorm(N)
    sapply(lseq,
           function(omega1) {
               F1.real <- sin(2 * pi * omega1 * (1:N))
               F <- F1.real + F2.real + noise
               ss <- iossa(ssa(F, L),
                           nested.groups = list(1:2, 3:4),
                           kappa = 2, maxiter = 200,
                           trace = FALSE)
               omega1.est <-
                   1 / parestimate(ss, groups = list(1:2),
                                   method = "esprit-ls")[[2]][1]
               omega2.est <-
                   1 / parestimate(ss, groups = list(3:4),
                                   method = "esprit-ls")[[2]][1]

               omegas.est <- range(omega1.est, omega2.est)
               if (omega2 < omega1)
                   omegas.est <- rev(omegas.est)

               c(iter = ss$iossa.result$iter,
                 err1 = (omega1 - omegas.est[1])^2,
                 err2 = (omega2 - omegas.est[2])^2)
           })
  }
  res <- replicate(M, est.err())

  iter <- res["iter", , ]
  err1 <- res["err1", , ]
  err2 <- res["err2", , ]

  list(iter.real = iter, iter.est = iter0,
       err1 = err1, err2 = err2)
  }
}

\examples{
library("lattice")
data(iossa.err)

rowMeansQuantile <- function(x, level = 0.05) {
  apply(x, 1,
        function(x) {
          q <- quantile(x, c(level / 2, 1 - level / 2))
          x[x < q[1]] <- q[1]
          x[x > q[2]] <- q[2]

          mean(x)
        })
}

lseq <- c(seq(0.03, 0.058, 0.002), seq(0.062, 0.1, 0.002))
iter.real <- rowMeansQuantile(iossa.err$iter.real)
iter.est <- iossa.err$iter.est
err1 <- sqrt(rowMeansQuantile(iossa.err$err1))
err2 <- sqrt(rowMeansQuantile(iossa.err$err2))

xlab <- expression(omega[1])
ylab1 <- expression(N[plain(iter)])
ylab2 <- expression(RMSE)

p1 <- xyplot(iter.real + iter.est ~ lseq,
             type = "l", ylab = ylab1, xlab = xlab)
p2 <- xyplot(err1 + err2 ~ lseq,
             type = "l", ylab = ylab2, xlab = xlab)
print(p1, split = c(1, 1, 1, 2), more = TRUE)
print(p2, split = c(1, 2, 1, 2), more = FALSE)

}
\keyword{datasets}
