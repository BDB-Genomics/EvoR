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

test_that("evo2_get_score errors when sampled_probs is missing", {
  # Mock response without sampled_probs
  mock_response <- list(
    sequence = "ACGTTTTT",
    elapsed_ms = 150
  )
  
  expect_error(
    evo2_get_score(mock_response),
    "sampled_probs"
  )
})

test_that("evo2_get_score errors when sampled_probs is NULL", {
  mock_response <- list(
    sequence = "ACGTTTTT",
    sampled_probs = NULL,
    elapsed_ms = 150
  )

  expect_error(
    evo2_get_score(mock_response),
    "sampled_probs is NULL"
  )
})

test_that("evo2_get_score errors when sampled_probs is non-numeric", {
  mock_response <- list(
    sequence = "ACGTTTTT", 
    sampled_probs = c("a", "b"),
    elapsed_ms = 150
  )
  
  expect_error(
    evo2_get_score(mock_response), 
    "must be numeric"
    )
})   

test_that("evo2_get_score errors when sampled_probs contains NA or NaN", {
  mock_response_na <- list(
    sequence = "ACGTTTTT", 
    sampled_probs = c(0.9, NA, 0.8), 
    elapsed_ms = 150
  )
    
  mock_response_nan <- list(
    sequence = "AGTTTTT", 
    sampled_probs = c(0.9, NaN, 0.9), 
    elapsed_ms = 150
  )
    
  expect_error(
    evo2_get_score(mock_response_na), 
    "must be numeric"
  )   
  expect_error(
    evo2_get_score(mock_response_nan), 
    "must be numeric"
  )   
})

test_that("evo2_get_score errors when sampled_probs is empty", {
  mock_response <- list(
    sequence = "ACGTTTTT",
    sampled_probs = numeric(0),
    elapsed_ms = 150
  )
  expect_error(
    evo2_get_score(mock_response),
    "must be numeric"
  )
})

test_that("evo2_get_score errors when sampled_probs contains Inf or -Inf", {
  mock_response_inf <- list(
    sequence = "ACGTTTTT",
    sampled_probs = c(0.9, Inf, 0.8),
    elapsed_ms = 150
  )
  mock_response_neginf <- list(
    sequence = "ACGTTTTT",
    sampled_probs = c(0.9, -Inf, 0.8),
    elapsed_ms = 150
  )
  expect_error(
    evo2_get_score(mock_response_inf),
    "must be numeric"
  )
  expect_error(
    evo2_get_score(mock_response_neginf),
    "must be numeric"
  )
})

