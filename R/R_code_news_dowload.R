library(RSelenium)
require(RSelenium)
library(XML)

source_dir<-"C:/Users/Project/Downloads/"
directory<-"C:/Users/Project/Desktop/Files/"

download_excel<-function(){
  remDr$findElement('id',"delivery_DnldRender")$clickElement() 
  Sys.sleep(10)
  remDr$findElement('link text',"Format Options")$clickElement() 
  Sys.sleep(15)
  remDr$findElement('xpath',"//*/option[@value = 'QDS_EF_CSV']")$clickElement() 
  remDr$findElement('xpath',"//*/option[@value = 'QDS_EF_CSV']")$clickElement() 
  
  Sys.sleep(15)
  #remDr$findElement('link text',"Modify...")$clickElement() 
  #Sys.sleep(15)
  # remDr$findElement('link text',"Select All")$clickElement() 
  # Sys.sleep(15)
  #remDr$findElement('class',"okSubmitBtn")$clickElement() 
  # Sys.sleep(15)
  remDr$findElement('class',"deliverBtn")$clickElement() 
  Sys.sleep(20)
  #while(length(list.files(source_dir))==0){}
  remDr$findElement('id',"closeBtn")$clickElement()
}
download_text<-function(){
  remDr$findElement('id',"delivery_DnldRender")$clickElement() 
  Sys.sleep(5)
  #remDr$findElement('link text',"Format Options")$clickElement() 
  #Sys.sleep(15)
  # remDr$findElement('xpath',"//*/option[@value = 'QDS_EF_GENERICTYPE']")$clickElement() 
  #remDr$findElement('xpath',"//*/option[@value = 'QDS_EF_GENERICTYPE']")$clickElement() 
  #remDr$findElement('xpath',"//*/option[@value = 'QDS_EF_GENERICTYPE']")$clickElement() 
  
  
  # Sys.sleep(5)
  remDr$findElement('link text',"Download Options")$clickElement() 
  # Sys.sleep(10)
  remDr$findElement('xpath', "//*/option[@value = 'SEGMTS']")$clickElement() 
  #remDr$findElement('xpath', "//*/option[@value = 'SEGMTS']")$clickElement() 
  #remDr$findElement('xpath', "//*/option[@value = 'SEGMTS']")$clickElement() 
  
  
  Sys.sleep(5)
  remDr$findElement('id',"modifyLink")$clickElement()
  #remDr$findElement('class',"linksmall selectAll")$clickElement()
  Sys.sleep(5)
  #id<-c("chk1","chk7","chk14","chk8","chk15","chk16","chk12","chk30","chk1","chk2","chk3","chk4","chk5","chk6","chk8","chk9")
  # id<-c("chk1","chk2","chk3","chk4","chk5","chk6","chk7","chk8","chk9","chk10","chk12","chk13","chk14","chk15","chk16","chk17","chk18","chk19",
  #  "chk20", "chk21","chk22","chk23","chk24")
  # ,"chk25","chk27","chk35")
  
  #,"chk37",
  #    "chk38","chk41","chk45","chk46","chk48","chk49")
  # id<-c("chk1")
  # for(i in 1:length(id)){remDr$findElement('id',id[i])$clickElement()}
  remDr$findElement('class',"selectAll")$clickElement()
  
  Sys.sleep(5)
  
  remDr$findElement('class',"okSubmitBtn")$clickElement()
  #Sys.sleep(5)
  #remDr$findElement('link text',"Page Options")$clickElement()
  # Sys.sleep(5)
  # remDr$findElement('id',"inclDocs")$clickElement()
  #Sys.sleep(5)
  # remDr$findElement('id',"endpg")$clickElement()
  #Sys.sleep(5)
  #remDr$findElement('id',"docnewpg")$clickElement()
  # Sys.sleep(5)
  # remDr$findElement('link text',"Format Options")$clickElement() 
  # Sys.sleep(5)
  #  remDr$findElement('xpath',"//*/option[@value = 'QDS_EF_GENERICTYPE']")$clickElement() 
  # remDr$findElement('class name',"btn primary")$clickElement() 
  Sys.sleep(5)
  remDr$findElement('xpath',"//*[contains(concat( \" \", @class, \" \" ), concat( \" \", \"deliverBtn\", \" \" ))]//img")$clickElement() 
  
}


