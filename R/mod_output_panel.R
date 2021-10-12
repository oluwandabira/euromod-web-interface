#' output_panel UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_output_panel_ui <- function(id, i18n){
  ns <- NS(id)
  tagList(
    textOutput(ns("years")),
    br(),
    i18n$t("Sisesta miinimumpalk (bruto)"),
    br(),
    textOutput(ns("lang"))
  )
}
    
#' output_panel Server Functions
#'
#' @noRd 
mod_output_panel_server <- function(id, app_inputs, i18n){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
    output$years <- renderText({
      i <- app_inputs()
      
      paste0(i$year, "/", i$min_wage)
    })
    
    output$lang <- renderText({
      i <- i18n()
      i$t("Sisesta miinimumpalk (bruto)")
      })
  })
}
    
## To be copied in the UI
# mod_output_panel_ui("output_panel_ui_1")
    
## To be copied in the server
# mod_output_panel_server("output_panel_ui_1")
