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

    #.......................... INPUT VALIDATION ........................................
    
    if (!is.list(api_response) || !("data" %in% names(api_response))) {
        stop("'api_response' must be a list containing a 'data' element (base64-encoded).")
    }

    if (is.null(api_response$data) || !is.character(api_response$data) || !nzchar(api_response$data)) {
        stop("data must non-empty, character strings.")
    }
    
    
    #....................................................................................
    
    #.......................... DECODE EMBEDDINGS .......................................  
      
    decoded_bytes <- base64enc::base64decode(api_response$data)

    tmp <- tempfile(fileext = ".npy")
    on.exit(unlink(tmp))
    writeBin(decoded_bytes, tmp)

    embeddings <- RcppCNPy::npyLoad(tmp, dotranspose = TRUE)
    
    #.....................................................................................
    
    #........................... RETURN OUTPUT ...........................................
    
    embeddings
    
    #.....................................................................................
}




