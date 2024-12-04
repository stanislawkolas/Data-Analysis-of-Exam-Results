options(repos = c(CRAN = "https://cloud.r-project.org"))
install.packages("car")
install.packages("palmerpenguins", repos = "https://cloud.r-project.org")
library(car)
library(palmerpenguins)


data <- read.csv(file = "czynniki.csv")

View(data)

sum(complete.cases(data))

nrow(data[complete.cases(data), ])/nrow(data)*100

is.special <- function(x){
  if (is.numeric(x)) !is.finite(x) else is.na(x)
}

sapply(data, is.special)

for (n in colnames(data)){
  is.na(data[[n]]) <- is.special(data[[n]])
}
summary(data)

model_full <- lm(Exam_Score ~ ., data = data)
summary(model_full)
model_mutiple <- step(model_full, direction = "backward")
summary (model_mutiple)

vif(model_full)