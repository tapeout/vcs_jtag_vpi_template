cd ../sdk
./build.sh
cd ../vcs_jtag_vpi_template
./iverilog_build.sh
timeout 10h ./run_iverilog.sh 2> sim.log &
sleep 5
./run_openocd_auto.sh
wait
