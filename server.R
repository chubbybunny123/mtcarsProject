#setwd('~/Desktop/ubuntu-share/coursera-dataProducts/irisProject')

## works locally!!

# server.R

library(shiny)
library(datasets)
library(ggplot2)
#library(caret)
data(mtcars)

# put the helper functions here
inTrain <- sample(1:length(mtcars$mpg), size=floor(0.6*length(mtcars$mpg))
                   , replace=FALSE)
training <- mtcars[inTrain,]
testing <- mtcars[-inTrain,]

# trctrl <- trainControl(method = "cv"
#                        , number = 10, repeats = 5
#                        , savePred = FALSE)

 modfit <- lm(mpg ~ wt + factor(cyl) + factor(am)
             , data = training
            )

fitcoef <- summary(modfit)$coef[,1]
pred <- predict(modfit, newdata=testing)
oosError <- mean(abs(pred-testing$mpg))/100

# shiny server stuff goes here
shinyServer(
    function(input, output) {
        output$feedback <- renderText({

        })
        
        # update values from the inputs
        testvals <- reactive({
            df <- data.frame('cyl' = input$xcyl
                             , 'wt' = input$xwt, 'am' = input$xam)
            return(df)
        })
        
        
        predResults <- reactive({
            blah <- predict(modfit, newdata = testvals())
            return(blah)
        })

         dataToPlot <- reactive({
             df <- data.frame('cyl' = input$xcyl
                              , 'wt' = input$xwt
                              , 'am' = input$xam
                               , 'mpg' = predResults()
             )
             return(df)             
         })
        
         output$resplot <- renderPlot({
             g <- (ggplot(data = training, aes(x=wt, y=mpg))
                   + geom_point(size = 3, aes(color=factor(am), shape=factor(cyl)))
                   + geom_abline(intercept = fitcoef[1], slope = fitcoef[2]
                                , color = 'gray') # 4cyl, auto
                   + geom_abline(intercept = fitcoef[1]+fitcoef[5]
                                , slope = fitcoef[2]
                                , color = 'gray') # 4cyl, man
                   + geom_abline(intercept = fitcoef[1]+fitcoef[3]
                                , slope = fitcoef[2]
                                , color = 'gray') # 6cyl, auto
                   + xlab("Weight (/1000lbs)")
                   + ylab("Miles per Gallon")
                   + ggtitle("Linear Regression of MPG vs Weight")
                   + scale_colour_discrete(name = "Transmission type"
                                          ,breaks = c(0, 1)
                                          ,labels = c("Automatic", "Manual"))
                   + scale_shape_discrete(name = "No. of cylinders")
              )
             
             print(g + geom_point(data=dataToPlot(), aes(x=wt, y=mpg)
                                  , color="green"
                                  , size = 5) )
                 
         })
        
        output$resultHeader <- renderText({
            "Your estimated fuel performance is"
        })

        output$yourResult <- renderText({
            paste(round(predResults(),1), "mpg")
        })
        
         output$summary <- renderPrint({
             dataToPlot()
         })
        
        output$modsummary <- renderPrint({
            summary(modfit)
        })
        
        output$modoos <- renderText({
            paste("This model has an out of sample error of:"
                  , round(oosError,3))
        })
     }
 )
