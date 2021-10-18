**Mid-Term Exam 2**

Case: Doctor&#39;s Visits

Yifan Wang

QTM 2623

Professor Mathaisel

I pledge my honor that I have neither received nor provided unauthorized assistance during the completion of this work.

Initials: YW

## 1. Introduction

This report analyzes the dataset, DoctorAUS.csv, which refers to the demographical and health related information of individuals in Australia. The dataset is originally sourced from Cameron, A.C. and P.K. Trivedi (1986) &quot;Econometric Models Based on Count Data: Comparisons and Applications of Some Estimators and Tests&quot;, _Journal of Applied Econometrics_, 1, 29-54. The goal of this analysis is to describe the characteristics of people with different insurance and the relationship between health data and demographic data, including the relationship between age and health score, age and number of illness, gender and medications, gender and chronic conditions, etc.

The objective of the analysis is to understand the data structure, including modifying the data types and handling missing values, and create visualizations to tell the story in this dataset. I believe that the results of this study will enhance my understanding of the health condition of different age group and different gender and could be used as a starting point for further modeling to estimate the health condition of current society.

## 2. Analysis

### 2.1 Preliminary Data Processing

#### 2.1.1 Loading Data Set into R

The first step is to load data into R studio using the function read.csv as shown in Exhibit 1. The data was then loaded to the global environment as shown in Exhibit 2, indicating there are 5190 observations and 16 variables. The first 5 rows are shown in Exhibit 3.

Exhibit 1

