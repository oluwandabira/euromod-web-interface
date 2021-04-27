library(tidyr)

source("translate.R")

# Calculate pay gap values from
# EUROMOD output files

# Helper function to find pay gap of gross hourly wage
hourly_gross_pay_gap <- function(data) {
  # Gross hourly wage: yivwg
  #data <- read.csv(file=paste("euromod/EUROMOD_WEB/output/","EE_2018_std.txt", sep=""), header=TRUE, sep="\t", stringsAsFactors = TRUE)
  
  data$yivwg <- as.numeric(sub(",",".",data$yivwg, fixed=TRUE))
  data$dwt <- as.numeric(sub(",",".",data$dwt, fixed=TRUE))
  data$dag <- as.numeric(sub(",",".",data$dag, fixed=TRUE))
  
  #hourly_men <- data[data[,"liwftmy"] > 0 & (data[,"liwftmy"]==data[,"liwmy"]) & data[,"dgn"]==1, c("yivwg", "dwt")]
  #hourly_women <- data[data[,"liwftmy"] > 0 & (data[,"liwftmy"]==data[,"liwmy"]) & data[,"dgn"]==0, c("yivwg", "dwt")]
  hourly_men <- data[data$lhw > 0 & data[,"yivwg"] > 0 & data[,"dgn"]==1, c("yivwg", "dwt")]
  hourly_women <- data[data$lhw > 0 & data[,"yivwg"] > 0 & data[,"dgn"]==0, c("yivwg", "dwt")]
  # data$dag >= 18 & data$dag < 65 & data[,"liwftmy"] == 12 & 
  avg_hourly_men <- weighted.mean(hourly_men$yivwg, hourly_men$dwt)
  avg_hourly_women <- weighted.mean(hourly_women$yivwg, hourly_women$dwt)
  #avg_hourly_men <- mean(hourly_men$yivwg)
  #avg_hourly_women <- mean(hourly_women$yivwg)
  
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
  data$dwt <- as.numeric(sub(",",".",data$dwt, fixed=TRUE))
  
  monthly_men <- data[data[,"yem"] > 0 & data[,"dgn"]==1, c("yem", "dwt")]
  monthly_women <- data[data[,"yem"] > 0 & data[,"dgn"]==0, c("yem", "dwt")]
  
  avg_monthly_men <- weighted.mean(monthly_men$yem, monthly_men$dwt)
  avg_monthly_women <- weighted.mean(monthly_women$yem, monthly_women$dwt)
  
  pay_gap <- (avg_monthly_men - avg_monthly_women)/avg_monthly_men * 100
  return(pay_gap)
}

# Filter out full time workers
monthly_gross_pay_gap_ft <- function(data) {
  # Gross monthly wage: yem
  data$yem <- as.numeric(sub(",",".",data$yem, fixed=TRUE))
  data$dwt <- as.numeric(sub(",",".",data$dwt, fixed=TRUE))

  monthly_men <- data[data[,"liwftmy"] > 0 & data[,"liwftmy"]==data[,"liwmy"] & data[,"yem"] > 0 & data[,"dgn"]==1, c("yem", "dwt")]
  monthly_women <- data[data[,"liwftmy"] > 0 & data[,"liwftmy"]==data[,"liwmy"] & data[,"yem"] > 0 & data[,"dgn"]==0, c("yem", "dwt")]
  
  avg_monthly_men <- weighted.mean(monthly_men$yem, monthly_men$dwt)
  avg_monthly_women <- weighted.mean(monthly_women$yem, monthly_women$dwt)

  pay_gap <- (avg_monthly_men - avg_monthly_women)/avg_monthly_men * 100
  return(pay_gap)
}

# Helper function to find disposable income gap
disposable_income_gap <- function(data) {
  # Disposable income: ils_dispy for registers, yds for EU-SILC
  data$ils_dispy <- as.numeric(sub(",",".",data$ils_dispy, fixed=TRUE))
  data$dwt <- as.numeric(sub(",",".",data$dwt, fixed=TRUE))
  
  disp_men <- data[data[,"ils_dispy"] > 0 & data[,"dgn"]==1, c("ils_dispy", "dwt")]
  disp_women <- data[data[,"ils_dispy"] > 0 & data[,"dgn"]==0, c("ils_dispy", "dwt")]
  
  avg_disp_men <- weighted.mean(disp_men$ils_dispy, disp_men$dwt)
  avg_disp_women <- weighted.mean(disp_women$ils_dispy, disp_women$dwt)
  
  pay_gap <- (avg_disp_men - avg_disp_women)/avg_disp_men * 100
  return(pay_gap)
}

