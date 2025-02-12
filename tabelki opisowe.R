install.packages("gtsummary")
library(gtsummary)
library(tidyverse)

# Tworzenie tabeli podsumowującej
summary_table <- czyste_dane %>%
  select(Exam_Score, Hours_Studied, Attendance, Parental_Involvement, 
         Access_to_Resources, Extracurricular_Activities, Sleep_Hours, 
         Previous_Scores, Motivation_Level, Internet_Access) %>%
  tbl_summary(by = Exam_Score > median(czyste_dane$Exam_Score, na.rm = TRUE),
              statistic = list(all_continuous() ~ "{mean} ({sd})",
                               all_categorical() ~ "{n} ({p}%)"),
              missing = "no") %>%
  add_p()

summary_table

?tbl_summary

str(czyste_dane_ft)

czyste_dane_ft <- czyste_dane %>%
  mutate(across(where(is.character), as.factor))

write.csv(czyste_dane_ft, "czyste_dane_ft", row.names = FALSE)
