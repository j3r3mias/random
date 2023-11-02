#!/usr/bin/python
# -*- coding: UTF-8 -*-

import os, sys, time, re
import requests
from bs4 import BeautifulSoup
import pandas as pd

FILENAME = 'boku-no-hero-popularity-polls.csv'
URLBASE = 'https://myheroacademia.fandom.com/wiki/Popularity_Polls'
INFOS = {'Poll': '', 'Character': '', 'Rank': '', 'Votes': '', 'URL': ''}

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
code = 0
while code != 200:
    print(' [+] Trying to connect and retrieve the content...')
    response = requests.get(URLBASE)
    code = response.status_code
    time.sleep(3)
print('     [+] Done!')

content = response.content
soup = BeautifulSoup(content, features = 'html.parser')
divs = soup.find_all('div', {"class": 'tabber wds-tabber'})
japan_polls = divs[0].find_all('tbody')

datalist = []
for poll in japan_polls:
    trs = poll.find_all('tr')
    poll_title = trs[0].find('p').text
    print(f' [+] {poll_title}')
    for tr in trs[1:]:
        infos = INFOS.copy()
        tds = tr.find_all('td')
        ths = tr.find_all('th')

        rank = ths[0].text.replace('\n', '')

        if len(tds) == 0:
            img_url = ths[1].find('img')['src']
            if 'static' not in img_url:
                img_url = ths[1].find('img')['data-src']
            name = ths[2].text.replace('\n', '')
            votes = int(ths[3].text.split(' ')[0].replace(',', ''))
        else:
            img_url = tds[0].find('img')['data-src']
            name = ths[1].text.replace('\n', '')
            try:
                votes = int(ths[2].text.split(' ')[0].replace(',', ''))
            except:
                print(f' [!] Votes for {name} not found. Using the previous one: {votes}')

        infos['Poll'] = poll_title
        infos['Character'] = name
        infos['Rank'] = rank
        infos['Votes'] = votes
        infos['URL'] = img_url
        datalist.append(infos.values())

database = pd.DataFrame(datalist, columns=INFOS.keys())
database = database.reset_index().pivot_table(index = 'Character', columns = 'Poll', values = 'Votes')
database.to_csv(FILENAME, sep = ';', index = True, encoding = 'utf-8')

