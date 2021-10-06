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
source("modules/main.R")
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
  mainUI("main", translator)
))

server <- shinyServer(function(input, output, session) {
    callModule(
      mainServer,
      "main",
      reactive(baseValues),
      reactive(data_dump),
      reactive(data_hh_dump),
      translator
    )
})

shinyApp(ui = ui, server = server)
