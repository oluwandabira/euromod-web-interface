# Creating new input files for EUROMOD
# for new minimum wage values
# working with monthly wages

#rm(list=ls())

create_input_data <- function(minwage, euromod_data) {
  actual_minwage <- 540 # necessary for determining the lower limit
  
  scenario_data <- data.frame(euromod_data)
  scenario_data$yem00 <- ifelse(scenario_data[,"liwftmy"] > 0 & scenario_data[,"liwftmy"]==scenario_data[,"liwmy"] & scenario_data[, "yem00"] <= minwage*1.05 & scenario_data[,"yem00"]>=actual_minwage*0.8, minwage, scenario_data[, "yem00"])
  scenario_data$yem <- scenario_data$yem00 + scenario_data$yemabtx + scenario_data$yemabnt
  scenario_data$yivwg <- ifelse(scenario_data[,"liwftmy"] > 0 & scenario_data[,"liwftmy"]==scenario_data[,"liwmy"] & scenario_data[, "yem00"] <= minwage*1.05 & scenario_data[,"yem00"]>=actual_minwage*0.8, scenario_data[,"yem"]/168, scenario_data[, "yivwg"])
  # Count how many were affected
  affected <- scenario_data[scenario_data[,"liwftmy"] > 0 & scenario_data[,"liwftmy"]==scenario_data[,"liwmy"] & scenario_data[, "yem00"] <= minwage*1.05 & scenario_data[,"yem00"]>=actual_minwage*0.8, ]
  cat("Affected:", nrow(affected))

  return(scenario_data)
}
