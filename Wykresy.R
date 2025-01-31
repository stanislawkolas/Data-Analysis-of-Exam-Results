
#zapisanie pliku do csv
write.csv(czyste_dane, "czyste_dane.csv")

# Ładowanie bibliotek
library(dplyr)
library(ggplot2)

# Dodanie kolumn 'grupa1' (podział według godzin nauki)
czyste_dane <- czyste_dane %>%
  mutate(grupa1 = case_when(
    Hours_Studied < 16 ~ "poniżej 16",
    Hours_Studied >= 16 & Hours_Studied <= 23 ~ "16-23",
    Hours_Studied > 23 ~ "powyżej 23"
  )) %>%
  mutate(grupa1 = factor(grupa1, levels = c("poniżej 16", "16-23", "powyżej 23")))

# Dodanie kolumny 'grupa2' (podział Exam_Score według ocen)
czyste_dane <- czyste_dane %>%
  mutate(grupa2 = case_when(
    Exam_Score < 60 ~ "2.0",
    Exam_Score >= 60 & Exam_Score <= 65 ~ "3.0",
    Exam_Score >= 66 & Exam_Score <= 70 ~ "3.5",
    Exam_Score >= 71 & Exam_Score <= 80 ~ "4.0",
    Exam_Score >= 81 & Exam_Score <= 90 ~ "4.5",
    Exam_Score >= 91 ~ "5.0",
    TRUE ~ "Brak danych"
  )) %>%
  mutate(grupa2 = factor(grupa2, levels = c("2.0", "3.0", "3.5", "4.0", "4.5", "5.0")))

# Dodanie kolumny 'grupa3' (podział Previous_Scores według ocen)
czyste_dane <- czyste_dane %>%
  mutate(grupa3 = case_when(
    Previous_Scores < 60 ~ "2.0",
    Previous_Scores >= 60 & Previous_Scores <= 65 ~ "3.0",
    Previous_Scores >= 66 & Previous_Scores <= 70 ~ "3.5",
    Previous_Scores >= 71 & Previous_Scores <= 80 ~ "4.0",
    Previous_Scores >= 81 & Previous_Scores <= 90 ~ "4.5",
    Previous_Scores >= 91 ~ "5.0",
    TRUE ~ "Brak danych"
  )) %>%
  mutate(grupa3 = factor(grupa3, levels = c("2.0", "3.0", "3.5", "4.0", "4.5", "5.0")))

# 1. Wykres: Wpływ godzin nauki na wynik egzaminu
ggplot(czyste_dane, aes(x = grupa1, y = Exam_Score, fill = grupa1)) +
  geom_boxplot() +
  theme_minimal() +
  labs(
    title = "Wpływ godzin nauki na wynik egzaminu",
    x = "Ilość godzin nauki",
    y = "Wynik egzaminu"
  ) +
  scale_fill_brewer(palette = "Set4")

# 2. Wykres: Zależność oceny od frekwencji
ggplot(czyste_dane, aes(x = grupa2, y = Attendance, fill = grupa2)) +
  geom_boxplot() +
  theme_minimal() +
  labs(
    title = "Zależność wyniku egzaminu od frekwencji na zajęciach",
    x = "Ocena z egzaminu",
    y = "Frekwencja w %"
  ) +
  scale_fill_brewer(palette = "Set5") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# 3. Wykres: Zależność oceny od liczby sesji korepetycji
ggplot(czyste_dane, aes(x = grupa2, y = Tutoring_Sessions, fill = grupa2)) +
  geom_boxplot() +
  theme_minimal() +
  labs(
    title = "Zależność wyniku egzaminu od liczby sesji korepetycji w tygodniu",
    x = "Ocena z egzaminu",
    y = "Liczba sesji korepetycji w tygodniu"
  ) +
  scale_fill_brewer(palette = "Set5") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# 4. Wykres: Liczba wyników egzaminu w zależności od typu szkoły (barplot)
ggplot(czyste_dane, aes(x = grupa2, fill = grupa2)) +
  geom_bar(position = "dodge") +
  facet_wrap(~ School_Type) +
  theme_minimal() +
  labs(
    title = "Liczba wyników egzaminu w zależności od typu szkoły",
    x = "Ocena z egzaminu",
    y = "Liczba uczniów"
  ) +
  scale_fill_brewer(palette = "Reds")

# 5. Wykres: Procentowy udział osób z zaburzeniami uczenia się (wykres kołowy)
czyste_dane_pie <- czyste_dane %>%
  group_by(grupa2, Learning_Disabilities) %>%
  summarise(count = n(), .groups = "drop") %>%
  group_by(grupa2) %>%
  mutate(percentage = count / sum(count) * 100)

