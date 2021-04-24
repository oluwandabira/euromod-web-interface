percentageChange <- function(original, new, format=TRUE) {
  value <- ((new*100)/original) - 100
  return(value)
}

formatPercentageChange <- function(value) {
  prefix = if (value < 0) "" else "+"
  return(paste(prefix, round(value,2),"%"))
}

getInputFileName <- function(year) {
  case_when(
    year == 2018 ~ "EE_2018_c1.txt",
    year == 2017 ~ "EE_2017_c4.txt",
    year == 2016 ~ "EE_2016_c3.txt",
    year == 2015 ~ "EE_2015_c3.txt",
    TRUE ~ "EE_2018_c1.txt"
  )
}

getSystemName <- function(year) {
  case_when(
    year == 2020 ~ "EE_2020",
    year == 2019 ~ "EE_2019",
    year == 2018 ~ "EE_2018",
    year == 2017 ~ "EE_2017",
    year == 2016 ~ "EE_2016",
    year == 2015 ~ "EE_2015",
    TRUE ~ "EE_2018"
  )
}

getOrigMinWage <- function(year) {
  case_when(
    year == 2020 ~ 584,
    year == 2019 ~ 540,
    year == 2018 ~ 500,
    year == 2017 ~ 470,
    year == 2016 ~ 430,
    year == 2015 ~ 390,
    TRUE ~ 500
  )
}

getOutputFileName <- function(year) {
  return(paste(getSystemName(year),"_std.txt",sep=""))
}
