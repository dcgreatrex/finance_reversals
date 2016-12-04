#-----------------------------------------------------------------------------------------------------
# Title: reversal functions
# Author: David Greatrex
# Date: 30/11/2016                                                                          
# Modifications:
#-----------------------------------------------------------------------------------------------------

#----------------------------
# Import libraries
#----------------------------
library('TTR')
library('quantmod')

#=================================================================================
# ListSegmentationFunctions
# Print a list of all functions within this file to screen
#=================================================================================
ListSegmentationFunctions <- function(){
   print("1) ListSegmentationFnctions: List names of all UKMAT functions",quote=FALSE)
   print("2) return_data: Call ticker data using quantmod package",quote=FALSE)
   print("3) reversals: Compute reversal points.",quote=FALSE)
}

#=================================================================================
# return_data
# Return timeseries data and index length for selected symbol, data provider and subset of time
#=================================================================================
return_data <- function(ticker, src, start)
{
  # call data
  tryCatch({
    
    # load data
    d <- getSymbols(ticker, src=src, auto.assign=FALSE)
    
    # subset data
    if(!missing(start)){
      q <- as.character(paste0(start,'::'))
      d <- d[q]
    }
    # return data
    return(list(d = d, error = FALSE))
    
  }, warning = function(war) {
    print(paste("Warning:  ",war))
    print(paste("Problems loading data for ", ticker, ": Aborting...", sep = ""))
    return(list(d = 0, error = TRUE))
  
  }, error = function(err) {
    print(paste("Aborting:  ",err))
    print(paste("Problems loading data for ", ticker, ": Aborting...", sep = ""))
    return(list(d = 0, error = TRUE))
  })
}

#=================================================================================
# reversals
#=================================================================================
reversals <- function(data, lookback, ticker, is_High){
  
  # prepare data
  d <- data.frame(date=index(data), data)
  master <- list()
  c = 1
  
  # create a list of lists with front/back look time windows
  for(idx in (lookback+1):(length(d[,2])-(lookback+1)) ){
    tmp <- list( v = d[idx,2], back = d[(idx-lookback):idx,2], front = d[idx:(idx+lookback),2], date = d[idx,1])
    master[[c]] <- tmp
    c = c+1
  }
  
  # compute reversal points
  if (is_High){
    idx <- which(lapply(master, function(x) { x$v == max(x$back) & x$v == max(x$front) }) == T)
  }else{
    idx <- which(lapply(master, function(x) { x$v == min(x$back) & x$v == min(x$front) }) == T)
  }
  values <- unlist(lapply(master[idx], function(x) { x$v }))
  dates <- as.Date(unlist(lapply(master[idx], function(x) { x$date })))
  idx = idx + lookback
  
  # create output table
  r <- data.frame(sym = ticker, time = dates, x = idx,  y = values, is_High = is_High)
}