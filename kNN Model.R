

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

## Create Dummy Variables

sex.matrix = model.matrix( ~ Sex - 1, data = train)
train = data.frame(train, sex.matrix)

boarded.matrix = model.matrix( ~ Boarded - 1, data = train)
train = data.frame(train, boarded.matrix)

Lifeboatsupport.matrix = model.matrix( ~ LifeboatSupport - 1, data = train)
train = data.frame(train, Lifeboatsupport.matrix)

train = train[, -c(4,8,9)]


## FORM KNN USE SCALING OR NORMALIZATION ## EITHER of ONE 

### SCALING

train2 = scale(train[, -1])
train = data.frame(Survived, train2)


###

## Normalizarion

normalize<-function(x){
  +return((x-min(x))/(max(x)-min(x)))}

train$Pclass = normalize(train$Pclass)
train$NameLength = normalize(train$NameLength)

train$SibSpouse = normalize(train$SibSpouse)
train$ParentsChild = normalize(train$ParentsChild)

train$Age_Months = normalize(train$Age_Months)
train$Fare_new = normalize(train$Fare_new)

train$Sexfemale = normalize(train$Sexfemale)
train$Sexmale = normalize(train$Sexmale)

train$Boarded.1 = normalize(train$Boarded.1)
train$BoardedBelfast = normalize(train$BoardedBelfast)

train$BoardedQueenstown = normalize(train$BoardedQueenstown)
train$BoardedSouthampton = normalize(train$BoardedSouthampton)
train$BoardedCherbourg = normalize(train$BoardedCherbourg)

train$LifeboatSupportNo = normalize(train$LifeboatSupportNo)
train$LifeboatSupportYes = normalize(train$LifeboatSupportYes)


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

attach(train)

### ## Development (Study) dataSet and Validation (Test) dataset

Prediction = subset(train, is.na(train$Survived))

train = na.omit(train)
attach(train)

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Make Ratio of 30% and 70% for test1 and train dataset 


ind = sample(2, nrow(train), replace = TRUE, prob = c(0.7,0.3))

train1 = train[ind == 1,]
test1 = train[ind == 2,]


## Build KNN Model

train.knn = knn(train = train1[, -c(1)], test = test1[, -c(1)], 
                cl = train1[, 1], k = 5)

test1$knn.Survived = train.knn

confusionMatrix(as.factor(test1$Survived), as.factor(test1$knn.Survived))



### ## ENsemble Modeling

## For Random Forest

test1$RF.Survived = predict(train.rf, test1, type = 'class')

## For Logistic Regression

test1$Logit.Survived = predict.glm(train.logit, test1, type = 'response')
test1$Logit.Survived = round(test1$Logit.Survived)

## For KNN

test1$knn.Survived = train.knn

##

test1$RF.Survuved = as.factor(test1$RF.Survuved)
test1$Logit.Survived = as.factor(test1$Logit.Survived)
test1$knn.Survived = as.factor(test1$knn.Survived)

test1$Survived.Majority = as.factor(ifelse(test1$RF.Survuved == '1' & test1$test1$Logit.Survived == '1', '1', 
                                           ifelse(test1$Logit.Survived == '1' & test1$knn.Survived == '1', '1',
                                                  ifelse(test1$knn.Survived == '1' &test1$RF.Survuved == '1', '1', '0'))))







