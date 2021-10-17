
#' Provider for precomputed results
#' @export
ComputedProvider <- R6::R6Class(
  "ComputedProvider",
  public = list(
    get_input_limits = function(){
      values <- unique(income_poverty_taxes_benefits$year) %>%
        purrr::map(~ dplyr::filter(income_poverty_taxes_benefits, year == .x)) %>%
        purrr::map(function(x) {
          mwage <- x$"min wage"
          c(x$year[1], min(mwage), max(mwage))
        })
      
      df <- as.data.frame(do.call(rbind, values))

      names(df) <- c("year", "min", "max")
      
      return(df)
    }
  )
)