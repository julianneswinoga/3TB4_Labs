from bitstring import Bits

text = """clr 2
addi 2 1
addi 2 2
addi 2 3
addi 2 4
br -5"""

instr = text.split("\n")

for i in instr:
    code = i.split(" ")
    
    if (code[0] == 'br'):
        print '100'+Bits(int=int(code[1]), length=5).bin
    if (code[0] == 'brz'):
        print '101'+Bits(int=int(code[1]), length=5).bin
    if (code[0] == 'addi'):
        print '000'+Bits(uint=int(code[2]), length=3).bin+Bits(uint=int(code[1]), length=2).bin
    if (code[0] == 'subi'):
        print '001'+Bits(uint=int(code[2]), length=3).bin+Bits(uint=int(code[1]), length=2).bin
    if (code[0] == 'sr0'):
        print '0100'+code[1]
    if (code[0] == 'srh0'):
        print '0101'+code[1]
    if (code[0] == 'clr'):
        print '011000'+Bits(uint=int(code[1]), length=2).bin
    if (code[0] == 'mov'):
        print '0111'+Bits(uint=int(code[1]), length=2).bin+Bits(uint=int(code[2]), length=2).bin
    if (code[0] == 'mova'):
        print '110000'+Bits(uint=int(code[1]), length=2).bin
    if (code[0] == 'movr'):
        print '110001'+Bits(uint=int(code[1]), length=2).bin
    if (code[0] == 'movrhs'):
        print '110010'+Bits(uint=int(code[1]), length=2).bin
    if (code[0] == 'pause'):
        print '11111111'
