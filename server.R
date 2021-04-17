library(shiny)
library(xml2)
library(plotly)
source("indicator_functions.R")

# Run base system simulation
system('EM_ExecutableCaller.exe "EUROMOD_WEB" EE_2019 EE_2019_e1')
base_output_data <- read.csv(file="EUROMOD_WEB/output/ee_2019_std.txt", header=TRUE, sep="\t", stringsAsFactors = TRUE)
base_pay_gap <- monthly_gross_pay_gap_ft(base_output_data)
cat(base_pay_gap)

new_pay_gap <- 0

# Function to create new input data file,
# create new config file
# and run simulation
runSimulation <- function(newMinWage) {
  source("create_input_files.R")
  
  # Create new input file
  euromod_data <- read.csv(file="EE_2019_e1.txt", header=TRUE, sep="\t", stringsAsFactors = TRUE)
  scenario_data <- create_input_data(newMinWage, euromod_data)
  write.table(scenario_data, file="EUROMOD_WEB/Input/EE_2019_e1_m.txt", quote=FALSE, col.names=TRUE, row.names=FALSE, sep="\t")
  
  # Create new config file
  page <- read_xml("EUROMOD_WEB\\XMLParam\\Countries\\EE\\EE.xml")
  c <- xml_ns_strip(page)
  j <- xml_find_first(c, '//Parameter[ID[text()=""]]/Value')
  
  xml_set_text(j, paste(newMinWage, "#m", sep=""))
  xml_text(j)
  ns <- xml_ns(page)

  write_xml(c, "EUROMOD_WEB\\XMLParam\\Countries\\EE\\EE.xml")

  # Run EUROMOD for ref system
  system('EUROMOD\\Executable\\EM_ExecutableCaller.exe "EUROMOD_WEB" EE_2019_ref EE_2019_e1_m')
  
  ### 
  
}

readOutput <- function() {
  source("indicator_functions.R")
  
  # Read output file
  output_data <- read.csv(file="EUROMOD_WEB/output/ee_2019_ref_std.txt", header=TRUE, sep="\t", stringsAsFactors = TRUE)
  
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
    output_data <- read.csv(file="EUROMOD_WEB/output/ee_2019_ref_std.txt", header=TRUE, sep="\t", stringsAsFactors = TRUE)
    
    # Find new values for indicators
    new_pay_gap <- monthly_gross_pay_gap_ft(output_data)
    
    pay_gaps <- c(base_pay_gap, new_pay_gap)
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
