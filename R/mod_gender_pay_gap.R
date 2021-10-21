#' gender_pay_gap UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList
mod_gender_pay_gap_ui <- function(id, i18n) {
  ns <- NS(id)
  div(
    br(),
    h4(i18n$t("Töötav elanikkond")),
    br(),
    mod_metric_change_ui(
      ns("pay_gap"),
      i18n$t("Sooline palgalõhe"),
      i18n$t("Täisajaga töötavate meeste ja naiste brutotunnipalkade lõhe.")
    ),
    br(),
    mod_metric_change_ui(
      ns("disp_ft"),
      i18n$t("Kättesaadava sissetuleku sooline lõhe"),
      i18n$t(
        "Täisajaga töötavate meeste ja naiste kasutatava sissetuleku (brutopalk + toetused - maksud) lõhe."
      )
    ),
    br(),
    mod_metric_change_ui(
      ns("disp"),
      i18n$t("Kättesaadava sissetuleku sooline lõhe"),
      i18n$t(
        "Positiivse sissetulekuga meeste ja naiste kasutatava sissetuleku (brutopalk + toetused - maksud) lõhe."
      )
    )
  )
}
    
#' gender_pay_gap Server Functions
#'
#' @noRd 
mod_gender_pay_gap_server <- function(id, i18n, results){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    mod_metric_change_server(
      "pay_gap",
      reactive(results()$original$"gender pay gap"),
      reactive(results()$computed$"new pay gap"),
    )

    mod_metric_change_server(
      "disp_ft",
      reactive(results()$original$"disp income gap workers"),
      reactive(results()$computed$"new disp inc gap ft")
    )
    
    mod_metric_change_server(
      "disp",
      reactive(results()$original$"disp income gap all"),
      reactive(results()$computed$"new disp inc gap")
    )
  })
}
