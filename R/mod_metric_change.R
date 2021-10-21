#' metric_change UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_metric_change_ui <- function(id, title, description) {
  ns <- NS(id)
  fluidRow(
    column(8, mod_metric_description_ui(ns("description"), title, description)),
    column(
      4,
      align = "center",
      mod_metric_ui(ns("old")),
      down_arrow(),
      mod_metric_ui(ns("new"))
    )
  )
}

down_arrow <- function() {
  tags$i(class = "fa fa-arrow-down")
         #style = "color: rgb(0,166,90)")
}

#' metric_change Server Functions
#'
#' @noRd
mod_metric_change_server <-
  function(id,
           old_value,
           new_value,
           desc_tt = NULL,
           old_tt = NULL,
           new_tt = NULL) {
    moduleServer(id, function(input, output, session) {
      ns <- session$ns
      
      mod_metric_description_server("decription", desc_tt)
      
      mod_metric_server("old", old_value, old_tt)
      
      mod_metric_server("new", new_value, new_tt)
    })
  }
