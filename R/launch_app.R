# R/launchapp.R

# R/launch_app.R
#' Launch the Shiny App
#' @export
launch_app <- function() {
  shiny::runApp(system.file("shiny", package = "rafliassign4"))
}

