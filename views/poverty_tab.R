library(CGPfunctions)

povertyOutput <- function(output_data, i18n) {
  renderUI({
    # Find new values for indicators
    new_absolute_poverty_rate <- absolute_poverty_rate(ABSOLUTE_POVERTY_LINE_2018, output_data)

    relative_poverty_line <- relative_poverty_line(output_data)
    new_relative_poverty_rate <-relative_poverty_rate(relative_poverty_line, output_data)
    new_in_work_poverty_rate <- in_work_poverty_rate(relative_poverty_line, output_data)
    hh_poverty_rates <- poverty_rates_by_hh(output_data, relative_poverty_line, i18n)
    
    div(
      br(),
      h4(i18n$t("Töötav elanikkond")),
      br(),
      fluidRow(
        column(8,
               metricDescription(title=i18n$t("Palgavaesuse määr"),
                                 description=i18n$t("Nende elanike osatähtsus, kes on vaesuses vaatamata sellele, et käivad tööl."),
                                 infoId="inWorkPovertyRateInfo",
                                 infoContent=i18n$t("Palgavaesus näitab, mitu protsenti töötavatest inimestest on suhtelises vaesuses, ehk nende ekvivalentnetosissetulek on allpool suhtelise vaesuse piiri."))
        ),
        column(4, align="center",
               div(id = "actualValueIWP",paste(round(RELATIVE_POVERTY_RATE_2018,2), "%")),
               bsTooltip(id = "actualValueIWP", title = i18n$t("Tegelik väärtus"),
                         placement = "left", trigger = "hover"),
               greenArrowDown(),
               div(id="newValueIWP", paste(round(new_in_work_poverty_rate,2), "%")),
               bsTooltip(id = "newValueIWP", title = i18n$t("Ennustatatud uus väärtus"),
                         placement = "left", trigger = "hover"),
        )
      ),
      h4(i18n$t("Kogu elanikkond")),
      br(),
      fluidRow(
        column(8,
               metricDescription(title=i18n$t("Suhtelise vaesuse määr"),
                                 description=i18n$t("Nende elanike osatähtsus, kelle ekvivalentnetosissetulek on allpool suhtelise vaesuse piiri."),
                                 infoId="relPovertyRateInfo",
                                 infoContent="TODO")
        ),
        column(4, align="center",
               div(id = "actualValue",paste(round(RELATIVE_POVERTY_RATE_2018,2), "%")),
               bsTooltip(id = "actualValue", title = i18n$t("Tegelik väärtus"),
                         placement = "left", trigger = "hover"),
               greenArrowDown(),
               div(id="newValue", paste(round(new_relative_poverty_rate,2), "%")),
               bsTooltip(id = "newValue", title = i18n$t("Ennustatatud uus väärtus"),
                         placement = "left", trigger = "hover"),
        )
      ),
      br(),
      fluidRow(
        column(8,
               metricDescription(title=i18n$t("Absoluutse vaesuse määr"),
                                 description=i18n$t("Nende elanike osatähtsus, kelle sissetulek jääb alla elatusmiinimumi."),
                                 infoId="absPovertyRateInfo",
                                 infoContent="TODO")
        ),
        column(4, align="center",
               div(id = "actualValue",paste(round(ABSOLUTE_POVERTY_RATE_2018,2), "%")),
               bsTooltip(id = "actualValue", title = i18n$t("Tegelik väärtus"),
                         placement = "left", trigger = "hover"),
               greenArrowDown(),
               div(id="newValue", paste(round(new_absolute_poverty_rate,2), "%")),
               bsTooltip(id = "newValue", title = i18n$t("Ennustatatud uus väärtus"),
                         placement = "left", trigger = "hover"),
        )
      ),
      br(),
      fluidRow(
        column(11, align="center",
          renderPlot(
            newggslopegraph(dataframe = hh_poverty_rates,
                            Times = Scenario,
                            Measurement = AbsolutePoverty,
                            Grouping = Household,
                            Title = i18n$t("Absoluutse vaesuse määra muutus"),
                            SubTitle = i18n$t("Leibkondade kaupa"),
                            YTextSize = 4,
                            DataTextSize = 4,
                            Caption=NULL)
          ),
        ),
      ),
      br(),
      fluidRow(
        column(11, align="center",
          renderPlot(
            newggslopegraph(dataframe = hh_poverty_rates,
                            Times = Scenario,
                            Measurement = RelativePoverty,
                            Grouping = Household,
                            Title = i18n$t("Suhtelise vaesuse määra muutus"),
                            SubTitle = i18n$t("Leibkondade kaupa"),
                            YTextSize = 4,
                            DataTextSize = 4,
                            Caption=NULL)
          ),
        ),
      ),
    )
    
  })
}
