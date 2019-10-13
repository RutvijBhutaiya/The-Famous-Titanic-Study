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



<br>

### Objective

Objective of the study is to predict the survival of passenger from the Titanic ship, with the use of Machine Learning algorithms. For accuracy, use ensemble techniques for prediction. For an extention of the project, one can insert the personal demographic data and check whether they would had survied the Titanic accident or not. 

### Approach

- Collect the data from kaggle - [Link](https://www.kaggle.com/pavlofesenko/titanic-extended)
- Edit the Original Dataset and Create the dataset for the study - [TitanicNew.csv](https://github.com/RutvijBhutaiya/The-Famous-Titanic-Study/blob/master/TitanicNew.csv) 
- Exploratery Data Analysis
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


2.     Missing value Age: We checkedpassenger Demographics (SibSpouce & ParentChild) based on which we tried toaverage down the missing vale in Age, However, we found it’s similar toActual Mean of Age_wiki. Hence we took that means only.

```
##* See the MissingFare Analysis on Tabelue and Selected Avg. = 13.4
##* See the MissinfAge Analysis on Tabelue and Select Avg. 
##* Age_wiki Avg.: 29.42 and Age_Months: 351


tt$Fare[is.na(tt$Fare)] = '13.4'

tt$Age_wiki[is.na(tt$Age_wiki)] = '29.42'

tt$Age_Months[is.na(tt$Age_Months)] = '351'

##* Fare, Age_wiki & Age_Months converted to Character
##* Convert back to Integer & Numeric

tt$Fare = as.integer(tt$Fare)
tt$Age_wiki = as.numeric(tt$Age_wiki)
tt$Age_Months = as.numeric(tt$Age_Months)
```

For the Titanic passenger Survival study we created Dev (Study) and Val (test) dataset. Here, we decided to create a testing / Val dataset for missing values for the dependent variable 'Survived'. 

And the Ratio from the Dev(Study) dataset for Survived and Not Survived passenger is 0: 61.6 and 1: 38.3

```
## Development (Study) dataSet and Validation (Test) dataset

val = subset(tt, is.na(tt$Survived))

dev = na.omit(tt)
attach(dev)


## Ratio : Survived 1 and 0

as.matrix((prop.table(table(Survived)))*100)

# [,1]
# 0 61.61616
# 1 38.38384

```

#### Data Analysis on Tableau 

Before we jump on our machine learning modeling we studied variables and data analysis on the titanic dataset with the help of Tableau.  



<br>




