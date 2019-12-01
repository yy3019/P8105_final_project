library(shiny)

shinyUI(
    navbarPage("Fragilty Index Calcultor", id = "inTabset",

        
        tabPanel("Evaluate the Fragility", value = "fragility",
                 h3("Evaluate the Fragility Index for your own meta-analysis"),
                 sidebarPanel(
                     tags$p(tags$strong("Upload meta-analysis data as CSV File")),
                     tags$em("(See ", actionLink('jumpToData', 'data requirements'), " for help)"),
                     fileInput("file1", label = NULL,
                               accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),

                     selectInput(inputId = "measure", label = tags$p(tags$u("Measure:"),
                                                                    style = "font-weight:normal;"),
                                 choices = c("Odds Ratio" = "OR",
                                             "Risk Difference" = "RD",
                                             "Risk Ratio" = "RR"),
                                 selected = "RR"),
                     selectInput(inputId = "random", label = tags$p(tags$u("Random effects:"),
                                                                    style = "font-weight:normal;"),
                                 choices = c("Fixed effects" = "NO",
                                             "Random effects" = "YES"),
                                 selected = "NO"),
                     tags$p(tags$strong("3- Evaluate the Fragility Index")),
                     actionButton("compute_fragility", "Evaluate the Fragility Index!"),
                     width = 3),
                 
                 mainPanel(
                     h4(textOutput("is_significant"),align="center"),
                     plotOutput("initPlot",width = "100%",height = "auto"),
                     tags$hr(),

                     conditionalPanel(condition = "output.show == true",       
                                      tags$div(style = "border: 1px solid black",
                                               h4(textOutput("fragility_index"),align="center"),
                                               h3(textOutput("fragility_index2"),align="center")),
                                      plotOutput('fragilePlot',width = "100%",height = "auto"),
                                      tags$hr(),
                                      htmlOutput("modifications_text")),
                     width = 9)
                 ),

        tabPanel("Data requirements", value = "data",
                 tags$h3("Data requirements"),
                 tags$p("The data you upload should be a CSV file looking like this:"),
                 tableOutput('ex_table'),
                 tags$p("Where the following headers need to be present:"),
                 tags$ul(tags$li(tags$b("EVENTS_1: "),"the number of events in Arm 1"),
                         tags$li(tags$b("TOTAL_1: "),"the total number of patients included in Arm 1"),
                         tags$li(tags$b("EVENTS_2: "),"the number of events in Arm 2"),
                         tags$li(tags$b("TOTAL_2: "),"the total number of patients included in Arm 2")),
                 tags$p('Fields in the CSV should be separated with a comma (,), and text should be delimited with quotation marks (")'),
                 tags$p(actionLink('jumpToFragility2', "Evaluate the Fragility Index"),
                        " of your own meta-analysis!")
                 ),
        tabPanel("Example", value = "example",
                 tags$h3("Detailed example of the iterative method used to evaluate the Fragility Index of a meta-analysis"),
                 HTML("<img src='figure_tracking_FI.svg' alt='' width='600px' />")
        )
        

    
        )
)
