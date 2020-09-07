port#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Oct  2 11:34:47 2018

@author: ansikmahapatra
"""

from selenium.webdriver import Chrome
from bs4 import BeautifulSoup as soup
import csv

base_folder = "/Users/ansikmahapatra/Desktop/"
sample = "https://coinmarketcap.com/currencies/civic/historical-data/?start=20171002&end=20181002"

token = input("Enter Token Name: ")
start_date = input("Enter Start Date (yyyymmdd): ")
end_date= input("Enter End Date (yyyymmdd): ")

if(token!=""):
    token = "bitcoin"
if(start_date!=""):
    start_date = "20171002"
if(end_date!=""):
    end_date = "20181002"

base_url = "https://coinmarketcap.com/currencies/" + token + "/historical-data/?start=" + start_date + "&end=" + end_date

browser = Chrome()
browser.get(base_url)
page = soup(browser.page_source,"html.parser")
table = page.find("table")
browser.close()

headers = [th.text for th in table.select("tr th")]
with open(base_folder+token+".csv", "w") as f:
    wr = csv.writer(f)
    wr.writerow(headers)
    wr.writerows([[td.text for td in row.find_all("td")] for row in table.select("tr + tr")])

