povertyUI <- function(id, i18n) {
  ns <- NS(id)
  
  div(
    br(),
    h4(i18n$t("Töötav elanikkond")),
    br(),
    metricChangeUI(
      ns("inWorkPoverty"),
      i18n$t("Palgavaesuse määr"),
      i18n$t(
        "Nende elanike osatähtsus, kes on vaesuses vaatamata sellele, et käivad tööl."
      ),
      i18n$t(
        "Palgavaesus näitab, mitu protsenti töötavatest inimestest on suhtelises vaesuses, ehk nende ekvivalentnetosissetulek on allpool suhtelise vaesuse piiri."
      ),
      i18n$t("Tegelik väärtus"),
      i18n$t("Ennustatatud uus väärtus")
    ),
    h4(i18n$t("Kogu elanikkond")),
    br(),
    metricChangeUI(
      ns("relativePovertyRate"),
      i18n$t("Suhtelise vaesuse määr"),
      i18n$t("Nende elanike osatähtsus, kes on suhtelises vaesuses."),
      i18n$t(
        "Suhtelise vaesuse määr näitab, mitu protsenti kogu elanikkonnast on suhtelises vaesuses, ehk nende ekvivalentnetosissetulek on allpool suhtelise vaesuse piiri."
      ),
      i18n$t("Tegelik väärtus"),
      i18n$t("Ennustatatud uus väärtus")
    ),
    metricChangeUI(
      ns("absolutePovertyRate"),
      i18n$t("Absoluutse vaesuse määr"),
      i18n$t(
        "Nende elanike osatähtsus, kelle sissetulek jääb alla elatusmiinimumi."
      ),
      i18n$t(
        "Absoluutse vaesuse määr näitab, mitu protsenti kogu elanikkonnast on absoluutses vaesuses, ehk nende ekvivalentnetosissetulek on allpool elatusmiinimumi."
      ),
      i18n$t("Tegelik väärtus"),
      i18n$t("Ennustatatud uus väärtus")
    )
  )
}

povertyServer <- function(input, output, session, results) {
  callModule(
    metricChangeServer,
    "inWorkPoverty",
    reactive(results()$original$in.work.poverty),
    reactive(results()$computed$new.in.work.poverty.rate)
  )
  
  callModule(
    metricChangeServer,
    "relativePovertyRate",
    reactive(results()$original$relative.poverty.rate),
    reactive(results()$computed$new.relative.poverty.rate)
  )
  
  callModule(
    metricChangeServer,
    "absolutePovertyRate",
    reactive(results()$original$abs.poverty.rate),
    reactive(results()$computed$new.abs.poverty.rate)
  )
}