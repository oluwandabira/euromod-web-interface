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
  
  translator <- golem::get_golem_options("i18n")
  
  i18n <- reactive({
    translator$set_translation_language(input$selector)
    translator
  })
  
  output$title <-
    renderUI(titlePanel(
      i18n()$t("Miinimumpalga tõusu mõju palgalõhele"),
      i18n()$t("Miinimumpalga tõusu mõju palgalõhele")
    ))
  
  limits <- provider$get_input_limits()
  
  app_inputs <- mod_input_panel_server("main_input", i18n, limits)
  
  observe({message("App Inputs", app_inputs())}) %>% bindEvent(app_inputs)
  
  results <- reactive({
    app_inputs() # NEED to draw this dependency so the inputs don't compute with NULL
    provider$compute(app_inputs()$year, app_inputs()$min_wage)
  })
  
  mod_output_panel_server("main_output", i18n, results)
}
