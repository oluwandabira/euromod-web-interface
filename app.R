library(shiny)
library(xml2)
library(plotly)
library(shinyBS) # Additional Bootstrap Controls
library(shiny.i18n)

i18n <-
  Translator$new(translation_json_path = 'translations/translation.json')
i18n$set_translation_language("ee")

source("modules/components.R")
source("modules/metric.R")
source("modules/metricChange.R")
source("modules/appInput.R")
source("modules/genderPayGap.R")
source("modules/poverty.R")
source("modules/taxesAndBenefits.R")


data_dump <- rbind(
  read.csv("data_dump/2018_dump.csv"),
  read.csv("data_dump/2019_dump.csv"),
  read.csv("data_dump/2020_dump.csv")
)

baseValues <- read.csv("data_dump/base_values.csv")

server <- shinyServer(function(input, output, session) {
  observeEvent(input$language, ignoreInit = TRUE, {
    update_lang(session, input$language)
  })
  results <-
    callModule(appInputServer,
               "appInput",
               reactive(baseValues),
               reactive(data_dump))
  callModule(genderPayGapServer, "genderPayGap", results)
  callModule(povertyServer, "poverty", results)
  callModule(taxesAndBenefitsServer, "taxesBenefits", results)
})


ui <- shinyUI(fluidPage(
  shiny.i18n::usei18n(i18n),
  titlePanel(i18n$t("Miinimumpalga tõusu mõju palgalõhele")),
  fluidRow(column(
    2,
    offset = 10,
    selectInput(
      "language",
      label = NULL,
      choices = list("Eesti keel" = "ee",
                     "In English" = "en"),
      selected = i18n$get_key_translation()
    )
  )),
  sidebarLayout(appInputUI("appInput", i18n), mainPanel(
    tabsetPanel(
      type = "tabs",
      tabPanel(i18n$t("Palgalõhe"), genderPayGapUI("genderPayGap", i18n)),
      tabPanel(i18n$t("Vaesus"), povertyUI("poverty", i18n)),
      tabPanel(
        i18n$t("Maksud ja toetused"),
        taxesAndBenefitsUI("taxesBenefits", i18n)
      )
    )
  ))
  
))

shinyApp(ui = ui, server = server)
