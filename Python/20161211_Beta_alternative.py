# -*- coding: utf-8 -*-
"""
Created on Sun Nov 27 09:57:45 2016

@author: ansikmahapatra
"""

from IPython import get_ipython
get_ipython().magic('reset -sf')
 
import numpy as np
import pandas as pd
#import datetime as dt
#import matplotlib as mpl
import matplotlib.pyplot as plt
get_ipython().magic('matplotlib inline')
#import statsmodels.formula.api as smf
#import statsmodels.api as sm
import pandas_datareader.data as fetch

#path_input = 'C:\\Users\\test\\Desktop\\MoF\\Algo_Trading\\Project\\In\\'
#
#t_inp = path_input +'SPY_Tickers.xlsx'
#temp = pd.read_excel(t_inp)
#temp.set_index('Index',inplace=True)

#%%
#
#import urllib3
#import pytz
#import pandas as pd
#
#from bs4 import BeautifulSoup
#from datetime import datetime
#
#
#SITE = "http://en.wikipedia.org/wiki/List_of_S%26P_500_companies"
#START = datetime(1900, 1, 1, 0, 0, 0, 0, pytz.utc)
#END = datetime.today().utcnow()
#
#
#def scrape_list(site):
#    hdr = {'User-Agent': 'Mozilla/5.0'}
#    req = urllib3.request.RequestMethods(site, headers=hdr)
#    page = urllib3.urlopen(req)
#    soup = BeautifulSoup(page)
#
#    table = soup.find('table', {'class': 'wikitable sortable'})
#    sector_tickers = dict()
#    for row in table.findAll('tr'):
#        col = row.findAll('td')
#        if len(col) > 0:
#            sector = str(col[3].string.strip()).lower().replace(' ', '_')
#            ticker = str(col[0].string.strip())
#            if sector not in sector_tickers:
#                sector_tickers[sector] = list()
#            sector_tickers[sector].append(ticker)
#    return sector_tickers
#
#
#def download_ohlc(sector_tickers, start, end):
#    sector_ohlc = {}
#    for sector, tickers in sector_tickers.iteritems():
#        print ('Downloading data from Yahoo for %s sector' % sector)
#        data = fetch.DataReader(tickers, 'yahoo', start, end)
#        for item in ['Open', 'High', 'Low']:
#            data[item] = data[item] * data['Adj Close'] / data['Close']
#        data.rename(items={'Open': 'open', 'High': 'high', 'Low': 'low',
#                           'Adj Close': 'close', 'Volume': 'volume'},
#                    inplace=True)
#        data.drop(['Close'], inplace=True)
#        sector_ohlc[sector] = data
#    print ('Finished downloading data')
#    return sector_ohlc
#
#
#def store_HDF5(sector_ohlc, path):
#        for sector, ohlc in sector_ohlc.iteritems():
#            store[sector] = ohlc
#
#
#def get_snp500():
#    sector_tickers = scrape_list(SITE)
#    sector_ohlc = download_ohlc(sector_tickers, START, END)
#    store_HDF5(sector_ohlc, 'snp500.h5')
#
#
#if __name__ == '__main__':
#    get_snp500()

#from pandas_datareader.famafrench import get_available_datasets
#%%
z ='AAPL C F GOOGL MA MS PG AMGN INTC'
tickers = z.split()
tickers
#for i in temp['Identifier']:
#    tickers.append(i)

dt_start  = '2012-12-31'
dt_end = '2016-10-30'
 
#fetch data from web and saved automatically as a panel object
#Items axis has Open, Close, High, Low, Volume and Adj Close
#Major axis has Dates
#Minor axis has Company Tickers

stk_data = fetch.DataReader(tickers, 'yahoo', dt_start, dt_end)
stk_data.rename(items = {'Adj Close': 'AdjClose'},inplace=True)
stk_data['Returns'] = stk_data.AdjClose/stk_data.AdjClose.shift(1) - 1
stk_prc_ajcls = stk_data.AdjClose
#Creating store funtion
#store = pd.HDFStore(fn_stock_data)
#Creating file
#%%
 
#equation_12: Portfolio Volatility
def equation_12(sigma,weights):
    sigma_P=np.sqrt(np.dot(weights,np.dot(sigma,np.transpose(weights))))
    return sigma_P
 
#equation_14: Calculating average pairwise correlation
def PairwiseCorr(rho):
    n=len(rho.index)
    rho_bar=(np.dot(np.ones(n),np.dot(rho,np.transpose(np.ones(n))))-n)/(n*(n-1))
    return rho_bar
 
#PtfTgtVol: portfolio target volatility
def PtfTgtVol(sigma_tgt,rho):
    sigma_P_tgt=sigma_tgt*np.sqrt((1+(len(rho.index)-1)*PairwiseCorr(rho))/len(rho.index))
    return sigma_P_tgt
 
#equation_18: Correlation Factor
def CorrFact(rho):
    CF=np.sqrt(len(rho.index)/(1+(len(rho.index)-1)*PairwiseCorr(rho)))
    return CF

