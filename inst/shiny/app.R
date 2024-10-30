# app.R or Shiny App file

# Load required libraries
library(shiny)
library(dplyr)

# Load the cleaned data
load("data/cleaned_data.rda")

# Define UI for the app
ui <- fluidPage(
  titlePanel("Olympic Medal Records Explorer"),

  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "country",
        label = "Select Country:",
        choices = unique(cleaned_data$reg),
        selected = unique(cleaned_data$reg)[1]
      ),
      selectInput(
        inputId = "year",
        label = "Select Year:",
        choices = unique(cleaned_data$Year),
        selected = unique(cleaned_data$Year)[1]
      )
    ),

    mainPanel(
      tableOutput("filtered_table")
    )
  )
)

# Define server logic
server <- function(input, output) {
  # Reactive expression to filter data based on inputs
  filtered_data <- reactive({
    cleaned_data %>%
      filter(reg == input$country & Year == input$year)
  })

  # Render filtered table
  output$filtered_table <- renderTable({
    filtered_data()
  })
}

# Run the app
shinyApp(ui = ui, server = server)
