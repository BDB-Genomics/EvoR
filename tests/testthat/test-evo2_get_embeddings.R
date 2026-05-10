# Test: evo2_get_embeddings
# Uses mock (fake) parsed API response to test embedding decoding

test_that("evo2_get_embeddings extracts data key from response", {
  # Skip if dependencies are not installed
  skip_if_not_installed("base64enc")
  skip_if_not_installed("RcppCNPy")

  # Mock the decoding functions so we don't need real binary data
  mock_raw <- as.raw(c(0x01, 0x02, 0x03))
  
  local_mocked_bindings(
    base64decode = function(what) mock_raw,
    .package = "base64enc"
  )
  
  fake_matrix <- matrix(c(0.1, 0.2, 0.3, 0.4), nrow = 2, ncol = 2)
  
  local_mocked_bindings(
    npyLoad = function(input, ...) fake_matrix,
    .package = "RcppCNPy"
  )
  
  mock_response <- list(
    data = "ZmFrZWRhdGE=",
    elapsed_ms = 200
  )
  
  result <- evo2_get_embeddings(mock_response)
  
  # Check expected behaviour
  expect_true(is.matrix(result))
  expect_equal(nrow(result), 2)
  expect_equal(ncol(result), 2)
  expect_equal(result[1, 1], 0.1)
})
