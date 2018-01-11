######help function for proten card database
###########submit check help functions#################

mandatoryFilledFun <- function(input, fieldsMandatory){
                          vapply(fieldsMandatory,
                                 function(x) {
                                   !is.null(input[[x]]) && input[[x]] != ""
                                 },
                                 logical(1)
                          )
  }


mandatoryNewFilledFun <- function(input, mandatoryItems){
  vapply(mandatoryItems, function(x){
    fields_input = paste0(x,"_input")
    new_input = paste0(x,"_new")
    
    if (is.null(input[[fields_input]])){
      return(TRUE)
    }else if (input[[fields_input]] == ""){
      return(TRUE)
    }else if (input[[fields_input]] == "other"){
      return(!is.null(input[[new_input]]) && input[[new_input]] !="")
    }else{
      return(TRUE)
    }
  },logical(1))
}
############################################################

#########submit content parser#########################

noNewInputParser<- function(input, var){
  var = paste0(var, "_input")
  tmp = input[[var]]
  
  if (var == 'date_input'){
    tmp = as.character(tmp)
    return(tmp)
  }
  
  if (is.null(tmp)){
    return(tmp)
  }else if(tmp == '' | tmp == 0){
    return(tmp)
  }
  if (var == "signal_strength_input" | var=="cell_annotation_input" | var=="comment_input"){
    tmp = trimws(tmp)
    return(input[[var]])
  }else if (var == "cGMP_level_input"){
    tmp = toString(tmp)
    return(paste0(tmp,"nM"))
  }else if (var == "cell_number_input"){
    tmp = toString(tmp)
    return(paste0(tmp,"K"))
  }else{
    return(tmp)
  }
} 


multiInputParser <- function(input, var){
  multiInput = paste0(var, '_input')
  multiNew = paste0(var, '_new')
  tmp = input[[multiInput]]
  if (is.null(tmp) | length(tmp) == 0){
    return('')
  }
  
  if ("other" %in% tmp){
    tmp = tmp[tmp!="other"]
    tmp_new = input[[multiNew]]
    if (is.null(tmp_new) | tmp_new ==""){
      out = paste(tmp, collapse="|")
    }else{
      tmp_new = trimws(tmp_new)
      out = unlist(strsplit(tmp_new, ";"))
      out =sapply(out, function(x){ 
        x = trimws(x)
        x = gsub(" +", "", x, perl=T)
      })
      out = paste(c(tmp, out), collapse="|")
    }
  }else{
    out = paste(tmp, collapse="|")  
  }
  return(out)
}

normalInputParser <- function(input, var){
  normalInput = paste0(var, '_input')
  normalNew = paste0(var, '_new')
  tmp = input[[normalInput]]
  

  if (var=="scientist" & tmp == "other"){
    firstname = capitalize(trimws(input$scientist_fisrtname))
    secondname = capitalize(trimws(input$scientist_secondname))
    name = paste(firstname, secondname, sep=" ")
    return(name)
  }

  if (tmp == "other"){
    out = capitalize(trimws(input[[normalNew]]))
    return(out)
  }else{
    return(tmp)
  }
  
}

previewFormGenerator<- function(input){
  form = getSubmitForm(input)
  form_modal = lapply(names(form), function(x){
      label = capitalize(unlist(strsplit(x, "_")))
      label = paste(label,collapse = " ")
      if(is.null(form[[x]])){
        content = "N/A"
      }else if (form[[x]]==""){
        content = "N/A"
      }else{
        content = form[[x]]
      }
      return(tags$li(class="list-inline-item", tags$label(label), p(content)))
      
    })
  form_modal = tags$ul(class="list-inline", form_modal)
  return(form_modal)
}


getSubmitForm<- function(input){
  form = list()
  inputItems =  c("info_source", "franchise", "organ", "cell_type", "primary", "species", "cell", "cell_source", "treatment",
                  "assay_type", "assay", "antibody", "scientist", "item_type", "path" )
  
  noNewInput = c("signal_strength", "cell_annotation", "cGMP_level", "cell_number", "comment", 'date')
  
  
  form_normal = sapply(inputItems,  function(x){
    normalInputParser(input, x)
  }, USE.NAMES=T)
  
  form_noNew = sapply(noNewInput, function(x){
    noNewInputParser(input, x)
  }, USE.NAMES=T)
  
  form_multi = sapply(c('eln'),function(x){
    multiInputParser(input, x)
  }, USE.NAMES = T)
  
  form = c(form_normal, form_noNew, form_multi)
  return(form)
}

insertExperiment2Db<- function(form){
  out = toJSON(bind_rows(form))
  out = gsub('"', "'", out[1])
  command = paste0("python C://Users/xfan/Documents/Github/protein_expression_db/python_db/mainFun.py \"", out, "\"")
  success = system(command, intern=T)
  return(success)
  # for (n in names(form)){
  #   # system("python C://Users/xfan/Documents/Github/protein_expression_db/python_db/mainFun.py %name")
  #   print(n)
  # }
  # conn <- dbConnect(
  #   drv = RMySQL::MySQL(),
  #   dbname = "protein_exp",
  #   host = host,
  #   username = username,
  #   password = password)
  # 
  # on.exit(dbDisconnect(conn), add = TRUE)
  # sql <- "SELECT * FROM City WHERE ID = ?id1 OR ID = ?id2 OR ID = ?id3;"
  # query <- sqlInterpolate(conn, sql, id1 = input$ID1,
  #                         id2 = input$ID2, id3 = input$ID3)
  # dbGetQuery(conn, query)
  
  
}


####################get dashboard data###############
getSelectedExperiemnt <- function(input, experiment, species, cell, 
                                  signal_strength,franchise, organ,
                                  cell_type, assay_type, assay, scientist){
  
  # if (is.null(input$species) || input$species == ""){
  #   species_select = species[,2]
  # } else{
  #   species_select = input$species
  # }
  
  signal_strength_select = getFilterSelected(input, signal_strength, "signal_strength")
  species_select = getFilterSelected(input, species, "species")
  cell_select = getFilterSelected(input, cell, "cell")
  franchise_selected = getFilterSelected(input, franchise, "franchise")
  organ_selected = getFilterSelected(input, organ, "organ")
  cell_type_selected = getFilterSelected(input, cell_type, "cell_type")
  assay_type_selected = getFilterSelected(input, assay_type, "assay_type")
  assay_selected = getFilterSelected(input, assay, "assay")
  scientist_selected = getFilterSelected(input, scientist, "scientist")
  
  filter = (experiment$Species %in% species_select) &
          (experiment$Cell %in% cell_select) &
          (experiment$SignalStrength %in% signal_strength_select)&
          (experiment$Franchise %in% franchise_selected)&
          (experiment$Organ %in% organ_selected)&
          (experiment$CellType %in% cell_type_selected)&
          (experiment$AssayType %in% assay_type_selected | is.na(experiment$AssayType))&
          (experiment$Assay %in% assay_selected | is.na(experiment$Assay))&
          (experiment$Scientist %in% scientist_selected)
  
  experiment_selected = experiment[filter,]
}

getFilterSelected<-function(input, table, name){
  if (is.null(input[[name]])|| input[[name]] == ""){
    data = table[,2]
  } else{
    data = input[[name]]
  }
  
  return(data)
}

