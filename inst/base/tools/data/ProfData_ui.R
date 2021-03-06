
# output$ui_fileUploadProfData <- renderUI({
#
#   if (is.null(input$loadGeneListID)) return()
#   if (input$loadGeneListID == "csv") {
#     fileInput('uploadfile', '', multiple=TRUE,
#               accept = c('text/csv','text/comma-separated-values',
#                          'text/tab-separated-values',
#                          'text/plain','.csv','.tsv'))
#   } else if (input$loadGeneListID == "rda") {
#     fileInput('uploadfile', '', multiple=TRUE,
#               accept = c(".rda",".rds",".rdata"))
#   }
# })

output$ui_clipboard_load_ProfData <- renderUI({
  if (r_local) {
    actionButton('loadClipProfData', 'Paste data')
  } else {
    tagList(tags$textarea(class="form-control",
                          id="load_cdata", rows="5"
    ),
    actionButton('loadClipProfData', 'Paste data'))
  }
})


output$ui_ProfData <- renderUI({
  list(

    wellPanel(

      radioButtons(inputId = "loadGeneListID", label = "Load Gene List:",
                   c( "examples" = "ExampleGeneList",  "clipboard" = "clipboard_GeneList"),
                   selected = "Genes", inline = TRUE),

      conditionalPanel(condition = "input.loadGeneListID == 'clipboard_GeneList'",
                       actionButton('loadClip_GeneList', 'Paste Gene List')
                       #uiOutput("ui_clipboard_load_ProfData")
      ),
      conditionalPanel(condition = "input.loadGeneListID == 'ExampleGeneList'",
                       actionButton('loadExampleGeneList', 'Load examples')
      )
#       conditionalPanel(condition = "input.loadGeneListID == 'state_Prof'",
#                        fileInput('uploadstate_Prof', 'Load previous app state_Prof:',  accept = ".rda"),
#                        uiOutput("refreshOnUpload")
#       )

  ),

  wellPanel(

    radioButtons(inputId = "ProfData", label = "Load ProfData to Datasets:",
                 c("ProfData"="ProfData"), selected = FALSE, inline =TRUE),
    conditionalPanel(condition = "input.ProfData == 'ProfData'",
                     actionButton('loadProfData', 'Load ProfData')

    )
  ),
#   wellPanel(
#     radioButtons(inputId = "saveAs", label = "Save data:",
#                  c("rda" = "rda", "csv" = "csv", "clipboard" = "clipboard",
#                    "state_Prof" = "state_Prof"), selected = "rda", inline = TRUE),
#
#     conditionalPanel(condition = "input.saveAs == 'clipboard'",
#                      uiOutput("ui_clipboard_save")
#     ),
#     conditionalPanel(condition = "input.saveAs != 'clipboard' &&
#                      input.saveAs != 'state_Prof'",
#                      downloadButton('downloadData', 'Save')
#     ),
#     conditionalPanel(condition = "input.saveAs == 'state_Prof'",
#                      HTML("<label>Save current app state_Prof:</label><br/>"),
#                      downloadButton('downloadstate_Prof', 'Save')
#     )
#   ),
#   wellPanel(
#     checkboxInput('man_show_remove', 'Remove data from memory', FALSE),
#     conditionalPanel(condition = "input.man_show_remove == true",
#                      uiOutput("uiRemoveDataset"),
#                      actionButton('removeDataButton', 'Remove data')
#     )
#   ),
#   help_modal('Manage','manageHelp',inclMD(file.path(r_path,"base/tools/help/manage.md")))
fileInput('file1', 'Choose txt File',
          accept=c('text',
                   'text,text/plain'))
  )
})
####################

# loading all examples files (linked to helpfiles)
observe({
  if (not_pressed(input$loadExampleGeneList)) return()
  isolate({

    # loading data bundled with Radiant
    data_path <- file.path(r_path,"base/data/GeneList")
    examples <- list.files(data_path)

    for (ex in examples) loadUserData(ex, file.path(data_path,ex), 'txt')

    # sorting files alphabetically
    r_data[['genelist']] <- sort(r_data[['genelist']])

    updateSelectInput(session, "GeneListID", label = "Gene List Examples:",
                      choices = r_data$genelist,
                      selected = r_data$genelist[1])
  })
#  A <<- r_data$genelist
})

## load genelist from clipBoard
observe({
  # 'reading' data from clipboard
  if (not_pressed(input$loadClip_GeneList)) return()
  isolate({
    loadClipboard_GeneList()
    updateRadioButtons(session = session, inputId = "GeneListID",
                       label = "Paste Genes:",
                       c( "examples" = "ExampleGeneList",  "clipboard" = "clipboard_GeneList"),
                       selected = "Genes", inline = TRUE)
    updateSelectInput(session, "GeneListID", label = "Pasted Genes:",
                      choices = r_data$genelist, selected = "Genes")
  })
})


## Load Profile data in datasets
observe({
  if (not_pressed(input$loadProfData)) return()
  isolate({

    loadInDatasets(fname="ProfData", header=TRUE)

    # sorting files alphabetically
    r_data[['datasetlist']] <- sort(r_data[['datasetlist']])

    updateSelectInput(session, "dataset", label = "Datasets:",
                      choices = r_data$datasetlist,
                      selected = "ProfData")

  })
})
