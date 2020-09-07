# -*- coding: utf-8 -*-
"""
Created on Fri Dec 16 08:56:16 2016

@author: ansikmahapatra
"""

from IPython import get_ipython
get_ipython().magic('reset -sf')

import numpy as np
import pandas as pd
import datetime as dt
import matplotlib as mpl
import matplotlib.pyplot as plt
get_ipython().magic('matplotlib inline')

import pandas_datareader.data as fetch

from pandas_datareader.famafrench import get_available_datasets
import quandl

import statsmodels.formula.api as smf
import statsmodels.api as sm
from scipy.optimize import minimize
#%%
dt_start                = '2005-1-1'
dt_end                  = '2016-12-1'

x                       = pd.read_csv("~/Desktop/tickers.csv")
tickers=x['ticker']
stk_data = fetch.DataReader(tickers, 'yahoo', dt_start, dt_end) 
stk_data.rename(items   = {'Adj Close': 'AdjClose'},inplace=True)
stk_prc_ajcls           = stk_data.AdjClose.dropna(1,'any')
stk_prc_open=stk_data.Open.dropna(1,'any')
stk_prc_close=stk_data.Close.dropna(1,'any')

#Our required daily data
prc=stk_prc_ajcls 
prc
#%%

d1  = fetch.DataReader("F-F_Research_Data_Factors_daily", "famafrench",start=dt_start)
d2  = fetch.DataReader("F-F_Momentum_Factor_daily", "famafrench",start=dt_start)
d3  = fetch.DataReader("F-F_Research_Data_5_Factors_2x3_daily", "famafrench",start=dt_start)

ff  = pd.DataFrame(d1[0]/100)
ff  = ff.join(pd.DataFrame(d2[0]/100),how='outer')
ff5 = pd.DataFrame(d3[0]/100)
ff5 = ff5[['RMW','CMA']]

#Our required fama-french factors
ff  = ff.join(pd.DataFrame(ff5),how='outer')
ff
#%%
#in_sample_start=dt_start
#in_sample_end='2005-12-31'
#out_sample_start='2006-1-1'
#out_sample_end=dt_end
daily_dates=prc.index
alldates=pd.DataFrame(daily_dates,index=daily_dates)
eom_dates=alldates.groupby([alldates.index.year,alldates.index.month]).last() 
eom_dates.index=eom_dates.Date
axis_eom        = eom_dates.index
axis_id         = stk_data.minor_axis

betas=pd.DataFrame([],index=axis_eom,columns=axis_id)



dfret=(prc/prc.shift(1))-1
dfret=dfret.sub(ff.RF,axis=0).dropna()
dfret['mktrf']=ff['Mkt-RF']

for t in axis_eom[13::]:
    dfret1=dfret.loc[t-pd.DateOffset(months=12):t,:]
    for id in axis_id:
        formula=id+'~mktrf'
        res=smf.ols(formula=formula,data=dfret1).fit()
        betas.loc[t,id]=res.params[1]

betas
#%%
#Median Beta Calculation for each end of the month
med_beta=pd.DataFrame([],index=betas.index,columns=['Median_Beta'])
for t in axis_eom:
    med_beta.Median_Beta[t]=betas.loc[t].median()
    
number = pd.DataFrame([],index=betas.index,columns=['low_beta','high_beta'])
mean_beta=pd.DataFrame([],index=betas.index,columns=['low_beta','high_beta'])

for t in axis_eom:
    counter_low=0
    counter_high=0
    sum_low=0
    sum_high=0n
    for i in axis_id:
        if betas[i].loc[t]>med_beta.Median_Beta.loc[t]:
            counter_high=counter_high+1
            sum_high=sum_high+betas[i].loc[t]
        if betas[i].loc[t]<med_beta.Median_Beta.loc[t]:
            counter_low=counter_low+1
            sum_low=sum_low+betas[i].loc[t]
    mean_beta.low_beta.loc[t]=sum_low
    mean_beta.high_beta.loc[t]=sum_high
    number.low_beta.loc[t]=counter_low
    number.high_beta.loc[t]=counter_high

for t in axis_eom:
    try:        
        mean_beta.low_beta.loc[t]=mean_beta.low_beta.loc[t]/number.low_beta.loc[t]
        mean_beta.high_beta.loc[t]=mean_beta.high_beta.loc[t]/number.high_beta.loc[t]      
    except ZeroDivisionError:
        mean_beta.low_beta.loc[t]=""
        mean_beta.high_beta.loc[t]=""

weights=pd.DataFrame([],index=betas.index,columns=axis_id)
for t in axis_eom:
    for i in axis_id:
        try:                
            if betas[i].loc[t]<med_beta.Median_Beta.loc[t]:
                weights[i].loc[t]=(1/(number.low_beta.loc[t]*mean_beta.low_beta.loc[t]))
            if betas[i].loc[t]>med_beta.Median_Beta.loc[t]:
                weights[i].loc[t]=(-1/(number.high_beta.loc[t]*mean_beta.high_beta.loc[t]))
        except Exception:
            weights[i].loc[t]=0           
weights

sum_weight=pd.DataFrame([],index=axis_eom,columns=['sum_of_weights'])
for t in axis_eom:
    sum_weight.sum_of_weights.loc[t]=weights.loc[t].sum()

#%%
risk_free=quandl.get("USTREASURY/YIELD",start_date=dt_start,end_date=dt_end)
risk_free=risk_free.dropna(1,'any')
risk_free.columns=['1month','6month','1year','2year','3year','5year','7year','10year','20year']
risk_free_1=risk_free.groupby([risk_free.index.year,risk_free.index.month]).last() 
risk_free_1.index=axis_eom
risk_free_1=risk_free_1/100
returns=pd.DataFrame([],index=axis_eom,columns=axis_id)
returns=stk_prc_ajcls.groupby([stk_prc_ajcls.index.year,stk_prc_ajcls.index.month]).last() 
returns.index=axis_eom
returns=(returns/returns.shift(1))-1
#returns=returns-risk_free_1['1month']
final_returns=pd.DataFrame([],index=axis_eom,columns=axis_id)
for t in axis_eom:
    for i in axis_id:
        final_returns[i].loc[t]=returns[i].loc[t]-risk_free_1['1month'].loc[t]
        
ptf_returns=pd.DataFrame([],index=axis_eom,columns=['portfolio_return'])
for t in axis_eom:
    sum=0
    for i in axis_id:
        ptf_returns['portfolio_return'].loc[t]=sum+(final_returns[i].loc[t]*weights[i].loc[t])
ptf_returns.plot()