![](https://github.com/ywang7-vivian/Doctor-Visits/images/exhibit1.png)

Exhibit 2

![](https://github.com/ywang7-vivian/Doctor-Visits/images/exhibit2.png)

Exhibit 3

![](https://github.com/ywang7-vivian/Doctor-Visits/images/exhibit3.png)

#### 2.1.2 Modifying Data Types

Observing the data, I noticed that &quot;X&quot; column is only an index column and is not an attribute of the dataset, and thus I removed the column. Besides, the &quot;sex&quot; column show gender in 0 and 1, which is not intuitive. By comparing the number of observations in dataset &quot;DoctorVisits&quot;, I confirmed that 1s stand for females and 0s stand for males, and modified the column accordingly. In addition, the &quot;age&quot; column is shown as age divided by 100 and the &quot;income&quot; column is exhibited in tens of thousands of dollars. To make it more easily understandable, I recalculated the two columns to display them in single unit. The corresponding codes are in Exhibit 4. After modifications, the data type of each attribute is shown in Table 1.

Exhibit 4

![](https://github.com/ywang7-vivian/Doctor-Visits/images/exhibit4.png)

Table 1

| **Variable Name** | **Units** | **Data Type** | **Definition** |
| --- | --- | --- | --- |
| sex | N/A | Character | Gender (male and female) |
| age | Years | Integer | Age |
| income | $ | Integer | Annual income |
| insurance | N/A | Character | Insurance contract (medlevy: medibank levy, levyplus: private health insurance, freepoor: government insurance due to low income, freerepa: government insurance due to old age disability or veteran status |
| illness | Number of illness | Integer | Number of illness in past 2 weeks |
| actdays | Days | Integer | Number of days of reduced activity in past 2 weeks due to illness or injury |
| hscore | Score | Integer | General health score using Goldberg&#39;s method (from 0 to 12).High scores indicate worse health. |
| chcond | N/A | Character | Chronic condition (np : no problem, la : limiting activity, nla : not limiting activity) |
| doctorco | Number of consultations | Integer | Number of consultations with a doctor or specialist in the past 2 weeks |
| nondocco | Number of consultations | Integer | Number of consultations with non-doctor health professionals (chemist, optician, physiotherapist, social worker, district community nurse, chiropodist or chiropractor) in the past 2 weeks |
| hospadmi | Number of admissions | Integer | Number of admissions to a hospital, psychiatric hospital, nursing or convalescent home in the past 12 months (up to 5 or more admissions which is coded as 5) |
| hospdays | Number of nights | Integer | Number of nights in a hospital, etc. during most recent admission: taken, where appropriate, as the mid-point of the intervals 1, 2, 3, 4, 5, 6, 7, 8-14, 15-30, 31-60, 61-79 with 80 or more admissions coded as 80. If no admission in past 12 months then equals zero. |
| medicine | Number of medications | Integer | Total number of prescribed and nonprescribed medications used in past 2 days |
| prescrib | Number of medications | Integer | Total number of prescribed medications used in past 2 days |
| nonpresc | Number of medications | Integer | Total number of nonprescribed medications used in past 2 days |

#### 2.1.3 Dataset overview

The function anyNA() and summary() are used to get an overview of the dataset, as shown in Exhibit 5. The output of anyNA() is FALSE, which means there is no missing value in the dataset. The summary() function shows the basic statistical information of the dataset. At first glance, most of the data related to illness, hospital visits and medications used are concentrated near 0, which indicates an overall healthy population in the dataset.

Exhibit 5

![](https://github.com/ywang7-vivian/Doctor-Visits/images/exhibit5.png)

### 2.2 Selection of Insurance Based on Age and Income

Before digging into the dataset, I first wanted to see the number of observations in each type of insurance and to figure out if there is any common characteristics among the people with the same insurance contract on the aspects age and income. I divided the &quot;income&quot; column by 25% and 75% quantile into three intervals, which stand for low, middle and high income, and stored the information into a new factor column named &quot;income level&quot;. Then I used geom\_bar() from ggplot2 package to build the bar plots and facet\_grid() to show the bar plots by four insurance types and three income levels. Finally, the function ggplotly() from plotly package is used to make the graph interactive. Users can hover on each bar to see the number of observations, age, income level, and type of insurance. The corresponding code is shown in Exhibit 6.

Exhibit 6

![](https://github.com/ywang7-vivian/Doctor-Visits/images/exhibit6.png)

As shown in Exhibit 7, there are 12 bar plots in total, three income levels by four insurance types. We can see that government insurance are mostly owned by low to middle income people, with freepor owned more by young people and freerepa owned more by elder people. This makes sense because freerepa is the government insurance due to old age disability or veteran status, while freepor is the government insurance due to low income. The other two paid insurances are owned more by middle to high income people, and a lot of them are below the age of 40.

We can also have a sense that there are relatively smaller amounts of observations that are in their mid-age. After doing some research, I found out that this is because only single people are included in the dataset. Comparing to young people who are yet to married and elder people who might be either divorced or widowed, middle-aged people can potentially have a lower chance to be single, and thus they are included less in the dataset.

Exhibit 7

![](https://github.com/ywang7-vivian/Doctor-Visits/images/exhibit7.png)

### 2.3 Health Score and Number of Illness in past 2 weeks by Insurance

In order to explore the health situation of people in each insurance, I plotted two sets of boxplots using health score and number of illness in past 2 weeks, colored by insurance. The plot\_ly() function and type = &quot;box&quot; is used to build the interactive boxplots. The subplot() function is used to exhibit two sets of boxplots at the same time. The two boxplots share the main title and have their own x axis titles. The corresponding code is in Exhibit 8.

Exhibit 8

![](https://github.com/ywang7-vivian/Doctor-Visits/images/exhibit8.png)

As shown in Exhibit 9, there are 2 sets of boxplots presented. The first set of boxplots is based on general health score. We can see that people with the two private health insurances generally have better health scores than people with government health insurance, and people with freepor insurance have the worst median health score. Besides, the general health score is strongly right skewed and has many outliers of high (bad) health score.

The second set of boxplots is based on the number of illness in past two weeks. We can see that generally people have a median of 1 illness in the past 2 weeks, except for people with freerepa insurance, who have a median of 2 illnesses in the past 2 weeks. As I mentioned in Exhibit 7, people with freerepa insurance are generally elder, which can be a potential reason for the higher rate of illness.

The main reason that people with freerepa insurance have a higher median illness but better median health score than people with freepor insurance is that general health score (GCQ-12) include not only physical health, but also mental health, especially stressfulness. It is possible that the low income young people have better physical health than elder people, but they are more stressful at their work and feel depressed, which brings down their general health score.

Exhibit 9

![](https://github.com/ywang7-vivian/Doctor-Visits/images/exhibit9.png)

### 2.4 Health score and Number of medications used by Age

Wondering if there is a relationship between age and health score, and age and the number of medications taken, I used stat\_summary() to build bar chart based on health score and line chart based on medications taken, including both prescribed medications and nonprescribed medications. The function ggplotly() is then used to make the plot interactive. Because of some formatting issue with the plotly package, the legend was originally shown in bracket, for example, (Health Score, 1). Thus, the for loop is used to edit each variable name in the plotly object and gsub() is used to remove the bracket and everything after comma. Finally, ggplotly() is used to turn the plot into an interactive plot. The corresponding code is in Exhibit 10.

Exhibit 10

![](https://github.com/ywang7-vivian/Doctor-Visits/images/exhibit10.png)

As shown in Exhibit 11, the grey bar plot shows that general health score is relatively stable as age growths with slightly higher score in people&#39;s 30s and 50s.

However, there is a positive trend in total medications taken (red line), which is caused by the more prescribed medications taken as age increases (blue line). Nonprescribed medications maintains a relative stable, or slightly decreasing, amount among different age groups (yellow line).

It is interesting that as age grows, the average health score does not increase a lot, but the number of medications taken does. My understanding is that firstly, elder people have to take more medications to maintain a certain health level. In addition, as mentioned in Exhibit 9, the improve in people&#39;s mental health, or decrease in stress level, after retirement can potentially offset the decrease in their physical health, and thus keep the overall health score stable.

Exhibit 11

![](https://github.com/ywang7-vivian/Doctor-Visits/images/exhibit11.png)

### 2.5 Prescribed Medications and Nonprescribed Medications used based on Insurance

In order to find out if there is a difference in medications taken between different genders, stat\_summary() is further used to build two sets of bar graphs to show the different average amount of prescribed and nonprescribed medications taken by people of different insurance, and the bar graph is colored by gender. In addition, line chart is added to show the average medication for both male and female. Finally, ggplotly() is used to make the graphs interactive, and subplot() is used to display two plots at the same time.

Exhibit 12

![](https://github.com/ywang7-vivian/Doctor-Visits/images/exhibit12.png)

As shown in Exhibit 13, the line chart shows that people with freerepa insurance have the highest consumption in prescribed medications and lowest consumption in nonprescribed medications. Since freerepa represents elder people with government insurance, the graph confirms my finding in Exhibit 11 that as age increases, people take more prescribed medications and slightly less nonprescribed medications.

We can also see that yellow bars are always higher than green bars, which shows that on average, female takes more medications than male. Especially with prescribed medications, female might take more than double the medications that males take.

Exhibit 13

![](https://github.com/ywang7-vivian/Doctor-Visits/images/exhibit13.png)

### 2.6 Chronic Condition based on Gender and Insurance Contract

In order to see if more medications is taken because chronic condition, I used the mosaic() function to build a mosaic plot with three variables, insurance type, gender, and chronic condition, and the graph is colored by chronic condition.

Exhibit 14

![](https://github.com/ywang7-vivian/Doctor-Visits/images/exhibit14.png)

As shown in Exhibit 15, the plot is divided into multiple rectangles with area of each rectangle representing the frequency. Blue means that the person has chronic condition and is limiting his or her activity. Pink means that the person has chronic condition, but the condition is so serious to influence activity. White means that the person has no chronic condition. From the chart, we can see that within the same insurance type, female always have more chronic condition than male, and more chronic condition is limiting their activities. In addition, people with freerepa condition have the most chronic condition, and people with freepor condition have the least chronic condition. This aligns with the fact that freerepa insurance is issued to old age disability and freepor insurance is owned most by young people.

Exhibit 15

![](https://github.com/ywang7-vivian/Doctor-Visits/images/exhibit15.png)

## 3. Conclusion

In this exercise, I leveraged multiple techniques to conduct graphical analysis of the demographical and health related data of doctor visits in Australia. I manipulated the data, modified the data structures, checked for missing values, and generated various visualizations to tell the stories about different people&#39;s health condition and selection of health insurance.

Firstly, government insurance due to low income are owned mostly by low to middle income young people, government insurance due to old age disability or veteran status are owned mostly by low to middle income elder people and private insurance are owned more by people with middle to high income. Besides, the low income young people tend to have a less number of illness but also less satisfying general health score than elder people, which might be caused by stress. In addition, there is a positive relationship between prescribed medications taken and age, but the amount of nonprescribed medications remains stable as age increases. When it comes to gender, females generally take much more prescribed medications and have more chronic condition limiting their activities than male.

One drawback I have is that this data set does not have a lot of observations about people in their middle age, and this data set includes only single people. If marriage status has any influence a person&#39;s health status, such as a happy marriage&#39;s positive influence on people&#39;s mental health, the visualization I created will fail to capture the relationship. If I can have more observations about middle-aged people, I might be able to find other relationships, such as the influence of work pressure on health.

Overall, analyzing the datasets provide me a general idea of people&#39;s health condition based on gender and age, and the target market for different kinds of health insurance. The visualizations can serve as a starting point for further regression analysis.