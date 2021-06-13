# constraints: long only, min 5% and max 20% invested in each asset

library(quantmod)
library(PerformanceAnalytics)
library(PortfolioAnalytics)
library(forecast)

tickers <- c("FB", "AAPL", "AMZN", "NFLX", "GOOG", "SQ", "NVDA")

portfolioPrices <- NULL
for (ticker in tickers) {
 portfolioPrices <- cbind(portfolioPrices,
                          getSymbols.yahoo(ticker, from = "2016-09-01", periodicity = "daily", auto.assign = FALSE)[,4])
}

portfolioReturns <- na.omit(ROC(portfolioPrices))

# a portfolio object that will hold the portfolio's constraints and objectives
portf <- portfolio.spec(colnames(portfolioReturns))