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

absolute_poverty_rate <- function(poverty_line, data, household = NULL) {
  # Ratio of people who fall under the poverty line
  if (is.null(household)) {
    total_count <- nrow(data)
    poor_count <- nrow(data[data$eq_dispy <= poverty_line,])
  } else {
    total_count <- nrow(data[data$hh_type == household,])
    poor_count <- nrow(data[data$hh_type == household & data$eq_dispy <= poverty_line,])
  }
  
  return(round((poor_count * 100)/total_count,2))
}

average_wage <- function(data) {
  return(mean(data[data$yem > 0, "yem"]))
}

relative_poverty_line <- function(data) {
  med <- median(data$eq_dispy)
  return((60*med)/100)
}

relative_poverty_rate <- function(poverty_line, data, household = NULL) {
  # Ratio of people whose equivalent disposable income
  # falls under the poverty line
  if (!is.null(household)) {
    total_count <- nrow(data[data$hh_type == household,])
    poor_count <- nrow(data[data$hh_type == household & data$eq_dispy <= poverty_line,])
  } else {
    total_count <- nrow(data)
    poor_count <- nrow(data[data$eq_dispy <= poverty_line,])
  }
  
  return(round((poor_count * 100)/total_count, 2))
}

get_poverty_rows <- function(hh_name, orig_abs_value, orig_rel_value, keyword, data, data_nxt, observables) {
  result <- data.frame("Household" = rep(hh_name, 3), "Scenario"=observables, "AbsolutePoverty" = rep(0,length(observables)), "RelativePoverty"=rep(0,length(observables)))
  
  result[result$Scenario == "orig" ,"AbsolutePoverty"] <- orig_abs_value
  result[result$Scenario == "orig" ,"RelativePoverty"] <- orig_rel_value
  
  # TODO: dynamically for each scenario
  # 2018
  result[result$Scenario == "2018" ,"AbsolutePoverty"] <- absolute_poverty_rate(ABSOLUTE_POVERTY_LINE_2018, data, household=keyword)
  result[result$Scenario == "2018" ,"RelativePoverty"] <- relative_poverty_rate(relative_poverty_line(data), data, household=keyword)
  
  # 2019
  result[result$Scenario == "2019" ,"AbsolutePoverty"] <- absolute_poverty_rate(ABSOLUTE_POVERTY_LINE_2019, data_nxt, household=keyword)
  result[result$Scenario == "2019" ,"RelativePoverty"] <- relative_poverty_rate(relative_poverty_line(data_nxt), data_nxt, household=keyword)
  
  return(result)
} 

poverty_rates_by_hh <- function(data, data_nxt) {
  observables <- c("orig","2018","2019")
  
  single_man_rows <- get_poverty_rows("Üksik mees", ABSOLUTE_POVERTY_RATE_2018_SINGLE_MAN, RELATIVE_POVERTY_RATE_2018_SINGLE_MAN, "single_man", data, data_nxt, observables)
  single_woman_rows <- get_poverty_rows("Üksik naine", ABSOLUTE_POVERTY_RATE_2018_SINGLE_WOMAN, RELATIVE_POVERTY_RATE_2018_SINGLE_WOMAN, "single_woman", data, data_nxt, observables)
  single_parent_rows <- get_poverty_rows("Üksikvanem", ABSOLUTE_POVERTY_RATE_2018_SINGLE_PARENT, RELATIVE_POVERTY_RATE_2018_SINGLE_PARENT, "single_parent", data, data_nxt, observables)
  couple_no_children_rows <- get_poverty_rows("Lasteta paar", ABSOLUTE_POVERTY_RATE_2018_CHILDLESS_COUPLE, RELATIVE_POVERTY_RATE_2018_CHILDLESS_COUPLE, "couple_no_children", data, data_nxt, observables)
  couple_one_child_rows <- get_poverty_rows("Ühe lapsega paar", ABSOLUTE_POVERTY_RATE_2018_COUPLE_ONE_CHILD, RELATIVE_POVERTY_RATE_2018_COUPLE_ONE_CHILD, "couple_one_child", data, data_nxt, observables)
  couple_two_children_rows <- get_poverty_rows("Kahe lapsega paar", ABSOLUTE_POVERTY_RATE_2018_COUPLE_TWO_CHILDREN, RELATIVE_POVERTY_RATE_2018_COUPLE_TWO_CHILDREN, "couple_two_children", data, data_nxt, observables)
  couple_many_children_rows <- get_poverty_rows("Kolme ja enama lapsega paar", ABSOLUTE_POVERTY_RATE_2018_COUPLE_MANY_CHILDREN, RELATIVE_POVERTY_RATE_2018_COUPLE_MANY_CHILDREN, "couple_many_children", data, data_nxt, observables)
  
  result <- rbind(single_man_rows, single_woman_rows, single_parent_rows, couple_no_children_rows, couple_one_child_rows, couple_two_children_rows, couple_many_children_rows)
  result$Scenario <- factor(result$Scenario,levels = observables, labels = c("Tegelik 2018","Ennustatud 2018","Ennustatud 2019"), ordered = TRUE)
  
  return(result)
}

