library(dplyr)

greenArrowDown <- function() {
  tags$i(
    id = "actualValue",
    class = "fa fa-arrow-down", 
    style = "color: rgb(0,166,90)"
  )
}

# Adds a column to the data depicting the equivalized disposable income
addEquivalizedIncome <- function(data) {
  data$ils_dispy <- as.numeric(sub(",",".",data$ils_dispy, fixed=TRUE))
  data$dag <- as.numeric(sub(",",".",data$dag, fixed=TRUE))
  
  # OECD levels
  first_adult <- 1
  next_adult <- 0.7
  child <- 0.5
  child_age <- 14
  data$oecd_weight <- ifelse(data$idperson == data$tu_sapehh_ee_HeadID, first_adult, ifelse(data$dag >= child_age, 0.7, 0.5))
  
  by_hh <- data %>% group_by(idhh)
  total_income <- by_hh %>% summarise(
    total_dispy = sum(ils_dispy),
    total_weight = sum(oecd_weight),
    eq_dispy = total_dispy/total_weight,
  )
  data <- left_join(data, total_income, by="idhh")
  
  return(data)
}