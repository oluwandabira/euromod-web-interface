# Creating new input files for EUROMOD
# for new minimum wage values
# working with monthly wages

createInputData <- function(newMinWage, year) {
  inputFileName <- getInputFileName(year)
  euromod_data <- read.csv(file=paste("data\\", inputFileName, sep=""), header=TRUE, sep="\t", stringsAsFactors = TRUE)
  scenario_data <- data.frame(euromod_data)
  
  origMinWage <- getOrigMinWage(year)
  
  # For register data yem00, for EU-SILC yem
  wage_variable = "yem"
  #scenario_data[, wage_variable] <- ifelse(scenario_data[,"liwftmy"] > 0 & scenario_data[,"liwftmy"]==scenario_data[,"liwmy"] & scenario_data[, wage_variable] <= newMinWage & scenario_data[,wage_variable]>=origMinWage*0.8, newMinWage, scenario_data[, wage_variable])
  scenario_data[, wage_variable] <- ifelse(scenario_data[,"liwftmy"] > 0 & scenario_data[,"liwftmy"]==scenario_data[,"liwmy"] & scenario_data[,"liwmy"] == 12 & scenario_data[, wage_variable] <= newMinWage & scenario_data[,wage_variable]>=origMinWage*0.8, newMinWage, scenario_data[, wage_variable])
  
  #scenario_data$yem <- scenario_data$yem00 + scenario_data$yemabtx + scenario_data$yemabnt
  #scenario_data$yivwg <- ifelse(scenario_data[,"liwftmy"] > 0 & scenario_data[,"liwftmy"]==scenario_data[,"liwmy"] & scenario_data[, wage_variable] <= newMinWage & scenario_data[,wage_variable]>=origMinWage*0.8, scenario_data[,wage_variable]/168, scenario_data[, "yivwg"])
  scenario_data$yivwg <- ifelse(scenario_data[,"liwftmy"] > 0 & scenario_data[,"liwftmy"]==scenario_data[,"liwmy"] & scenario_data[,"liwmy"] == 12 & scenario_data[, wage_variable] <= newMinWage & scenario_data[,wage_variable]>=origMinWage*0.8, scenario_data[,wage_variable]/168, scenario_data[, "yivwg"])
  
  write.table(scenario_data, file=paste("euromod\\EUROMOD_WEB\\Input\\", inputFileName, sep=""), quote=FALSE, col.names=TRUE, row.names=FALSE, sep="\t")
  
  new_av_wage <- average_wage(scenario_data)
  createXmlConfig(newMinWage, new_av_wage, year)
  
  return(inputFileName)
}

# Adds a column to the data depicting the equivalized disposable income
addEquivalizedIncome <- function(data) {
  data$ils_dispy <- as.numeric(sub(",",".",data$ils_dispy, fixed=TRUE))
  data$dag <- as.numeric(sub(",",".",data$dag, fixed=TRUE))
  
  # OECD levels
  first_adult <- 1
  next_adult <- 0.5
  child <- 0.3
  child_age <- 14
  data$oecd_weight <- ifelse(data$idperson == data$tu_sapehh_ee_HeadID, first_adult, ifelse(data$dag >= child_age, 0.7, 0.5))
  
  by_hh <- data %>% group_by(idhh)
  total_income <- by_hh %>% summarise(
    total_dispy = sum(ils_dispy),
    total_weight = sum(oecd_weight),
    eq_dispy = total_dispy/total_weight,
    hh_adults_count = sum(dag >= 18),
    hh_children_count = sum(dag < 18),
    hh_pensioners_count = sum(dag >= 65),
    dgn_help = sum(dgn),
  ) 
  total_income$hh_type <- case_when(
    total_income$hh_pensioners_count > 0 | total_income$hh_adults_count > 2 ~ "other",
    total_income$hh_adults_count == 1 & total_income$hh_children_count == 0 & total_income$dgn_help == 1 ~ "single_man",
    total_income$hh_adults_count == 1 & total_income$hh_children_count == 0 & total_income$dgn_help == 0 ~ "single_woman",
    total_income$hh_adults_count == 1 & total_income$hh_children_count > 0 ~ "single_parent",
    total_income$hh_adults_count == 2 & total_income$hh_children_count == 0 ~ "couple_no_children",
    total_income$hh_adults_count == 2 & total_income$hh_children_count == 1 ~ "couple_one_child",
    total_income$hh_adults_count == 2 & total_income$hh_children_count == 2 ~ "couple_two_children",
    total_income$hh_adults_count == 2 & total_income$hh_children_count > 2 ~ "couple_many_children",
    TRUE ~ "other"
  ) 
    
  data <- left_join(data, total_income, by="idhh")

  return(data)
}

# Modify EUROMOD XML file
createXmlConfig <- function(newMinWage, newAvWage, year) {
  # Create new config file
  page <- read_xml("data\\EE_original.xml")
  systemName <- getSystemName(year)
  
  # Update variables in XML config
  system <- paste('//d1:System[d1:Name[text()="',systemName,'"]]',sep="")
  
  minWageParam <- xml_find_first(page, paste(system,'//d1:Parameter[d1:Name[text()="$MinWage"]]/d1:Value', sep=""))
  xml_set_text(minWageParam, paste(newMinWage, "#m", sep=""))
  
  avWageParam <- xml_find_first(page, paste(system,'//d1:Parameter[d1:Name[text()="$AvWage"]]/d1:Value', sep=""))
  xml_set_text(avWageParam, paste(newAvWage, "#m", sep=""))
  
  write_xml(page, "euromod\\EUROMOD_WEB\\XMLParam\\Countries\\EE\\EE.xml")
}