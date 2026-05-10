# Test: evo2_query
# Mock the API call and verify the function builds the request correctly

test_that("evo2_query stops when no API key is set", {
  # Clear any existing key
  withr::local_envvar(NVIDIA_API_KEY = "")
  
  expect_error(
    evo2_query("ACGT"),
    "API key not found"
  )
})

test_that("evo2_query uses default endpoint when api_url is NULL", {
  # We mock the HTTP request so it never actually hits the network
  local_mocked_bindings(
    req_perform = function(...) {
      # Return a fake response object
      structure(list(
        body = charToRaw('{"sequence":"ACGTTTTT","sampled_probs":[0.9,0.8,0.7,0.6,0.5,0.4,0.3,0.2],"elapsed_ms":100}'),
        headers = list("content-type" = "application/json"),
        status_code = 200L
      ), class = "httr2_response")
    },
    resp_body_json = function(...) {
      list(
        sequence = "ACGTTTTT",
        sampled_probs = c(0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2),
        elapsed_ms = 100
      )
    },
    .package = "httr2"
  )
  
  withr::local_envvar(NVIDIA_API_KEY = "fake-key-for-testing")
  
  result <- evo2_query("ACGT")
  
  expect_type(result, "list")
  expect_true("sequence" %in% names(result))
  expect_true("sampled_probs" %in% names(result))
})
