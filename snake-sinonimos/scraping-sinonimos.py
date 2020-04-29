import requests, time
import pandas as pd
from bs4 import BeautifulSoup

URLBASE = 'https://www.sinonimos.com.br'
FIRSTWORD = '10'
URL = 'https://www.sinonimos.com.br'

nexthref = '/' + FIRSTWORD + '/'

count = 0
dataset = []
while True:
    nextword = nexthref.replace('/', '')
    count = count + 1
    print(count, ' - Next word:', nextword)
    url = URLBASE + nexthref
    content = requests.get(url).text
    bs = BeautifulSoup(content, features = 'html.parser')

    allsyns = bs.find_all('div', class_ = 's-wrapper')
    groups = [nextword]
    for a in allsyns:
        try:
            meaning = a.find('div', class_ = 'sentido').text.replace(':', ' ')
        except:
            meaning = ''
        syns1 = a.find_all('a', class_ = 'sinonimo')
        syns2 = a.find_all('span')
        sl = []
        # Words that are links (<a>)
        for s in syns1:
            sl.append(s.text)
        # Words that are not links (<span>)
        for s in syns2:
            sl.append(s.text)
        syn = meaning + str(sl).replace('\'', '').replace('[', '(').replace(']', ')')
        groups.append(syn)
    dataset.append(groups)
    try:
        nexthref = bs.find_all('ul', class_ = 'lig-next')[0].find('li').a['href']
    except:
        print('Next href not found. Saving progress.')
        break

    # Save a snapshot for each 10000
    if count % 10000 == 0:
        filename = 'base-sinonimos-' + str(time.time()).split('.')[0] + '-' + nextword + '.xlsx'
        database = pd.DataFrame(dataset)
        columnnames = list(database.columns)
        columnnames[0] = 'Palavra'
        database.columns = columnnames
        database.to_excel(filename, sheet_name='Sinonimos', index = False, encoding = 'utf-8', header = True)

# Final words it the scraper don't find a next word
filename = 'base-sinonimos-' + str(time.time()).split('.')[0] + '-' + nextword + '.xlsx'
database = pd.DataFrame(dataset)
columnnames = list(database.columns)
columnnames[0] = 'Palavra'
database.columns = columnnames
database.to_excel(filename, sheet_name='Sinonimos', index = False, encoding = 'utf-8', header = True)
