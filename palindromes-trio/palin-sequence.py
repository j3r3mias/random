#!/usr/bin/python3
# -*- coding: utf-8 -*-

import multiprocessing
import numpy as np
from allyourbase import BaseConvert
from decimal import Decimal

basis = list(map(int, input().split()))
print(basis)
limit = int(input())

OUTPUT = 'result-sequence-' + '-'.join(str(x) for x in basis) + \
         '--' + str(limit) + '.txt'

def ispalindrome(s):
    return s == s[::-1]


def lol(interval):
    ans = []
    i = interval[0]
    while i < interval[1]:
        flag = True
        for b in basis:
            bas = BaseConvert(10, b)
            num = bas.encode(str(i))
            if not ispalindrome(num):
                flag = False
                break
        if flag:
            ans.append(i)
        i = i + 1
    # print(str(ans))
    return ans

p = multiprocessing.cpu_count()
intervals = []
for i in range(p):
    intervals.append([int(i * (limit / p)), int((i + 1) * (limit / p))])
# print(intervals)

pool = multiprocessing.Pool(processes = multiprocessing.cpu_count())
results = pool.map(lol, intervals)
 
result = list(map(int, np.concatenate(results)))
print(result)
f = open(OUTPUT, 'w')
f.write(str(result) + '\n')
f.close()
