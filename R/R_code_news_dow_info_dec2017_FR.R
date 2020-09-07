#New Way to Download things off LexisNexis.

library(RSelenium)
require(RSelenium)
library(XML)
#firefox
rD<-rsDriver(port = 4567L, browser = c("chrome")) 
remDr<-rD[["client"]]
one<-"https://www.nexis.com/search/flap.do?flapID=home&random=0.16324389901773118"


#####################################################
#folders<-c("LexisNexis_New")
#source_dir<-"~/Downloads/"
#directory<-paste0("~/OneDrive/",folders[1],"/")
##################################################

#start_date<-"2017-01-01"
#end_date<-Sys.Date()



#searchterm<-c("bitcoin")
############################
start_date<-as.Date("2006-03-01")
end_date<-start_date+30
today<-Sys.Date()
#searchterm<-c("deflation W/p ECB")

##########################


searchterm_total<-c("Confédération Nationale du Crédit Mutuel", "La Banque Postale","Agence Française de Développement","Bpifrance S.A. Banque Publique d'Investissement","Caisse de Refinancement de lHabitat","HSBC France","Groupe BPCE","Groupe GCA","Société générale","BNP Paribas")

###############################

for (ii in length(searchterm_total))
{
  searchterm<-searchterm_total[ii]
  while(end_date<today){
    remDr$navigate(one)
    searchbox=remDr$findElement('id',"searchTextAreaStyle")
    searchbox$clickElement()
    searchbox$sendKeysToElement(list(searchterm))
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
    
    
    pagetitle<-remDr$getTitle()
    pagetitle<-substr(pagetitle,9,9)
    
    
    if (pagetitle=="R" ){
      
      results<-remDr$findElement('id',"results")$getElementText()
      result_test<-substr(results[[1]],1,1)
      Sys.sleep(1)
      print(result_test)
      if (result_test!="N" ){
        Sys.sleep(1)
        resultsinfo<-remDr$findElement('id',"searchinfo")$getElementText()
        nserchsize<-nchar(searchterm)
        searchsize<-substr(resultsinfo,nserchsize+18,nserchsize+18)
        
        if (searchsize>0){
          num_of_results<-remDr$findElement('id',"updateCountDiv")$getElementText()
          num_of_results<-gsub("\\(","",num_of_results[[1]])
          num_of_results<-gsub("\\)","",num_of_results[[1]])
          num_of_results<-as.numeric(num_of_results)
          
          num_of_results<-as.numeric(num_of_results)
          ##  decet_result_No()
          if (num_of_results<201) 
          {
            
            download_text2()
            Message_text<-"Your documents are being processed. Please wait a moment."
            #text<-remDr$findElement('id',"process-generic-deliv-dialogbox")$getElementText()
            test<-FALSE
            
            while ((test!=TRUE))
            {
              options(error = expression(NULL))
              try(trytext<-remDr$findElement('id',"process-generic-deliv-dialogbox")$getElementText())
              if (trytext!=Message_text) {test=TRUE }
            }
            Sys.sleep(3)
            remDr$findElement('id',"closeBtn")$clickElement()
            # #########################
            # Sys.sleep(20)
            # if(num_of_results>50) {Sys.sleep(10)}
            # if(num_of_results>100){Sys.sleep(10)}
            # if(num_of_results>150)  {Sys.sleep(10)}
            
          }  else {
            
            ############# if N > 200 ##########
            ############## Detect No downloads
            end<-num_of_results
            start<-num_of_results-1
            remDr$findElement('id',"delivery_DnldRender")$clickElement() 
            # remDr$findElement('id',"delSelection")$clickElement() 
            Sys.sleep(2)
            remDr$findElement('link text',"Download Options")$clickElement() 
            
            remDr$findElement('id',"sel")$clickElement()
            #remDr$sendKeysToActiveElement(c(end))
            remDr$sendKeysToActiveElement(c(start,"-",end))
            
            remDr$findElement('xpath',"//*[contains(concat( \" \", @class, \" \" ), concat( \" \", \"deliverBtn\", \" \" ))]//img")$clickElement() 
            Message_text<-"Your documents are being processed. Please wait a moment."
            #text<-remDr$findElement('id',"process-generic-deliv-dialogbox")$getElementText()
            test<-FALSE
            
            while ((test!=TRUE))
            {
              options(error = expression(NULL))
              try(trytext<-remDr$findElement('id',"process-generic-deliv-dialogbox")$getElementText())
              if (trytext!=Message_text) {test=TRUE }
            }
            Sys.sleep(2)
            
            
            txt_error <-remDr$findElement('id',"errorAlign")$getElementText()
            Correc_NO<-strsplit(as.character(txt_error)," ")[[1]][10]
            Correc_NO<-gsub(",","",as.character(Correc_NO))
            Correc_NO<-gsub(",","",as.character(Correc_NO))
            num_of_results<-strtrim(Correc_NO, (nchar(Correc_NO)-1))
            # 
            Sys.sleep(1)
            ########################
            test<-FALSE
            
            while ((test!=TRUE))
            {
              options(error = expression(NULL))
              try(test<- remDr$findElement('xpath',"//*[contains(concat( \" \", @class, \" \" ), concat( \" \", \"cancelBtn\", \" \" ))]//img")$getStatus()[1])
            }
            
            
            remDr$findElement('xpath',"//*[contains(concat( \" \", @class, \" \" ), concat( \" \", \"cancelBtn\", \" \" ))]//img")$clickElement() 
            
            ####################################################################
            
            
            ##########
            Sys.sleep(1)
            num_of_results<-as.numeric(num_of_results)
            remainder<-num_of_results%%200
            #if (num_of_results>200) {}
            ###########################
           # num_of_loops<-as.integer(num_of_results/200)+1
            num_of_loops<-as.integer(ceiling(num_of_results/200))
            Sys.sleep(1)
            #########################
            #  download_text()
            #download_info()
            ############### detect the correct number#########
            start<-1
            end<-num_of_results
            if (num_of_results>200) {end<-200}
            
            ################################################
            
            for(i in 1:num_of_loops){
              #download_text()
              #Sys.sleep(30)
              ############ test ##############
              
              download_text()
              Message_text<-"Your documents are being processed. Please wait a moment."
              #text<-remDr$findElement('id',"process-generic-deliv-dialogbox")$getElementText()
              test<-FALSE
              
              while ((test!=TRUE))
              {
                options(error = expression(NULL))
                try(trytext<-remDr$findElement('id',"process-generic-deliv-dialogbox")$getElementText())
                if (trytext!=Message_text) {test=TRUE }
              }
              
              #####################################
              ###################
              Sys.sleep(3)
              remDr$findElement('id',"closeBtn")$clickElement()
              # #########################
              # Sys.sleep(20)
              # if(num_of_results>50) {Sys.sleep(10)}
              # if(num_of_results>100){Sys.sleep(10)}
              # if(num_of_results>150)  {Sys.sleep(10)}
              
              
              ######
              #  Sys.sleep(5)
              # source_text<-dir(source_dir,pattern = ".TXT")
              # files.text<-dir(directory, pattern = ".TXT")
              # source_text_data<-paste0(source_dir,source_text[1])
              # string_text<-paste0("News_",as.character(start_date),"_to_",as.character(end_date),"_",as.character(i),".TXT")
              # string_text<-paste0(directory,string_text)
              # file.copy(source_text_data,string_text)
              # file.remove(source_text_data[1])
              # 
              #############################################
              # download_info()
              #  Sys.sleep(1)
              #  if(num_of_results>50) {Sys.sleep(10)}
              #  if(num_of_results>100){Sys.sleep(10)}
              #  if(num_of_results>150)  {Sys.sleep(10)}
              #  
              # # while(length(list.files(source_dir))==0){}
              #  
              #  source_text<-dir(source_dir,pattern = ".TXT")
              #  files.text<-dir(directory, pattern = ".TXT")
              #  source_text_data<-paste0(source_dir,source_text[1])
              #  string_text<-paste0("InfoNews_",as.character(start_date),"_to_",as.character(end_date),"_",as.character(i),".TXT")
              #  string_text<-paste0(directory,string_text)
              #  file.copy(source_text_data,string_text)
              #  file.remove(source_text_data[1])
              
              ######################################################
              
              start<-(i*200)+1
              end<-(i+1)*200
              if(i==num_of_loops-1){end<-(i*200)+remainder}
            }
            #########################
            
          }
          
          
        }
      }
    }   
    Sys.sleep(1)
    start_date<-end_date+1
    end_date<-start_date+30
    
  }
  from.dir <- "C:/Users/sadoghi_PC/Desktop/News_data/SSM_FR"
to.dir <- paste("C:/Users/sadoghi_PC/Desktop/SSM_FR/",ii,sep = "")
files <- list.files(path = from.dir, full.names = TRUE, recursive = TRUE)
for (f in files) file.copy(from = f, to = to.dir)
file.remove(files)
}






