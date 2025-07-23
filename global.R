# global.R file for chronoamperometry app

# packages to load
library(shiny)
library(shinythemes)
library(eChem)

# set color scheme
palette("Okabe-Ito")

# data for application
introCA = simulateCA(t.1 = 10, t.end = 20)
doubleCA = simulateCA(mechanism = "E", pulses = "double",
                      t.1 = 10, t.2 = 20, t.end = 30,
                      kcf = 0, t.units = 2000)
