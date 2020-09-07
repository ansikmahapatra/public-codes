# -*- coding: utf-8 -*-
"""
Created on Mon Nov 14 20:36:56 2016

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

import pandas_datareader.data as web
from pandas_datareader.famafrench import get_available_datasets
#import quandl

# NEW PACKAGES!
import statsmodels.formula.api as smf
import statsmodels.api as sm
from scipy.optimize import minimize

MachineUsed = 1

if MachineUsed==1: # Mac
    path_input = '/Users/ansikmahapatra/Documents/Algorithmic Trading/Code/Source/'
    path_output = '/Users/ansikmahapatra/Documents/Algorithmic Trading/Code/Processed/'

# define some file names
#fn_crspd       = path_input  +'crspd.csv'
fn_index       = path_input  +'spdrd.csv'

fn_retdata     = path_output + 'retdata.h5'
fn_factors     = path_output + 'fffactors.h5'


# download the data on sectors and factors
secta = pd.read_hdf(fn_retdata,'ret/sect')
ffd     = pd.read_hdf(fn_factors,'daily/ff')
#%% let's run regressions and estimate factor betas

## Fit regression model (using the natural log of one of the regressors)
results = smf.ols('mktrf ~ smb + hml + np.power(mktrf,2)', data=ffd).fit()
#
## get the results -- display or save..
#results.params
#results.summary()
#
## there is another way:
#==============================================================================
#==============================================================================
y    = ffd.mktrf
temp = np.power(ffd.mktrf,2)
temp.name = 'mktrfsq'
X = ffd[['smb','hml']].join(temp)
X = sm.add_constant(X)

  # Fit regression model
results1 = sm.OLS(y, X).fit()

#==============================================================================
#
#==============================================================================


reg = smf.ols(formula=formula, data=data).fit(cov_type='HAC', cov_kwds={'maxlags': 10}, use_t=True)


## let us estimate a number of betas using rolling window regressions and save them on each day? month?
# questions: what kind of loop would you use?

#==============================================================================
axis_dates=secta.major_axis
alldates=pd.DataFrame(axis_dates,index=axis_dates)
alleom=alldates.groupby([alldates.index.year,alldates.index.month]).last()
alleom.index=alleom.date
axis_eom=alleom.index
axis_id=secta.minor_axis

betas=pd.DataFrame([],index=axis_eom,columns=axis_id)

dfret=secta.ret
dfret=dfret.sub(ffd.rf,axis=0).dropna()
dfret=dfret.join(ffd.mktrf,how='inner')

for t in axis_eom[13::]:
    dfret1=dfret.loc[t-pd.DateOffset(months=12):t,:]
    for id in axis_id:
        formula=id+'~mktrf'
        res=smf.ols(formula=formula,data=dfret1).fit()
        betas.loc[t,id]=res.params[1]
#
#
#==============================================================================

#%% OPTIMIZATIONS
b = np.matrix(betas.iloc[-1,:])
w = np.ones((1,9))/9
#w = np.matrix(np.random.lognormal(0,1,size=(1,9)))
w = w/w.sum()
#






def MktNeutral(w,b):
    mktb = abs(w*b.T)-0.5
    return mktb
#
cons = ({'type': 'ineq',
'fun' : lambda x,b: -np.linalg.norm(x)+0.1,
'args': (b,)},
{'type':'eq',
 'fun':lambda x:x.sum()-1})
#
#


res_opt = minimize(MktNeutral, np.ones((1,9))/9, args=(b,),options={'disp': True}, method='SLSQP')#, jac=func_deriv,  options={'disp': True})
res1_opt = minimize(MktNeutral, np.ones((1,9))/9, args=(b,),constraints=cons,options={'disp': True}, method='SLSQP')#, jac=func_deriv,  options={'disp': True})


# let us minimize the portfolio variance subject to market-neutral constraint.



#%% MISC

#plt.figure()
#secta.prc['mat'].rolling(window=12).mean().plot()
#secta.prc['mat'].rolling(window=120).mean().plot()
#
#alldates  = pd.DataFrame(axis_dates,index=axis_dates)
#alleom    = alldates.groupby([alldates.index.year,alldates.index.month]).last()
#alleom.index = alleom.date
#axis_eom  = alleom.index


#temp   = crspa.loc['ret',t-pd.DateOffset(years = 1):t,index_curr]
#            badsP  = temp.count()<len(temp)/3
#            temp   = temp.replace(np.nan,0)
#            hvcv   = temp.cov()*252
#            hvcv.loc[badsP,:] = np.nan
#            hvcv.loc[:,badsP] = np.nan
