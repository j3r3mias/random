#!/usr/bin/python3
# -*- coding: utf-8 -*-

import multiprocessing
import pandas as pd
from itertools import combinations 
from allyourbase import BaseConvert
from decimal import Decimal
import time, sys
OUTPUT = 'palin-sets-result.csv'

def ispalindrome(s):
    return s == s[::-1]

def checkcomb(c):
    print('Next: ', c)
    l = []
    for n in range(0, 100):
        flag = True
        for b in c:
            bas = BaseConvert(10, b)
            num = bas.encode(str(n))
            if not ispalindrome(num):
                flag = False
                break
        if flag:
            l.append(n)
    if len(l) > 3 and max(l) > 16:
        print(str(c), str(l))
        return (c, l)


if __name__ == '__main__':
    p = multiprocessing.Pool(processes = multiprocessing.cpu_count())
    allcombinations = list(combinations(range(2, 6), 2)) #+ \
           # list(combinations(range(2, 17), 4))
    print(len(allcombinations))
    results = p.map(checkcomb, allcombinations)
    sets = []
    numbers = []
    for i in results:
        if i:
            sets.append(i[0])
            numbers.append(i[1])
    dbans = pd.DataFrame(list(zip(sets, numbers)), columns=['comb', 'list'])
    dbans.to_csv(OUTPUT, index=False, sep=';')
