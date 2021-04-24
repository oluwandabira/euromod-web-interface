source("components\\index.R")

genderWageGapOutput <- function(output_data) {
  renderUI({
    
    # Find new values for indicators
    new_pay_gap <- monthly_gross_pay_gap_ft(output_data)
    
    new_dis_inc_gap_ft <- disposable_income_gap_ft(output_data)
    new_dis_inc_gap <- disposable_income_gap(output_data)
    
    div(
      h4("Töötav elanikkond"),
      fluidRow(
        column(8,
               metricDescription(title="Sooline palgalõhe",
                                 description="Täisajaga töötavate meeste ja naiste brutopalkade lõhe.",
                                 infoId="genderPayGapInfo",
                                 infoContent="Arvutuse aluseks on meeste ja naiste kuine brutopalk.")
        ),
        column(4, align="center",
               div(id = "actualValue",paste(round(GENDER_PAY_GAP_WORKERS,2), "%")),
               bsTooltip(id = "actualValue", title = "Tegelik väärtus",
                         placement = "top", trigger = "hover"),
               greenArrowDown(),
               div(id="newValue", paste(round(new_pay_gap,2), "%")),
               bsTooltip(id = "newValue", title = "Ennustatatud uus väärtus",
                         placement = "top", trigger = "hover"),
        )
      ),
      br(),
      fluidRow(
        column(8,
               metricDescription(title="Kättesaadava sissetuleku sooline lõhe",
                                 description="Täisajaga töötavate meeste ja naiste kasutatava sissetuleku (brutopalk + toetused - maksud) lõhe.",
                                 infoId="dispIncGapFTInfo",
                                 infoContent="Arvutuse aluseks on meeste ja naiste kuine brutopalk.")
        ),
        column(4, align="center",
               div(paste(round(DISP_INCOME_GAP_WORKERS,2), "%")),
               greenArrowDown(),
               div(paste(round(new_dis_inc_gap_ft,2), "%")),
        )
      ),
      br(),
      h4("Kogu elanikkond"),
      fluidRow(
        column(8,
               metricDescription(title="Kättesaadava sissetuleku sooline lõhe",
                                 description="Positiivse sissetulekuga meeste ja naiste kasutatava sissetuleku (brutopalk + toetused - maksud) lõhe.",
                                 infoId="dispIncGapInfo",
                                 infoContent="Arvutuse aluseks on meeste ja naiste kuine brutopalk.")
        ),
        column(4, align="center",
               div(paste(round(DISP_INCOME_GAP_ALL,2), "%")),
               greenArrowDown(),
               div(paste(round(new_dis_inc_gap,2), "%")),
        )
      ),
    )
    
  })
}
