# ui for chronoamp

library(shiny)
library(shinythemes)
library(eChem)

ui = navbarPage("Analytical Chemistry 3.0",
                theme = shinytheme("journal"),
          #       tags$head(
          #         tags$link(rel = "stylesheet",
          #                   type = "text/css",
          #                   href = "style.css")
          # ),
              tabPanel("Chronoamperometry", 
                fluidRow(
                  column(width = 6,
                    wellPanel(id = "tPanel",
                              style = "overflow-y:scroll; max-height: 750px",
                      includeHTML("chronoamp.html")
          )     
          ),
                  column(width = 6,
                         align = "center",
                    splitLayout(
                      sliderInput("area","log(area) (cm^2)",
                                  min = -3, max = -1, value = -2,
                                  width = "200px", step = 0.1),
                      sliderInput("conc","log([Ox]) (M)",
                                  min = -4, max = -2, value = -3,
                                  width = "200px", step = 0.1),
                      sliderInput("diff","log(diff coef) (cm^2/s)",
                                  min = -6, max = -4, value = -5,
                                  width = "200px", step = 0.1)
          ),
                    splitLayout(
                      radioButtons("n","number of electrons",
                                   choices = c("1", "2", "3"), 
                                   selected = "1", inline = FALSE,
                                   width = "150px"),
                      sliderInput("time","time", 
                                  min = 0, max = 30, step = 0.5,
                                  value = 0, width = "200px",
                                  animate = TRUE,
                                  animationOptions(interval = 100))
          ),
                    plotOutput("i_vs_t", height = "550px")
          )
          )
          
          
          
          )
)
