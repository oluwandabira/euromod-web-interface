# test_that("mod_input_panel_server works?", {
#   expect_equal(2 * 2, 4)
# })

testServer(mod_input_panel_server,{
    session$setInputs(year = 2018, min_wage = 600)
  
    #expect_equal()
  })
