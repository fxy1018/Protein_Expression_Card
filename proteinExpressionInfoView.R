proteinExpressionInfoView<-function(){
  renderUI({
    div(id="insertionForm", class='container',
        span(h1("New Experiment"), p("* required")),
        hr(),
        div(class='form', id = "form",
            div(class='row',
                div(class="col col-sm-4",
                    div(class='form-group row',
                        selectizeInput("info_source_input", labelMandatory("Info Source: "), choices=NULL),
                        textInput("info_source_new",labelMandatory("New Info Source:")),
                        selectizeInput("franchise_input", labelMandatory("Franchise: "), choices=NULL),
                        textInput("franchise_new",labelMandatory("New Franchise:")),
                        selectizeInput("organ_input",labelMandatory("Organ: "), choices=NULL),
                        textInput("organ_new",labelMandatory("New Organ:"))
                    )
                ),
                div(class='col col-sm-4',
                    div(class='form-group row',
                        selectizeInput("cell_type_input", labelMandatory("Cell Type: "), choices=NULL),
                        textInput("cell_type_new",labelMandatory("New Cell Type:")),
                        selectizeInput("primary_input", labelMandatory("Primary: "), choices=NULL),
                        textInput("primary_new",labelMandatory("New Primary:")),
                        selectizeInput("species_input", labelMandatory("Species: "), choices=NULL),
                        textInput("species_new",labelMandatory("New Species:"))
                    )
                )
            ),
            
            div(class='row', style="width: 61%;  background-color:lightgrey",
                selectizeInput("cell_input", labelMandatory("Cell: "), choices=NULL,  width="100%"),
                textInput("cell_new",labelMandatory("New Cell:"), width='100%'),
                textAreaInput("cell_annotation_input","Cell Annotation:", width='230%'),
                selectizeInput("cell_source_input", labelMandatory("Cell Source: "), choices=NULL, width='100%'),
                textInput("cell_source_new",labelMandatory("New Cell Source:"))
                
            ),
            
            div(class='row', style='margin-top:10px',
                div(class='col col-sm-4',
                    div(class='form-group row',
                        selectizeInput("treatment_input", "Treatment: ", choices=NULL),
                        textInput("treatment_new","New Treatment:"),
                        selectizeInput("antibody_input", "Antibody: ", choices=NULL),
                        textInput("antibody_new","New Antibody:")
                    )
                ),
                div(class='col col-sm-4',
                    div(class='form-group row',
                        selectizeInput("assay_type_input", "Assay Type: ", choices=NULL),
                        textInput("assay_type_new","New Assay Type:"),
                        selectizeInput("assay_input", "Assay: ", choices=NULL),
                        textInput("assay_new","New Assay:")
                    )
                )
            ),
            
            div(class='row', style="width: 61%;  background-color:lightgrey",
                selectizeInput("signal_strength_input", labelMandatory("Signal Strength: "), choices=NULL, width='100%'),
                tags$label("cGMP Level (nM)/# Cells: ", `for`='cGMP_div'),
                div(id="cGMP_div", class='form-group row',
                    div(class='col col-sm-4', numericInput("cGMP_level_input", "cGMP Level (nM)", value=0, min = 0, max = 100000, step = 5)),
                    div(class='col col-sm-4', numericInput("cell_number_input", "Cell Number (K): ", value=0, min = 0, max = 10000, step = 5 ))
                )
            ),
            
            div(class='form-group row', style='margin-top:10px',
                selectizeInput("eln_input", "#ELN: ", choices=NULL,  multiple = TRUE, width="59%"), 
                textAreaInput("eln_new","New #ELN:", width="230%", placeholder = "new ELN, seperated by semi-common(;). For example: 000254-64;000254-75;000254-71"),
                textAreaInput("comment_input","Comments:", width="230%")
            ),
            
            
            div(class='row',
                div(class='col col-sm-4',
                    div(class='form-group row',
                        selectizeInput("scientist_input", labelMandatory("Scientist: "), choices=NULL),
                        div(id="scientist_new",
                            textInput("scientist_fisrtname",labelMandatory("First Name:")),
                            textInput("scientist_secondname",labelMandatory("Second Name:"))
                        ),
                        selectizeInput("item_type_input", labelMandatory("Item Type: "), choices=NULL),
                        textInput("item_type_new",labelMandatory("New Item Type:"))
                    )
                ),
                div(class='col col-sm-4', 
                    div(class='form-group row',
                        selectizeInput("path_input", labelMandatory("Path: "), choices=NULL),
                        textInput("path_new",labelMandatory("New Path:")),
                        dateInput('date_input', "Date:", value=Sys.Date())
                    )
                )
            ),
            
            div(class='form-group row',
                actionButton("submit_record", 'Submit', class="btn-primary"),
                actionButton("reset", 'Reset', class="btn-primary")
            )
        )
    )
  })
  
  
}

labelMandatory <- function(label) {
  tagList(
    label,
    span("*", class = "mandatory_star")
  )
}