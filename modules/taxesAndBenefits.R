


formatMoney <- function(value) {
  paste("€", formatC(round(value), big.mark = ',', format = 'd'))
}

formatPercentageChange <- function(value) {
  prefix = if (value < 0)
    ""
  else
    "+"
  return(paste(prefix, round(value, 2), "%", sep = ""))
}

taxesAndBenefitsUI <- function(id, i18n) {
  ns <- NS(id)
  
  div(
    br(),
    h4(i18n$t(
      "Riigi tööjõumaksutulu ja kulutused toetustele"
    )),
    br(),
    fluidRow(column(8,
                    strong(
                      i18n$t("Laekuvad tööjõumaksud")
                    )),
             column(4, align = "center", metricUI(
               ns("taxChange"), i18n$t("Tegelik väärtus")
             ))),
    br(),
    fluidRow(column(11, tableOutput(ns(
      "taxes"
    )))),
    br(),
    fluidRow(column(8,
                    strong(
                      i18n$t("Väljamakstavad toetused")
                    )),
             column(4, align = "center", metricUI(
               ns("benefitsChange"), i18n$t("Tegelik väärtus")
             ))),
    fluidRow(column(11, tableOutput(ns(
      "benefits"
    ))))
  )
}

taxesAndBenefitsServer <-
  function(input, output, session, results, i18n) {
    taxes_table <- reactive({
      r <- results()
      # i18n translation doesn't work here, should change to server side translation.
      data.frame(
        "Maks" = c(
          i18n()$t("Sotsiaalmaks"),
          i18n()$t("Tulumaks"),
          i18n()$t("Kokku")
        ),
        "Tegelik maksutulu" = c(
          formatMoney(r$original$social.tax.paid),
          formatMoney(r$original$income.tax.paid),
          formatMoney(r$original$social.tax.paid + r$original$income.tax.paid)
        ),
        "Ennustatav summa" = c(
          formatMoney(r$computed$new.social.tax),
          formatMoney(r$computed$new.income.tax),
          formatMoney(r$computed$new.social.tax + r$computed$new.income.tax)
        ),
        "Muutus" = c(
          formatPercentageChange(r$computed$subsistence.benefit.change),
          formatPercentageChange(r$computed$other.benefits.change),
          formatPercentageChange(r$computed$total.benefits.change)
        )
      )
    })
    
    benefits_table <- reactive({
      r <- results()
      
      data.frame(
        "Toetus" = c(
          i18n()$t("Toimetulekutoetus"),
          i18n()$t("Muud toetused"),
          i18n()$t("Kokku")
        ),
        "Tegelik kulu" = c(
          formatMoney(r$original$subsistence.benefit.received),
          formatMoney(
            r$original$all.benefits.received - r$original$subsistence.benefit.received
          ),
          formatMoney(r$original$all.benefits.received)
        ),
        "Ennustatav kulu" = c(
          formatMoney(r$computed$new.subsistence.benefits),
          formatMoney(
            r$computed$new.all.benefits - r$computed$new.subsistence.benefits
          ),
          formatMoney(r$computed$new.all.benefits)
        ),
        "Muutus" = c(
          formatPercentageChange(r$computed$subsistence.benefit.change),
          formatPercentageChange(r$computed$other.benefits.change),
          formatPercentageChange(r$computed$total.benefits.change)
        )
      )
    })
    
    callModule(metricServer,
               "taxChange",
               reactive(results()$computed$total.tax.change))
    callModule(
      metricServer,
      "benefitsChange",
      reactive(results()$computed$total.benefits.change)
    )
    
    output$taxes <-
      renderTable(taxes_table(), width = "100%", striped = TRUE)
    
    output$benefits <-
      renderTable(benefits_table(), width = "100%", striped = TRUE)
  }