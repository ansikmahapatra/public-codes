# Shiny with R
# When writing the entire project in one file name it app.R
# When separating the two name them ui.R and server.R

install.packages("shiny")
library(shiny)

ui <- fluidPage(
  sliderInput(inputId = "slider",
              label = "Choose a number",
              min = 0,
              max = 100,
              value = 50,
              step = 10),
  plotOutput(outputId = "num"),
  actionButton(inputId = "actionbutton",
               label = "Do Something"),
  submitButton(text = "Submit Form"),
  checkboxInput(inputId = "oneCheck",
                label = "I hereby agree to all terms and conditions",
                value = FALSE),
  checkboxGroupInput(inputId = "groupCheck",
                     label = "What do I want?",
                     choices = c("Job","Money","Gyurls"),
                     selected = c("Job","Money","Gyurls")),
  dateInput(inputId = "dateEnter",
            label = "Enter date",
            value = "1991-12-22"),
  dateRangeInput(inputId = "rangeDate",
                 label = "Enter the period of time you gone mad lolz",
                 start = "1991-12-22",
                 end = "2018-04-24"),
  fileInput(inputId = "fileUpload",
            label = "Please upload some file",
            multiple = FALSE,
            buttonLabel = "Upload"),
  numericInput(inputId = "numberInput",
               label = "Gross Annual Revenue in EUR",
               min = 0,
               max = 10000,
               step = 10,
               value = 100)
  
)

server <- function(input, output, session) {
  observe({
    output$num = renderPlot({
      hist(rnorm(input$slider))
    })  
  })
}

shinyApp(ui, server)

# Another section

install.packages("devtools")
library(devtools)
#devtools::install_github("rstudio/shinyapps")

# Deploy shiny apps directly from R console

install.packages("rsconnect")
rsconnect::setAccountInfo(name='ansikmahapatra',
                          token='4DACA4EF6DA5BAABDEE02FAC50D09F1F',
                          secret='YfAb3LTCSnJiU0bpxX3Msa5jmlnOPq3tZcvRJp14')
path<-"~/Dropbox/CodesProgramming/Codes - R/Temp/"
rsconnect::deployApp(path)
