# R/launchapp.R

#' Launch the Shiny App
#'
#' This function launches the Shiny app contained in the package.
#' @export
launch_app <- function() {
  shiny::runApp(system.file("shiny", package = "rafliassign4"))
}
