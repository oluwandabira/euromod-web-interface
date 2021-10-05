library(shiny)
library(xml2)
library(plotly)
library(shinyBS) # Additional Bootstrap Controls
library(shiny.i18n)

# Used in poverty tab for newggslopegraph
library(CGPfunctions)

translator <-
  Translator$new(translation_json_path = 'translations/translation.json')
translator$set_translation_language("ee")

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

data_hh_dump <- rbind(
  read.csv("data_dump/2018_hh_dump.csv"),
  read.csv("data_dump/2019_hh_dump.csv"),
  read.csv("data_dump/2020_hh_dump.csv")
)

baseValues <- read.csv("data_dump/base_values.csv")


ui <- shinyUI(fluidPage(
  shiny.i18n::usei18n(translator),
  titlePanel(translator$t("Miinimumpalga tõusu mõju palgalõhele")),
  fluidRow(column(
    2,
    offset = 10,
    selectInput(
      "language",
      label = NULL,
      choices = list("Eesti keel" = "ee",
                     "In English" = "en"),
      selected = translator$get_key_translation()
    )
  )),
  sidebarLayout(appInputUI("appInput", translator), mainPanel(
    tabsetPanel(
      type = "tabs",
      tabPanel(
        translator$t("Palgalõhe"),
        genderPayGapUI("genderPayGap", translator)
      ),
      tabPanel(translator$t("Vaesus"), povertyUI("poverty", translator)),
      tabPanel(
        translator$t("Maksud ja toetused"),
        taxesAndBenefitsUI("taxesBenefits", translator)
      )
    )
  ))
))

server <- shinyServer(function(input, output, session) {
  observeEvent(input$language, ignoreInit = TRUE, {
    update_lang(session, input$language)
  })
  
  i18n <- reactive({
    translator$set_translation_language(input$language)
    translator
  })
  results <-
    callModule(
      appInputServer,
      "appInput",
      reactive(baseValues),
      reactive(data_dump),
      reactive(data_hh_dump)
    )
  callModule(genderPayGapServer, "genderPayGap", results)
  callModule(povertyServer, "poverty", results, i18n)
  callModule(taxesAndBenefitsServer, "taxesBenefits", results, i18n)
})

shinyApp(ui = ui, server = server)
