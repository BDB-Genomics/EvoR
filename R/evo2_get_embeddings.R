#' Extract and decode embeddings from Evo2 forward pass response
#'
#' @param api_response The parsed response list from the Evo2 forward API
#' @return A matrix of numerical embeddings (nucleotides x features)
#' @export
#' @examples
#' \dontrun{
#'   api_response <- evo2_query_embeddings("ACGT")
#'   embeddings <- evo2_get_embeddings(api_response)
#' }
evo2_get_embeddings <- function(api_response) {
    decoded_bytes <- base64enc::base64decode(api_response$data)

    tmp <- tempfile(fileext = ".npy")
    on.exit(unlink(tmp))
    writeBin(decoded_bytes, tmp)

    embeddings <- RcppCNPy::npyLoad(tmp, dotranspose = TRUE)

    return(embeddings)
}
