proteinExpressionCardUI <- function(experiment){
    renderUI({
      div(class="card-list",
      apply(experiment,1, function(x) {
        names(x) <- c("ID", "InfoSource","Franchise", "Organ", "CellType", "Primary/CellLine", "Cell" ,
                      "CellAnotation", "Species","Cell Source", "Treatment", "Assay Type", "Assay",
                      "SignalStrength","SignalStrengthValue", "Antibody", "cGMP Level (nM)","#Cells",
                      "ELN #", "Scientist","Comments", "ItemType", "Path","Date" )
        createCardView(x)})
      )
    })
}

createCardView <- function(row){
  div(style="display: inline-block;",
    tags$script(paste0('$("#card', trimws(row[1]), '").flip({trigger: "click", axis:"x", speed:200});')),
  
    div(id=paste0("card", trimws(row[1])),
        style="display: inline-block;",
         div(class="front",
           div(class=" card-background",
               div(class="card-title-block",
                   div(class="card-title-1",
                       h5(class="card-title-species", row[9]),
                       h5(class="card-title-cell", row[7]))),
               
               div(class="card-body-block",
                   div(class="card-body-content",
                       div(class="card-body-content-left",
                           div(paste0("Trx: ", row[11])),
                           div(paste0("Assay: ", row[13]))),
                       if(row[14] == "-"){
                         div(class="card-body-box-fail",
                             div(class="card-body-box-value", row[14]))
                       }else if(row[14]=="Y"){
                         div(class="card-body-box-success",
                             div(class="card-body-box-value", icon("check")))
                       }else{
                       div(class="card-body-box-success",
                           div(class="card-body-box-value", row[14]))}
                   )),
               
               div (class="card-foot-block",
                    div(class="card-foot-content",
                        div(class="card-foot-content-left",
                            div(paste0("Source: ", row[2])),
                            div(paste0("ELN#: ", row[19]))),
                        div(class="card-foot-content-right",
                            div(class="card-scientist", row[20]))
                    ),
                    
                    div(class="card-more",
                        p(class="card-link", "Click to Get More Info"))
               )
               
           )),
        div(class='back',
            div(class="back-card-background",
            lapply(names(row)[c(12, 10, 17, 18, 3, 6, 16, 24)], function(x){
              p(tags$strong(paste0(x, ": ")),row[x])
            })
            )
          )
      )
    )
  
}