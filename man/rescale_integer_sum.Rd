% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rescale_integer_sum.R
\name{rescale_integer_sum}
\alias{rescale_integer_sum}
\title{Rescale Integer Vector to a Set sum}
\usage{
rescale_integer_sum(x, tot)
}
\arguments{
\item{x}{Vector of numeric values}

\item{tot}{Numeric integer value to rescale sum to.}
}
\value{
Vector or integer values that sum to to \code{tot}
}
\description{
For when you want to rescale a set of numbers to sum to a given value and do not want all rescaled values to be integers.
}
\examples{
x <- rnorm(n = 10, mean = 5, sd = 20)
y <- rescale_integer_sum(x, tot = 10)
y
sum(y)

for(i in 1:10){
  y <- rescale_integer_sum(x = rpois(n = 10, lambda = 10), tot = 1000)
  print(sum(y))
}
}
\seealso{
\code{\link{ipf3_qi}}, \code{\link{ffs_diff}}
}
\author{
Guy J. Abel
}
