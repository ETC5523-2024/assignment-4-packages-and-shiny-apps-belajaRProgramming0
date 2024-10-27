library(shiny)
library(ggplot2)
library(plotly)

# Sample ggplot for demonstration
plot_gg <- ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point() +
  labs(title = "Car Mileage vs. Weight")

# Define UI for the app
ui <- fluidPage(
  titlePanel("GGPlot to Plotly Conversion"),
  plotlyOutput("plotlyPlot")
)

# Define server logic
server <- function(input, output) {
  output$plotlyPlot <- renderPlotly({
    ggplotly(plot_gg)  # Convert ggplot to plotly
  })
}

# Run the application
shinyApp(ui = ui, server = server)
