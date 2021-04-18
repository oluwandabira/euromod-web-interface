# Creating new input files for EUROMOD
# for new minimum wage values
# working with monthly wages

createInputData <- function(origMinwage, newMinWage) {
  euromod_data <- read.csv(file="data\\EE_2018_c1.txt", header=TRUE, sep="\t", stringsAsFactors = TRUE)
  scenario_data <- data.frame(euromod_data)
  
  # For register data yem00, for EU-SILC yem
  wage_variable = "yem"
  scenario_data[, wage_variable] <- ifelse(scenario_data[,"liwftmy"] > 0 & scenario_data[,"liwftmy"]==scenario_data[,"liwmy"] & scenario_data[, wage_variable] <= newMinWage*1.05 & scenario_data[,wage_variable]>=origMinwage*0.8, newMinWage, scenario_data[, wage_variable])
  #scenario_data$yem <- scenario_data$yem00 + scenario_data$yemabtx + scenario_data$yemabnt
  scenario_data$yivwg <- ifelse(scenario_data[,"liwftmy"] > 0 & scenario_data[,"liwftmy"]==scenario_data[,"liwmy"] & scenario_data[, wage_variable] <= newMinWage*1.05 & scenario_data[,wage_variable]>=origMinwage*0.8, scenario_data[,wage_variable]/168, scenario_data[, "yivwg"])

  write.table(scenario_data, file="euromod\\EUROMOD_WEB\\Input\\EE_2018_c1.txt", quote=FALSE, col.names=TRUE, row.names=FALSE, sep="\t")
  
  new_av_wage <- average_wage(scenario_data)
  createXmlConfig(newMinWage, new_av_wage)
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
createXmlConfig <- function(newMinWage, newAvWage) {
  # Create new config file
  page <- read_xml("data\\EE_original.xml")
  
  # Update variables in XML config
  
  # $MinWage
  i <- xml_find_first(page, '//d1:Parameter[d1:ID[text()="e06886b0-7b1f-41ba-b0af-d97029e57413"]]/d1:Value', xml_ns(page))
  xml_set_text(i, paste(newMinWage, "#m", sep=""))
  
  # $AvWage
  j <- xml_find_first(page, '//d1:Parameter[d1:ID[text()="cf54f149-8033-4c55-8c4c-310845143201"]]/d1:Value', xml_ns(page))
  xml_set_text(j, paste(newAvWage, "#m", sep=""))
  
  # Update variables for next year
  
  # $MinWage
  k <- xml_find_first(page, '//d1:Parameter[d1:ID[text()="3c856bfe-ef84-4ef9-8833-fbe8821bbb3c"]]/d1:Value', xml_ns(page))
  xml_set_text(k, paste(newMinWage, "#m", sep=""))
  
  # $MinWage_lag1
  l <- xml_find_first(page, '//d1:Parameter[d1:ID[text()="805164fa-7941-4ea5-80b5-0d16d1899c90"]]/d1:Value', xml_ns(page))
  xml_set_text(l, paste(newMinWage, "#m", sep=""))
  
  # SIC_MinBase
  l <- xml_find_first(page, '//d1:Parameter[d1:ID[text()="37220aef-853e-48af-8533-70341714f401"]]/d1:Value', xml_ns(page))
  xml_set_text(l, paste(newMinWage, "#m", sep=""))
  write_xml(page, "euromod\\EUROMOD_WEB\\XMLParam\\Countries\\EE\\EE.xml")
  
  # PB_MinAmount
  l <- xml_find_first(page, '//d1:Parameter[d1:ID[text()="0fad4831-d278-4164-a11f-9f83b838a558"]]/d1:Value', xml_ns(page))
  xml_set_text(l, paste(newMinWage, "#m", sep=""))
  write_xml(page, "euromod\\EUROMOD_WEB\\XMLParam\\Countries\\EE\\EE.xml")
}