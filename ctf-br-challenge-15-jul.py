from baseconv import BaseConverter

string =['2d', '33', '2g', '1i', '2c', '31', '4f', '20', '1p', '3e', '1o',
'3n', '3e', '1l', '3e', '3i', '1p', '46', '1p', '40', '3n', '1l', '3e', '1p',
'45', '49', '1m', '3e', '1o', '3n', '3e', '3h', '3g', '47', '3k', '3e', '1n',
'21', '4h'];

full = '0123456789abcdefghijklmnopqrstuvxwyz'

size = len(full)

zero = 0

for i in string:
    if ord(i[1]) > zero:
        zero = ord(i[1])

for i in range((full.find(chr(zero)) + 1), size):
    base = BaseConverter(full[0:i])
    result = []
    for j in string:
        result.append(int(base.decode(j)))
    text = ''.join(chr(c) for c in result)
    print text
