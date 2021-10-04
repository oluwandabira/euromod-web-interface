
appInputUI <- function(id, i18n) {
  ns <- NS(id)
  sidebarPanel(
    div(i18n$t("Rakendus ennustab miinimumpalga muutuse esmast mõju sotsiaalsetele näitajatele, eeldusel, et muud näitajad jäävad samaks.")),
    br(),
    numericInput(ns("minWage"),
                 i18n$t("Sisesta miinimumpalk (bruto)"),
                 550),
    selectInput(ns("year"), i18n$t("Rakendumise aasta"),
                selected="2018",
                c("2020" = "2020",
                  "2019" = "2019",
                  "2018" = "2018")),
    actionButton(ns("run"), i18n$t("Arvuta"))
    #textOutput(ns("selected"))
  )
}

appInputServer <- function(input, output, session, baseValues, resultsDump) {
  #output$selected <- renderText(paste("Selected: ", req(input$year), " : ", req(input$minWage)))
  return(reactive({
    input$run
    
    mwage <- isolate(input$minWage)
    year <- isolate(input$year)
    
    list(
      "computed" = filter(resultsDump(), .data$year == .env$year, .data$minwage == .env$mwage),
      "original" = filter(baseValues(), .data$year == .env$year)
    )
    }))
}