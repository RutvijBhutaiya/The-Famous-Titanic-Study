
# @@@@@@@@@@@@@ RANDOM FOREST MODEL @@@@@@@@@@@@@ #

## Library

library(Boruta)
library(randomForest)


## Load Traning DataSet 

TitanicCleanData = read.csv('TitanicCleanData.csv')


## Development (Study) dataSet and Validation (Test) dataset

Prediction = subset(TitanicCleanData, is.na(TitanicCleanData$Survived))

train = na.omit(TitanicCleanData)
attach(train)

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Make Ratio of 30% and 70% for test1 and train1 dataset 

ind = sample(2, nrow(train), replace = TRUE, prob = c(0.7,0.3))

train1 = train[ind == 1,]
test1 = train[ind == 2,]
  
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

#Feature Selection Techniques - 

attach(train1)

set.seed(123)

boruta.train <- Boruta(Survived ~ . , data=train1, doTrace = 2)

## UnImportant attruibutes - Destination, DestinationCountry, Name, PassengerId

train1 = train1[, -c(1,4, 15, 14)]

str(train1)

## Due to Limitation and Error in Categorical variable we can not take cat class more than 53.

train1 = train1[, -c(7,8)] # Remove TicketNumber & Cabin attributes

## Build Random Forest Model 

set.seed(123)

train.rf = randomForest(as.factor(Survived) ~ ., data = train1, 
                        ntree = 201, mtry = 6, nodesize = 20, importance  = TRUE)

print(train.rf)

plot(train.rf, main="Error Rate")

legend("topright", c("OOB", "0", "1"), text.col=1:6, lty=1:3, col=1:3)

train.rf$err.rate

train.tune = tuneRF(x = train1[, -c(1)], y = as.factor(train1$Survived),
                    mtryStart = 6,
                    ntreeTry = 41,
                    stepFactor = 1.2,
                    improve = 0.0001,
                    trace = TRUE,
                    plot = TRUE,
                    nodesize = 20,
                    doBest = TRUE,
                    importance = TRUE
                    ) 

train.rf = randomForest(as.factor(train1$Survived) ~ ., data = train1, 
                        ntree =31, mtry = 5, nodesize = 20, importance  = TRUE)

print(train.rf)

## For Prediction class do Scoring 


View(train1)


## Train Random Forest MOdel Performance 

## Confusion Matrix 

library(caret)
library(e1071)

confusionMatrix(as.factor(train1$Survived), train1$predict.class)

## F1 Score

precision.train1 = precision(as.factor(train1$Survived), train1$predict.class)
# [1] 0.9915966

recall.train1 = recall(as.factor(train1$Survived), train1$predict.class)
# [1] 0.9806094

train1.F1 = (2*precision.train1*recall.train1) / sum(precision.train1, recall.train1)
# [1] 0.9860724

## ROC Curve

library(pROC)

roc(train1$Survived, as.numeric(train1$predict.class), plot = TRUE, main = 'ROC Curve', col = 'Blue')




# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% #

# Apply RF Model on test1 datasets


test1$predict.class <- predict(train.rf, test1, type = "class")

View(test)

## testing Random Forest MOdel Performance on test1 dataset

## Confusion Matrix 

library(caret)
library(e1071)

confusionMatrix(as.factor(test1$Survived), test1$predict.class)

## F1 Score

precision.test1 = precision(as.factor(test1$Survived), test1$predict.class)
# [1] 0.9940828

recall.test1 = recall(as.factor(test1$Survived), test1$predict.class)
# [1] 0.9767442

test1.F1 = (2*precision.test1*recall.test1) / sum(precision.test1, recall.test1)
# [1] 0.9853372


## ROC Curve

roc(train1$Survived, as.numeric(train1$predict.class), plot = TRUE, main = 'ROC Curve for test1', col = 'darkseagreen')

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


## Random Forest Model applied on Unseen (Missing values) dataset - Prediction

Prediction$Survived <- predict(train.rf, Prediction, type = "class")

View(Prediction)

write.csv(Prediction, 'Prediction Random Forest.csv')


