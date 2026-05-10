#' Extract confidence scores (probabilities) from Evo2 API response
#'
#' @param api_response The parsed response list from the Evo2 API (via evo2_query)
#' @return A numeric vector of probabilities (sampled_probs) for each generated base
#' @export
#' @examples
#' \dontrun{
#'   api_response <- evo2_query("ACGT")
#'   scores <- evo2_get_score(api_response)
#' }

evo2_get_score <- function(api_response) {
      return(api_response$sampled_probs)
}



