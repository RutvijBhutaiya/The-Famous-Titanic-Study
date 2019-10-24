
## ********** Ensemble MOdeling ********** ##

## Random Forest / Logistic Regression / K Nearest Neighbour



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


## ENsemble Modeling

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



