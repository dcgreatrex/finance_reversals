#finance_reversals
# Functions for computing time series reversal points.
*Author: David Greatrex, University of Cambridge.  
*Date: 30/11/2016 -- Language: Matlab. -- Modifications:

##Overview:
This algorithm can be used as part of a larger program to automatically detect price channel boundaries and trade entry/exit points. The function extracts price reversal points by using a user defined lookback window. The results are then overlayed on a time series plot using the quantmod package. The function will run on any time series dataset with index length > 2 lookback window.

##References:

* [Ryan, J., Ulrich, J., Thielen, W. (2016). Quantmod: Quantitative Financial Modelling Framework](https://cran.r-project.org/web/packages/quantmod/quantmod.pdf)