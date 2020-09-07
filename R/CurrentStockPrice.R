#Recover the old file

library(httr,RCurlwq)
library(rvest)

#Uses Google Finance
URL<-"https://finance.google.com/finance?q="
tickers<-c("NASDAQ:AAPL",
           "NSE:INFY",
           "NYSE:GOOGL")
booked_prices<-c(100.00,
		            900.25,
		            1000.00)
quote_price<-return<-c()
for(i in 1:length(tickers)){
  quote_price[i]<-html_text(html_nodes(read_html(paste0(URL,gsub(":","%3A",tickers[i]))),".pr span"))
  return[i]<-paste0(as.character((as.double(gsub(",","",quote_price[i]))-booked_prices[i])*100/booked_prices[i]),"%")
}
Stock.Prices<-data.frame(tickers,quote_price,booked_prices,return)
Stock.Prices