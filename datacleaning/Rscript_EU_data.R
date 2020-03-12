setwd ("C:\\Github\\igm_survey_gender")
library("tidyverse")
library("readxl")
library("readstata13")
library(stringr)
rm(list=ls())
# load data
df<-read_delim("scraping//data_output_eu.csv",delim="|")
# Confidence
df1<-df%>%select(Confidence,Name)%>%
  separate(Confidence,into = paste("CONF", 1:1000, sep = "_"),sep="¦")%>%
  pivot_longer(1:1000, names_to="Question",values_to = "Confidence")%>%
  mutate(Confidence=as.numeric(Confidence))
# Medianconf
df2<-df%>%select(Medianconf,Name)%>%
  separate(Medianconf,into = paste("CONF", 1:1000, sep = "_"),sep="¦")%>%
  pivot_longer(1:1000, names_to="Question",values_to = "Medianconf")%>%
  mutate(Medianconf=as.numeric(Medianconf))
# Vote
df3<-df%>%select(Votes,Name)%>%
  separate(Votes,into = paste("CONF", 1:1000, sep = "_"),sep="¦")%>%
  pivot_longer(1:1000, names_to="Question",values_to = "Vote")
# Median Vote
df4<-df%>%select(Median,Name)%>%
  separate(Median,into = paste("CONF", 1:1000, sep = "_"),sep="¦")%>%
  pivot_longer(1:1000, names_to="Question",values_to = "Median")
# Comment 
df5<-df%>%select(Comment,Name)%>%
  separate(Comment,into = paste("CONF", 1:1000, sep = "_"),sep="¦")%>%
  pivot_longer(1:1000, names_to="Question",values_to = "Comment")
# Question 
df6<-df%>%select(Questions,Name)%>%
  separate(Questions,into = paste("CONF", 1:1000, sep = "_"),sep="¦")%>%
  pivot_longer(1:1000, names_to="Question",values_to = "Qtext")
# Institution 
df7<-df%>%select(Profile,Name)%>%
  mutate(Profile=str_remove(Profile, Name),
         Profile=str_remove(Profile, "Personal Homepage"),
        Profile=str_trim(Profile))%>%
  rename(Institution=Profile)
# gender
gender<-read_csv("manualdata//eugender.csv")
# topic
topic<-read_excel("manualdata//qtext_eu.xlsx")
# merge
df_m<-merge(gender,df1,by=c("Name"))
df_m<-merge(df_m,df2,by=c("Name","Question"))
df_m<-merge(df_m,df3,by=c("Name","Question"))
df_m<-merge(df_m,df4,by=c("Name","Question"))
df_m<-merge(df_m,df6,by=c("Name","Question"))
df_m<-merge(df_m,df5,by=c("Name","Question"))%>%
      mutate(Question=as.numeric(str_remove(Question, "CONF_")))%>%
      arrange(Name,Question)%>%
      filter(!is.na(Medianconf))
# qtext
df_m<-merge(df_m,topic,by="Qtext")
# write to Stata
write_excel_csv(df_m,"datacleaning/cleaned_data_EU.csv")
save.dta13(df_m,"datacleaning/cleaned_data_EU.dta")
# Plot
#ggplot(df4,aes(x=Deviation_from_median_confidence))+geom_bar()