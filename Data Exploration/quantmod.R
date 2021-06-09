# Package for quant finance, used to get data into our R environment
install.packages("quantmod")
library(quantmod)
# Package for visualizing performance
install.packages("PerformanceAnalytics")
library(PerformanceAnalytics)

# Set up max date
date <- "2016-9-1"

# loading some data for AAPL
aapl <- getSymbols.yahoo("AAPL", from = date, auto.assign = F)

# just get the adjusted close data fro AAPL
aaplClose <- getSymbols.yahoo("AAPL", from = date, auto.assign = F)[, 6]

# calculate AAPL's returns
aaplReturns <- na.omit(dailyReturn(aaplClose, type = "log"))

# chart AAPL's returns
chartSeries(aapl)