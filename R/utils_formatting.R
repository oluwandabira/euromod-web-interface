format_money <- function(value) {
  formatC(value, big.mark = ",", format = "d")
}


format_change <- function(value) {
  value <- round(value, 2)
  prefix <- if (value <= 0) "" else "+"
  return(sprintf("%s%s", prefix, value))
}
