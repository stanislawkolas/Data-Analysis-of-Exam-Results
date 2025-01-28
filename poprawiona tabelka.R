install.packages("gtsummary")
library(gtsummary)
library(tidyverse)
library(dplyr)

# Zamiana kolumn typu character na factor
data <- data %>%
  mutate(across(where(is.character), as.factor))

# Tworzenie tabeli podsumowującej
summary_table <- data %>%
  select(grupa2, Hours_Studied, Attendance, Parental_Involvement, 
         Access_to_Resources, Extracurricular_Activities, Sleep_Hours, 
         Previous_Scores, Motivation_Level, Internet_Access, 
         Tutoring_Sessions, Family_Income, Teacher_Quality, 
         School_Type, Peer_Influence, Physical_Activity, 
         Learning_Disabilities, Parental_Education_Level, 
         Distance_from_Home, Gender) %>%
  tbl_summary(
    by = grupa2, # Grupowanie według kolumny grupa2
    statistic = list(
      all_continuous() ~ "{mean} ({sd})", # Średnia i odchylenie standardowe
      all_categorical() ~ "{n} ({p}%)"   # Liczba i procent
    ),
    missing = "no" # Ignorowanie brakujących danych
  ) %>%
  add_p() %>%      # Dodanie testów statystycznych
  add_overall() %>% # Dodanie kolumny ogólnej
  bold_labels()    # Pogrubienie etykiet

# Wyświetlenie tabeli
summary_table