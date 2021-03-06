% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/update_achievement_function.r
\name{update.achievement}
\alias{update.achievement}
\title{Function for updating the achievement of all students during one time interval
called by grow.trajectories()}
\usage{
\method{update}{achievement}(
  learn.rate,
  home.env,
  decay.rate,
  achievement,
  assignment,
  dosage,
  school.weight,
  home.weight,
  decay.weight,
  school.lookup.table,
  home.lookup.table,
  which.curriculum
)
}
\arguments{
\item{learn.rate}{vector of learning rates, one for each student}

\item{home.env}{vector of home environments, one for each student}

\item{decay.rate}{vector of decay rates, one for each student}

\item{achievement}{vector of achievement values, one for each student}

\item{assignment}{vector indicating which school curriculum will be presented during each time period,
where the numbers refer to columns of the curriculum.start.points matrix and zeros represent times
of no school instruction (e.g., summmer)}

\item{dosage}{scalar ranging from 0 to 1 indicating the ratio of school / home exposure during time
intervals where school curriculum is presented (e.g., during academic years)}

\item{school.weight}{a global scalar for adjusting the growth from school exposure; prevents having to adjust
all learn.rate values}

\item{home.weight}{a global scalar for adjusting the growth from home; prevents having to adjust all home.env values}

\item{decay.weight}{a global scalar for adjusting the rate of forgetting; prevents having to adjust all decay.rate values}

\item{school.lookup.table}{the school growth lookup table produced by the build_school_lookup() function}

\item{home.lookup.table}{the home growth lookup table produced by the build_home_lookup() funtion}

\item{which.curriculum}{a vector of values indicating which version of the school curriculum should be presented
during interval t. The numbers index list elements of the curriculum.start.points and curriculum.widths objects}
}
\description{
Function for updating the achievement of all students during one time interval
called by grow.trajectories()
}
\examples{
\dontrun{
curriculum.start.points <- matrix(c(.1, .2, .3), ncol=1)

curriculum.widths <- matrx(rep(.11, 3), ncol=1)

school.lookup.table <- build.school.lookup(integration.points=2000, ZPD.width=.05,
                                           ZPD.offset=.02,
                                           curriculum.start.points=curriculum.start.points,
                                           curriculum.widths=curriculum.widths,
                                           slope1=10, slope2=30, maxachievement=1.5)

home.lookup.table <- build.home.lookup(integration.points=2000, ZPD.width=.05, ZPD.offset=.02,
                                       rate=4, maxachievement=1.5)

update.achievement(learn.rate=c(.05, .04, .03), home.env=c(.15, .2, .08),
                   decay.rate=c(.001, .002, .0015),
                   achievement=rep(.15, 3), which.curriculum=1,
                   assignment=1, decay.weight=.25, school.weight=1, home.weight=1,
                   dosage=.8, school.lookup.table=list(school.lookup.table),
                   home.lookup.table=home.lookup.table)
}
}
