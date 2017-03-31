from bitstring import Bits

#code = "01100000	01001010	01111100	01000011	11000100	00111000	11001000	10011001"
code = "01100010	00001010	10011111	"
instr = code.split("\t")

addr = 0
for i in instr:
    print addr,
    if (i[0:3] == '100'):
        print 'br', Bits(bin=i[3:8]).int
    if (i[0:3] == '101'):
        print 'brz', Bits(bin=i[3:8]).int
    if (i[0:3] == '000'):
        print 'addi', Bits(bin=i[6:8]).uint, '+=', i[3:6]
    if (i[0:3] == '001'):
        print 'subi', Bits(bin=i[6:8]).uint, '-=', i[3:6]
    if (i[0:4] == '0100'):
        print 'sr0', i[4:8]
    if (i[0:4] == '0101'):
        print 'srh0', i[4:8]
    if (i[0:6] == '011000'):
        print 'clr', i[6:8]
    if (i[0:4] == '0111'):
        print 'mov', Bits(bin=i[6:8]).uint, '=>', Bits(bin=i[4:6]).uint
    if (i[0:6] == '110000'):
        print 'mova'
    if (i[0:6] == '110001'):
        print 'movr', i[6:8]
    if (i[0:6] == '110010'):
        print 'movrhs', i[6:8]
    if (i[0:6] == '111111'):
        print 'pause'
    addr += 1
