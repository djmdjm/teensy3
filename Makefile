CPU=cortex-m4
MCU=mk20dx256 # For teensy_loader_cli

# Board support objects.
BOARD_OBJS=board/arm_cm4.o board/crt0.o board/sysinit.o

# Main program objects.
OBJS=$(BOARD_OBJS) main.o

CFLAGS= -Wall -fno-common -mthumb -mcpu=$(CPU)
LDSCRIPT= board/Teensy31_flash.ld
LDFLAGS= -nostartfiles -T$(LDSCRIPT) -mthumb -mcpu=$(CPU)
ASFLAGS= -mcpu=$(CPU)

# Tools
AR = arm-none-eabi-ar
AS = arm-none-eabi-as
CC = arm-none-eabi-gcc
LD = arm-none-eabi-ld
OBJCOPY = arm-none-eabi-objcopy
OBJDUMP = arm-none-eabi-objdump
SIZE = arm-none-eabi-size

all: firmware.hex

clean:
	rm -f firmware.hex firmware.S firmware.elf *.o board/*.o

dump: firmware.S

load: firmware.hex
	$(SUDO) teensy_loader_cli -v -w -mmcu=${MCU} firmware.hex

firmware.hex: firmware.elf
	$(OBJCOPY) -R .stack -O ihex firmware.elf $@

firmware.S: firmware.elf
	$(OBJDUMP) -D firmware.elf > firmware.S

firmware.elf: $(OBJS)
	$(CC) $(OBJS) $(LDFLAGS) -o $@

