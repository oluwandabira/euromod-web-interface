#' input_panel UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_input_panel_ui <- function(id, i18n) {
  ns <- NS(id)
  tagList(
    i18n$t(
      "Rakendus ennustab miinimumpalga muutuse esmast mõju sotsiaalsetele näitajatele, eeldusel, et muud näitajad jäävad samaks."
    ),
    br(),
    numericInput(ns("min_wage"),
                 i18n$t("Sisesta miinimumpalk (bruto)"),
                 0, min = 0, max = 100),
    selectInput(ns("year"),
                i18n$t("Rakendumise aasta"),
                c(2018, 2019, 2020)),
    actionButton(ns("run"), i18n$t("Arvuta"))
  )
}

#' input_panel Server Functions
#'
#' @noRd
mod_input_panel_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    return(reactive({
      input$run
      
      list(year = isolate(input$year), min_wage = isolate(input$min_wage))
    }))
  })
}

## To be copied in the UI
# mod_input_panel_ui("input_panel_ui_1")

## To be copied in the server
# mod_input_panel_server("input_panel_ui_1")
