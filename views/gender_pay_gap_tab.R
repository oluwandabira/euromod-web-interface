source("components\\index.R")
#source("translate.R")

genderWageGapOutput <- function(output_data) {
  renderUI({
    # Find new values for indicators
    #new_pay_gap <- monthly_gross_pay_gap_ft(output_data)
    new_pay_gap <- hourly_gross_pay_gap(output_data)
    new_dis_inc_gap_ft <- disposable_income_gap_ft(output_data)
    new_dis_inc_gap <- disposable_income_gap(output_data)
    
    div(
      br(),
      h4(i18n$t("Töötav elanikkond")),
      fluidRow(
        column(8,
               metricDescription(title=i18n$t("Sooline palgalõhe"),
                                 description=i18n$t("Täisajaga töötavate meeste ja naiste brutotunnipalkade lõhe."),
                                 infoId="genderPayGapInfo",
                                 infoContent=i18n$t("Palgalõhe näitab, mitu protsenti on naiste brutotunnipalk meeste omast madalam."))
        ),
        column(4, align="center",
               div(id = "actualValue1",paste(round(GENDER_PAY_GAP_WORKERS,2), "%")),
               bsTooltip(id = "actualValue1", title = i18n$t("Tegelik väärtus"),
                         placement = "top", trigger = "hover"),
               greenArrowDown(),
               div(id="newValue1", paste(round(new_pay_gap,2), "%")),
               bsTooltip(id = "newValue1", title = i18n$t("Ennustatatud uus väärtus"),
                         placement = "top", trigger = "hover"),
        )
      ),
      br(),
      fluidRow(
        column(8,
               metricDescription(title=i18n$t("Kättesaadava sissetuleku sooline lõhe"),
                                 description=i18n$t("Täisajaga töötavate meeste ja naiste kasutatava sissetuleku (brutopalk + toetused - maksud) lõhe."),
                                 infoId="dispIncGapFTInfo",
                                 infoContent=i18n$t("Arv näitab, mitu protsenti on naiste kuus kättesaadav sissetulek meeste omast madalam."))
        ),
        column(4, align="center",
               div(id = "actualValue2",paste(round(DISP_INCOME_GAP_WORKERS,2), "%")),
               bsTooltip(id = "actualValue2", title = i18n$t("Tegelik väärtus"),
                         placement = "top", trigger = "hover"),
               greenArrowDown(),
               div(id="newValue2", paste(round(new_dis_inc_gap_ft,2), "%")),
               bsTooltip(id = "newValue2", title = i18n$t("Ennustatatud uus väärtus"),
                         placement = "top", trigger = "hover"),
        )
      ),
      br(),
      h4(i18n$t("Kogu elanikkond")),
      fluidRow(
        column(8,
               metricDescription(title=i18n$t("Kättesaadava sissetuleku sooline lõhe"),
                                 description=i18n$t("Positiivse sissetulekuga meeste ja naiste kasutatava sissetuleku (brutopalk + toetused - maksud) lõhe."),
                                 infoId="dispIncGapInfo",
                                 infoContent=i18n$t("Arv näitab, mitu protsenti on naiste kuus kättesaadav sissetulek meeste omast madalam."))
        ),
        column(4, align="center",
               div(id = "actualValue3",paste(round(DISP_INCOME_GAP_ALL,2), "%")),
               bsTooltip(id = "actualValue3", title = i18n$t("Tegelik väärtus"),
                         placement = "top", trigger = "hover"),
               greenArrowDown(),
               div(id="newValue3", paste(round(new_dis_inc_gap,2), "%")),
               bsTooltip(id = "newValue3", title = i18n$t("Ennustatatud uus väärtus"),
                         placement = "top", trigger = "hover"),
        )
      ),
    )
    
  })
}
