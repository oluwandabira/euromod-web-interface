# Calculate pay gap values from
# EUROMOD output files

rm(list=ls())

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
  #cat(sort(monthly_men))
  cat(length(monthly_men[monthly_men <= 500]))
  cat("\n")

  pay_gap <- (avg_monthly_men - avg_monthly_women)/avg_monthly_men * 100
  return(pay_gap)
}

# Helper function to find disposable income gap
disposable_income_gap <- function(data) {
  # Disposable income: ils_dispy
  data$ils_dispy <- as.numeric(sub(",",".",data$ils_dispy, fixed=TRUE))
  
  disp_men <- data[data[,"ils_dispy"] > 0 & data[,"dgn"]==1, "ils_dispy"]
  disp_women <- data[data[,"ils_dispy"] > 0 & data[,"dgn"]==0, "ils_dispy"]
  
  avg_disp_men <- mean(disp_men)
  avg_disp_women <- mean(disp_women)
  
  pay_gap <- (avg_disp_men - avg_disp_women)/avg_disp_men * 100
  return(pay_gap)
}


print_results <- function(title, data) {
  cat(title, "hourly pay gap:", hourly_gross_pay_gap(data), "\n")
  cat(title, "hourly pay gap for full time workers:", hourly_gross_pay_gap_ft(data), "\n")
  cat(title, "monthly pay gap:", monthly_gross_pay_gap(data), "\n")
  cat(title, "monthly pay gap for full time workers:", monthly_gross_pay_gap_ft(data), "\n")
  cat(title, "disposable income gap:", disposable_income_gap(data), "\n")
}
