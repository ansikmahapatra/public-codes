# -*- coding: utf-8 -*-
"""
Created on Sun Nov 27 18:14:24 2016

@author: ansikmahapatra
"""


#%%  import lots of stuff
from IPython import get_ipython
get_ipython().magic('reset -sf')


import numpy as np
import pandas as pd
import datetime as dt
from datetime import datetime
import matplotlib as mpl
import matplotlib.pyplot as plt
get_ipython().magic('matplotlib inline')

import pandas_datareader.data as web
from pandas_datareader.famafrench import get_available_datasets
import quandl
import statsmodels.formula.api as smf
import statsmodels.api as sm
from scipy.optimize import minimize

# NEW PACKAGES! 
from zipline.algorithm import TradingAlgorithm
from zipline.data.bundles import register, yahoo_equities
from zipline.api import symbol, order, record, history
import zipline
import pytz
from collections import OrderedDict
     
MachineUsed = 0

if MachineUsed==1: # Mac
    path_input = '/Users/AnsikMahapatra/Downloads/Projects/Input/'
    path_output = '/Users/AnsikMahapatra/Downloads/Projects/Output/'


# define some file names
#fn_crspd       = path_input  +'crspd.csv'
fn_index       = path_input  +'spdrd.csv'

fn_retdata     = path_output + 'retdata.h5'
fn_factors     = path_output + 'fffactors.h5'


# download the data on sectors and factors
secta = pd.read_hdf(fn_retdata,'ret/sect')
ffd   = pd.read_hdf(fn_factors,'daily/ff')



#%% SIMPLEST ALGO - JUST BUY APPLE ON EACH ITERATION - 


# prepare data first 
data = OrderedDict()

start_date = '2011-01-01'
end_date   = '2016-11-28'
data['AAPL'] = web.DataReader('AAPL',data_source='yahoo',start=start_date, end=end_date)
print(data['AAPL'].head())
type(data['AAPL'])

panelAAPL            = pd.Panel(data)
panelAAPL.minor_axis = ['open', 'high', 'low', 'price', 'volume', 'close']
panelAAPL.major_axis = panelAAPL.major_axis.tz_localize(pytz.utc)  


# prepare algorithm
def initialize(context):  
    pass


def handle_data(context, data):  
    order(symbol('AAPL'), 10)

# initialize an instance of algorithm
algo = TradingAlgorithm(initialize=initialize,  
                        handle_data=handle_data)  

# run and plot
results0     = algo.run(panelAAPL)  

results0.portfolio_value.plot()  
 

#%% SAME AS ABOVE, BUT BUY ONLY IF NOT ORDERED EARLIER

def initialize(context):  
    context.has_ordered = False

def handle_data(context, data): 
    if not context.has_ordered:
        order(symbol('AAPL'), 10)
        context.has_ordered = True

  
algo = TradingAlgorithm(initialize=initialize, handle_data=handle_data)

results1 = algo.run(panelAAPL)

results1.portfolio_value.plot()

#%% CROSSING MA EXAMPLE -- SOMEWHAT MORE INVOLVED 

def initialize(context):
    context.security = symbol('AAPL')
    context.i = 0

def handle_data(context, data):
    context.i += 1
    # skip the first 300 points for MA
    if context.i < 150:
        return
    
    # note that the data.history(context.security, bar_count=100, frequency='1d', fields='price')
    # is the pandas Series object, and hence inherits all series methods
    MA1 = data.history(context.security, bar_count=50, frequency='1d', fields='price').mean()
    MA2 = data.history(context.security, bar_count=150, frequency='1d', fields='price').mean()    
    
    date = str(data[context.security].datetime)[:10]
    print('Processing ',date)
    current_price     = data[context.security].price
    current_positions = context.portfolio.positions[context.security].amount
    cash              = context.portfolio.cash
    value             = context.portfolio.portfolio_value
    current_pnl       = context.portfolio.pnl
    
     #code (this will come under handle_data function only)
    if (MA1 > MA2) and current_positions == 0:
        number_of_shares = int(cash/current_price)
        order(context.security, number_of_shares)
        record(date=date,MA1 = MA1, MA2 = MA2, Price= 
        current_price,status="buy",shares=number_of_shares,PnL=current_pnl,cash=cash,value=value)
     
    elif (MA1 < MA2) and current_positions != 0:
        order(context.security, -abs(current_positions))
        record(date=date,MA1 = MA1, MA2 = MA2, Price= current_price,status="sell",shares="--",PnL=current_pnl,cash=cash,value=value)
     
    else:
        record(date=date,MA1 = MA1, MA2 = MA2, Price= current_price,status="--",shares="--",PnL=current_pnl,cash=cash,value=value)

 
algo_obj = TradingAlgorithm(initialize=initialize,handle_data=handle_data)
results2 = algo_obj.run(panelAAPL)


results2[["MA1","MA2","Price"]].plot()
plt.figure()
results2.portfolio_value.plot()

#%% ORDERING SECTORS 

# prepare the panel with items = sectors
sectb = secta.swapaxes('items','minor_axis')
sectb.minor_axis = ['ret','close','shrout']

