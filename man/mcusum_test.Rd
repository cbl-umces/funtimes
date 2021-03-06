% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mcusum_test.R
\name{mcusum_test}
\alias{mcusum_test}
\title{Change Point Test for Regression}
\usage{
mcusum_test(
  e,
  k,
  B = 1000,
  ksm = FALSE,
  ksm.arg = list(kernel = "gaussian", bw = "sj"),
  ...
)
}
\arguments{
\item{e}{vector of regression residuals (a stationary time series).}

\item{k}{an integer vector or scalar with hypothesized change point location(s) to
test. The length of this vector is treated as \eqn{m}, that is, the number of change
points being confirmed as statistically significant (from those
specified in \code{k}) would be \eqn{\le m}.}

\item{B}{number of bootstrap simulations to obtain empirical critical values.
Default is 1000.}

\item{ksm}{logical value indicating whether a kernel smoothing to innovations in sieve
bootstrap shall be applied (default is \code{FALSE}, that is, the original estimated
innovations are bootstrapped, without the smoothing).}

\item{ksm.arg}{used only if \code{ksm = TRUE}. A list of arguments for kernel smoothing
to be passed to \code{\link[stats]{density}} function. Default settings specify the
use of Gaussian kernel and the \code{"sj"} rule to choose the bandwidth.}

\item{...}{additional arguments passed to \code{\link{ARest}}
(for example, \code{ar.method}).}
}
\value{
A list of class \code{"htest"} containing the following components:
\item{method}{name of the method.}
\item{data.name}{name of the data.}
\item{statistic}{obseved value of the test statistic.}
\item{parameter}{\code{mhat} is the final number of change points,
from those specified in the input \code{k},
for which the test statistic is reported.
See the corresponding locations, \code{khat}, in the \code{estimate}.}
\item{p.value}{bootstrapped \eqn{p}-value of the test.}
\item{alternative}{alternative hypothesis.}
\item{estimate}{list with elements: \code{AR_order} and
\code{AR_coefficients} (the autoregressive order and estimated autoregressive
coefficients used in sieve bootstrap procedure), \code{khat} (final change points,
from those specified in the input \code{k} for which the test statistic is reported),
and \code{B} (the number of bootstrap replications).}
}
\description{
Apply change point test by \insertCite{Horvath_etal_2017;textual}{funtimes}
for detecting at-most-\eqn{m} changes in regression coefficients, where
test statistic is a modified cumulative sum (CUSUM), and
critical values are obtained with sieve bootstrap \insertCite{Lyubchich_etal_2020_changepoints}{funtimes}.
}
\details{
The sieve bootstrap is applied by approximating regression residuals \code{e}
with an AR(\eqn{p}) model using function \code{\link{ARest}},
where the autoregressive coefficients are estimated with \code{ar.method},
and order \eqn{p} is selected based on \code{ar.order} and \code{BIC} settings
(see \code{\link{ARest}}). At the next step, \code{B} autoregressive processes
are simulated under the null hypothesis of no change points.
The distribution of test statistics \eqn{M_T} computed on each of those
bootstrapped series is used to obtain bootstrap-based \eqn{p}-values for the test
\insertCite{Lyubchich_etal_2020_changepoints}{funtimes}.

The test statistic corresponds to the maximal value of the modified CUSUM over
all combinations of hypothesized change points specified in \code{k}. The change
points that correspond to that maximum are reported in \code{estimate$khat},
and their number is reported as \code{parameter}.
}
\examples{
##### Model 1 with normal errors, by Horvath et al. (2017)
T <- 100 #length of time series
X <- rnorm(T, mean = 1, sd = 1)
E <- rnorm(T, mean = 0, sd = 1)
SizeOfChange <- 1
TimeOfChange <- 50
Y <- c(1 * X[1:TimeOfChange] + E[1:TimeOfChange], 
      (1 + SizeOfChange)*X[(TimeOfChange + 1):T] + E[(TimeOfChange + 1):T])
ehat <- lm(Y ~ X)$resid
mcusum_test(ehat, k = c(30, 50, 70))

#Same, but with bootstrapped innovations obtained from a kernel smoothed distribution:
mcusum_test(ehat, k = c(30, 50, 70), ksm = TRUE)

}
\references{
\insertAllCited{}
}
\author{
Vyacheslav Lyubchich
}
\keyword{changepoint}
\keyword{htest}
\keyword{ts}
