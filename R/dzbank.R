directory<-"~/Desktop/7Text/dzbank/"
setwd(directory)
number_of_news<-0
p<-che<-1
what<-nu<-c()
hh<-c()
o<-length(dir(directory))
f<-list.files(directory)
first<-vector("list",o)
news<-vector("list",o)

for(t in 1:o){
  con=file(f[t],open="r")
  line=readLines(con) 
  long=length(line)
  for(tt in 1:long){what[tt]<-trimws(line[tt])}
  nu[t]<-as.integer(substr(what[5],37,nchar(what[5])-1))
  for(check in 1:nu[t]){
    for(jk in 1:length(what)){
      if(paste0(as.character(check)," of ",nu[t]," DOCUMENTS")%in%what[jk]){
        first[[t]][[check]]<-jk
        number_of_news<-number_of_news+1
      }
    }
    first[[t]][[check+1]]<-length(what)
  }
  close(con)
  for(sm in 2:length(first[[t]])){
    news[[t]][[sm-1]]<-""
    for(u in first[[t]][[sm-1]]:first[[t]][[sm]]-1){
      news[[t]][[sm-1]]<-paste0(news[[t]][[sm-1]]," ",what[u])
    }
  }
}

dzbank<-data.frame(search=1:number_of_news,date=1:number_of_news,load_date=1:number_of_news,news=1:number_of_news,len=1:number_of_news,pubtype=1:number_of_news)

for(i in 1:length(news)){
  for(j in 1:length(news[[i]])){
    dzbank$news[p]<-news[[i]][[j]]
    p<-p+1
  }
}
for(t in 1:o){
  con=file(f[t],open="r")
  line=readLines(con) 
  for(i in 1:length(line)){
    hh[che]<-line[i]
    che<-che+1
  }
  close(con)
}
che<-0
for(i in 1:length(hh)){
  if(grepl(" DOCUMENTS",hh[i])==TRUE){
    che<-che+1
  }
  if(grepl("LOAD-DATE:",hh[i])==TRUE){
    dzbank$load_date[che]<-substr(trimws(hh[i]),12,nchar(trimws(hh[i])))
  }
  if(grepl("LENGTH:",hh[i])==TRUE){
    dzbank$len[che]<-substr(trimws(hh[i]),8,nchar(trimws(hh[i]))-5)
  }
  if(grepl("PUBLICATION-TYPE:",hh[i])==TRUE){
    dzbank$pubtype[che]<-substr(trimws(hh[i]),18,nchar(trimws(hh[i])))
  }
}
month_<-"January|February|March|April|May|June|July|August|September|October|November|December"
year_<-"2005|2006"
day_<-"Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday"
agency<-"Agence France Presse|Agence France Presse -- English|Global Broadcast Database|
The Main Wire|Japan Economic Newswire|National Post's Financial Post & FP Investing (Canada)|
The Evening Standard (London)|FD (Fair Disclosure) Wire|RIA Novosti|Cabinet Maker|
The New York Sun|The Sunday Herald|Midnight Trader Live Briefs|Cabinet Maker|Sunday Mirror|
UPI|FD (Fair Disclosure) Wire|AP Worldstream|AFX - Asia|
Associated Press Financial Wire|Associated Press International|Associated Press Online|
BBC Monitoring Kiev Unit|Carpet & Floorcoverings Review|CNNMoney.com|Deutsche Presse-Agentur|
Emerging Markets Monitor|Evening Gazette|eWeek.com|FD (Fair Disclosure) Wire|FinancialWire|
PR Newswire US|SKRIN Market & Corporate News|
Thai News Service|The Associated Press|The Australian|The Business Times Singapore|The Economic Times|
The Globe and Mail (Canada)|The International Herald Tribune|
THE JOURNAL (Newcastle, UK)|The New York Sun|The Sun|The Washington Post|Variety"
for(i in 1:length(dzbank$news)){
  dzbank$search[i]<-"dzbank"
  dzbank$len[i]<-trimws(dzbank$len[i])
  dzbank$news[i]<-trimws(dzbank$news[i])
  dzbank$news[i]<-gsub("[[:digit:]]+ of [[:digit:]]+ DOCUMENTS","",dzbank$news[i])
  dzbank$news[i]<-gsub("LANGUAGE: ENGLISH","",dzbank$news[i])
  dzbank$news[i]<-gsub(paste0("PUBLICATION-TYPE:",dzbank$pubtype[i]),"",dzbank$news[i])
  dzbank$news[i]<-trimws(dzbank$news[i])
  dzbank$news[i]<-gsub(paste0("LOAD-DATE: ",dzbank$load_date[i]),"",dzbank$news[i])
  dzbank$news[i]<-trimws(dzbank$news[i])
  dzbank$news[i]<-gsub("Copyright [[:digit:]]+","",dzbank$news[i])
  dzbank$news[i]<-gsub("All Rights Reserved","",dzbank$news[i])
  dzbank$news[i]<-gsub("[[:digit:]]+:[[:digit:]]+ AM|PM GMT","",dzbank$news[i])
  dzbank$news[i]<-gsub(paste0("LENGTH: ",dzbank$len[i]," words"),"",dzbank$news[i])
  dzbank$news[i]<-gsub("The Main Wire","",dzbank$news[i])
  dzbank$news[i]<-gsub(agency,"",dzbank$news[i])
  dzbank$news[i]<-gsub("National Post \\(f/k/a The Financial Post\\) \\(Canada\\)","",dzbank$news[i])
  dzbank$news[i]<-trimws(dzbank$news[i])
  qwe<-strsplit(dzbank$news[i]," ")[[1]]
  dzbank$date[i]<-paste(qwe[1],qwe[2],qwe[3],qwe[4],sep = " ")
  dzbank$news[i]<-gsub(dzbank$date[i],"",dzbank$news[i])
  dzbank$news[i]<-trimws(dzbank$news[i])
}

hu.liu.pos = readLines('https://www.dropbox.com/sh/3xctszdxx4n00xq/AAA_Go_Y3kJxQACFaVBem__ea/positive-words.txt?dl=1')
hu.liu.neg = readLines('https://www.dropbox.com/sh/3xctszdxx4n00xq/AABTGWHitlRZcddq1pPXOSqca/negative-words.txt?dl=1')