# Helper function to find disposable income gap
equivalized_disposable_income_gap <- function(data) {
  # Disposable income: ils_dispy for registers, yds for EU-SILC
  # variable <- "ydses_o"
  variable <- eq_dispy
  data[,variable] <- as.numeric(sub(",",".",data[,variable], fixed=TRUE))
  data$dwt <- as.numeric(sub(",",".",data$dwt, fixed=TRUE))
  
  disp_men <- data[data[,variable] > 0 & data[,"dgn"]==1, c(variable, "dwt")]
  disp_women <- data[data[,variable] > 0 & data[,"dgn"]==0, c(variable, "dwt")]
  
  avg_disp_men <- weighted.mean(disp_men[,variable], disp_men$dwt)
  avg_disp_women <- weighted.mean(disp_women[,variable], disp_men$dwt)
  
  pay_gap <- (avg_disp_men - avg_disp_women)/avg_disp_men * 100
  return(pay_gap)
}

# Helper function to find disposable income gap for full-time workers
disposable_income_gap_ft <- function(data) {
  # Disposable income: ils_dispy
  data$ils_dispy <- as.numeric(sub(",",".",data$ils_dispy, fixed=TRUE))
  data$dwt <- as.numeric(sub(",",".",data$dwt, fixed=TRUE))
  
  disp_men <- data[data[,"liwftmy"] > 0 & data[,"liwftmy"]==data[,"liwmy"] & data[,"ils_dispy"] > 0 & data[,"dgn"]==1, c("ils_dispy", "dwt")]
  disp_women <- data[data[,"liwftmy"] > 0 & data[,"liwftmy"]==data[,"liwmy"] & data[,"ils_dispy"] > 0 & data[,"dgn"]==0, c("ils_dispy", "dwt")]
  
  avg_disp_men <- weighted.mean(disp_men$ils_dispy, disp_men$dwt)
  avg_disp_women <- weighted.mean(disp_women$ils_dispy, disp_women$dwt)
  
  pay_gap <- (avg_disp_men - avg_disp_women)/avg_disp_men * 100
  return(pay_gap)
}

absolute_poverty_rate <- function(poverty_line, data, household = NULL) {
  data$dwt <- as.numeric(sub(",",".",data$dwt, fixed=TRUE))
  
  # Ratio of people who fall under the poverty line
  if (is.null(household)) {
    total_weight <- sum(data$dwt)
    poor_weight <- sum(data[data$eq_dispy <= poverty_line,"dwt"])
  } else {
    total_weight <- sum(data[data$hh_type == household, "dwt"])
    poor_weight <- sum(data[data$hh_type == household & data$eq_dispy <= poverty_line, "dwt"])
  }
  
  return(round((poor_weight * 100)/total_weight,2))
}

average_wage <- function(data) {
  positive_income <- data[data$yem > 0, ]
  return(weighted.mean(positive_income$yem,positive_income$dwt))
}

relative_poverty_line <- function(data) {
  med <- median(rep(data$eq_dispy, times=data$dwt))
  return((60*med)/100)
}

relative_poverty_rate <- function(poverty_line, data, household = NULL) {
  # Ratio of people whose equivalent disposable income
  # falls under the poverty line
  data$dwt <- as.numeric(sub(",",".",data$dwt, fixed=TRUE))
  
  if (!is.null(household)) {
    total_weight <- sum(data[data$hh_type == household,"dwt"])
    poor_weight <- sum(data[data$hh_type == household & data$eq_dispy <= poverty_line,"dwt"])
  } else {
    total_weight <- sum(data$dwt)
    poor_weight <- sum(data[data$eq_dispy <= poverty_line,"dwt"])
  }
  
  return(round((poor_weight * 100)/total_weight, 2))
}

