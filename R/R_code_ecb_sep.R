library(tm)
require(tm)
library(NLP)
removeURL <- function(x) gsub("http[^[:space:]]*", "", x)
removeNumPunct <- function(x) gsub("[^[:alpha:][:space:]]*", "", x)
myStopwords_de  <- c(setdiff(stopwords('german'), c("r", "big")), "ver","für", "ver","ungen", "ung","ae","ä","oe","ö","ue","eü","ü","eue","aün","auen","eün","euen", "ens", "en", "fiir","ãÿ","â???z")
myStopwords<- c(setdiff(stopwords('english'), c("r", "big")),"use", "see", "used", "via", "amp")


#######################
replaceWord <- function(corpus, oldwords, newword) {
  for (i in 1:length(oldwords) )
  {
    tm_map(corpus, content_transformer(gsub),pattern=oldwords[i], replacement=newword) }
}

###############
wordFreq <- function(corpus, word) {
  results <- lapply(corpus,function(x) { grep(as.character(x), pattern=paste0("nn<",word)) })
  sum(unlist(results))
}
##################################################################f
replaceWord2 <- function(corpus, oldword, newword) {
  tm_map(corpus, content_transformer(gsub),pattern=oldword, replacement=newword) 
}
###################################################################

hu.liu.pos = readLines('https://www.dropbox.com/sh/3xctszdxx4n00xq/AAA_Go_Y3kJxQACFaVBem__ea/positive-words.txt?dl=1');
hu.liu.neg = readLines('https://www.dropbox.com/sh/3xctszdxx4n00xq/AABTGWHitlRZcddq1pPXOSqca/negative-words.txt?dl=1');

score.sentiment = function(sentences, pos.words, neg.words, .progress='none')
{
  require(plyr);
  require(stringr);
  scores = laply(sentences, function(sentence, pos.words, neg.words) {
    sentence = gsub('[^A-z ]','', sentence)
    sentence = tolower(sentence);
    word.list = str_split(sentence, '\\s+');
    words = unlist(word.list);
    pos.matches = match(words, pos.words);
    neg.matches = match(words, neg.words);
    pos.matches = !is.na(pos.matches);
    neg.matches = !is.na(neg.matches);
    score = sum(pos.matches) - sum(neg.matches);
    return(score);
  }, pos.words, neg.words, .progress=.progress );
  scores.df = data.frame(score=scores);
  return(scores.df);
}

