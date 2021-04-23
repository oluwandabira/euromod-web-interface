percentageChange <- function(original, new, format=TRUE) {
  value <- ((new*100)/original) - 100
  return(value)
}

formatPercentageChange <- function(value) {
  prefix = if (value < 0) "" else "+"
  return(paste(prefix, round(value,2),"%"))
}


