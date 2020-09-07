#Ask user for a search querry 
#Ask user for constraints such as: number of articles displayed
#Get the search results with constraints that are provided by the user
#Ask user for providing range of search results to download in a local folder in the format specified (mainly text or json)

#library(httr)
#library(RCurl)
#library(XML)
#library(rvest)

library(RSelenium)
require(RSelenium)

rD<-rsDriver(port = 4567L, browser = c("chrome")) #change to iexplorer, firefox, phantomjs
remDr<-rD[["client"]]
one<-"https://www.nexis.com/api/version1/au?la=en"

remDr$navigate(one)
remDr$findElement('xpath',"/html/body/table/tbody/tr[2]/td/table/tbody/tr/td[2]/table/tbody/tr[4]/td[2]/table/tbody/tr/td/table/tbody/tr[1]/td/a[1]")$clickElement()
remDr$findElement('id',"searchTermsTextAreaInput")$clickElement()
remDr$sendKeysToActiveElement(list("deutschebank")) #Enter string to saerch
remDr$findElement('id',"ie_search")$clickElement() #Open customized search toolbar
remDr$findElement('id',"reSearchSelector")$clickElement() #Date Selector
remDr$findElement('xpath', "//*/option[@value = '-20|years']")$clickElement() #-20years
remDr$findElement('id',"easySearchNewsChkBoxLabel0")$clickElement() #News
remDr$findElement('id',"easySearchNewsChkBoxLabel1")$clickElement() #Companies
remDr$findElement('id',"easySearchNewsChkBoxLabel2")$clickElement() #Market Insight
remDr$findElement('id',"groupDuplicates")$clickElement() #Group Dublicates
remDr$findElement('id',"searchFilterBtn")$clickElement() #Search button on customizer toolbar
#remDr$findElement('id',"searchBtn")$clickElement() #Search button in case you haven't customized search
remDr$findElement('id',"delivery_DnldRender")$clickElement() #Download button on search result page

remDr$setImplicitWaitTimeout(2)

remDr$findElement('id',"sel")$clickElement() #Select Range of Documents
remDr$findElement('id',"rangetextbox")$clickElement() #Select Range of Documents
remDr$sendKeysToActiveElement(list("1-200")) #1 to 500 Documents 
remDr$findElement('id',"delView")$clickElement() #Select DocumentView
remDr$findElement('xpath', "//*/option[@value = 'SEGMTS']")$clickElement() #Custom

remDr$setImplicitWaitTimeout(1)

remDr$findElement('id',"modifyLink")$clickElement()
remDr$setImplicitWaitTimeout(1)
remDr$findElement('id',"chk1")$clickElement() #Abstract
#remDr$findElement('id',"chk2")$clickElement() #Advanced Date
#remDr$findElement('id',"chk3")$clickElement() #Affiliation
#remDr$findElement('id',"chk4")$clickElement() #Agenda
#remDr$findElement('id',"chk5")$clickElement() #Anchors
remDr$findElement('id',"chk6")$clickElement() #Bibliography
remDr$findElement('id',"chk7")$clickElement() #Body
remDr$findElement('id',"chk8")$clickElement() #City
remDr$findElement('id',"chk9")$clickElement() #Company
remDr$findElement('id',"chk10")$clickElement() #Company-Numebr
#remDr$findElement('id',"chk11")$clickElement() #Contact
remDr$findElement('id',"chk12")$clickElement() #Country
remDr$findElement('id',"chk13")$clickElement() #Dateline
#remDr$findElement('id',"chk14")$clickElement() #Editor Note
#remDr$findElement('id',"chk15")$clickElement() #Enhancement
#remDr$findElement('id',"chk16")$clickElement() #Extracted terms
#remDr$findElement('id',"chk17")$clickElement() #Geographic
#remDr$findElement('id',"chk18")$clickElement() #Graphic
#remDr$findElement('id',"chk19")$clickElement() #Guests
#remDr$findElement('id',"chk20")$clickElement() #Highlights
remDr$findElement('id',"chk21")$clickElement() #HLead
remDr$findElement('id',"chk22")$clickElement() #Indices
remDr$findElement('id',"chk23")$clickElement() #Industry
remDr$findElement('id',"chk24")$clickElement() #Journal Code
remDr$findElement('id',"chk25")$clickElement() #Keyword
#remDr$findElement('id',"chk26")$clickElement() #Kr-Acc-No
remDr$findElement('id',"chk27")$clickElement() #Language
#remDr$findElement('id',"chk28")$clickElement() #Language-Spoken
#remDr$findElement('id',"chk29")$clickElement() #Lead
#remDr$findElement('id',"chk30")$clickElement() #Legislation
#remDr$findElement('id',"chk31")$clickElement() #Market
#remDr$findElement('id',"chk32")$clickElement() #Memo
#remDr$findElement('id',"chk33")$clickElement() #Orig-Language
remDr$findElement('id',"chk35")$clickElement() #Person
#remDr$findElement('id',"chk36")$clickElement() #Product
remDr$findElement('id',"chk37")$clickElement() #Pub-Type
remDr$findElement('id',"chk38")$clickElement() #Reporters
#remDr$findElement('id',"chk39")$clickElement() #Series
#remDr$findElement('id',"chk40")$clickElement() #Sicovam-Code
remDr$findElement('id',"chk41")$clickElement() #Source
#remDr$findElement('id',"chk42")$clickElement() #State
#remDr$findElement('id',"chk43")$clickElement() #Stock-Code
#remDr$findElement('id',"chk44")$clickElement() #Subcommittee
remDr$findElement('id',"chk45")$clickElement() #Subject
remDr$findElement('id',"chk46")$clickElement() #Terms
#remDr$findElement('id',"chk47")$clickElement() #Testimony-BY
remDr$findElement('id',"chk48")$clickElement() #Text
remDr$findElement('id',"chk49")$clickElement() #Ticker
#remDr$findElement('id',"chk34")$clickElement() #Participants
remDr$findElement('class',"okSubmitBtn")$clickElement()

remDr$setImplicitWaitTimeout(2)
remDr$findElement('link text',"Page Options")$clickElement() #Goes to Page Option
remDr$setImplicitWaitTimeout(1)
remDr$findElement('id',"inclDocs")$clickElement() #List of Included Documents
remDr$setImplicitWaitTimeout(2)
remDr$findElement('id',"endpg")$clickElement() #End Page
remDr$setImplicitWaitTimeout(2)
remDr$findElement('id',"docnewpg")$clickElement() #Each Document on a New Page
remDr$setImplicitWaitTimeout(2)
remDr$findElement('link text',"Format Options")$clickElement() #Goes to Page Option
remDr$findElement('id',"delFmt")$clickElement() #Select Format
remDr$findElement('xpath', "//*/option[@value = 'QDS_EF_GENERICTYPE']")$clickElement() #Text Format
remDr$findElement('class',"deliverBtn")$clickElement() #Final Download