##################### initail for accepting
rD<-rsDriver(port = 4567L, browser = c("firefox")) 
remDr<-rD[["client"]]
start_date<-as.Date("2005-01-01")
end_date<-start_date+7
today<-Sys.Date()
one<-"https://www.nexis.com/api/version1/au?la=en"
two<-"https://www.nexis.com/search/flap.do?flapID=home&random=0.7614609425383752"
search<-c("deutschebank")
remDr$navigate(one)

### Stop 
# First Run


remDr$navigate(one)
Sys.sleep(5)
remDr$findElement('css selector', "#secondarytabs .active+ li .null")$clickElement()
Sys.sleep(5)
searchbox=remDr$findElement('id',"searchTextAreaStyle")
searchbox$clickElement()
searchbox$sendKeysToElement(list(c("low inflation ecb")))
Sys.sleep(5)
id<-c("groupDuplicates","searchNaturalStyle")
Sys.sleep(5)
for(i in 1:length(id)){remDr$findElement('id',id[i])$clickElement()}
Sys.sleep(5)
remDr$findElement('id',"sourceSelectDDStyle")$clickElement()
Sys.sleep(15)
remDr$findElement('xpath', "//*/option[@value = 'F_GB00NBGenSrch.CS00900470;All English Language News']")$clickElement()
Sys.sleep(15)
remDr$findElement('xpath',   "//*/option[@value = 'from']")$clickElement() 
remDr$findElement('id',"fromDate")$clickElement()
Sys.sleep(5)
for(t in 1:16){
  remDr$findElement('id',"fromDate")$sendKeysToElement(list(key = "delete"))
  remDr$findElement('id',"fromDate")$sendKeysToElement(list(key = "backspace"))
}
Sys.sleep(5)
date_<-paste0(
  as.character(format(as.Date(start_date,format="%d/%m/%y"),"%d")),"/",
  as.character(format(as.Date(start_date,format="%d/%m/%y"),"%m")),"/","20",
  as.character(format(as.Date(start_date,format="%d/%m/%y"),"%y")))
Sys.sleep(5)
remDr$findElement('id',"fromDate")$sendKeysToElement(list(date_))
Sys.sleep(5)
remDr$findElement('id',"toDate")$clickElement()
for(t in 1:16){
  remDr$findElement('id',"toDate")$sendKeysToElement(list(key = "delete"))
  remDr$findElement('id',"toDate")$sendKeysToElement(list(key = "backspace"))
}
Sys.sleep(5)
date_<-paste0(
  as.character(format(as.Date(end_date,format="%d/%m/%y"),"%d")),"/",
  as.character(format(as.Date(end_date,format="%d/%m/%y"),"%m")),"/","20",
  as.character(format(as.Date(end_date,format="%d/%m/%y"),"%y")))
Sys.sleep(5)
remDr$findElement('id',"toDate")$sendKeysToElement(list(date_))
Sys.sleep(5)
remDr$findElement('id',"enableSearchImg")$clickElement()
num_of_results<-remDr$findElement('id',"updateCountDiv")$getElementText()
num_of_results<-gsub("\\(","",num_of_results[[1]])
num_of_results<-gsub("\\)","",num_of_results[[1]])
num_of_results<-as.numeric(num_of_results)
num_of_loops<-as.integer(num_of_results/200)
# Sys.sleep(15)
# download_excel()
# Sys.sleep(15)
# string_CSV<-paste0(search[1]," ",start_date," to ",end_date,".CSV")
# string_CSV<-paste0(directory,string_CSV)
# source_CSV<-dir(source_dir,pattern = ".CSV")
# source_CSV_data<-paste0(source_dir,source_CSV[1])
# file.copy(source_CSV_data,string_CSV)
# file.remove(source_CSV_data[1])
Sys.sleep(5)
download_text()
Sys.sleep(10)
#while(length(list.files(source_dir))==0){}
remDr$findElement('id',"closeBtn")$clickElement()
Sys.sleep(10)
source_text<-dir(source_dir,pattern = ".TXT")
string_text<-paste0(search[1]," ",start_date," to ",end_date,".TXT")
string_text<-paste0(directory,string_text)
source_text_data<-paste0(source_dir,source_text[1])
file.copy(source_text_data,string_text)
file.remove(source_text_data[1])
start_date<-end_date+1
end_date<-start_date+7

