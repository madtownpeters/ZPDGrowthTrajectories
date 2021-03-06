% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/school_function.r
\name{school}
\alias{school}
\title{Function for defining the school curriculum function as a piecewise linear equation
called by school.growth()}
\usage{
school(x, slope1, slope2, start, end)
}
\arguments{
\item{x}{achievement value}

\item{slope1}{the slope of the lower leg of the school curriculum}

\item{slope2}{the slope of the upper leg of the school curriculum}

\item{start}{the curriculum starting location}

\item{end}{the curriculum ending location}
}
\description{
Function for defining the school curriculum function as a piecewise linear equation
called by school.growth()
}
\examples{
\dontrun{
x <- seq(0, 1, .001)
plot(x, school(x, slope1=10, slope2=30, start=.2, end=.4), "l")
# mark start and end points
 abline(v=c(.2, .4), lty="dotted", col="red")
}

}
