# Test: evo2_get_score
# Uses mock (fake) parsed API response to test score extraction

test_that("evo2_get_score returns sampled_probs from parsed response", {
  # 1. Create mock (fake) parsed API response
  mock_response <- list(
    sequence = "ACGTTTTT",
    sampled_probs = c(0.98, 0.95, 0.99, 0.87, 0.92, 0.88, 0.91, 0.94),
    elapsed_ms = 150
  )
  
  # 2. Call the function with fake data
  scores <- evo2_get_score(mock_response)
  
  # 3. Check expected behaviour

  expect_type(scores, "double")
  expect_length(scores, 8)
  expect_equal(scores[1], 0.98)
  expect_true(all(scores >= 0 & scores <= 1))
})

test_that("evo2_get_score returns NULL when sampled_probs is missing", {
  # Mock response without sampled_probs
  mock_response <- list(
    sequence = "ACGTTTTT",
    elapsed_ms = 150
  )
  
  scores <- evo2_get_score(mock_response)
  
  expect_null(scores)
})
