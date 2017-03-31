from bitstring import Bits

'''text = """clr 2
addi 2 1
addi 2 2
addi 2 3
addi 2 4
br -5"""
'''
text = raw_input("Assembly:").lower()

filename = "Lab5/instruction_rom.mif"

instruction_rom = open(filename, "r+")
filecontents = instruction_rom.read()
instruction_rom.close()
instruction_rom = open(filename, "w+")
filecontents = filecontents[:filecontents.find("CONTENT BEGIN")]

mifappend = "CONTENT BEGIN\n"
instr = text.split("\n")
line = 0
for i in instr:
    code = i.split(" ")
    mifappend += "\t" + str(line) + " : "
    
    if (code[0] == 'br'):
        mifappend += '100'+Bits(int=int(code[1]), length=5).bin
    if (code[0] == 'brz'):
        mifappend += '101'+Bits(int=int(code[1]), length=5).bin
    if (code[0] == 'addi'):
        mifappend += '000'+Bits(uint=int(code[2]), length=3).bin+Bits(uint=int(code[1]), length=2).bin
    if (code[0] == 'subi'):
        mifappend += '001'+Bits(uint=int(code[2]), length=3).bin+Bits(uint=int(code[1]), length=2).bin
    if (code[0] == 'sr0'):
        mifappend += '0100'+code[1]
    if (code[0] == 'srh0'):
        mifappend += '0101'+code[1]
    if (code[0] == 'clr'):
        mifappend += '011000'+Bits(uint=int(code[1]), length=2).bin
    if (code[0] == 'mov'):
        mifappend += '0111'+Bits(uint=int(code[1]), length=2).bin+Bits(uint=int(code[2]), length=2).bin
    if (code[0] == 'mova'):
        mifappend += '110000'+Bits(uint=int(code[1]), length=2).bin
    if (code[0] == 'movr'):
        mifappend += '110001'+Bits(uint=int(code[1]), length=2).bin
    if (code[0] == 'movrhs'):
        mifappend += '110010'+Bits(uint=int(code[1]), length=2).bin
    if (code[0] == 'pause'):
        mifappend += '11111111'
    mifappend += ";\n"
    line += 1
mifappend += "\t["+str(line + 1)+"..255] : 00000000;\nEND;\n"

print filecontents + mifappend

instruction_rom.write(filecontents + mifappend)
instruction_rom.close()
