#!/usr/bin/python
# -*- coding: UTF-8 -*-

import os, sys, time, re
import requests
from bs4 import BeautifulSoup
import pandas as pd
from dateutil import parser

FILENAME = 'boku-no-hero-database.csv'
URLBASE = 'http://bokunoheroacademia.wikia.com/wiki/Chapter_'
URLCHAPTERS = 'https://myheroacademia.fandom.com/wiki/Chapters_and_Volumes'
INFOS = {'Chapter': '', 'Japanese': '', 'Romaji': '', 'Volume': '', 
         'Pages': '', 'Date Released': '', 'Arc': '', 'Anime Episode(s)': ''}
columnnames = {'Chapter': 'chapter', 'Japanese': 'japanesename', 
               'Romaji': 'name', 'Volume': 'volume', 'Pages': 'pages', 
               'Date Released': 'release', 'Arc': 'arc', 
               'Anime Episode(s)': 'anime'}

def get_number_of_chapters():
    while True:
        r = requests.get(URLCHAPTERS)
        if r.status_code != 200:
            time.sleep(5)
            continue
        
        content = r.content
        soup = BeautifulSoup(content, features = 'html.parser')
        main = soup.find_all('main')[0]
        uls = main.find_all('ul')
        tankouban = uls[-2]
        lis = tankouban.find_all('li')
        for li in lis[::-1]:
            chapter = li.text.split('.')[0]
            first_word = li.text.split(' ')[1]
            if first_word != 'TBA':
                return int(chapter)
        else:
            print('Last chapter not found')
            sys.exit(-1)


def getcontent(divs, name):
    for d in divs:
        if name == d.find('h3').text:
            if name == 'Anime Episode(s)':
                return list(map(int, re.findall('\d+', d.find('div').text)))[0]
            else:
                return d.find('div').contents[0].text
    return ''


datalist = []

print(' [+] Colecting the following BNH infos:', INFOS.keys())
last_chapter = get_number_of_chapters()

for chapter in range(1, last_chapter):
    url = URLBASE + str(chapter)
    response = requests.get(url)
    code = response.status_code
    print('     [+] Chapter:', chapter)
    if code == 200:
        content = response.content
        soup = BeautifulSoup(content, features = 'html.parser')
        divs = soup.find_all('div', {"class": 'pi-item pi-data pi-item-spacing pi-border-color'})
        infos = INFOS.copy()
        for i in infos.keys():
            info = getcontent(divs, i)
            infos[i] = info
        infos['Chapter'] = chapter
        datalist.append(infos.values())
    else:
        print('         [!] Problem with the page. Response code is', code)

database = pd.DataFrame(datalist, columns=infos.keys())
database.rename(columns = columnnames, inplace = True)
database[['release']] = database[['release']].astype(str)
# database[['release']] = database[['release']].apply(parser.parse)
database[['release']] = database[['release']].apply(pd.to_datetime)
database[['chapter', 'volume', 'pages']] = \
    database[['chapter', 'volume', 'pages']].apply(pd.to_numeric) 
database.to_csv(FILENAME, sep = ',', index=False, encoding = 'utf-8')
