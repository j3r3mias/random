#!/usr/bin/python3
# -*- coding: utf-8 -*-

from allyourbase import BaseConvert
from decimal import Decimal
import pandas as pd
import ast

dbfile = pd.read_csv('results-palin-all.txt', sep=';')
for i in range(len(dbfile)):
    numbers = ast.literal_eval(dbfile.iloc[i][1].replace(' [', '['))
    basis   = ast.literal_eval(dbfile.iloc[i][0])
    print('B: ' + str(basis) + ' - ' + 'L: ' + str(numbers))
    for j in numbers:
        print('Decimal: ' + str(j))
        for k in basis:
            b = BaseConvert(10, k)
            num = b.encode(str(j))
            print('base ' + str(k) + ' - ' + str(num))
        print('')
