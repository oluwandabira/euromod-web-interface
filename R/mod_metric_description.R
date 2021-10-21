#' metric_description UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_metric_description_ui <- function(id, title, description){
  ns <- NS(id)
  div(
    strong(title),
    p(description,
      span(id = ns("info"), icon("question-circle", "far", "font-awesome"))),
      uiOutput(ns("tooltip"))
  )
}
    
#' metric_description Server Functions
#'
#' @noRd 
mod_metric_description_server <- function(id, tooltip = NULL){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
    output$tooltip <- renderUI({
      if (is.null(tooltip)) {
        span()
      } else {
        # TODO: FIX TOOLTIP
        shinyBS::bsTooltip(id = ns("info"), title = tooltip,
                  placement = "bottom", trigger = "hover")
      }
    })
  })
}