# Code developed by Yifan Wang

# Exam 2

library(ggplot2)
library(plotly)
library(vcd)

# Load dataset
doctor=read.csv("DoctorAUS.csv")

doctor$X = NULL
doctor$sex = as.character(doctor$sex)
doctor[doctor$sex==1,"sex"] = "female"
doctor[doctor$sex==0,"sex"] = "male"
doctor$age = as.integer(100*doctor$age)
doctor$income = as.integer(10000*doctor$income)
str(doctor)

anyNA(doctor)
summary(doctor)


# selection of insurance based on age and income
quantile(doctor$income)
doctor$incomelevel = cut(doctor$income,c(-Inf,2500,9000,Inf))
levels(doctor$incomelevel) = c("Low Income","Middle Income","High Income")

ggplotly(ggplot(doctor,aes(age, label=incomelevel, label1=insurance)) +
           geom_bar() + 
           facet_grid(insurance~incomelevel) +
           theme_bw() +
           labs(x="Age",y="Count",title="Selection of Insurance based on Age and Income") +
           theme(plot.title = element_text(hjust=0.5)))



# hscore and illness by insurance
subplot(
  plot_ly(doctor, x = ~hscore, type="box", color = ~insurance)%>%
    layout(title = "Health Score and Number of Illness in past 2 weeks by Insurance",
           xaxis = list(title = "health score"),
           showlegend=FALSE)
  ,
  plot_ly(doctor, x = ~illness, type="box", color = ~insurance)%>%
    layout(xaxis = list(title = "number of illness in past 2 weeks"),
           showlegend=FALSE),
  nrows=2,margin=0.08,titleX=TRUE
)



# health score and medications by age
healthmed = ggplotly(ggplot(data = doctor, aes(x=age)) +
               stat_summary(aes(y = hscore, fill="Health Score"), fun = "mean", geom = "bar") +
               stat_summary(aes(y = medecine, colour="Total medications"), fun="mean", geom="line") +
               stat_summary(aes(y = medecine), color="red", fun="mean", geom="point") +
               stat_summary(aes(y = prescrib, colour="Prescribed medications"), fun="mean", geom="line") +
               stat_summary(aes(y = prescrib), color="#56B4E9", fun="mean", geom="point") +
               stat_summary(aes(y = nonpresc, colour="Nonprescribed medications"), fun="mean", geom="line") +
               stat_summary(aes(y = nonpresc), color="#E69F00", fun="mean", geom="point") +
               scale_color_manual(values=c("#E69F00", "#56B4E9","red")) +
               scale_fill_manual(values="grey") +
               theme_light() + 
               labs(x="Age", y="Medications / Health Score",
                    title="Health score and Number of medications used by Age") +
               theme(plot.title = element_text(hjust = 0.5), legend.title = element_blank()),
               tooltip = c("x","y"))
 
for (i in 1:length(healthmed$x$data)){
  if (!is.null(healthmed$x$data[[i]]$name)){
    healthmed$x$data[[i]]$name =  gsub("\\(","",gsub("\\,.*","",healthmed$x$data[[i]]$name))
  }
}

healthmed


# prescribed and nonprescribed medication by insurance
medins=subplot(
  ggplotly(ggplot(doctor,aes(x=insurance,y=prescrib,fill=sex)) +
             stat_summary(fun="mean",geom="bar",color="black",size=0.3, alpha=0.5) +
             stat_summary(aes(group=1),fun="mean",geom="line") +
             scale_fill_manual(values=c("#FFDB6D","#56B4E9")) +
             theme_bw() +
             theme(legend.title = element_blank(), plot.title = element_text(hjust = 0.5)) +
             labs(y="prescribed",
                  title = "Prscribed Medications and Nonprescribed Medications used based on insurance")),
  ggplotly(ggplot(doctor,aes(x=insurance,y=nonpresc,fill=sex)) +
             stat_summary(fun="mean",geom="bar",color="black",size=0.3,alpha=0.5) +
             stat_summary(aes(group=1),fun="mean",geom="line") +
             scale_fill_manual(values=c("#FFDB6D","#56B4E9")) +
             coord_cartesian(ylim=c(0,1.9)) +
             theme_bw() +
             theme(legend.title = element_blank())), margin =0.04, shareX=TRUE, titleY = TRUE)

for (i in 1:2){
  medins$x$data[[i]]$showlegend=FALSE
}
medins


# chronic condition by gender
mosaic( ~ insurance + sex + chcond, data = doctor, 
        highlighting = "chcond", highlighting_fill = c("lightblue", "pink","white"),
        direction = c("v", "v", "h"), main = "Chronic Condition based on Gender and Insurance Contract",
        labeling_args = list(set_varnames = 
                               c(insurance="Insurance Contract",chcond="Chronic Condition",sex="Gender")),
        set_labels=list(sex = c("f", "m")))




