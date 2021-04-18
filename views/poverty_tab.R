
povertyOutput <- function(output_data) {
  renderUI({
    
    # Find new values for indicators
    new_pay_gap <- monthly_gross_pay_gap_ft(output_data)
    new_dis_inc_gap_ft <- disposable_income_gap_ft(output_data)
    new_dis_inc_gap <- disposable_income_gap(output_data)
    
    div(
      h4("TĆ¶Ć¶tav elanikkond"),
      fluidRow(
        column(8,
               strong("Sooline palgalĆµhe"),
               span(id="infoPayGap", icon("info-circle", "fa")),
               bsTooltip(id = "infoPayGap", title = "Arvutuse aluseks on meeste ja naiste kuine brutopalk.",
                         placement = "bottom", trigger = "hover"),
               p("TĆ¤isajaga tĆ¶Ć¶tavate meeste ja naiste brutopalkade lĆµhe.")
               
        ),
        column(4,
               div(id = "actualValue",paste(round(GENDER_PAY_GAP_WORKERS,2), "%")),
               bsTooltip(id = "actualValue", title = "Tegelik vĆ¤Ć¤rtus",
                         placement = "left", trigger = "hover"),
               icon("arrow-down", "fa"),
               div(id="newValue", paste(round(new_pay_gap,2), "%")),
               bsTooltip(id = "newValue", title = "Ennustatatud uus vĆ¤Ć¤rtus",
                         placement = "left", trigger = "hover"),
        )
      ),
      br(),
      fluidRow(
        column(8,
               strong("KĆ¤ttesaadava sissetuleku sooline lĆµhe"),
               span(id="infoDispIncFT", icon("info-circle", "fa")),
               bsTooltip(id = "infoDispIncFT", title = "Arvutuse aluseks on meeste ja naiste kuine brutopalk.",
                         placement = "bottom", trigger = "hover"),
               p("TĆ¤isajaga tĆ¶Ć¶tavate meeste ja naiste kasutatava sissetuleku (brutopalk + toetused - maksud) lĆµhe.")
               
        ),
        column(4,
               div(paste(round(DISP_INCOME_GAP_WORKERS,2), "%")),
               icon("arrow-down", "fa"),
               div(paste(round(new_dis_inc_gap_ft,2), "%")),
        )
      ),
      br(),
      h4("Kogu elanikkond"),
      fluidRow(
        column(8,
               strong("KĆ¤ttesaadava sissetuleku sooline lĆµhe"),
               span(id="infoDispInc", icon("info-circle", "fa")),
               bsTooltip(id = "infoDispInc", title = "Arvutuse aluseks on meeste ja naiste kuine brutopalk.",
                         placement = "bottom", trigger = "hover"),
               p("Positiivse sissetulekuga meeste ja naiste kasutatava sissetuleku (brutopalk + toetused - maksud) lĆµhe.")
               
        ),
        column(4,
               div(paste(round(DISP_INCOME_GAP_ALL,2), "%")),
               icon("arrow-down", "fa"),
               div(paste(round(new_dis_inc_gap,2), "%")),
        )
      ),
    )
    
  })
}
