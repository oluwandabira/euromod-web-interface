#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  
  provider <- ComputedProvider$new()
  
  observeEvent(input$selector, ignoreInit = TRUE, {
    shiny.i18n::update_lang(session, input$selector)
  })
  
  # i18n <-
  #   mod_language_selector_server("language", golem::get_golem_options("i18n"))
  
  i18n <- reactive({
    translator$set_translation_language(input$selector)
    translator
  })
  
  output$title <-
    renderUI(titlePanel(
      i18n()$t("Miinimumpalga tõusu mõju palgalõhele"),
      i18n()$t("Miinimumpalga tõusu mõju palgalõhele")
    ))
  
  app_inputs <- mod_input_panel_server("main_input")
  
  mod_output_panel_server("main_output", app_inputs, i18n)
}
