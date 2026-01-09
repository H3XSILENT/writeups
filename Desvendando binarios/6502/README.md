# hardcore
## writing  instruction of 6502
Build a 6502 computer

Learn how computers work by building and programming a computer with the classic 6502 microprocessor. This was the first truly low-cost microprocessor that started the personal-computing revolution. Versions of 6502 found their way into the Atari 2600, Apple II, Nintendo Entertainment System, Commodore 64, Atari Lynx, BBC Micro and many other computers and game consoles of the era.

---
## Estruct
```mm
0x0000 - 0x0100-0x01FF - Stack
0x1000
0x2000
0x3000 - 0x0000-ox3FFF - RAM
0x4000
0x5000
0x6000 - 0x6000-0x600F - trava
0x7000
0x8000 - EEPROM
0x9000
0xA000
0xB000
0xC000
0xD000
0xE000
0xF000 - 0xFFFC-0xFFD (reset vector)
---

copiling [blink.s](blink.s):
```bash
vasm6502_oldstyle -Fbin -dot blink.s
```
copiling for arduino:
```bash
hexdump -C a.out
```
writing of eeprom:
```Bash
minipro -p AT28C256 -w a.out
```
