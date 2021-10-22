#' metric UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_metric_ui <- function(id) {
  ns <- NS(id)
  textOutput(ns("value"))
}

#' metric Server Functions
#'
#' @noRd
mod_metric_server <- function(id, metric, tooltip = NULL) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output$value <- renderText(sprintf("%.2f%%", metric()))

    shinyBS::addTooltip(session, ns("value"), "Tool tip")
    # TODO: FIX TOOLTIP
    # output$tooltip <- renderUI({
    #   if (is.null(tooltip)) {
    #     span()
    #   } else {
    #     shinyBS::bsTooltip(ns("value_id"), toolTip, "top", "hover")
    #   }
    # })
  })
}
