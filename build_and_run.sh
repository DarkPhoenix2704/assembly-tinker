#!/bin/bash

# Compile bootloader
#nasm -f bin bootloader.asm -o bootloader.bin
nasm -f bin calculator.asm -o bootloader.bin


# Compile kernel
gcc -m32 -c kernel.c -o kernel.o -ffreestanding -fno-pie

# Link kernel
ld -m elf_i386 -T linker.ld kernel.o -o kernel.bin -nostdlib

# Create disk image
dd if=/dev/zero of=os-image.bin bs=512 count=2880
dd if=bootloader.bin of=os-image.bin conv=notrunc
dd if=kernel.bin of=os-image.bin seek=1 conv=notrunc

# Run in QEMU
qemu-system-i386 -fda os-image.bin
