
PROJECT = Lab1

# System configuration
CC = arm-none-eabi-gcc#arm-atollic-eabi-gcc
RM=rm -rf

# Assembler, Compiler and Linker flags and linker script settings
LINKER_FLAGS=-lm -mthumb -mhard-float -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -Wl,--gc-sections -T$(LINK_SCRIPT) -static  -Wl,--start-group -lc -lm -Wl,--end-group -specs=nosys.specs  -Wl,-cref "-Wl,-Map=$(BIN_DIR)/$(PROJECT).map" -Wl,--defsym=malloc_getpagesize_P=0x1000
LINK_SCRIPT="stm32f4_flash.ld"
ASSEMBLER_FLAGS=-c -g -O0 -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mthumb -mhard-float -D"HSE_VALUE=8000000" -D"USE_STM32F429I_DISCO" -D"STM32F42_43xxx" -D"USE_STDPERIPH_DRIVER"  -x assembler-with-cpp  -IUtilities/Common -IUtilities/STM32F429I-Discovery -Isrc -ILibraries/CMSIS/Include -ILibraries/Device/ST/STM32F4xx/Include -ILibraries/STM32F4xx_StdPeriph_Driver/inc
COMPILER_FLAGS=-c -g -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -O0 -Wall -ffunction-sections -fdata-sections -mthumb -mhard-float -D"HSE_VALUE=8000000" -D"USE_STM32F429I_DISCO" -D"STM32F42_43xxx" -D"USE_STDPERIPH_DRIVER"   -IUtilities/Common -IUtilities/STM32F429I-Discovery -Isrc -ILibraries/CMSIS/Include -ILibraries/Device/ST/STM32F4xx/Include -ILibraries/STM32F4xx_StdPeriph_Driver/inc 

# Define output directory
OBJECT_DIR = Debug
BIN_DIR = $(OBJECT_DIR)

# Define sources and objects
SRC := $(wildcard */*/*/*/*/*/*/*.c) \
	$(wildcard */*/*/*/*/*/*.c) \
	$(wildcard */*/*/*/*/*.c) \
	$(wildcard */*/*/*/*.c) \
	$(wildcard */*/*/*.c) \
	$(wildcard */*/*.c) \
	$(wildcard */*.c)
SRCSASM := 	$(wildcard */*/*/*/*/*/*/*/*.s) \
	$(wildcard */*/*/*/*/*/*/*.s) \
	$(wildcard */*/*/*/*/*/*.s) \
	$(wildcard */*/*/*/*/*.s) \
	$(wildcard */*/*/*/*.s) \
	$(wildcard */*/*/*.s) \
	$(wildcard */*/*.s) \
	$(wildcard */*.s)
OBJS := $(SRC:%.c=$(OBJECT_DIR)/%.o) $(SRCSASM:%.s=$(OBJECT_DIR)/%.o)
OBJS := $(OBJS:%.S=$(OBJECT_DIR)/%.o)  

###############
# Build project
# Major targets
###############
all: buildelf buildbin

buildelf: $(OBJS) 
	$(CC) -o "$(BIN_DIR)/$(PROJECT).elf" $(OBJS) $(LINKER_FLAGS)
	
buildbin: $(BIN_DIR)/$(PROJECT).elf
	arm-none-eabi-objcopy -O binary $(BIN_DIR)/$(PROJECT).elf $(BIN_DIR)/$(PROJECT).bin
	
flash: $(BIN_DIR)/$(PROJECT).bin
	ST-LINK_CLI -P $(BIN_DIR)/$(PROJECT).bin 0x08000000

clean:
	$(RM) $(OBJS) "$(BIN_DIR)/$(PROJECT).elf" "$(BIN_DIR)/$(PROJECT).map"


##################
# Specific targets
##################
$(OBJECT_DIR)/src/main.o: src/main.c
	@mkdir $(subst /,\,$(dir $@)) || echo off
	$(CC) $(COMPILER_FLAGS) src/main.c -o $(OBJECT_DIR)/src/main.o 


##################
# Implicit targets
##################
$(OBJECT_DIR)/%.o: %.c
	@mkdir $(subst /,\,$(dir $@)) || echo off
	$(CC) $(COMPILER_FLAGS) $< -o $@

$(OBJECT_DIR)/%.o: %.s
	@mkdir $(subst /,\,$(dir $@)) || echo off
	$(CC) $(ASSEMBLER_FLAGS) $< -o $@
	
$(OBJECT_DIR)/%.o: %.S
	@mkdir $(subst /,\,$(dir $@)) || echo off
	$(CC) $(ASSEMBLER_FLAGS) $< -o $@