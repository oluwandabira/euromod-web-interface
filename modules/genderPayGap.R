

genderPayGapUI <- function(id, i18n) {
  ns <- NS(id)
  div(
    br(),
    h4(i18n$t("Töötav elanikkond")),
    br(),
    metricChangeUI(
      ns("payGap"),
      i18n$t("Sooline palgalõhe"),
      i18n$t("Täisajaga töötavate meeste ja naiste brutotunnipalkade lõhe."),
      i18n$t(
        "Palgalõhe näitab, mitu protsenti on naiste brutotunnipalk meeste omast madalam."
      ),
      i18n$t("Tegelik väärtus"),
      i18n$t("Ennustatatud uus väärtus")
    ),
    br(),
    metricChangeUI(
      ns("dispIncGapFT"),
      i18n$t("Kättesaadava sissetuleku sooline lõhe"),
      i18n$t(
        "Täisajaga töötavate meeste ja naiste kasutatava sissetuleku (brutopalk + toetused - maksud) lõhe."
      ),
      i18n$t(
        "Arv näitab, mitu protsenti on naiste kuus kättesaadav sissetulek meeste omast madalam."
      ),
      i18n$t("Tegelik väärtus"),
      i18n$t("Ennustatatud uus väärtus")
    ),
    br(),
    metricChangeUI(
      ns("dispIncGap"),
      i18n$t("Kättesaadava sissetuleku sooline lõhe"),
      i18n$t(
        "Positiivse sissetulekuga meeste ja naiste kasutatava sissetuleku (brutopalk + toetused - maksud) lõhe."
      ),
      i18n$t(
        "Arv näitab, mitu protsenti on naiste kuus kättesaadav sissetulek meeste omast madalam."
      ),
      i18n$t("Tegelik väärtus"),
      i18n$t("Ennustatatud uus väärtus")
    )
  )
}

genderPayGapServer <- function(input, output, session, results) {
  callModule(
    metricChangeServer,
    "payGap",
    reactive(results()$original$gender.pay.gap),
    reactive(results()$computed$new.pay.gap)
  )
  callModule(
    metricChangeServer,
    "dispIncGapFT",
    reactive(results()$original$disp.income.gap.workers),
    reactive(results()$computed$new.disp.inc.gap.ft)
  )
  callModule(
    metricChangeServer,
    "dispIncGap",
    reactive(results()$original$disp.income.gap.all),
    reactive(results()$computed$new.disp.inc.gap)
  )
}