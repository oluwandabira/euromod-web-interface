
test_that("get_input_limits() returns the proper limits format", {
  provider <- ComputedProvider$new()
  
  actual <- provider$get_input_limits()
  
  expected_names <- c("year", "min", "max")
  
  expect_equal(names(actual), expected_names)
  
  expected_names %>% purrr::map(function(x) expect_type(actual[[x]], "integer"))
})