Textprocess <- function(mytext){
  myCorpus_eng <- Corpus(VectorSource(mytext),readerControl = list(language = "en"))
  myCorpus_eng <- tm_map(myCorpus_eng, content_transformer(tolower))
  myCorpus_eng <- tm_map(myCorpus_eng, content_transformer(removeURL))
  myCorpus_eng <- tm_map(myCorpus_eng, content_transformer(removeNumPunct))
  myCorpus_eng <- tm_map(myCorpus_eng, removeWords, stopwords("english"))
  myCorpus_eng <- tm_map(myCorpus_eng, stripWhitespace)
  myCorpus_eng <- tm_map(myCorpus_eng, stemDocument)
  tdm_eng <- TermDocumentMatrix(myCorpus_eng,  control = list(wordLengths = c(1, Inf)))
  idx_eng <- which(dimnames(tdm_eng)$Terms %in% keywords_main) 
  results_eng<-data.frame(t(as.matrix(tdm_eng[idx_eng,])))
}
  
  #################################################################################
  
  keywords_main <-c("price","deflat", "inflat","cent","expect","economi","ecb","europ","bank","draghi","board")
  myCorpus_eng <- replaceWord2(myCorpus_eng, "deflation", "deflat")
  myCorpus_eng <- replaceWord2(myCorpus_eng, "inflation", "inflat")
  myCorpus_eng <- replaceWord2(myCorpus_eng, "preis","price")
  myCorpus_eng <- replaceWord2(myCorpus_eng, "prei","price")
  
  myCorpus_eng <- replaceWord2(myCorpus_eng,"erwarten","expect")
  myCorpus_eng <- replaceWord2(myCorpus_eng,"constancio","board")
  myCorpus_eng <- replaceWord2(myCorpus_eng,"coeure","board")
  myCorpus_eng <- replaceWord2(myCorpus_eng,"lautenschlager","board")
  myCorpus_eng <- replaceWord2(myCorpus_eng,"mersch","board") 
  myCorpus_eng <- replaceWord2(myCorpus_eng,"praet","board")
  myCorpus_eng <- replaceWord2(myCorpus_eng,"stark","board")
  myCorpus_eng <- replaceWord2(myCorpus_eng,"smaghi","board")
  myCorpus_eng <- replaceWord2(myCorpus_eng,"paramo","board")
  myCorpus_eng <- replaceWord2(myCorpus_eng,"gonzalez","board")
  myCorpus_eng <- replaceWord2(myCorpus_eng,"trichet","board")
  myCorpus_eng <- replaceWord2(myCorpus_eng,"gugerell","board")
  myCorpus_eng <- replaceWord2(myCorpus_eng,"papademos","board")
  myCorpus_eng <- replaceWord2(myCorpus_eng,"constâncio","board")
  myCorpus_eng <- replaceWord2(myCorpus_eng,"couré","board")
  myCorpus_eng <- replaceWord2(myCorpus_eng,"tumpel","board")
  myCorpus_eng <- replaceWord2(myCorpus_eng,"gonzález","board")
  myCorpus_eng <- replaceWord2(myCorpus_eng,"lautenschläger","board")
  myCorpus_eng <- replaceWord2(myCorpus_eng,"governor","board")
  
  ################################################################
  myCorpus_eng <- replaceWord2(myCorpus_eng,"predict","expect")
  myCorpus_eng <- replaceWord2(myCorpus_eng,"forecast","expect")
  myCorpus_eng <- replaceWord2(myCorpus_eng,"believe","expect")
  myCorpus_eng <- replaceWord2(myCorpus_eng,"suppose","expect")
  myCorpus_eng <- replaceWord2(myCorpus_eng,"presume","expect")
  myCorpus_eng <- replaceWord2(myCorpus_eng,"imagine","expect")
  myCorpus_eng <- replaceWord2(myCorpus_eng,"assume","expect")
  myCorpus_eng <- replaceWord2(myCorpus_eng,"conjecture","expect")
  myCorpus_eng <- replaceWord2(myCorpus_eng,"guess","expect")
  myCorpus_eng <- replaceWord2(myCorpus_eng,"figur","expect")
  myCorpus_eng <- replaceWord2(myCorpus_eng,"anticipate","expect")
  myCorpus_eng <- replaceWord2(myCorpus_eng,"await","expect")
  myCorpus_eng <- replaceWord2(myCorpus_eng,"hope","expect")
  myCorpus_eng <- replaceWord2(myCorpus_eng,"foresee","expect")
  myCorpus_eng <- replaceWord2(myCorpus_eng,"thought","expect")
  
  
  tdm_eng <- TermDocumentMatrix(myCorpus_eng,  control = list(wordLengths = c(1, Inf)))
  idx_eng <- which(dimnames(tdm_eng)$Terms %in% keywords_main) 
  results_eng<-data.frame(t(as.matrix(tdm_eng[idx_eng,])))
}
#--------------------------------------------------------#---------------------------------------

##############################

j
file.names[j]

