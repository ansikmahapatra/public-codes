# -*- coding: utf-8 -*-
"""
Created on Sun Nov 20 10:25:42 2016

@author: ansikmahapatra
"""

#%% 

#load_ext zipline

#zipline ingest -b quantopian-quandl

#%%
get_ipython().magic('zipline --start 2000-1-1 --end 2014-1-1')


from zipline.api import order, record, symbol


def initialize(context):
    pass


def handle_data(context, data):
    order(symbol('AAPL'), 10)
    record(AAPL=data.current(symbol('AAPL'), 'price'))