# sentiment analysis for crypto currency trend

library(dplyr)

# I need selenium and web scripping tools which for some reason don't seem to function in R
# I need data analytics tools, like moving average, grouping values with a given timeframe.

ETHUSD <- read.csv("~/Google Drive/Fincancial Data/ETH-USD.csv")
plot(ETHUSD$Close,ETHUSD$Date)
plot(ETHUSD$Close)

BTCUSD <- read.csv("~/Google Drive/Fincancial Data/BTC-USD.csv")
plot(BTCUSD$Close)

XRPUSD <- read.csv("~/Google Drive/Fincancial Data/XRP-USD.csv")
plot(XRPUSD$Close)
