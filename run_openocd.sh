#!/bin/sh
export JTAG_VPI_PORT=5555
./openocd/src/openocd -s ./openocd/tcl -f openocd_jtag_vpi.cfg
