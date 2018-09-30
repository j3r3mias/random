#!/usr/bin/python3
# -*- coding: utf-8 -*-

from allyourbase import BaseConvert
from decimal import Decimal
import pandas as pd
import ast
import sys
import re

fname = sys.argv[1]
if fname == '':
    sys.exit()

basis = list(map(int, re.findall('\d+', fname)[:-1]))

if len(basis) == 0:
    sys.exit()

flist = open(fname).readlines()[0]
numbers = list(map(int, re.findall('\d+', flist)))
print(numbers)

for i in numbers:
    print('Decimal: ' + str(i))
    for j in basis:
        b = BaseConvert(10, j)
        num = b.encode(str(i))
        print('base ' + str(j) + ' - ' + str(num))
    print('')
