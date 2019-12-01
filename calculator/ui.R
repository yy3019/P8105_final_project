library(shiny)

shinyUI(
    navbarPage("Fragilty Index Calculator", id = "inTabset",
               
               tabPanel("About", value = "about",
                        fluidRow(
                            column(9,
                                   h3("The Fragility Index of meta-analyses"),
                                   tags$p("The statistical significance of a meta-analysis of a binary outcome could be changed if the outcomes of a few patients were modified within the randomized controlled trials included in it."),
                                   tags$p(tags$strong("The Fragility Index for meta-analyses"), 
                                          " of randomized controlled trials is an intuitive measure for the confidence we have in the statistical significance of a meta-analysis."), 
                                   tags$p("Here we use two functions to evaluate the Fragility:"),
                                   tags$p("- Statistically significant meta-analyses `fragility_sign_ma.R`"),
                                   tags$p("- Statistically non-significant meta-analyses `fragility_non_sign_ma.R`"),
                                   h3("Data requirements"),
                                   tags$p("The data you upload should be a CSV file looking like this:"),
                                   tableOutput('ex_table'),
                                   tags$p("Where the following headers need to be present:"),
                                   tags$ul(tags$li(tags$b("STUDY_ID: "),"an ID for each trial in the meta-analysis"),
                                           tags$li(tags$b("EVENTS_1: "),"the number of events in Arm 1"),
                                           tags$li(tags$b("TOTAL_1: "),"the total number of patients included in Arm 1"),
                                           tags$li(tags$b("EVENTS_2: "),"the number of events in Arm 2"),
                                           tags$li(tags$b("TOTAL_2: "),"the total number of patients included in Arm 2"))))),
               
               
        tabPanel("Evaluate the Fragility", value = "fragility",
                 h3("Evaluate the Fragility Index for your own meta-analysis"),
                            
                 sidebarPanel(
                     tags$p(tags$strong("1- Upload meta-analysis data as CSV File")),
                     tags$em("(See ", actionLink('jumpToData', 'data requirements'), " for help)"),
                     fileInput("file1", label = NULL,
                               accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
                     tags$p(tags$strong("2- Select the parameters of the meta-analysis")),
                     selectInput(inputId = "method", label = tags$p(tags$u("Method:"),
                                                                    style = "font-weight:normal;"),
                                 choices = c("Mantel-Haenszel" = "MH",
                                             "Inverse Variance" = "Inverse",
                                             "Peto" = "PETO"),
                                 selected = "MH"),
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
                                      htmlOutput("modifications_text")),width = 9))
                 
        
        
        
)

)