###########################################
start_date<-as.Date("2005-01-01")
end_date<-start_date+7
today<-Sys.Date()
searchterm<-c("low inflation ECB")
while(end_date<today){
  
  remDr$navigate(one)
  Sys.sleep(5)
  remDr$findElement('css selector', "#secondarytabs .active+ li .null")$clickElement()
  Sys.sleep(5)
  searchbox=remDr$findElement('id',"searchTextAreaStyle")
  searchbox$clickElement()
  searchbox$sendKeysToElement(list(searchterm))
  #Sys.sleep(5)
  #id<-c("groupDuplicates","searchNaturalStyle")
  #for(i in 1:length(id)){remDr$findElement('id',id[i])$clickElement()}
  #Sys.sleep(5)
  #remDr$findElement('id',"sourceSelectDDStyle")$clickElement()
  #Sys.sleep(5)
  
  #remDr$findElement('xpath',   "//*/option[@value = 'from']")$clickElement() 
  Sys.sleep(1)
  remDr$findElement('id',"fromDate")$clickElement()
  Sys.sleep(1)
  for(t in 1:16){
    remDr$findElement('id',"fromDate")$sendKeysToElement(list(key = "delete"))
    remDr$findElement('id',"fromDate")$sendKeysToElement(list(key = "backspace"))
  }
  Sys.sleep(1)
  date_<-paste0(
    as.character(format(as.Date(start_date,format="%d/%m/%y"),"%d")),"/",
    as.character(format(as.Date(start_date,format="%d/%m/%y"),"%m")),"/","20",
    as.character(format(as.Date(start_date,format="%d/%m/%y"),"%y")))
  Sys.sleep(1)
  remDr$findElement('id',"fromDate")$sendKeysToElement(list(date_))
  Sys.sleep(1)
  remDr$findElement('id',"toDate")$clickElement()
  Sys.sleep(1)
  for(t in 1:16){
    remDr$findElement('id',"toDate")$sendKeysToElement(list(key = "delete"))
    remDr$findElement('id',"toDate")$sendKeysToElement(list(key = "backspace"))
  }
  Sys.sleep(1)
  date_<-paste0(
    as.character(format(as.Date(end_date,format="%d/%m/%y"),"%d")),"/",
    as.character(format(as.Date(end_date,format="%d/%m/%y"),"%m")),"/","20",
    as.character(format(as.Date(end_date,format="%d/%m/%y"),"%y")))
  Sys.sleep(1)
  remDr$findElement('id',"toDate")$sendKeysToElement(list(date_))
  Sys.sleep(5)
  #remDr$findElement('xpath', "//*/option[@value = 'F_GB00NBGenSrch.CS00900470;All English Language News']")$clickElement()
  #Sys.sleep(20)
  remDr$findElement('id',"enableSearchImg")$clickElement()
  Sys.sleep(5)
  
  pagetitle<-remDr$getTitle()
  pagetitle<-substr(pagetitle,9,9)
  if (pagetitle=="R" ){
    
    results<-remDr$findElement('id',"results")$getElementText()
    result_test<-substr(results[[1]],1,1)
    if (result_test=="s" ){
      Sys.sleep(1)
      resultsinfo<-remDr$findElement('id',"searchinfo")$getElementText()
      Sys.sleep(3)
      #resultsinfo<-gsub("\\(","",resultsinfo[[1]])
      #resultsinfo<-gsub("\\)","",resultsinfo[[1]])
      #nserchsize<-nchar(searchterm)
      searchsize<-substr(resultsinfo,nserchsize+18,nserchsize+18)
      
      if (searchsize>0){
        num_of_results<-remDr$findElement('id',"updateCountDiv")$getElementText()
        num_of_results<-gsub("\\(","",num_of_results[[1]])
        num_of_results<-gsub("\\)","",num_of_results[[1]])
        num_of_results<-as.numeric(num_of_results)
        num_of_loops<-as.integer(num_of_results/200)
        Sys.sleep(5)
        download_text()
        Sys.sleep(10)
        if(num_of_results>50)
        {
          Sys.sleep(10)
        }
        if(num_of_results>100)
        {
          Sys.sleep(10)
        }
        if(num_of_results>150)
        {
          Sys.sleep(10)
        }
        #while(length(list.files(source_dir))==0){}
        remDr$findElement('id',"closeBtn")$clickElement()
        source_text<-dir(source_dir,pattern = ".TXT")
        string_text<-paste0(search[1]," ",start_date," to ",end_date,".TXT")
        string_text<-paste0(directory,string_text)
        source_text_data<-paste0(source_dir,source_text[1])
        file.copy(source_text_data,string_text)
        file.remove(source_text_data[1])
      }
      
    }
  }
  # 
  # download_excel()
  # Sys.sleep(15)
  # string_CSV<-paste0(search[1]," ",start_date," to ",end_date,".CSV")
  # string_CSV<-paste0(directory,string_CSV)
  # source_CSV<-dir(source_dir,pattern = ".CSV")
  # source_CSV_data<-paste0(source_dir,source_CSV[1])
  # file.copy(source_CSV_data,string_CSV)
  # file.remove(source_CSV_data[1])
  Sys.sleep(5)
  start_date<-end_date+1
  end_date<-start_date+4
}

