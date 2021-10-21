
#' Provider for precomputed results
#' @export
#' @importFrom dplyr %>%
ComputedProvider <- R6::R6Class(
  "ComputedProvider",
  public = list(
    get_input_limits = function(){
      values <- unique(income_poverty_taxes_benefits$year) %>%
        purrr::map( ~ dplyr::filter(income_poverty_taxes_benefits, year == .x)) %>%
        purrr::map(function(x) {
          mwage <- x$"min wage"
          c(x$year[1], min(mwage), max(mwage))
        })
      
      df <- as.data.frame(do.call(rbind, values))
      
      names(df) <- c("year", "min", "max")
      
      return(df)
    },
    
    compute = function(year, min_wage) {
      
      computed <-
        dplyr::filter(
          income_poverty_taxes_benefits,
          .data$year == .env$year,
          .data$"min wage" == .env$min_wage
        )
      
      hh <-
        dplyr::filter(household_poverty,
                      .data$year == .env$year,
                      .data$"min wage" == .env$min_wage)
      
      orig <- dplyr::filter(original, .data$year == .env$year)
      
      return(list(
        "computed" = computed,
        "original" = orig,
        "household" = hh
      ))
    }
  )
)