#################### main file 
setwd("D:/Francisco/blockchain")
file.names <- dir("D:/Francisco/blockchain", pattern =".TXT") 
doc_counter<-0
News_data<-c()
for (j in 36:length(file.names)){
    
con=file(file.names[j],open="r")
line=readLines(con) 
long=length(line)
close(con)
#############
correction<-c("We are sorry but there is an error in this")
sunline<-substr(line, 1, 42) 
correction_lines<-which(sunline==correction,) 
document_error<-length(correction_lines)

############### doc info
doc_numbers<-trimws(substr(trimws(line[2]), 6, 8))
if(is.na(doc_numbers)==T)
{
  doc_numbers<-trimws(substr(trimws(line[23]), 6, 8))
  
}
if(length(document_error)>0){
  doc_numbers <-as.numeric(doc_numbers)- document_error
}

print(doc_numbers)
sunline<-substr(line, 1, 10) 
loadDate_lines<-which(trimws(sunline)=="LOAD-DATE:",)  
if (length(loadDate_lines)== doc_numbers )
{
  loadDate_lines<-c(0,loadDate_lines)
  end_news<-loadDate_lines
}
else
{
  sunline<-substr(trimws(line),9,28)
  end_news<-which(trimws(sunline)=="DOCUMENTS",) 
  end_news <-c(end_news, length(line))
   #end_news<-c(0,end_news)

}

print(length(end_news))


for (i in 1:doc_numbers)
  {
  this_doc<-line[(end_news[i]+1):(end_news[i+1])]
  doc_counter<-doc_counter+1
  
sunline<-substr(this_doc, 1, 8) 
LENGTH_lines<-which(sunline=="LENGTH: ",) 
if (length(LENGTH_lines)==1){
  temp<-trimws(substr(this_doc[LENGTH_lines],9,50) )
News_data$Length[doc_counter]<-substr(temp,1,nchar(temp)-6)
}


##########################################
sunline<-substr(this_doc, 1, 10) 
HEADLINE_lines<-which(sunline=="HEADLINE: ",)  
if(length(HEADLINE_lines)==1){
News_data$HEADLINE[doc_counter]<-trimws(substr(this_doc[HEADLINE_lines],11,100000) )
}
##############################
sunline<-substr(this_doc, 1, 17) 
PUBLICATION_lines<-which(sunline=="PUBLICATION-TYPE:",) 
if(length(PUBLICATION_lines)==1){
  News_data$PUBLICATIONType[doc_counter]<-trimws(substr(this_doc[PUBLICATION_lines],18,100000) )
}
##############################


sunline<-substr(this_doc, 1, 10)
loadDate_line<-which(sunline=="LOAD-DATE:",)  
if (length(loadDate_line)>0)
{
  News_data$loadDate[doc_counter]<-trimws(substr(this_doc[loadDate_line],12,100000) )
}


sunline<-substr(this_doc, 1, 5)
body_lines<-which(sunline=="BODY:",)
sunline<-substr(this_doc, 1, 10) 
LANGUAGE_lines<-which(sunline=="LANGUAGE: ",)
sunline<-substr(this_doc, 1, 14) 
returs_lines<-which(sunline=="Return to List",)
sunline<-substr(this_doc, 1, 5)
TEXT_lines<-which(sunline=="TEXT:",)



if (length(body_lines)==1 ) 
{Start_line<-body_lines+1 } 
if (length(body_lines)==0 && length(HEADLINE_lines)==1 ) 
{Start_line<-HEADLINE_lines+1}
if (length(body_lines)==0 && length(HEADLINE_lines)==0 ) 
{Start_line<-LENGTH_lines+1 }
if (length(body_lines)==0 && length(HEADLINE_lines)==0  && length(LENGTH_lines)==0 ) 
{Start_line<-TEXT_lines+1 }


if (length(LANGUAGE_lines)==1 ) 
{End_line<-LANGUAGE_lines-1 } 
if (length(LANGUAGE_lines)==0 && length(PUBLICATION_lines)==1 ) 
{End_line<-PUBLICATION_lines-1 }
if (length(LANGUAGE_lines)==0 && length(PUBLICATION_lines)==0 && length(loadDate_line)==1 ) 
{End_line<-loadDate_line-1 }
if (length(LANGUAGE_lines)==0 && length(PUBLICATION_lines)==0  && length(loadDate_line)==0 && length(returs_lines)==1) 
{End_line<-returs_lines-1 }
if (length(LANGUAGE_lines)==0 && length(PUBLICATION_lines)==0  && length(loadDate_line)==0 && length(returs_lines)==0) 
{End_line<-length(this_doc)-1 }
temp1<-c()
temp<-""
temp1<-this_doc[Start_line:End_line]
for(jj in 1:length(temp1))  {temp<-paste0(temp,temp1[jj])}
News_data$Body[doc_counter]<-trimws(temp)

##########################
##### not correct date, should be from 1 to stat-line search for a month name and pick up that line

temp_docy<-c()
temp_doc<-this_doc[1:(Start_line-1)]

months_name<-c("January","February", "March", "April", "May", "June", "July", "August", "September", "October", "November","December")


for (jjj in 1:length(temp_doc))
{
 test<-c()
 name_month_test<-c()
  temp_temp<-trimws(temp_doc[jjj])
  for (jk in 1:10){ if (substr(temp_temp,jk,jk)==" ") {test<-jk}}
  if (length(test)>0){name_month_test<-trimws(substr(trimws(temp_doc[jjj]),1, test)) }
  if (length(name_month_test)>0){
    if (name_month_test == "Copyright" ){News_data$publisher[doc_counter]<-substr(trimws(temp_doc[jjj]),16,200)}
    for (jjjj in 1:12)
    {
      if (name_month_test == months_name[jjjj]){News_data$date_info[doc_counter]<-trimws(temp_doc[jjj])}
    }
  }
}

News_data$filename[doc_counter]<-file.names[j]

}
}


