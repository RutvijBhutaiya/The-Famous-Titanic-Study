

######### TITANIC STUDY ###########


## Set Working Directory & Load DataSet

tt = read.csv('TitanicNew.csv')

attach(tt)

## Libraries

library(ggplot2)
library(rpivotTable)
library(ggcorrplot)
library(corrplot)
library(RColorBrewer)


## Data Summary & Structure

summary(tt)

dim(tt)

str(tt)



### ********  Exploratery Data Analysis  ******** ###

## Convert Passenger Class into Factor()

# tt$Pclass = as.factor(Pclass)

# tt$TicketNumber = as.factor(TicketNumber)


## Treating Missing Values

colSums(is.na(tt))

missingfare = subset(tt, is.na(Fare))

missingage = subset(tt, is.na(Age_wiki))

##* See the MissingFare Analysis on Tabelue and Selected Avg. = 13.4
##* See the MissinfAge Analysis on Tabelue and Select Avg. 
##* Age_wiki Avg.: 29.42 and Age_Months: 351


tt$Fare[is.na(tt$Fare)] = '13.4'

tt$Age_wiki[is.na(tt$Age_wiki)] = '29.42'

tt$Age_Months[tt$Age_Months == 0] = '351'

##* Fare, Age_wiki & Age_Months converted to Character
##* Convert back to Integer & Numeric

tt$Fare = as.integer(tt$Fare)
tt$Age_wiki = as.numeric(tt$Age_wiki)
tt$Age_Months = as.numeric(tt$Age_Months)


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

## Pivot Table Analysis

rpivotTable(tt)

## NOTE: Out of 1309 observations 
### 418 observations taken as Testing dataset (NULL)


## Ratio : Survived 1 and 0

as.matrix((prop.table(table(Survived)))*100)

# [,1]
# 0 61.61616
# 1 38.38384


## Fare Variable Analysis for Outliers


boxplot(Fare ~ Pclass, data = tt, 
        main = 'Fare with respect to Passenger Class', ylab = 'Price', col = 'darksalmon')

## Remove Less Logical Fare observation ??
## 1. 0 Fare : Remove 
## 2. $5 : 1Class passenger : Remove [Erroe : $5 passenger travelling in 1st class!]
## 3. $69.55 : 3Class passenger : 11 passengers :Remove. [Person pay high tkt and travel in 3 class!]
## 4. $56.49 : 3Class passenger : 8 passengers :Remove. [Person pay high tkt and travel in 3 class!] 

## However, we decided not to remove above observations, as val dataset analysis has similar patterns!


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

## Boxplot Analysis for Outliers!

par(mfrow = c(1,3))

boxplot(SibSpouse ~ Survived, data = tt, 
        main = 'Sibbling / Spouce with respect to Survived', ylab = 'Count', col = 'darksalmon')

boxplot(ParentsChild ~ Survived, data = tt, 
        main = 'Parents / Children with respect to Survived', ylab = 'Count', col = 'darksalmon')

# NOTE: 1. Remove Outliers from SibSpouse & ParentChild
# NOTE: 2. Chk the Correlation on dependent variable 
# NOTE: 3. Hypothesis Test

# NULL : No Significant Diff.
# Alt: Significant Diff.

# SibSpouse

SibSpouse1 = subset(tt, SibSpouse <= 4)

cor(SibSpouse1$SibSpouse, SibSpouse1$Survived)

t.test(tt$SibSpouse, SibSpouse1$SibSpouse)

# p-value = 0.04271 # Hence, Reject Null Hypo (95% Confidence)- Significant Diff. # Remove Outliers

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# ParentsChild

ParentsChild1 = subset(tt, ParentsChild <= 2)

cor(ParentsChild1$ParentsChild, ParentsChild1$Survived)

t.test(tt$ParentsChild, ParentsChild1$ParentsChild)

# p-value = 0.009444 # Hence, Reject Null Hypo (95% Confidence)- Significant Diff. # Remove Outliers

# Hence, removed the Outliers from SibSpouse and ParentsChild variables

tt = tt[which(tt$SibSpouse <= 4 & tt$ParentsChild <=2),]


## Other VAriables Outliers Study

boxplot(Age_Months ~ Survived, data = tt, 
        main = 'Age in Months with respect to Survived', ylab = 'Age Months', col = 'darksalmon')

boxplot(NameLength ~ Survived, data = tt, 
        main = 'Name Length of Male/Female Passengers', ylab = 'Name Length', col = 'darksalmon')


## NOTE: There are few Outliers in the Dev dataset, But for significant purpose we decided to consider it in the study.


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

attach(tt)

## Coorelation 

ggcorrplot(cor(tt[, c(2,3,5,7,8,10,13)]), method = 'circle',  type = 'lower', lab = TRUE)

## Correlation

corrplot(cor(dev[, c(2,3,5,7,8,10,13)]), type = 'upper', order = 'hclust', 
         col = brewer.pal(n = 7, name = 'YlGnBu'))


## Data Normalization 

library(forecast)

hist(Age_Months, col = 'salmon')
BoxCox.lambda(Age_Months)

# [1] 0.6221575


hist(NameLength, col = 'Salmon')


hist(Fare, col = 'Salmon')
BoxCox.lambda(Fare)

tt$Fare_new = log(tt$Fare)
# [1] 4.102259e-05 BoxCox Test

# Remove Fare and Keep Fare_new
tt = tt[, -c(10)]

# Also Remove Age_Wiki, IN study forward we'll consider Age_Months
tt = tt[, -c(11)]

write.csv(tt, 'TitanicCleanData.csv')

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%