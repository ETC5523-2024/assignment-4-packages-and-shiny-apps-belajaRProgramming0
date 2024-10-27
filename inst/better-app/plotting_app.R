library(shiny)
library(ggplot2)
library(dplyr)

# Load cleaned data (from your package)
data("olym_final", package = "rafliassign4")

# Define UI (User Interface)
ui <- fluidPage(
  titlePanel("Olympics Data Explorer"),

  sidebarLayout(
    sidebarPanel(
      selectInput("sport", "Select a Sport:", choices = unique(olym_final$Sport)),
      sliderInput("year", "Select Year Range:",
                  min = min(olym_final$Year), max = max(olym_final$Year),
                  value = c(2000, 2020))
    ),

    mainPanel(
      plotOutput("sportPlot"),  # Output for the plot
      verbatimTextOutput("summary")  # Output for summary statistics
    )
  )
)

# Define Server Logic
server <- function(input, output) {

  # Reactive expression: Filter data based on user inputs
  filtered_data <- reactive({
    olym_final %>%
      filter(Sport == input$sport, Year >= input$year[1], Year <= input$year[2])
  })

  # Generate the plot
  output$sportPlot <- renderPlot({
    ggplot(filtered_data(), aes(x = Year, y = Top_1_value, color = Top_1_attr)) +
      geom_line() +
      labs(title = paste("Trend for", input$sport), y = "Top Attribute Value")
  })

  # Generate a summary of the filtered data
  output$summary <- renderPrint({
    summary(filtered_data())
  })
}

# Run the application
shinyApp(ui = ui, server = server)
