
data <- read.csv(file = "czynniki.csv")

View(data)
getwd()
install.packages("tidyverse")
library(tidyverse)
install.packages("finalfit")
library(finalfit)
dim(data)

names(data)
#  Plot Missing-ness
data %>%
  dplyr::select(Hours_Studied,Attendance, Parental_Involvement,Access_to_Resources, Extracurricular_Activities, Sleep_Hours, 
                Previous_Scores, Motivation_Level, Internet_Access, Tutoring_Sessions, Family_Income, Teacher_Quality, School_Type,
                Peer_Influence, Physical_Activity, Learning_Disabilities, Parental_Education_Level, Distance_from_Home, Gender) %>%
  finalfit::missing_plot()
# Report on a Subset of variables
data %>%
  dplyr::select(Hours_Studied,Attendance, Parental_Involvement,Access_to_Resources, Extracurricular_Activities, Sleep_Hours, 
                Previous_Scores, Motivation_Level, Internet_Access, Tutoring_Sessions, Family_Income, Teacher_Quality, School_Type,
                Peer_Influence, Physical_Activity, Learning_Disabilities, Parental_Education_Level, Distance_from_Home, Gender) %>%
  finalfit::missing_pattern()
  # VIM method
data %>%
  dplyr::select(Hours_Studied,Attendance, Parental_Involvement,Access_to_Resources, Extracurricular_Activities, Sleep_Hours, 
                Previous_Scores, Motivation_Level, Internet_Access, Tutoring_Sessions, Family_Income, Teacher_Quality, School_Type,
                Peer_Influence, Physical_Activity, Learning_Disabilities, Parental_Education_Level, Distance_from_Home, Gender) %>%
  VIM::aggr(numbers = TRUE,   # shows the number to the far right
             prop    = FALSE)  # shows counts instead of proportions

##
explanatory = c("Hours_Studied","Attendance", "Parental_Involvement","Access_to_Resources", "Extracurricular_Activities", "Sleep_Hours", 
                "Previous_Scores", "Motivation_Level", "Internet_Access", "Tutoring_Sessions", "Family_Income", "Teacher_Quality", "School_Type",
                "Peer_Influence", "Physical_Activity", "Learning_Disabilities", "Parental_Education_Level", "Distance_from_Home", "Gender")
dependent = "Exam_Score"
data %>% 
  missing_pairs(dependent, explanatory)
###
data %>% 
  missing_pairs(dependent, explanatory, position= "fill",)

explanatory = c("Hours_Studied", "Attendance", "Sleep_Hours", "Previous_Scores", "Tutoring_Sessions", "Physical_Activity")
dependent = "Exam_Score"
data %>% 
  missing_pairs(dependent, explanatory)

boxplot( data$Sleep_Hours, data$Tutoring_Sessions, data$Physical_Activity, col ="green", xlab = "various data", ylab = "Scale")
boxplot (data$Attendance, data$Previous_Scores, data$Exam_Score, col ="red")

#instalujemy pakiety
install.packages("dlookr")
install.packages("editrules") #reguły
install.packages("VIM")
install.packages("validata")

library(dlookr)
library(editrules)
library(VIM)
library(validata)


