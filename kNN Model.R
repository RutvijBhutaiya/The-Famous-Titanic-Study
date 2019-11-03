

# @@@@@@@@@@@@  K Nearest Neighbour (KNN) MOdel @@@@@@@@@@@ #


library(class)
library(caret)
library(SDMTools)
library(pROC)

train = read.csv('TitanicCleanData.csv')

str(train)
attach(train)

## Remove : PassengerId, Name, TicketNumber, Cabin, Destination, Dest Country,  Lifeboat 

train = train[, -c(1,4,9,10,12,14,16,15)]


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

attach(train)

### ## Development (Study) dataSet and Validation (Test) dataset

Prediction = subset(train, is.na(train$Survived))

train = na.omit(train)
attach(train)

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


## Create Dummy Variables

sex.matrix = model.matrix( ~ Sex - 1, data = train)
train = data.frame(train, sex.matrix)

boarded.matrix = model.matrix( ~ Boarded - 1, data = train)
train = data.frame(train, boarded.matrix)

Lifeboatsupport.matrix = model.matrix( ~ LifeboatSupport - 1, data = train)
train = data.frame(train, Lifeboatsupport.matrix)

train = train[, -c(4,8,9)]


### SCALING

train2 = scale(train[, -1],)
train = data.frame(train$Survived, train2)

# Make Ratio of 30% and 70% for test1 and train dataset 


ind = sample(2, nrow(train), replace = TRUE, prob = c(0.7,0.3))

train1 = train[ind == 1,]
test1 = train[ind == 2,]


## Build KNN Model

train.knn = knn(train = train1[, -c(1)], test = test1[, -c(1)], 
                cl = train1[, 1], k = 5)


## Performance Measurement of kNN Model

test1$knn.Survived = train.knn

confusionMatrix(as.factor(test1$train.Survived), test1$knn.Survived)


## F1 Score

precision.test1 = precision(as.factor(test1$train.Survived), test1$knn.Survived)
# [1] 0.9801325

recall.test1 = recall(as.factor(test1$train.Survived), as.factor(test1$knn.Survived))
# [1] 0.9736842

test1.F1 = (2*precision.test1*recall.test1) / sum(precision.test1, recall.test1)
# [1] 0.9768977


## ROC Curve

roc(test1$train.Survived, as.numeric(test1$knn.Survived), plot = TRUE, main = 'ROC Curve for test1', col = 'darkseagreen')








