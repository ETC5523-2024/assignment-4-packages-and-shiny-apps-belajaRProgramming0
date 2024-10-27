library(shiny)

ui <- fluidPage(
  titlePanel("Olympics Data Explorer"),
  sidebarLayout(
    sidebarPanel(
      selectInput("sport", "Select a Sport:", choices = c("Athletics", "Swimming"))
    ),
    mainPanel(
      textOutput("selected_sport")
    )
  )
)

server <- function(input, output) {
  output$selected_sport <- renderText({
    paste("You selected:", input$sport)
  })
}

shinyApp(ui = ui, server = server)
