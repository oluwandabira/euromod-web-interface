library(shiny)
library(xml2)
library(plotly)
library(shinyBS) # Additional Bootstrap Controls

project_folder <- "C:/Users/kr1stine/git/euromod-web-interface"
setwd(project_folder)

source("util\\indicator_functions.R")
source("util\\const.R")
source("util\\create_input_files.R") 
source("views\\gender_pay_gap_tab.R", encoding="utf-8")
source("views\\poverty_tab.R", encoding="utf-8")

runSimulation <- function(newMinWage) {
  # Create new input file and config
  createInputData(500, newMinWage)

  # Run EUROMOD for ref system of the same year
  shell('euromod\\EUROMOD\\Executable\\EM_ExecutableCaller.exe  "C:\\Users\\kr1stine\\git\\euromod-web-interface\\euromod\\EUROMOD_WEB" EE_2018 EE_2018_c1')
  # Run EUROMOD for the next year 
  # TODO- if year changes, check that system exists
  shell('euromod\\EUROMOD\\Executable\\EM_ExecutableCaller.exe  "C:\\Users\\kr1stine\\git\\euromod-web-interface\\euromod\\EUROMOD_WEB" EE_2019 EE_2018_c1')
  
}

readOutputData <- function() {
  output_data <- read.csv(file="euromod/EUROMOD_WEB/output/ee_2018_std.txt", header=TRUE, sep="\t", stringsAsFactors = TRUE)
  
  # Add equivalized disposable income variables
  output_data <- addEquivalizedIncome(output_data)

  return(output_data)
}

readNextYearOutputData <- function() {
  output_data_nxt <- read.csv(file="euromod/EUROMOD_WEB/output/ee_2019_std.txt", header=TRUE, sep="\t", stringsAsFactors = TRUE)
  
  # Add equivalized disposable income variables
  output_data_nxt <- addEquivalizedIncome(output_data_nxt)
  
  return(output_data_nxt)
}

shinyServer(function(input, output) {
  output$simulationResults <- renderUI({
    input$run
    isolate(runSimulation(input$obs))
    
    # Read output file
    output_data <- readOutputData()
    output_data_nxt <- readNextYearOutputData()
    
    tabsetPanel(type = "tabs",
                tabPanel("Palgalõhe", genderWageGapOutput(output_data)),
                tabPanel("Vaesus", povertyOutput(output_data, output_data_nxt)),
                tabPanel("Maksud ja toetused", "")
    )
  })
  


})
