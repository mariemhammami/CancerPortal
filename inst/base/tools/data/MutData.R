output$MutDataTable <- DT::renderDataTable({
  ## check if GenProf is mutation
  cgds <- CGDS("http://www.cbioportal.org/public-portal/")
  Studies<- getCancerStudies(cgds)



  if (length(grep("Mutations", input$GenProfID))==0){

    dat <- as.data.frame("Please select mutations from Genetic Profiles")

  }else if(input$GeneListID != "Genes"){

    GeneList <- t(unique(read.table(paste0(getwd(),"/data/GeneList/",input$GeneListID,".txt" ,sep=""))))

  #GeneList <- (r_data[[input$GeneListID]])

  ##### Get Mutation Data for selected Case and Genetic Profile



  #appel des variables <<caselist>> <<genProf>> avec le fichier ProfData.r
  res <- 1
  for (i in 1: nrow(Studies))
  {
    if ((Studies[i,2]) == input$StudiesID)


    { res<-i
    }
  }
  caseList <- getCaseLists(cgds,Studies[res,1])
  GenProf <- getGeneticProfiles(cgds,Studies[res,1])
  res2 <- 1
  for (i in 1: nrow(caseList))
  {
    if ((caseList[i,2]) == input$CasesID)


    { res2<-i
    }
  }

  res3<-1
  for (i in 1: nrow(GenProf))
  {
    if ((GenProf[i,2]) == input$GenProfID)


    { res3<-i
    }
  }
  dat <- getMutationData(cgds,caseList[res2,1],GenProf[res3,1], GeneList)
  ## change rownames in the first column
  dat <- as.data.frame(dat %>% add_rownames("Patients"))
  }
#   if(is.numeric(dat[1,1])){
#     dat <- round(dat, digits = 3)
#   }
  ####

  # action = DT::dataTableAjax(session, dat, rownames = FALSE, toJSONfun = my_dataTablesJSON)
  action = DT::dataTableAjax(session, dat, rownames = FALSE)

  DT::datatable(dat, filter = "top", rownames = FALSE, server = TRUE,
                # class = "compact",
                options = list(
                  ajax = list(url = action),
                  search = list(regex = TRUE),
                  columnDefs = list(list(className = 'dt-center', targets = "_all")),
                  autoWidth = TRUE,
                  processing = FALSE,
                  pageLength = 10,
                  lengthMenu = list(c(10, 25, 50, -1), c('10','25','50','All'))
                )
  )

})
