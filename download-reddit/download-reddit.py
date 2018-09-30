#!/usr/bin/python
# -*- coding: utf-8 -*-

import configparser, logging, os
import re, time
from PIL import Image
import json, urllib
import subprocess
import uuid
import sys


def downloadreddit(link):
    '''
    Download Reddit Link
    '''

    response = urllib.urlopen(link + '.json')
    while response.getcode() == 429:
        print ' [+] Too many requests'
        time.sleep(1)
        response = urllib.urlopen(link + '.json')
    if response.getcode() != 200:
        print ' [-] Problem:', response.getcode()
        return

    data = json.loads(response.read())

    title = data[0]['data']['children'][0]['data']['title']
    fallbackurl = data[0]['data']['children'][0]['data']['secure_media']['reddit_video']['fallback_url']
    videoname = uuid.uuid4().hex[:6].upper()
    urllib.urlretrieve(fallbackurl, videoname)
    print ' [+] Video convert...'
    with open(os.devnull, 'w') as devnull:
        subprocess.call(['ffmpeg', '-i', videoname, videoname + \
                        '.mp4'], stdout=devnull, stderr=devnull)
    subprocess.call(['rm', videoname])

    audiourl = re.sub('/[\w\d]+$', '/audio', fallbackurl)
    audioresponse = urllib.urlopen(audiourl)
    if audioresponse.getcode() == 200:
        audioname = uuid.uuid4().hex[:6].upper()
        finalvideo = uuid.uuid4().hex[:6].upper()
        urllib.urlretrieve(audiourl, audioname)
        print ' [+] Audio convert...'
        with open(os.devnull, 'w') as devnull:
            subprocess.call(['ffmpeg', '-i', audioname, '-acodec',
                             'mp3', audioname + '.mp3'],
                             stdout=devnull, stderr=devnull)
        subprocess.call(['rm', audioname])
        print ' [+] Merge audio and video...'
        with open(os.devnull, 'w') as devnull:
            subprocess.call(['ffmpeg', '-i', videoname + '.mp4', 
                             '-i', audioname + '.mp3', '-c',
                             'copy', finalvideo + '.mp4'], stdout=devnull,
                             stderr=devnull)
        subprocess.call(['rm', audioname + '.mp3'])
        subprocess.call(['rm', videoname + '.mp4'])
        videoname = finalvideo
    subprocess.call(['mv',  videoname + '.mp4', title + '.mp4'])
    print ' [+] Name:', title


def main():
    if len(sys.argv) != 2:
        sys.exit()
    else:
        link = sys.argv[1]
    downloadreddit(link)

if __name__ == '__main__':
    main()
