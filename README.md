1. Edit the top-level Verilog `vsim_top.v` to instantiate your target design.
2. Build the VCS simulator with `./vcs_build.sh`.
3. Run the VCS simulator with `./run_sim.sh`.
4. In parallel, start OpenOCD with `./run_openocd.sh`.
5. In parallel as well, use either `client.sh` in the openocd_riscv repo, or `telnet localhost 4444` to load and run programs.
6. Use `./vpd2gz.sh` to create a `.vcd.gz` to transfer the waveforms. Run `gunzip -f out.vcd.gz` locally to view the resultant waveforms.

