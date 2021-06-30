# Porsche Anti-Theft System
29 April 2021 - 10 May 2021

A project done by me under the Electronics Club of Indian Institute of Technology, Guwahati

In this project, I built an [anti-theft system](http://web.mit.edu/6.111/volume2/www/f2019/handouts/labs/lab4_19/index.html) for a two-seater car using verilog.
I performed design synthesis, implementation and bitstream generation using Xilinx Vivado (https://www.xilinx.com/products/design-tools/vivado.html) and tested the circuit on the [Zybo Z7-20: Zynq-7000 ARM/FPGA SoC Development Board](https://store.digilentinc.com/zybo-z7-zynq-7000-arm-fpga-soc-development-board/).
As the FPGA has only 4 switches, 4 push buttons and we did not have a speaker, the speaker module and the functionality to reprogram the time parameters were removed for implementation on the FPGA. The siren generator module has been separately written and the time parameters reprogramming was checked through a separate module and testbench.
