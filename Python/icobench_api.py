#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Sep  3 10:58:35 2018

@author: ansikmahapatra
"""

import requests

private_key = "publickey"
public_key = "privatekey"

# Request for all ICOs
url = "https://icobench.com/api/v1/icos/all"
data = '''
{
 'X-ICObench-Key': private_key,
 'Content-Type: application/json'
}
'''
response = requests.post(url, data=data)
response = requests.post(url)
response.content

# Request for ICO Filters
url = "https://icobench.com/api/v1/icos/filters"
data = '''
{

}
'''
response1 = requests.post(url, data=data)
response1.content

# Request for Trending ICOs
url = "https://icobench.com/api/v1/icos/trending"
data = '''
{

}
'''
response = requests.post(url, data=data)
response.content

# Request for ICO Ratings
url = "https://icobench.com/api/v1/icos/ratings"
data = '''
{

}
'''
response = requests.post(url, data=data)
response.content

# ICO ID or Profile
url = "https://icobench.com/api/v1/ico/"
# Insert {id|url} above
data = '''
{

}
'''
response = requests.post(url, data=data)
response.content

# Request for people and profiles
url = "https://icobench.com/api/v1/people/all"
data = '''
{

}
'''
response = requests.post(url, data=data)

# Show only experts
url = "https://icobench.com/api/v1/people/expert"
data = '''
{

}
'''
response = requests.post(url, data=data)

# Show only registered
url = "https://icobench.com/api/v1/people/registered"
data = '''
{

}
'''
response = requests.post(url, data=data)

# Stats
url = "https://icobench.com/api/v1/other/stats"
data = '''
{

}
'''
response = requests.post(url, data=data)




## Back to the basics
#from selenium.webdriver import Chrome
from selenium import webdriver
from bs4 import BeautifulSoup as soup

index = range(1,422)
url = "https://icobench.com/icos?page="
#browser = Chrome()
chromedriver = "/Users/ansikmahapatra/Documents/chromedriver"
browser = webdriver.Chrome(chromedriver)
info = []
index = range(1,22)
url="https://icobench.com/icos?filterBonus=&filterBounty=&filterMvp=&filterKyc=&filterExpert=&filterSort=&filterCategory=all&filterRating=any&filterStatus=upcoming&filterPublished=&filterCountry=any&filterRegistration=0&filterExcludeArea=none&filterPlatform=any&filterCurrency=any&filterTrading=any&s=&filterStartAfter=&filterEndBefore=&page="
for i in index:
    browser.get(url+str(i))
    page = soup(browser.page_source,"html.parser")
    content = page.find_all("tr")
    for j in range(1,len(content)):
        name = content[j].find_all("a")[1].text.strip()
        profile = "https://icobench.com"+content[j].find_all("a")[1]['href']
        description = content[j].find_all("td")[0].p.text
        start_date = content[j].find_all("td")[1].text
        end_date = content[j].find_all("td")[2].text
        rate = content[j].find_all("td")[3].text
        info.append([name,profile,description,start_date,end_date,rate])

browser.close()

import pandas as pd
icobench = pd.DataFrame(info,columns=list(['name','profile','description','start_date','end_date','rate']))
icobench.to_csv("/Users/ansikmahapatra/Downloads/icobench_06_Dec_2018.csv")

browser = webdriver.Chrome(chromedriver)
website = []
for i in icobench['profile']:
    browser.get(i)
    page = soup(browser.page_source,"html.parser")
    content = page.find_all("a",{"class":"www"})[0]['href']
    website.append([content])

import re
for j in website:    
    j[0]=re.sub('\?utm_source=icobench','',j[0])

websites = pd.DataFrame(website,columns=list(['websites']))
websites.to_csv("/Users/ansikmahapatra/Downloads/icobench_websites.csv")

browser = webdriver.Chrome(chromedriver)
browser.get("https://cannabium.co/")
page = soup(browser.page_source,"html.parser")
content = ""

