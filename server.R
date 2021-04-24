#rm(list=ls())
library(shiny)
library(xml2)
library(plotly)
library(shinyBS) # Additional Bootstrap Controls

project_folder <- "C:/Users/kr1stine/git/euromod-web-interface"
setwd(project_folder)

source("util\\indicator_functions.R")
source("util\\const.R")
source("util\\create_input_files.R") 
source("util\\helpers.R") 
source("views\\gender_pay_gap_tab.R", encoding="utf-8")
source("views\\poverty_tab.R", encoding="utf-8")
source("views\\taxes_and_benefits_tab.R ", encoding="utf-8")

runSimulation <- function(newMinWage, year) {
  # Create new input file and config
  createInputData(newMinWage, year)
  systemName <- getSystemName(year)
  inputFileName <- getInputFileName(year)
  command <- paste('euromod\\EUROMOD\\Executable\\EM_ExecutableCaller.exe  "C:\\Users\\kr1stine\\git\\euromod-web-interface\\euromod\\EUROMOD_WEB" ',
                   systemName,
                   tools::file_path_sans_ext(inputFileName)
                   )
  # Run EUROMOD for ref system of the same year
  shell(command)
}

readOutputData <- function(year) {
  outputFileName <- getOutputFileName(year)
  output_data <- read.csv(file=paste("euromod/EUROMOD_WEB/output/",outputFileName, sep=""), header=TRUE, sep="\t", stringsAsFactors = TRUE)

  # Add equivalized disposable income variables
  output_data <- addEquivalizedIncome(output_data)

  return(output_data)
}

shinyServer(function(input, output) {
  output$simulationResults <- renderUI({
    input$run
    isolate(runSimulation(input$obs, input$year))
    
    # Read output file
    output_data <- isolate(readOutputData(input$year))

    tabsetPanel(type = "tabs",
                tabPanel("Palgalõhe", genderWageGapOutput(output_data)),
                tabPanel("Vaesus", povertyOutput(output_data)),
                tabPanel("Maksud ja toetused", taxesAndBenefitsOutput(output_data))
    )
  })
  


})
