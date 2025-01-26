#making a group based on data in a column Hours_Studied
#grouping the data based on the column Hours_Studied
grouped = df.groupby('Hours_Studied')
View(czyste_dane)



# Obliczenie kwartali dla kolumny Hours_Studied
quantiles <- quantile(czyste_dane$Hours_Studied)

# Wyświetlenie wyników
print(quantiles)
# Podział danych na grupy
czyste_dane_temp <- czyste_dane %>%
  mutate(grupa = case_when(
    Hours_Studied < 16 ~ "poniżej 16",
    Hours_Studied >= 16 & Hours_Studied <= 23 ~ "16-23",
    Hours_Studied >= 23 ~ "powyżej 23"
  ))
as.factor(czyste_dane_temp$grupa)
str(czyste_dane_temp)
# Sprawdzenie danych
print(czyste_dane)
library(dplyr)
library(ggplot2)
#wykres
ggplot(czyste_dane_temp, aes(x = grupa, y = Exam_Score, fill = grupa)) +
  geom_boxplot() +
  theme_minimal() +
  labs(title = "Wpływ godzin nauki na wynik egzaminu",
       x = "Grupa godzin nauki",
       y = "Wynik egzaminu") +
  scale_fill_brewer(palette = "Set3")