library(shiny)
library(leaflet)
library(RColorBrewer)
library(plotly)

#ui <- bootstrapPage()
#  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  #leafletOutput("map", width = "100%", height = "100%"),
  #absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
   #             draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
    #            width = 330, height = "auto",
     #           
      #          h2("See Trials in the United States!"),
       #         
        #        selectInput("choice",
         #                      "Select agency class",
          #                     choice_map)
  #)
#)######

######
navbarPage("See Clinicaltrials in United States!", id="nav",
           
           tabPanel("Spatial Distribution",
                    div(class="outer",
                        
                        tags$head(
                          # Include our custom CSS
                          includeCSS("style.css"),
                          includeScript("gomap.js")
                        ),
                        
                        
                        leafletOutput("map", width="100%", height="100%"),
                        
                        
                        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                      draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                                      width = 330, height = "auto",
                                      
                                      h2("Select Studies"),
                                      
                                      selectInput("choice", "Select agency class", choice_map),
                                      selectInput("agency", "Compare agencies", agency),
                                      plotlyOutput("map_plotly", height = 300)),
                        
                        
                        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                      draggable = TRUE, top = 260, left = 230, right =70 , bottom = "auto",
                                      width = 330, height = "auto",
                                      
                                      plotOutput("map_plot", height = 500)
                              
                        ),
                        
                        tags$div(id="cite",
                                 'Data compiled for ', tags$em('Clinical Trials in United States'), ' by Fragelity Index Group.'
                        )
                    )
           ),
           
           tabPanel("Sponsor Information",
                    h2("Search Sponsor Information"),
                    hr(),
                    DT::dataTableOutput("table")
           ),
           
           conditionalPanel("false", icon("crosshair"))
)