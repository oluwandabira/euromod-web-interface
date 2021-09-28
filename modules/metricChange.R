
metricChangeUI <- function(id, title, description, infoToolTip, oldMetricToolTip, newMetricToolTip) {
  ns <- NS(id)
  
  fluidRow(
    column(8,
      metricDescription(title=title,
        description=description,
        infoId=ns("info"),
        infoContent=infoToolTip)
  ),
  column(4, align="center",
    metricUI(ns("oldValue"), oldMetricToolTip),
    greenArrowDown(),
    metricUI(ns("newValue"), newMetricToolTip)
    )
  )
}

metricChangeServer <- function(input, output, session, oldMetric, newMetric) {
  callModule(metricServer, "oldValue", oldMetric)
  callModule(metricServer, "newValue", newMetric)
}
