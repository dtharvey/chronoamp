# user interface for chronoamperometry module

# use library() to load packages used in app
# at a minimum this will be the shiny and the shinythemes packages
# add others as needed

library(shiny)
library(shinythemes)
library(eChem)


# the code below creates the app's user interface, which consists of
# a navbar page and at least three tabpanels: an introduction, an 
# activity, and a wrap-up; additional activity tabPanels can be added

ui = navbarPage("AC 3.0: Chronoamperometry",
     theme = shinytheme("journal"),
     header = tags$head(
       tags$link(rel = "stylesheet",
                 type = "text/css",
                 href = "style.css") # link to css file in www folder
     ),
     
     tabPanel("Introduction",
      fluidRow(
        column(width = 6, # left column that holds text
          wellPanel(
            includeHTML("text/introduction.html") # link to introduction
      )),
        column(width = 6, # right column that holds visualizations
          align = "center",
          br(), # code that creates html tags for new line
          plotOutput("intro_plot", height = "700px") # output to server
          )
      )), # close introduction tabPanel
     
     tabPanel("Typical Experiment",
      fluidRow(
        column(width = 6,
          wellPanel(
            includeHTML("text/typical_expt.html")
      )),
        column(width = 6,
          align = "center",
          splitLayout(
            #place controls here
            sliderInput("act1_time", "time (s)",
                        min = 0, max = 20, step = 1,
                        value = 0, ticks = FALSE,
                        animate = TRUE,
                        animationOptions(interval = 25))
          ),
          plotOutput("act1_plot", height = "600px")
          )
      )), # close activity tabPanel
     
     tabPanel("Cottrell Equation",
      fluidRow(
        column(width = 6,
          wellPanel(includeHTML("text/cottrell.html")
            )),
        column(width = 6,
          align = "center",
            splitLayout(
              radioButtons("n","n",
                           choices = c(1,2,3), selected = 1),
              radioButtons("A", "A", 
                           choices = c(0.005, 0.010, 0.020), selected = 0.010),
              radioButtons("D","D",
                           choices = c(5e-6,1e-5,2e-5), selected = 1e-5),
              radioButtons("C","C",
                           choices = c(0.0005,0.001,0.002), selected = 0.001)
            ),
          plotOutput("act2_plot", height = "600px")
          ),
       
      )),
     
     tabPanel("Related Experiments",
              fluidRow(
                column(width = 6,
                       wellPanel(
                         includeHTML("text/related_expts.html")
                       )),
                column(width = 6,
                       align = "center",
                       splitLayout(
                         #place controls here
                         sliderInput("kcf", "forward chemical rate constant",
                                     min = 10, max = 500, step = 10,
                                     value = 10, ticks = FALSE,
                                     animate = TRUE,
                                     )
                       ),
                       plotOutput("act3_plota", height = "250px"),
                       hr(),
                       sliderInput("act3_time", "time (s)",
                                   min = 0, max = 20, step = 1,
                                   value = 0, ticks = FALSE,
                                   animate = TRUE,
                                   animationOptions(interval = 25)),
                       plotOutput("act3_plotb", height = "250px")
                )
              )), # close activity tabPanel
     
     tabPanel("Wrapping Up",
      fluidRow(
        column(width = 6,
               wellPanel(id = "wrapuppanel",
                  style = "overflow-y:scroll; max-height: 750px",
                  includeHTML("text/wrapup.html"))),
        column(width = 6,
          align = "center",
          plotOutput("wrapup_plot1", height = "700px"),
          )
          
      )) # close wrapping up tabPanel
     
     ) # close navbarpage
