library(RSelenium)
require(RSelenium)
library(XML)

source_dir<-"C:/Users/sadoghi_PC/Downloads/"
directory<-"D:/Projects/Exchange/news/"

download_excel<-function(){
  remDr$findElement('id',"delivery_DnldRender")$clickElement() 
  Sys.sleep(10)
  remDr$findElement('link text',"Format Options")$clickElement() 
  Sys.sleep(15)
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
  remDr$findElement('id',"delSelection")$clickElement() 
  
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

#####################################################################################

start_date<-as.Date("1980-01-01")
end_date<-start_date+7
today<-Sys.Date()
searchterm<-c("search_term")



while(end_date<today){
  remDr$navigate(one)
  #Sys.sleep(5)
  #remDr$findElement('css selector', "#secondarytabs .active+ li .null")$clickElement()
  ## change
  searchbox=remDr$findElement('id',"searchTextAreaStyle")
  searchbox$clickElement()
  searchbox$sendKeysToElement(list(searchterm))
  
  remDr$findElement('id',"fromDate")$clickElement()
  # Sys.sleep(1)
  for(t in 1:16){
    remDr$findElement('id',"fromDate")$sendKeysToElement(list(key = "delete"))
    remDr$findElement('id',"fromDate")$sendKeysToElement(list(key = "backspace"))
  }
  # Sys.sleep(1)
  date_<-paste0(
    as.character(format(as.Date(start_date,format="%d/%m/%y"),"%d")),"/",
    as.character(format(as.Date(start_date,format="%d/%m/%y"),"%m")),"/","19",
    as.character(format(as.Date(start_date,format="%d/%m/%y"),"%y")))
  # Sys.sleep(1)
  remDr$findElement('id',"fromDate")$sendKeysToElement(list(date_))
  # Sys.sleep(1)
  remDr$findElement('id',"toDate")$clickElement()
  # Sys.sleep(1)
  for(t in 1:16){
    remDr$findElement('id',"toDate")$sendKeysToElement(list(key = "delete"))
    remDr$findElement('id',"toDate")$sendKeysToElement(list(key = "backspace"))
  }
  # Sys.sleep(1)
  date_<-paste0(
    as.character(format(as.Date(end_date,format="%d/%m/%y"),"%d")),"/",
    as.character(format(as.Date(end_date,format="%d/%m/%y"),"%m")),"/","19",
    as.character(format(as.Date(end_date,format="%d/%m/%y"),"%y")))
  # Sys.sleep(1)
  remDr$findElement('id',"toDate")$sendKeysToElement(list(date_))
  #Sys.sleep(5)
  #remDr$findElement('xpath', "//*/option[@value = 'F_GB00NBGenSrch.CS00900470;All English Language News']")$clickElement()
  #Sys.sleep(20)
  remDr$findElement('id',"enableSearchImg")$clickElement()
  #Sys.sleep(5)
  
  pagetitle<-remDr$getTitle()
  pagetitle<-substr(pagetitle,9,9)
  if (pagetitle=="R" ){
    
    results<-remDr$findElement('id',"results")$getElementText()
    result_test<-substr(results[[1]],1,1)
    if (result_test=="s" ){
      # Sys.sleep(1)
      resultsinfo<-remDr$findElement('id',"searchinfo")$getElementText()
      #  Sys.sleep(3)
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
        Sys.sleep(1)
        #########################
        #download_text()
        remDr$findElement('id',"delivery_DnldRender")$clickElement() 
        remDr$findElement('id',"delSelection")$clickElement() 
        Sys.sleep(1)
        
        remDr$findElement('link text',"Download Options")$clickElement() 
        # Sys.sleep(10)
        remDr$findElement('xpath', "//*/option[@value = 'SEGMTS']")$clickElement() 
        Sys.sleep(1)
        remDr$findElement('id',"modifyLink")$clickElement()
        Sys.sleep(1)
        remDr$findElement('class',"selectAll")$clickElement()
        
        Sys.sleep(1)
        
        remDr$findElement('class',"okSubmitBtn")$clickElement()
        
        Sys.sleep(1)
        remDr$findElement('xpath',"//*[contains(concat( \" \", @class, \" \" ), concat( \" \", \"deliverBtn\", \" \" ))]//img")$clickElement() 
        
        #########################
        Sys.sleep(1)
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