# Define algorithm
def initialize(context):
    context.i = 0
    context.has_ordered = False
    context.stocks = [symbol('cdi'),  # Consumer Discrectionary SPDR Fund
                      symbol('fin'),  # Financial SPDR Fund
                      symbol('tec'),  # Technology SPDR Fund
                      symbol('ene'),  # Energy SPDR Fund
                      symbol('hea'),  # Health Care SPDR Fund
                      symbol('ind'),  # Industrial SPDR Fund
                      symbol('cst'),  # Consumer Staples SPDR Fund
                      symbol('mat'),  # Materials SPDR Fund
                      symbol('utl')]  # Utilities SPDR Fund

                     
def handle_data(context, data): 
    context.i += 1
    if context.i < 2:
        return
        
    if not context.has_ordered:
        for z in context.stocks:            
            order(z,10)            
        context.has_ordered = True
        

algo = TradingAlgorithm(initialize=initialize, handle_data=handle_data)

# Run algorithm
results3 = algo.run(sectb)
results3.portfolio_value.plot()

#%% IMPLEMENTING OPTIMIZED STRATEGY USING SECTORS 

# prepare the panel with items = sectors
sectb = secta.swapaxes('items','minor_axis')
sectb.minor_axis = ['ret','close','shrout']

# compute betas and ptf weights
axis_dates = secta.major_axis
alldates   = pd.DataFrame(axis_dates,index=axis_dates)
alleom     = alldates.groupby([alldates.index.year,alldates.index.month]).last()
alleom.index = alleom.date
axis_eom  = alleom.index
axis_id = secta.minor_axis

betas = pd.DataFrame([],index=axis_eom,columns=axis_id)


dfret = secta.ret
dfret = dfret.sub(ffd.rf,axis=0).dropna()
dfret = dfret.join(ffd.mktrf,how='inner')


for t in axis_eom[13::]:
    dfret1 = dfret.loc[t-pd.DateOffset(months = 12):t,:]
    for id in axis_id:
        formula = id + '~mktrf'
        res = smf.ols(formula = formula,data = dfret1).fit()
        betas.loc[t,id] = res.params[1]
        
def PtfVar(w,b,vcv):
    temp = w.dot(vcv).dot(w.T)
    return temp

 
dfret    = secta.ret
axis_eom = betas.index
axis_id  = betas.columns

w = pd.DataFrame([],index=axis_eom,columns=axis_id)
#
for t in axis_eom[13::]:
    b   = np.array(betas.loc[t,:])
    vcv = np.array(dfret.loc[t-pd.DateOffset(months = 12):t,:].cov())
    
    cons = ({'type': 'ineq',
    'fun' : lambda x,b: 0.2-abs(x.dot(b.T)),
    'args': (b,)},
    {'type':'eq',
     'fun': lambda x: x.sum()-1})     
    
    res = minimize(PtfVar, np.ones((1,9))/9 , args=(b,vcv,),constraints=cons,options={'disp': True,'ftol':1e-12}, method='SLSQP')#, jac=func_deriv,  options={'disp': True})
    w.loc[t,:]=res.x


#%% RUN THE ALGO BACKTEST
from zipline.finance import commission, slippage

# prepare the panel with items = sectors
sectb = secta.swapaxes('items','minor_axis')
sectb.minor_axis = ['ret','close','shrout']
sectb.major_axis = sectb.major_axis.tz_localize(pytz.utc)
w1               = w.copy()
w1.index         = w.index.tz_localize(pytz.utc)
w1               = w1.reindex(columns = ['cdi','fin','tec','ene','hea','ind','cst','mat','utl'])

# Define algorithm
def initialize(context):
    context.i = 0
    context.has_ordered = False
    context.stocks = [symbol('cdi'),  # Consumer Discrectionary SPDR Fund
                      symbol('fin'),  # Financial SPDR Fund
                      symbol('tec'),  # Technology SPDR Fund
                      symbol('ene'),  # Energy SPDR Fund
                      symbol('hea'),  # Health Care SPDR Fund
                      symbol('ind'),  # Industrial SPDR Fund
                      symbol('cst'),  # Consumer Staples SPDR Fund
                      symbol('mat'),  # Materials SPDR Fund
                      symbol('utl')]  # Utilities SPDR Fund

    context.w = w1 # optimal weights
    context.w.columns = context.stocks
    context.rebal_date = axis_eom[13::].tz_localize(pytz.utc) # rebalancing dates - we start in Jan 2000
    
    context.set_commission(commission.PerShare(cost=0.02, min_trade_cost=0))
    context.set_slippage(slippage.FixedSlippage(spread=0.01))       
              
def handle_data(context, data): 
    t_curr = data[context.stocks[0]].datetime
    # do not do anything before the first rebalancing
    if t_curr<context.rebal_date[0]:
#        print(data[context.stocks[0]].datetime)
        return
     
    # rebalance if rebalancing date
    if t_curr in context.rebal_date: 
        ptf_val             = context.portfolio.portfolio_value
        for z in context.stocks:
            # new number of stocks
            nstocks     = int(ptf_val*context.w.loc[t_curr,z]/data.current(z,'close'))
            nstocks_old = context.portfolio.positions[z].amount
            if abs(nstocks_old-nstocks)>0:
#                print(context.portfolio.positions[z].amount,nstocks)
                order(z, nstocks-nstocks_old)

        
algo = TradingAlgorithm(initialize=initialize, handle_data=handle_data)

# Run algorithm
results4 = algo.run(sectb)
results4.portfolio_value.plot()



