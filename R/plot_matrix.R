#' Plot a matrix as a heatmap
#'
#' Visualise a matrix, such as a matrix population model (MPM), as a heatmap.
#'
#' @param A A matrix, such as the A matrix of a matrix population model
#' @param zeroNA Logical indicating whether zero values should be treated as NA
#' @param legend Logical indicating whether to include a legend
#' @param na_colour Colour for NA values
#' @param ... Additional arguments to be passed to ggplot
#' @return A ggplot object
#' @export
#' @importFrom ggplot2 ggplot scale_colour_gradientn theme_void geom_tile theme scale_fill_viridis_c aes
#' @importFrom reshape melt
#' @importFrom dplyr mutate
#' @examples
#' matDim <- 10
#' A1 <- make_leslie_matrix(
#'   survival = seq(0.1, 0.7, length.out = matDim),
#'   fertility = seq(0.1, 0.7, length.out = matDim),
#'   n_stages = matDim
#' )
#' plot_matrix(A1, zeroNA = TRUE, na_colour = "black")
#' plot_matrix(A1, zeroNA = TRUE, na_colour = NA)
#'
plot_matrix <- function(A, zeroNA = FALSE, legend = FALSE, na_colour = NA, ...) {
  # Validation
  # Check that A is a matrix
  if (!inherits(A, "matrix")) {
    stop("A must be a matrix")
  }

  # Check that zeroNA is a logical value
  if (!is.logical(zeroNA)) {
    stop("zeroNA must be a logical value")
  }

  # Check that legend is a logical value
  if (!is.logical(legend)) {
    stop("legend must be a logical value")
  }

  # Check that na_colour is a valid colour
  if (!(is.na(na_colour) || is_colour(na_colour))) {
    stop("na_colour must be a valid colour, or NA")
  }


  df <- melt(t(A))
  colnames(df) <- c("x", "y", "value")

  if (zeroNA) {
    df <- df |>
      mutate(value = ifelse(value == 0, NA, value))
  }

  df <- df |>
    mutate(y = rev(y))

  p <- ggplot(df, aes(x = x, y = y, fill = value)) +
    geom_tile() +
    theme_void() +
    # scale_fill_gradientn(colours = terrain.colors(sqrt(nrow(df))), na.value = na_colour)
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
  sapply(x, function(X) {
    tryCatch(is.matrix(col2rgb(X)),
      error = function(e) FALSE
    )
  })
}
