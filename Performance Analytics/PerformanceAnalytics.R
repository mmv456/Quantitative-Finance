# Creating a stock portfolio
library(quantmod) # for data
library(PerformanceAnalytics) # for generating performance analytics

# creating a vector of tickers and weighting them equally
tickers <- c("FB", "AAPL", "AMZN", "NFLX")
weights <- c(.25, .25, .25, .25)

# get the closing price data for each of the tickers in the portfolio
portfolioPrices <- NULL

for (ticker in tickers) {
  portfolioPrices <- cbind(portfolioPrices, 
                           getSymbols.yahoo(ticker, from = "2016-09-01", periodicity = "daily", auto.assign = FALSE)[,4])
}
colSums(is.na(portfolioPrices)) # checks the total na values for each column, a quick data quality check

# get data for a benchmark portfolio, the SP500
benchmarkPrices <- getSymbols.yahoo("SPY", from = "2016-09-01", periodicity = "daily", auto.assign = FALSE)[,4]
colSums(is.na(benchmarkPrices)) # do another data quality check

# --Now perform calculations--

# calculate the daily returns for the benchmark
benchmarkReturns <- na.omit(ROC(benchmarkPrices, type = "discrete"))

# calculate the daily returns for the portfolio
dailyReturns <- na.omit(ROC(portfolioPrices, type = "discrete"))
# calculate the overall portfolio returns using the equal weighting
portfolioReturn <- Return.portfolio(dailyReturns, weights = weights)



# --Now perform analytics on my portfolio--

# Plotting the individual securities' performace
plot(portfolioPrices, legend = tickers)

# plotting the performance of the portfolio returns
chart.CumReturns(portfolioReturn)
charts.PerformanceSummary(portfolioReturn) # this chart shows the combined wealth index, bars for per-period performance, and underwater drawdown

# calculating beta, using 3.5% as risk-free rate and 252 trading days in year
CAPM.beta(portfolioReturn, benchmarkReturns, 0.035/252)
CAPM.beta.bear(portfolioReturn, benchmarkReturns, 0.035/252) # calculation on negative market returns
CAPM.beta.bull(portfolioReturn, benchmarkReturns, 0.035/252) # calculation on positive market returns

# calculating Jensen's alpha
CAPM.jensenAlpha(portfolioReturn, benchmarkReturns, 0.35/252)

# calculating Sharpe ratio
SharpeRatio(portfolioReturn, 0.035/252)

# creating a table showing returns
table.AnnualizedReturns(portfolioReturn, Rf = 0.035/252, geometric = TRUE)