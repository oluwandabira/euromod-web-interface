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
  tabsetPanel(
    type = "tabs",
    tabPanel(i18n$t("Palgalõhe"), mod_gender_pay_gap_ui(ns("gender_pay_gap"), i18n)),
    tabPanel(i18n$t("Vaesus"), mod_poverty_ui(ns("poverty"), i18n)),
    tabPanel(
      i18n$t("Maksud ja toetused"),
      mod_taxes_ui(ns("taxes"), i18n)
    ))
}
    
#' output_panel Server Functions
#'
#' @noRd 
mod_output_panel_server <- function(id, i18n, results){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
    # observe({
    #   if (is.null(results()$year)) {
    #     message("IS NULL")
    #   } else {
    #     message("IS NOT NULL")
    #   }
    # })
    mod_gender_pay_gap_server("gender_pay_gap", i18n, results)
    
    mod_poverty_server("poverty", i18n, results)

    mod_taxes_server("taxes", i18n, results)
  })
}
    
## To be copied in the UI
# mod_output_panel_ui("output_panel_ui_1")
    
## To be copied in the server
# mod_output_panel_server("output_panel_ui_1")
