import atheris
import sys

def roman2int_01(s):
    translations = {
            'I':    1,
            'V':    5,
            'X':   10,
            'L':   50,
            'C':  100,
            'D':  500,
            'M': 1000
            }
    number = 0
    s = s.replace('IV', 'IIII').replace('IX', 'VIIII')
    s = s.replace('XL', 'XXXX').replace('XC', 'LXXXX')
    s = s.replace('CD', 'CCCC').replace('CM', 'DCCCC')
    for c in s:
        number += translations[c]

    return number

def roman2int_02(s):
    return len(s.replace('IV', 4*'.').replace('IX',9*'.').replace('XL', 40*'.').replace('XC',90*'.').replace('CD',400*'.').replace('CM',900*'.').replace('M',1000*'.').replace('D',500*'.').replace('C',100*'.').replace('L',50*'.').replace('X',10*'.').replace('V',5*'.'))


def TestValues(inps):
    fdp = atheris.FuzzedDataProvider(inps)

    rvalue = fdp.ConsumeString(sys.maxsize)

    try:
        v1 = roman2int_01(rvalue)
    except Exception as e:
        return 0

    try:
        v2 = roman2int_02(rvalue)
    except Exception as e:
        return 0

    assert v1 == v2

atheris.Setup(sys.argv, TestValues, enable_python_coverage=True)
atheris.Fuzz()
