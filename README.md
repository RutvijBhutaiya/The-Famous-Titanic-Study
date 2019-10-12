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
- [Data Cleaning & Edit](#data-cleaning-&-edit)
- [Exploratery Data Analysis](#exploratery-data-analysis)



<br>

### Objective

Objective of the study is to predict the survival of passenger from the Titanic ship, with the use of Machine Learning algorithms. For accuracy, use ensemble techniques for prediction. For an extention of the project, one can insert the personal demographic data and check whether they would had survied the Titanic accident or not. 

### Approach

- Collect the data from kaggle - [Link](https://www.kaggle.com/pavlofesenko/titanic-extended)
- Edit the Original Dataset and Create the dataset for the study - [TitanicNew.csv](https://github.com/RutvijBhutaiya/The-Famous-Titanic-Study/blob/master/TitanicNew.csv) 
- Exploratery Data Analysis
-

<br>

### Data Cleaning & Edit

1.	We downloaded dataset from [Kaggle](https://www.kaggle.com/pavlofesenko/titanic-extended). The dataset is already extended – Kaggle + Wikipedia.

2.	In dataset we decided to consider Wiki_Age  and not Age – because of missing values in Age variable. 

3.	Even in duplicated variables like Boarded and Embarked, we choose Boarded due to the places full form names. 

4.	For simplicity - we made changes in Destination, and added new variable called DestinationCountry. DestinationCountry indicates only the country name unlike Destination with more details lie State and City. 

5.	From the original dataset we have also added one more variable called NameLength. This variable indicates length characters of the name. Before applying the logic we had also removed the double name checks in the variables like e.g. Nasser, Mrs. Nicholas (Adele Achem) become Nasser, Mrs. Nicholas. 

And at last after doing all these changes in the original dataset we created TitanicNew dataset for the prediction of the passenger survival study. 



<br>





