module mojo_top(
    // 50MHz clock input
    input clk,
    // Input from reset button (active low)
    input rst_n,
    // cclk input from AVR, high when AVR is ready
    input cclk,
    // Outputs to the 8 onboard LEDs
    output[7:0]led,
    // AVR SPI connections
    output spi_miso,
    output clk_o,
    output clk_slow_o,
    input spi_ss,
    input spi_mosi,
    input spi_sck,
    // AVR ADC channel select
    output [3:0] spi_channel,
    // Serial connections
    input avr_tx, // AVR Tx => FPGA Rx
    output avr_rx, // AVR Rx => FPGA Tx
    input avr_rx_busy, // AVR Rx buffer full
    output pwm_o,
    output[9:0] signal
    );

wire rst = ~rst_n; // make reset active high

// these signals should be high-z when not used
assign spi_miso = 1'bz;
assign avr_rx = 1'bz;
assign spi_channel = 4'bzzzz;

assign led = 8'b1;
assign clk_o = clk;

/** avr interface
 *  get adc values from pin A0
 */
wire new_sample;//flag that a new sample is ready
wire [9:0] sample_value;
wire [3:0] sample_channel;

avr_interface avr_interface (
    .clk(clk),
    .rst(rst),
    .cclk(cclk),
    .spi_miso(spi_miso),
    .spi_mosi(spi_mosi),
    .spi_sck(spi_sck),
    .spi_ss(spi_ss),
    .spi_channel(spi_channel),
    .tx(avr_rx),
    .rx(avr_tx),
    .channel(4'b0),//sample at pinA0
    .new_sample(new_sample),
    .sample(sample_value),
    .sample_channel(sample_channel),
    .tx_data(8'h00),
    .new_tx_data(1'b0),
    .tx_busy(),
    .tx_block(avr_rx_busy),
    .rx_data(),
    .new_rx_data()
  );



/** pwm
 *  connect the adc value to the compare input of pwm
 *  pwm frequency is 40khz
 */

reg [10:0] compare;
wire reg10 = compare[10]; 
assign reg10 = 1'b0;
wire pwm_out;

always @(*) begin
  if (new_sample && sample_channel == 4'b0) begin
    compare[9:0] = sample_value;
  end
end

pwm pwm(
  .rst(rst),
  .clk(clk),
  .compare(compare),
  .pwm(pwm_out)
);

//divide clk by 4, as loop limit will be maxed out
reg clk_slow;
wire clk_slow_w;
assign clk_slow_w = clk_slow;
assign clk_slow_o = clk_slow;

clk_divider #(.N(4)) clk_divider(
  .clk(clk),
  .clk_d(clk_slow_w),
  .rst(rst)
 );

/** generate shift registers */
//parameter N_SR = 32'd3471;
parameter N_SR = 870;//loop limit is 1000 :(
wire[N_SR-2:0] delay_w;
genvar i;
generate 
  for (i = 0; i < N_SR-2; i = i+1) begin : for_gen0
    shift_register sr(
      .clk(clk_slow),
      .rst(rst),
      .d(delay_w[i]),
      .q(delay_w[i+1])
      );
  end
endgenerate
 

//first wire has to be a reg, since it will be connected  to input

assign pwm_o = pwm_out;

shift_register sr0(
  .clk(clk_slow),
  .rst(rst),
  .d(pwm_out),
  .q(delay_w[0])
);

/** assign outputs */
integer nu_sr = 86;//347;//number of shift registers for a unit delay
assign signal[0] = pwm_out;
genvar j;
generate 
  for (j = 1; j < 10; j = j+1) begin : assign_signal
    assign signal[j] = delay_w[j*nu_sr - 1];
  end
endgenerate

endmodule