`timescale 1ns/100ps

`define CLOCK_PERIOD 50 // 50ns

module vsim_top();
  localparam CLOCK_PERIOD = `CLOCK_PERIOD;

  reg clock = 0;
  always #(CLOCK_PERIOD/2) clock <= ~clock; // 25ns*2 = 50ns = 20 MHz

  reg reset = 1;

  // JTAG wires
  wire TCK;
  wire TMS;
  wire TDI;
  wire TRSTn;
  wire TDO;

  // UART
  wire uart_txd;
  wire uart_rxd;

  // Tie off rxd for now.
  assign uart_rxd = 1'd0;

  wire t_io_clock_120MHz;
  // Tie it off
  assign t_io_clock_120MHz = 1'd0;

  EE194RocketTop t (
    .clock(clock),
    .io_reset_in(reset),
    .io_jtag_TCK(TCK),
    .io_jtag_TMS(TMS),
    .io_jtag_TDI(TDI),
    .io_jtag_TRSTn(TRSTn),
    .io_jtag_TDO(TDO),
    .io_uart_txd(uart_txd),
    .io_uart_rxd(uart_rxd),
    .io_clock_120MHz(t_io_clock_120MHz)
  );

  reg jtag_init_done = 0;
  jtag_vpi jtag (
    .tms(TMS),
    .tck(TCK),
    .tdi(TDI),
    .tdo(TDO),
    .enable(1'd1),
    .init_done(jtag_init_done)
  );
  
  // Run the simulation for 1000 clock cycles.
  /*
  initial begin
    #(CLOCK_PERIOD*1000);
    $finish;
  end
  */

  // Initialize jtag_vpi after 30 cycles.
  initial begin
    jtag_init_done = 0;
    #(CLOCK_PERIOD*30)
    jtag_init_done = 1;
  end

  // Hold reset high for the first 50 cycles.
  initial begin
    reset = 0;
    #(CLOCK_PERIOD*1)
    reset = 1;
    #(CLOCK_PERIOD*49)
    reset = 0;
  end

endmodule
