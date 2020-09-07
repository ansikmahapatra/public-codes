# -*- coding: utf-8 -*-
"""
Created on Sun Nov 13 18:38:21 2016

@author: ansikmahapatra
"""

#%%
# import lots of stuff
from IPython import get_ipython
get_ipython().magic('reset -sf')

import numpy as np
import pandas as pd
import datetime as dt
import matplotlib as mpl
import matplotlib.pyplot as plt
get_ipython().magic('matplotlib inline')
#import statsmodels.formula.api as smf
#import statsmodels.api as sm
#import quandl


import pandas_datareader.data as web
from pandas_datareader.famafrench import get_available_datasets
     
MachineUsed = 1

if MachineUsed==1: # Mac
    path_input = '/Users/ansikmahapatra/Documents/Algorithmic Trading/Code/Source/'
    path_output = '/Users/ansikmahapatra/Documents/Algorithmic Trading/Code/Processed/'


# define some file names
#fn_crspd       = path_input  +'crspd.csv'
fn_index       = path_input  +'spdrd.csv'
fn_retdata     = path_output + 'retdata.h5'
fn_factors     = path_output + 'fffactors.h5'

#%%


#z ='XLB XLV XLP XLY XLE XLF XLI XLK XLU'
#z.split()
secnum = np.array([86449, 86451, 86452,86453,86454,86455,86456,86457,86458])
secnme = ['mat','hea','cst','cdi','ene','fin','ind','tec','utl']
#
sect = pd.read_csv(fn_index)
sect.columns = [x.lower() for x in sect.columns]


sect['date'] = pd.to_datetime(sect['date'],format='%Y%m%d')
sect.id      = sect.id.replace(secnum,secnme)
sect         = sect[sect.id.isin(secnme)]


#==============================================================================
# index_ret = pd.DataFrame([],index=sect.date.unique())
# for z in secnme:
#     a = sect[['date','ret']][sect.id==z]
#     a.rename(columns={'ret': z},inplace=True)
#     a.set_index('date',inplace=True)
# #==============================================================================
# #     index_ret = index_ret.join(a) #==============================================================================
#     index_ret = pd.concat([index_ret,a],axis=1,join='outer')
#==============================================================================
#
sect.set_index(['date','id'],inplace=True)
sect  = sect.groupby(level=[0,1]).first() 
secta = sect[['ret','prc','shrout']].to_panel()


store = pd.HDFStore(fn_retdata)
store['ret/sect']      = secta
store['ret/sect_orig'] = sect
store.close()



store.open()
store.keys()
store.items

a = pd.read_hdf(fn_retdata,'ret/sect')

#%%

z ='XLB XLV XLP XLY XLE XLF XLI XLK XLU'
tickers = z.split()

dt_start = '1998-12-23'

index_prc = None
for x in tickers:
    f = web.DataReader(x, 'yahoo', dt_start, dt.date.today())
    f = f[['Adj Close']]
    f.rename(columns={'Adj Close': x.lower()},inplace=True)
    if index_prc is None:        
        index_prc = f.copy()      
    else:
        index_prc = pd.concat([index_prc,f],axis=1,join='outer')

index_ret = index_prc/index_prc.shift(1)-1



f = web.DataReader(tickers, 'yahoo', dt_start, dt.date.today())
f.rename(items={'Adj Close': 'AdjClose'},inplace=True)

f['Ret'] = f.AdjClose/f.AdjClose.shift(1)-1

store['ret/test'] = f




#%% import factors/ save in hdf file 

#
d1  = web.DataReader("F-F_Research_Data_Factors_daily", "famafrench",start=dt.datetime(1926,1,1))
d2  = web.DataReader("F-F_Momentum_Factor_daily", "famafrench",start=dt.datetime(1926,1,1))
d3  = web.DataReader("F-F_Research_Data_5_Factors_2x3_daily", "famafrench",start=dt.datetime(1926,1,1))

d1m = web.DataReader("F-F_Research_Data_Factors", "famafrench")
d2m = web.DataReader("F-F_Momentum_Factor", "famafrench")

ff  = pd.DataFrame(d1[0]/100)
ff  = ff.join(pd.DataFrame(d2[0]/100),how='outer')
ff5 = pd.DataFrame(d3[0]/100)
ff5 = ff5[['RMW','CMA']]
ff  = ff.join(pd.DataFrame(ff5),how='outer')

ffm = pd.DataFrame(d1m[0]/100)
ffm = ffm.join(pd.DataFrame(d2m[0]/100),how='outer')
ff.columns = ['mktrf','smb','hml','rf','mom','rmw','cma']
ffm.columns = ['mktrf','smb','hml','rf','mom']
#There are the five factors for Fama and Fench

#Storing data
store = pd.HDFStore(fn_factors) 

store['daily/ff'] = ff
store['monthly/ff'] = ffm
#
store.close()
#
### to read the data use 
##ffd     = pd.read_hdf(fn_factors,'daily/ff')
##ffm     = pd.read_hdf(fn_factors,'monthly/ff')
