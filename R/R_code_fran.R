
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
  scores.df = data.frame(score=scores, text=sentences);
  return(scores.df);
}



#################### main file 
setwd("~/Google\ Drive/thesis/7Text")
fileName="All_English_Language_News2017-07-03_22-30.TXT"
con=file(fileName,open="r")
line=readLines(con) 
long=length(line)
close(con)



body_lines<-which(line=="BODY:")
returs_lines<-which(line=="Return to List")

sunline<-substr(line, 1, 17) 
returs_lines<-which(sunline=="PUBLICATION-TYPE:")

Publication_type<-substr(line[returs_lines], 18, 50) 


text_list<-list()
for (i in 1:length(body_lines))
{
  text_list[[i]]<-line[(body_lines[i]+1):(returs_lines[i]-1)]
  
}


myCorpus <- Corpus(VectorSource(text_list),readerControl = list(language = "en"))
myCorpus <- tm_map(myCorpus, content_transformer(tolower))
myCorpus <- tm_map(myCorpus, content_transformer(removeURL))
myCorpus <- tm_map(myCorpus, content_transformer(removeNumPunct))
myCorpus <- tm_map(myCorpus, removeWords, stopwords("english"))
myCorpus <- tm_map(myCorpus, stripWhitespace)
myCorpus <- tm_map(myCorpus, stemDocument)

tdm <- TermDocumentMatrix(myCorpus,  control = list(wordLengths = c(1, Inf)))
idx <- which(dimnames(tdm)$Terms %in% keywords_main) 


results_news2<-data.frame(t(as.matrix(tdm[idx,])))

(freq.terms <- findFreqTerms(tdm, lowfreq = 1, highfreq = Inf))
(freq.terms <- findFreqTerms(tdm, lowfreq = 100001, highfreq = Inf))
(freq.terms <- findFreqTerms(tdm, lowfreq = 50001, highfreq = 100000))
(freq.terms <- findFreqTerms(tdm, lowfreq = 40001, highfreq = 50000))
(freq.terms <- findFreqTerms(tdm, lowfreq = 30001, highfreq = 40000))
(freq.terms <- findFreqTerms(tdm, lowfreq = 20001, highfreq = 30000))
(freq.terms <- findFreqTerms(tdm, lowfreq = 10001, highfreq = 20000))
(freq.terms <- findFreqTerms(tdm, lowfreq = 9001, highfreq = 10000))
(freq.terms <- findFreqTerms(tdm, lowfreq = 5001, highfreq = 9000))
(freq.terms <- findFreqTerms(tdm, lowfreq = 4001, highfreq = 5000))
(freq.terms <- findFreqTerms(tdm, lowfreq = 2001, highfreq = 4000))
(freq.terms <- findFreqTerms(tdm, lowfreq = 1000, highfreq = 2000))
(freq.terms <- findFreqTerms(tdm, lowfreq = 500, highfreq = 999))
(freq.terms <- findFreqTerms(tdm, lowfreq = 300, highfreq = 499))
(freq.terms <- findFreqTerms(tdm, lowfreq = 100, highfreq = 299))
(freq.terms <- findFreqTerms(tdm, lowfreq = 1, highfreq = 99))
keywords_main <-c("fintech","blockchain","bank","regul","growth","pay")
idx <- which(dimnames(tdm)$Terms %in% keywords_main) 
results_block<-data.frame(t(as.matrix(tdm[idx,])))

#####################################

myCorpus <- replaceWord2(myCorpus,"anticipate","expect")


keywords_main <-c("price","deflat", "inflat", "eurozon","expect","oil","japan","economi","ecb","gold","china","europ","energi","draghi","nfl","germani","commod","fuel","polici","board")



tdm <- TermDocumentMatrix(myCorpus,  control = list(wordLengths = c(1, Inf)))
idx <- which(dimnames(tdm)$Terms %in% keywords_main) 


results_news2<-data.frame(t(as.matrix(tdm[idx,])))

(freq.terms <- findFreqTerms(tdm, lowfreq = 1, highfreq = Inf))
