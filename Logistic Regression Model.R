

## **********  LOGISTIC REGRESSION ********** ##


## Library

library(SDMTools)
library(pROC)
library(Hmisc)

library(caret)

## Load Traning DataSet 

train = read.csv('TitanicCleanData.csv')

str(train)
attach(train)

## Remove : PassengerId, Name, TicketNumber, Cabin, Destination, Dest Country,  Lifeboat 

train = train[, -c(1,4,9,10,12,14,16,15)]


## Development (Study) dataSet and Validation (Test) dataset

Prediction = subset(train, is.na(train$Survived))

train = na.omit(train)
attach(train)

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Make Ratio of 30% and 70% for test1 and train dataset 

ind = sample(2, nrow(train), replace = TRUE, prob = c(0.7,0.3))

train1 = train[ind == 1,]
test1 = train[ind == 2,]

## %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


## Build Logit Model

train.logit = glm(Survived ~ . , data = train1, family = binomial())

summary(train.logit)



test1$test.predict = predict.glm(train.logit, test1, type = 'response')

## Performance Measurement

# confusionmatrix = confusion.matrix(test1$Survived, test1$test.predict, threshold = 0.5)

# confusionmatrix

test1$predict.logit = round(test1$test.predict)

confusionMatrix(as.factor(test1$Survived), as.factor(test1$predict.logit))


