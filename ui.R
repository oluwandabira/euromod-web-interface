library(shiny)
library(plotly)


shinyUI(pageWithSidebar(
  headerPanel(""),
  
  sidebarPanel(
    div("Rakendus ennustab miinimumpalga muutuse esmast mõju sotsiaalsetele näitajatele, eeldusel, et muud näitajad jäävad samaks."),
    br(),
    numericInput("obs",
                 "Sisesta miinimumpalk (bruto) ",
                 500,
                 min=500),
    actionButton("run", "Arvuta")
  ),
  
  mainPanel(
    uiOutput(outputId="simulationResults"),
 )
))

# runApp("X:/Projektid/TLY_REGE_valimid/Kristine_Leetberg/R skriptid/Veebiliides")