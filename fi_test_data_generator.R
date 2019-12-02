library(tidyverse)

max_val = 20

nonsig_trial_test3 <- tibble(
  STUDY_ID = str_c("trial ", 1:max_val),
  EVENTS_1 = sample(50:100, max_val),
  TOTAL_1 = sample(100:300, max_val),
  EVENTS_2 = sample(50:100, max_val),
  TOTAL_2 = sample(100:400, max_val)
)

write.csv(trial_test3, str_c(getwd(), "/Desktop/trial_test3.csv"))


sig_trial_test <- tibble(
  STUDY_ID = str_c("trial ", 1:max_val),
  EVENTS_1 = sample(89:100, max_val, replace = TRUE),
  TOTAL_1 = sample(100:120, max_val, replace = TRUE),
  EVENTS_2 = sample(50:100, max_val, replace = TRUE),
  TOTAL_2 = sample(100:120, max_val, replace = TRUE)
) 

write.csv(sig_trial_test, str_c(getwd(), "/Desktop/sig_trial_test.csv"))
