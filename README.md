# 8259 PIC Project
## Overview
This is the Computer Architecture project 8259 Programmable interrupt controller, PIC is an integrated circuit that helps a 8086 CPU handle interrupt requests (IRQs) coming from multiple different sources (like external I/O devices) which may occur at the same time. It helps prioritize IRQs so that the CPU switches execution to the most appropriate interrupt handler (ISR) after the PIC assesses the IRQs' relative priorities. interrupt priority implemented is rotating priorities it has EOI modes which includes specific end of interrupt, unspecific end of interrupt and automatic end of interrupt.
## Modules
### Read Write logic
#### Reading mode
- The input status of several internal registers can be read by the cpu to update the user information on the system.
#### Write mode
- CPU sends a command to initilize PIC using ICWs OCWs. 
### Control logic
- It contains the Initialization Command Word (ICW) registers and Operation Command Word (OCW) registers which store the various control formats for device operation.
- It handels the cascading of multiple PICs.
### Interrupt request register (IRQ)
- The IRR is used to store all the interrupt levels which are requesting service.
- It has 2 modes edge triggering and level triggering.
### Priority resolver
- This logic block determines the priorites of the bits set in the IRR. The highest priority is selected and strobed into the corresponding bit of the ISR during INTA pulse.
### Interrupt service register
- The ISR is used to store all the interrupt levels which are being serviced.
## Sequance of operations
1. One or more of the INTERRUPT REQUEST lines (IR7±0) are raised high, setting the corresponding IRR bit(s).
2. The 8259A evaluates these requests, and sends an INT to the CPU, if appropriate.
3. The CPU acknowledges the INT and responds with an INTA pulse.
4. Upon receiving an INTA from the CPU group, the highest priority ISR bit is set and the corresponding IRR bit is reset. The 8259A does not drive the Data Bus during this cycle.
5. The 8086 will initiate a second INTA pulse. During this pulse, the 8259A releases an 8-bit pointer onto the Data Bus where it is read by the CPU.
6. This completes the interrupt cycle. In the AEOI mode the ISR bit is reset at the end of the second INTA pulse. Otherwise, the ISR bit remains set until an appropriate EOI command is issued at the end of the interrupt subroutine.

## Authors 

| # | Name  | ID | Contribution |
| - |------------- | ------- |------|
| 1 |[Fathy Abdlhady Fathy](https://github.com/FathyAbdlhady)  | 2001152 | Part of Control logic, Top module testbench |
| 2 |[Youssef Wael Hamdy Ibrahim Ashmawy](https://github.com/youssefashmawy)  | 2001430 | Read-Write logic, R/W logic testbench |
| 3 |[Yousef Shawky Mohamed](https://github.com/thedarkevil987)  | 2001500 | Priority resolver, PR testbench |
| 4 |[Omar Saleh Mohamed Abdo](https://github.com/MrMariodude)  | 2001993 | ISR, ISR testbench |
| 5 |[Ahmed Ayman Abd El Fatah](https://github.com/AhmedAyman2000128) | 2000128 | Part of Control logic, Top module |
| 6 |[Fady Adel Botros](https://github.com/FadyAdel10) | 2001388 | IRQs, IRQs testbench |
