mainUI <- function(id, i18n) {
  ns <- NS(id)
  div(
    titlePanel(i18n$t("Miinimumpalga tõusu mõju palgalõhele")),
    fluidRow(column(
      2,
      offset = 10,
      selectInput(
        ns("language"),
        label = NULL,
        choices = list("Eesti keel" = "ee",
                       "In English" = "en"),
        selected = i18n$get_key_translation()
      )
    )),
    sidebarLayout(
      sidebarPanel(
        div(
          i18n$t(
            "Rakendus ennustab miinimumpalga muutuse esmast mõju sotsiaalsetele näitajatele, eeldusel, et muud näitajad jäävad samaks."
          )
        ),
        br(),
        uiOutput(ns("inputPanel")),
        actionButton(ns("run"), i18n$t("Arvuta"))
      ),
      mainPanel(tabsetPanel(
        type = "tabs",
        tabPanel(i18n$t("Palgalõhe"),
                 genderPayGapUI(ns("genderPayGap"), i18n)),
        tabPanel(i18n$t("Vaesus"), povertyUI(ns("poverty"), i18n)),
        tabPanel(
          i18n$t("Maksud ja toetused"),
          taxesAndBenefitsUI(ns("taxesBenefits"), i18n)
        )
      ))
    )
    
  )
}

mainServer <-
  function(input,
           output,
           session,
           original,
           results,
           household_results, translator) {
    
    observeEvent(input$language, ignoreInit = TRUE, {
      update_lang(session, input$language)
    })
    
    i18n <- reactive({
      translator$set_translation_language(input$language)
      translator
    })
    
    
    output$inputPanel <- renderUI({
      i18n <- i18n()
      mwage <- isolate(input$minWage)
      year <- isolate(input$year)
      
      results <- results()
      
      #req(input$year)
      
      if (is.null(year)) {
        year <- max(results$year)
      }
      
      computed <- results %>% filter(.data$year == .env$year)
      
      if (is.null(mwage)) {
        mwage <- min(computed$minwage)
      }
      
      div(
        numericInput("minWage",
                     i18n$t("Sisesta miinimumpalk (bruto)"),
                     mwage),
        selectInput(
          "year",
          i18n$t("Rakendumise aasta"),
          selected = year,
          unique(data_dump$year)
        )
      )
    })
    
    observeEvent(input$run, {
      message("Running ", input$run)
      message("Observed raw minwage and year: ", input$minWage,"/", input$year)
      mwage <- input$minWage
      year <- input$year
      
      results <- results()
      
      req(year)
      # if (is.null(year)) {
      #   year <- min(results$year)
      # }
      # 
      computed <- results %>% filter(.data$year == .env$year)
      
      # if (is.null(mwage)) {
      #   mwage <- min(computed$minwage)
      # }
      
      message("Observed minwage and year: ", mwage,"/", year)
      
      computed_household <-
        household_results() %>% filter(.data$year == .env$year)
      
      original <- original() %>% filter(.data$year == .env$year)
      
      r <- reactive(list(
        "computed" = computed %>% filter(.data$minwage == .env$mwage),
        "computed_household" = computed_household %>% filter(.data$minwage == .env$mwage),
        "original" = original
      ))
      
      callModule(genderPayGapServer, "genderPayGap", r)
      callModule(povertyServer, "poverty", r, i18n)
      callModule(taxesAndBenefitsServer, "taxesBenefits", r, i18n)
    })
  }