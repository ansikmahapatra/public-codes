
#Extract SSM Banks list from the PDF
#install.packages("tm")
#library(tm)

#Extracting table from a downloaded pdf file
#install.packages("pdftools")
#install.packages("pdftables")

#library(pdftools)
#library(pdftables)
#filename<-"/Users/ansikmahapatra/Desktop/list_of_supervised_entities_201701.en.pdf"
#write.csv(head(iris,20),file = "table.csv",row.names = FALSE)  
#convert_pdf(filename,"table.csv")

#pdf_info(filename)
#corpus<-pdf_text(filename)
#corpus<-corpus[1:16]

#ssm_banks<-read.csv("ssm_banks_1.csv",header = TRUE)
country<-c(1:125)
bank<-c(1:125)
ticker<-c(1:125)
ssmBanks<-data.frame(country,bank,ticker)
for(i in 1:7){
  ssmBanks$country[i]="Belgium"
}
for(i in 8:28){
  ssmBanks$country[i]="Germany"
}
for(i in 29:30){
  ssmBanks$country[i]="Estonia"
}
for(i in 31:35){
  ssmBanks$country[i]="Ireland"
}
for(i in 36:39){
  ssmBanks$country[i]="Greece"
}
for(i in 40:53){
  ssmBanks$country[i]="Spain"
}
for(i in 54:66){
  ssmBanks$country[i]="France"
}
for(i in 67:80){
  ssmBanks$country[i]="Italy"
}
for(i in 81:84){
  ssmBanks$country[i]="Cyprus"
}
for(i in 85:87){
  ssmBanks$country[i]="Latvia"
}
for(i in 88:90){
  ssmBanks$country[i]="Lithuania"
}
for(i in 91:94){
  ssmBanks$country[i]="Luxembourg"
}
for(i in 95:97){
  ssmBanks$country[i]="Malta"
}
for(i in 98:103){
  ssmBanks$country[i]="The Netherlands"
}
for(i in 104:111){
  ssmBanks$country[i]="Austria"
}
for(i in 112:115){
  ssmBanks$country[i]="Portugal"
}
for(i in 116:118){
  ssmBanks$country[i]="Slovenia"
}
for(i in 119:121){
  ssmBanks$country[i]="Slovakia"
}
for(i in 122:125){
  ssmBanks$country[i]="Finland"
}

bank_name<-read.csv("/Users/ansikmahapatra/Google Drive/thesis/9CSV/ssm_banks.csv", header = FALSE)

for(i in 1:125){
  ssmBanks$bank[i]=as.character(bank_name[1]$V1[i])
}

