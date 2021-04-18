library(tidyr)

# Calculate pay gap values from
# EUROMOD output files

# Helper function to find pay gap of gross hourly wage
hourly_gross_pay_gap <- function(data) {
  # Gross hourly wage: yivwg
  data$yivwg <- as.numeric(sub(",",".",data$yivwg, fixed=TRUE))
  
  hourly_men <- data[data[,"yivwg"] > 0 & data[,"dgn"]==1, "yivwg"]
  hourly_women <- data[data[,"yivwg"] > 0 & data[,"dgn"]==0, "yivwg"]
  
  avg_hourly_men <- mean(hourly_men)
  avg_hourly_women <- mean(hourly_women)
  
  pay_gap <- (avg_hourly_men - avg_hourly_women)/avg_hourly_men * 100
  return(pay_gap)
}

# Filter out full time workers
hourly_gross_pay_gap_ft <- function(data) {
  # Gross hourly wage: yivwg
  data$yivwg <- as.numeric(sub(",",".",data$yivwg, fixed=TRUE))
  
  hourly_men <- data[data[,"liwftmy"] > 0 & (data[,"liwftmy"]==data[,"liwmy"]) & data[,"yivwg"] > 0 & data[,"dgn"]==1, "yivwg"]
  hourly_women <- data[data[,"liwftmy"] > 0 & (data[,"liwftmy"]==data[,"liwmy"]) & data[,"yivwg"] > 0 & data[,"dgn"]==0, "yivwg"]


  avg_hourly_men <- mean(hourly_men)
  avg_hourly_women <- mean(hourly_women)
  
  pay_gap <- ((avg_hourly_men - avg_hourly_women)/avg_hourly_men) * 100
  return(pay_gap)
}

# Helper function to find pay gap of gross monthly wage
monthly_gross_pay_gap <- function(data) {
  # Gross monthly wage: yem
  data$yem <- as.numeric(sub(",",".",data$yem, fixed=TRUE))
  
  monthly_men <- data[data[,"yem"] > 0 & data[,"dgn"]==1, "yem"]
  monthly_women <- data[data[,"yem"] > 0 & data[,"dgn"]==0, "yem"]
  
  avg_monthly_men <- mean(monthly_men)
  avg_monthly_women <- mean(monthly_women)
  
  pay_gap <- (avg_monthly_men - avg_monthly_women)/avg_monthly_men * 100
  return(pay_gap)
}

# Filter out full time workers
monthly_gross_pay_gap_ft <- function(data) {
  # Gross monthly wage: yem
  data$yem <- as.numeric(sub(",",".",data$yem, fixed=TRUE))
  
  monthly_men <- data[data[,"liwftmy"] > 0 & data[,"liwftmy"]==data[,"liwmy"] & data[,"yem"] > 0 & data[,"dgn"]==1, "yem"]
  monthly_women <- data[data[,"liwftmy"] > 0 & data[,"liwftmy"]==data[,"liwmy"] & data[,"yem"] > 0 & data[,"dgn"]==0, "yem"]
  
  avg_monthly_men <- mean(monthly_men)
  avg_monthly_women <- mean(monthly_women)

  pay_gap <- (avg_monthly_men - avg_monthly_women)/avg_monthly_men * 100
  return(pay_gap)
}

# Helper function to find disposable income gap
disposable_income_gap <- function(data) {
  # Disposable income: ils_dispy for registers, yds for EU-SILC
  data$ils_dispy <- as.numeric(sub(",",".",data$ils_dispy, fixed=TRUE))
  
  disp_men <- data[data[,"ils_dispy"] > 0 & data[,"dgn"]==1, "ils_dispy"]
  disp_women <- data[data[,"ils_dispy"] > 0 & data[,"dgn"]==0, "ils_dispy"]
  
  avg_disp_men <- mean(disp_men)
  avg_disp_women <- mean(disp_women)
  
  pay_gap <- (avg_disp_men - avg_disp_women)/avg_disp_men * 100
  return(pay_gap)
}

# Helper function to find disposable income gap
equivalized_disposable_income_gap <- function(data) {
  # Disposable income: ils_dispy for registers, yds for EU-SILC
  variable <- "ydses_o"
  data[,variable] <- as.numeric(sub(",",".",data[,variable], fixed=TRUE))
  
  disp_men <- data[data[,variable] > 0 & data[,"dgn"]==1, variable]
  disp_women <- data[data[,variable] > 0 & data[,"dgn"]==0, variable]
  
  avg_disp_men <- mean(disp_men)
  avg_disp_women <- mean(disp_women)
  
  pay_gap <- (avg_disp_men - avg_disp_women)/avg_disp_men * 100
  return(pay_gap)
}

# Helper function to find disposable income gap for full-time workers
disposable_income_gap_ft <- function(data) {
  # Disposable income: ils_dispy
  data$ils_dispy <- as.numeric(sub(",",".",data$ils_dispy, fixed=TRUE))
  
  disp_men <- data[data[,"liwftmy"] > 0 & data[,"liwftmy"]==data[,"liwmy"] & data[,"ils_dispy"] > 0 & data[,"dgn"]==1, "ils_dispy"]
  disp_women <- data[data[,"liwftmy"] > 0 & data[,"liwftmy"]==data[,"liwmy"] & data[,"ils_dispy"] > 0 & data[,"dgn"]==0, "ils_dispy"]
  
  avg_disp_men <- mean(disp_men)
  avg_disp_women <- mean(disp_women)
  
  pay_gap <- (avg_disp_men - avg_disp_women)/avg_disp_men * 100
  return(pay_gap)
}

absolute_poverty_rate <- function(poverty_line, data) {
  # Ratio of people who fall under the poverty line
  total_count <- nrow(data)
  poor_count <- nrow(data[data$eq_dispy <= poverty_line,])
  
  return((poor_count * 100)/total_count)
}

average_wage <- function(data) {
  return(mean(data[data$yem > 0, "yem"]))
}

relative_poverty_line <- function(data) {
  med <- median(data$eq_dispy)
  return((60*med)/100)
}

relative_poverty_rate <- function(poverty_line, data) {
  # Ratio of people whose equivalent disposable income
  # falls under the poverty line
  total_count <- nrow(data)
  poor_count <- nrow(data[data$eq_dispy <= poverty_line,])
  
  return((poor_count * 100)/total_count)
}

absolute_poverty_rate_by_hh <- function(poverty_line, data) {
  # Ratio of people who fall under the poverty line
  household_types <- c("Üksik mees", "Üksik naine", "Üksikvanem", "Ühe lapsega paar")
  obervables <- c("orig","2018","2019")
  
  household_types_rep <- unlist(lapply(household_types, function(x) rep(x, length(observables))))
  observables_rep <- unlist(lapply(observables, function(x) rep(x, length(household_types))))
  hh_poverty_rates <- data.frame("Leibkond"=household_types, "AbsolutePoverty" = rep(0,length(household_types)), "RelativePoverty"=rep(0,length(household_types)))
  
  total_count <- nrow(data)
  poor_count <- nrow(data[data$eq_dispy <= poverty_line,])
  
  return((poor_count * 100)/total_count)
}