for (i in 2:doc_counter){
 if  (is.na(News_data$date_info[i])==T) { News_data$date_info[i]=News_data$date_info[i-1]}
}

for (i in 2:doc_counter){
  News_data$month[i]<-strsplit(News_data$date_info[i], " ")[[1]][1]
News_data$day[i]<-strsplit(News_data$date_info[i], " ")[[1]][2]
News_data$year[i]<-strsplit(News_data$date_info[i], " ")[[1]][3]
#News_data$day[i]<-strsplit(as.character(News_data$day[i]), ",")[1]
#News_data$day[i]<-as.numeric(strsplit(as.character(News_data$day[i]), ",")[1])
}



for (i in 2:doc_counter){
  if (is.na(News_data$year[i])==T) { News_data$date_info[i]<-as.character(News_data$date_info[i-1])}
}
for (i in 2:doc_counter){
  News_data$month[i]<-strsplit(News_data$date_info[i], " ")[[1]][1]
  News_data$day[i]<-strsplit(News_data$date_info[i], " ")[[1]][2]
  News_data$year[i]<-strsplit(News_data$date_info[i], " ")[[1]][3]
  #News_data$day[i]<-strsplit(as.character(News_data$day[i]), ",")[1]
  #News_data$day[i]<-as.numeric(strsplit(as.character(News_data$day[i]), ",")[1])
}


nayear<-which(is.na(News_data$year)=="NA")

for (i in 2:doc_counter){
  News_data$month[i]<-strsplit(News_data$date_info[i], " ")[[1]][1]
  News_data$day[i]<-strsplit(News_data$date_info[i], " ")[[1]][2]
  News_data$year[i]<-strsplit(News_data$date_info[i], " ")[[1]][3]
  #News_data$day[i]<-strsplit(as.character(News_data$day[i]), ",")[1]
  News_data$day[i]<-as.numeric(strsplit(as.character(News_data$day[i]), ",")[1])
}

for (i in 2:doc_counter){
  News_data$day[i]<-as.numeric(strsplit(as.character(News_data$day[i]), ",")[1])
}

nadays<-which(is.na(News_data$day)==T)

News_data$date_info[nadays]<-News_data$loadDate[nadays]
for (i in 2:doc_counter){
  News_data$month[i]<-strsplit(News_data$date_info[i], " ")[[1]][1]
  News_data$day[i]<-strsplit(News_data$date_info[i], " ")[[1]][2]
  News_data$year[i]<-strsplit(News_data$date_info[i], " ")[[1]][3]
  #News_data$day[i]<-strsplit(as.character(News_data$day[i]), ",")[1]
  News_data$day[i]<-as.numeric(strsplit(as.character(News_data$day[i]), ",")[1])
}
nadays<-which(is.na(News_data$day)==T)


