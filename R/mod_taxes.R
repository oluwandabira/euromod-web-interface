#' taxes UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_taxes_ui <- function(id, i18n) {
  ns <- NS(id)
  div(
    br(),
    h4(i18n$t(
      "Riigi tööjõumaksutulu ja kulutused toetustele"
    )),
    br(),
    fluidRow(
      column(8,
             strong(i18n$t(
               "Laekuvad tööjõumaksud"
             ))),
      column(4, align = "center", mod_metric_ui(ns("tax_change")))
    ),
    br(),
    fluidRow(column(11, tableOutput(ns(
      "taxes"
    )))),
    br(),
    fluidRow(
      column(8,
             strong(i18n$t(
               "Väljamakstavad toetused"
             ))),
      column(4, align = "center", mod_metric_ui(ns(
        "benefits_change"
      )))
    ),
    br(),
    fluidRow(column(11, tableOutput(ns(
      "benefits"
    ))))
  )
}

#' taxes Server Functions
#'
#' @noRd
mod_taxes_server <- function(id, i18n, results) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    taxes_table <- reactive({
      r <- results()
      i18n <- i18n()
      dataframe <- data.frame(
        "Maks" = c(
          i18n$t("Sotsiaalmaks"),
          i18n$t("Tulumaks"),
          i18n$t("Kokku")
        ),
        "Tegelik maksutulu" = c(
          format_money(r$original$"social tax paid"),
          format_money(r$original$"income tax paid"),
          format_money(
            r$original$"social tax paid"+r$original$"income tax paid"
          )
        ),
        "Ennustatav summa" = c(
          format_money(r$computed$"new social tax"),
          format_money(r$computed$"new income tax"),
          format_money(r$computed$"new social tax"+r$computed$"new income tax")
        ),
        "Muutus" = c(
          format_change(r$computed$"subsistence benefit change"),
          format_change(r$computed$"other benefits change"),
          format_change(r$computed$"total benefits change")
        )
      )
      names(dataframe) <-
        c(
          i18n$t("Maks"),
          sprintf("%s (€)", i18n$t("Tegelik maksutulu")),
          sprintf("%s (€)", i18n$t("Ennustatav maksutulu")),
          sprintf("%s (%%)", i18n$t("Muutus"))
        )
      dataframe
    })
    
    benefits_table <- reactive({
      r <- results()
      i18n <- i18n()
      dataframe <- data.frame(
        "Toetus" = c(
          i18n$t("Toimetulekutoetus"),
          i18n$t("Muud toetused"),
          i18n$t("Kokku")
        ),
        "Tegelik kulu" = c(
          format_money(r$original$"subsistence benefit received"),
          format_money(
            r$original$"all benefits received"-r$original$"subsistence benefit received"
          ),
          format_money(r$original$"all benefits received")
        ),
        "Ennustatav kulu" = c(
          format_money(r$computed$"new subsistence benefits"),
          format_money(
            r$computed$"new all benefits"-r$computed$"new subsistence benefits"
          ),
          format_money(r$computed$"new all benefits")
        ),
        "Muutus" = c(
          format_change(r$computed$"subsistence benefit change"),
          format_change(r$computed$"other benefits change"),
          format_change(r$computed$"total benefits change")
        )
      )
      names(dataframe) <-
        c(
          i18n$t("Toetus"),
          sprintf("%s (€)", i18n$t("Tegelik kulu")),
          sprintf("%s (€)", i18n$t("Ennustatav kulu")),
          sprintf("%s (%%)", i18n$t("Muutus"))
        )
      dataframe
    })
    
    mod_metric_server("tax_change",
                      reactive(results()$computed$"total tax change"))
    
    mod_metric_server("benefits_change",
                      reactive(results()$computed$"total benefits change"))
    
    output$taxes <-
      renderTable(taxes_table(), width = "100%", striped = TRUE)
    
    output$benefits <-
      renderTable(benefits_table(), width = "100%", striped = TRUE)
  })
}
