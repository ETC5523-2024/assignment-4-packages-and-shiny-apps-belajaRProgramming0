#' Launch the Shiny App
#'
#' This function launches the Olympics Data Explorer Shiny app.
#' @export
launch_app <- function() {
  appDir <- system.file("shiny_app", package = "rafliassign4")
  if (appDir == "") {
    stop("Could not find the Shiny app directory. Please check the path.")
  }
  shiny::runApp(appDir)
}