slash_year<-which(News_data$year=="/")
News_data$date_info[slash_year]<-News_data$loadDate[slash_year]

document_year<-which(News_data$year=="Document")
News_data$date_info[document_year]<-News_data$loadDate[document_year]

document_year<-which(News_data$year=="1.")
News_data$date_info[document_year]<-News_data$loadDate[document_year]


document_year<-which(News_data$year=="of")
News_data$date_info[document_year]<-News_data$loadDate[document_year]


document_year<-which(News_data$month==19)
News_data$date_info[20851]<-as.vector("May 19 2017")



for (i in 1:doc_counter){
  News_data$month[i]<-strsplit(News_data$date_info[i], " ")[[1]][1]
  News_data$day[i]<-strsplit(News_data$date_info[i], " ")[[1]][2]
  News_data$year[i]<-strsplit(News_data$date_info[i], " ")[[1]][3]
  #News_data$day[i]<-strsplit(as.character(News_data$day[i]), ",")[1]
  News_data$day[i]<-as.numeric(strsplit(as.character(News_data$day[i]), ",")[1])
  News_data$year[i]<-as.numeric(strsplit(as.character(News_data$year[i]), ",")[1])
  News_data$year[i]<-as.numeric(strsplit(as.character(News_data$year[i]), ";")[1])
}


News_data$date<-paste(trimws(News_data$day),"/", trimws(News_data$month),"/",trimws(News_data$year))


News_data$date_info[nadays]
News_data$filename[nadays]
News_data$year[nadays]
News_data$publisher[nadays]
unique(News_data$year)
unique(News_data$month)
unique(News_data$day)


News_data$month2<-c()
for(iii in 20870:doc_counter){
  News_data$month2[iii]<-switch(as.vector(News_data$month[iii]),"January"=1 , "February"=2, "March"=3,"April"=4 , "May"=5, "June"=6,"July"=7 , "August"=8, "September"=9,"October"=10 , "November"=11, "December"=12, "19"=5, " "=0)
}
News_data$date<-ISOdate(trimws(News_data$year),trimws(News_data$month2),trimws(News_data$day),,)





results_eng<-Textprocess(News_data$Body)
News_data<-cbind(News_data,results_eng)
News_data$score_sentiment<-score.sentiment(News_data$Body,hu.liu.pos,hu.liu.neg)







########################################
findAssocs(tdm_eng, "ecb", 0.5)
######################################

News_data<-News_data[order(News_data$date),]
Daily_impact_median<-aggregate(News_data$score_sentiment, by= list(Category=News_data$date), FUN=median)
Daily_impact_mean<-aggregate(News_data$score_sentiment, by= list(Category=News_data$date), FUN=mean)
Daily_news_count<-(aggregate(News_data$score_sentiment, by= list(Category=News_data$date), FUN=length))
Daily_news_sum_deflation<-(aggregate(News_data$deflat, by= list(Category=News_data$date), FUN=sum))
Daily_news_sum_dargi<-(aggregate(News_data$draghi, by= list(Category=News_data$date), FUN=sum))
Daily_news_sum_board<-(aggregate(News_data$board, by= list(Category=News_data$date), FUN=sum))
Daily_impact_median$Daily_impact_median<-Daily_impact_median$score
Daily_impact_mean$Daily_impact_mean<-Daily_impact_mean$score
Daily_news_count$Daily_news_count<-Daily_news_count$score
Daily_news_sum_deflation$Daily_news_sum_deflation<-Daily_news_sum_deflation$x
Daily_news_sum_dargi$Daily_news_sum_dargi<-Daily_news_sum_dargi$x
Daily_news_sum_board$Daily_news_sum_board<-Daily_news_sum_board$x
final_daily<-c()
final_daily<-cbind(as.Date(Daily_impact_median$Category),Daily_impact_median$Daily_impact_median,Daily_impact_mean$Daily_impact_mean,Daily_news_count$Daily_news_count,Daily_news_sum_deflation$Daily_news_sum_deflation,Daily_news_sum_dargi$Daily_news_sum_dargi,Daily_news_sum_board$Daily_news_sum_board)
final_daily<-data.frame(final_daily)
names(final_daily)<-c("date","Daily_impact_median","Daily_impact_mean","Newscount","sum_deflation","sum_dargi","sum_board")

