a = 23
b = 34
c = 56
d = 99
e = 10
f = 54
g = 1
h = 88

parity = a ^ b ^c ^ d ^ e ^ f ^ g ^ h

newh = 2
newparity = (parity ^ h) ^ newh

checkparity = a ^ b ^ c ^ d ^ e ^ f ^ g ^ newh

print newparity, checkparity