remDr$close


##############################################






#####################################################
###########################################################################
###################################################################################
###########################################################################################








remDr$setImplicitWaitTimeout(2000000000000) 
remDr$findElement('id',"closeBtn")$clickElement()



remDr$setImplicitWaitTimeout(20000000000000)
remDr$findElement('link text',"Power Search")$clickElement()
source_dir<-"C:/Users/Project/Downloads/"
directory<-"C:/Users/Project/Desktop/Files/"
list.files(directory)
list.files(source_dir)
remDr$setImplicitWaitTimeout(20000000000000)
source_text<-dir(source_dir,pattern = ".TXT")
#    source_CSV<-dir(source_dir,pattern = ".CSV")
files.text<-dir(directory, pattern = ".TXT")

#    files.CSV<-dir(directory, pattern = ".CSV")
source_text_data<-paste0(source_dir,source_text[1])
#    source_CSV_data<-paste0(source_dir,source_CSV[i])
string_text<-paste0(search[element]," ",start_date," to ",end_date,".TXT")
string_text<-paste0(directory,string_text)
#    string_CSV<-paste0(ssmBanks$bank[element]," ",start_date," to ",end_date,".CSV")
#    string_CSV<-paste0(directory,string_CSV)
file.copy(source_text_data,string_text)
#    file.copy(source_CSV_data[i],string_CSV)
#    file.remove(source_CSV_data[i])
file.remove(source_text_data[1])
news$country[fill]<-ssmBanks$country[element]
news$bank[fill]<-ssmBanks$bank[element]
news$s_date[fill]<-start_date
news$e_date[fill]<-end_date
# news$body.text[fill]<-read.table(string_text,header = FALSE)
fill<-fill+1
start_date<-end_date+1
end_date<-start_date+7
remDr$setImplicitWaitTimeout(200000)








