#wywołanie danych z csv
data <- read.csv(file = "czynniki.csv")

#stworzenie ramki danych którymi się zajmujemy
data <- data.frame(data)

#biblioteki potzrebne do imputacji danych
install.packages("dlookr")
install.packages("editrules") #reguły
install.packages("VIM")
install.packages("validate")
install.packages("gapminder")

library(dlookr)
library(editrules)
library(VIM)
library(validate)
library(ggplot2) 
library(hrbrthemes) 
library(plotly)
library(ISLR)
library(gapminder)


summary(data)
# ustalenie zasad według których dane mają być imputowane oraza jeżeli dane wyrastają poza skalę oznaczane będą jako błedy
library(validate)
RULE <- validator(Hours_Studied >= 0, 
                  Hours_Studied <= 30,
                  Attendance >= 0,
                  Attendance <= 100,
                  Parental_Involvement %in% c("Low","Medium","High"),
                  Access_to_Resources %in% c("Low", "Medium", "High"),
                  Extracurricular_Activities %in% c("No","Yes"),
                  Sleep_Hours >= 0, 
                  Previous_Scores >= 0, 
                  Previous_Scores<= 100, 
                  Motivation_Level %in% c("Low","Medium","High"),
                  Internet_Access %in% c("No","Yes"),
                  Tutoring_Sessions >= 0,
                  Family_Income %in% c("Low","Medium","High"),
                  Teacher_Quality %in% c("Low","Medium","High"),
                  School_Type %in% c("Public","Private"),
                  Peer_Influence %in% c("Negative","Neutral","Positive"),
                  Physical_Activity >= 0,
                  Physical_Activity <= 25,
                  Learning_Disabilities %in% c("No","Yes"),
                  Parental_Education_Level %in% c("High School","College","Postgraduate"),
                  Distance_from_Home %in% c("Near","Moderate","Far"),
                  Gender %in% c("Male","Female"),
                  Exam_Score >= 0,
                  Exam_Score <= 100)

summary(data)
View(data)

#sprawdzenie ilości danych które nie odpowidaja powyższym regułom ustalonym mna podtawie eksperckiej analizy
out   <- confront(data, RULE)
plot(out)
summary(out)

#zamiana danych typu character na factor
install.packages("dplyr")
library(dplyr)
data <- data %>%
  mutate_if(is.character, as.factor)
str(data)

#zastąpienie błędów na NA
install.packages("errorlocate")
library(errorlocate)
data_no_error <- replace_errors(data,RULE)
summary(data_no_error)

#imputacja danych przez hotdeck
library(VIM)
czyste_dane <- hotdeck(data_no_error)
View(czyste_dane)
#sprawdzenie czy wszytskie NA zostały zastąpione danymi przez hotdeck
czyste_dane %>%
  dplyr::select(Hours_Studied,Attendance, Parental_Involvement,Access_to_Resources, Extracurricular_Activities, Sleep_Hours, 
                Previous_Scores, Motivation_Level, Internet_Access, Tutoring_Sessions, Family_Income, Teacher_Quality, School_Type,
                Peer_Influence, Physical_Activity, Learning_Disabilities, Parental_Education_Level, Distance_from_Home, Gender) %>%
  finalfit::missing_plot()




# Wizualizacja danych - Stachu

library(ggplot2) 
library(hrbrthemes) 
library(plotly)
library(ISLR)
install.packages("gapminder")
library(gapminder)


# korelacja między nauką a wynikami
ggplot(czyste_dane, aes(x = Hours_Studied, y = Exam_Score, color = Motivation_Level)) +
  geom_point() +
  labs(title = "korelacja między nauką a wynikami",
       x = "Hours Studied",
       y = "Exam Score")

# czy wiecej nauki podnosi motywacje - wyróżnienie wartości odstających
ggplot(czyste_dane, aes(x = Motivation_Level, y = Exam_Score, fill = Motivation_Level)) +
  geom_boxplot() +
  labs(title = "czy wiecej nauki podnosi motywacje - wyróżnienie wartości odstających",
       x = "Motivation Level",
       y = "Exam Score")

# Jak sen wpływa na wyniki egzaminu
ggplot(czyste_dane, aes(x = Sleep_Hours, y = Exam_Score, color = Gender)) +
  geom_point() +
  labs(title = "Jak sen wpływa na wyniki egzaminu",
       x = "Sleep Hours",
       y = "Exam Score",
       color = "Gender")

#średni wynik egzaminu w podziale na wpływ rodziców

library(dplyr)

mean_scores <- czyste_dane %>%
  group_by(Parental_Involvement) %>%
  summarise(mean_exam_score = mean(Exam_Score, na.rm = TRUE))

library(ggplot2)

ggplot(mean_scores, aes(x = Parental_Involvement, y = mean_exam_score)) +
  geom_bar(stat = "identity", fill = "blue") +
  labs(title = "Średni wynik egzaminu w podziale na wpływ rodziców",
       x = "Parental Involvement", y = "Średni Exam_Score") +
  theme_minimal()

# Jaki wpływ na wynik egzaminu ma dochód rodziny oraz poziom edukacji rodziców

ggplot(czyste_dane, aes(x = Family_Income, y = Exam_Score, color = Parental_Education_Level)) +
  geom_point(alpha = 0.7) +
  labs(title = "Jaki wpływ na wynik egzaminu ma dochód rodziny oraz poziom edukacji rodziców",
       x = "Family Income",
       y = "Exam Score",
       color = "Parental Education Level") +
  theme_minimal()

# Wynik egzaminu w podziale na stopień edukacji rodziców

