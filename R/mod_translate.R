#' translate UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_translate_ui <- function(id){
  ns <- NS(id)
  textOutput("translated")
}
    
#' translate Server Functions
#'
#' @param str String to be translated
#' @noRd 
mod_translate_server <- function(id, str){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
    output$translated <- renderText("Testing")
  })
}
    
## To be copied in the UI
# mod_translate_ui("translate_ui_1")
    
## To be copied in the server
# mod_translate_server("translate_ui_1")
