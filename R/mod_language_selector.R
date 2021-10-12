#' language_selector UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_language_selector_ui <- function(id, i18n){
  ns <- NS(id)
  selectInput(
    ns("selector"),
    label = i18n$t("Keelt muuta"),
    choices = i18n$get_languages(),
    selected = i18n$get_key_translation()
  )
}
    
#' language_selector Server Functions
#'
#' @noRd 
mod_language_selector_server <- function(id, translator){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
    observeEvent(input$selector, ignoreInit = TRUE, {
      shiny.i18n::update_lang(session, input$selector)
    })
    
    return(reactive({
      translator$set_translation_language(input$selector)
      translator
    }))
  })
}
    
## To be copied in the UI
# mod_language_selector_ui("language_selector_ui_1")
    
## To be copied in the server
# mod_language_selector_server("language_selector_ui_1")
