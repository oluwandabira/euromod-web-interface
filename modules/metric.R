#' Create a UI element representing a percentage metric with a tooltip
#' @param id ID string of module.
#' @param toolTip String content of the tooltip.
metricUI <- function(id, toolTip) {
  ns <- NS(id)
  div(div(id = ns("valueID"), textOutput(ns("value"))),
      # This tooltip will display a jumbled mess because Translator$translate
      # returns a html span element and bsToolTip expects a string as content
      bsTooltip(ns("valueID"), toolTip, "top", "hover"))
}

metricServer <- function(input, output, session, metric) {
  output$value <- renderText(paste(round(metric(), 2), "%"))
}