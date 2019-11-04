In progress..

## The Famous Titanic Study

<br>

<p align="center"><img width=100% src=https://user-images.githubusercontent.com/44467789/66575859-4e214080-eb94-11e9-903b-891e94663b25.gif>
                                              Source: National Geographic Channel


<br>

## How To Use The Project 

<details>

<summary><b>Expand For Steps</b></summary>

<br>

__Step 1:__ [Install R Studio](https://www.rstudio.com/products/rstudio/download/#download)

__Step 2:__ Download the Titanic [Dataset](https://www.kaggle.com/pavlofesenko/titanic-extended)

</details>

<br>

## Table of Content 

- [Objective](#objective)
- [Approach](#approach)
- [Data Cleaning and Edit](#data-cleaning-and-edit)
- [Exploratery Data Analysis](#exploratery-data-analysis)
- [Data Analysis on Tableau](#data-analysis-on-tableau)
- [Random Forest Model](#random-forest-model)
- [Logistic Regression Model](#logistic-regression-model)
- [K Nearest Neighbors](#k-nearest-neighbors)
- [Conclusion](#conclusion)


<br>

### Objective

Objective of the study is to predict the survival of passenger from the Titanic ship, with the use of Machine Learning algorithms. For accuracy, use ensemble techniques for prediction. For an extention of the project, one can insert the personal demographic data and check whether they would had survied the Titanic accident or not. 

### Approach

- Collect the data from kaggle - [Link](https://www.kaggle.com/pavlofesenko/titanic-extended)
- Edit the Original Dataset and Create the dataset for the study - [TitanicNew.csv](https://github.com/RutvijBhutaiya/The-Famous-Titanic-Study/blob/master/TitanicNew.csv) 
- Exploratery Data Analysis
- Clean the original dataset and get data ready for buiding models - [TitanicCleanData.csv](https://github.com/RutvijBhutaiya/The-Famous-Titanic-Study/blob/master/TitanicCleanData.csv)
- Use [cleandata](https://github.com/RutvijBhutaiya/The-Famous-Titanic-Study/blob/master/TitanicCleanData.csv) for Random Forst model.
- Use Boruta for feature selection.
- Built the Random Forest Model - [R code](https://github.com/RutvijBhutaiya/The-Famous-Titanic-Study/blob/master/RandomForestModel.R)
- Check the performance of model and present Area Under Curve(AUC).
-

<br>

### Data Cleaning and Edit

1.	We downloaded dataset from [Kaggle](https://www.kaggle.com/pavlofesenko/titanic-extended). The dataset is already extended – Kaggle + Wikipedia.

2.	In dataset we decided to consider Wiki_Age  and not Age – because of missing values in Age variable. 

3.	Even in duplicated variables like Boarded and Embarked, we choose Boarded due to the places full form names. 

4.	For simplicity - we made changes in Destination, and added new variable called DestinationCountry. DestinationCountry indicates only the country name unlike Destination with more details lie State and City. 

5.	From the original dataset we have also added one more variable called NameLength. This variable indicates length characters of the name. Before applying the logic we had also removed the double name checks in the variables like e.g. Nasser, Mrs. Nicholas (Adele Achem) become Nasser, Mrs. Nicholas. 

6. Lifeboat Support - we assume that the box with missing value under variable Lifeboat means particular passenger didn't received the support from the Lifeboat. And hence, we created new variable LifeboatSuppot - Yes / No. 

And at last after doing all these changes in the original dataset we created TitanicNew dataset for the prediction of the passenger survival study. 

<br>

### Exploratery Data Analysis

After setting up the working directory we in Exploratory Data Analysis we begun with treating missing value in the date.

```
## Treating Missing Values

colSums(is.na(tt))

missingfare = subset(tt, is.na(Fare))

missingage = subset(tt, is.na(Age_wiki))
```

1.     Missing Fare value treatment: Wechecked – Passengers Demographics (Boarded, PClass, Sex, Destination Country)and then done analysis in Tabelue with respect to demographics and set theAverage missing passenger Fare. [Checked Tabelus Pic missingfare]

<p align="center"><img width=78% src=https://user-images.githubusercontent.com/44467789/66712011-e8130400-edb3-11e9-85fd-8298c91e45d8.png>
 
 <br>


2.     Missing value Age: We checkedpassenger Demographics (SibSpouse & ParentChild) based on which we tried toaverage down the missing vale in Age, However, we found it’s similar toActual Mean of Age_wiki. Hence we took that means only.

```
##* See the MissingFare Analysis on Tabelue and Selected Avg. = 13.4

#* Also Few observations are '0' as Fare - We changes acccording to PClass Average.
##* 1st Class = 82.1 [Removed Outliers of 4 tickets with 512.3]
##* 2nd CLass = 21.1
##* 3rd Class = 13.4

##* See the MissinfAge Analysis on Tabelue and Select Avg. 
##* Age_wiki Avg.: 29.42 and Age_Months: 351


tt$Fare[is.na(tt$Fare)] = '13.4'

tt$Fare[tt$Fare == 0 & tt$Pclass == 1] = '82.1'
tt$Fare[tt$Fare == 0 & tt$Pclass == 2] = '21.1'
tt$Fare[tt$Fare == 0 & tt$Pclass == 3] = '13.4'

tt$Age_wiki[is.na(tt$Age_wiki)] = '29.42'

tt$Age_Months[is.na(tt$Age_Months)] = '351'

##* Fare, Age_wiki & Age_Months converted to Character
##* Convert back to Integer & Numeric

tt$Fare = as.integer(tt$Fare)
tt$Age_wiki = as.numeric(tt$Age_wiki)
tt$Age_Months = as.numeric(tt$Age_Months)
```

And the Ratio from the  dataset for Survived and Not Survived passenger is 0: 61.6 and 1: 38.3

```

## Ratio : Survived 1 and 0

as.matrix((prop.table(table(Survived)))*100)

# [,1]
# 0 61.61616
# 1 38.38384

```

<br>

#### Data Analysis on Tableau 

Before we jump on our machine learning modeling we studied variables and data analysis on the titanic dataset with the help of Tableau.  

##### 1. Passenger Class Survived Ratio

<p align="center"><img width=78% src=https://user-images.githubusercontent.com/44467789/66712145-024de180-edb6-11e9-8b56-37ab867d036e.png>
<br>
  
Pie chartshows, Passenger Class wise survived passenger ratio. This clearly indicatedmore than half of the passengers survived the Titanic accident was fromPassenger Class 1, and lease passenger were survived were from Class 3. Thisclearly indicated that even though the Class 1 passenger was less on countthey got the higher priority and hence their survival ratio is 63%.

<br>

##### 2. Passenger Hometown

<p align="center"><img width=88% src=https://user-images.githubusercontent.com/44467789/66712169-49d46d80-edb6-11e9-9925-2a35ed564dd1.png>

<br>

PassengerHometown geography map indicated that % ratio of total passengers from different- different country locations. Majority of the passengers were from the UnitedKingdom and The United States with 23.6% and 21.77% respectively. 

<br>

##### 3. Passenger Boarded and Survived –Gender wise

<p align="center"><img width=88% src=https://user-images.githubusercontent.com/44467789/66712190-899b5500-edb6-11e9-9cfa-e19df0085fda.png>
  
<br>

Passenger Boarded and Survived – Gender wise barchart indicate the ratio of Male and Female passenger class with respect tothe port they boarded. This bar chart indicate that the majority of thepassengers boarded the Titanic ship from the port of Southampton. However, thepassenger who didn’t survive the crash was also from the same group of the cluster – 40.04%. This is mainly due to Pclass – passenger class. Class 3passenger count is substation high compare to Class 1 passenger and Class 3passenger was boarded from the port of Southampton. But, unfortunately only24% of passengers from Class 3 passengers cluster were survived and the rest 76% werenot lucky. From the chart, we can also observe that all the male passengers boardedfrom Belfast were not lucky to survive the crash. 

<br>

##### 4. Passenger Survived – Age wise

<p align="center"><img width=58% src=https://user-images.githubusercontent.com/44467789/66712211-d8e18580-edb6-11e9-87aa-1978b520a966.png>

<br>

Passengersurvived – Age-wise classification is shown in the Box Plot.  This box plot indicates that the average ageof female passenger, survived the Titanic accident was 29 Years. And theaverage age of a female passenger did not survive was 24.2 Years.  In male passenger case the situation reverses,the average age of male passengers, did not survive was 30.8 Years. And theaverage age of male passengers, survived was 27.2 Years. This indicates the elderfemale class and young male class had high survival ratio than the younger femaleclass and elder male class.

<br>

##### 5. Passenger Class wise Fare / LifeboatSupport

 <p align="center"><img width=74% src=https://user-images.githubusercontent.com/44467789/66712260-8a80b680-edb7-11e9-9968-ceadb077eb16.png>
  
<br>
In this bar the chart we can see that the % Ratio of Fare is obviously higher for Class 1passengers. But, when we analyze - was their discrimination for lower classpassengers! This chart clearly indicated that 1st Class passengersgot priority in Lifeboat due to their high paid tickets. When we compare theLifeboatSupport with % of Fare Average – we observed that ticket Fare price averageis not very high for passengers who received the Lifeboat support. This ismainly due to the Class 1 passengers. However, due respect to the count of Class 3passengers and their low ticket value they did not luck to access Lifeboat onpriority.

<br>

##### 6. Parents Children – Spouse Siblings

<p align="center"><img width=62% src=https://user-images.githubusercontent.com/44467789/66712272-ce73bb80-edb7-11e9-87b2-7ce314c391b8.png>

<br>

ParentsChildren and Spouse Siblings bar chart indicated that solo passenger withoutParents or Children’s family members’ survival is high. Similarly, a passenger who has not traveled with Spouse or Siblings also had a high survival ratio.

<br>
                       
#### Outlier Study

We began the Outliers study with the Fare variable. In the Outliersidentification  we did the study on Fare,SibSpouse , ParentsChild, Age_Month, NameLength variables. 

- Remove Less Logical Fare observation ??
- 1. 0 Fare : Remove 
- 2. $5 : 1Class passenger : Remove [Erroe : $5 passengertraveling in 1st class!]
- 3. $69.55 : 3Class passenger : 11 passengers :Remove.[Person pay high tkt and travel in 3 class!]
- 4. $56.49 : 3Class passenger : 8 passengers :Remove.[Person pay high tkt and travel in 3 class!] 

```
boxplot(Fare ~ Pclass, data = tt, 
        main = 'Fare with respect to Passenger Class', ylab = 'Price', col = 'darksalmon')
```

<p align="center"><img width=80% src=https://user-images.githubusercontent.com/44467789/66922134-16a70e00-f044-11e9-8baf-0fcc1be5f6f5.png>
  
However, we decided not to remove the Outliers from the Fare feature, because it's logical, that 1st class passenger paid high Fare. So we decided not to remove the outliers from the Fare feature. 

For SibSpouse and ParentsChild feature, we found close outliers. Hence, we decided to do the Hypotheses testing to know the significant impact on the Target variable. 

For the following 2 features, we did hypothesis testing after removing the outliers from the features. And checked the p-value. 

```
## Boxplot Analysis for Outliers!

par(mfrow = c(1,2))

boxplot(SibSpouse ~ Survived, data = tt, 
        main = 'Sibbling / Spouce with respect to Survived', ylab = 'Count', col = 'darksalmon')

boxplot(ParentsChild ~ Survived, data = tt, 
        main = 'Parents / Children with respect to Survived', ylab = 'Count', col = 'darksalmon')
```

<p align="center"><img width=80% src=https://user-images.githubusercontent.com/44467789/66922688-2d019980-f045-11e9-95c1-1078b4a54fc2.png>

- NOTE: 1. Remove Outliers from SibSpouse & ParentChild
- NOTE: 2. Chk the Correlation on dependent variable 
- NOTE: 3. Hypothesis Test

```
# SibSpouse Feature

SibSpouse1 = subset(tt, SibSpouse <= 4)

cor(SibSpouse1$SibSpouse, SibSpouse1$Survived)

t.test(tt$SibSpouse, SibSpouse1$SibSpouse)

# p-value = 0.04271 # Hence, Reject Null Hypo (95% Confidence)- Significant Diff. # Remove Outliers

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# ParentsChild Feature

ParentsChild1 = subset(tt, ParentsChild <= 2)

cor(ParentsChild1$ParentsChild, ParentsChild1$Survived)

t.test(tt$ParentsChild, ParentsChild1$ParentsChild)

# p-value = 0.009444 # Hence, Reject Null Hypo (95% Confidence)- Significant Diff. # Remove Outliers

# Hence, removed the Outliers from SibSpouse and ParentsChild variables

tt = tt[which(tt$SibSpouse <= 4 & tt$ParentsChild <=2),]

```

Hence, based on p-value we decided not to remove the outliers. 


Other Features - Age_Months & NameLength Outliers Study

```
boxplot(Age_Months ~ Survived, data = tt, 
        main = 'Age in Months with respect to Survived', ylab = 'Age Months', col = 'darksalmon')

boxplot(NameLength ~ Survived, data = tt, 
        main = 'Name Length of Male/Female Passengers', ylab = 'Name Length', col = 'darksalmon')
```

<p align="center"><img width=80% src=https://user-images.githubusercontent.com/44467789/66923222-0a23b500-f046-11e9-8534-4fcb3f70b54e.png>
  
There are few Outliers (Not very large) in the tt dataset, But for significant purpose we decided to consider it in the stud for Age_Month and NameLength. 

#### Correlation Study between features 

```
## Coorelation 

ggcorrplot(cor(tt[, c(2,3,5,7,8,10,12)]), method = 'circle',  type = 'lower', lab = TRUE)
```
<p align="center"><img width=88% src=https://user-images.githubusercontent.com/44467789/67010275-f3936180-f10a-11e9-9b22-ec11ccec0a0b.png>

As we can see in the correlation chart, PClass and Fare have the highest negative correlation, along with the target variable. Before building the Machine Learning models we will also do the feature selection through the Boruta package in R. 


#### Normalization Feature - Skewness

Based on the Histogram study, we decided to study normalization for continious variables. We used BoxCox.Lambda test to normalize the data. 

Based on the histogram, we found that Age_Months and NameLengths are normally distributed. But, Fare is right skewed. 

```
library(forecast)

hist(Age_Months, col = 'salmon')
BoxCox.lambda(Age_Months)
# [1] 0.5972085

hist(NameLength, col = 'Salmon')

hist(Fare, col = 'Salmon')
BoxCox.lambda(Fare)
```
<p align="center"><img width=80% src=https://user-images.githubusercontent.com/44467789/67006267-559b9900-f102-11e9-9618-5be63d8ea79d.png>
  
As we can see in the histogram Fare is right skewed and hence, we use log() for normalization. 

```
tt$Fare_new = log(tt$Fare)
# [1] 4.102259e-05 BoxCox Test

# Remove Fare and Keep Fare_new
tt = tt[, -c(10)]

# Also Remove Age_Wiki, IN study forward we'll consider Age_Months
tt = tt[, -c(11)]

write.csv(tt, 'TitanicCleanData.csv')
```
Save the clean dataset into new file for the machine learning modeling - [TitanicCleanData.csv](https://github.com/RutvijBhutaiya/The-Famous-Titanic-Study/blob/master/TitanicCleanData.csv)

<br>

### Random Forest Model 

Random Forest technique is based on ‘Ensemble technique’, where you create multiple trees like forest and the prediction is based on Mode of classification tree, and voting principle will select the class based on Mode. 

Random forest model user inbuilt library called randomForest in R studio. 

We loaded the clean dataset fro the Random Forest model building, - [TitanicCleanData.csv](https://github.com/RutvijBhutaiya/The-Famous-Titanic-Study/blob/master/TitanicCleanData.csv)

Based on the data we created 2 subsets. Here, One subset is missing values in attribute of Survived [Actual prediction]. Hence we called this subset as Prediction. 

```
## Development (Study) dataSet and Validation (Test) dataset

Prediction = subset(TitanicCleanData, is.na(TitanicCleanData$Survived))

train = na.omit(TitanicCleanData)
attach(train)
```

Then, In the second subset we created two more subset, 1. For model building - train1 and 2. For model testing test1 dataset. 

Train1 and tst1 dataset are in the artio of 70:30. 

```

# Make Ratio of 30% and 70% for test1 and train1 dataset 

## Create Random variable with random numberw between 0 and 1

train$random = runif(nrow(train),0,1)

## Add new coloum for these new randam data

train = train[order(train$random),]

#Splitting the data into Development (70%) and Testing (30%) sample

train1 = train[which(train$random <= 0.7),]
test1 = train[which(train$random > 0.7),]

# Remove Random dummy variable 

train1 = train1[, -c(19)]
test1 = test1[, -c(19)]
```

For feature selection we used Boruta technique. 

```
boruta.train <- Boruta(Survived ~ . , data=train1, doTrace = 2)

## UnImportant attruibutes - Destination, DestinationCountry, Name, PassengerId

train1 = train1[, -c(1,4, 15, 14)]
```

After that with the use of 201 trees and 20 nodesize we build Randomforest tree and tried to see the Error rate for ideal tree selaction. 

```
train.rf = randomForest(as.factor(Survived) ~ ., data = train1, 
                        ntree = 201, mtry = 5, nodesize = 20, importance  = TRUE)

print(train.rf)

plot(train.rf, main="Error Rate")
```

Based on the following chart OOB (Out Of Bag Erroe rate is 1.9%), with number of variables tries is 5. 

<p align="center"><img width=88% src=https://user-images.githubusercontent.com/44467789/67146408-8584a100-f2a8-11e9-8993-96fd41c43fbb.png>
  
<br>

NOTE: Model Results would vary with every diffrent performance, because, In selection of train1 and test1 we have selected random. Hence, every run would through diffrent results. 

<br>
  
Hence, based on the erroe rate we decided to select ideal nmtree as 61. 
For model trnung, we selected mtryStart as 6 and stepFactor as 1.2.

And we found out that ideal mtry is 7, with minimum OOB. 

After model building , train.rf, we used the model to predict the same dataset for train1. 
```
## For Prediction class do Scoring 

train1$predict.class <- predict(train.rf, train1, type = "class")
```

#### Performance Measurement of the MOdel

FOr Random Forest - Classification model performance we took three performance measurement. 
1. Confusion Matrix
2. F1 Score (Between 0 and 1, higher the score better the results)
3. ROC Curve - AUC (Area Under Curve)

##### Confusion Matrix

Confusion matris is combination of TP (True Positive), TN(True Negative), FP(False Positive) and FN (False Negative). For classification problem, confusion matrix is highly preferable. 

```
## Confusion Matrix 

library(caret)
library(e1071)

confusionMatrix(as.factor(train1$Survived), train1$predict.class)
```

Confusion Matrix and Statistics

          Reference
Prediction   0   1
         0 367   3
         1   8 233
                                        
               Accuracy : 0.982         
                 95% CI : (0.968, 0.991)
    No Information Rate : 0.6137        
    P-Value [Acc > NIR] : <2e-16        
                                        
                  Kappa : 0.9622        
                                        
 Mcnemar's Test P-Value : 0.2278        
                                        
            Sensitivity : 0.9787        
            Specificity : 0.9873        
         Pos Pred Value : 0.9919        
         Neg Pred Value : 0.9668        
             Prevalence : 0.6137        
         Detection Rate : 0.6007        
   Detection Prevalence : 0.6056        
      Balanced Accuracy : 0.9830        
                                        
       'Positive' Class : 0 
       
IN the performance matrix, Accuracy is 98.2%. However, it is important that we get good accuracy on testing dataset.  test1. 
<br>

##### F1 Score

F1 Score is measured based on the values from Precesion and Recall. 
```
precision.train1 = precision(as.factor(train1$Survived), train1$predict.class)
# [1] 0.9915966

recall.train1 = recall(as.factor(train1$Survived), train1$predict.class)
# [1] 0.9806094

train1.F1 = (2*precision.train1*recall.train1) / sum(precision.train1, recall.train1)
# [1] 0.9860724
```

##### ROC Curve and AUC (Area Under Curve)

For ROC curve, we used library(pROC. IN the follwoing ROC Chart the AUC value is 0.9793
```
library(pROC)

roc(train1$Survived, as.numeric(train1$predict.class), plot = TRUE, main = 'ROC Curve', col = 'Blue')
```
<br>

<p align="center"><img width=88% src=https://user-images.githubusercontent.com/44467789/67146594-540cd500-f2aa-11e9-99c7-7b1600eef96c.png>
  


<br>
<br>

#### Random Forest Model on test1 dataset

Similarly, train.rf model we used to prdeict the Survived class on unseen dataset of test1. Hence, we will check the accuracy of the model prediction on the test1 dats and then we will put the RF model train.rf for the actual Prediction data. 

Based on the performance measurement we woud chec the train.rf model realiability. 

```
# Apply RF Model on test1 datasets

test1$predict.class <- predict(train.rf, test1, type = "class")
```

Based on the predict.class, we used same three model performance measurement techniques.

<br>

##### Confusion Matrix for test1

```
## testing Random Forest MOdel Performance on test1 dataset

## Confusion Matrix 

confusionMatrix(as.factor(test1$Survived), test1$predict.class)
```
Confusion Matrix and Statistics

          Reference
Prediction   0   1
         0 155   1
         1   3  94
                                        
               Accuracy : 0.9842        
                 95% CI : (0.96, 0.9957)
    No Information Rate : 0.6245        
    P-Value [Acc > NIR] : <2e-16        
                                        
                  Kappa : 0.9664        
                                        
 Mcnemar's Test P-Value : 0.6171        
                                        
            Sensitivity : 0.9810        
            Specificity : 0.9895        
         Pos Pred Value : 0.9936        
         Neg Pred Value : 0.9691        
             Prevalence : 0.6245        
         Detection Rate : 0.6126        
   Detection Prevalence : 0.6166        
      Balanced Accuracy : 0.9852        
                                        
       'Positive' Class : 0   
  
  <br>
Hence, it's true that model is fit for unseen dataset. And the accuracy for the model is 98.4%. Which is superb!

<br>

##### F1 Score for test1

```
precision.test1 = precision(as.factor(test1$Survived), test1$predict.class)
# [1] 0.9940828

recall.test1 = recall(as.factor(test1$Survived), test1$predict.class)
# [1] 0.9767442

test1.F1 = (2*precision.test1*recall.test1) / sum(precision.test1, recall.test1)
# [1] 0.9853372
```

<br>

##### ROC and AUC for test1

AUC for the test1 data is 0.9793

<p align="center"><img width=88% src=https://user-images.githubusercontent.com/44467789/67146895-62102500-f2ad-11e9-95b9-08cb5775b177.png>
  
<br>

##### Apply RF Model on Actual Prediction dataset

Hence, based on the train1 and test1 performance we decided to apply same train.rf model to the missing dataset set of Survived passenged prediction in the study, for Prediction dataset. 

```
Prediction$Survived <- predict(train.rf, Prediction, type = "class")

write.csv(Prediction, 'Prediction Random Forest.csv')
```

Also save the results in the File - [Prediction Random Forest.csv](https://github.com/RutvijBhutaiya/The-Famous-Titanic-Study/blob/master/Prediction%20Random%20Forest.csv)

<br>

### Logistic Regression Model

In the logistic regression, we have used the TitanicCleanData.csv file. Based on the feature selection study from Random Forest model, we decided to remove less significant features – PassengerID, Name, TicketNumber, Cabin, Destination, DestCountry, and Lifeboat. 

```
## Remove : PassengerId, Name, TicketNumber, Cabin, Destination, Dest Country,  Lifeboat 

train = train[, -c(1,4,9,10,12,14,16,15)]
```
For the training and testing dataset we used random 70% observation ad validation (train) and 30% observations as test dataset. Same proportion of observation as we selected in Random Forest model. 

```
## Development (Study) dataSet and Validation (Test) dataset

Prediction = subset(train, is.na(train$Survived))

train = na.omit(train)
attach(train)

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Make Ratio of 30% and 70% for test1 and train dataset 

ind = sample(2, nrow(train), replace = TRUE, prob = c(0.7,0.3))

train1 = train[ind == 1,]
test1 = train[ind == 2,]
```

Now, to build Logistic Regression we uses Generalised Linear Model, glm() function. 

```
## Build Logit Model

train.logit = glm(Survived ~ . , data = train1, family = binomial())

summary(train.logit)
```

After applying the model on testing dataset with the use of predict.glm() function we completed the performance measurement with to check the model accuracy. 

```
## Apply model on testing dataset

test1$test.predict = predict.glm(train.logit, test1, type = 'response')

## Performance Measurement

# confusionmatrix = confusion.matrix(test1$Survived, test1$test.predict, threshold = 0.5)

# confusionmatrix

test1$predict.logit = round(test1$test.predict)

confusionMatrix(as.factor(test1$Survived), as.factor(test1$predict.logit))
```

<p align="center"><img width=65% src=https://user-images.githubusercontent.com/44467789/68070378-618a8a80-fd93-11e9-949c-82ca60c21b17.png>
  
Accuracy of the model is more than 98% 

Apart from accuracy, Precision for the model came to 0.99 and recall is 0.97. 
Also, as performance measurement we have checked the F1 score, and which is more than 98% 
```
## F1 Score

precision.test1 = precision(as.factor(test1$Survived), as.factor(test1$predict.logit))
# [1] 0.9944444

recall.test1 = recall(as.factor(test1$Survived), as.factor(test1$predict.logit))
# [1] 0.9781421

test1.F1 = (2*precision.test1*recall.test1) / sum(precision.test1, recall.test1)
# [1] 0.9862259
```

Now, before we conclude the Logistic Regression, we also test ROC curve for the model and checked the Area Under Curve (AUC). 
AUC is 0.977

<p align="center"><img width=88% src=https://user-images.githubusercontent.com/44467789/68070317-ec1eba00-fd92-11e9-805b-4471b6b6bb7b.png>
  
<br>

### K Nearest Neighbors

KNN – also known as K-Nearest Neighbour algorithm.  KNN is a non-parametric algorithm, and entertains only factor and numeric as variables, hence we need to create dummy variables for categorical variables. KNN used Ecludian, Manhatten and Chebychev distance measurement techniques, mainly Ecludian technique. 

IN KNN model too, we removed less significant features from the dataset, and created the dummy features in the dataset. 

```
## Create Dummy Variables

sex.matrix = model.matrix( ~ Sex - 1, data = train)
train = data.frame(train, sex.matrix)

boarded.matrix = model.matrix( ~ Boarded - 1, data = train)
train = data.frame(train, boarded.matrix)

Lifeboatsupport.matrix = model.matrix( ~ LifeboatSupport - 1, data = train)
train = data.frame(train, Lifeboatsupport.matrix)

train = train[, -c(4,8,9)]
```

IN the KNN algorithm, it is important either the features should be scaled or normalized! Here we decide to scale the features. 

```
### SCALING

train2 = scale(train[, -1],)
train = data.frame(train$Survived, train2)
```

And after that we created the train and testing datasets with 70:30. And build the model with knn() and Class library. 
Here, in the model, we performed k = 5 [can be changed on case to case bases]

```
## Build KNN Model

train.knn = knn(train = train1[, -c(1)], test = test1[, -c(1)], 
                cl = train1[, 1], k = 5)
```

For performance measurement, first we checked the confusion matrix, and the accuracy stands at 97.1% for testing(unknown) dataset. 

<p align="center"><img width=60% src=https://user-images.githubusercontent.com/44467789/68083530-99570800-fe4f-11e9-9d94-49bc7d1ec537.png>
 
After that we also checked the Precision, Recall and F1 Score on the same model, 
```
## F1 Score

precision.test1 = precision(as.factor(test1$train.Survived), test1$knn.Survived)
# [1] 0.9801325

recall.test1 = recall(as.factor(test1$train.Survived), as.factor(test1$knn.Survived))
# [1] 0.9736842

test1.F1 = (2*precision.test1*recall.test1) / sum(precision.test1, recall.test1)
# [1] 0.9768977

```
As, a final measurement we also studied the AUC and ROC graph, AUC for the modes stands at 0.969

<p align="center"><img width=88% src=https://user-images.githubusercontent.com/44467789/68083549-dd4a0d00-fe4f-11e9-8edf-aee7fb88748e.png>
  
### Conclusion

As we set an objective for the study - to predict the survival of passengers from the Titanic ship, with the use of Machine Learning algorithms. We used Random Forest, Logistic Regression and K-nearest neighbor techniques to achieve the results. 

Based on the Exploratory Data Analysis (EDA) one thing is clear that 1st class passengers had priority for Lifeboats as ratio 62% passengers survived and from 3rd class, only 24% of passengers survived. However, the total count for a passenger from 1st, 2nd and 3rd class were 709, 277 and 323 respectively [based on TitanicNew.csv](https://github.com/RutvijBhutaiya/The-Famous-Titanic-Study/blob/master/TitanicNew.csv) file. 

As we can see in the below-mentioned table, RF works best in accuracy, however, Logistic Regression fits best in the dataset with respect to precision, recall, and F1 score. KNN also achieved an accuracy of more than 97%. 

<p align="center"><img width=60% src=https://user-images.githubusercontent.com/44467789/68084041-564c6300-fe56-11e9-9d7e-d0595f2ffecd.png> 
  

