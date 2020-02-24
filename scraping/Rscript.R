setwd ("C:\\Github\\igm_survey_gender\\scraping")
library("tidyverse")

# load data
df<-read_delim("data_output.csv",delim="|")
# Confidence
df1<-df%>%select(Confidence,Name)%>%
  separate(Confidence,into = paste("CONF", 1:119, sep = "_"),sep=";")%>%
  pivot_longer(1:119, names_to="Question",values_to = "Confidence")%>%
  mutate(Confidence=as.numeric(Confidence))
# Medianconf
df2<-df%>%select(Medianconf,Name)%>%
  separate(Medianconf,into = paste("CONF", 1:119, sep = "_"),sep=";")%>%
  pivot_longer(1:119, names_to="Question",values_to = "Medianconf")%>%
  mutate(Medianconf=as.numeric(Medianconf))
df3<-df%>%select(Questions,Name)%>%
  separate(Questions,into = paste("CONF", 1:119, sep = "_"),sep=";")%>%
  pivot_longer(1:119, names_to="Question",values_to = "Questiontext")
# merge
df4<-merge(df1,df2,by=c("Name","Question"))
df4<-merge(df4,df3,by=c("Name","Question"))%>%
      mutate(Question=as.numeric(substr(Question,6,6)),
             Deviation_from_median_confidence=Confidence-Medianconf)
write_csv(df4,"cleaned_data_not_all_elements.csv")
# Plot
ggplot(df4,aes(x=Deviation_from_median_confidence))+geom_bar()