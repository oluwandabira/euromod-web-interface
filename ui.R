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
    uiOutput(outputId="genderWageGap"),
    # h4("Kogu elanikkond"),
    # div("Meeste ja naiste täisajaga töötatud kuude keskmiste netosissetulekute (palk koos toetuste ja muude sissetulekutega) lõhe"),
    # 
    # strong("Sooline palgalõhe kättesaadavas sissetulekus"),
    # div("Meeste ja naiste keskmiste kuunetosissetulekute (palk koos toetuste ja muude sissetulekutega) lõhe"),
    
 )
))

# runApp("X:/Projektid/TLY_REGE_valimid/Kristine_Leetberg/R skriptid/Veebiliides")