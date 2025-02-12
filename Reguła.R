#wywołanie danych z csv
data <- read.csv(file = "czynniki.csv")

#stworzenie ramki danych którymi się zajmujemy
data <- data.frame(data)

#biblioteki potzrebne do imputacji danych
install.packages("dlookr")
install.packages("editrules") #reguły
install.packages("VIM")
install.packages("validate")

library(dlookr)
library(editrules)
library(VIM)
library(validate)


summary(data)
# ustalenie zasad według których dane mają być imputowane oraz jeżeli dane wyrastają poza skalę oznaczane będą jako błedy
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

#sprawdzenie ilości danych które nie odpowidaja powyższym regułom ustalonym mna podstawie eksperckiej analizy
out   <- confront(data, RULE)
plot(out)
summary(out)

#zamiana danych typu character na factor
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

