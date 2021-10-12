ComputedProvider <- R6Class(
  "ComputedProvider",
  public = list(
    initialize = function(){
      
    },
    get_input_limits = function(){
      
      return(list(
        2018 = c(500, 100)
      ))
    }
  )
)