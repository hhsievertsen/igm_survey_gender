clear 
cd "C:\github\igm_survey_gender\scraping"
/* extract questions from us survey */
use "cleaned_data_US.dta",clear
keep Qtext
duplicates drop 
export excel using "qtext_us.xlsx", firstrow(variables)

/* extract questions from eu survey */
clear 
use "cleaned_data_EU.dta",clear
keep Qtext
duplicates drop 
export excel using "qtext_eu.xlsx", firstrow(variables)
