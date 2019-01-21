#!/usr/bin/python
# -*- coding: UTF-8 -*-

import os, sys, time, re
import urllib
from bs4 import BeautifulSoup
import pandas as pd

FILENAME = 'boku-no-hero-database.csv'
URLBASE = 'http://bokunoheroacademia.wikia.com/wiki/Chapter_'
infos = {'Chapter': '', 'Japanese': '', 'Romaji': '', 'Volume': '', 
         'Pages': '', 'Date Released': '', 'Arc': '', 'Anime Episode(s)': ''}
columnnames = {'Chapter': 'chapter', 'Japanese': 'japanesename', 
               'Romaji': 'name', 'Volume': 'volume', 'Pages': 'pages', 
               'Date Released': 'release', 'Arc': 'arc', 
               'Anime Episode(s)': 'anime'}


def getcontent(divs, name):
    for d in divs:
        if name == d.find('h3').text:
            if name == 'Anime Episode(s)':
                return map(int, re.findall('\d+', d.find('div').text))
            else:
                return d.find('div').text
    return ''


datalist = []

print ' [+] Colecting the following BNH infos:', infos.keys() 

for chapter in range(1, 202):
    url = URLBASE + str(chapter)
    response = urllib.urlopen(url)
    code = response.getcode()
    print '     [+] Chapter:', chapter
    if code == 200:
        content = response.read()
        soup = BeautifulSoup(content, features = 'html.parser')
        divs = soup.find_all('div', {"class": 'pi-item pi-data pi-item-spacing pi-border-color'})
        for i in infos.keys():
            info = getcontent(divs, i)
            infos[i] = info
        infos['Chapter'] = chapter
        datalist.append(infos.values())
    else:
        print '         [!] Problem with the page. Response code is', code

database = pd.DataFrame(datalist, columns=infos.keys())
database.rename(columns = columnnames, inplace = True)
database[['release']] = database[['release']].apply(pd.to_datetime)
database[['chapter', 'volume', 'pages']] = \
    database[['chapter', 'volume', 'pages']].apply(pd.to_numeric) 
database.to_csv(FILENAME, sep = ',', index=False, encoding = 'utf-8')
