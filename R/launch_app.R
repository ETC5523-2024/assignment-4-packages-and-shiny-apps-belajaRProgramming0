#' Launch the Shiny App
#'
#' @export
launch_app <- function() {
  shiny::runApp(system.file("plotting_app", package = "rafliassign4"))
}
