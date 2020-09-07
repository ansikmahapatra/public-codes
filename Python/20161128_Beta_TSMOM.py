# -*- coding: utf-8 -*-
"""
Created on Mon Nov 28 12:30:05 2016

@author: ansikmahapatra
"""

from IPython import get_ipython
get_ipython().magic('reset -sf')
 
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
get_ipython().magic('matplotlib inline')
import pandas_datareader.data as fetch

z ='AAPL C F GOOGL MA MS PG'
tickers = z.split()
tickers
 
dt_start_insample   = '2012-12-31'
dt_end_insample     = '2015-12-31'
dt_start_outsample  = '2016-1-1'
dt_end_outsample    = '2016-10-30'

stk_data = fetch.DataReader(tickers, 'yahoo', dt_start_insample, dt_end_insample) #This is a panel
 
#rename for simplicity
stk_data.rename(items = {'Adj Close': 'AdjClose'},inplace=True)
 
# Creating another item axis 'Returns'
stk_data['Returns'] = stk_data.AdjClose/stk_data.AdjClose.shift(1) - 1
stk_prc_ajcls = stk_data.AdjClose

plt.figure(); stk_prc_ajcls.plot(); plt.legend(loc='best')
 
#equation_12: Portfolio Volatility
def equation_12(sigma,weights):
    sigma_P=np.sqrt(np.dot(weights,np.dot(sigma,np.transpose(weights))))
    return sigma_P
 
#equation_14: Calculating average pairwise correlation
def equation_14(rho):
    n=len(rho.index)
    rho_bar=(np.dot(np.ones(n),np.dot(rho,np.transpose(np.ones(n))))-n)/(n*(n-1))
    return rho_bar
 
#equation_15: portfolio target volatility
def equation_15(sigma_tgt,rho):
    sigma_P_tgt=sigma_tgt*np.sqrt((1+(len(rho.index)-1)*equation_14(rho))/len(rho.index))
    return sigma_P_tgt
 
#equation_18: Correlation Factor
def equation_18(rho):
    CF=np.sqrt(len(rho.index)/(1+(len(rho.index)-1)*equation_14(rho)))
    return CF
      
#equation_20: YZ Volatility Estimator
def equation_20(stk_data,n):
    #stk_ret = stk_data.Returns
    stk_prc_opn = stk_data.Open
    stk_prc_cls = stk_data.Close
    stk_prc_h = stk_data.High
    stk_prc_l = stk_data.Low
    stk_prc_ajcls = stk_data.AdjClose
     
    k = ((0.34)/((1.34)+((n+1)/(n-1))))
     
    oj_mu = np.log(stk_prc_opn.shift(1)/stk_prc_cls).mean(0)
    prc_oj = (((np.log(stk_prc_opn.shift(1)/stk_prc_cls)) - oj_mu)**2).sum()
    var_oj = prc_oj/(n-1)
    var_oj #Overnight Variance
     
    oc_mu = np.log(stk_prc_cls/stk_prc_opn).mean(0)
    prc_oc = (((np.log(stk_prc_cls/stk_prc_opn)) - oc_mu)**2).sum()
    var_oc = prc_oc/(n-1)
    var_oc #Openclose Variance
     
    prc_rc = ((np.log(stk_prc_h/stk_prc_cls))*(np.log(stk_prc_h/stk_prc_opn)) + (np.log(stk_prc_l/stk_prc_cls))*(np.log(stk_prc_l/stk_prc_opn)))
    var_rs = prc_rc.sum()/n
    var_rs #Roger - Sacthel Variance
 
    vol_yz = (var_oj + k*var_oc + (1-k)*var_rs)**(1/2)
    return vol_yz
   
#equation_24: Calculating Sign
def equation_24(X):
    return np.sign(X)
 
 
axis_dates=stk_data.major_axis
alldates=pd.DataFrame(axis_dates,index=axis_dates)
alleom=alldates.groupby([alldates.index.year,alldates.index.month]).last() 
alleom.index=alleom.Date
axis_eom=alleom.index
axis_id=stk_data.minor_axis
 
our_dataframe=pd.DataFrame([],index=axis_eom,columns=axis_id)
stk_mon_AdjClose=stk_data.AdjClose.groupby([stk_data.AdjClose.index.year,stk_data.AdjClose.index.month]).last()
stk_mon_AdjClose.index=our_dataframe.index

print ("Stock Monthly Return: ")
plt.figure(); stk_mon_AdjClose.plot(); plt.legend(loc='best')

stk_yearly_ret=(stk_mon_AdjClose.shift(12)/stk_mon_AdjClose)-1

print ("Stock Yearly Return: ")
plt.figure(); stk_yearly_ret.plot(); plt.legend(loc='best')

stk_target=stk_yearly_ret.loc['2015-12-31',:]
 
stk_corr=stk_data.AdjClose.corr()

#print("Portfolio Return:")
#

equation_24(stk_target)#Sign Function
X = equation_24(stk_target)
print ("Long or Short decision: ")
print (X)

sigma_tgt=0.2#Taget Volatility to be provided
print ("Target Asset Volatility: ")
print (sigma_tgt)

sigma_p_tgt=equation_15(sigma_tgt,stk_corr)#Target portfolio volatility
print ("Target Porfolio Volatility: ")
print (sigma_p_tgt)

equation_18(stk_corr) #Correlation Factor
print ("Correlation Factor: ")
cf=equation_18(stk_corr)
print (cf)

n=len(stk_prc_ajcls.index)#No. of days
print ("No. of Days: ")
print(n)

N=len(stk_prc_ajcls.columns)#No. of assets
print ("No. of Assets: ")
print(N)

sigma_yz=equation_20(stk_data,n) #Calculating YZ Volatility estimator
print ("YZ Volatilities: ")
print(sigma_yz)

weights=(X*(sigma_p_tgt)*cf)/(N*sigma_yz)#Calculating weights
weights

final_weights=weights/sum(weights)#Scaling up to one
print ("Asset Weights:")
print (final_weights)

print ("Sum of Weights: ")#Checking sum of weights
print(sum(final_weights))
