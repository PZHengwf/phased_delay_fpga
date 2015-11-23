module mojo_top(
    // 50MHz clock input
    input clk,
    // Input from reset button (active low)
    input rst_n,
    // cclk input from AVR, high when AVR is ready
    input cclk,
    // Outputs to the 8 onboard LEDs
    //output[7:0]led,
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


/** generate shift registers */

wire [8500:0] delay_w;
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
generate_shift_registers  #(.N(501)) gen_sr16 (
  .clk(clk),
  .rst(rst),
  .delay_w(delay_w[8500:8000])
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

always @(*) begin
//delay code for negative angles
  if (select == 4'd0) begin
//delay for angle -30
    signal[0] <= delay_w[8500];
    signal[1] <= delay_w[8070];
    signal[2] <= delay_w[7640];
    signal[3] <= delay_w[7210];
    signal[4] <= delay_w[6780];
    signal[5] <= delay_w[6350];
    signal[6] <= delay_w[5920];
    signal[7] <= delay_w[5490];
    signal[8] <= delay_w[5060];
    signal[9] <= delay_w[4630];
    signal[10] <= delay_w[4200];
    signal[11] <= delay_w[3770];
    signal[12] <= delay_w[3340];
    signal[13] <= delay_w[2910];
    signal[14] <= delay_w[2480];
    signal[15] <= delay_w[2050];
    signal[16] <= delay_w[1620];
    signal[17] <= delay_w[1190];
    signal[18] <= delay_w[760];
    signal[19] <= delay_w[330];
  
  end else if (select == 4'd1) begin   
    //delay for angle -25
    signal[0] <= delay_w[8500];
    signal[1] <= delay_w[8141];
    signal[2] <= delay_w[7782];
    signal[3] <= delay_w[7423];
    signal[4] <= delay_w[7064];
    signal[5] <= delay_w[6705];
    signal[6] <= delay_w[6346];
    signal[7] <= delay_w[5987];
    signal[8] <= delay_w[5628];
    signal[9] <= delay_w[5269];
    signal[10] <= delay_w[4910];
    signal[11] <= delay_w[4551];
    signal[12] <= delay_w[4192];
    signal[13] <= delay_w[3833];
    signal[14] <= delay_w[3474];
    signal[15] <= delay_w[3115];
    signal[16] <= delay_w[2756];
    signal[17] <= delay_w[2397];
    signal[18] <= delay_w[2038];
    signal[19] <= delay_w[1679];
  
  end else if (select == 4'd2) begin  
    //delay for angle -20
    signal[0] <= delay_w[8500];
    signal[1] <= delay_w[8213];
    signal[2] <= delay_w[7926];
    signal[3] <= delay_w[7639];
    signal[4] <= delay_w[7352];
    signal[5] <= delay_w[7065];
    signal[6] <= delay_w[6778];
    signal[7] <= delay_w[6491];
    signal[8] <= delay_w[6204];
    signal[9] <= delay_w[5917];
    signal[10] <= delay_w[5630];
    signal[11] <= delay_w[5343];
    signal[12] <= delay_w[5056];
    signal[13] <= delay_w[4769];
    signal[14] <= delay_w[4482];
    signal[15] <= delay_w[4195];
    signal[16] <= delay_w[3908];
    signal[17] <= delay_w[3621];
    signal[18] <= delay_w[3334];
    signal[19] <= delay_w[3047];
    
  end else if (select == 4'd3) begin    
    //delay for angle -15
    signal[0] <= delay_w[8500];
    signal[1] <= delay_w[8285];
    signal[2] <= delay_w[8070];
    signal[3] <= delay_w[7855];
    signal[4] <= delay_w[7640];
    signal[5] <= delay_w[7425];
    signal[6] <= delay_w[7210];
    signal[7] <= delay_w[6995];
    signal[8] <= delay_w[6780];
    signal[9] <= delay_w[6565];
    signal[10] <= delay_w[6350];
    signal[11] <= delay_w[6135];
    signal[12] <= delay_w[5920];
    signal[13] <= delay_w[5705];
    signal[14] <= delay_w[5490];
    signal[15] <= delay_w[5275];
    signal[16] <= delay_w[5060];
    signal[17] <= delay_w[4845];
    signal[18] <= delay_w[4630];
    signal[19] <= delay_w[4415];
    
  end else if (select == 4'd4) begin    
    //delay for angle -10
    signal[0] <= delay_w[8500];
    signal[1] <= delay_w[8357];
    signal[2] <= delay_w[8214];
    signal[3] <= delay_w[8071];
    signal[4] <= delay_w[7928];
    signal[5] <= delay_w[7785];
    signal[6] <= delay_w[7642];
    signal[7] <= delay_w[7499];
    signal[8] <= delay_w[7356];
    signal[9] <= delay_w[7213];
    signal[10] <= delay_w[7070];
    signal[11] <= delay_w[6927];
    signal[12] <= delay_w[6784];
    signal[13] <= delay_w[6641];
    signal[14] <= delay_w[6498];
    signal[15] <= delay_w[6355];
    signal[16] <= delay_w[6212];
    signal[17] <= delay_w[6069];
    signal[18] <= delay_w[5926];
    signal[19] <= delay_w[5783];
    
  end else if (select == 4'd5) begin    
    //delay for angle -5
    signal[0] <= delay_w[8500];
    signal[1] <= delay_w[8428];
    signal[2] <= delay_w[8356];
    signal[3] <= delay_w[8284];
    signal[4] <= delay_w[8212];
    signal[5] <= delay_w[8140];
    signal[6] <= delay_w[8068];
    signal[7] <= delay_w[7996];
    signal[8] <= delay_w[7924];
    signal[9] <= delay_w[7852];
    signal[10] <= delay_w[7780];
    signal[11] <= delay_w[7708];
    signal[12] <= delay_w[7636];
    signal[13] <= delay_w[7564];
    signal[14] <= delay_w[7492];
    signal[15] <= delay_w[7420];
    signal[16] <= delay_w[7348];
    signal[17] <= delay_w[7276];
    signal[18] <= delay_w[7204];
    signal[19] <= delay_w[7132];
    
    
  end else if (select == 4'd6) begin    
    //delay code for positive angles
    
    //delay for angle 0
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
    signal[10] <= delay_w[0];
    signal[11] <= delay_w[0];
    signal[12] <= delay_w[0];
    signal[13] <= delay_w[0];
    signal[14] <= delay_w[0];
    signal[15] <= delay_w[0];
    signal[16] <= delay_w[0];
    signal[17] <= delay_w[0];
    signal[18] <= delay_w[0];
    signal[19] <= delay_w[0];
    
  end else if (select == 4'd7) begin    
    //delay for angle 5
    signal[0] <= delay_w[0];
    signal[1] <= delay_w[72];
    signal[2] <= delay_w[144];
    signal[3] <= delay_w[216];
    signal[4] <= delay_w[288];
    signal[5] <= delay_w[360];
    signal[6] <= delay_w[432];
    signal[7] <= delay_w[504];
    signal[8] <= delay_w[576];
    signal[9] <= delay_w[648];
    signal[10] <= delay_w[720];
    signal[11] <= delay_w[792];
    signal[12] <= delay_w[864];
    signal[13] <= delay_w[936];
    signal[14] <= delay_w[1008];
    signal[15] <= delay_w[1080];
    signal[16] <= delay_w[1152];
    signal[17] <= delay_w[1224];
    signal[18] <= delay_w[1296];
    signal[19] <= delay_w[1368];
     
  end else if (select == 4'd8) begin   
    //delay for angle 10
    signal[0] <= delay_w[0];
    signal[1] <= delay_w[143];
    signal[2] <= delay_w[286];
    signal[3] <= delay_w[429];
    signal[4] <= delay_w[572];
    signal[5] <= delay_w[715];
    signal[6] <= delay_w[858];
    signal[7] <= delay_w[1001];
    signal[8] <= delay_w[1144];
    signal[9] <= delay_w[1287];
    signal[10] <= delay_w[1430];
    signal[11] <= delay_w[1573];
    signal[12] <= delay_w[1716];
    signal[13] <= delay_w[1859];
    signal[14] <= delay_w[2002];
    signal[15] <= delay_w[2145];
    signal[16] <= delay_w[2288];
    signal[17] <= delay_w[2431];
    signal[18] <= delay_w[2574];
    signal[19] <= delay_w[2717];
    
  end else if (select == 4'd9) begin    
    //delay for angle 15
    signal[0] <= delay_w[0];
    signal[1] <= delay_w[215];
    signal[2] <= delay_w[430];
    signal[3] <= delay_w[645];
    signal[4] <= delay_w[860];
    signal[5] <= delay_w[1075];
    signal[6] <= delay_w[1290];
    signal[7] <= delay_w[1505];
    signal[8] <= delay_w[1720];
    signal[9] <= delay_w[1935];
    signal[10] <= delay_w[2150];
    signal[11] <= delay_w[2365];
    signal[12] <= delay_w[2580];
    signal[13] <= delay_w[2795];
    signal[14] <= delay_w[3010];
    signal[15] <= delay_w[3225];
    signal[16] <= delay_w[3440];
    signal[17] <= delay_w[3655];
    signal[18] <= delay_w[3870];
    signal[19] <= delay_w[4085];
     
  end else if (select == 4'd10) begin   
    //delay for angle 20
    signal[0] <= delay_w[0];
    signal[1] <= delay_w[287];
    signal[2] <= delay_w[574];
    signal[3] <= delay_w[861];
    signal[4] <= delay_w[1148];
    signal[5] <= delay_w[1435];
    signal[6] <= delay_w[1722];
    signal[7] <= delay_w[2009];
    signal[8] <= delay_w[2296];
    signal[9] <= delay_w[2583];
    signal[10] <= delay_w[2870];
    signal[11] <= delay_w[3157];
    signal[12] <= delay_w[3444];
    signal[13] <= delay_w[3731];
    signal[14] <= delay_w[4018];
    signal[15] <= delay_w[4305];
    signal[16] <= delay_w[4592];
    signal[17] <= delay_w[4879];
    signal[18] <= delay_w[5166];
    signal[19] <= delay_w[5453];
     
  end else if (select == 4'd11) begin   
    //delay for angle 25
    signal[0] <= delay_w[0];
    signal[1] <= delay_w[359];
    signal[2] <= delay_w[718];
    signal[3] <= delay_w[1077];
    signal[4] <= delay_w[1436];
    signal[5] <= delay_w[1795];
    signal[6] <= delay_w[2154];
    signal[7] <= delay_w[2513];
    signal[8] <= delay_w[2872];
    signal[9] <= delay_w[3231];
    signal[10] <= delay_w[3590];
    signal[11] <= delay_w[3949];
    signal[12] <= delay_w[4308];
    signal[13] <= delay_w[4667];
    signal[14] <= delay_w[5026];
    signal[15] <= delay_w[5385];
    signal[16] <= delay_w[5744];
    signal[17] <= delay_w[6103];
    signal[18] <= delay_w[6462];
    signal[19] <= delay_w[6821];
     
  end else if (select == 4'd12) begin   
    //delay for angle 30
    signal[0] <= delay_w[0];
    signal[1] <= delay_w[430];
    signal[2] <= delay_w[860];
    signal[3] <= delay_w[1290];
    signal[4] <= delay_w[1720];
    signal[5] <= delay_w[2150];
    signal[6] <= delay_w[2580];
    signal[7] <= delay_w[3010];
    signal[8] <= delay_w[3440];
    signal[9] <= delay_w[3870];
    signal[10] <= delay_w[4300];
    signal[11] <= delay_w[4730];
    signal[12] <= delay_w[5160];
    signal[13] <= delay_w[5590];
    signal[14] <= delay_w[6020];
    signal[15] <= delay_w[6450];
    signal[16] <= delay_w[6880];
    signal[17] <= delay_w[7310];
    signal[18] <= delay_w[7740];
    signal[19] <= delay_w[8170];
    
  end else begin  
    //delay for angle 0
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
    signal[10] <= delay_w[0];
    signal[11] <= delay_w[0];
    signal[12] <= delay_w[0];
    signal[13] <= delay_w[0];
    signal[14] <= delay_w[0];
    signal[15] <= delay_w[0];
    signal[16] <= delay_w[0];
    signal[17] <= delay_w[0];
    signal[18] <= delay_w[0];
    signal[19] <= delay_w[0];
  end

end

 
   
endmodule
