#!/usr/bin/python3
# -*- coding: UTF-8 -*-

import os, sys, time
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import Select
from selenium.common.exceptions import *

def openSite():
    '''
    Abre o site do Tribunal Regional Federal 
    '''

    global downloadPath
    
    mimeTypes =\
            'application/pdf,application/vnd.adobe.xfdf,application/vnd.fdf,application/vnd.adobe.xdp+xml'

    # Personaliza o Firefox para download automático, pasta onde serão salvos 
    # os arquivos, etc
    fp = webdriver.FirefoxProfile()
    fp.set_preference('browser.download.folderList', 2)
    fp.set_preference('browser.download.manager.showWhenStarting', False)
    fp.set_preference('browser.download.dir', downloadPath)
    fp.set_preference('browser.helperApps.neverAsk.saveToDisk', mimeTypes)
    fp.set_preference('plugin.disable_full_page_plugin_for_types', mimeTypes)
    fp.set_preference('pdfjs.disabled', True)
    
    driver = webdriver.Firefox(firefox_profile=fp)
    driver.get('https://www4.trf5.jus.br/diarioeletinternet/index.jsp')
    return driver

def getID(driver, s):
    '''
    Acha o elemento pelo ID
    '''
    
    return driver.find_element_by_id(s)

def expandTo100(driver):
    '''
    Expande os itens por página para 100
    '''

    select = Select(getID(driver, 'frmPesquisa:quantidadeRegistros'))
    select.select_by_index(4)
    pesquisar = getID(driver, 'frmVisao:j_id48' )
    pesquisar.click()

def isRegistros(driver):
    '''
    Verifica se a página possui algum item para download
    '''

    try:
        info = driver.find_element_by_class_name('msg-informacao')
        if 'Nenhum registro' in info.text:
            return False
    except NoSuchElementException:
        None
    return True

def selectAndGo(driver, org, edi, per):
    '''
    Seleciona as opções dos formulários
        - org: O índice do órgam
        - edi: O índice da edição
        - per: O período
    '''

    o = Select(getID(driver, 'frmVisao:orgao'))
    o.select_by_index(org)
    e = Select(getID(driver, 'frmVisao:edicao'))
    e.select_by_index(edi)
    p = Select(getID(driver, 'frmVisao:periodo'))
    p.select_by_index(per)
   
    pesquisar = getID(driver, 'frmVisao:j_id48' )
    pesquisar.click()
   
    registros = isRegistros(driver)
    
    if registros:
        expandTo100(driver)
    return registros

def isNonZeroFile(fPath):  
    '''
    Verifica se o arquivo existe e se ele não é vazio
    '''

    return os.path.isfile(fPath) and os.path.getsize(fPath) > 0

def download(driver):
    '''
    Faz o download após as opções terem sido selecionadas
    '''

    global firstDownload
    global downloadPath
    
    table = getID(driver, 'frmPesquisa:tDiarios:tb')
    options = table.find_elements_by_tag_name('tr')
    sizeOpt = len(options) + 1
    
    for i in range(1, sizeOpt):
        print('Baixando ', options[i - 1].text )
        xpath = '//html/body/div/div/div[4]/form[2]/div/table/tbody/tr/td/'
        xpath = xpath + 'table/tbody/tr[' + str(i) + ']/td[4]'
        down = driver.find_element_by_xpath(xpath)
        
        down.click()

        name = str(options[i - 1].text).replace('/', '-')
        name = name.replace(' ', '-')
        arg1 = downloadPath + 'Diário.pdf'
        arg2 = downloadPath + name + '.pdf'
       
        # Checagem do download (o Selenium não faz)
        while True:
            if isNonZeroFile(arg1):
                print('Download concluído')
                command = 'mv ' + arg1 + ' ' + arg2 
                print('Renomeando')
                os.system(command)
                while True:
                    if isNonZeroFile(arg2):
                        break
                    else:
                        print('Renomeando...')
                        time.sleep(2)
                break
            else:
                print('Download em andamento...')
                time.sleep(5)

def main():
    ''' 
    Main
        - arg1 [opcional]: Diretório onde serão salvos os arquivos
    '''

    global downloadPath

    if len(sys.argv) == 2:
        downloadPath = sys.argv[1] + '/arquivos/'
    else:
        downloadPath = os.getcwd() + '/arquivos/'
    os.system('mkdir -p ' + downloadPath)

    driver = openSite()

    # Lista os itens que serão percorridos
    orgaos    = getID(driver, 'frmVisao:orgao'  )
    edicao    = getID(driver, 'frmVisao:edicao' )
    periodo   = getID(driver, 'frmVisao:periodo')
    
    optOrgaos  = orgaos.find_elements_by_tag_name( 'option')
    optEdicao  = edicao.find_elements_by_tag_name( 'option')
    optPeriodo = periodo.find_elements_by_tag_name('option')
    
    sizeOrgaos  = len(optOrgaos )
    sizeedicao  = len(optEdicao )
    sizeperiodo = len(optPeriodo)

    for i in range(1, sizeOrgaos):
        for j in range(1, sizeedicao):
            for k in range(1, sizeperiodo):
                if selectAndGo(driver, i, j, k):
                    download(driver)
                else:
                    continue
    driver.close()

if __name__ == '__main__':
    main()
