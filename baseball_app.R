library(shiny)
library(Lahman)
library(dplyr)
library(ggplot2)

#Data Setup
batting <- Batting %>%
  select(
    -playerID,
    -stint,
    -teamID,
    -lgID
  )%>%
  mutate(SLG=((H-X2B-X3B-HR)+2*X2B+3*X3B+4*HR)/AB)%>%
  mutate(AVG=H/AB)

ui <- fluidPage(
  titlePanel("Batting Stats"),
  
  sidebarLayout(
    sidebarPanel(
      
      selectInput("metric", 
                  label = "Which metric would you like to see?",
                  choices = c("AVG",
                              "SLG",
                              "AB",
                              "G", 
                              "R",
                              "H",
                              "X2B",
                              "X3B",
                              "HR",
                              "RBI",
                              "SB",
                              "CS",
                              "BB",
                              "SO",
                              "IBB",
                              "HBP",
                              "SH",
                              "SF",
                              "GIDP"
                  ),
                  selected = "AVG"),
      
      sliderInput("bins",
                  label = "Histogram bins",
                  min = 5, max = 100, value = 50),
      
      selectInput("year",
                  label = "Year",
                  choices=rev(seq(min(batting$yearID),max(batting$yearID)))),
      
      numericInput("min_AB",
                   label = "Minimum At-Bats",
                   value = 5,
                   step = 1,
                   min = 0, max=max(batting$AB))
    ),
    
    mainPanel(
      plotOutput("fig1")
    )
  )
)

server <- function(input, output) {
  output$fig1 <- renderPlot({
    batting%>%
      filter(yearID==input$year)%>%
      filter(AB>input$min_AB)%>%
      select(VAR = input$metric)%>%
      ggplot()+
      geom_histogram(aes(x=VAR),bins=input$bins,fill="darkorchid")+
      xlab(input$metric)
  })
  
}

# Run the app ----
shinyApp(ui = ui, server = server)