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
    //output pwm_o,
    output reg [19:0] signal,
    input[3:0] select,
    input pwm_in
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
wire [9:0] sample;
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
    .sample(sample),
    .sample_channel(sample_channel),
    .tx_data(8'h00),
    .new_tx_data(1'b0),
    .tx_busy(),
    .tx_block(avr_rx_busy),
    .rx_data(),
    .new_rx_data()
  );

/** generate shift registers */

wire [8000:0] delay_w;
//input signal comes from pwm from arduino
//first wire has to be a reg, since it will be connected  to input
shift_register sr0(
  .clk(clk),
  .rst(rst),
  .d(pwm_in),
  .q(delay_w[0])
);
//loop limit is about 1000 in the mojo IDE, so looping from 0 to ~6000 in one loop will fail
//put the generate block into modules and split up work into loops of 500

generate_shift_registers  #(.N(501)) gen_sr0 (
  .clk(clk),
  .rst(rst),
  .delay_w(delay_w[500:0])
 );
 
generate_shift_registers  #(.N(501)) gen_sr1 (
  .clk(clk),
  .rst(rst),
  .delay_w(delay_w[1000:500])
 );
 
generate_shift_registers  #(.N(501)) gen_sr2 (
  .clk(clk),
  .rst(rst),
  .delay_w(delay_w[1500:1000])
 );
 
generate_shift_registers  #(.N(501)) gen_sr3 (
  .clk(clk),
  .rst(rst),
  .delay_w(delay_w[2000:1500])
 );
 
generate_shift_registers  #(.N(501)) gen_sr4 (
  .clk(clk),
  .rst(rst),
  .delay_w(delay_w[2500:2000])
 );
 
generate_shift_registers  #(.N(501)) gen_sr5 (
  .clk(clk),
  .rst(rst),
  .delay_w(delay_w[3000:2500])
 );
 
generate_shift_registers  #(.N(501)) gen_sr6 (
  .clk(clk),
  .rst(rst),
  .delay_w(delay_w[3500:3000])
 );
 generate_shift_registers  #(.N(501)) gen_sr7 (
  .clk(clk),
  .rst(rst),
  .delay_w(delay_w[4000:3500])
 );
 
generate_shift_registers  #(.N(501)) gen_sr8 (
  .clk(clk),
  .rst(rst),
  .delay_w(delay_w[4500:4000])
 );
 
generate_shift_registers  #(.N(501)) gen_sr9 (
  .clk(clk),
  .rst(rst),
  .delay_w(delay_w[5000:4500])
 );
 
generate_shift_registers  #(.N(501)) gen_sr10 (
  .clk(clk),
  .rst(rst),
  .delay_w(delay_w[5500:5000])
 );
 
generate_shift_registers  #(.N(501)) gen_sr11 (
  .clk(clk),
  .rst(rst),
  .delay_w(delay_w[6000:5500])
 );

generate_shift_registers  #(.N(501)) gen_sr12 (
  .clk(clk),
  .rst(rst),
  .delay_w(delay_w[6500:6000])
 );
generate_shift_registers  #(.N(501)) gen_sr13 (
  .clk(clk),
  .rst(rst),
  .delay_w(delay_w[7000:6500])
 );
generate_shift_registers  #(.N(501)) gen_sr14 (
  .clk(clk),
  .rst(rst),
  .delay_w(delay_w[7500:7000])
 );
generate_shift_registers  #(.N(501)) gen_sr15 (
  .clk(clk),
  .rst(rst),
  .delay_w(delay_w[8000:7500])
 );

 
/** assign outputs
 *  place active high switches as select with select[0] at pin 57
 *  'select' maps the following beam angles:
 *  -30, -25, -20, -15, -10, -5, 0, 
 *    5, 10, 15, 20, 25, 30
 *  to the 'select' values 0000, 0001, 0010 ... 1101
 *  all other combinations give 0 angle
 */
 
//LUT generated for 10 bit select is too big. 
//many need to use a 10 input mux and design comb. logic to get select signals
//for now use a 4 bit select with to give phase angles -30, -15, 0, 15, 30

reg[9:0] multiplier;
reg pos_angle;
reg[5:0] index[19:0];
index[19] = 3'd19;
index[18] = 3'd18;
index[17] = 3'd17;
index[16] = 3'd16;
index[15] = 3'd15;
index[14] = 3'd14;
index[13] = 3'd13;
index[12] = 3'd12;
index[11] = 3'd11;
index[10] = 3'd10;
index[9] = 3'd9;
index[8] = 3'd8;
index[7] = 3'd7;
index[6] = 3'd6;
index[5] = 3'd5;
index[4] = 3'd4;
index[3] = 3'd3;
index[2] = 3'd2;
index[1] = 3'd1;
index[0] = 3'd0;

always @(*) begin
  if (select == 4'b0000) begin
    multiplier <= 10'd411;
    pos_angle <= 1'b0;
  end else begin    
    multiplier <= 10'd0;
    pos_angle <= 1'b0;
  end
end



reg index
genvar i;
generate
  for (i = 0; i < 20; i = i+1) begin: gen_signal
  
    always @(*) begin
      if (pos_angle == 1'b1) begin
        
        signal[i] <= delay_w[i * multiplier];
      end else begin
        signal[i] <= delay_w[8000 - i * multiplier];
      end
    end
  end
endgenerate
 
   
endmodule