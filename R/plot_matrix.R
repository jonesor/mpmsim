#' Plot a matrix as a heatmap
#'
#' Visualise a matrix, such as a matrix population model (MPM), as a heatmap.
#'
#' @param mat A matrix, such as the A matrix of a matrix population model
#' @param zero_na Logical indicating whether zero values should be treated as NA
#' @param legend Logical indicating whether to include a legend
#' @param na_colour Colour for NA values
#' @param ... Additional arguments to be passed to ggplot
#' @return A ggplot object
#' @export
#' @importFrom ggplot2 ggplot scale_colour_gradientn theme_void geom_tile theme
#'   scale_fill_viridis_c aes
#' @importFrom reshape melt
#' @importFrom dplyr mutate
#' @author Owen Jones <jones@biology.sdu.dk>
#' @family utility
#' @examples
#' matDim <- 10
#' A1 <- make_leslie_mpm(
#'   survival = seq(0.1, 0.7, length.out = matDim),
#'   fertility = seq(0.1, 0.7, length.out = matDim),
#'   n_stages = matDim
#' )
#' plot_matrix(A1, zero_na = TRUE, na_colour = "black")
#' plot_matrix(A1, zero_na = TRUE, na_colour = NA)
#'
plot_matrix <- function(mat, zero_na = FALSE, legend = FALSE,
                        na_colour = NA, ...) {
  # Validation
  # Check that mat is a matrix
  if (!inherits(mat, "matrix")) {
    stop("mat must be a matrix")
  }

  # Check that zero_na is a logical value
  if (!is.logical(zero_na)) {
    stop("zero_na must be a logical value")
  }

  # Check that legend is a logical value
  if (!is.logical(legend)) {
    stop("legend must be a logical value")
  }

  # Check that na_colour is a valid colour
  if (is.null(na_colour)) {
    stop("na_colour must be a valid colour, or NA.
         Consider specifying zero values as NA, with `zero_NA`")
  }

  # Check that na_colour is a valid colour
  if (!(is.na(na_colour) || is_colour(na_colour))) {
    stop("na_colour must be a valid colour, or NA.
         Consider specifying zero values as NA, with `zero_NA`")
  }



  df <- melt(t(mat))
  colnames(df) <- c("x", "y", "value")

  if (zero_na) {
    df <- df |>
      mutate(value = ifelse(value == 0, NA, value))
  }

  df <- df |>
    mutate(y = rev(y))

  p <- ggplot(df, aes(x = x, y = y, fill = value)) +
    geom_tile() +
    theme_void() +
    scale_fill_viridis_c(na.value = na_colour)

  if (legend) {
    p_out <- p
  } else {
    p_out <- p + theme(legend.position = "none")
  }

  return(p_out)
}

#' Helper function to validate colours
#'
#' @importFrom grDevices col2rgb
#' @noRd


is_colour <- function(x) {
  sapply(x, function(z) {
    tryCatch(is.matrix(col2rgb(z)),
      error = function(e) FALSE
    )
  })
}
