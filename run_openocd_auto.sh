#!/bin/sh
# EDIT THIS LINE
export OPENOCD_INSTALL_DIR="./openocd-20171229"

export OPENOCD_BIN="$OPENOCD_INSTALL_DIR/bin/openocd"

export JTAG_VPI_PORT=5555
$OPENOCD_BIN -s "$OPENOCD_INSTALL_DIR/share/openocd/scripts" -f openocd_jtag_vpi_auto.cfg -c "load_image ../sdk/software/bletest/bletest" -c "resume 0x20000000" -c "exit"
echo "Exiting openocd"
