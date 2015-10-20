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
    output reg [9:0] signal,
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

input_capture input_capture(
  .clk(clk),
  .rst(rst),
  .channel(channel),
  .new_sample(new_sample),
  .sample(sample),
  .sample_channel(sample_channel)
 );


/** pwm
 *  connect the adc value to the compare input of pwm
 *  pwm frequency is 40khz
 */
 // pwm ctr_q is 11 bits to generate 40 kHz reset with 50 MHz clk
 // signal 'compare' will be compared to ctr_q, so set compare to 11 bits,
 // although output of adc is 10 bits
/* 
reg [10:0] compare;

wire pwm_out;
assign pwm_o = pwm_out;

always @(*) begin
  compare[9:0] = sample;
  compare[10] = 1'b0;
end

pwm pwm(
  .rst(rst),
  .clk(clk),
  .compare(compare),
  .pwm(pwm_out)
);
*/
/** generate shift registers */

wire [6000:0] delay_w;
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

 
/** assign outputs
 *  place active high switches as select with select[0] at pin 57
 *  'select' selects from the following phase angles:
 *  -15, -12, -9, -6, -3, 3, 6, 9, 12, 15
 *  all other combinations give 0 phase
 */
//LUT generated for 10 bit select is too big. 
//many need to use a 10 input mux and design comb. logic to get select signals
//for now use a 4 bit select with to give phase angles -30, -15, 0, 15, 30


always @(*) begin
  
  if (select == 4'b1000) begin//generate +30deg phase angle
    
    signal[0] <= delay_w[1];
    signal[1] <= delay_w[662];
    signal[2] <= delay_w[1324];
    signal[3] <= delay_w[1986];
    signal[4] <= delay_w[2648];
    signal[5] <= delay_w[3310];
    signal[6] <= delay_w[3972];
    signal[7] <= delay_w[4634];
    signal[8] <= delay_w[5296];
    signal[9] <= delay_w[5958];
    
    
  end else if (select == 4'b0100) begin //15 deg phase angle
    
    signal[0] <= delay_w[1];
    signal[1] <= delay_w[343];
    signal[2] <= delay_w[686];
    signal[3] <= delay_w[1029];
    signal[4] <= delay_w[1372];
    signal[5] <= delay_w[1715];
    signal[6] <= delay_w[2058];
    signal[7] <= delay_w[2401];
    signal[8] <= delay_w[2744];
    signal[9] <= delay_w[3087];

  end else if (select == 4'b0010) begin //-15 deg phase angle
   
    signal[0] <= delay_w[3087];
    signal[1] <= delay_w[2744];
    signal[2] <= delay_w[2401];
    signal[3] <= delay_w[2058];
    signal[4] <= delay_w[1715];
    signal[5] <= delay_w[1372];
    signal[6] <= delay_w[1029];
    signal[7] <= delay_w[686];
    signal[8] <= delay_w[343];
    signal[9] <= delay_w[1];
    
  end else if (select == 4'b0001) begin //-30 deg phase angle
    
    signal[0] <= delay_w[5958];
    signal[1] <= delay_w[5296];
    signal[2] <= delay_w[4634];
    signal[3] <= delay_w[3972];
    signal[4] <= delay_w[3310];
    signal[5] <= delay_w[2648];
    signal[6] <= delay_w[1986];
    signal[7] <= delay_w[1324];
    signal[8] <= delay_w[662];
    signal[8] <= delay_w[1];
  
  end else begin //0 deg phase angle 
  
    signal[0] <= delay_w[0];
    signal[1] <= delay_w[0];
    signal[2] <= delay_w[0];
    signal[3] <= delay_w[0];
    signal[4] <= delay_w[0];
    signal[5] <= delay_w[0];
    signal[6] <= delay_w[0];
    signal[7] <= delay_w[0];
    signal[8] <= delay_w[0];
    signal[9] <= delay_w[0];
  
  end

end

endmodule