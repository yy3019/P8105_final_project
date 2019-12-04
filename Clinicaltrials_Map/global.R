library(tidyverse)
library(readxl)





### function for frames (plotly animation)
accumulate_by <- function(dat, var) {
  var <- lazyeval::f_eval(var, dat)
  lvls <- plotly:::getLevels(var)
  dats <- lapply(seq_along(lvls), function(x) {
    cbind(dat[var %in% lvls[seq(1, x)], ], frame = lvls[[x]])
  })
  dplyr::bind_rows(dats)
}



## steps for processing data in shiny App
geocode_state = read_excel("./states.xlsx") #geocode dataset

geocode_state =
  geocode_state %>%
  separate(location_state,c("location_state","country"),sep = ",") %>%
  select(-country) %>%
  rename("state_lat" = lat,
         "state_lng" = lng) # cleaning process


test_us = read_csv("./test_us.csv") %>%
  mutate(location_state = recode(location_state,
                                 "Missouri" = "Missouri State")) %>%
  select(-state_lat,-state_lng) # cleaning process, ready for getting lat/lng of each state

test_us = left_join(test_us, geocode_state) # merge data

test_us_completion = test_us %>%
  mutate(completion_year = str_sub(completion_date,start = -4)) # extract completion years of the studies

completion_by_agency = read_csv('completion_by_agency.csv') # read data in shiny APP
completion_by_agency$agency_class = factor(completion_by_agency$agency_class) # cleaning process

completion_by_state = read_csv('completion_by_state.csv') # read data in shiny APP

nih_ind = completion_by_agency %>% filter(agency_class == "NIH" | agency_class == "Industry") # studies sponsored only by NIh and Industry
other_fed = completion_by_agency %>% filter(agency_class != "NIH" & agency_class != "Industry") # studies sponsored only by U.S. Fed and Others

nih_ind = nih_ind %>%
  accumulate_by(~completion_year) #create frames for animation plot

other_fed = other_fed %>%
  accumulate_by(~completion_year)  #create frames for animation plot

completion_by_state = completion_by_state %>%
  accumulate_by(~completion_year)  #create frames for animation plot
####

####create datasets for plotting map in shiny APP
df = test_us
df1 = test_us %>% filter( agency_class == "U.S. Fed")
df2 = test_us %>% filter( agency_class == "NIH")
df3 = test_us %>% filter( agency_class == "Industry")
df4 = test_us %>% filter( agency_class == "Other")

#sponsor dataset for Shiny APP
sponsor = 
  test_us %>%
  mutate(sponsors = str_replace(sponsors, "Other", " "),
         sponsors = str_replace(sponsors, "NIH", " "),
         sponsors = str_replace(sponsors, "Industry", " "),
         sponsors = str_replace(sponsors, "U.S. Fed", " ")
         ) %>%
  group_by(sponsors) %>%
  summarise(studies = n(),
            enrollment = sum(enrollment),
            enrollment.mean = enrollment/studies,
            enrollment.min = min(enrollment),
            enrollment.max = max(enrollment))



# Shiny UI settings
choice_map = c("All","US Fed", "NIH", "Industry", "Other")
choice_study_info = c("Sponsor Type", "Condition Type", "Intervention Type", "Status", "Enrollment", "Phase (Clinical Trial)", "Duration")
choice_sponsor = c("sponsor_type", "sponsor", "sponsor_num")
choice_time = c("Studies by Start Year", "Studies by Completion Year")
choice_phase = c("Phase 1/Phase 2", "Phase 3", "Phase 2", "Phase 1", "Phase 4", "Phase 2/Phase 3", "Early Phase 1")
agency = c("NIH VS Industry",
           "U.S. Fed VS Others")
all_sponsor = unique(sponsor$sponsors)











