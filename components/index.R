library(dplyr)

greenArrowDown <- function() {
  tags$i(
    id = "actualValue",
    class = "fa fa-arrow-down", 
    style = "color: rgb(0,166,90)"
  )
}

metricDescription <- function(title, description, infoId, infoContent) {
  div(
    strong(title),
    p(description,
      span(id = infoId, icon("question-circle", "far", "font-awesome"))),
    bsTooltip(id = infoId, title = infoContent,
              placement = "bottom", trigger = "hover")
  )
}