in_work_poverty_rate <- function(poverty_line, data) {
  # Ratio of people who are employed and whose equivalent disposable income
  # falls under the poverty line
  data$dwt <- as.numeric(sub(",",".",data$dwt, fixed=TRUE))
  data$liwmy <- as.numeric(sub(",",".",data$liwmy, fixed=TRUE))
  
  total_weight <- sum(data[data$liwmy > 0 ,"dwt"])
  poor_weight <- sum(data[data$liwmy > 0 & data$eq_dispy <= poverty_line,"dwt"])

  return(round((poor_weight * 100)/total_weight, 2))
}

get_poverty_rows <- function(hh_name, orig_abs_value, orig_rel_value, keyword, data, observables, relative_poverty_line) {
  result <- data.frame("Household" = rep(hh_name, 2), "Scenario"=observables, "AbsolutePoverty" = rep(0,length(observables)), "RelativePoverty"=rep(0,length(observables)))
  
  result[result$Scenario == "orig" ,"AbsolutePoverty"] <- orig_abs_value
  result[result$Scenario == "orig" ,"RelativePoverty"] <- orig_rel_value
  
  # TODO: dynamically for each scenario
  # 2018
  result[result$Scenario == "2018" ,"AbsolutePoverty"] <- absolute_poverty_rate(ABSOLUTE_POVERTY_LINE, data, household=keyword)
  result[result$Scenario == "2018" ,"RelativePoverty"] <- relative_poverty_rate(relative_poverty_line, data, household=keyword)

  return(result)
} 

poverty_rates_by_hh <- function(data, relative_poverty_line, i18n) {
  observables <- c("orig","2018")

  single_man_rows <- get_poverty_rows(i18n$t("Üksik mees"), ABSOLUTE_POVERTY_RATE_SINGLE_MAN, RELATIVE_POVERTY_RATE_SINGLE_MAN, "single_man", data, observables, relative_poverty_line)
  single_woman_rows <- get_poverty_rows(i18n$t("Üksik naine"), ABSOLUTE_POVERTY_RATE_SINGLE_WOMAN, RELATIVE_POVERTY_RATE_SINGLE_WOMAN, "single_woman", data, observables, relative_poverty_line)
  single_parent_rows <- get_poverty_rows(i18n$t("Üksikvanem"), ABSOLUTE_POVERTY_RATE_SINGLE_PARENT, RELATIVE_POVERTY_RATE_SINGLE_PARENT, "single_parent", data, observables, relative_poverty_line)
  couple_no_children_rows <- get_poverty_rows(i18n$t("Lasteta paar"), ABSOLUTE_POVERTY_RATE_CHILDLESS_COUPLE, RELATIVE_POVERTY_RATE_CHILDLESS_COUPLE, "couple_no_children", data, observables, relative_poverty_line)
  couple_one_child_rows <- get_poverty_rows(i18n$t("Ühe lapsega paar"), ABSOLUTE_POVERTY_RATE_COUPLE_ONE_CHILD, RELATIVE_POVERTY_RATE_COUPLE_ONE_CHILD, "couple_one_child", data, observables, relative_poverty_line)
  couple_two_children_rows <- get_poverty_rows(i18n$t("Kahe lapsega paar"), ABSOLUTE_POVERTY_RATE_COUPLE_TWO_CHILDREN, RELATIVE_POVERTY_RATE_COUPLE_TWO_CHILDREN, "couple_two_children", data, observables, relative_poverty_line)
  couple_many_children_rows <- get_poverty_rows(i18n$t("Kolme ja enama lapsega paar"), ABSOLUTE_POVERTY_RATE_COUPLE_MANY_CHILDREN, RELATIVE_POVERTY_RATE_COUPLE_MANY_CHILDREN, "couple_many_children", data, observables, relative_poverty_line)
  
  # single_man_rows <- get_poverty_rows(i18n$t("Üksik mees"), ABSOLUTE_POVERTY_RATE_2018_SINGLE_MAN, RELATIVE_POVERTY_RATE_2018_SINGLE_MAN, "single_man", data, observables, relative_poverty_line)
  # single_woman_rows <- get_poverty_rows(i18n$t("Üksik naine"), ABSOLUTE_POVERTY_RATE_2018_SINGLE_WOMAN, RELATIVE_POVERTY_RATE_2018_SINGLE_WOMAN, "single_woman", data, observables, relative_poverty_line)
  # single_parent_rows <- get_poverty_rows(i18n$t("Üksikvanem"), ABSOLUTE_POVERTY_RATE_2018_SINGLE_PARENT, RELATIVE_POVERTY_RATE_2018_SINGLE_PARENT, "single_parent", data, observables, relative_poverty_line)
  # couple_no_children_rows <- get_poverty_rows(i18n$t("Lasteta paar"), ABSOLUTE_POVERTY_RATE_2018_CHILDLESS_COUPLE, RELATIVE_POVERTY_RATE_2018_CHILDLESS_COUPLE, "couple_no_children", data, observables, relative_poverty_line)
  # couple_one_child_rows <- get_poverty_rows(i18n$t("Ühe lapsega paar"), ABSOLUTE_POVERTY_RATE_2018_COUPLE_ONE_CHILD, RELATIVE_POVERTY_RATE_2018_COUPLE_ONE_CHILD, "couple_one_child", data, observables, relative_poverty_line)
  # couple_two_children_rows <- get_poverty_rows(i18n$t("Kahe lapsega paar"), ABSOLUTE_POVERTY_RATE_2018_COUPLE_TWO_CHILDREN, RELATIVE_POVERTY_RATE_2018_COUPLE_TWO_CHILDREN, "couple_two_children", data, observables, relative_poverty_line)
  # couple_many_children_rows <- get_poverty_rows(i18n$t("Kolme ja enama lapsega paar"), ABSOLUTE_POVERTY_RATE_2018_COUPLE_MANY_CHILDREN, RELATIVE_POVERTY_RATE_2018_COUPLE_MANY_CHILDREN, "couple_many_children", data, observables, relative_poverty_line)
  # 
  result <- rbind(single_man_rows, single_woman_rows, single_parent_rows, couple_no_children_rows, couple_one_child_rows, couple_two_children_rows, couple_many_children_rows)
  result$Scenario <- factor(result$Scenario,levels = observables, labels = c(paste(i18n$t("Tegelik"), "2018"),paste(i18n$t("Ennustatud"), "2018")), ordered = TRUE)
  
  return(result)
}

