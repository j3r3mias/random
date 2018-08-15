#!/usr/bin/python3
# -*- coding: UTF-8 -*-

import os, sys, time
import pyautogui, sys
import numpy as np
import cv2
from PIL import Image
from io import BytesIO
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import Select
from selenium.common.exceptions import *

font                   = cv2.FONT_HERSHEY_SIMPLEX
fontScale              = 1
fontColor              = (255,255,255)
lineType               = 2

count = 1000
REFPOINT = (260.0, -200.0)

patt1 = cv2.imread('neymar.png', cv2.IMREAD_GRAYSCALE)
sift = cv2.xfeatures2d.SIFT_create()
kp_image, desc_image = sift.detectAndCompute(patt1, None)
index_params = dict(algorithm=0, trees=5)
search_params = dict()
flann = cv2.FlannBasedMatcher(index_params, search_params)
 

def openSite():
    '''
    Open the website 
    '''

    mimeTypes =\
            'application/pdf,application/vnd.adobe.xfdf,application/vnd.fdf,application/vnd.adobe.xdp+xml'
    chrome_options = webdriver.ChromeOptions()
    chrome_options.add_argument("--disable-infobars")
    chrome_options.add_argument("--start-maximized")
    driver = webdriver.Chrome('/home/j3r3mias/Development/random/neyboy/chromedriver', chrome_options=chrome_options)
    driver.get('https://neyboy.com.br/')

    time.sleep(2)

    return driver

def calculateSlope(x1, y1, x2, y2):
    # print 'A:', x, y
    dx = (x2 - x1)
    dy = (y2 - y1)
    # print 'D:', dx, dy, dx/dy
    return dx / dy

# def getSlope():
def getSlope(driver):
    '''
    Capture a screenshoot and return slope of Neymar
    '''
    global count

    scr = driver.get_screenshot_as_png()
    scr = Image.open(BytesIO(scr))
    scr = np.asarray(scr, dtype=np.float32).astype(np.uint8)

    ## # Image need to be convert from BRG to RGB
    scr = cv2.cvtColor(scr, cv2.COLOR_BGR2RGB)

    # Tests with input dir
    # fn = 'input/' + str(count) + '.png'
    # scr = cv2.imread(fn, cv2.IMREAD_COLOR)
    # roi = scr[0:600, 200:600]

    # Region of Interest
    roi = scr[200:800, 420:950]
    
    grayframe = cv2.cvtColor(roi, cv2.COLOR_RGB2GRAY) # trainimage


    kp_grayframe, desc_grayframe = sift.detectAndCompute(grayframe, None)
    matches = flann.knnMatch(desc_image, desc_grayframe, k=2)
 
    good_points = []
    for m, n in matches:
        if m.distance < 0.6 * n.distance:
            good_points.append(m)

    if len(good_points) > 10:
        query_pts = np.float32([kp_image[m.queryIdx].pt for m in good_points]).reshape(-1, 1, 2)
        train_pts = np.float32([kp_grayframe[m.trainIdx].pt for m in good_points]).reshape(-1, 1, 2)
 
        matrix, mask = cv2.findHomography(query_pts, train_pts, cv2.RANSAC, 5.0)
        matches_mask = mask.ravel().tolist()
 
        # Perspective transform
        h, w = patt1.shape
        pts = np.float32([[0, 0], [0, h], [w, h], [w, 0]]).reshape(-1, 1, 2)
        dst = cv2.perspectiveTransform(pts, matrix)
 
        point = np.int32(dst)
        topmidx = (point[0][0][0] + point[3][0][0]) / 2.0
        topmidy = (point[0][0][1] + point[3][0][1]) / 2.0
        botmidx = (point[1][0][0] + point[2][0][0]) / 2.0
        botmidy = (point[1][0][1] + point[2][0][1]) / 2.0
 
        ans = calculateSlope(topmidx, topmidy, botmidx, botmidy)
        homography = cv2.polylines(roi, [np.int32(dst)], True, (255, 0, 0), 3)
        homography = cv2.line(homography, (int(topmidx), int(topmidy)), 
                              (int(botmidx), int(botmidy)), (0, 0, 0), 2)
        homography = cv2.putText(homography, str(ans), 
                                 (int(topmidx), int(topmidy)), font, fontScale,
                                 fontColor, lineType)

 
        cv2.imwrite('output/' + str(count) + '.png', homography)
        count = count + 1
    else:
        ans = 0
        # cv2.imwrite('output/' + str(count) + '.png', roi)
        # count = count + 1
    
    return ans

def main():
    ''' 
    Main
        - Abre site https://neyboy.com.br/
    '''

    driver = openSite()
    time.sleep(2)
    element = driver.find_element_by_xpath("//*[@class='sc-bwzfXH czumOQ']") 
    # ids = driver.find_elements_by_xpath('//*[@id]')
    # ids = driver.find_elements_by_xpath("//*[not(*)]")
    # for i in ids:
    #     print dir(i.get_attribute)
    #     break
    # element = driver.find_element_by_id(ids[0].get_attribute('id'))
    element.click()
    # time.sleep(0.1)

    for i in range(100000, 110100):
        slp = getSlope(driver)
        print slp
        if slp > -0.1 and slp < 0.1:
            continue
        elif slp > 1.5:
            pyautogui.click(x=850, y=550)
            pyautogui.click(x=850, y=550)
        elif slp > 0:
            pyautogui.click(x=850, y=550)
        elif slp < -1.5:
            pyautogui.click(x=530, y=550)
            pyautogui.click(x=530, y=550)
        elif slp < 0:
            pyautogui.click(x=530, y=550)
    driver.close()

if __name__ == '__main__':
    main()
