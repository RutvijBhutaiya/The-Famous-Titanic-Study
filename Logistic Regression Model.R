

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

## Create Random variable with random numberw between 0 and 1

train$random = runif(nrow(train),0,1)

## Add new coloum for these new randam data

train = train[order(train$random),]

#Splitting the data into Development (70%) and Testing (30%) sample

train1 = train[which(train$random <= 0.7),]
test1 = train[which(train$random > 0.7),]

# Remove Random dummy variable 

train1 = train1[, -c(11)]
test1 = test1[, -c(11)]

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


