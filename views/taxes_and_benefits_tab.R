source("components\\index.R")
source("translate.R")

formatMoney <- function(value) {
  return(paste("€", formatC(round(value), big.mark=',', format = 'd')))
}

taxesAndBenefitsOutput <- function(output_data, i18n) {
  renderUI({
    
    # Taxes
    
    new_social_tax <- get_social_taxes_paid(output_data)
    social_tax_change <- percentageChange(SOCIAL_TAX_PAID, new_social_tax)
    new_income_tax <- get_income_taxes_paid(output_data)
    income_tax_change <- percentageChange(INCOME_TAX_PAID, new_income_tax)
    total_tax_change <- percentageChange(SOCIAL_TAX_PAID + INCOME_TAX_PAID, new_social_tax + new_income_tax)
    
    taxes_table <- data.frame("Maks"=c(i18n$t("Sotsiaalmaks"), i18n$t("Tulumaks"), i18n$t("Kokku")), 
                              "Tegelik maksutulu" = c(formatMoney(SOCIAL_TAX_PAID), formatMoney(INCOME_TAX_PAID), formatMoney(SOCIAL_TAX_PAID + INCOME_TAX_PAID)), 
                              "Ennustatav summa" = c(formatMoney(new_social_tax), formatMoney(new_income_tax), formatMoney(new_social_tax + new_income_tax)),
                              "Muutus"=c(formatPercentageChange(social_tax_change),
                                         formatPercentageChange(income_tax_change),
                                         formatPercentageChange(total_tax_change)))
    names(taxes_table) <- c(i18n$t("Maks"), i18n$t("Tegelik maksutulu"), i18n$t("Ennustatav maksutulu"), i18n$t("Muutus"))
    
    # Benefits
    
    new_subsistence_benefits <- get_subsistence_benefit_received(output_data)
    subsistence_benefit_change <- percentageChange(SUBSISTENCE_BENEFIT_RECEIVED, new_subsistence_benefits)
    new_all_benefits <- get_benefits_received(output_data)
    total_benefits_change <- percentageChange(ALL_BENEFITS_RECEIVED, new_all_benefits)
    other_benefits_change <- percentageChange(ALL_BENEFITS_RECEIVED - SUBSISTENCE_BENEFIT_RECEIVED, new_all_benefits - new_subsistence_benefits)
    
    benefits_table <- data.frame("Toetus"=c(i18n$t("Toimetulekutoetus"), i18n$t("Muud toetused"), i18n$t("Kokku")), 
                              "Tegelik kulu" = c(formatMoney(SUBSISTENCE_BENEFIT_RECEIVED), formatMoney(ALL_BENEFITS_RECEIVED - SUBSISTENCE_BENEFIT_RECEIVED), formatMoney(ALL_BENEFITS_RECEIVED)), 
                              "Ennustatav kulu" = c(formatMoney(new_subsistence_benefits), formatMoney(new_all_benefits - new_subsistence_benefits), formatMoney(new_all_benefits)),
                              "Muutus"=c(formatPercentageChange(subsistence_benefit_change),
                                         formatPercentageChange(other_benefits_change),
                                         formatPercentageChange(total_benefits_change)))
    names(benefits_table) <- c(i18n$t("Toetus"), i18n$t("Tegelik kulu"), i18n$t("Ennustatav kulu"), i18n$t("Muutus"))
    
    # Pay
    
    new_private_pay_expense <- get_private_pay_expense(output_data)
    private_pay_change <- percentageChange(PRIVATE_PAY_EXPENSE, new_private_pay_expense)
    new_public_pay_expense <- get_public_pay_expense(output_data)
    public_pay_change <- percentageChange(PUBLIC_PAY_EXPENSE, new_public_pay_expense)
    new_all_pay <- new_private_pay_expense + new_public_pay_expense
    total_pay_change <- percentageChange(PRIVATE_PAY_EXPENSE + PUBLIC_PAY_EXPENSE, new_all_pay)

    pay_expense_table <- data.frame("Sektor"=c(i18n$t("Avalik sektor"), i18n$t("Erasektor"), i18n$t("Kokku")), 
                                 "Tegelik palgakulu" = c(formatMoney(PUBLIC_PAY_EXPENSE), formatMoney(PRIVATE_PAY_EXPENSE), formatMoney(PRIVATE_PAY_EXPENSE + PUBLIC_PAY_EXPENSE)), 
                                 "Ennustatav palgakulu" = c(formatMoney(new_public_pay_expense), formatMoney(new_private_pay_expense), formatMoney(new_all_pay)),
                                 "Muutus"=c(formatPercentageChange(public_pay_change),
                                            formatPercentageChange(private_pay_change),
                                            formatPercentageChange(total_pay_change)))
    names(pay_expense_table) <- c(i18n$t("Sektor"), i18n$t("Tegelik palgakulu"), i18n$t("Ennustatav palgakulu"), i18n$t("Muutus"))
    
    
    div(
      br(),
      h4(i18n$t("Riigi tööjõumaksutulu ja kulutused toetustele")),
      br(),
      fluidRow(
        column(8,
               strong(i18n$t("Laekuvad tööjõumaksud"))
        ),
        column(4, align="center",
               div(id = "actualValue", formatPercentageChange(total_tax_change), changeArrow(total_tax_change))
        )
      ),
      br(),
      fluidRow(
        column(11,
               renderTable(taxes_table, width="100%", striped=TRUE)
        ),
      ),
      br(),
      fluidRow(
        column(8,
               strong(i18n$t("Väljamakstavad toetused"))
        ),
        column(4, align="center",
               div(id = "actualValue",formatPercentageChange(total_benefits_change), changeArrow(total_benefits_change))
        )
      ),
      br(),
      fluidRow(
        column(11,
               renderTable(benefits_table, width="100%", striped=TRUE)
        ),
      ),
      br(),
      br(),
      h4(i18n$t("Ettevõtete kulutused")),
      br(),
      fluidRow(
        column(8,
               strong(i18n$t("Palgakulu ettevõtetele"))
        ),
        column(4, align="center",
               div(id = "actualValue",formatPercentageChange(total_pay_change), changeArrow(total_pay_change)),
               
        )
      ),
      br(),
      fluidRow(
        column(11,
               renderTable(pay_expense_table, width="100%", striped=TRUE)
        ),
      ),
      br(),
      br(),
      strong(i18n$t("Selgitused")),
      p(i18n$t("Kõik arvud on näidatud keskmiselt ühe kuu kohta."))
    )
    
  })
}
