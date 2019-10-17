
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

train = subset(train, select = -c(random))


#Feature Selection Techniques - 

set.seed(123)

boruta.train <- Boruta(Survived ~ . ,data=train, doTrace = 2)

  