ggplot(czyste_dane_pie, aes(x = "", y = percentage, fill = Learning_Disabilities)) +
  geom_bar(stat = "identity", width = 1, color = "white") +
  coord_polar(theta = "y") +
  facet_wrap(~ grupa2) +
  theme_minimal() +
  labs(
    title = "Procentowy udział osób z zaburzeniami w uczeniu się dla każdej oceny",
    x = NULL,
    y = NULL
  ) +
  scale_fill_manual(values = c("Yes" = "#FF6666", "No" = "#66B3FF")) +
  theme(axis.text.x = element_blank(), axis.ticks = element_blank())

# 6. Wykres: Zależność oceny od liczby godzin nauki
ggplot(czyste_dane, aes(x = grupa2, y = Exam_Score, color = grupa2)) +
  geom_point() +
  theme_minimal() +
  labs(
    title = "Zależność wyniku egzaminu od liczby godzin nauki",
    x = "Ilość godzin nauki",
    y = "Wynik egzaminu"
  ) +
  scale_color_brewer(palette = "Set1")


# Tworzymy tabelę częstości
library(kableExtra)
library(dplyr)

tabela_kable <- table(czyste_dane$grupa2, czyste_dane$Extracurricular_Activities) 

# Konwersja tabeli na ramkę danych
tabela_df <- as.data.frame.matrix(tabela_kable)

# Tabela częstości zajęć dodatkowych dla każdej z ocen
kable(tabela_df, format = "html", caption = "Tabela częstości zajęć dodatkowych dla każdej oceny") %>%
  kable_styling(full_width = FALSE, bootstrap_options = c("striped", "hover", "condensed")) %>%
  row_spec(0, bold = TRUE, background = "#D3D3D3") %>% 
  row_spec(seq(1, nrow(tabela_df), 2), background = "#F0F8FF") 

#Tworzenie tabeli 2
tabela_kable2 <- table( czyste_dane$Access_to_Resources, czyste_dane$grupa2) 

# Konwersja tabeli na ramkę danych
tabela_df2 <- as.data.frame.matrix(tabela_kable2)
#Tabela częstości dostępu do zasobów dla każdej z ocen
kable(tabela_df, format = "html", caption = "Tabela częstości dostępu do zasobów dla każdej z ocen") %>%
  kable_styling(full_width = FALSE, bootstrap_options = c("striped", "hover", "condensed")) %>%
  row_spec(0, bold = TRUE, background = "#D3D3D3") %>%
  row_spec(seq(1, nrow(tabela_df), 2), background = "#F0F8FF") 

# 7.Histogram stworzony za pomocą biblioteki ggstatsplot
#na potrzeby wykresu zamiana danych na numeryczne
czyste_dane$grupa2num <- as.numeric(as.character(czyste_dane$grupa2))
library(ggstatsplot)
gghistostats(czyste_dane, 
             x= grupa2num,
             binwidth =0.5,
             xlab = "Skala ocen",
             title = "Analiza rozkładu ocen",
             caption = NULL,
             type = "parametric",
             bf.message = FALSE
             )
# 8.Histogram stworzony za pomocą biblioteki ggstatsplot
#na porzeby wykresu zamiana danych na numeryczne
czyste_dane$grupa3num <- as.numeric(as.character(czyste_dane$grupa3))
gghistostats(czyste_dane, 
             x= grupa3num,
             binwidth =0.5,
             xlab = "Skala ocen",
             title = "Analiza rozkładu ocen poprzedniego egzaminu",
             caption = NULL,
             type = "parametric",
             bf.message = FALSE
)
#9. Wykres zależności grupa 2 od Internet_Access
ggplot(czyste_dane, aes(x = Internet_Access, y = Exam_Score, fill = Exam_Score)) +
  geom_boxplot() +
  theme_minimal() +
  labs(
    title = "Zależność wyniku egzaminu od dostępu do internetu",
    x = "Dostęp do internetu",
    y = "Ocena z egzaminu"
  ) +
  scale_fill_brewer(palette = "Set5") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#10. Wykres zależności Exam_Score od Access_to_Resources
ggplot(czyste_dane, aes(x = Access_to_Resources, y = Exam_Score, fill = Exam_Score)) +
  geom_boxplot() +
  theme_minimal() +
  labs(
    title = "Zależność wyniku egzaminu od dostępu do zasobów",
    x = "Dostęp do zasobów",
    y = "Ocena z egzaminu"
  ) +
  scale_fill_brewer(palette = "Set5") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