while(end_date<today){
  remDr$findElement('xpath', 
                    "//*/option[@value = 'from']")$clickElement() 
  remDr$findElement('id',"fromDate")$clickElement()
  for(t in 1:16){
    remDr$findElement('id',"fromDate")$sendKeysToElement(list(key = "delete"))
    remDr$findElement('id',"fromDate")$sendKeysToElement(list(key = "backspace"))
  }
  date_<-paste0(
    as.character(format(as.Date(start_date,format="%d/%m/%y"),"%d")),"/",
    as.character(format(as.Date(start_date,format="%d/%m/%y"),"%m")),"/","20",
    as.character(format(as.Date(start_date,format="%d/%m/%y"),"%y")))
  remDr$findElement('id',"fromDate")$sendKeysToElement(list(date_))
  remDr$findElement('id',"toDate")$clickElement()
  for(t in 1:16){
    remDr$findElement('id',"toDate")$sendKeysToElement(list(key = "delete"))
    remDr$findElement('id',"toDate")$sendKeysToElement(list(key = "backspace"))
  }
  date_<-paste0(
    as.character(format(as.Date(end_date,format="%d/%m/%y"),"%d")),"/",
    as.character(format(as.Date(end_date,format="%d/%m/%y"),"%m")),"/","20",
    as.character(format(as.Date(end_date,format="%d/%m/%y"),"%y")))
  remDr$findElement('id',"toDate")$sendKeysToElement(list(date_))
  remDr$findElement('id',"enableSearchImg")$clickElement()
  num_of_results<-remDr$findElement('id',"updateCountDiv")$getElementText()
  num_of_results<-gsub("\\(","",num_of_results[[1]])
  num_of_results<-gsub("\\)","",num_of_results[[1]])
  num_of_results<-as.numeric(num_of_results)
  num_of_loops<-as.integer(num_of_results/200)
  #download_excel()
  #remDr$findElement('id',"closeBtn")$clickElement()
  download_text()
  remDr$setImplicitWaitTimeout(2000000000000) 
  while(length(list.files(source_dir))==0){}
  remDr$findElement('id',"closeBtn")$clickElement()
  remDr$setImplicitWaitTimeout(20000000000000)
  remDr$findElement('link text',"Power Search")$clickElement()
  source_dir<-"C:/Users/Project/Downloads/"
  directory<-"C:/Users/Project/Desktop/Files/"
  list.files(directory)
  list.files(source_dir)
  remDr$setImplicitWaitTimeout(20000000000000)
  source_text<-dir(source_dir,pattern = ".TXT")
  #    source_CSV<-dir(source_dir,pattern = ".CSV")
  files.text<-dir(directory, pattern = ".TXT")
  
  #    files.CSV<-dir(directory, pattern = ".CSV")
  source_text_data<-paste0(source_dir,source_text[1])
  #    source_CSV_data<-paste0(source_dir,source_CSV[i])
  string_text<-paste0(search[element]," ",start_date," to ",end_date,".TXT")
  string_text<-paste0(directory,string_text)
  #    string_CSV<-paste0(ssmBanks$bank[element]," ",start_date," to ",end_date,".CSV")
  #    string_CSV<-paste0(directory,string_CSV)
  file.copy(source_text_data,string_text)
  #    file.copy(source_CSV_data[i],string_CSV)
  #    file.remove(source_CSV_data[i])
  file.remove(source_text_data[1])
  news$country[fill]<-ssmBanks$country[element]
  news$bank[fill]<-ssmBanks$bank[element]
  news$s_date[fill]<-start_date
  news$e_date[fill]<-end_date
  # news$body.text[fill]<-read.table(string_text,header = FALSE)
  fill<-fill+1
  start_date<-end_date+1
  end_date<-start_date+7
  remDr$setImplicitWaitTimeout(200000)
  #  }
}
remDr$setImplicitWaitTimeout(200000)
remDr$close
}



########################################################################
########################################################################









