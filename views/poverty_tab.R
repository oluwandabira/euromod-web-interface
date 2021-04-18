
povertyOutput <- function(output_data) {
  renderUI({
    
    # Find new values for indicators
    new_pay_gap <- monthly_gross_pay_gap_ft(output_data)
    new_dis_inc_gap_ft <- disposable_income_gap_ft(output_data)
    new_dis_inc_gap <- disposable_income_gap(output_data)
    
    div(
      h4("Kogu elanikkond"),
      fluidRow(
        column(8,
               strong("Absoluutse vaesuse määr"),
               span(id="infoPayGap", icon("info-circle", "fa")),
               bsTooltip(id = "infoPayGap", title = "TODO",
                         placement = "bottom", trigger = "hover"),
               p("TODO")
               
        ),
        column(4, align="center",
               div(id = "actualValue",paste(round(GENDER_PAY_GAP_WORKERS,2), "%")),
               bsTooltip(id = "actualValue", title = "Tegelik vĆ¤Ć¤rtus",
                         placement = "left", trigger = "hover"),
               greenArrowDown(),
               div(id="newValue", paste(round(new_pay_gap,2), "% (2018)")),
               bsTooltip(id = "newValue", title = "Ennustatatud uus vĆ¤Ć¤rtus",
                         placement = "left", trigger = "hover"),
               greenArrowDown(),
               div(id="newValue", paste(round(new_pay_gap,2), "% (2019)")),
               bsTooltip(id = "newValue", title = "Ennustatatud uus vĆ¤Ć¤rtus",
                         placement = "left", trigger = "hover"),
        )
      ),
    )
    
  })
}
