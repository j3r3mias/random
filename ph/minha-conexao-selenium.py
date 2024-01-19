#!/usr/bin/python

import json
import requests

from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium import webdriver
from time import sleep

URL = 'https://www.minhaconexao.com.br/'
URL_TO_SEND_RESULTS = 'http://127.0.0.1' # Imagine um grafana aqui

service = Service()
options = webdriver.ChromeOptions()
# options.add_argument('--headless=new')     # Descomente para rodar em background
driver = webdriver.Chrome(service=service, options=options)

driver.get(URL)

iniciar = driver.find_element(By.XPATH, "//div[contains(@onclick,'onClickStartButtonSpeedTestSectionSpeedometer')]")
iniciar.click()

while driver.current_url == URL:
    sleep(3)

spans = driver.find_elements(By.TAG_NAME, 'span')
latenciaflag = downloadflag = uploadflag = False
latencia = download = upload = -1
for i, span in enumerate(spans):
    if span.text == '(Latência)':
        latencia = spans[i + 1].text
        latenciaflag = True

    if span.text == '(Baixar dados)':
        download = spans[i + 1].text
        downloadflag = True
    
    if span.text == '(Enviar dados)':
        upload = spans[i + 1].text
        uploadflag = True

    if latenciaflag and downloadflag and uploadflag:
        break

data = {
    'latencia': latencia,
    'download': download,
    'upload': upload,
    'url': driver.current_url
}

requests.put(
                URL_TO_SEND_RESULTS, 
                data=json.dumps(data),
                headers = {'Content-type': 'application/json'}
            )

driver.quit()

