#' poverty UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_poverty_ui <- function(id, i18n){
  ns <- NS(id)
  div(
    br(),
    h4(i18n$t("Töötav elanikkond")),
    br(),
    mod_metric_change_ui(
      ns("in_work_poverty"),
      i18n$t("Palgavaesuse määr"),
      i18n$t(
        "Nende elanike osatähtsus, kes on vaesuses vaatamata sellele, et käivad tööl."
      )
    ),
    h4(i18n$t("Kogu elanikkond")),
    br(),
    mod_metric_change_ui(
      ns("relative_poverty"),
      i18n$t("Suhtelise vaesuse määr"),
      i18n$t("Nende elanike osatähtsus, kes on suhtelises vaesuses.")
    ),
    br(),
    mod_metric_change_ui(
      ns("absolute_poverty"),
      i18n$t("Absoluutse vaesuse määr"),
      i18n$t(
        "Nende elanike osatähtsus, kelle sissetulek jääb alla elatusmiinimumi."
      )
    ),
    br(),
    fluidRow(column(11, align = "center", plotOutput(
      ns("hh_abs")
    ))),
    br(),
    fluidRow(column(11, align = "center", plotOutput(
      ns("hh_rel")
    )))
  )
}
    
#' poverty Server Functions
#'
#' @noRd 
mod_poverty_server <- function(id, i18n, results){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
    mod_metric_change_server(
      "in_work_poverty",
      reactive(results()$original$"in work poverty"),
      reactive(results()$computed$"new in-work poverty rate")
    )
    
    mod_metric_change_server(
      "relative_poverty",
      reactive(results()$original$"relative poverty rate"),
      reactive(results()$computed$"new relative poverty rate")
    )
    
    mod_metric_change_server(
      "absolute_poverty",
      reactive(results()$original$"abs poverty rate"),
      reactive(results()$computed$"new abs poverty rate")
    )
    
    
    translated_data <- reactive({
      dataframe <- results()$household
      i18n <- i18n()
      dataframe <-
        dataframe %>% dplyr::mutate(household := i18n$t(household), scenario := i18n$t(scenario))
      names(dataframe) <- c("year", "min wage", "household", "scenario", "abs_poverty", "rel_poverty")
      dataframe
    })
    
    output$hh_abs <-
      renderPlot(
        CGPfunctions::newggslopegraph(
          dataframe = translated_data(),
          Times = scenario,
          Measurement = abs_poverty,
          Grouping = household,
          Title = i18n()$t("Absoluutse vaesuse määra muutus"),
          SubTitle = i18n()$t("Leibkondade kaupa"),
          YTextSize = 4,
          DataTextSize = 4,
          Caption = NULL
        )
      )
    
    output$hh_rel <-
      renderPlot(
        CGPfunctions::newggslopegraph(
          dataframe = translated_data(),
          Times = scenario,
          Measurement = rel_poverty,
          Grouping = household,
          Title = i18n()$t("Suhtelise vaesuse määra muutus"),
          SubTitle = i18n()$t("Leibkondade kaupa"),
          YTextSize = 4,
          DataTextSize = 4,
          Caption = NULL
        )
      )
  })
}
