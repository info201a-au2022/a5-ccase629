library("shiny")
library("plotly")

countries <- unique(data$country)

graph_side <- sidebarPanel(
  selectInput(
    "countries",
    "Countries",
    countries,
    multiple = TRUE,
    selected = "United States"
  ),
  selectInput(
    "selected_causes",
    "Causes",
    causes,
    multiple = TRUE,
    selected = causes
  ),
  sliderInput(
    "years",
    "Time",
    min = min(data$year),
    max = max(data$year),
    value = c(min(data$year), max(data$year))
  )
)

graph_main <- mainPanel(
  plotlyOutput("co2_plot"),
  h3("Findings"),
  p("In the majority of countries, currently and historically, oil related industry is the largest source of 
    co2. This was true for both developed and developing nations, though there were some differences between the two.
    Developed nations tend to produce much more co2 and started producing earlier than developing, and in
    developed nations the second highest source is likely to be gas, whereas in developing nations there is
    a much more even spread.")
)

intro_panel <- tabPanel(
  "Introduction",
  h1("Introduction"),
  p("Climate change caused by rising greenhouse gas levels is a major concern for global health and safety.
    Specifically, rising carbon dioxide levels due to industry are rapidly accelerating the pace of
    global climate change."),
  p("Global industry is a huge source of co2. This year", round(total_this_year, 0), "million metric tones of co2 were released into the 
    atmosphere by global industry. This, however, is a simpification. Of that figure", round(largest_amt_this_year, 0), "million metric
    tons were released by industry related to oil. This also changes over time, industries related to", largest_change_cause, "are producing",
    round(largest_change, 0), "million metric tones of co2 more annually now than ten years ago."),
  p("In this report, I will examine the different industrial sources of co2 across the globe, in different types of industry, and in developed
    and developing nations, to examine global trends in the production of co2.")
  )

graph_panel <- tabPanel("Graph", sidebarLayout(graph_side, graph_main))

ui <- fluidPage(
  tabsetPanel(
    intro_panel,
    graph_panel
  )
)