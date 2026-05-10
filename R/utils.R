#' Null coalescing operator
#'
#' @param x An object
#' @param y An object to return if x is NULL
#' @return x if x is not NULL, otherwise y
#' @noRd
`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}
