source("components\\index.R")

formatMoney <- function(value) {
  return(paste("€", formatC(round(value), big.mark=',', format = 'd')))
}

taxesAndBenefitsOutput <- function(output_data) {
  renderUI({
    
    new_social_tax <- get_social_taxes_paid(output_data)
    social_tax_change <- percentageChange(SOCIAL_TAX_PAID, new_social_tax)
    new_income_tax <- get_income_taxes_paid(output_data)
    income_tax_change <- percentageChange(INCOME_TAX_PAID, new_income_tax)
    total_tax_change <- percentageChange(SOCIAL_TAX_PAID + INCOME_TAX_PAID, new_social_tax + new_income_tax)
    
    taxes_table <- data.frame("Maks"=c("Sotsiaalmaks", "Tulumaks", "Kokku"), 
                              "Tegelik maksutulu" = c(formatMoney(SOCIAL_TAX_PAID), formatMoney(INCOME_TAX_PAID), formatMoney(SOCIAL_TAX_PAID + INCOME_TAX_PAID)), 
                              "Ennustatav summa" = c(formatMoney(new_social_tax), formatMoney(new_income_tax), formatMoney(new_social_tax + new_income_tax)),
                              "Muutus"=c(formatPercentageChange(social_tax_change),
                                         formatPercentageChange(income_tax_change),
                                         formatPercentageChange(total_tax_change)))
    names(taxes_table) <- c("Maks", "Tegelik maksutulu", "Ennustatav summa", "Muutus")
    
    new_subsistence_benefits <- get_subsistence_benefit_received(output_data)
    subsistence_benefit_change <- percentageChange(SUBSISTENCE_BENEFIT_RECEIVED, new_subsistence_benefits)
    new_all_benefits <- get_benefits_received(output_data)
    total_benefits_change <- percentageChange(ALL_BENEFITS_RECEIVED, new_all_benefits)
    other_benefits_change <- percentageChange(ALL_BENEFITS_RECEIVED - SUBSISTENCE_BENEFIT_RECEIVED, new_all_benefits - new_subsistence_benefits)
    
    benefits_table <- data.frame("Toetus"=c("Toimetulekutoetus", "Muud toetused", "Kokku"), 
                              "Tegelik kulu" = c(formatMoney(SUBSISTENCE_BENEFIT_RECEIVED), formatMoney(ALL_BENEFITS_RECEIVED - SUBSISTENCE_BENEFIT_RECEIVED), formatMoney(ALL_BENEFITS_RECEIVED)), 
                              "Ennustatav kulu" = c(formatMoney(new_subsistence_benefits), formatMoney(new_all_benefits - new_subsistence_benefits), formatMoney(new_all_benefits)),
                              "Muutus"=c(formatPercentageChange(subsistence_benefit_change),
                                         formatPercentageChange(other_benefits_change),
                                         formatPercentageChange(total_benefits_change)))
    names(benefits_table) <- c("Toetus", "Tegelik kulu", "Ennustatav kulu", "Muutus")
    
    div(
      h4("Riigi tööjõumaksutulu ja kulutused toetustele"),
      fluidRow(
        column(8,
               strong("Laekuvad tööjõumaksud")
        ),
        column(4, align="center",
               div(id = "actualValue", formatPercentageChange(total_tax_change), changeArrow(total_tax_change)),
               bsTooltip(id = "actualValue", title = "Tegelik väärtus",
                         placement = "top", trigger = "hover"),
              
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
               strong("Väljamakstavad toetused")
        ),
        column(4, align="center",
               div(id = "actualValue",formatPercentageChange(total_benefits_change), changeArrow(total_benefits_change)),
               bsTooltip(id = "actualValue", title = "Tegelik väärtus",
                         placement = "top", trigger = "hover"),
               
        )
      ),
      br(),
      fluidRow(
        column(11,
               renderTable(benefits_table, width="100%", striped=TRUE)
        ),
      ),
    )
    
  })
}
