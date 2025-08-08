# user interface for chronoamperometry module

ui = navbarPage("AC 3.0: Chronoamperometry",
     theme = shinytheme("journal"),
     header = tags$head(
       tags$link(rel = "stylesheet",
                 type = "text/css",
                 href = "style.css") # link to css file in www folder
     ),
     
# tabpanel for introduction
     tabPanel("Introduction",
      fluidRow(withMathJax(),
        column(width = 6, # left column that holds text
          wellPanel(
            class = "scrollable-well",
            div(class = "html-fragment",
            includeHTML("text/introduction.html")
      ))),
        column(width = 6, # right column that holds visualizations
          align = "center",
          br(), 
          plotOutput("intro_plot", height = "600px") 
          )
      )), # close introduction tabPanel
     
# tabpanel for first activity
     tabPanel("Typical Experiment",
      fluidRow(
        column(width = 6,
               wellPanel(
                 class = "scrollable-well",
                 div(class = "html-fragment",
                     includeHTML("text/activity1.html")
                 ))),
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
          plotOutput("act1_plot", height = "500px")
          )
      )), # close first activity tabPanel
     
# tabpanel for second activity
     tabPanel("Cottrell Equation",
      fluidRow(
        column(width = 6,
               wellPanel(
                 class = "scrollable-well",
                 div(class = "html-fragment",
                     includeHTML("text/activity2.html")
                 ))),
        column(width = 6,
          align = "center",
            splitLayout(
              radioButtons("n","n",
                           choices = c(1,2,3), 
                           selected = 2),
              radioButtons(inputId = "A", 
                           label = HTML(paste0("A (cm",tags$sup("2"),")")), 
                           choices = c(0.005, 0.010, 0.020), 
                           selected = 0.010),
              radioButtons(inputId = "D", 
                           label = HTML(paste0("D (cm",tags$sup("2"),"/s)")),
                           choices = c(5e-6,1e-5,2e-5), 
                           selected = 1e-5),
              radioButtons(inputId = "C",
                           label = HTML(paste0("C (M)")),
                           choices = c(0.0005,0.001,0.002), 
                           selected = 0.001)
            ),
          plotOutput("act2_plot", height = "500px")
          )
       
      )), # close second activity tabpanel 
     
# tabpanel for third activity
     tabPanel("Double-Step Chronoamperometry",
              fluidRow(
                column(width = 6,
                       wellPanel(
                          class = "scrollable-well",
                         div(class = "html-fragment",
                             includeHTML("text/activity3.html")
                         ))),
                column(width = 6,
                       align = "center",
                       splitLayout(
                         #place controls here
                         sliderInput("t2", "time of pulse 2",
                                     min = 12, max = 20,
                                     step = 1, value = 20,
                                     ticks = FALSE),
                         sliderInput("kcf", 
                                     "rate constant for chemical step",
                                     min = 0, max = 5, step = 0.1,
                                     value = 0, ticks = FALSE
                                     )
                       ),
                       plotOutput("act3plot", height = "500px")

                )
              )), # close third activity tabPanel
     
# tabpanel for fourth activity
     tabPanel("Chronocoulometry",
      fluidRow(
        column(width = 6,
               wellPanel(
                 class = "scrollable-well",
                 div(class = "html-fragment",
                     includeHTML("text/activity4.html")
                 ))),
        column(width = 6,
               align = "center",
               sliderInput("cctime", "time (s)",
                           min = 0, max = 20, step = 1,
                           value = 0, ticks = FALSE,
                           animate = TRUE, 
                           animationOptions(interval = 25)),
               plotOutput("act4plot", height = "500px")
      ))), # close tabpanel for fourth activity
     
# tabpanel for wrapping-up
     tabPanel("Wrapping Up",
      fluidRow(
        column(width = 6,
               wellPanel(
                 class = "scrollable-well",
                 div(class = "html-fragment",
                     includeHTML("text/wrapup.html")
                 ))),
        column(width = 6,
          align = "center",
          plotOutput("wrapup_plot1", height = "600px")
          )
          
      )) # close wrapping-up tabPanel
     
     ) # close navbarpage
