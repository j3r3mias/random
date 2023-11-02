#!/usr/bin/python
import sympy

out = ''
for i in range(400):
    if sympy.isprime(i):
        continue
    number_of_bits_one_in_i = bin(i).count("1")
    if sympy.isprime(number_of_bits_one_in_i):
        nv = f'{i}, '
        print(nv, end = '')

        if len(out) + len(nv) < 260:
            out += nv
print()
print(out)