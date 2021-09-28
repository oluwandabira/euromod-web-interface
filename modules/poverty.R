

povertyUI <- function(id, i18n) {
  ns <- NS(id)
  
  div(
    br(),
    h4(i18n$t("Töötav elanikkond")),
    br(),
    metricChangeUI(ns("newInWorkPoverty"),
                   i18n$t("Palgavaesuse määr"),
                   i18n$t("Nende elanike osatähtsus, kes on vaesuses vaatamata sellele, et käivad tööl."),
                   i18n$t("Palgavaesus näitab, mitu protsenti töötavatest inimestest on suhtelises vaesuses, ehk nende ekvivalentnetosissetulek on allpool suhtelise vaesuse piiri."),
                   i18n$t("Tegelik väärtus"),
                   i18n$t("Ennustatatud uus väärtus")
                   )
  )
}

povertyServer <- function(input, output, session, results) {
  callModule(metricChangeServer, "newInWorkPoverty",
             reactive(results()$original$in.work.poverty),
             reactive(results()$computed$new.in.work.poverty.rate))
}