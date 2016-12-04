#-----------------------------------------------------------------------------------------------------
# Title: main.reversals
# Description: Compute reversal points for detecting channel boundaries and entry/exit points
# Author: David Greatrex
# Date: 30/11/2016                                                                          
# Modifications:
#-----------------------------------------------------------------------------------------------------

#-------------------------------------
# user defined variables
#-------------------------------------
wd = "/Users/dcg/_gitProjects/Public/finance_reversals"
data_provider <- "yahoo" 
start_month <- "2015-01"
row_lookback <- 3

#-------------------------------------
# load functions
#-------------------------------------
source(paste(wd,'functions/reversals.R',sep="/")) # load function script

#-------------------------------------
# load tickers
#-------------------------------------
markets <- c('ftse_100','ftse_250')
market <- read.table(paste(wd,'data',paste0(markets[1],'.txt'),sep="/"),sep="\t", header=FALSE)
tickers <- market[,1]

#-------------------------------------
# get reversals
#-------------------------------------
for (i in 1:length(tickers)){
  
  # load and subset data
  s <- toString(tickers[i])
  dat <- return_data(ticker = s, src = data_provider, start = start_month)
  if(dat$error){
    next
  }

  # compute reversals
  high <- reversals(data = dat$d[,2], lookback = row_lookback, ticker = s, is_High = 1)
  low <- reversals(data = dat$d[,3], lookback = row_lookback, ticker = s, is_High = 0)
  
  # plot reversals
  chartSeries(dat$d, name = s, type = "candlesticks", 
              TA="
              addPoints(y = high$y, x = high$x, col = 'red');
              addPoints(y = low$y, x = low$x, col = 'blue');
              addVo()")
  
  # remove variables
  rm(s, dat, high, low)
}