# body.text<-country<-bank<-ticker<-s_date<-e_date<-c(1:125)
# ssmBanks<-data.frame(country,bank,ticker)
# news<-data.frame(country,bank,s_date,e_date,body.text)
# for(i in 1:7){ssmBanks$country[i]="Belgium"}
# for(i in 8:28){ssmBanks$country[i]="Germany"}
# for(i in 29:30){ssmBanks$country[i]="Estonia"}
# for(i in 31:35){ssmBanks$country[i]="Ireland"}
# for(i in 36:39){ssmBanks$country[i]="Greece"}
# for(i in 40:53){ssmBanks$country[i]="Spain"}
# for(i in 54:66){ssmBanks$country[i]="France"}
# for(i in 67:80){ssmBanks$country[i]="Italy"}
# for(i in 81:84){ssmBanks$country[i]="Cyprus"}
# for(i in 85:87){ssmBanks$country[i]="Latvia"}
# for(i in 88:90){ssmBanks$country[i]="Lithuania"}
# for(i in 91:94){ssmBanks$country[i]="Luxembourg"}
# for(i in 95:97){ssmBanks$country[i]="Malta"}
# for(i in 98:103){ssmBanks$country[i]="The Netherlands"}
# for(i in 104:111){ssmBanks$country[i]="Austria"}
# for(i in 112:115){ssmBanks$country[i]="Portugal"}
# for(i in 116:118){ssmBanks$country[i]="Slovenia"}
# for(i in 119:121){ssmBanks$country[i]="Slovakia"}
# for(i in 122:125){ssmBanks$country[i]="Finland"}
# #bank_name<-read.csv("/Users/ansikmahapatra/Google Dprive/thesis/9CSV/ssm_banks.csv", header = FALSE)
# 
# bank_name<- read.csv("C:/Users/Project/Desktop/ssm_banks.csv",  col_names = FALSE)
# for(i in 1:125){ssmBanks$bank[i]=as.character(bank_name[1]$X1[i])}
# for(i in 1:length(ssmBanks$bank)){ssmBanks$bank[i]<-trimws(ssmBanks$bank[i])}





rD<-rsDriver(port = 4567L, browser = c("firefox")) 
remDr<-rD[["client"]]
start_date<-as.Date("2005-01-01")
end_date<-start_date+7
today<-Sys.Date()
one<-"https://www.nexis.com/api/version1/au?la=en"
two<-"https://www.nexis.com/search/flap.do?flapID=home&random=0.7614609425383752"
#search<-ssmBanks$bank[13]
search<-c("deutschebank")
#search<-c("deutschebank","european AND central AND bank")
#for(element in 1:length(search)){
remDr$navigate(two)

remDr$setImplicitWaitTimeout(2000000000000) 
remDr$findElement('xpath',"/html/body/table/tbody/tr[2]/td/table/tbody/tr/td[2]/table/tbody/tr[4]/td[2]/table/tbody/tr/td/table/tbody/tr[1]/td/a[1]")$clickElement()
remDr$setImplicitWaitTimeout(2000000000000) 


remDr$findElement('css selector', "#secondarytabs .active+ li .null")$clickElement()
remDr$setImplicitWaitTimeout(200) 
searchbox=remDr$findElement('id',"searchTextAreaStyle")
searchbox$clickElement()
searchbox$sendKeysToElement(list(c("deutschebank")))
remDr$setImplicitWaitTimeout(200) 
id<-c("groupDuplicates","searchNaturalStyle")
remDr$setImplicitWaitTimeout(200) 
for(i in 1:length(id)){remDr$findElement('id',id[i])$clickElement()}
remDr$setImplicitWaitTimeout(200) 
remDr$findElement('id',"sourceSelectDDStyle")$clickElement()
remDr$findElement('xpath', "//*/option[@value = 
                  'F_GB00NBGenSrch.CS00900470;All English Language News']")$clickElement()
