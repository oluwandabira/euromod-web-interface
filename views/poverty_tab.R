library(CGPfunctions)

povertyOutput <- function(output_data, output_data_nxt) {
  renderUI({
    # Find new values for indicators
    new_absolute_poverty_rate <- absolute_poverty_rate(ABSOLUTE_POVERTY_LINE_2018, output_data)
    new_absolute_poverty_rate_nxt <- absolute_poverty_rate(ABSOLUTE_POVERTY_LINE_2019, output_data_nxt)
    
    relative_poverty_line <- relative_poverty_line(output_data)
    new_relative_poverty_rate <-relative_poverty_rate(relative_poverty_line, output_data)
    new_relative_poverty_rate_nxt <- relative_poverty_rate(relative_poverty_line, output_data_nxt)
    hh_poverty_rates <- poverty_rates_by_hh(output_data, output_data_nxt)
    
    div(
      h4("Kogu elanikkond"),
      fluidRow(
        column(8,
               strong("Absoluutse vaesuse määr"),
               span(id="infoPayGap", icon("info-circle", "fa")),
               bsTooltip(id = "infoPayGap", title = "TODO",
                         placement = "bottom", trigger = "hover"),
               p("Nende elanike osatähtsus, kelle sissetulek jääb alla elatusmiinimumi.")
               
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
      br(),
      fluidRow(
        column(8,
               strong("Suhtelise vaesuse määr"),
               span(id="infoPayGap", icon("info-circle", "fa")),
               bsTooltip(id = "infoPayGap", title = "TODO",
                         placement = "bottom", trigger = "hover"),
               p("Nende elanike osatähtsus, kelle ekvivalentnetosissetulek on allpool suhtelise vaesuse piiri. ")
               
        ),
        column(4, align="center",
               div(id = "actualValue",paste(round(RELATIVE_POVERTY_RATE_2018,2), "%")),
               bsTooltip(id = "actualValue", title = "Tegelik vĆ¤Ć¤rtus",
                         placement = "left", trigger = "hover"),
               greenArrowDown(),
               div(id="newValue", paste(round(new_relative_poverty_rate,2), "% (2018)")),
               bsTooltip(id = "newValue", title = "Ennustatatud uus vĆ¤Ć¤rtus",
                         placement = "left", trigger = "hover"),
               greenArrowDown(),
               div(id="newValue", paste(round(new_relative_poverty_rate_nxt,2), "% (2019)")),
               bsTooltip(id = "newValue", title = "Ennustatatud uus vĆ¤Ć¤rtus",
                         placement = "left", trigger = "hover"),
        )
      ),
      br(),
      renderPlot(
        newggslopegraph(dataframe = hh_poverty_rates,
                        Times = Scenario,
                        Measurement = AbsolutePoverty,
                        Grouping = Household,
                        Title = "Absoluutse vaesuse määra muutus",
                        SubTitle = "Leibkondade kaupa")
      ),
      # br(),
      # renderPlot(
      #   newggslopegraph(dataframe = hh_poverty_rates,
      #                   Times = Scenario,
      #                   Measurement = RelativePoverty,
      #                   Grouping = Household,
      #                   Title = "Suhtelise vaesuse määra muutus",
      #                   SubTitle = "Leibkondade kaupa")
      # ),
    )
    
  })
}
