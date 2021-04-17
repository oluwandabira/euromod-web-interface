library(shiny)
library(xml2)
library(plotly)
library(shinyBS) # Additional Bootstrap Controls

project_folder <- "C:/Users/kr1stine/git/euromod-web-interface"
setwd(project_folder)

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


shinyServer(function(input, output) {
  source("indicator_functions.R")
  source("const.R")
  
  output$genderWageGap <- renderUI({
    input$run
    isolate(runSimulation(input$obs))
    # Read output file
    output_data <- read.csv(file="euromod/EUROMOD_WEB/output/ee_2018_std.txt", header=TRUE, sep="\t", stringsAsFactors = TRUE)
    
    # Find new values for indicators
    new_pay_gap <- monthly_gross_pay_gap_ft(output_data)
    new_dis_inc_gap_ft <- disposable_income_gap_ft(output_data)
    new_dis_inc_gap <- disposable_income_gap(output_data)
    
    div(
      h4("Töötav elanikkond"),
      fluidRow(
        column(8,
               strong("Sooline palgalõhe"),
               span(id="infoPayGap", icon("info-circle", "fa")),
               bsTooltip(id = "infoPayGap", title = "Arvutuse aluseks on meeste ja naiste kuine brutopalk.",
                         placement = "bottom", trigger = "hover"),
               p("Täisajaga töötavate meeste ja naiste brutopalkade lõhe.")
               
        ),
        column(4,
               div(id = "actualValue",paste(round(GENDER_PAY_GAP_WORKERS,2), "%")),
               bsTooltip(id = "actualValue", title = "Tegelik väärtus",
                         placement = "left", trigger = "hover"),
               icon("arrow-down", "fa"),
               div(id="newValue", paste(round(new_pay_gap,2), "%")),
               bsTooltip(id = "newValue", title = "Ennustatatud uus väärtus",
                         placement = "left", trigger = "hover"),
        )
      ),
      br(),
      fluidRow(
        column(8,
               strong("Kättesaadava sissetuleku sooline lõhe"),
               span(id="infoDispIncFT", icon("info-circle", "fa")),
               bsTooltip(id = "infoDispIncFT", title = "Arvutuse aluseks on meeste ja naiste kuine brutopalk.",
                         placement = "bottom", trigger = "hover"),
               p("Täisajaga töötavate meeste ja naiste kasutatava sissetuleku (brutopalk + toetused - maksud) lõhe.")
               
        ),
        column(4,
               div(paste(round(DISP_INCOME_GAP_WORKERS,2), "%")),
               icon("arrow-down", "fa"),
               div(paste(round(new_dis_inc_gap_ft,2), "%")),
        )
      ),
      br(),
      h4("Kogu elanikkond"),
      fluidRow(
        column(8,
               strong("Kättesaadava sissetuleku sooline lõhe"),
               span(id="infoDispInc", icon("info-circle", "fa")),
               bsTooltip(id = "infoDispInc", title = "Arvutuse aluseks on meeste ja naiste kuine brutopalk.",
                         placement = "bottom", trigger = "hover"),
               p("Positiivse sissetulekuga meeste ja naiste kasutatava sissetuleku (brutopalk + toetused - maksud) lõhe.")
               
        ),
        column(4,
               div(paste(round(DISP_INCOME_GAP_ALL,2), "%")),
               icon("arrow-down", "fa"),
               div(paste(round(new_dis_inc_gap,2), "%")),
        )
      ),
    )
  
  })

})
