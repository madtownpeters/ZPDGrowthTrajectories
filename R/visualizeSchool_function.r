#' Function for visualizing the school curriculum.
#'
#' \code{visualizeSchool()} is a function for visualizing the school curriculum function.
#'
#'  \code{visualizeSchool()} plots the school curriculum. It is useful for exploring
#'    the consequences of the \code{curriculum.start.points}, \code{curriculum.widths},
#'    \code{curriculum.lower.slopes}, \code{curriculum.upper.slopes}, and \code{alpha} arguments to
#'    \code{ZPDGrowthTrajectories()}. The function returns a
#'    \code{ggplot} object that can be modified with typical \code{ggplot2} arguments.
#'
#' @param start.point The point at which the curriculum reaches full intensity. This value would become one of
#'  the elements of the \code{curriculum.start.points} argument to \code{ZPDGrowthTrajectories()}.
#'
#' @param width The highest point at which the curriculum is at full intensity. This value would become one of
#'  the elements of the \code{curriculum.widths} argument to \code{ZPDGrowthTrajectories()}.
#'
#' @param review.slope The steepness of the school curriculum cutoff at the lower range.
#'   Conceptually controls the amount of review content. This value would become one of
#'  the elements of the \code{curriculum.review.slopes} argument to \code{ZPDGrowthTrajectories()}.
#'
#' @param advanced.slope The slope of the school curriculum at the upper range.
#'   Conceptually controls the amount of advanced content. This value would become one of
#'  the elements of the \code{curriculum.advanced.slopes} argument to \code{ZPDGrowthTrajectories()}.
#'
#' @return An object of class \code{ggplot2}
#'
#' @examples
#' visualizeSchool(start.point=.2, width=.1, review.slope=10, advanced.slope=15)
#'
#' @family visualizations
#'
#' @seealso \code{\link{ZPDGrowthTrajectories}} for simulating growth trajectories.
#'
#' @importFrom checkmate qtest
#'
#' @export

visualizeSchool <- function(start.point, width, review.slope, advanced.slope) {

  # check arguments
  # all must be numeric non-NA length one. all must be positive; start.point can be zero
  if(checkmate::qtest(start.point, "N1[0,)")==FALSE) {stop("start.point must be a non-negative scalar")}
  if(checkmate::qtest(width, "N1(0,)")==FALSE) {stop("width must be a positive scalar")}
  if(checkmate::qtest(review.slope, "N1(0,)")==FALSE) {stop("review.slope must be a positive scalar")}
  if(checkmate::qtest(advanced.slope, "N1(0,)")==FALSE) {stop("advanced.slope must be a positive scalar")}

  # check if review slope leg extends past zero
  if (start.point - 1/review.slope < 0) {warning("the combination of start.point and review.slope implies that the school curriculum review leg extends below zero. Is this what you intended?")}

  # check if review component is wider than grade-level component
  if (1/review.slope > width) {warning("the combination of review.slope and width values you have specified implies that the review component of the curriculum is wider than the full-intensity portion. Is this what you intended?")}

  # check if advanced component is wider than grade-level component
  if (1/advanced.slope > width) {warning("the combination of advanced.slope and width values you have specified implies that the advanced component of the curriculum is wider than the full-intensity portion. Is this what you intended?")}

  # rename objects
  slope1 <- review.slope
  slope2 <- advanced.slope

  # scale autoscaled based on arguments with some space on each side
  end.point <- start.point + width
  space.left <- max((1/slope1), width/2)*2
  space.right <- max((1/slope2), width/2)*2

  x <- seq(max(start.point - space.left, 0),
           end.point + space.right,
           length.out=10000)

  y <- school(x=x, slope1=slope1, slope2=slope2, start=start.point, end=start.point+width)

  # normalize intensity (y)
  y <- y / max(y)

  data <- data.frame(cbind(x,y))

  # calculate area to shade
  shade <- rbind(c(max(start.point - space.left, 0), 0),
                 subset(data, (x >= max(0, start.point - space.left) &
                                         x <= end.point + space.right)),
                 c(end.point + space.right, 0))

  p <- ggplot2::ggplot(data=data, ggplot2::aes(x=x, y=y))+ggplot2::geom_line(alpha=.5)+
    ggplot2::geom_polygon(data=shade, ggplot2::aes(x,y), fill="blue", alpha=.1)+
    ggplot2::theme_classic()+ggplot2::ylab("achievement")+ggplot2::xlab("intensity")

  return(p)
}
