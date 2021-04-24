library(shiny)
library(plotly)

source("translate.R")

shinyUI(pageWithSidebar(
  headerPanel(""),
  
  sidebarPanel(
    div(i18n$t("Rakendus ennustab miinimumpalga muutuse esmast mõju sotsiaalsetele näitajatele, eeldusel, et muud näitajad jäävad samaks.")),
    br(),
    numericInput("obs",
                 i18n$t("Sisesta miinimumpalk (bruto)"),
                 700),
    selectInput("year", i18n$t("Rakendumise aasta"),
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
))

# runApp("X:/Projektid/TLY_REGE_valimid/Kristine_Leetberg/R skriptid/Veebiliides")