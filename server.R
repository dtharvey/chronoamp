# server for chronoamp

library(shiny)
library(shinythemes)
library(eChem)
source("R/ladder_pot.R")

# set colors
palette("Okabe-Ito")

# data for application
introCA = simulateCA(t.1 = 10, t.end = 20)
doubleCA = simulateCA(mechanism = "E", pulses = "double",
                      t.1 = 0.001, t.2 = 0.003, t.end = 0.005,
                      kcf = 0, t.units = 2000)

shinyServer(function(input,output,session){
  
  ca = reactive({
    out = simulateCA(n = as.numeric(input$n),
               d = 10^(input$diff),
               area = 10^(input$area),
               conc.bulk = 10^(input$conc))
  })
  
  output$intro_plot = renderPlot({

    old.par = par(mfrow = c(2,2))
    # ladder diagram
    plot(x = -1, y = -1,
         xlim = c(0,10), xlab = "", ylab = "potential (V)", xaxt = "n",
         ylim = c(introCA$initialE+introCA$pulseE,introCA$initialE),
         main = "ladder diagram", bty = "n", 
         cex.lab = 1.25, cex.main = 1.25, cex.axis = 1.25)
    legend(x = "topright", legend = c("Ox","Red"),
           fill = c(2,3), bty = "n", cex = 1.25)
    rect(xleft = 1, ybottom = introCA$initialE+introCA$pulseE,
         xright = 3, ytop = introCA$formalE, 
         col = 3)
    rect(xleft = 1, ybottom = introCA$formalE,
         xright = 3, ytop = introCA$initialE, 
         col = 2)
    text(x = 3.1, y = -0.02, "[Ox] > [Red]", pos = 4, cex = 1.25)
    text(x = 3.1, y = -0.06, "Red is oxidized to Ox", pos = 4, cex = 1.25)
    text(x = 3.1, y = -0.48, "[Red] > [Ox]", pos = 4, cex = 1.25)
    text(x = 3.1, y = -0.44, "Ox is reduced to Red", pos = 4, cex = 1.25)
    lines(x = c(0,4), y = c(-0.25,-0.25), lty = 3, lwd = 3)
    text(x = 4, y = -0.25, "formal potential", pos = 4, cex = 1.25)
    
    # potential profile
    plot(x = introCA$time, y = introCA$potential, type = "l", 
         lwd = 4, col = 6,
         xlab = "time (s)", ylab = "potential (V)",
         main = "applied potential profile",
         cex.lab = 1.25, cex.main = 1.25, cex.axis = 1.25)
    text(x = 5, y = -0.025, "1", adj = 0.5, cex = 2)
    text(x = 10.1, y = -0.25, "2", pos = 4, cex = 2)
    text(x = 15, y = -0.47, "3", adj = 0.5, cex = 2)
    grid()
    
    # diffusion profile
    plot(x = introCA$distance, y = introCA$oxdata[1,], type = "l",
         lwd = 4, col = 2, xlab = "distance from electrode (cm)",
         ylab = "concentration (mM)", ylim = c(0,1),
         main = "diffusion profiles",
         cex.lab = 1.25, cex.main = 1.25, cex.axis = 1.25)
    lines(x = introCA$distance, y = introCA$reddata[1,], lty = 1,
          col = 3, lwd = 4)
    lines(x = introCA$distance, y = introCA$reddata[2001,], lty = 3,
          col = 3, lwd = 4)
    lines(x = introCA$distance, y = introCA$oxdata[2001,], lty = 3,
          col = 2, lwd = 4)
    legend(x = "right", 
           legend = c("Ox (initial)","Red (initial)", "Ox (end)", "Red (end)"),
           col = c(2,3,2,3), lwd = 4, lty = c(1,1,3,3), bty = "n", cex = 1.25)
    grid()
    
    # current profile
    plot(x = introCA$time, y = introCA$current, type = "l",
         lwd = 4, col = 6, xlab = "time (s)", ylab = "current (µA)",
         main = "current profile",
         cex.lab = 1.25, cex.main = 1.25, cex.axis = 1.25)
    grid()
    par(old.par)
    
    })
  
  output$act1_plot = renderPlot({
    
    old.par = par(mfrow = c(2,2))
    # ladder diagram
    index = which.min(abs(introCA$time - input$act1_time))
    plot(x = -1, y = -1,
         xlim = c(0,10), xlab = "", ylab = "potential (V)", xaxt = "n",
         ylim = c(introCA$initialE+introCA$pulseE,introCA$initialE),
         main = "ladder diagram", bty = "n", 
         cex.lab = 1.25, cex.main = 1.25, cex.axis = 1.25)
    legend(x = "topright", legend = c("Ox","Red"),
           fill = c(2,3), bty = "n", cex = 1.25)
    rect(xleft = 1, ybottom = introCA$initialE+introCA$pulseE,
         xright = 3, ytop = introCA$formalE, col = 3)
    rect(xleft = 1, ybottom = introCA$formalE,
         xright = 3, ytop = introCA$initialE, col = 2)
    lines(x = c(0,4), y = c(-0.25,-0.25), lty = 3, lwd = 3)
    text(x = 4, y = -0.25, "formal potential", pos = 4, cex = 1.25)
    lines(x = c(1,3), 
          y = c(introCA$potential[index],introCA$potential[index]), 
          col = 1, lwd = 6)
    
    # potential profile
    plot(x = introCA$time[1:index], 
         y = introCA$potential[1:index], type = "l", 
         lwd = 4, col = 6,
         xlab = "time (s)", ylab = "potential (V)",
         main = "applied potential profile",
         xlim = c(0,introCA$time_end), 
         ylim = c(min(introCA$potential),max(introCA$potential)),
         cex.lab = 1.25, cex.main = 1.25, cex.axis = 1.25)
    abline(v = input$act1_time, lty = 3, col = 1, lwd = 4)
    grid()
    
    # diffusion profile
    plot(x = introCA$distance, y = introCA$oxdata[index,], type = "l",
         lwd = 4, col = 2, xlab = "distance from electrode (cm)",
         ylab = "concentration (mM)", ylim = c(0,1),
         main = "diffusion profiles",
         cex.lab = 1.25, cex.main = 1.25, cex.axis = 1.25)
    lines(x = introCA$distance, y = introCA$reddata[index,], lty = 1,
          col = 3, lwd = 4)
    # lines(x = introCA$distance, y = introCA$reddata[2001,], lty = 3,
    #       col = 3, lwd = 4)
    # lines(x = introCA$distance, y = introCA$oxdata[2001,], lty = 3,
    #       col = 2, lwd = 4)
    legend(x = "right", 
           legend = c("Ox", "Red"),
           col = c(2,3), lwd = 4, lty = c(1,1), bty = "n", cex = 1.25)
    grid()
    
    # current profile
    plot(x = introCA$time[1:index], y = introCA$current[1:index], type = "l",
         lwd = 4, col = 6, xlab = "time (s)", ylab = "current (µA)",
         main = "current profile", ylim = c(0,max(introCA$current)),
         xlim = c(0,introCA$time_end),
         cex.lab = 1.25, cex.main = 1.25, cex.axis = 1.25)
    abline(v = input$act1_time, lty = 3, col = 1, lwd = 4)
    grid()
    par(old.par)
    
  })
  
  ca_cottrell = reactive({
    out = simulateCA(
      n = as.numeric(input$n),
      d = as.numeric(input$D),
      area = as.numeric(input$A),
      conc.bulk = as.numeric(input$C),
      t.end = 20
    )
  })
  
  output$act2_plot = renderPlot({
    # index12 = which.min(abs(introCA$time - 12))
    index13 = which.min(abs(introCA$time - 13))
    index14 = which.min(abs(introCA$time - 14))
    index15 = which.min(abs(introCA$time - 15))
    index16 = which.min(abs(introCA$time - 16))
    index17 = which.min(abs(introCA$time - 17))
    plot(x = ca_cottrell()$time, y = ca_cottrell()$current, type = "l",
         lwd = 4, col = 6, xlab = "total elapsed time (s)", ylab = "current (µA)",
         ylim = c(0,25), xlim = c(10,20),
         cex.lab = 1.25, cex.main = 1.25, cex.axis = 1.25)
    points(x = ca_cottrell()$time[c(index13,index14,index15,index16,index17)], 
           y = ca_cottrell()$current[c(index13,index14,index15,index16,index17)],
           pch = 19, col = 2, cex = 2)
    text(x = ca_cottrell()$time[c(index13,index14,index15,index16,index17)],
         y = ca_cottrell()$current[c(index13,index14,index15,index16,index17)],
         labels = round(ca_cottrell()$current[c(index13,index14,index15,index16,index17)],3),
         srt = 90, pos = 3, offset = 3, cex = 1.5)
    grid()
  })
  
  output$wrapup_plot1 = renderPlot({
    plotGrid(introCA)
  })
  
  doublestepCA = reactive({
    simulateCA(mechanism = "EC", pulses = "double",
               t.1 = 0.001, t.2 = 0.003, t.end = 0.005,
               kcf = input$kcf, t.units = 5000)
  })
  
  output$act3_plota = renderPlot({
    old.par = par(mar = c(5,4,1,2))
    plotCA(list(doubleCA, doublestepCA()), scale = 0.1,
           legend_text = c("kcf = 0", paste0("kcf = ",input$kcf)),
           legend_position = "topright")
    grid()
    par(old.par)
    # plot(x = doublestepCA()$time, y = doublestepCA()$current, type = "l",
    #      lwd = 4, col = 6, xlab = "total elapsed time (s)", ylab = "current (µA)",
    #      cex.lab = 1.25, cex.main = 1.25, cex.axis = 1.25)
    # lines(x = doubleCA$time, y = doubleCA$current, lty = 3, lwd = 4, 
    #       col = 2)
  })
  
  output$act3_plotb = renderPlot({
    introCC = simulateCC(introCA)
    index = which.min(abs(introCA$time - input$act3_time))
    old.par = par(mfrow = c(1,2))
    plot(x = introCA$time[1:index], y = introCA$current[1:index], type = "l",
         lwd = 4, col = 6, xlab = "time (s)", ylab = "current (µA)",
         main = "chronoamperometry", ylim = c(0,max(introCA$current)),
         xlim = c(0,introCA$time_end),
         cex.lab = 1.25, cex.main = 1.25, cex.axis = 1.25)
    abline(v = input$act3_time, lty = 3, col = 1, lwd = 4)
    grid()
    plot(x = introCC$time[1:index], y = introCC$charge[1:index], type = "l",
         lwd = 4, col = 6, xlab = "time (s)", ylab = "charge (µC)",
         main = "chronocoulometry", ylim = c(0,max(introCC$charge)),
         xlim = c(0,introCC$time_end),
         cex.lab = 1.25, cex.main = 1.25, cex.axis = 1.25)
    abline(v = input$act3_time, lty = 3, col = 1, lwd = 4)
    grid()
    # plotCA(list(introCA))
    # plotCC(list(introCC))
    par(old.par)
  })
  
}) # close server
