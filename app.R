#rm(list=ls())
library(shiny)
library(xml2)
library(plotly)
library(shinyBS) # Additional Bootstrap Controls
library(shiny.i18n)

project_folder <- "C:/Users/kr1stine/git/euromod-web-interface"
setwd(project_folder)

i18n <- Translator$new(translation_json_path='translations/translation.json')
i18n$set_translation_language("ee")

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

server <- shinyServer(function(input, output, session) {
  # Make sure minimum wage is not below the actual minimum wage 
  observeEvent(input$language, ignoreInit = TRUE, {
    update_lang(session, input$language)
  })
  observe({
    updateNumericInput(session, "obs", min = getOrigMinWage(input$year))
  })
  v <- reactive({
    validate(
      need(input$obs, i18n$t("Miinimumpalk ei tohi olla tühi!")),
      need(input$obs >= getOrigMinWage(input$year), i18n$t("Palun sisesta tegelikust miinimumpalgast kõrgem väärtus."))
    )
  })

  output$simulationResults <- renderUI({

    # Calls this function if "Run" button is clicked
    input$run

    # Validations
    isolate(v())

    # Run simulation
    runSimulation(input$obs, input$year)

    # Read output file
    output_data <- readOutputData(input$year)

    tabsetPanel(type = "tabs",
                tabPanel(i18n$t("Palgalõhe"), genderWageGapOutput(output_data, i18n)),
                tabPanel(i18n$t("Vaesus"), povertyOutput(output_data, i18n)),
                tabPanel(i18n$t("Maksud ja toetused"), taxesAndBenefitsOutput(output_data, i18n)))

  })
})


ui <- shinyUI(
  fluidPage(
    shiny.i18n::usei18n(i18n),
    titlePanel(i18n$t("Miinimumpalga tõusu mõju palgalõhele")),
    
    fluidRow(
      column(2,offset=10,
             selectInput("language", label= NULL, 
                         choices = list("Eesti keel" = "ee",
                                        "In English" = "en"),
                         selected = i18n$get_key_translation())
      )
    ),
    sidebarLayout(
      sidebarPanel(
        div(i18n$t("Rakendus ennustab miinimumpalga muutuse esmast mõju sotsiaalsetele näitajatele, eeldusel, et muud näitajad jäävad samaks.")),
        br(),
        numericInput("obs",
                     i18n$t("Sisesta miinimumpalk (bruto)"),
                     700),
        selectInput("year", i18n$t("Rakendumise aasta"),
                    selected="2018",
                    c("2020" = "2020",
                      "2019" = "2019",
                      "2018" = "2018",
                      "2017" = "2017",
                      "2016" = "2016",
                      "2015" = "2015")),
        actionButton("run", i18n$t("Arvuta"))
      ),
      
      mainPanel(
        uiOutput(outputId="simulationResults"),
      )
    )
  )
)

shinyApp(ui=ui, server=server)
