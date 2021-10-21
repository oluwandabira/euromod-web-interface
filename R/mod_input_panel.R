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
                 tagList(
                   i18n$t("Sisesta miinimumpalk (bruto)"),
                   textOutput(ns("range"), inline = TRUE)
                 ),
                 600),
    selectInput(ns("year"),
                i18n$t("Rakendumise aasta"),
                c(2018, 2019, 2020)),
    actionButton(ns("run"), i18n$t("Arvuta"))
  )
}

#' input_panel Server Functions
#'
#' @noRd
mod_input_panel_server <- function(id, i18n, input_limits) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    limits <- reactive(input_limits[input_limits$year == input$year, ])
    
    output$range <- renderText(sprintf("[%d,%d]", limits()$min, limits()$max))
    
    iv <- shinyvalidate::InputValidator$new()
    
    iv$add_rule("min_wage", shinyvalidate::sv_required())
    
    iv$add_rule("min_wage",
                function(min_wage) {
                  if (min_wage < limits()$min || min_wage > limits()$max)
                    i18n()$t("Sisend väljaspool vahemikku")
                })
    
    iv$enable()
    #observe({iv$enable()}) %>% bindEvent(input$run)
    
    observe({
      if (!iv$is_valid()) {
        shinyjs::disable("run")
      } else {
        shinyjs::enable("run")
      }
    })
    
    app_inputs <- reactive({
      #year <- isolate(input$year)
      #min_wage <- isolate(input$min_wage)

      #req(!is.null(year))
      #req(!is.null(min_wage))
      req(iv$is_valid())
      list("year" = input$year, "min_wage" = input$min_wage)
    }) %>% bindEvent(input$run, ignoreInit = TRUE)
    
    return(app_inputs)
  })
}
