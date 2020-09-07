# Step 1: Press Releases : press_matrix
# Step 2: Speeches : speech_matrix
# Step 3: Interviews : interviews_matrix
# Step 4: Publications: publications_matrix : contains the pdf links to all publications
#If you're using ubuntu then make sure you install the following packages from terminal: libxml2, libxml2-dev, libssl-dev

install.packages('rvest', repos='http://cran.rstudio.com/', lib = "~/Library/R/3.4/library/")
install.packages('httr', repos='http://cran.rstudio.com/', lib = "~/Library/R/3.4/library/")
install.packages('RCurl', repos='http://cran.rstudio.com/', lib = "~/Library/R/3.4/library/")
install.packages('XML', repos='http://cran.rstudio.com/', lib = "~/Library/R/3.4/library/")

library(rvest, lib.loc="~/Library/R/3.4/library/")
library(httr, lib.loc="~/Library/R/3.4/library/")
library(RCurl, lib.loc="~/Library/R/3.4/library/")
library(XML)

base_url<-"https://www.bankingsupervision.europa.eu/home/html/index.en.html"
urls<-xpathSApply(htmlParse(getURL(base_url)),path = "//a",xmlGetAttr,"href")
english<-c()
press<-c()
speech<-c()
interviews<-c()
publications<-c()
j=1
for(i in 1:length(urls)){
  if(grepl(".en.html",urls[i])==TRUE){
    english[j]<-urls[i]
    j=j+1
  }
}
j=1
for(i in 1:length(english)){
  if(grepl("/press/pr/date/",english[i])==TRUE){
    press[j]<-english[i]
    j=j+1
  }
}
j=1
for(i in 1:length(english)){
  if(grepl("/press/speeches/date/",english[i])==TRUE){
    speech[j]<-english[i]
    j=j+1
  }
}
j=1
for(i in 1:length(english)){
  if(grepl("/press/interviews/date/",english[i])==TRUE){
    interviews[j]<-english[i]
    j=j+1
  }
}
j=1
for(i in 1:length(english)){
  if(grepl("/press/publications/",english[i])==TRUE){
    publications[j]<-english[i]
    j=j+1
  }
}
press_matrix<-matrix(list(),nrow = length(press),ncol = 3)
j=1
base<-"https://www.bankingsupervision.europa.eu/"
for(i in 1:length(press)){
  if(grepl("/html/index.en.html",press[i])==FALSE){
    web<-read_html(paste0(base,press[i]))
    press_matrix[[j,2]]<-html_text(html_nodes(web,".ecb-pressContentTitle"))
    press_matrix[[j,1]]<-html_text(html_nodes(web,".ecb-pressContentPubDate"))
    press_matrix[[j,3]]<-html_text(html_nodes(web,"article p"))
    j=j+1
  }
}
press_matrix<-unique(press_matrix)
speech_matrix<-matrix(list(),nrow = length(speech),ncol = 3)
j=1
base<-"https://www.bankingsupervision.europa.eu/"
for(i in 1:length(speech)){
  if(grepl("/html/index.en.html",speech[i])==FALSE){
    web<-read_html(paste0(base,speech[i]))
    speech_matrix[[j,2]]<-html_text(html_nodes(web,".ecb-pressContentTitle"))
    speech_matrix[[j,1]]<-html_text(html_nodes(web,"h2"))
    speech_matrix[[j,3]]<-html_text(html_nodes(web,"#ecb-content-col p"))
    j=j+1
  }
}
speech_matrix<-unique(speech_matrix)
interviews_matrix<-matrix(list(),nrow = length(interviews),ncol = 3)
j=1
base<-"https://www.bankingsupervision.europa.eu/"
for(i in 1:length(interviews)){
  if(grepl("/html/index.en.html",interviews[i])==FALSE){
    web<-read_html(paste0(base,interviews[i]))
    interviews_matrix[[j,2]]<-html_text(html_nodes(web,".ecb-pressContentTitle"))
    interviews_matrix[[j,1]]<-html_text(html_nodes(web,".ecb-pressContentSubtitle"))
    interviews_matrix[[j,3]]<-html_text(html_nodes(web,"#ecb-content-col p"))
    j=j+1
  }
}
interviews_matrix<-unique(interviews_matrix)
publications_matrix<-c()
j=1
n=0
base<-"https://www.bankingsupervision.europa.eu"
for(j in 1:length(publications)){
  pdfs<-xpathSApply(htmlParse(getURL(paste0(base,publications[j]))),path = "//a",xmlGetAttr,"href")
  for(i in 1:length(pdfs)){
    if(grepl("/ecb/pub/pdf/",pdfs[i])==TRUE)
    {
      n=n+1
      publications_matrix[n]=paste0(base,pdfs[i])
    }
  }
}
dimnames(press_matrix)=list(c(),c("date","heading","body"))
for(i in 1:(length(press_matrix)/3)){
  temp<-""
  for(j in 1:length(press_matrix[[i,3]])-1){
    temp<-paste0(temp,press_matrix[[i,3]][j])
  }
  press_matrix[[i,3]]<-temp
}
dimnames(speech_matrix)=list(c(),c("date","heading","body"))
for(i in 1:(length(speech_matrix)/3)){
  temp<-""
  for(j in 1:length(speech_matrix[[i,3]])-1){
    temp<-paste0(temp,speech_matrix[[i,3]][j])
  }
  speech_matrix[[i,3]]<-temp
  r<-speech_matrix[[i,1]][1]
  speech_matrix[[i,1]]<-as.character(r)
}
dimnames(interviews_matrix)=list(c(),c("date","heading","body"))
for(i in 1:(length(interviews_matrix)/3)){
  temp<-""
  for(j in 1:length(interviews_matrix[[i,3]])-1){
    temp<-paste0(temp,interviews_matrix[[i,3]][j])
  }
  interviews_matrix[[i,3]]<-temp
}
for(i in 1:(length(press_matrix)/3)){
  press_matrix[[i,1]]<-gsub("\n","",press_matrix[[i,1]][1])
  press_matrix[[i,1]]<-trimws(press_matrix[[i,1]][1],"both")
}

