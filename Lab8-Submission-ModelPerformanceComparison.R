

if (require("languageserver")) {
  require("languageserver")
} else {
  install.packages("languageserver", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

# Introduction ----
#the lab aims at coparing the models using visual aid. This is done to pick out the best performing model 


#  Installing  and Loading the Required Packages ----
## mlbench ----
if (require("mlbench")) {
  require("mlbench")
} else {
  install.packages("mlbench", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## caret ----
if (require("caret")) {
  require("caret")
} else {
  install.packages("caret", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## kernlab ----
if (require("kernlab")) {
  require("kernlab")
} else {
  install.packages("kernlab", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## randomForest ----
if (require("randomForest")) {
  require("randomForest")
} else {
  install.packages("randomForest", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

# Loading the Dataset ----iris

data("iris")

#Data preprocessing 0 looking for missing values 
any_na(iris)

#  Resampling Function ----
## Training the Models ----
#the models are trianed with 10 fold repeated cross validation which has 3 repeats

#   LDA
#   CART
#   KNN
#   SVM
#   Random Forest

train_control <- trainControl(method = "repeatedcv", number = 10, repeats = 3)

### LDA ----
set.seed(7)
iris_model_lda <- train(Species ~ ., data = iris,
                        method = "lda", trControl = train_control)

### CART ----
set.seed(7)
iris_model_cart <- train(Species ~ ., data = iris,
                         method = "rpart", trControl = train_control)

### KNN ----
set.seed(7)
iris_model_knn <- train(Species ~ ., data = iris,
                        method = "knn", trControl = train_control)

### SVM ----
set.seed(7)
iris_model_svm <- train(Species ~ ., data = iris,
                        method = "svmRadial", trControl = train_control)

### Random Forest ----
set.seed(7)
iris_model_rf <- train(Species ~ ., data = iris,
                       method = "rf", trControl = train_control)

##Calling the `resamples` Function ----


results <- resamples(list(LDA = iris_model_lda, CART = iris_model_cart,
                          KNN = iris_model_knn, SVM = iris_model_svm,
                          RF = iris_model_rf))

#  Showing the Results ----
summary(results)

## 2. Box and Whisker Plot ----
# This is useful for visually observing the spread of the estimated accuracies
# for different algorithms and how they relate.
scales <- list(x = list(relation = "free"), y = list(relation = "free"))
bwplot(results, scales = scales)

## 3. Dot Plots ----
# They show both the mean estimated accuracy as well as the 95% confidence
# interval (e.g. the range in which 95% of observed scores fell).
scales <- list(x = list(relation = "free"), y = list(relation = "free"))
dotplot(results, scales = scales)

## 4. Scatter Plot Matrix ----
# This is useful when considering whether the predictions from two
# different algorithms are correlated. If weakly correlated, then they are good
# candidates for being combined in an ensemble prediction.
splom(results)

## 5. Pairwise xyPlots ----
# You can zoom in on one pairwise comparison of the accuracy of trial-folds for
# two models using an xyplot.
xyplot(results, models = c("LDA", "SVM"))

# or
xyplot(results, models = c("SVM", "CART"))

## 6. Statistical Significance Tests ----
# This is used to calculate the significance of the differences between the
# metric distributions of the various models.

### Upper Diagonal ----
# The upper diagonal of the table shows the estimated difference between the
# distributions. If we think that LDA is the most accurate model from looking
# at the previous graphs, we can get an estimate of how much better it is than
# specific other models in terms of absolute accuracy.

### Lower Diagonal ----
# The lower diagonal contains p-values of the null hypothesis.
# The null hypothesis is a claim that "the models are the same".
# A lower p-value is better (more significant).

diffs <- diff(results)

summary(diffs)