setwd("D:/Deflation Project/august 2017")
#News_data$date_info<-c()
#News_data$publication<-c()
final_daily<-cbind(as.Date(Daily_impact_median$Category),final_daily)
final_daily$date<-c()
names(final_daily)<-c("date","Daily_impact_median","Daily_impact_mean","Newscount","sum_deflation","sum_dargi","sum_board")
View(final_daily)
########################## test LSA
library("lsa")
require("lsa")
library(tm)
############
setwd("D:/Deflation Project")
file.name <- dir("D:/Deflation Project/", pattern =".txt") 
  con=file(file.name,open="r")
  line=readLines(con) 
  long=length(line)
  close(con)

  Defilation_def<-c()
temp<-""
for(jj in 1:length(line))  {temp<-paste0(temp,line[jj])}
Defilation_def<-trimws(temp)
########################################speech
speech_matrix_frame<-c()
speech_matrix_frame<-as.data.frame(speech_matrix)
for (i in 1:length(speech_matrix)[1])
{
text<-as.character(rbind(speech_matrix_frame$body[i],Defilation_def))

view <- factor((c("view 1", "view 2")))
df <- data.frame(text, view, stringsAsFactors = FALSE)
# prepare corpus
corpus <- Corpus(VectorSource(df$text))
corpus <- tm_map(corpus, tolower)
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, function(x) removeWords(x, stopwords("english")))
corpus <- tm_map(corpus, stemDocument, language = "english")

td.mat <- as.matrix(TermDocumentMatrix(corpus))
dist.mat <- dist(t(as.matrix(td.mat)))
speech_matrix_frame$dist.mat[i]<-dist.mat  # check distance matrix

td.mat.lsa <- lw_bintf(td.mat) * gw_idf(td.mat)  # weighting
lsaSpace <- lsa(td.mat.lsa)  # create LSA space
dist.mat.lsa <- dist(t(as.textmatrix(lsaSpace)))  # compute distance matrix
speech_matrix_frame$dist.mat.lsa[i]<-dist.mat.lsa  # check distance mantrix
}
results_eng<-Textprocess(speech_matrix_frame$body)
speech_matrix_frame<-cbind(speech_matrix_frame,results_eng)
speech_matrix_frame$score_sentiment<-score.sentiment(speech_matrix_frame$body,hu.liu.pos,hu.liu.neg)

View(speech_matrix_frame)

############################Interview
Interview_matrix_frame<-c()
Interview_matrix_frame<-as.data.frame(interviews_matrix)
View(Interview_matrix_frame)
for (i in 1:length(interviews_matrix)[1])
{
  text<-as.character(rbind(Interview_matrix_frame$body[i],Defilation_def))
  
  view <- factor((c("view 1", "view 2")))
  df <- data.frame(text, view, stringsAsFactors = FALSE)
  # prepare corpus
  corpus <- Corpus(VectorSource(df$text))
  corpus <- tm_map(corpus, tolower)
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, function(x) removeWords(x, stopwords("english")))
  corpus <- tm_map(corpus, stemDocument, language = "english")
  
  td.mat <- as.matrix(TermDocumentMatrix(corpus))
  dist.mat <- dist(t(as.matrix(td.mat)))
  Interview_matrix_frame$dist.mat[i]<-dist.mat  # check distance matrix
  
  td.mat.lsa <- lw_bintf(td.mat) * gw_idf(td.mat)  # weighting
  lsaSpace <- lsa(td.mat.lsa)  # create LSA space
  dist.mat.lsa <- dist(t(as.textmatrix(lsaSpace)))  # compute distance matrix
  Interview_matrix_frame$dist.mat.lsa[i]<-dist.mat.lsa  # check distance mantrix
}

