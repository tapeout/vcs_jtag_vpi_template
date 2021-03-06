`timescale 1ns/100ps

`define CLOCK_PERIOD 100 // 100ns

module vsim_top();
  localparam CLOCK_PERIOD = `CLOCK_PERIOD;
  localparam ADC_SAMPLE_PERIOD = 25; // 25 ns = 40 Mhz
  localparam PI = 3.1415;

  // Output
  wire [2:0] gfsk_out;

  reg [4:0] I;
  reg [4:0] Q;

  real phase;
  real freq;
  real s;
  real c;
  reg gfsk_started;
  initial begin
    phase = 0;
    gfsk_started = 0;
  end

  always #ADC_SAMPLE_PERIOD begin
    freq = (2250000.0 + gfsk_out * 62500.0) / 1000000000.0; // freq in Ghz so 1/freq is in ns
    phase = phase + (2*PI*ADC_SAMPLE_PERIOD * freq);
    if (phase > 2*PI) begin
      phase = phase - 2*PI;
    end
    I <= 16 + 10 * $sine(phase);
    Q <= 16 + 10 * $cosine(phase);
    
    if (gfsk_out != 3'd0) begin
      gfsk_started = 1'b1;
    end
  end
   
  reg clock = 1;
  always #(CLOCK_PERIOD/2) clock <= ~clock; // 50ns*2 = 100ns = 10 MHz
  
  reg clock40 = 1;
  always #(12.5) clock40 <= ~clock40; // 12.5ns*2 = 25ns = 40 MHz

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

  EE194CoreTop t (
    .clock(clock),
    .reset(reset),
    .io_jtag_TCK(TCK),
    .io_jtag_TMS(TMS),
    .io_jtag_TDI(TDI),
    .io_jtag_TRSTn(TRSTn),
    .io_jtag_TDO(TDO),
    .io_uart_txd(uart_txd),
    .io_uart_rxd(uart_rxd),
    .io_gfskout(gfsk_out),
    .io_scanchain_PHI(1'd0),
    .io_scanchain_PHIB(1'd0),
    .io_scanchain_i0o1(1'd0),
    .io_scanchain_LOAD(1'd0),
    .io_scanchain_SCAN_IN(1'd0),
    .io_scanchain_SCAN_OUT(),
    .io_gpio_pins_0_i_ival(1'd0), // @[:ee194.DigitalTop.EE194BoomConfig.fir@237782.4]
    .io_gpio_pins_1_i_ival(1'd0), // @[:ee194.DigitalTop.EE194BoomConfig.fir@237782.4]
    .io_gpio_pins_2_i_ival(1'd0), // @[:ee194.DigitalTop.EE194BoomConfig.fir@237782.4]
    .io_gpio_pins_3_i_ival(1'd0), // @[:ee194.DigitalTop.EE194BoomConfig.fir@237782.4]
    .io_clock_40MHz(clock40), // @[:ee194.DigitalTop.EE194BoomConfig.fir@237782.4]
    .io_isig(I), // @[:ee194.DigitalTop.EE194BoomConfig.fir@237782.4]
    .io_qsig(Q), // @[:ee194.DigitalTop.EE194BoomConfig.fir@237782.4]
    .io_enable_scan_global(1'd0), // @[:ee194.DigitalTop.EE194BoomConfig.fir@237782.4]
    .io_alternate_modulation_in(1'd0), // @[:ee194.DigitalTop.EE194BoomConfig.fir@237782.4]
    .io_modulator_bypass_force(1'd0) // @[:ee194.DigitalTop.EE194BoomConfig.fir@
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
    `ifdef VCD
      $vcdpluson(0);
      $vcdplusmemon(0);
    `endif
    reset = 1;
    #(CLOCK_PERIOD*50)
    reset = 0;
  end

endmodule
