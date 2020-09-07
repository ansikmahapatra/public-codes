#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Oct 15 16:15:07 2018

@author: ansikmahapatra
"""

from selenium import webdriver
from bs4 import BeautifulSoup as soup
import csv
import pandas as pd
base_folder = "/Users/ansikmahapatra/Desktop/"
base_url = "https://www.google.com/search?q="
browser = webdriver.Chrome("/Users/ansikmahapatra/Downloads/chromedriver")
data = pd.read_csv("/Users/ansikmahapatra/Desktop/postleitzahl.csv")

for i in range(len(data['Address'])):
    print(data['Address'][i])
    if(data['Address'][i]!='nan'):
        text = str(data['Address'][i]).replace(" ","+")
        browser.get(base_url+text)
        page = soup(browser.page_source,"html.parser")
        try:
            data['Postleitzahl'][i]=page.find("span",{"class":"desktop-title-subcontent"}).text
        except:
            data['Postleitzahl'][i]='find manually'
    else:
        data['Postleitzahl'][i]='nan'

browser.close()

data.to_csv("/Users/ansikmahapatra/Desktop/postleitzahl2.csv")

api_key = "API_KEY"
import googlemaps

gm = googlemaps.Client(key=api_key)
#geocode_result = gm.geocode('Geschwister-Scholl-Straße 54, Potsdam')
#geocode_result[0]['geometry']['location']['lat']
#geocode_result[0]['geometry']['location']['lng']

import pandas as pd

vcs = pd.read_csv("/Users/ansikmahapatra/Desktop/input.csv")
info = []
for i in range(len(vcs)):
    #search = vcs['address'][i]#+" "+vcs['city'][i]
    search = vcs['city'][i]#+" "+vcs['city'][i]
    try:
        geocode_result = gm.geocode(search)
        lat = geocode_result[0]['geometry']['location']['lat']
        lng = geocode_result[0]['geometry']['location']['lng']
    except:
        lat = ""
        lng = ""
    print(str(lat)+" "+str(lng))
    info.append([search,lat,lng])

pn = pd.DataFrame(info,columns=list(['city','lat','lng']))
pn.to_csv("/Users/ansikmahapatra/Desktop/output.csv")
vcs.to_csv("/Users/ansikmahapatra/Desktop/vcs_extra_google2.csv")
