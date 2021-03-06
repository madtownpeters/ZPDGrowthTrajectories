#' Function for visualizing trajectories generated by ZPDGrowthTrajectories
#'
#' \code{visualizeTrajectories} plots synthetic growth trajectories using \code{ggplot2}.
#'
#' \code{visualizeTrajectories} plots the trajectories generated by the \code{ZPDGrowthTrajectories()}
#'  function. The figure plots achievement versus time and represents each student's trajectory using a
#'  different colored line.
#'
#' @param trajectories An object of class \code{ZPD} produced by the \code{ZPDGrowthTrajectories()}
#'  function. If needed, this object be converted internally to "long" format suitable for
#'  \code{ggplot}.The function returns a \code{ggplot} object that can be modified with typical
#'  \code{ggplot2} arguments.
#'
#' @param showTransitions Logical. Should vertical lines be drawn when the school curriculum changes?
#'   Defaults to FALSE
#'
#' @param timerange Optional numeric vector providing limits for the x axis. Defaults to NULL.
#'
#' @param version Optional numeric vector for plotting trajectories only for specific version(s) of
#'   the curriculum. For example, \code{c(1,2)} indicates that only trajectories for versions 1 and 2
#'   should be plotted
#'
#' @family visualizations
#'
#' @seealso \code{\link{describeTrajectories}} for calculating summary statistics of the generated
#'  trajectories.
#'
#' @seealso \code{\link{ZPDGrowthTrajectories}} for simulating growth trajectories.
#'
#' @importFrom utils tail
#' @importFrom checkmate qtest
#'
#' @examples
#' # learning rate
#' learn.rate <- c(.08, .10, .12, .18)
#'
#' # decay rate
#' decay.rate <- c(.04, .03, .02, .01)
#'
#' # initial achievement
#' initial.ach <- rep(0, times=4)
#'
#' # quality of home environment
#' home.env <- c(.06, .12, .15, .20)
#'
#' # assignment object simulating starting kindergarten on time 801
#' #  Kindergarten for 200 days, followed by 100 days of summer
#' #  then 200 days of first grade
#' assignment <- c(rep(0, times=800), rep(1, times=200),
#'                 rep(0, times=100), rep(2, times=200))
#'
#' # define school curriculum
#' curriculum.start.points <- list(
#'     # "typical curriculum" start points for K and first grade
#'   matrix(c(.2, .26), nrow=2, ncol=1),
#'     # "advanced curriculum" start points for K and first grade
#'   matrix(c(.22, .29), nrow=2, ncol=1)
#' )
#'
#' curriculum.widths <- list(
#'   # "typical curriculum" widths for K and first grade
#'   matrix(c(.04, .04), nrow=2, ncol=1),
#'   # "advanced curriculum" widths for K and first grade
#'   matrix(c(.05, .05), nrow=2, ncol=1)
#' )
#'
#' curriculum.review.slopes <- list(
#'   # "typical curriculum" review slopes for K and first grade
#'   matrix(c(30, 30), nrow=2, ncol=1),
#'   # "advanced curriculum" review slopes for K and first grade
#'   matrix(c(60, 60), nrow=2, ncol=1)
#' )
#'
#' curriculum.advanced.slopes <- list(
#'   # "typical curriculum" advanced slopes for K and first grade
#'   matrix(c(50, 50), nrow=2, ncol=1),
#'   # "advanced curriculum" advanced slopes for K and first grade
#'   matrix(c(25, 25), nrow=2, ncol=1)
#' )
#'
#' # students 1 and 2 get typical curriculum, 3 and 4 get advanced
#' which.curriculum <- c(1,1,2,2)
#'
#'  y <- ZPDGrowthTrajectories(learn.rate=learn.rate, home.env=home.env,
#'                         decay.rate=decay.rate, initial.ach=initial.ach,
#'                         ZPD.width=.05, ZPD.offset=.02,
#'                         home.learning.decay.rate=6,
#'                         curriculum.start.points=curriculum.start.points,
#'                         curriculum.widths=curriculum.widths,
#'                         curriculum.review.slopes=curriculum.review.slopes,
#'                         curriculum.advanced.slopes=curriculum.advanced.slopes,
#'                         assignment=assignment, dosage=.8,
#'                         adaptive.curriculum=FALSE,
#'                         which.curriculum=which.curriculum,
#'                         school.weight=.5, home.weight=1, decay.weight=.05,
#'                         verbose=TRUE)
#
#' visualizeTrajectories(y)
#'
#' visualizeTrajectories(y, timerange=c(500, 700))
#'
#'
#' @export

  visualizeTrajectories <- function(trajectories, showTransitions=FALSE, timerange=NULL, version=NULL) {

  `%notin%` <- Negate(`%in%`)

  # check if trajectories is class ZPD, if not stop
  if(!("ZPD" %in% class(trajectories))) {stop("Object supplied to trajectories argument is not ZPDGrowthTrajectories() output")}

  # check if showTransitions is logical
  if(checkmate::qtest(showTransitions, "B1")==FALSE) {stop("showTransitions must be TRUE or FALSE")}

  # if timerange is provided, it must be a numeric vector of length 2, no NAs, in ascending order, and matching values
  if (is.null(timerange)==FALSE) {
    if(checkmate::qtest(timerange, "N2[0,)")==FALSE) {stop("timerange must either be NULL or a nonnegative vector of length 2")}
    if (any(timerange %notin% trajectories$time)) {stop("a value in timerange exceeds the range of time points included in trajectories")}
    if (timerange[2] <= timerange[1]) {stop("values supplied to timerange must be in ascending order")}
  }

  # if version is provided, it must be integer-line with no NA and length 1, and values in range
  if (!is.null(version)) {
    if (qtest(version, "X>=1[1,)") == FALSE) {stop("version must be a postive scalar or vector containing integer values")}
    if (any(!version %in% trajectories$version)) {stop("the specified value(s) of version are not found in trajectories object")}
  }

  if (!is.null(version)) {
    # restrict trajectories to the matching values of version
    trajectories <- trajectories[trajectories$version %in% version,]
  }

  if (!is.null(timerange)) {

    p <- ggplot2::ggplot(data=trajectories[trajectories$time >= timerange[1] & trajectories$time <= timerange[2],],
                         ggplot2::aes(x=time, y=achievement, color=factor(id)))+
      ggplot2::geom_line(show.legend=FALSE, size=.5, alpha=.5) +
      ggplot2::geom_hline(yintercept=0, col="gray")+ggplot2::geom_vline(xintercept=0, col="gray")+
      ggplot2::theme(panel.background=ggplot2::element_blank(), panel.grid.major=ggplot2::element_blank(),
                   panel.grid.minor=ggplot2::element_blank())
  } else {

    p <- ggplot2::ggplot(data=trajectories, ggplot2::aes(x=time, y=achievement, color=factor(id)))+
      ggplot2::geom_line(show.legend=FALSE, size=.5, alpha=.5) +
      ggplot2::geom_hline(yintercept=0, col="gray")+ggplot2::geom_vline(xintercept=0, col="gray")+
      ggplot2::theme(panel.background=ggplot2::element_blank(), panel.grid.major=ggplot2::element_blank(),
                     panel.grid.minor=ggplot2::element_blank())
  }

  if (showTransitions==TRUE) {

    # get assignment object from ZPDGrowthTrajectories output
    assignment <- trajectories$assignment[trajectories$version==1 & trajectories$id==1]

    # find transitions in the assignment object
    lag.assignment <- c(utils::tail(assignment,-1),NA)

    # index of those transitions, appending first and last time point / time
    index <- which(assignment != lag.assignment)

    p <- p + ggplot2::geom_vline(xintercept=index, alpha=.25)
  }

  if (!is.null(timerange)) {
    p <- p + ggplot2::coord_cartesian(xlim=timerange)
  }

  return(p)
}