results_eng<-Textprocess(Interview_matrix_frame$body)
Interview_matrix_frame<-cbind(Interview_matrix_frame,results_eng)
Interview_matrix_frame$score_sentiment<-score.sentiment(Interview_matrix_frame$body,hu.liu.pos,hu.liu.neg)

View(Interview_matrix_frame)
#####################################Press
Press_matrix_frame<-c()
Press_matrix_frame<-as.data.frame(press_matrix)
View(Press_matrix_frame)
for (i in 1:length(press_matrix)[1])
{
  text<-as.character(rbind(Press_matrix_frame$body[i],Defilation_def))
  
  view <- factor((c("view 1", "view 2")))
  df <- data.frame(text, view, stringsAsFactors = FALSE)
  # prepare corpus
  corpus <- Corpus(VectorSource(df$text))
  corpus <- tm_map(corpus, tolower)
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, function(x) removeWords(x, stopwords("english")))
  corpus <- tm_map(corpus, stemDocument, language = "english")
  
  td.mat <- as.matrix(TermDocumentMatrix(corpus))
  dist.mat <- dist(t(as.matrix(td.mat)))
  Press_matrix_frame$dist.mat[i]<-dist.mat  # check distance matrix
  
  td.mat.lsa <- lw_bintf(td.mat) * gw_idf(td.mat)  # weighting
  lsaSpace <- lsa(td.mat.lsa)  # create LSA space
  dist.mat.lsa <- dist(t(as.textmatrix(lsaSpace)))  # compute distance matrix
  Press_matrix_frame$dist.mat.lsa[i]<-dist.mat.lsa  # check distance mantrix
}

results_eng<-Textprocess(Press_matrix_frame$body)
Press_matrix_frame<-cbind(Press_matrix_frame,results_eng)
Press_matrix_frame$score_sentiment<-score.sentiment(Press_matrix_frame$body,hu.liu.pos,hu.liu.neg)

View(Press_matrix_frame)

setwd("D:/Deflation Project/august 2017")

write.csv(final_daily, file = "final_daily.csv")
save(final_daily,speech_matrix_frame, Interview_matrix_frame, Press_matrix_frame,News_data , file = "final_agust28.RData")





############ code for graphs it is not complete

#inspect a particular document
#writeLines(as.character(myCorpus[[30]]))

getTransformations()


dtm <- DocumentTermMatrix(myCorpus)
freq <- colSums(as.matrix(dtm))
length(freq)

#create sort order (descending)
ord <- order(freq,decreasing=TRUE)
#inspect most frequently occurring terms
freq[head(ord)]
#inspect least frequently occurring terms
freq[tail(ord)] 



dtmr <-DocumentTermMatrix(myCorpus_eng, control=list(wordLengths=c(5, 6),   bounds = list(global = c(5,10))))
findAssocs(dtmr,"deflat",0.1)
freqr <- colSums(as.matrix(dtmr))
#length should be total number of terms
length(freqr)
#create sort order (asc)
ordr <- order(freqr,decreasing=TRUE)
#inspect most frequently occurring terms
freqr[head(ordr)]
#inspect least frequently occurring terms
freqr[tail(ordr)]

#################
######### Graph
######### Graph
wf=data.frame(term=names(freqr),occurrences=freqr)
library(ggplot2)
p <- ggplot(subset(wf, freqr>70), aes(term, occurrences))
p <- p + geom_bar(stat="identity")
p <- p + theme(axis.text.x=element_text(angle=45, hjust=1))
p


#wordcloud
library(wordcloud)
#setting the same seed each time ensures consistent look across clouds
set.seed(42)
#limit words by specifying min frequency
wordcloud(names(freqr),freqr, min.freq=10)




###############################################
