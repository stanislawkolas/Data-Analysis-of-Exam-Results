data <- read.csv(file = "czynniki.csv")

summary(data)

RULE <- validator(Hours_Studied >= 0, 
                  Hours_Studied <= 24,
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
                  
