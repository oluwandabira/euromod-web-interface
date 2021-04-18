library(shiny)
library(xml2)
library(plotly)
library(shinyBS) # Additional Bootstrap Controls

project_folder <- "C:/Users/kr1stine/git/euromod-web-interface"
setwd(project_folder)

source("indicator_functions.R")
source("const.R")
source("gender_pay_gap_tab.R", encoding="utf-8")

new_pay_gap <- 0


runSimulation <- function(newMinWage) {
  # Create new input file
  source("create_input_files.R")
  orig_data <- read.csv(file="data\\EE_2018_c1.txt", header=TRUE, sep="\t", stringsAsFactors = TRUE)
  scenario_data <- create_input_data(newMinWage, orig_data)
  write.table(scenario_data, file="euromod\\EUROMOD_WEB\\Input\\EE_2018_c1.txt", quote=FALSE, col.names=TRUE, row.names=FALSE, sep="\t")
  
  # Create new config file
  page <- read_xml("data\\EE_original.xml")

  # $MinWage
  j <- xml_find_first(page, '//d1:Parameter[d1:ID[text()="e06886b0-7b1f-41ba-b0af-d97029e57413"]]/d1:Value', xml_ns(page))
  xml_set_text(j, paste(newMinWage, "#m", sep=""))
  write_xml(page, "euromod\\EUROMOD_WEB\\XMLParam\\Countries\\EE\\EE.xml")

  # Run EUROMOD for ref system
  shell('euromod\\EUROMOD\\Executable\\EM_ExecutableCaller.exe  "C:\\Users\\kr1stine\\git\\euromod-web-interface\\euromod\\EUROMOD_WEB" EE_2018 EE_2018_c1')
}

shinyServer(function(input, output) {
  output$simulationResults <- renderUI({
    input$run
    isolate(runSimulation(input$obs))
    # Read output file
    output_data <- read.csv(file="euromod/EUROMOD_WEB/output/ee_2018_std.txt", header=TRUE, sep="\t", stringsAsFactors = TRUE)
    
    tabsetPanel(type = "tabs",
                tabPanel("Palgalõhe", genderWageGapOutput(output_data)),
                tabPanel("Vaesus", ""),
                tabPanel("Maksud ja toetused", "")
    )
  })
  


})
