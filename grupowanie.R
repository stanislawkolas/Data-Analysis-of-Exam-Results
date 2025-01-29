#making a group based on data in a column Hours_Studied
#grouping the data based on the column Hours_Studied
grouped = df.groupby('Hours_Studied')
View(czyste_dane)

# Load the required libraries
library(ggplot2) 
library(hrbrthemes) 
library(plotly)
library(ISLR)
install.packages("gapminder")
library(gapminder)
library(dplyr)
library(ggplot2)


# Obliczenie kwartali dla kolumny Hours_Studied
quantiles <- quantile(czyste_dane$Hours_Studied)

# Wyświetlenie wyników
print(quantiles)
# Podział danych na grupy
czyste_dane_temp <- czyste_dane %>%
  mutate(grupa1 = case_when(
    Hours_Studied < 16 ~ "poniżej 16",
    Hours_Studied >= 16 & Hours_Studied <= 23 ~ "16-23",
    Hours_Studied >= 23 ~ "powyżej 23"
  ))

# Sprawdzenie danych
print(czyste_dane)
library(dplyr)
library(ggplot2)
#Uszeregowanie danych w grupach
czyste_dane_temp$grupa1 <- factor(czyste_dane_temp$grupa1, levels = c("poniżej 16", "16-23", "powyżej 23"))
#wykres
ggplot(czyste_dane_temp, aes(x = grupa1, y = Exam_Score, fill = grupa1)) +
  geom_boxplot() +
  theme_minimal() +
  labs(title = "Wpływ godzin nauki na wynik egzaminu",
       x = "Ilość godzin nauki",
       y = "Wynik egzaminu") +
  scale_fill_brewer(palette = "Set4")

# Podział kolumny Exam_Score na grupy
czyste_dane_temp2 <- czyste_dane %>%
  mutate(grupa2 = case_when(
    Exam_Score < 60 ~ "2.0",                          # poniżej 60
    Exam_Score >= 60 & Exam_Score <= 65 ~ "3.0",      # 60 do 65
    Exam_Score >= 66 & Exam_Score <= 70 ~ "3.5",      # 66 do 70
    Exam_Score >= 71 & Exam_Score <= 80 ~ "4.0",      # 71 do 80
    Exam_Score >= 81 & Exam_Score <= 90 ~ "4.5",      # 81 do 90
    Exam_Score > 90 ~ "5.0",                          # powyżej 90
    TRUE ~ "Brak danych"                              # "Brak danych", by uniknąć NA
  ))
#ustawianie pogrupowanych danych jako factor
czyste_dane_temp2 <- czyste_dane_temp2 %>%
  mutate(grupa2 = factor(grupa2, levels = c("2.0", "3.0", "3.5", "4.0", "4.5", "5.0")))

#Wykres Boxplot pokazujący zależnośc oceny na egzaminie od frekwencji na zajęciach
ggplot(czyste_dane_temp2, aes(x = grupa2, y = Attendance, fill = grupa2)) +
  geom_boxplot() +
  theme_minimal() +
  labs(
    title = "Zależność wyniku egzaminu od frekwencji na zajęciach",
    y = "Frekwencja w %",
    x = "Ocena z egzaminu egzaminu"
  ) +
  scale_fill_brewer(palette = "Set5") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Wykres Boxplot pokazujący zależność oceny na egzaminie od liczby sesji korepetycji w tygodniu
ggplot(czyste_dane_temp2, aes(x = grupa2, y = Tutoring_Sessions, fill = grupa2)) +
  geom_boxplot() +
  theme_minimal() +
  labs(
    title = "Zależność wyniku egzaminu od liczby sesji korepetycji w tygodniu",
    y = "Liczba sesji korepetycji w tygodniu",
    x = "Ocena z egzaminu"
  ) +
  scale_fill_brewer(palette = "Set5") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Tworzymy wykresy barplotów
ggplot(czyste_dane_temp2, aes(x = grupa2, fill = grupa2)) +
  geom_bar(position = "dodge") +  # Słupki obok siebie
  facet_wrap(~ School_Type) +  # Dwa panele: jeden dla szkoły prywatnej, drugi dla publicznej
  theme_minimal() +
  labs(
    title = "Liczba wyników egzaminu w zależności od typu szkoły",
    x = "Ocena z egzaminu",
    y = "Liczba uczniów"
  ) +
  scale_fill_brewer(palette = "Reds") 


# Obliczanie procentów
czyste_dane_temp2 <- czyste_dane_temp2 %>%
  group_by(grupa2, Learning_Disabilities) %>%
  summarise(count = n()) %>%
  mutate(percentage = count / sum(count) * 100)

# Tworzymy wykresy kołowe
ggplot(czyste_dane_temp2, aes(x = "", y = percentage, fill = Learning_Disabilities)) +
  geom_bar(stat = "identity", width = 1, color = "white") +  # Wykres kołowy
  coord_polar(theta = "y") +  # Konwersja do wykresu kołowego
  facet_wrap(~ grupa2) +  # Podział na wykresy dla każdej oceny
  theme_minimal() +
  labs(
    title = "Procentowy udział osób z zaburzeniami w uczeniu się dla każdej oceny",
    x = NULL,
    y = NULL
  ) +
  scale_fill_manual(values = c("Yes" = "#FF6666", "No" = "#66B3FF")) +
  theme(axis.text.x = element_blank(),
        axis.ticks = element_blank())  
