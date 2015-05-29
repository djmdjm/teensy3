CPU=cortex-m4
MCU=mk20dx256 # For teensy_loader_cli

# Main program objects.
OBJS=main.o

CFLAGS= -Wall -g -fno-common -mthumb -mcpu=$(CPU)
LDSCRIPT= board/Teensy31_flash.ld
LDFLAGS= -nostartfiles -T$(LDSCRIPT) -mthumb -mcpu=$(CPU)
ASFLAGS= -mcpu=$(CPU)

# Board support objects.
BOARD_OBJS=arm_cm4.o crt0.o sysinit.o
VPATH=board

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
	rm -f firmware.hex firmware.S firmware.elf *.o

dump: firmware.S
	cat firmware.S

load: firmware.hex
	$(SUDO) teensy_loader_cli -v -w -mmcu=${MCU} firmware.hex

firmware.hex: firmware.elf
	$(OBJCOPY) -R .stack -O ihex firmware.elf $@

firmware.S: firmware.elf
	$(OBJDUMP) -S -D firmware.elf > firmware.S

firmware.elf: $(BOARD_OBJS) $(OBJS)
	$(CC) $(BOARD_OBJS) $(OBJS) $(LDFLAGS) -o $@
