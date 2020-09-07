# -*- coding: utf-8 -*-
"""
Created on Sun Dec 11 19:35:31 2016

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
import statsmodels.formula.api as smf
import statsmodels.api as sm
import pandas_datareader.data as fetch
from scipy.optimize import minimize

path_input = '/Users/AnsikMahapatra/Downloads/Input/'
path_output = '/Users/AnsikMahapatra/Downloads/Output/'

fn_stock_data           = path_output + 'stock_data.h5'

#%%
dt_start                = '2012-12-31'
dt_end                  = '2016-10-30'
#x                       = pd.read_csv("constituents.csv")#Download this file from DropBox and put it in C:\Users\"Your User Name"
#tickers                 = x['Symbol']
#z                      ='AAPL C F GOOGL MA MS PG'
#tickers                = z.split()
a = pd.read_hdf(fn_stock_data,'stock_data') #Just download the H5 file and run this code to not download it again and agian
a
stk_data = a

#fetch data from web and saved automatically as a panel object
#Items axis has Open, Close, High, Low, Volume and Adj Close
#Major axis has Dates
#Minor axis has Company Tickers
#stk_data                = fetch.DataReader(tickers, 'yahoo', dt_start, dt_end)
stk_data.rename(items   = {'Adj Close': 'AdjClose'},inplace=True)
stk_data['Returns']     = stk_data.AdjClose/stk_data.AdjClose.shift(1) - 1
stk_prc_ajcls           = stk_data.AdjClose.dropna(1,'any')

##Creating store funtion
#store                   = pd.HDFStore(fn_stock_data)
#store['stock_data']     = stk_data #Creating file
#store.close()

#Run when not on Saurabh's PC but first download this file and put it in your output path 
#%%
#==============================================================================
# Format Data in correct shape
#==============================================================================
stk_data_ret    = stk_prc_ajcls/stk_prc_ajcls.shift(1) - 1
axis_daily      = stk_data_ret.index
alldates        = pd.DataFrame(axis_daily,index=axis_daily)
alleom          = alldates.groupby([alldates.index.year,alldates.index.month]).last() 
alleom.index    = alleom.Date
axis_eom        = alleom.index
axis_id         = stk_data.minor_axis
#%%

def PtfVar(w,vcv):
    temp = w.dot(vcv).dot(w.T)
    return temp

cons = ({'type':'eq','fun' : lambda x: x.sum()-0},)

#
weights_eom = pd.DataFrame([], index = axis_eom, columns = stk_data_ret.columns)
#
for t in axis_eom[13::]:
    #
    vcv = np.array(stk_data_ret.loc[t-pd.DateOffset(months = 12):t,:].cov())
    #
    res = minimize(PtfVar, np.ones((1,len(stk_data_ret.columns)))/(len(stk_data_ret.columns)) , 
    args=(vcv,),constraints=cons,options={'disp': True, 'ftol': 1e-12}, 
    method='SLSQP')#, jac=func_deriv,  options={'disp': True})
    weights_eom.loc[t,:] = res.x
#%%

daily_weights               = pd.DataFrame(weights_eom,index=axis_daily,columns=stk_prc_ajcls.columns)
daily_weights               = daily_weights.fillna(method='ffill')

#Calculating Daily Portfolio Value
ptf_val                     = pd.DataFrame([],index=axis_daily,columns=['Daily_Portfolio_Return'])
for i in axis_daily:
    v                       = np.matrix(daily_weights.loc[i]).dot(np.matrix(stk_prc_ajcls.loc[i]).T)
    ptf_val.loc[i,:]        = v

#ptf_val = ptf_val*10000
#ptf_val.loc[axis_eom[12]::].plot()
    
#stk_mon_AdjClose            = stk_prc_ajcls.groupby([stk_prc_ajcls.index.year,stk_prc_ajcls.index.month]).last()
#stk_mon_AdjClose.index      = weights_eom.index
##Dollar Vol
#notional                    = 1000000
#weight_in_amount            = weights_eom*notional   
#dollar_vol                  = pd.DataFrame([],index=axis_daily,columns=["Amount_Invested"])
#for i in weight_in_amount.index:
#    w2                      = weight_in_amount.loc[i]
#    var                     = w2.dot(stk_mon_AdjClose.cov()).dot(w2.T)
#    vol                     = np.sqrt(var)
#    dollar_vol.loc[i,:]     = vol
##Forward fillinf NaNs with previous values
#daily_dol_vol               = dollar_vol.fillna(method='ffill')
#%%
#Creating 100 base portfolio
ptf_ret                     = ptf_val/ptf_val.shift(1) - 1

#ptf_ret_final               = np.array(ptf_ret)/np.array(daily_dol_vol)
#ptf_ret_final               = pd.DataFrame(ptf_ret_final,index=axis_daily,columns=["Ptf_ret_final"])
#value                       = 100+((100*ptf_ret_final).cumsum())

value                       = 100+((100*ptf_ret).cumsum())

#Removing NaN value period
valueptf                    = value.loc[axis_eom[12]::]
valueptf.plot()


#%%
#writer                      = pd.ExcelWriter(path_output + "output_alternate.xlsx")
#valueptf.to_excel(writer, sheet_name = 'Sheet1')
#writer.save()
#
