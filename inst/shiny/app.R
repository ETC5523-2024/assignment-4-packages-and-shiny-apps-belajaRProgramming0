# app.R or Shiny App file

# Load required libraries
library(shiny)
library(dplyr)
library(DT)
library(ggplot2)

# Load the cleaned data from the package
data("cleaned_data", package = "rafliassign4")

# UI of the app
ui <- fluidPage(
  titlePanel("Olympic Data Explorer"),

  sidebarLayout(
    sidebarPanel(
      tabsetPanel(
        id = "sidebar_tabs",  # Add an ID for the tabsetPanel
        tabPanel("Controls",
                 # Dropdown for attribute filtering
                 selectInput(
                   "attr",
                   "Select Attribute:",
                   choices = c("ANA", "FLX", "HAN", "NER", "PWR", "SPD",
                               "STR", "END", "DUR", "AGI"),
                   selected = "ANA"
                 ),

                 # Year range slider
                 sliderInput(
                   "year_range",
                   "Select Year Range:",
                   min = 1948,
                   max = 2016,
                   value = c(1948, 2016),
                   step = 4,
                   animate = animationOptions(interval = 1000)
                 )
        ),
        tabPanel("Attribute Meanings",
                 # Attribute meanings table
                 DTOutput("attribute_table")
        )
      )
    ),

    mainPanel(
      # Conditional rendering: show boxplot only when "Controls" tab is active
      conditionalPanel(
        condition = "input.sidebar_tabs == 'Controls'",
        plotOutput("boxplot_output")
      )
    )
  )
)

# Define server logic
server <- function(input, output) {
  # Load cleaned data from the package
  data("cleaned_data", package = "rafliassign4")

  # Attribute meanings data
  attribute_data <- data.frame(
    Primary_Attribute = c("ANA", "HAN", "DUR", "NER", "STR",
                          "END", "PWR", "AGI", "SPD", "FLX"),
    Attribute_Name = c("Analytic Aptitude", "Hand-eye Coordination",
                       "Durability", "Nerve", "Strength",
                       "Endurance", "Power", "Agility",
                       "Speed", "Flexibility")
  )

  # Reactive filtering based on inputs
  filtered_data <- reactive({
    cleaned_data %>%
      filter(
        Year >= input$year_range[1] & Year <= input$year_range[2],
        Top_1_attr == input$attr | Top_2_attr == input$attr | Top_3_attr == input$attr
      )
  })

  # Render the attribute meanings table without search bar
  output$attribute_table <- renderDT({
    datatable(
      attribute_data,
      options = list(
        pageLength = 5,
        searching = FALSE  # Disable the search bar
      ),
      caption = "Attribute Abbreviations and their Meanings"
    )
  })

  # Render the boxplot based on filtered data
  output$boxplot_output <- renderPlot({
    data <- filtered_data()

    if (nrow(data) == 0) {
      plot.new()
      title("No Data Available for the Selected Criteria")
      return()
    }

    ggplot(data, aes(x = Sport, y = Age)) +
      geom_boxplot() +
      labs(
        title = paste("Age Distribution by Sport for", input$attr, "Attribute"),
        x = "Sport",
        y = "Age"
      ) +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  })
}

# Run the app
shinyApp(ui = ui, server = server)