#YZVolEst: YZ Volatility Estimator
def YZVolEst(stk_data,n,tt,t):
    location2 = stk_data.AdjClose.index.get_loc(tt)
    location1 = stk_data.AdjClose.index.get_loc(t)
    #stk_ret = stk_data.Returns
    stk_prc_opn = stk_data.Open.iloc[location2:location1+1,:]
    stk_prc_cls = stk_data.Close.iloc[location2:location1+1,:]
    stk_prc_h = stk_data.High.iloc[location2:location1+1,:]
    stk_prc_l = stk_data.Low.iloc[location2:location1+1,:]
    
     
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

def Sign(stk_ret):
    return np.sign(stk_ret)
    
#%%
#==============================================================================
# Format Data in correct shape
#==============================================================================
stk_data_ret = stk_data['AdjClose'].pct_change()
axis_daily= stk_data_ret.index
alldates=pd.DataFrame(axis_daily,index=axis_daily)
alleom=alldates.groupby([alldates.index.year,alldates.index.month]).last() 
alleom.index=alleom.Date
axis_eom=alleom.index
axis_id=stk_data.minor_axis


#%%

#==============================================================================
# Calculation weigths Matrix
#==============================================================================


#Sigma Target - manual input value
sigma_tgt=0.2
N=len(stk_prc_ajcls.columns)#No. of assets


weights = pd.DataFrame([],index=axis_eom,columns=axis_id)
stk_mon_AdjClose=stk_data.AdjClose.groupby([stk_data.AdjClose.index.year,stk_data.AdjClose.index.month]).last()
stk_mon_AdjClose.index=weights.index
stk_yearly_ret=(stk_mon_AdjClose/stk_mon_AdjClose.shift(12))-1


#Calcuccaling weights matrix
tt=axis_eom[1]
t=axis_eom[12]
t_counter=12
tt_counter=1
start=True
for i in axis_eom:  
    if start:  
       location2 = stk_data.AdjClose.index.get_loc(tt)
       location1 = stk_data.AdjClose.index.get_loc(t)
       stk_prc_ajcls = stk_data.AdjClose.iloc[location2:location1+1,:]
       stk_corr=stk_data.AdjClose.iloc[location2:location1+1,:].corr()
       sigma_p_tgt=PtfTgtVol(sigma_tgt,stk_corr)
       
       cf=CorrFact(stk_corr)
       
    #   Length should always be one year
       n=len(stk_prc_ajcls.index)#len of period
    
    #Calculate siigma yz   
       sigma_yz=YZVolEst(stk_data,n,tt,t)
       
    #   SignTarget Calculation
       stk_target=stk_yearly_ret.loc[t,:]
       X = Sign(stk_target)
       w=(X*(sigma_p_tgt)*cf)/(N*sigma_yz)
       w=w/sum(w)
       weights.loc[t,:]=w
       
       print(sum(w))
       t_counter=t_counter+1
       tt_counter=tt_counter+1
       if t_counter==axis_eom.size:
           start=False  
       if start:
           t=axis_eom[t_counter]
           tt=axis_eom[tt_counter]
         
   
#%%

value = pd.DataFrame([],index=axis_daily,columns=axis_id)
"""
Robin
Backtest Portfolio OOS
"""
#Calcuccaling value matrix
tt=axis_daily[0]
t=axis_daily[1]
for t in axis_daily:
    value.loc[t,:] = value.loc[tt,:]*(1+stk_data_ret.loc[t,:])      
    if t in axis_eom:
        if t==axis_eom[12]:
            value.loc[t,:] = weights.loc[t,:]*1000
        else:
            value.loc[t,:] = weights.loc[t,:]*value.loc[t,:].sum()   
    tt=t

value=value.loc[axis_eom[12]::]
valret=value.sum(axis=1).pct_change()
valret.mean()/valret.std()*np.sqrt(252)
valueptf = value.sum(axis=1)
valueptf.plot()

#%%

import scipy.optimize as minimize

def objective_function(one_array,vcv):
    return np.dot(one_array.T,np.dot(vcv,one_array))

def alternative():
    one_array=np.ones(N)
    one_array=one_array/N 
    mean_returns=pd.DataFrame([],index=axis_id,columns=['Mean_Returns'])
    vol = pd.DataFrame([],index=axis_id,columns=['Annual_Volatility'])
    vcv = pd.DataFrame([],index=axis_id,columns=axis_id)
    vcv = stk_yearly_ret.corr()
    temp=stk_yearly_ret
    for j in X.index:          
        mean_returns.Mean_Returns[j] = np.mean(stk_yearly_ret[j])
        temp[j]=stk_yearly_ret[j]-mean_returns.Mean_Returns[j]
        temp[j]=temp[j]**2
        vol.Annual_Volatility[j]=np.sqrt((1/len(stk_yearly_ret[j]))*temp[j].sum())
    vol_diag=np.diag(vol.Annual_Volatility)    
    vcv=np.dot(vol_diag,np.dot(vcv,vol_diag))
    vcv=pd.DataFrame(vcv,index=axis_id,columns=axis_id)
    
    cons = cons = ({'type':'eq','fun' : lambda x: x.sum()-0},)
    res1 = minimize(objective_function, one_array, args=(vcv,), constraints=cons, options={'disp': True, 'ftol': 1e-12}, method='SLSQP')
    res1
    return 1
    