while(end_date<today){
  remDr$findElement('xpath', 
                    "//*/option[@value = 'from']")$clickElement() 
  remDr$findElement('id',"fromDate")$clickElement()
  for(t in 1:16){
    remDr$findElement('id',"fromDate")$sendKeysToElement(list(key = "delete"))
    remDr$findElement('id',"fromDate")$sendKeysToElement(list(key = "backspace"))
  }
  date_<-paste0(
    as.character(format(as.Date(start_date,format="%d/%m/%y"),"%d")),"/",
    as.character(format(as.Date(start_date,format="%d/%m/%y"),"%m")),"/","20",
    as.character(format(as.Date(start_date,format="%d/%m/%y"),"%y")))
  remDr$findElement('id',"fromDate")$sendKeysToElement(list(date_))
  remDr$findElement('id',"toDate")$clickElement()
  for(t in 1:16){
    remDr$findElement('id',"toDate")$sendKeysToElement(list(key = "delete"))
    remDr$findElement('id',"toDate")$sendKeysToElement(list(key = "backspace"))
  }
  date_<-paste0(
    as.character(format(as.Date(end_date,format="%d/%m/%y"),"%d")),"/",
    as.character(format(as.Date(end_date,format="%d/%m/%y"),"%m")),"/","20",
    as.character(format(as.Date(end_date,format="%d/%m/%y"),"%y")))
  remDr$findElement('id',"toDate")$sendKeysToElement(list(date_))
  remDr$findElement('id',"enableSearchImg")$clickElement()
  #  if(remDr$findElement('class',"zeroMsgHeader")$isElementDisplayed()[[1]]){
  #    remDr$navigate("https://www.nexis.com/search/editSearch.do?formBeanKey=68_T26308331190&BCT=G0")
  #    start_date<-end_date+1
  #    end_date<-start_date+7
  #    next
  #  }
  #  else if(remDr$findElement('id',"updateCountDiv")$isElementDisplayed()[[1]]){
  num_of_results<-remDr$findElement('id',"updateCountDiv")$getElementText()
  num_of_results<-gsub("\\(","",num_of_results[[1]])
  num_of_results<-gsub("\\)","",num_of_results[[1]])
  num_of_results<-as.numeric(num_of_results)
  num_of_loops<-as.integer(num_of_results/200)
  #download_excel()
  #remDr$findElement('id',"closeBtn")$clickElement()
  download_text()
  remDr$setImplicitWaitTimeout(2000000000000) 
  while(length(list.files(source_dir))==0){}
  remDr$findElement('id',"closeBtn")$clickElement()
  remDr$setImplicitWaitTimeout(20000000000000)
  remDr$findElement('link text',"Power Search")$clickElement()
  source_dir<-"C:/Users/Project/Downloads/"
  directory<-"C:/Users/Project/Desktop/Files/"
  list.files(directory)
  list.files(source_dir)
  remDr$setImplicitWaitTimeout(20000000000000)
  source_text<-dir(source_dir,pattern = ".TXT")
  #    source_CSV<-dir(source_dir,pattern = ".CSV")
  files.text<-dir(directory, pattern = ".TXT")
  
  #    files.CSV<-dir(directory, pattern = ".CSV")
  source_text_data<-paste0(source_dir,source_text[1])
  #    source_CSV_data<-paste0(source_dir,source_CSV[i])
  string_text<-paste0(search[element]," ",start_date," to ",end_date,".TXT")
  string_text<-paste0(directory,string_text)
  #    string_CSV<-paste0(ssmBanks$bank[element]," ",start_date," to ",end_date,".CSV")
  #    string_CSV<-paste0(directory,string_CSV)
  file.copy(source_text_data,string_text)
  #    file.copy(source_CSV_data[i],string_CSV)
  #    file.remove(source_CSV_data[i])
  file.remove(source_text_data[1])
  news$country[fill]<-ssmBanks$country[element]
  news$bank[fill]<-ssmBanks$bank[element]
  news$s_date[fill]<-start_date
  news$e_date[fill]<-end_date
  # news$body.text[fill]<-read.table(string_text,header = FALSE)
  fill<-fill+1
  start_date<-end_date+1
  end_date<-start_date+7
  remDr$setImplicitWaitTimeout(200000)
  #  }
}
remDr$setImplicitWaitTimeout(200000)
remDr$close
}
