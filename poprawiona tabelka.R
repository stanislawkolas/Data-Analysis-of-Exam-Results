install.packages("gtsummary")
install.packages("ggstatsplot")
library(gtsummary)
library(tidyverse)
library(dplyr)
library(readr)
library(ggstatsplot)

czyste_dane_ft <- read_csv("czyste_dane_ft.csv")
View(czyste_dane_ft)

# Zamiana kolumn typu character na factor
data <- data %>%
czyste_dane_ft <- czyste_dane %>%
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
summary_tablesummary_tablesummary_tablesummary_table

# Instalacja i załadowanie wymaganych pakietów
install.packages("tidyverse")
install.packages("ggplot2")

library(tidyverse)
library(ggplot2)

# Wczytanie danych
data <- read.csv("ścieżka_do_pliku/czyste_dane.csv")

# Sprawdzenie struktur zmiennych
str(data)

# 1. Wpływ godzin nauki na wynik egzaminu (test korelacji Spearmana)
cor_hours <- cor.test(czyste_dane_ft$Hours_Studied, czyste_dane_ft$Exam_Score, method = "spearman")

# 2. Zależność wyniku egzaminu od frekwencji (test korelacji Spearmana)
cor_attendance <- cor.test(czyste_dane_ft$Attendance, czyste_dane_ft$Exam_Score, method = "spearman")

# 3. Zależność wyniku egzaminu od liczby sesji korepetycji (test korelacji Spearmana)
cor_tutoring <- cor.test(czyste_dane_ft$Tutoring_Sessions, czyste_dane_ft$Exam_Score, method = "spearman")

# 4. Liczba wyników egzaminu w zależności od typu szkoły (test ANOVA)
anova_school <- aov(Exam_Score ~ School_Type, data = czyste_dane_ft)
anova_summary <- summary(anova_school)

# 5. Procentowy udział osób z zaburzeniami uczenia się
learning_disabilities_percent <- czyste_dane_ft %>%
  group_by(Learning_Disabilities) %>%
  summarise(count = n()) %>%
  mutate(percent = round(count / sum(count) * 100, 2))

# Wyświetlenie wyników analizy
list(
  "Korelacja godzin nauki z wynikiem egzaminu" = cor_hours,
  "Korelacja frekwencji z wynikiem egzaminu" = cor_attendance,
  "Korelacja sesji korepetycji z wynikiem egzaminu" = cor_tutoring,
  "ANOVA - wpływ typu szkoły na wynik egzaminu" = anova_summary,
  "Procentowy udział osób z zaburzeniami uczenia się" = learning_disabilities_percent
)

#Godziny nauki a wynik egzaminu
ggstatsplot::ggscatterstats(
  data = czyste_dane_ft,
  x = Hours_Studied,
  y = Exam_Score,
  type = "spearman",  # Test korelacji Spearmana
  title = "Korelacja między godzinami nauki a wynikiem egzaminu",
  bf.message = FALSE
)

#Wykres porównawczy: Typ szkoły a wynik egzaminu
ggstatsplot::ggbetweenstats(
  data = czyste_dane_ft,
  x = School_Type,
  y = Exam_Score,
  type = "parametric",  # ANOVA (lub zmień na "nonparametric" dla Kruskala-Wallisa)
  title = "Porównanie wyników egzaminów w różnych typach szkół",
  bf.message = FALSE
)

# Analiza wpływu korepetycji na wyniki egzaminów
ggstatsplot::ggscatterstats(
  data = czyste_dane_ft,
  x = Tutoring_Sessions,
  y = Exam_Score,
  type = "spearman",
  title = "Wpływ liczby sesji korepetycji na wynik egzaminu",
  bf.message = FALSE
)

#Analiza wpływu frekwencji na wynik egzaminu
ggstatsplot::ggscatterstats(
  data = czyste_dane_ft,
  x = Attendance,
  y = Exam_Score,
  type = "spearman",
  title = "Zależność wyniku egzaminu od frekwencji",
  bf.message = FALSE
)

#Procentowy udział ucznów z zaburzeniami uczenia się
ggstatsplot::ggpiestats(
  data = czyste_dane_ft,
  x = Learning_Disabilities,
  title = "Procentowy udział uczniów z zaburzeniami uczenia się",
  bf.message = FALSE
)
