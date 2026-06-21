#' Query the Evo2 API
#' @param sequence The biological sequence (DNA/RNA/protein) to query
#' @param num_tokens Number of tokens to generate (default: 8)
#' @param temperature Sampling temperature (default: 1.0)
#' @param top_k Top-k sampling parameter (default: 1, which makes generation deterministic/reproducible)
#' @param top_p Top-p (nucleus) sampling parameter (default: 1.0)
#' @param seed Random seed for reproducible generation (optional)
#' @param api_url The base URL for the Evo2 API (optional)
#' @param api_key The API key for authentication (optional)
#' @return A list containing the API response data and elapsed time in milliseconds
#' @export
#' @examples
#' if (nzchar(Sys.getenv("NVIDIA_API_KEY"))) {
#'   result <- evo2_query("ACGTACGTACGT", seed = 42)
#' }
evo2_query <- function(sequence,
                       num_tokens = 8,
                       temperature = 1.0,
                       top_k = 1,
                       top_p = 1.0,
                       seed = NULL,
                       api_url = NULL,
                       api_key = NULL) {

  #......................................................... INPUT VALIDATION ........................................................................
  
  # sequence 
  if (!is.character(sequence) || length(sequence) != 1 || is.na(sequence) || !nzchar(sequence) || nchar(sequence) > 50000 || !grepl("^[ATGCUNRYKMSWBDHV]+$", sequence)) {
    stop("The sequence must be a character string of length 1, not greater than 50000 bp, non-empty, and IUPAC compliant.")
  }
  
  # num_tokens
  if (!is.numeric(num_tokens) || length(num_tokens) != 1 || !is.finite(num_tokens) || num_tokens != floor(num_tokens) || num_tokens < 1 || num_tokens > 100) {
    stop("The num_tokens must be numeric and between 1 and 100")
  }
  
  # temperature
  if (!is.numeric(temperature) || length(temperature) != 1 || !is.finite(temperature) || temperature < 0 || temperature > 2) {
    stop("The temperature must be numeric and between 0 and 2.")
   }
  
  # top_k 
  if (!is.numeric(top_k) || length(top_k) != 1 || !is.finite(top_k) || top_k != floor(top_k) || top_k < 1 || top_k > 100) {
    stop("The top_k must be integer and between 1 and 100.")
  }
  
  # top_p
  if (!is.numeric(top_p) || length(top_p) != 1 || !is.finite(top_p) || top_p < 0 || top_p > 1) {
    stop("The top_p must be numeric and between 0 and 1.")
  }      
  
  # seed
  if (!is.null(seed) && (!is.numeric(seed) || length(seed) != 1 || !is.finite(seed) || seed < 0 || seed != floor(seed))) {
    stop("seed must be a non-negative integer.")
  }

#...................................................................................................................................................
  
#...................................................................................................................................................  

#......................................................... CORE LOGIC ..............................................................................
  
  # Set the endpoint
  if (is.null(api_url)) {
    api_url <- "https://health.api.nvidia.com/v1/biology/arc/evo2-40b/generate"
  }

  # Grab the API key from environment variable
  if (is.null(api_key)) {
    api_key <- Sys.getenv("NVIDIA_API_KEY")
  }

  if (api_key == "") {
    stop("API key not found. Set NVIDIA_API_KEY environment variable or pass api_key parameter.")
  }

  # Build request body
  body <- list(
    sequence = sequence,
    num_tokens = num_tokens,
    temperature = temperature,
    top_k = top_k,
    top_p = top_p,
    enable_sampled_probs = TRUE
  )

  # Include seed if provided to ensure exact reproducibility
  if (!is.null(seed)) {
    body$seed <- seed
  }

  # Record start time
  start_time <- Sys.time()

  # Send the request
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

  # Record end time and calculate elapsed milliseconds
  end_time <- Sys.time()
  elapsed_ms <- as.numeric(difftime(end_time, start_time, units = "secs")) * 1000

  # Parse JSON response
  result <- httr2::resp_body_json(response)

  # Add elapsed time to result
  result$elapsed_ms <- elapsed_ms
  
#...................................................................................................................................................

#......................................................... RETURN OUTPUT ...........................................................................

  result
  
#...................................................................................................................................................  
}
