#' Query the Evo2 API for sequence embeddings (forward pass)
#'
#' @param sequence The DNA sequence to get embeddings for
#' @param layer The layer name to extract (default: "blocks.28.mlp.l3")
#' @param api_url The base URL for the Evo2 forward API (optional)
#' @param api_key The API key for authentication (optional)
#' @return A list containing the API response with embeddings and metadata
#' @export
#' @examples
#' \dontrun{
#'   api_response <- evo2_query_embeddings("ACGT")
#' }
evo2_query_embeddings <- function(sequence,
                                  layer = "blocks.28.mlp.l3",
                                  api_url = NULL,
                                  api_key = NULL) {

  if (is.null(api_url)) {
    api_url <- "https://health.api.nvidia.com/v1/biology/arc/evo2-40b/forward"
  }

  if (is.null(api_key)) {
    api_key <- Sys.getenv("NVIDIA_API_KEY")
  }

  if (api_key == "") {
    stop("API key not found. Set NVIDIA_API_KEY environment variable or pass api_key parameter.")
  }

  body <- list(
    sequence = sequence,
    output_layers = list(layer)
  )

  start_time <- Sys.time()

  response <- httr2::request(api_url) |>
    httr2::req_headers(
      "Authorization" = paste("Bearer", api_key),
      "Content-Type" = "application/json"
    ) |>
    httr2::req_body_json(body) |>
    httr2::req_retry(max_tries = 3) |>
    httr2::req_timeout(120) |>
    httr2::req_error(body = \(resp) {
      err <- httr2::resp_body_json(resp)
      sprintf("Evo2 API error [%s]: %s", httr2::resp_status(resp), err$detail %||% err$message %||% "unknown")
    }) |>
    httr2::req_perform()

  end_time <- Sys.time()
  elapsed_ms <- as.numeric(difftime(end_time, start_time, units = "secs")) * 1000

  result <- httr2::resp_body_json(response)
  result$elapsed_ms <- elapsed_ms
  result$target_layer <- layer

  return(result)
}
