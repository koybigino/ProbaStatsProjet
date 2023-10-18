library(dplyr)
library(ggplot2)

function(session, input, output) {
  
  # Functions----------------------------------------------------------------------------------------------------------
  isFile <- function(){
    inFile <- input$file1
    
    if (is.null(inFile))
      return(FALSE)
    
    return(TRUE)
  }
  
  showDatas <- function(){
    
    inFile <- input$file1
    
    if (isFile() == FALSE)
      return(NULL)
    
    tableDatas <- read.table(inFile$datapath, header = input$header,
                        sep = input$sep)
    
    return(tableDatas)
    
    #print(str(dataq))
    
    #print(as.list(dataq[0,], strsplit(dataq[0,], input$sep)[[1]]))
    
  }
  
  #showPlot <- eventReactive(input$btn, {})
  showPlot <- function(){
    
    if (isFile() == FALSE)
      return(NULL)
    
    x<- input$x
    y<- input$y
    plot <- ggplot(data = showDatas(), mapping = aes_string(x, y)) + labs(title = paste("Plot of ", input$x, " vs ", input$y),x = x, y = y)
    
    if(input$type == "li")
      plot <- plot + geom_line(colour = "#4a796e")
    else if(input$type == "p")
      plot <- plot + geom_point()
    else if(input$type == "o")
      plot <- plot + geom_point() + geom_line(colour = "#4a796e")
    
    #xVar <- select(showDatas(), input$x)[,1]
    #yVar <- select(showDatas(), input$y)[,1]
    
    #plot(xVar, yVar, type = input$type, pch = 4, cex = 0.5, lwd = 0.8, col = "blue", xlab = input$x, ylab = input$y, main = paste("Plot of ", input$x, " vs ", input$y))
    
    if(input$checkgroup == "c")
      plot <- plot + geom_smooth()
    else if(input$checkgroup == "l")
      plot <- plot + stat_smooth(method = lm, col = "red")
    else if(input$checkgroup == "b")
      plot <- plot + stat_smooth(method = lm, col = "red") + geom_smooth()
    
    
    return(plot)
    
  }
  
  
  
  #Events-----------------------------------------------------------------------------------------
  observe({
    colunm_names <- colnames(showDatas())
    updateSelectInput(session, "x", "Select x variable", choices = colunm_names)
    updateSelectInput(session, "y", "Select y variable", choices = colunm_names)
  })
  
  
  
  # Outputs---------------------------------------------------------------------------------------
  output$contents <- DT::renderDataTable(
    showDatas()
  )
  
  output$text <- renderText({
    if (isFile() == FALSE)
      return(NULL)
    
    return("Datas Tables")
  })

  output$diagramme <- renderPlot(
    showPlot()
  )
  
  output$plotDownload <- downloadHandler(
    filename = function(){
      name <- paste(input$x, "_", input$y, "_plot")
      paste(name, "png", sep = ".")
    },
    
    content = function(file){
      ggsave(showPlot(), filename = file)
    }
  )
}