ggplot(czyste_dane, aes(x = Parental_Education_Level, y = Exam_Score, fill = Parental_Education_Level)) +
  geom_boxplot() +
  labs(title = "Wynik egzaminu w podziale na stopień edukacji rodziców",
       x = "Parental Education Level",
       y = "Exam Score") +
  theme_minimal()

# Wynik egzaminu w podziale na rodzaj szkoły (publiczna vs prywatna)

ggplot(czyste_dane, aes(x = School_Type, y = Exam_Score, fill = School_Type)) +
  geom_boxplot() +
  labs(title = "Wynik egzaminu w podziale na rodzaj szkoły",
       x = "School Type",
       y = "Exam Score") +
  theme_minimal()

# Średnia wyników z egzaminu w podzialne na jakość nauczyciela

library(dplyr)
library(ggplot2)


mean_teacher_quality <- czyste_dane %>%
  group_by(Teacher_Quality) %>%
  summarise(mean_exam_score = mean(Exam_Score, na.rm = TRUE))


ggplot(mean_teacher_quality, aes(x = Teacher_Quality, y = mean_exam_score)) +
  geom_bar(stat = "identity", fill = "gray") +
  labs(title = "Średnia wyników z egzaminu w podzialne na jakość nauczyciela",
       x = "Teacher Quality", y = "Średni Exam_Score") +
  theme_minimal()

# Jakość nauczania a obecność na zajęciach w odróznieniu o rodzaj szkoły (prywatna na publiczna)

ggplot(czyste_dane, aes(x = Teacher_Quality, y = Attendance, color = School_Type)) +
  geom_point(alpha = 0.7) +
  labs(title = "Jakość nauczania a obecność na zajęciach w odróznieniu o rodzaj szkoły",
       x = "Teacher Quality",
       y = "Attendance",
       color = "School Type") +
  theme_minimal()

# Obecność a wynik egzaminu 

ggplot(czyste_dane, aes(x = Attendance, y = Exam_Score)) +
  geom_line(color = "gray", size = 1) +
  geom_point(color = "red", size = 2) +
  labs(title = "Obecność a wynik egzaminu",
       x = "Attendance",
       y = "Exam Score") +
  theme_minimal()

# Aktywość fizyczna a uczestnictwo w zajęciach w odrózneniu o wpływ rówieśników

ggplot(czyste_dane, aes(x=Physical_Activity, y=Attendance, colour = Peer_Influence)) +
  geom_point(alpha=0.7) +
  labs(title = "Aktywość fizyczna a uczestnictwo w zajęciach w odrózneniu o wpływ rówieśników",
       x = "Physical Activity (Hours)",
       y = "Attendance (%)",
       colour = "Peer Influence") +
  theme_minimal()

# Wynik z egzaminu w podziale na płeć

ggplot(czyste_dane, aes(x = Gender, y = Exam_Score, fill = Gender)) +
  geom_boxplot() +
  labs(title = "Exam Score by Gender",
       x = "Gender",
       y = "Exam Score") +
  theme_minimal()

# Płeć vs Aktywność fizyczna z kolorami oznaczającymi motywacje

library(dplyr)

ggplot(czyste_dane, aes(x = Gender, y = Physical_Activity, color = Motivation_Level)) +
  geom_jitter(size = 3, alpha = 0.7) +
  labs(title = "GPłeć vs Aktywność fizyczna z kolorami oznaczającymi motywacje",
       x = "Gender",
       y = "Physical Activity",
       color = "Motivation Level") +
  theme_minimal()

# Dostęp do zasobów edukacyjnych vs Wynik egzaminu z kolorami oznaczającymi dostęp do internetu

ggplot(czyste_dane, aes(x = Access_to_Resources, y = Exam_Score, color = Internet_Access)) +
  geom_point(size = 3, alpha = 0.7) +
  labs(title = "Dostęp do zasobów edukacyjnych vs Wynik egzaminu z kolorami oznaczającymi dostęp do internetu",
       x = "Access to Resources",
       y = "Exam Score",
       color = "Internet Access") +
  theme_minimal()

# Średni wynik egzaminu w podziale na zajęcia pozalekcyjne

library(dplyr)

mean_exam_score <- czyste_dane %>%
  group_by(Extracurricular_Activities) %>%
  summarise(mean_score = mean(Exam_Score, na.rm = TRUE))

barplot(mean_exam_score$mean_score,
        names.arg = mean_exam_score$Extracurricular_Activities,
        col = "lightblue",
        main = "Średni wynik egzaminu w podziale na zajęcia pozalekcyjne",
        xlab = "Extracurricular Activities",
        ylab = "Średni Exam_Score")

# Wynik egzaminu vs godziny nauki, podzielone według płci

ggplot(czyste_dane, aes(x = Hours_Studied, y = Exam_Score)) +
  geom_point(color = "blue", size = 3, alpha = 0.7) +
  facet_wrap(~ Gender) +
  labs(title = "Wynik egzaminu vs godziny nauki, podzielone według płci",
       x = "Hours Studied",
       y = "Exam Score") +
  theme_minimal()

# Obecność na zajęciach vs poziom motywacji, podzielone według rodzaju szkoły

ggplot(czyste_dane, aes(x = Motivation_Level, y = Attendance)) +
  geom_boxplot(fill = "lightblue") +
  facet_wrap(~ School_Type) +
  labs(title = "Obecność na zajęciach vs poziom motywacji, podzielone według rodzaju szkoły",
       x = "Motivation Level",
       y = "Attendance") +
  theme_minimal()

# Rozkład wyników egzaminów

ggplot(czyste_dane, aes(x = Exam_Score)) +
  geom_histogram(binwidth = 7, fill = "blue", color = "black", alpha = 0.7) +
  labs(title = "Rozkład wyników egzaminów",
       x = "Exam Score",
       y = "Frequency") +
  theme_minimal()





