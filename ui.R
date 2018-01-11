#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)
library(DT)
library(shinyjs)

# Define UI for application that draws a histogram
shinyUI(tagList(
  useShinyjs(),
  inlineCSS(appCSS),
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "mystyle.css"),
    
    tags$script(src="jquery.flip.js")
  ),
  navbarPage("Expression Data",
             tabPanel("Dashboard View",
                      
                      fluidRow(
                        column(2,
                               wellPanel(
                                 selectizeInput("franchise", "Franchise: ", choices=NULL,multiple = TRUE),
                                 selectizeInput("organ", "Organ: ", choices=NULL,multiple = TRUE),
                                 selectizeInput("species", "Species: ", choices=NULL,multiple = TRUE),
                                 selectizeInput("cell", "Cell: ", choices=NULL,  multiple = TRUE, width="100%"),
                                 selectizeInput("cell_type", "Cell Type: ", choices=NULL,multiple = TRUE),
                                 selectizeInput("assay_type", "Assay Type: ", choices=NULL,multiple = TRUE),
                                 selectizeInput("assay", "Assay: ", choices=NULL,multiple = TRUE),
                                 selectizeInput("scientist", "Scientist: ", choices=NULL,multiple = TRUE),
                                 selectizeInput("signal_strength", "Signal Strength: ", choices=NULL, multiple = TRUE, width='100%')
                                 
                               )),
                        column(10,
                               uiOutput('proteinExpressionCard'))
                        
                        
                        
                        )
                      ),
             
             tabPanel("Table View", 
                      DT::dataTableOutput('experiment_table'),
                      tags$div(class='col col-sm-2', downloadButton("downloadExpTable", "Download Expression DB", icon=icon('download'), class ="btn btn-success"))
                      ),
             
             tabPanel("Add New Data",
                      tags$div(class='row',
                               tags$div(class='col col-sm-2', actionButton("addRecord", "Add", icon=icon("plus"), width='70%', class="btn btn-primary"))
                               
                               # , tags$div(class='col col-sm-2', actionButton("editRecord", "Edit", icon=icon("pencil"),width='70%',class="btn btn-success"))
                               # ,
                               # tags$div(class='col col-sm-2', actionButton("deleteRecord", "Delete", icon=icon("minus"),width='70%', class="btn btn-primary"))
                      ),
                      uiOutput('proteinExpressionInfo')
                      )
             
    )
  )
)
