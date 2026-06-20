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

      #..................... INPUT VALIDATION .......................................
      
      if (!is.list(api_response) || !("sampled_probs" %in% names(api_response))) {
          stop("'api_response' must be a list containing a 'sampled_probs' element.")
      }
      
      if (is.null(api_response$sampled_probs)) {
          stop("sampled_probs is NULL.")
      }
      
      if (!is.numeric(api_response$sampled_probs) || length(api_response$sampled_probs) == 0 || anyNA(api_response$sampled_probs) || 
      any(!is.finite(api_response$sampled_probs))) {
          stop("sampled_probs must be numeric, non-empty, and must not contain NA, NaN, Inf, and -Inf")
      }
      
      #.............................................................................
      
      
      #..................... RETURN OUTPUT .........................................
      
      api_response$sampled_probs
      
      #.............................................................................
}