######################################################################
################################# New ################################
######################################################################
download_text<-function(){
  remDr$findElement('id',"delivery_DnldRender")$clickElement() 
  #remDr$findElement('id',"delSelection")$clickElement() 
  Sys.sleep(1)
  remDr$findElement('link text',"Download Options")$clickElement() 
  remDr$findElement('id',"sel")$clickElement()
#  remDr$findElement('id',"selDocs")$clickElement()
  remDr$sendKeysToActiveElement(c(start,"-",end))
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
  Sys.sleep(1)
  
  #remDr$findElement('link text',"Format Options")$clickElement() 
  #remDr$findElement('xpath',"//*/option[@value = 'QDS_EF_GENERICTYPE']")$clickElement() 
  #remDr$findElement('xpath',"//*[contains(concat( \" \", @class, \" \" ), concat( \" \", \"deliverBtn\", \" \" ))]//img")$clickElement() 
}
#############################################
download_text2<-function(){
  remDr$findElement('id',"delivery_DnldRender")$clickElement() 
  #remDr$findElement('id',"delSelection")$clickElement() 
  Sys.sleep(1)
  remDr$findElement('link text',"Download Options")$clickElement() 
 # remDr$findElement('id',"sel")$clickElement()
  #  remDr$findElement('id',"selDocs")$clickElement()
 # remDr$sendKeysToActiveElement(c(start,"-",end))
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
  Sys.sleep(1)
  
  #remDr$findElement('link text',"Format Options")$clickElement() 
  #remDr$findElement('xpath',"//*/option[@value = 'QDS_EF_GENERICTYPE']")$clickElement() 
  #remDr$findElement('xpath',"//*[contains(concat( \" \", @class, \" \" ), concat( \" \", \"deliverBtn\", \" \" ))]//img")$clickElement() 
}
##################################




