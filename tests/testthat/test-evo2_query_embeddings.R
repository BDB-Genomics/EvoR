# Test: evo2_query_embeddings
# Mock the API call and verify the function builds the correct request for /forward

test_that("evo2_query_embeddings stops when no API key is set", {
  withr::local_envvar(NVIDIA_API_KEY = "")
  
  expect_error(
    evo2_query_embeddings("ACGT"),
    "API key not found"
  )
})

test_that("evo2_query_embeddings uses correct default layer", {
  local_mocked_bindings(
    req_perform = function(...) {
      structure(list(
        body = charToRaw('{"data":"ZmFrZWRhdGE=","elapsed_ms":200}'),
        headers = list("content-type" = "application/json"),
        status_code = 200L
      ), class = "httr2_response")
    },
    resp_body_json = function(...) {
      list(
        data = "ZmFrZWRhdGE=",
        elapsed_ms = 200
      )
    },
    .package = "httr2"
  )
  
  withr::local_envvar(NVIDIA_API_KEY = "fake-key-for-testing")
  
  result <- evo2_query_embeddings("ACGT")
  
  expect_type(result, "list")
  expect_true("data" %in% names(result))
  expect_equal(result$target_layer, "blocks.28.mlp.l3")
})

test_that("evo2_query_embeddings accepts custom layer", {
  local_mocked_bindings(
    req_perform = function(...) {
      structure(list(
        body = charToRaw('{"data":"ZmFrZWRhdGE=","elapsed_ms":200}'),
        headers = list("content-type" = "application/json"),
        status_code = 200L
      ), class = "httr2_response")
    },
    resp_body_json = function(...) {
      list(
        data = "ZmFrZWRhdGE=",
        elapsed_ms = 200
      )
    },
    .package = "httr2"
  )
  
  withr::local_envvar(NVIDIA_API_KEY = "fake-key-for-testing")
  
  result <- evo2_query_embeddings("ACGT", layer = "decoder.final_norm")
  
  expect_equal(result$target_layer, "decoder.final_norm")
})
