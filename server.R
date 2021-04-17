library(shiny)
library(xml2)
library(plotly)

project_folder <- "C:/Users/kr1stine/git/euromod-web-interface"
setwd(project_folder)


source("indicator_functions.R")
source("const.R")

# Run base system simulation
# TODO - save these to the system to save time?
# shell(' C:\\Users\\kr1stine\\git\\euromod-web-interface\\euromod\\EUROMOD\\Executable\\EM_ExecutableCaller.exe  "C:\\Users\\kr1stine\\git\\euromod-web-interface\\euromod\\EUROMOD_WEB" EE_2018 EE_2018_c1')
# base_output_data <- read.csv(file="euromod/EUROMOD_WEB/output/ee_2018_std.txt", header=TRUE, sep="\t", stringsAsFactors = TRUE)
# base_pay_gap <- monthly_gross_pay_gap_ft(base_output_data)
# cat(base_pay_gap)

new_pay_gap <- 0

# Function to create new input data file,
# create new config file
# and run simulation
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
  
  ### 
  
}

readOutput <- function() {
  source("indicator_functions.R")
  
  # Read output file
  output_data <- read.csv(file="euromod\\EUROMOD_WEB\\output\\ee_2018_std.txt", header=TRUE, sep="\t", stringsAsFactors = TRUE)
  
  # Find new values for indicators
  new_pay_gap <- hourly_gross_pay_gap(output_data)
  cat(new_pay_gap)
}



shinyServer(function(input, output) {

  # output$grossHourlyWageGapPlot <- renderPlot({
  #   
  #   input$run
  #   #isolate(runSimulation(input$obs))
  #   # Read output file
  #   output_data <- read.csv(file="C:/Users/kristine.leetberg/Documents/EUROMOD_WEB/output/ee_2019_ref_std.txt", header=TRUE, sep="\t", stringsAsFactors = TRUE)
  #   
  #   # Find new values for indicators
  #   new_pay_gap <- monthly_gross_pay_gap_ft(output_data)
  #   
  #   pay_gaps <- c(base_pay_gap, new_pay_gap)
  #   names <- c("Tegelik palgalohe", "Simuleeritud palgalohe")
  #   
  #   barplot(pay_gaps, names.arg=names, main="Sooline palgalohe brutokuupalgas")
  #   
  # })
  output$grossHourlyWageGapPlotInt <- renderPlotly({
    
    input$run
    isolate(runSimulation(input$obs))
    # Read output file
    output_data <- read.csv(file="euromod/EUROMOD_WEB/output/ee_2018_std.txt", header=TRUE, sep="\t", stringsAsFactors = TRUE)
    
    # Find new values for indicators
    new_pay_gap <- monthly_gross_pay_gap_ft(output_data)
    
    pay_gaps <- c(GENDER_PAY_GAP_WORKERS, new_pay_gap)
    names <- c("2019 - 540€", "2019 - 700€")
    text <- c("2019. aasta tegelik palgalõhe statistikaameti andmetel", "Palgalõhe sisestatud miinimumpalgaga simuleeritud olukorras")
    data <- data.frame(names, pay_gaps, text)
    
    fig <- plot_ly(data, x = ~names, y = ~pay_gaps, type='bar', text = text,
                   marker = list(color='rgb(158,202,225)',
                                 line = list(color = 'rgb(8,48,107)',
                                             width = 1.5)))
    fig <- fig %>% layout(title = "",
                          xaxis = list(title = ""),
                          yaxis = list(title = ""))
    fig
    
  })
})
