install.packages("gtsummary")
library(gtsummary)
library(tidyverse)
library(dplyr)

# Zamiana kolumn typu character na factor
data <- data %>%
  mutate(across(where(is.character), as.factor))

# Tworzenie tabeli podsumowującej
summary_table <- czyste_dane %>%
  select(Exam_Score, Hours_Studied, Attendance, Parental_Involvement, 
summary_table <- czyste_dane_ft %>%
  select(grupa2, Hours_Studied, Attendance, Parental_Involvement, 
         Access_to_Resources, Extracurricular_Activities, Sleep_Hours, 
         Previous_Scores, Motivation_Level, Internet_Access) %>%
  tbl_summary(by = Exam_Score > median(czyste_dane$Exam_Score, na.rm = TRUE),
              statistic = list(all_continuous() ~ "{mean} ({sd})",
                               all_categorical() ~ "{n} ({p}%)"),
              missing = "no") %>%
  add_p()

summary_table
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

?tbl_summary

str(czyste_dane_ft)

czyste_dane_ft <- czyste_dane %>%
  mutate(across(where(is.character), as.factor))

write.csv(czyste_dane_ft, "czyste_dane_ft", row.names = FALSE)
# Wyświetlenie tabeli
summary_table