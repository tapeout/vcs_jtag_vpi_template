1. Download an openocd_riscv binary from https://github.com/edwardcwang/openocd_riscv/releases (or build it from source following the instructions at https://github.com/edwardcwang/openocd_riscv).
2. Edit `run_openocd.sh` to update the openocd install dir to reflect the above.
3. Edit the top-level Verilog `vsim_top.v` to instantiate your target design.
4. Build the VCS simulator with `./vcs_build.sh`.
5. Run the VCS simulator with `./run_sim.sh`.
6. In parallel, start OpenOCD with `./run_openocd.sh`.
7. In parallel as well, use either `client.sh` in the openocd_riscv repo, or `telnet localhost 4444` to load and run programs.
8. Use `./vpd2gz.sh` to create a `.vcd.gz` to transfer the waveforms. Run `gunzip -f out.vcd.gz` locally to view the resultant waveforms.

