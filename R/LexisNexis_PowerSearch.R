library(RSelenium)
require(RSelenium)
library(XML)

download_excel<-function(){
  remDr$findElement('id',"delivery_DnldRender")$clickElement() 
  remDr$findElement('link text',"Format Options")$clickElement() 
  remDr$findElement('xpath',"//*/option[@value = 'QDS_EF_CSV']")$clickElement() 
  remDr$findElement('link text',"Modify...")$clickElement() 
  remDr$findElement('link text',"Select All")$clickElement() 
  remDr$findElement('class',"okSubmitBtn")$clickElement() 
  remDr$findElement('class',"deliverBtn")$clickElement() 
}
download_text<-function(){
  remDr$findElement('id',"delivery_DnldRender")$clickElement() 
  remDr$setImplicitWaitTimeout(2000000)
  id<-c("chk1","chk6","chk7","chk8","chk9","chk10","chk12","chk13",
        "chk21","chk22","chk23","chk24","chk25","chk27","chk35","chk37",
        "chk38","chk41","chk45","chk46","chk48","chk49")
  remDr$setImplicitWaitTimeout(200000)
  remDr$findElement('link text',"Format Options")$clickElement() 
  remDr$findElement('xpath',"//*/option[@value = 'QDS_EF_GENERICTYPE']")$clickElement() 
  remDr$findElement('xpath',
    "//*[contains(concat( \" \", @class, \" \" ), concat( \" \", \"deliverBtn\", \" \" ))]//img")$clickElement() 
}

rD<-rsDriver(port = 4567L, browser = c("chrome")) 
remDr<-rD[["client"]]
one<-"https://www.nexis.com/api/version1/au?la=en"
search<-c("dz bank","deutschebank","wgz bank","commerzbank","bayernlb",
          "hsh nordbank","lbbw","helaba","nordlb")
folders<-c("dzbank","deutschebank","wgzbank","commerzbank","bayernlb","hshnordbank"
           ,"landesbankbaden","landesbankhessen","norddeutschelandesbank")
search<-c("commerzbank")
folders<-c("commerzbank")
for(element in 1:length(search)){
  start_date<-as.Date("2014-06-27")
  end_date<-start_date+7
  today<-Sys.Date()
  remDr$navigate(one)
  remDr$findElement('xpath',"/html/body/table/tbody/tr[2]/td/table/tbody/
                    tr/td[2]/table/tbody/tr[4]/td[2]/table/tbody/tr/td/table/tbody/tr[1]/
                    td/a[1]")$clickElement()
  remDr$findElement('css selector',
                    "#secondarytabs .active+ li .null")$clickElement()
  remDr$sendKeysToActiveElement(list(search[element]))
  id<-c("groupDuplicates","searchNaturalStyle")
  for(i in 1:length(id)){remDr$findElement('id',id[i])$clickElement()}
  remDr$findElement('id',"sourceSelectDDStyle")$clickElement()
  remDr$findElement('xpath', "//*/option[@value = 
                    'F_GB00NBGenSrch.CS00900470;All English Language News']")$clickElement() 
  while(end_date<today){
    remDr$findElement('xpath', 
                      "//*/option[@value = 'from']")$clickElement() 
    remDr$findElement('id',"fromDate")$clickElement()
    for(t in 1:6){
      remDr$sendKeysToActiveElement(list(key = "delete"))
      remDr$sendKeysToActiveElement(list(key = "backspace"))
    }
    date_<-paste0(
      as.character(format(as.Date(start_date,format="%d/%m/%y"),"%d")),"/",
      as.character(format(as.Date(start_date,format="%d/%m/%y"),"%m")),"/","20",
      as.character(format(as.Date(start_date,format="%d/%m/%y"),"%y")))
    remDr$sendKeysToActiveElement(list(date_))
    remDr$findElement('id',"toDate")$clickElement()
    for(t in 1:6){
      remDr$sendKeysToActiveElement(list(key = "delete"))
      remDr$sendKeysToActiveElement(list(key = "backspace"))
    }
    date_<-paste0(
      as.character(format(as.Date(end_date,format="%d/%m/%y"),"%d")),"/",
      as.character(format(as.Date(end_date,format="%d/%m/%y"),"%m")),"/","20",
      as.character(format(as.Date(end_date,format="%d/%m/%y"),"%y")))
    remDr$sendKeysToActiveElement(list(date_))
    remDr$findElement('id',"enableSearchImg")$clickElement()
      num_of_results<-remDr$findElement('id',"updateCountDiv")$getElementText()
      num_of_results<-gsub("\\(","",num_of_results[[1]])
      num_of_results<-gsub("\\)","",num_of_results[[1]])
      num_of_results<-as.numeric(num_of_results)
      num_of_loops<-as.integer(num_of_results/200)
      download_text()
      source_dir<-"~/Downloads/"
      directory<-paste0("~/Desktop/7Text/",folders[element],"/")
      while(length(list.files(source_dir))==0){}
      remDr$findElement('id',"closeBtn")$clickElement()
      Sys.sleep(15)
      source_text<-dir(source_dir,pattern = ".TXT")
      files.text<-dir(directory, pattern = ".TXT")
      source_text_data<-paste0(source_dir,source_text[1])
      string_text<-paste0(search[element]," ",start_date," to ",end_date,".TXT")
      string_text<-paste0(directory,string_text)
      file.copy(source_text_data,string_text)
      file.remove(source_text_data[1])
      start_date<-end_date+1
      end_date<-start_date+7
      remDr$findElement('link text',"Power Search")$clickElement()
  }
  remDr$close
}
