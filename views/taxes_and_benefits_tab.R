source("components\\index.R")

taxesAndBenefitsOutput <- function(output_data) {
  renderUI({
    
    # Find new values for indicators
    new_social_tax <- get_social_taxes_paid(output_data)
    new_income_tax <- get_income_taxes_paid(output_data)
    taxes_table <- data.frame("Maks"=c("Sotsiaalmaks", "Tulumaks", "Kokku"), 
                              "Tegelik maksutulu" = c(new_social_tax, new_income_tax, new_social_tax + new_income_tax), 
                              "Ennustatav summa" = c(new_social_tax, new_income_tax, new_social_tax + new_income_tax),
                              "Muutus"=c(1,1,1))
    
    names(taxes_table) <- c("Maks", "Tegelik maksutulu", "Ennustatav summa", "Muutus")
    
    new_subsistence_benefits <- get_subsistence_benefit_received(output_data)
    new_all_benefits <- get_benefits_received(output_data)

    benefits_table <- data.frame("Toetus"=c("Toimetulekutoetus", "Muud toetused", "Kokku"), 
                              "Tegelik kulu" = c(new_subsistence_benefits, new_all_benefits - new_subsistence_benefits, new_all_benefits), 
                              "Ennustatav kulu" = c(new_subsistence_benefits, new_all_benefits - new_subsistence_benefits, new_all_benefits),
                              "Muutus"=c(1,1,1))
    names(benefits_table) <- c("Maks", "Tegelik kulu", "Ennustatav kulu", "Muutus")
    
    div(
      h4("Riigi tööjõumaksutulu ja kulutused toetustele"),
      fluidRow(
        column(8,
               strong("Laekuvad tööjõumaksud")
        ),
        column(4, align="center",
               div(id = "actualValue",paste(round(GENDER_PAY_GAP_WORKERS,2), "%"), redArrowUp()),
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
               div(id = "actualValue",paste(round(GENDER_PAY_GAP_WORKERS,2), "%"), redArrowUp()),
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
