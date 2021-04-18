
povertyOutput <- function(output_data, output_data_nxt) {
  renderUI({
    
    # Find new values for indicators
    new_absolute_poverty_rate <- absolute_poverty_rate(ABSOLUTE_POVERTY_LINE_2018, output_data)
    new_absolute_poverty_rate_nxt <- absolute_poverty_rate(ABSOLUTE_POVERTY_LINE_2019, output_data_nxt)
    
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
               div(id = "actualValue",paste(round(ABSOLUTE_POVERTY_RATE_2018,2), "%")),
               bsTooltip(id = "actualValue", title = "Tegelik vĆ¤Ć¤rtus",
                         placement = "left", trigger = "hover"),
               greenArrowDown(),
               div(id="newValue", paste(round(new_absolute_poverty_rate,2), "% (2018)")),
               bsTooltip(id = "newValue", title = "Ennustatatud uus vĆ¤Ć¤rtus",
                         placement = "left", trigger = "hover"),
               greenArrowDown(),
               div(id="newValue", paste(round(new_absolute_poverty_rate_nxt,2), "% (2019)")),
               bsTooltip(id = "newValue", title = "Ennustatatud uus vĆ¤Ć¤rtus",
                         placement = "left", trigger = "hover"),
        )
      ),
    )
    
  })
}
