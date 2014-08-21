#setwd('~/Desktop/ubuntu-share/coursera-dataProducts/mtcarsProject')

# ui.R

library(shiny)
shinyUI(fluidPage(
    
    titlePanel("Predicting your car's mpg"),
    
    sidebarLayout(
        
        sidebarPanel(
            # Lets put the controls here
            h3("Options")
            
            ,p("Your car characteristics:") 
            ,hr()
            
            
            ,radioButtons(inputId="xam" 
                         , label = "Transmission:"
                         , choices = list("Automatic" = 0, "Manual" = 1)
                         , selected = 0, inline = FALSE)
            
            ,radioButtons(inputId="xcyl" 
                         , label = "No. of cylinders:"
                         , choices = list(4,6,8)
                         , selected = 4, inline = FALSE)
            
            ,sliderInput(inputId="xwt"
                         , label = "Your car weight (in 1000lbs):"
                         , min = 1.5
                         , max = 5
                         , value = 2.5
                         , step = 0.1)

   #         , actionButton("goButton", "Go!")


        ),
        
        mainPanel(
            tabsetPanel(
                tabPanel("Plot"
                         , p(paste("This model is based off of linear",
                                   "regression of the mtcars dataset using",
                                   "only the weight, cylinders, and",
                                   "transmission. Your car choice will",
                                   "appear on the chart as a green dot.",
                                   "The graph and predicted value will",
                                   "update automatically when a change is",
                                   "made in the inputs in the Options",
                                   "section."))
                         , textOutput("resultHeader")
                         , textOutput("yourResult")
                         , br()
                         , plotOutput("resplot")), 
                tabPanel("Details"
                         , p(paste("Here are the inputs to the model:"))
                         , verbatimTextOutput("summary") 
                         , br()
                         , p(paste("This is the model that was used:"))
                         , verbatimTextOutput("modsummary")
                         , textOutput("modoos") 
                )
            )
        )
    )
))