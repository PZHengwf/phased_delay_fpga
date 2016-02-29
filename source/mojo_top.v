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
 *  -30, -26, -22,... 30 
 *  to the 'select' values 0000, 0001, 0010 ... 1111
 */
 
//LUT generated for 10 bit select is too big. 
//hard code delay 

always @(*) begin

  if (select == 4'd0) begin
//delay for angle -28
    signal[0] <= delay_w[8500];
    signal[1] <= delay_w[8098];
    signal[2] <= delay_w[7696];
    signal[3] <= delay_w[7294];
    signal[4] <= delay_w[6892];
    signal[5] <= delay_w[6490];
    signal[6] <= delay_w[6088];
    signal[7] <= delay_w[5686];
    signal[8] <= delay_w[5284];
    signal[9] <= delay_w[4882];
    signal[10] <= delay_w[4480];
    signal[11] <= delay_w[4078];
    signal[12] <= delay_w[3676];
    signal[13] <= delay_w[3274];
    signal[14] <= delay_w[2872];
    signal[15] <= delay_w[2470];
    signal[16] <= delay_w[2068];
    signal[17] <= delay_w[1666];
    signal[18] <= delay_w[1264];
    signal[19] <= delay_w[862];

  end else if (select == 4'd1) begin
//delay for angle -24
    signal[0] <= delay_w[8500];
    signal[1] <= delay_w[8156];
    signal[2] <= delay_w[7812];
    signal[3] <= delay_w[7468];
    signal[4] <= delay_w[7124];
    signal[5] <= delay_w[6780];
    signal[6] <= delay_w[6436];
    signal[7] <= delay_w[6092];
    signal[8] <= delay_w[5748];
    signal[9] <= delay_w[5404];
    signal[10] <= delay_w[5060];
    signal[11] <= delay_w[4716];
    signal[12] <= delay_w[4372];
    signal[13] <= delay_w[4028];
    signal[14] <= delay_w[3684];
    signal[15] <= delay_w[3340];
    signal[16] <= delay_w[2996];
    signal[17] <= delay_w[2652];
    signal[18] <= delay_w[2308];
    signal[19] <= delay_w[1964];

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
//delay for angle -16
    signal[0] <= delay_w[8500];
    signal[1] <= delay_w[8271];
    signal[2] <= delay_w[8042];
    signal[3] <= delay_w[7813];
    signal[4] <= delay_w[7584];
    signal[5] <= delay_w[7355];
    signal[6] <= delay_w[7126];
    signal[7] <= delay_w[6897];
    signal[8] <= delay_w[6668];
    signal[9] <= delay_w[6439];
    signal[10] <= delay_w[6210];
    signal[11] <= delay_w[5981];
    signal[12] <= delay_w[5752];
    signal[13] <= delay_w[5523];
    signal[14] <= delay_w[5294];
    signal[15] <= delay_w[5065];
    signal[16] <= delay_w[4836];
    signal[17] <= delay_w[4607];
    signal[18] <= delay_w[4378];
    signal[19] <= delay_w[4149];

  end else if (select == 4'd4) begin
//delay for angle -12
    signal[0] <= delay_w[8500];
    signal[1] <= delay_w[8328];
    signal[2] <= delay_w[8156];
    signal[3] <= delay_w[7984];
    signal[4] <= delay_w[7812];
    signal[5] <= delay_w[7640];
    signal[6] <= delay_w[7468];
    signal[7] <= delay_w[7296];
    signal[8] <= delay_w[7124];
    signal[9] <= delay_w[6952];
    signal[10] <= delay_w[6780];
    signal[11] <= delay_w[6608];
    signal[12] <= delay_w[6436];
    signal[13] <= delay_w[6264];
    signal[14] <= delay_w[6092];
    signal[15] <= delay_w[5920];
    signal[16] <= delay_w[5748];
    signal[17] <= delay_w[5576];
    signal[18] <= delay_w[5404];
    signal[19] <= delay_w[5232];

  end else if (select == 4'd5) begin
//delay for angle -8
    signal[0] <= delay_w[8500];
    signal[1] <= delay_w[8385];
    signal[2] <= delay_w[8270];
    signal[3] <= delay_w[8155];
    signal[4] <= delay_w[8040];
    signal[5] <= delay_w[7925];
    signal[6] <= delay_w[7810];
    signal[7] <= delay_w[7695];
    signal[8] <= delay_w[7580];
    signal[9] <= delay_w[7465];
    signal[10] <= delay_w[7350];
    signal[11] <= delay_w[7235];
    signal[12] <= delay_w[7120];
    signal[13] <= delay_w[7005];
    signal[14] <= delay_w[6890];
    signal[15] <= delay_w[6775];
    signal[16] <= delay_w[6660];
    signal[17] <= delay_w[6545];
    signal[18] <= delay_w[6430];
    signal[19] <= delay_w[6315];

  end else if (select == 4'd6) begin
//delay for angle -4
    signal[0] <= delay_w[8500];
    signal[1] <= delay_w[8443];
    signal[2] <= delay_w[8386];
    signal[3] <= delay_w[8329];
    signal[4] <= delay_w[8272];
    signal[5] <= delay_w[8215];
    signal[6] <= delay_w[8158];
    signal[7] <= delay_w[8101];
    signal[8] <= delay_w[8044];
    signal[9] <= delay_w[7987];
    signal[10] <= delay_w[7930];
    signal[11] <= delay_w[7873];
    signal[12] <= delay_w[7816];
    signal[13] <= delay_w[7759];
    signal[14] <= delay_w[7702];
    signal[15] <= delay_w[7645];
    signal[16] <= delay_w[7588];
    signal[17] <= delay_w[7531];
    signal[18] <= delay_w[7474];
    signal[19] <= delay_w[7417];

  end else if (select == 4'd7) begin
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

  end else if (select == 4'd8) begin
//delay for angle 4
    signal[0] <= delay_w[0];
    signal[1] <= delay_w[57];
    signal[2] <= delay_w[114];
    signal[3] <= delay_w[171];
    signal[4] <= delay_w[228];
    signal[5] <= delay_w[285];
    signal[6] <= delay_w[342];
    signal[7] <= delay_w[399];
    signal[8] <= delay_w[456];
    signal[9] <= delay_w[513];
    signal[10] <= delay_w[570];
    signal[11] <= delay_w[627];
    signal[12] <= delay_w[684];
    signal[13] <= delay_w[741];
    signal[14] <= delay_w[798];
    signal[15] <= delay_w[855];
    signal[16] <= delay_w[912];
    signal[17] <= delay_w[969];
    signal[18] <= delay_w[1026];
    signal[19] <= delay_w[1083];

  end else if (select == 4'd9) begin
//delay for angle 8
    signal[0] <= delay_w[0];
    signal[1] <= delay_w[115];
    signal[2] <= delay_w[230];
    signal[3] <= delay_w[345];
    signal[4] <= delay_w[460];
    signal[5] <= delay_w[575];
    signal[6] <= delay_w[690];
    signal[7] <= delay_w[805];
    signal[8] <= delay_w[920];
    signal[9] <= delay_w[1035];
    signal[10] <= delay_w[1150];
    signal[11] <= delay_w[1265];
    signal[12] <= delay_w[1380];
    signal[13] <= delay_w[1495];
    signal[14] <= delay_w[1610];
    signal[15] <= delay_w[1725];
    signal[16] <= delay_w[1840];
    signal[17] <= delay_w[1955];
    signal[18] <= delay_w[2070];
    signal[19] <= delay_w[2185];

  end else if (select == 4'd10) begin
//delay for angle 12
    signal[0] <= delay_w[0];
    signal[1] <= delay_w[172];
    signal[2] <= delay_w[344];
    signal[3] <= delay_w[516];
    signal[4] <= delay_w[688];
    signal[5] <= delay_w[860];
    signal[6] <= delay_w[1032];
    signal[7] <= delay_w[1204];
    signal[8] <= delay_w[1376];
    signal[9] <= delay_w[1548];
    signal[10] <= delay_w[1720];
    signal[11] <= delay_w[1892];
    signal[12] <= delay_w[2064];
    signal[13] <= delay_w[2236];
    signal[14] <= delay_w[2408];
    signal[15] <= delay_w[2580];
    signal[16] <= delay_w[2752];
    signal[17] <= delay_w[2924];
    signal[18] <= delay_w[3096];
    signal[19] <= delay_w[3268];

  end else if (select == 4'd11) begin
//delay for angle 16
    signal[0] <= delay_w[0];
    signal[1] <= delay_w[229];
    signal[2] <= delay_w[458];
    signal[3] <= delay_w[687];
    signal[4] <= delay_w[916];
    signal[5] <= delay_w[1145];
    signal[6] <= delay_w[1374];
    signal[7] <= delay_w[1603];
    signal[8] <= delay_w[1832];
    signal[9] <= delay_w[2061];
    signal[10] <= delay_w[2290];
    signal[11] <= delay_w[2519];
    signal[12] <= delay_w[2748];
    signal[13] <= delay_w[2977];
    signal[14] <= delay_w[3206];
    signal[15] <= delay_w[3435];
    signal[16] <= delay_w[3664];
    signal[17] <= delay_w[3893];
    signal[18] <= delay_w[4122];
    signal[19] <= delay_w[4351];

  end else if (select == 4'd12) begin
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

  end else if (select == 4'd13) begin
//delay for angle 24
    signal[0] <= delay_w[0];
    signal[1] <= delay_w[344];
    signal[2] <= delay_w[688];
    signal[3] <= delay_w[1032];
    signal[4] <= delay_w[1376];
    signal[5] <= delay_w[1720];
    signal[6] <= delay_w[2064];
    signal[7] <= delay_w[2408];
    signal[8] <= delay_w[2752];
    signal[9] <= delay_w[3096];
    signal[10] <= delay_w[3440];
    signal[11] <= delay_w[3784];
    signal[12] <= delay_w[4128];
    signal[13] <= delay_w[4472];
    signal[14] <= delay_w[4816];
    signal[15] <= delay_w[5160];
    signal[16] <= delay_w[5504];
    signal[17] <= delay_w[5848];
    signal[18] <= delay_w[6192];
    signal[19] <= delay_w[6536];

  end else if (select == 4'd14) begin
//delay for angle 28
    signal[0] <= delay_w[0];
    signal[1] <= delay_w[402];
    signal[2] <= delay_w[804];
    signal[3] <= delay_w[1206];
    signal[4] <= delay_w[1608];
    signal[5] <= delay_w[2010];
    signal[6] <= delay_w[2412];
    signal[7] <= delay_w[2814];
    signal[8] <= delay_w[3216];
    signal[9] <= delay_w[3618];
    signal[10] <= delay_w[4020];
    signal[11] <= delay_w[4422];
    signal[12] <= delay_w[4824];
    signal[13] <= delay_w[5226];
    signal[14] <= delay_w[5628];
    signal[15] <= delay_w[6030];
    signal[16] <= delay_w[6432];
    signal[17] <= delay_w[6834];
    signal[18] <= delay_w[7236];
    signal[19] <= delay_w[7638];

  end else if (select == 4'd15) begin
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

  end
end


endmodule
