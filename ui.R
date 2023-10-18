library(shiny)
library(DT)
library(shinythemes)


fluidPage(theme = shinytheme("flatly"),
  titlePanel("Mini Projet de Probabilité et statistiques"),
  sidebarLayout(
    sidebarPanel(
      fileInput('file1', 'Choose file to upload',
                accept = ".txt"
      ),
      hr(),
      checkboxInput('header', 'This file as a header ?', TRUE),
      radioButtons('sep', 'Choose the separator inside the file',
                   c(Comma=',',
                     Semicolon=';',
                     Tab='\t'),
                   '\t'),
      hr(),
      br(),
      selectInput("x", "Selectionné la variable x", choices = NULL),
      selectInput("y", "Select Y variable", choices = NULL),
      hr(),
      radioButtons('type', 'Choose the type of the plot',
                   c(Line='li',
                     Point='p',
                     Both='o'),
                   'p'),
      hr(),
      #checkboxInput("check", "Show regression cuve ?"),
      radioButtons("checkgroup", "Regression cuve options", c(Line='l',Cuve='c',Both='b',None='n'),'n'),
      hr(),
      downloadButton("plotDownload", "Download Plot")
    ),
    mainPanel(
      plotOutput("diagramme", height = "600px"),
      hr(),
      br(),
      h3(textOutput("text"), class="capitalyse"),
      br(),
      DT::dataTableOutput('contents'),
      br()
    )
  )
)
