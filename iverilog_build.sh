#!/bin/sh
iverilog-vpi jtag_vpi.c
iverilog -g 2012 -s vsim_top -o vsim_top.vvp \
    -D VCS_VPI -D RANDOMIZE_REG_INIT -D RANDOMIZE_MEM_INIT -D RANDOMIZE_DELAY=2 \
    vsim_top.v jtag_vpi.v ../verilog/DigitalTop.v ../verilog/DigitalTop.behav_srams.v
