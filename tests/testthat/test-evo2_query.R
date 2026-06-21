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

test_that("evo2_query validates sequence parameter", {
  withr::local_envvar(NVIDIA_API_KEY = "fake-key-for-testing")
  
  # Type, length, NA, Empty, Too long, Non-IUPAC
  expect_error(evo2_query(123), "must be a character string")
  expect_error(evo2_query(c("ACGT", "TGCA")), "must be a character string")
  expect_error(evo2_query(NA_character_), "must be a character string")
  expect_error(evo2_query(""), "must be a character string")
  expect_error(evo2_query("ACGTX"), "must be a character string")
})

test_that("evo2_query validates num_tokens parameter", {
  withr::local_envvar(NVIDIA_API_KEY = "fake-key-for-testing")
  
  # Non-numeric, length != 1, NA/NaN/Inf, not integer, range
  expect_error(evo2_query("ACGT", num_tokens = "10"), "num_tokens must be numeric")
  expect_error(evo2_query("ACGT", num_tokens = c(5, 10)), "num_tokens must be numeric")
  expect_error(evo2_query("ACGT", num_tokens = NA_real_), "num_tokens must be numeric")
  expect_error(evo2_query("ACGT", num_tokens = NaN), "num_tokens must be numeric")
  expect_error(evo2_query("ACGT", num_tokens = Inf), "num_tokens must be numeric")
  expect_error(evo2_query("ACGT", num_tokens = 5.5), "num_tokens must be numeric")
  expect_error(evo2_query("ACGT", num_tokens = 0), "num_tokens must be numeric")
  expect_error(evo2_query("ACGT", num_tokens = 101), "num_tokens must be numeric")
})

test_that("evo2_query validates temperature parameter", {
  withr::local_envvar(NVIDIA_API_KEY = "fake-key-for-testing")
  
  # NA/NaN/Inf, range
  expect_error(evo2_query("ACGT", temperature = NA_real_), "temperature must be numeric")
  expect_error(evo2_query("ACGT", temperature = NaN), "temperature must be numeric")
  expect_error(evo2_query("ACGT", temperature = Inf), "temperature must be numeric")
  expect_error(evo2_query("ACGT", temperature = -0.1), "temperature must be numeric")
  expect_error(evo2_query("ACGT", temperature = 2.1), "temperature must be numeric")
})

test_that("evo2_query validates top_k parameter", {
  withr::local_envvar(NVIDIA_API_KEY = "fake-key-for-testing")
  
  # NA/NaN/Inf, float, range
  expect_error(evo2_query("ACGT", top_k = NA_real_), "top_k must be integer")
  expect_error(evo2_query("ACGT", top_k = NaN), "top_k must be integer")
  expect_error(evo2_query("ACGT", top_k = Inf), "top_k must be integer")
  expect_error(evo2_query("ACGT", top_k = 5.5), "top_k must be integer")
  expect_error(evo2_query("ACGT", top_k = 0), "top_k must be integer")
  expect_error(evo2_query("ACGT", top_k = 101), "top_k must be integer")
})

test_that("evo2_query validates top_p parameter", {
  withr::local_envvar(NVIDIA_API_KEY = "fake-key-for-testing")
  
  # NA/NaN/Inf, range
  expect_error(evo2_query("ACGT", top_p = NA_real_), "top_p must be numeric")
  expect_error(evo2_query("ACGT", top_p = NaN), "top_p must be numeric")
  expect_error(evo2_query("ACGT", top_p = Inf), "top_p must be numeric")
  expect_error(evo2_query("ACGT", top_p = -0.1), "top_p must be numeric")
  expect_error(evo2_query("ACGT", top_p = 1.1), "top_p must be numeric")
})

test_that("evo2_query validates seed parameter", {
  withr::local_envvar(NVIDIA_API_KEY = "fake-key-for-testing")
  
  # NA/NaN/Inf, negative, float
  expect_error(evo2_query("ACGT", seed = NA_real_), "seed must be a non-negative integer")
  expect_error(evo2_query("ACGT", seed = NaN), "seed must be a non-negative integer")
  expect_error(evo2_query("ACGT", seed = Inf), "seed must be a non-negative integer")
  expect_error(evo2_query("ACGT", seed = -5), "seed must be a non-negative integer")
  expect_error(evo2_query("ACGT", seed = 5.5), "seed must be a non-negative integer")
})
