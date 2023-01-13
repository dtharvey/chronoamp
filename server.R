# server for chronoamp

library(shiny)
library(shinythemes)
library(eChem)
source("ladder_pot.R")

# set colors
palette("Okabe-Ito")

shinyServer(function(input,output,session){
  
  ca = reactive({
    out = simulateCA(n = as.numeric(input$n),
               d = 10^(input$diff),
               area = 10^(input$area),
               conc.bulk = 10^(input$conc))
  })
  
  output$i_vs_t = renderPlot({
    
    
    old.par = par(mfrow = c(2,2))
    
    # first plot: ladder diagram 
    ladder_pot(type = "strip",
               pot_limit = c(-0.5,0),
               labels = c(expression("Ox"),
                          expression("Red")),
               buffer = FALSE,
               pot_list = -0.25, electrons = 1,
               species = "Ox/Red", pot_axis = TRUE)
    text(x = 3, y = -0.4, labels = "Ox is reduced to Red", pos = 4)
    text(x = 3, y = -0.1, labels = "Ox is not reduced to Red", pos = 4)
    
    # second plot: potential vs. time
    plot(x = ca()$time, y = ca()$potential, type = "l", col = 6, lwd = 3,
         ylab = "Potential (V)", xlab = "time (s)")
    abline(v = input$time, lty = 2, col = 2, lwd = 2)
    grid()
    
    # third plot: diffusion profiles
    index = which.min(abs(ca()$time - input$time))
    plot(x = ca()$distance, y = ca()$oxdata[index,], 
         type = "l", col = 6, lwd = 3,
         ylim = c(0, ca()$conc.bulk*1000),
         xlab = "distance from electrode (cm)", 
         ylab = "concentration (mM)")
    lines(x = ca()$distance, y = ca()$reddata[index,], 
           type = "l", col = 8, lwd = 3)
    legend(x = "right", legend = c("Ox", "Red"), lwd = 3, col = c(6,8),
           bty = "n")
    grid()
    
    # fourth plot: current vs. time
    plot(x = ca()$time, y = ca()$current, type = "l", col = 6, lwd = 3, 
         xlab = "time (s)", ylab = "current (µA)",
         xlim = c(0,30), 
         ylim = c(min(ca()$current), 0.2 * max(ca()$current)))
    if (input$time > 10){
    arrows(x0 = ca()$time[index], y0 = 0,
           x1 = ca()$time[index], y1 = ca()$current[index],
           code = 3, length = 0.1, angle = 15, col = 2, lwd = 2)
    }
    title(main = paste("Current = ", 
                       format(ca()$current[index], digits = 2, nsmall = 2), 
                       "µA"), col.main = 8, cex.main = 1.25)
    abline(v = input$time, lty = 2, col = 2, lwd = 2)
    grid()
    
    par(old.par)
    
    })
  
}) # close server
