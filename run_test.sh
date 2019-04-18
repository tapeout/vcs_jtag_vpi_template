cd ../sdk
./build.sh
cd ../vcs_jtag_vpi_template
./iverilog_build.sh
./run_iverilog.sh &
RUNNING_PID=$!
sleep 5
./run_openocd_auto.sh
sleep 600
kill -- -$$
