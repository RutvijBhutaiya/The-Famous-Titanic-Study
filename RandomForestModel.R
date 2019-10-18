
# @@@@@@@@@@@@@ RANDOM FOREST MODEL @@@@@@@@@@@@@ #

## Library

library(Boruta)
library(randomForest)


## Load Traning DataSet 

TitanicCleanData = read.csv('TitanicCleanData.csv')


## Development (Study) dataSet and Validation (Test) dataset

test = subset(TitanicCleanData, is.na(TitanicCleanData$Survived))

train = na.omit(TitanicCleanData)
attach(train)


#Feature Selection Techniques - 

set.seed(123)

boruta.train <- Boruta(Survived ~ . , data=train, doTrace = 2)

## UnImportant attruibutes - Destination, DestinationCountry, Name, PassengerId

train = train[, -c(1,4, 15, 14)]

str(train)

## Due to Limitation and Error in Categorical variable we can not take cat class more than 53.

train = train[, -c(7,8)] # Remove TicketNumber & Cabin attributes

## Build Random Forest Model 

set.seed(123)

train.rf = randomForest(as.factor(Survived) ~ ., data = train, 
                        ntree = 501, mtry = 5, nodesize = 100, importance  = TRUE)

print(train.rf)
plot(train.rf)

  