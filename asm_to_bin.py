from bitstring import Bits

text = """clr 2
addi 2 1
br -1"""

instr = text.split("\n")

for i in instr:
    code = i.split(" ")
    
    if (code[0] == 'br'):
        print '100'+Bits(int=int(code[1]), length=5).bin
    if (code[0] == 'brz'):
        print '101'+Bits(int=int(code[1]), length=5).bin
    if (code[0] == 'addi'):
        print int(code[2])
        print '000'+Bits(uint=int(code[2]), length=3).bin+Bits(uint=int(code[1]), length=2).bin
    if (code[0] == 'subi'):
        print '001'+Bits(uint=int(code[2]), length=3).bin+Bits(uint=int(code[1]), length=2).bin

    if (code[0] == 'clr'):
        print '011000'+Bits(uint=int(code[1]), length=2).bin
    if (code[0] == 'mov'):
        print '0111'+Bits(uint=int(code[1]), length=2).bin+Bits(int=uint(code[2]), length=2).bin

    if (code[0] == 'pause'):
        print '11111111'
