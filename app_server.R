library("shiny")
library("tidyverse")
library("plotly")

data <- read.csv("owid-co2-data.csv") %>%
  filter(iso_code != "")

#--------------------------------
# Summary Information

causes <- c("cement_co2", "flaring_co2", "gas_co2", "oil_co2", "other_industry_co2")

amount_by_cause_year <- function(input_year) {
  year_data  <- data %>%
    filter(year == input_year) %>%
    select(causes) %>%
    colSums(na.rm = TRUE) %>%
    data.frame(causes)
  
    return(rename(year_data, amount = .))
}

change_in_annual <- function(start, end) {
  amount_by_cause_year(start) %>%
    left_join(amount_by_cause_year(end), by = "causes") %>%
    mutate(change = amount.y - amount.x) %>%
    select(causes, change)
}


max_cause <- function(data, colname) {
    data %>%
    filter(colname == max(colname)) %>%
    pull(causes) %>%
    str_remove("_co2")
}

current_year <- max(data$year)

amts_this_year <- amount_by_cause_year(current_year)

largest_amt_this_year <- max(amts_this_year$amount)

total_this_year <- sum(amts_this_year$amount)

cause_this_year <- max_cause(amts_this_year, amts_this_year$amount)

change_10_year <- change_in_annual(current_year - 10, current_year)

largest_change_cause <- max_cause(change_10_year, change_10_year$change) 

largest_change <- max(change_10_year$change)
#---------------------------------

get_data <- function(countries, selected_causes, start, end) {
  data %>%
    select(append(selected_causes, c("country", "year"))) %>%
    filter(country %in% countries) %>%
    filter(year >= start & end >= year) %>%
    pivot_longer(selected_causes, names_to = "cause", values_to = "amount") %>%
    mutate(id = paste(cause, ",", country)) %>%
    select(c(id, year, amount))
    
}

plot_graph <- function(countries, selected_causes, start, end) {
  graph_data <- get_data(countries, selected_causes, start, end)
  #plot <- plot_ly(data = graph_data, x = ~year, y = ~amount, color = ~id)
  #return(plot)
  plot <- ggplot(data = graph_data, aes(x = year, y = amount, color = id)) +
    geom_line() +
    geom_point()
  
  return(ggplotly(plot))
}

server <- function(input, output) {
  output$co2_plot <- renderPlotly({
    plot_graph(input$countries, input$selected_causes, input$years[1], input$years[2])
    })
}