library(dplyr)

base_folder<-"~/Desktop/"
token<-"civic"
token_df<-read.csv(paste0(base_folder,token,".csv"))

token_df$Dates <- lapply(token_df$Date, function(x){as.Date(as.character(x),format="")})

token_df$Dates<-as.Date(as.character(token_df$Date),format="")

for (i in 1:length(token_df$Date)) {
  token_df$Dates[i]<-as.Date(as.character(token_df$Date[i]),format="")
}

token_df$Date<-NULL
