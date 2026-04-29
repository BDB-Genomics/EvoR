#' Extract biological data from Evo2 API response
#' @param api_response The parsed response from the Evo2 API
#' @return A list containing the biological sequence and elapsed time in milliseconds
#' @export
#' @examples
#' \dontrun{
#'   api_response <- evo2_request()
#'   result <- evo2_get(api_response)
#' }
evo2_get <- function(api_response) {
  sequence <- api_response$sequence
  elapsed_ms <- api_response$elapsed_ms

  result <- list(
    sequence = sequence,
    elapsed_ms = elapsed_ms
  )

  return(result)
}
