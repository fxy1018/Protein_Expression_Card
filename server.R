#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyjs)
source("helpFunction.R")
library(pool)
library(dplyr)
library(xlsx)
source("proteinExpressionCardView.R")
source("proteinExpressionInfoView.R")

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  sketch = htmltools::withTags(table(
    class="display",
    thead(
      tr(
        th(rowspan=2,'Id'),
        th(rowspan=2, 'Info Source'),
        th(rowspan=2, 'Franchise'),
        th(rowspan=2, 'Organ'),
        th(rowspan=2, 'Cell Type'),
        th(rowspan=2, 'Primary/Cell Line'),
        th(colspan = 2, 'Cell'),
        th(rowspan=2, 'Species'),
        th(rowspan=2, 'Cell Source'),
        th(rowspan=2, 'Treatment'),
        th(rowspan=2, 'Assay Type'),
        th(rowspan=2, 'Assay'),
        th(rowspan=2, 'Signal Strength'),
        th(rowspan=2, 'SignalStrengthValue'),
        th(rowspan=2, 'Antibody'),
        th(colspan = 2, 'cGMP Level (nM)/# Cells'),
        th(rowspan=2, 'ELN #'),
        th(rowspan=2, 'Scientist'),
        th(rowspan=2, 'Comments'),
        th(rowspan=2, 'Item Type'),
        th(rowspan=2, 'Path'),
        th(rowspan=2, 'Date')
      ),
      tr(
        lapply(c('Cell', 'Cell Anotation','cGMP Level (nM)', '# Cells'), th)
      )
    )
  ))
  
  experiment = data.frame(my_db2 %>% tbl('experiment_view'))
  experiment$Assay = iconv(experiment$Assay, "UTF-8")

  
  output$experiment_table <- DT::renderDataTable({
    experiment
  }, options=list(pageLength = 5, order=list(14,'asc')), rownames=F, container=sketch, class = 'cell-border stripe', selection=c("none"))
  
  cell= data.frame(my_db2 %>% tbl('cell'))
  species= data.frame(my_db2 %>% tbl('species'))
  signal_strength = data.frame(my_db2 %>% tbl('signal_strength'))
  franchise= data.frame(my_db2 %>% tbl('franchise'))
  organ= data.frame(my_db2 %>% tbl('organ'))
  cell_type= data.frame(my_db2 %>% tbl('cell_type'))
  assay_type= data.frame(my_db2 %>% tbl('assay_type'))
  assay = data.frame(my_db2 %>% tbl('assay'))
  assay$name = iconv(assay$name, "UTF-8")
  scientist= data.frame(my_db2 %>% tbl('scientist'))
  
  updateSelectizeInput(session, 'cell', selected="", choices = c(cell[,2]))
  updateSelectizeInput(session, 'species', selected="", choices = c(species[,2]))
  updateSelectizeInput(session, 'signal_strength', selected="+++", choices = c(signal_strength[,2]))
  updateSelectizeInput(session,"organ", selected="", choices = c(organ[,2]))
  updateSelectizeInput(session,"cell_type", selected="", choices = c(cell_type[,2]))
  updateSelectizeInput(session,"assay_type",selected="", choices = c(assay_type[,2]))
  updateSelectizeInput(session,"assay", selected="", choices = c(assay[,2]))
  updateSelectizeInput(session,"scientist", selected="", choices = c(scientist[,2]))
  updateSelectizeInput(session,"franchise", selected="", choices = c(franchise[,2]))
  

  observe({
    experiment_selected <- getSelectedExperiemnt(input, experiment, species, cell, 
                                                 signal_strength,franchise, organ,
                                                 cell_type, assay_type, assay, scientist)
    output$proteinExpressionCard <- proteinExpressionCardUI(experiment_selected)

  })
  
  
  observeEvent(input$addRecord, {
    
    info_source= data.frame(my_db2 %>% tbl('info_source'))
    primary= data.frame(my_db2 %>% tbl('primary'))
    cell_source= data.frame(my_db2 %>% tbl('cell_source'))
    treatment= data.frame(my_db2 %>% tbl('treatment'))
    antibody = data.frame(my_db2 %>% tbl('antibody'))
    detail= data.frame(my_db2 %>% tbl('detail'))
    eln = data.frame(my_db2 %>% tbl('eln'))
    
    item_type= data.frame(my_db2 %>% tbl('item_type'))
    path= data.frame(my_db2 %>% tbl('path'))
    
    output$proteinExpressionInfo <- proteinExpressionInfoView()

    #update selectize input, get from server
    updateSelectizeInput(session, 'info_source_input', selected="In-House", choices = c(info_source[,2], 'other'))
    updateSelectizeInput(session, 'franchise_input',  selected="", choices = c(franchise[,2], 'other'))
    updateSelectizeInput(session, 'organ_input', selected="", choices = c(organ[,2], 'other'))
    updateSelectizeInput(session, 'cell_type_input', selected="",choices = c(cell_type[,2], 'other'))
    updateSelectizeInput(session, 'primary_input', selected="Primary", choices = c(primary[,2], 'other'))
    updateSelectizeInput(session, 'cell_input', selected="", choices = c(cell[,2], 'other'))
    updateSelectizeInput(session, 'species_input', selected="", choices = c(species[,2], 'other'))
    updateSelectizeInput(session, 'cell_source_input', choices = c(cell_source[,2], 'other'))
    updateSelectizeInput(session, 'treatment_input', selected="", choices = c(treatment[,2], 'other'))
    updateSelectizeInput(session, 'assay_type_input', selected="", choices = c(assay_type[,2], 'other'))
    updateSelectizeInput(session, 'assay_input', selected="", choices = c(assay[,2], 'other'))
    updateSelectizeInput(session, 'signal_strength_input', selected="", choices = c(signal_strength[,2]))
    updateSelectizeInput(session, 'antibody_input', selected="", choices = c(antibody[,2], 'other'))
    updateSelectizeInput(session, 'eln_input', selected=c(""), choices = c(eln[,2], 'other'), server=T)
    updateSelectizeInput(session, 'scientist_input', selected="", choices = c(scientist[,2], 'other'))
    updateSelectizeInput(session, 'item_type_input', choices = c(item_type[,2], 'other'))
    updateSelectizeInput(session, 'path_input', choices = c(path[,2], 'other'))
    

    observe({
      mandatoryItems <- c("info_source", "organ", "franchise", "cell_type", "primary",
                          "cell", "species", "cell_source",  "item_type", "path")
      
      fieldsMandatory <- c("info_source_input", "organ_input", "franchise_input", "cell_type_input", "primary_input",
                           "cell_input", "species_input", "cell_source_input", "signal_strength_input",  "scientist_input", "item_type_input", "path_input")
      
      mandatoryFilled <- mandatoryFilledFun(input, fieldsMandatory)
      mandatoryFilled <- all(mandatoryFilled)
      
      mandatoryNewFilled <- mandatoryNewFilledFun(input, mandatoryItems)
      mandatoryNewFilled <- all(mandatoryNewFilled)
      
      #####check scientist new input validation#####
      if (is.null(input$scientist_input)){
        scientistFilled= TRUE
      }else if (input$scientist_input == ""){
        scientistFilled=TRUE
      }else if (input$scientist_input == "other"){
        scientistFilled = (!is.null(input$scientist_fisrtname) && !is.null(input$scientist_secondname) && input$scientist_fisrtname !="" && input$scientist_secondname !="")
      }else{
        scientistFilled = TRUE
      }
      
      #control
      shinyjs::toggleState("submit_record", mandatoryFilled & mandatoryNewFilled & scientistFilled)
    })
    
    
    
    observeItems = c("info_source", "franchise", "organ", "cell_type", "primary", "species", "cell_source", "treatment",
                     "assay_type", "assay", "antibody", "scientist", "item_type", "path", "cell" )
    
    sapply(observeItems, observeFun)
    
    observeMultiItems = c("eln")
    sapply(observeMultiItems, observeMultiFun)
    
  })
  
  observe({
    if (input$addRecord > 1){
      session$reload()
    }
  })
  
  observeFun <- function(fieldName) {
    inputName = paste0(fieldName, "_input")
    newName = paste0(fieldName, "_new")
    observe({
      if (is.null(input[[inputName]])){
        shinyjs::hideElement(newName)
      } else if (input[[inputName]]==""){
        hideElement(newName)
      }else if (input[[inputName]] == "other" ){
        showElement(newName)
      }else {
        hideElement(newName)
      }
    })
  }
  
  observeMultiFun <- function(fieldName) {
    inputName = paste0(fieldName, "_input")
    newName = paste0(fieldName, "_new")
    observe({
      if (is.null(input[[inputName]])){
        hideElement(newName)
      } else if (length(input[[inputName]])==0){
        hideElement(newName)
      }else if ("other" %in% input[[inputName]]){
        showElement(newName)
      }else {
        hideElement(newName)
      }
    })
  }
  
  submitModal <- function(){
    modalDialog(
      title = "New Submit Preview",
      previewForm <- previewFormGenerator(input),
      footer = tagList(
        modalButton("Cancel"),
        actionButton('submit_confirmed', "OK")
      )
    )
  }
  
  observeEvent(input$submit_record, {
    showModal(submitModal())
  })
  
  observeEvent(input$submit_confirmed,{
    form = getSubmitForm(input)
    success = insertExperiment2Db(form)
    if (success == "True"){
      removeModal()
      showNotification("You have created a new experiment!", type="message",duration = 5)
    }else{
      removeModal()
      showNotification("Fail", type="error",duration = 10)
    }
    
  })
  
  observeEvent(input$reset, {
    shinyjs::reset("form")
  })
  

  output$downloadExpTable <- downloadHandler(
    filename = function() {
        paste('expressionDB_', Sys.Date(), '.xlsx', sep='')
    },
        content = function(con) {
          write.xlsx2(experiment, con, row.names = F)
        }
    
  )
  
  observeEvent(input$editRecord,{
    removeUI(selector="#insertionForm")
    output$proteinExpessionInfo <- renderUI({
      tags$h1('Info')
    })
  })
  
  
})