decet_result_No<-function(){
  end<-num_of_results
  start<-num_of_results-1
  remDr$findElement('id',"delivery_DnldRender")$clickElement() 
 # remDr$findElement('id',"delSelection")$clickElement() 
  Sys.sleep(1)
  remDr$findElement('link text',"Download Options")$clickElement() 

    remDr$findElement('id',"sel")$clickElement()
  #remDr$sendKeysToActiveElement(c(end))
  remDr$sendKeysToActiveElement(c(start,"-",end))

      remDr$findElement('xpath',"//*[contains(concat( \" \", @class, \" \" ), concat( \" \", \"deliverBtn\", \" \" ))]//img")$clickElement() 
      Message_text<-"Your documents are being processed. Please wait a moment."
      #text<-remDr$findElement('id',"process-generic-deliv-dialogbox")$getElementText()
      test<-FALSE
      
      while ((test!=TRUE))
      {
        options(error = expression(NULL))
        try(trytext<-remDr$findElement('id',"process-generic-deliv-dialogbox")$getElementText())
        if (trytext!=Message_text) {test=TRUE }
      }
      Sys.sleep(2)
   txt_error <-remDr$findElement('id',"errorAlign")$getElementText()
   Correc_NO<-strsplit(as.character(txt_error)," ")[[1]][10]
   Correc_NO<-gsub(",","",as.character(Correc_NO))
   Correc_NO<-gsub(",","",as.character(Correc_NO))
   num_of_results<-strtrim(Correc_NO, (nchar(Correc_NO)-1))
   Sys.sleep(5)
   
   remDr$findElement('xpath',"//*[contains(concat( \" \", @class, \" \" ), concat( \" \", \"cancelBtn\", \" \" ))]//img")$clickElement() 
   Sys.sleep(1)
   num_of_results<-as.numeric(num_of_results)
   
}



##########################################  
download_info<-function(){

  remDr$findElement('id',"delivery_refworks")$clickElement() 
    windows<-remDr$getWindowHandles()
  remDr$switchToWindow(windows[[2]])

 remDr$findElement('name',"selDocs")$clickElement()
 ###########################
 webElem <-remDr$findElement('id',"delivery_refworks")
 remDr$mouseMoveToLocation(webElement = webElem) # move to the required element
 remDr$click(2) # right mouse button click 
 webElem$sendKeysToElement(list(key = "control", "t")) # open a new tab by sending ctrl+t
 
 
 
 ######################
 
 
  remDr$sendKeysToActiveElement(c(start,"-",end))  
    remDr$findElement('id',"dnldBiblio")$clickElement()
    Sys.sleep(1)
  remDr$findElement('id',"img_orig_bottom")$clickElement()
  Sys.sleep(2)
  remDr$closeWindow()
  Sys.sleep(2)
  remDr$switchToWindow(windows[[1]])
} 
####################################
currWin <- remDr$getCurrentWindowHandle()
allWins <- unlist(remDr$getWindowHandles())
otherWindow <- allWins[!allWins %in% currWin[[1]]]
remDr$switchToWindow(otherWindow)
remDr$getTitle()


webElem <- remDr$findElements("css", "iframe")
remDr$switchToFrame(otherWindow)

    ##############################################
      remDr$findElement('id',"selDocs")$clickElement()

  
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
  Sys.sleep(1)
  remDr$findElement('link text',"Format Options")$clickElement() 
  remDr$findElement('xpath',"//*/option[@value = 'QDS_EF_GENERICTYPE']")$clickElement() 
  
}




#############################################


