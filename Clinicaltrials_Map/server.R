library(shiny)
library(shinyjs)
library(leaflet)
library(tidyverse)
library(plotly)
library(viridis)
library(gganimate)



# font size

t <- list(
  family = "sans serif",
  size = 8)


################
# This is only for US clinical trials
## 1. merge latitude and longtitude ok
## 2. recode the study type 
## 3. create a ineraction map grouped by study type and agency class
  



shinyServer(function(input, output){
  
    
  ####
  output$table <- DT::renderDataTable({
    data.table::data.table(sponsor) #%>% 
    #formatStyle(input$selected, background="skyblue", fontWeight='bold')
  })
  ### MAPS ###
  output$map <- renderLeaflet({
    
    if (input$choice == "All") {
      leaflet() %>% 
        addTiles() %>%
        addMarkers(data = df %>% filter(study_type == "Interventional"), lng = ~ state_lng, lat = ~ state_lat, group = "Interventional" , clusterOptions = markerClusterOptions()) %>%
        addMarkers(data = df %>% filter(study_type == "Observational"), lng = ~ state_lng, lat = ~ state_lat, group = "Observational" , clusterOptions = markerClusterOptions()) %>%
        addMarkers(data = df %>% filter(study_type == "Observational [Patient Registry]"), lng = ~ state_lng, lat = ~ state_lat, group = "Observational [Patient Registry]", clusterOptions = markerClusterOptions()) %>%
        addMarkers(data = df %>% filter(study_type == "Expanded Access"), lng = ~ state_lng, lat = ~ state_lat, group = "Expanded Access", clusterOptions = markerClusterOptions()) %>%
        addLayersControl(
          baseGroups = c("Interventional", "Observational","Observational [Patient Registry]","Expanded Access" ),
          options = layersControlOptions(collapsed = FALSE),
          position = c("topleft") 
        ) 
    } 
    
    else if (input$choice == "US Fed") {
      leaflet() %>%
        addTiles() %>%
        addMarkers(data = df1 %>% filter(study_type == "Interventional"), lng = ~ state_lng, lat = ~ state_lat, group = "Interventional" , clusterOptions = markerClusterOptions()) %>%
        addMarkers(data = df1 %>% filter(study_type == "Observational"), lng = ~ state_lng, lat = ~ state_lat, group = "Observational" , clusterOptions = markerClusterOptions()) %>%
        addMarkers(data = df1 %>% filter(study_type == "Observational [Patient Registry]"), lng = ~ state_lng, lat = ~ state_lat, group = "Observational [Patient Registry]", clusterOptions = markerClusterOptions()) %>%
        addMarkers(data = df1 %>% filter(study_type == "Expanded Access"), lng = ~ state_lng, lat = ~ state_lat, group = "Expanded Access", clusterOptions = markerClusterOptions()) %>%
        addLayersControl(
          baseGroups = c("Interventional", "Observational","Observational [Patient Registry]","Expanded Access" ),
          options = layersControlOptions(collapsed = FALSE),
          position = c("topleft") 
        )        
      
    } else if (input$choice == "NIH") {
      leaflet() %>%
        addTiles() %>%
        addMarkers(data = df2 %>% filter(study_type == "Interventional"), lng = ~ state_lng, lat = ~ state_lat, group = "Interventional" , clusterOptions = markerClusterOptions()) %>%
        addMarkers(data = df2 %>% filter(study_type == "Observational"), lng = ~ state_lng, lat = ~ state_lat, group = "Observational" , clusterOptions = markerClusterOptions()) %>%
        addMarkers(data = df2 %>% filter(study_type == "Observational [Patient Registry]"), lng = ~ state_lng, lat = ~ state_lat, group = "Observational [Patient Registry]", clusterOptions = markerClusterOptions()) %>%
        addMarkers(data = df2 %>% filter(study_type == "Expanded Access"), lng = ~ state_lng, lat = ~ state_lat, group = "Expanded Access", clusterOptions = markerClusterOptions()) %>%
        addLayersControl(
          baseGroups = c("Interventional", "Observational","Observational [Patient Registry]","Expanded Access" ),
          options = layersControlOptions(collapsed = FALSE),
          position = c("topleft") 
        )
      
    } else if (input$choice == "Industry") {
      leaflet() %>%
        addTiles() %>%
        addMarkers(data = df3 %>% filter(study_type == "Interventional"), lng = ~ state_lng, lat = ~ state_lat, group = "Interventional" , clusterOptions = markerClusterOptions()) %>%
        addMarkers(data = df3 %>% filter(study_type == "Observational"), lng = ~ state_lng, lat = ~ state_lat, group = "Observational" , clusterOptions = markerClusterOptions()) %>%
        addMarkers(data = df3 %>% filter(study_type == "Observational [Patient Registry]"), lng = ~ state_lng, lat = ~ state_lat, group = "Observational [Patient Registry]", clusterOptions = markerClusterOptions()) %>%
        addMarkers(data = df3 %>% filter(study_type == "Expanded Access"), lng = ~ state_lng, lat = ~ state_lat, group = "Expanded Access", clusterOptions = markerClusterOptions()) %>%
        addLayersControl(
          baseGroups = c("Interventional", "Observational","Observational [Patient Registry]","Expanded Access" ),
          options = layersControlOptions(collapsed = FALSE),
          position = c("topleft") 
        )        
      
    } else {
      leaflet() %>%
        addTiles() %>%
        addMarkers(data = df4 %>% filter(study_type == "Interventional"), lng = ~ state_lng, lat = ~ state_lat, group = "Interventional" , clusterOptions = markerClusterOptions()) %>%
        addMarkers(data = df4 %>% filter(study_type == "Observational"), lng = ~ state_lng, lat = ~ state_lat, group = "Observational" , clusterOptions = markerClusterOptions()) %>%
        addMarkers(data = df4 %>% filter(study_type == "Observational [Patient Registry]"), lng = ~ state_lng, lat = ~ state_lat, group = "Observational [Patient Registry]", clusterOptions = markerClusterOptions()) %>%
        addMarkers(data = df4 %>% filter(study_type == "Expanded Access"), lng = ~ state_lng, lat = ~ state_lat, group = "Expanded Access", clusterOptions = markerClusterOptions()) %>%
        addLayersControl(
          baseGroups = c("Interventional", "Observational","Observational [Patient Registry]","Expanded Access" ),
          options = layersControlOptions(collapsed = FALSE),
          position = c("topleft") 
        )
    }
    
  })
  # plots
  output$map_plot <- renderPlot({
    
    if (input$choice == "All"){
 
    df %>%
      group_by(location_state) %>%
      summarise(total = n()) %>%
      ggplot(aes( x = reorder(location_state, total), y = total, fill = location_state)) +
      geom_col() +
      scale_fill_viridis(option = "viridis" , discrete = TRUE) + 
      coord_flip() +
      theme_minimal() +
      theme(legend.position = "none",
            plot.title = element_text(hjust = .5)) +
      labs(x = "Total",
           y = "States",
           title = "Numbers of trials in States (All)")
        
    }
    
    else if(input$choice == "NIH"){

    df2 %>%
      group_by(location_state) %>%
      summarise(total = n()) %>%
      ggplot(aes( x = reorder(location_state, total), y = total, fill = location_state)) +
      geom_col() +
      scale_fill_viridis(option = "viridis" , discrete = TRUE) +  
      coord_flip() +
      theme_minimal() +
        theme(legend.position = "none",
              plot.title = element_text(hjust = .5)) +
        labs(x = "Total",
             y = "States",
             title = "Numbers of trials in States (NIH)")
    }
    
    else if(input$choice == "Industry"){
  
    df3 %>%
      group_by(location_state) %>%
      summarise(total = n()) %>%
      ggplot(aes( x = reorder(location_state, total), y = total, fill = location_state)) +
      geom_col() +
      scale_fill_viridis(option = "viridis" , discrete = TRUE) +  
      coord_flip() +
      theme_minimal() +
        theme(legend.position = "none",
              plot.title = element_text(hjust = .5)) +
        labs(x = "Total",
             y = "States",
             title = "Numbers of trials in States (Industry)")
    }
    
    else if(input$choice == "Other"){

    df4 %>%
      group_by(location_state) %>%
      summarise(total = n()) %>%
      ggplot(aes( x = reorder(location_state, total), y = total, fill = location_state)) +
      geom_col() +
      scale_fill_viridis(option = "viridis" , discrete = TRUE) +  
      coord_flip() +
      theme_minimal() +
        theme(legend.position = "none",
              plot.title = element_text(hjust = .5)) +
        labs(x = "Total",
             y = "States",
             title = "Numbers of trials in States (Others)")
    }
    
    else{
      
      df1 %>%
        group_by(location_state) %>%
        summarise(total = n()) %>%
        ggplot(aes( x = reorder(location_state, total), y = total, fill = location_state)) +
        geom_col() +
        scale_fill_viridis(option = "viridis" , discrete = TRUE) +
        coord_flip() +
        theme_minimal() +
        theme(legend.position = "none",
              plot.title = element_text(hjust = .5)) +
        labs(x = "Total",
             y = "States",
             title = "Numbers of trials in States (U.S Fed)")
      
    } 
    })
  #plots
  output$map_plotly <- renderPlotly({
    if(input$agency =="NIH VS Industry"){
      nih_ind %>%
        plot_ly(
          x = ~ completion_year,
          y = ~ number_of_clinical_trials,
          frame = ~frame,
          type = 'scatter',
          mode = 'lines',
          color = ~ agency_class,
          text = ~agency_class, hoverinfo = "text") %>%
        layout(yaxis = list(type = "log",title = "Number of Trials"),
               xaxis = list(title = "Completion Year"),
               title = "Number of Completed Studies Sponsored by NIH and Industry",
               font = t) %>%
        add_markers(colors = viridis_pal(option = "D")(2) , frame = ~frame, ids = ~agency_class) %>%
        animation_opts(150, easing = "elastic", transition = 0, redraw = FALSE) %>%
        animation_button(
          x = 1, xanchor = "right", y = 0, yanchor = "bottom") %>%
        animation_slider(
          currentvalue = list(prefix = "YEAR ", font = list(color="red")),
          hide = T)
    }
    
    else{
      other_fed %>%
        plot_ly(
          x = ~ completion_year,
          y = ~ number_of_clinical_trials,
          frame = ~frame,
          type = 'scatter',
          mode = 'lines',
          split = ~agency_class,
          text = ~agency_class, hoverinfo = "text") %>%
        layout(yaxis = list(type = "log",title = "Number of Trials"),
               xaxis = list(title = "Completion Year"),
               title = "Number of Completed Studies Sponsored by U.S. Fed and Others",
               font = t) %>%
        add_markers(color = ~agency_class, frame = ~frame, ids = ~agency_class) %>%
        animation_opts(50, easing = "elastic", transition = 0, redraw = FALSE) %>%
        animation_button(
          x = 1, xanchor = "right", y = 0, yanchor = "bottom"
        ) %>%
        animation_slider(
          currentvalue = list(prefix = "YEAR ", font = list(color="red")),
          hide = T
        )
    }
  })
})
