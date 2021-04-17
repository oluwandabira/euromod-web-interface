library(shiny)
library(plotly)


shinyUI(pageWithSidebar(
  headerPanel(""),
  
  sidebarPanel(
    div("Rakendus ennustab miinimumpalga muutuse esmast mõju sotsiaalsetele näitajatele."),
    br(),
    numericInput("obs",
                 "Sisesta miinimumpalk ",
                 700,
                 min=500),
    actionButton("run", "Arvuta")
  ),
  
  mainPanel(
    strong("Sooline palgalõhe töötava elanikkonna hulgas"),
    div("Meeste ja naiste täisajaga töötatud kuude keskmiste brutopalkade lõhe"),
    uiOutput(outputId="grossHourlyWageGapStatic"),
    strong("Sooline palgalõhe kättesaadavas sissetulekus"),
    div("Meeste ja naiste täisajaga töötatud kuude keskmiste netosissetulekute (palk koos toetuste ja muude sissetulekutega) lõhe"),
    h4("Kogu elanikkond"),
    strong("Sooline palgalõhe kättesaadavas sissetulekus"),
    div("Meeste ja naiste keskmiste kuunetosissetulekute (palk koos toetuste ja muude sissetulekutega) lõhe"),
  )
))

# runApp("X:/Projektid/TLY_REGE_valimid/Kristine_Leetberg/R skriptid/Veebiliides")