get_social_taxes_paid <- function(data) {
  # EUROMOD calculated variables:
  # ils_sicot - SIC paid by individuals rather than employees
  # ils_sicee - employee SIC
  # ils_sicse - self-employed SIC
  # ils_sicer - employer SIC
  # ils_sicct - credited SIC
  result <- 0
  data$dwt <- as.numeric(sub(",",".",data$dwt, fixed=TRUE))
  
  for (col in c("ils_sicot", "ils_sicee", "ils_sicse", "ils_sicer", "ils_sicct")) {
    data[,col] <- as.numeric(sub(",",".",data[,col], fixed=TRUE))
    weighted <- data[,col]*data$dwt
    result <- result + sum(weighted)
    
  }
 return(result)
}

get_income_taxes_paid <- function(data) {
  # EUROMOD calculated variables:
  # ils_taxsim - income tax
  data$ils_taxsim <- as.numeric(sub(",",".",data$ils_taxsim, fixed=TRUE))
  data$dwt <- as.numeric(sub(",",".",data$dwt, fixed=TRUE))
  weighted <- data$ils_taxsim*data$dwt
  return(sum(weighted))
}

get_subsistence_benefit_received <- function(data) {
  # EUROMOD calculated variables:
  # bsa00_s
  data$bsa00_s <- as.numeric(sub(",",".",data$bsa00_s, fixed=TRUE))
  data$dwt <- as.numeric(sub(",",".",data$dwt, fixed=TRUE))
  weighted <- data$bsa00_s*data$dwt
  return(sum(weighted))
  
}

get_benefits_received <- function(data) {
  # EUROMOD calculated variables:
  # ils_ben
  data$ils_ben <- as.numeric(sub(",",".",data$ils_ben, fixed=TRUE))
  data$dwt <- as.numeric(sub(",",".",data$dwt, fixed=TRUE))
  weighted <- data$ils_ben*data$dwt
  return(sum(weighted))
  
}


