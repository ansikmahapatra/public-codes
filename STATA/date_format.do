generate newdate = date(date,"MDY#") 
drop date
rename newdate date
tsset date, daily

generate newdate = date(common_date,"MDY#") 
drop common_date
rename newdate date
tsset date, daily


ssc install rollreg
ssc install eststo

ssc install wbopendata
