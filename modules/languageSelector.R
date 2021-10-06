
languageSelectorUI <- function(id) {
  fluidRow(column(
    2,
    offset = 10,
    selectInput(
      "language",
      label = NULL,
      choices = list("Eesti keel" = "ee",
                     "In English" = "en"),
      selected = translator$get_key_translation()
    )
  ))
}

languageSelectorServer <- function(input, output, session) {
  
}