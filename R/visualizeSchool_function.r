#' Function for visualizing the school curriculum.
#'
#'  \code{visualizeSchool} plots school curriculum. It is useful for exploring
#'    the consequences of the \code{curriculum.start.points}, \code{curriculum.widths},
#'    \code{curriculum.lower.slope}, \code{curriculum.upper.slope}, and \code{alpha} arguments to
#'    \code{ZPDGrowthTrajectories()}. The function returns a
#'    \code{ggplot} object that can be modified with typical \code{ggplot2} arguments.
#'
#' @param slope1 The steepness of the school curriculum cutoff at the lower range.
#'   Conceptually controls the amount of review content.
#' @param slope2 The slope of the school curriculum at the upper range.
#'   Conceptually controls the amount of advanced content.
#' @param start.point The point at which the curriculum reaches full intensity. This value would become one of
#'  the elements of the curriculum.start.points argument to \code{ZPDGrowthTrajectories}.
#' @param width The highest point at which the curriculum is at full intensity. This value would become one of
#'  the elements of the curriculum.widths argument to \code{ZPDGrowthTrajectories}.
#'
#' @examples
#' visualizeSchool(start.point=.2, width=.1, slope1=10, slope2=15)
#'
#' @export

visualizeSchool <- function(start.point, width, slope1, slope2) {

  #x <- seq(0, 1, length.out=10000)

  x <- seq(min(0, 2*start.point - (1/slope1)),
           max(1, 2*start.point+width + (1/slope2)),
           length.out=10000)

  y <- school(x=x, slope1=slope1, slope2=slope2, start=start.point, end=start.point+width)

  # normalize intensity (y)
  y <- y / max(y)

  data <- data.frame(cbind(x,y))

  # calculate area to shade
  shade <- rbind(c(0,0), subset(data, (x>min(0, 2*start.point - (1/slope1)) &
                                         x<=  max(1, 2*start.point+width + (1/slope2)))), c(1, 0))

  p <- ggplot2::ggplot(data=data, ggplot2::aes(x=x, y=y))+ggplot2::geom_line(alpha=.5)+
    ggplot2::geom_polygon(data=shade, ggplot2::aes(x,y), fill="blue", alpha=.1)+
    ggplot2::theme_classic()+ggplot2::ylab("achievement")+ggplot2::xlab("intensity")

  return(p)
}