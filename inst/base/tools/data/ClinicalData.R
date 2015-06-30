output$ClinicalDataTable <- DT::renderDataTable({

  #if (not_available(input$view_vars)) return()
  cgds <- CGDS("http://www.cbioportal.org/public-portal/")
  Studies<- getCancerStudies(cgds)

#   ##### get Clinical Data for selected Case
  for (i in 1: nrow(Studies))
  {
    if ((Studies[i,2]) == input$StudiesID)


    { res<-i
    }
  }
  # caselist <- apply(as.data.frame(Studies[,-2:-3][res]), 1,function(x)getCaseLists(cgds,x))
  caselist <- getCaseLists(cgds,Studies[res,1])
#  #print(caselist)
#   #######################
#   for (i in 1: nrow(caselist))
#   {
#     if ((caselist[i,2]) == input$CasesID)
#
#
#     { res<-i
#     }
#   }
 dat <- apply(as.data.frame(caselist[,-2:-5][2]),1,function(x)getClinicalData(cgds,x))
 # dat <- getClinicalData(cgds, caselist[res,1])


  ## change rownames in the first column
  dat <- dat %>% add_rownames("Patients")
  ####

  # action = DT::dataTableAjax(session, dat, rownames = FALSE, toJSONfun = my_dataTablesJSON)
  action = DT::dataTableAjax(session, dat, rownames = FALSE)

  DT::datatable(dat, filter = "top", rownames =FALSE, server = TRUE,
                # class = "compact",
                options = list(
                  ajax = list(url = action),
                  search = list(regex = TRUE),
                  columnDefs = list(list(className = 'dt-center', targets = "_all")),
                  autoWidth = FALSE,
                  processing = FALSE,
                  pageLength = 10,
                  lengthMenu = list(c(10, 25, 50, -1), c('10','25','50','All'))
                )
  )
})

