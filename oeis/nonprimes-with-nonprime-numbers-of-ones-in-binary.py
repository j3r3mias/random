#!/usr/bin/python
import sympy

# [n for n in (0..100) if (not n.is_prime()) and (not ZZ(sum(n.digits(2))).is_prime())]


out = ''
for i in range(400):
    if sympy.isprime(i):
        continue
    number_of_bits_one_in_i = bin(i).count("1")
    if not sympy.isprime(number_of_bits_one_in_i):
        nv = f'{i}, '
        print(nv, end = '')

        if len(out) + len(nv) < 260:
            out += nv
print()
print(out)