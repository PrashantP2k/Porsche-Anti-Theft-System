# Car-Anti-Theft-Alarm-System
A project done by me under the Electronics Club of Indian Institute of Technology, Guwahati

In this project, we build an anti-theft system for a two-seater car using verilog (http://web.mit.edu/6.111/volume2/www/f2019/handouts/labs/lab4_19/index.html).
I performed design synthesis, implementation and bitstream generation and tested the circuit on the Zybo-Z7-20: Zynq-7000 ARM/FPGA SoC Development Board.
As the FPGA has only 4 switches, 4 push buttons and we did not have a speaker, the speaker module and the functionality to reprogram the time parameters were removed for implementation on the FPGA. The siren generator module has been separately written. The time parameters reprogramming was checked with simulation only.
