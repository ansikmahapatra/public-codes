#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jul  5 09:52:48 2018

@author: ansikmahapatra
"""

#This is a webscrapping code for etherscan

import time
import platform
import os


if platform.system() == 'Darwin':
    print("This is a macOS system.")
else:
    print("This is not a macOS system.")

try:
    from bs4 import BeautifulSoup as soup
except ImportError:
    print("Installing BeautifulSoup")
    os.system("pip3 install bs4")
    from bs4 import BeautifulSoup as soup

try:
    from selenium.webdriver import Chrome
except ImportError:
    print("Installing selenium webdriver")
    os.system("pip3 install selenium")
    from selenium.webdriver import Chrome

ur = "http://www.etherscan.io/tokens?p="
try:
    browser = Chrome()
except:
    print("Chrome is not installed")
    
info = []
for i in range(11):
    browser.get(ur+str(i+1))
    time.sleep(2)
    name = soup(browser.page_source,"html.parser")
    name = name.find_all("td",{"class":"hidden-xs"})
    name = name[1::2]
    for s in name:
        try:
            info.append([s.a.text,s.small.text])
        except:
            info.append([s.a.text," "])

browser.close()

try:
    import pandas as pd
except:
    print("Installing pandas")
    os.system("pip3 install pandas")
    import pandas as pd

print("Experting to CSV File")
mydata = pd.DataFrame(info,columns=list(['tokens','description']))
address = "/Users/ansikmahapatra/Desktop/"
mydata.to_csv(address+"etherscan.csv")