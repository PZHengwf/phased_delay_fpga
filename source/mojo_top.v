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
reg [9:0] compare;
wire pwm_out;
assign pwm_o = pwm_out;

always @(*) begin
  if (new_sample && sample_channel == 4'b0) begin
    compare = sample_value;
  end
end

pwm pwm(
  .rst(rst),
  .clk(clk),
  .compare(compare),
  .pwm(pwm_out)
);

/** generate shift registers */

wire [6869:0] delay_w;

//first wire has to be a reg, since it will be connected  to input
shift_register sr0(
  .clk(clk),
  .rst(rst),
  .d(pwm_out),
  .q(delay_w[0])
);
//loop limit is about 1000 in the mojo IDE, so looping from 0 to ~6000 in one loop will fail
//put the generate block into modules and split up work into loops of 500

generate_shift_registers  #(.N(500)) gen_sr0 (
  .clk(clk),
  .rst(rst),
  .delay_w(delay_w[499:0])
 );
 
generate_shift_registers  #(.N(500)) gen_sr1 (
  .clk(clk),
  .rst(rst),
  .delay_w(delay_w[999:500])
 );
 
generate_shift_registers  #(.N(500)) gen_sr2 (
  .clk(clk),
  .rst(rst),
  .delay_w(delay_w[1499:1000])
 );
 
generate_shift_registers  #(.N(500)) gen_sr3 (
  .clk(clk),
  .rst(rst),
  .delay_w(delay_w[1999:1500])
 );
 
generate_shift_registers  #(.N(500)) gen_sr4 (
  .clk(clk),
  .rst(rst),
  .delay_w(delay_w[2499:2000])
 );
 
generate_shift_registers  #(.N(500)) gen_sr5 (
  .clk(clk),
  .rst(rst),
  .delay_w(delay_w[2999:2500])
 );
 
generate_shift_registers  #(.N(500)) gen_sr6 (
  .clk(clk),
  .rst(rst),
  .delay_w(delay_w[3499:3000])
 );
 
generate_shift_registers  #(.N(500)) gen_sr7 (
  .clk(clk),
  .rst(rst),
  .delay_w(delay_w[3999:3500])
 );       

generate_shift_registers  #(.N(500)) gen_sr8 (
  .clk(clk),
  .rst(rst),
  .delay_w(delay_w[4499:4000])
 );
 
generate_shift_registers  #(.N(500)) gen_sr9 (
  .clk(clk),
  .rst(rst),
  .delay_w(delay_w[4999:4500])
 );
 
generate_shift_registers  #(.N(500)) gen_sr10 (
  .clk(clk),
  .rst(rst),
  .delay_w(delay_w[5499:5000])
 );
 
generate_shift_registers  #(.N(500)) gen_sr11 (
  .clk(clk),
  .rst(rst),
  .delay_w(delay_w[5999:5500])
 );
 
generate_shift_registers  #(.N(870)) gen_sr12 (
  .clk(clk),
  .rst(rst),
  .delay_w(delay_w[6869:6000])
 );


/** assign outputs */
integer nu_sr = 343;//number of shift registers for a unit delay to achieve 15 deg shift
assign signal[0] = pwm_out;
genvar j;
generate 
  for (j = 1; j < 10; j = j+1) begin : assign_signal
    assign signal[j] = delay_w[j*nu_sr - 1];
  end
endgenerate

endmodule