press_matrix<-data.frame(press_matrix)
speech_matrix<-data.frame(speech_matrix)
interviews_matrix<-data.frame(interviews_matrix)
publications_matrix<-data.frame(publications_matrix)

for(index in 1:length(publications_matrix)){
  download.file(publications_matrix[index],paste0("~/Dropbox/thesis/11PDF/ECBPublications/",as.character(index),".pdf"))  
}

speech_matrix$body<-vapply(speech_matrix$body,paste,collapse=", ",character(1L))
speech_matrix$heading<-vapply(speech_matrix$heading,paste,collapse=", ",character(1L))
speech_matrix$date<-vapply(speech_matrix$date,paste,collapse=", ",character(1L))

press_matrix$date<-vapply(press_matrix$date,paste,collapse=", ",character(1L))
press_matrix$heading<-vapply(press_matrix$heading,paste,collapse=", ",character(1L))
press_matrix$body<-vapply(press_matrix$body,paste,collapse=", ",character(1L))

interviews_matrix$date<-vapply(interviews_matrix$date,paste,collapse=", ",character(1L))
interviews_matrix$heading<-vapply(interviews_matrix$heading,paste,collapse=", ",character(1L))
interviews_matrix$body<-vapply(interviews_matrix$body,paste,collapse=", ",character(1L))

write.csv(press_matrix,"~/Dropbox/thesis/9CSV/press_matrix.csv")
write.csv(speech_matrix,"~/Dropbox/thesis/9CSV/speech_matrix.csv")
write.csv(interviews_matrix,"~/Dropbox/thesis/9CSV/interviews_matrix.csv")
write.csv(publications_matrix,"~/Dropbox/thesis/9CSV/publication_matrix.csv")
