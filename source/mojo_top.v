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

    //delay for angle -26
    signal[0] <= delay_w[8500];
    signal[1] <= delay_w[8127];
    signal[2] <= delay_w[7754];
    signal[3] <= delay_w[7381];
    signal[4] <= delay_w[7008];
    signal[5] <= delay_w[6635];
    signal[6] <= delay_w[6262];
    signal[7] <= delay_w[5889];
    signal[8] <= delay_w[5516];
    signal[9] <= delay_w[5143];
    signal[10] <= delay_w[4770];
    signal[11] <= delay_w[4397];
    signal[12] <= delay_w[4024];
    signal[13] <= delay_w[3651];
    signal[14] <= delay_w[3278];
    signal[15] <= delay_w[2905];
    signal[16] <= delay_w[2532];
    signal[17] <= delay_w[2159];
    signal[18] <= delay_w[1786];
    signal[19] <= delay_w[1413];

  end else if (select == 4'd2) begin 

    //delay for angle -22
    signal[0] <= delay_w[8500];
    signal[1] <= delay_w[8184];
    signal[2] <= delay_w[7868];
    signal[3] <= delay_w[7552];
    signal[4] <= delay_w[7236];
    signal[5] <= delay_w[6920];
    signal[6] <= delay_w[6604];
    signal[7] <= delay_w[6288];
    signal[8] <= delay_w[5972];
    signal[9] <= delay_w[5656];
    signal[10] <= delay_w[5340];
    signal[11] <= delay_w[5024];
    signal[12] <= delay_w[4708];
    signal[13] <= delay_w[4392];
    signal[14] <= delay_w[4076];
    signal[15] <= delay_w[3760];
    signal[16] <= delay_w[3444];
    signal[17] <= delay_w[3128];
    signal[18] <= delay_w[2812];
    signal[19] <= delay_w[2496];

  end else if (select == 4'd3) begin 
    //delay for angle -18
    signal[0] <= delay_w[8500];
    signal[1] <= delay_w[8242];
    signal[2] <= delay_w[7984];
    signal[3] <= delay_w[7726];
    signal[4] <= delay_w[7468];
    signal[5] <= delay_w[7210];
    signal[6] <= delay_w[6952];
    signal[7] <= delay_w[6694];
    signal[8] <= delay_w[6436];
    signal[9] <= delay_w[6178];
    signal[10] <= delay_w[5920];
    signal[11] <= delay_w[5662];
    signal[12] <= delay_w[5404];
    signal[13] <= delay_w[5146];
    signal[14] <= delay_w[4888];
    signal[15] <= delay_w[4630];
    signal[16] <= delay_w[4372];
    signal[17] <= delay_w[4114];
    signal[18] <= delay_w[3856];
    signal[19] <= delay_w[3598];

  end else if (select == 4'd4) begin 
    //delay for angle -14
    signal[0] <= delay_w[8500];
    signal[1] <= delay_w[8299];
    signal[2] <= delay_w[8098];
    signal[3] <= delay_w[7897];
    signal[4] <= delay_w[7696];
    signal[5] <= delay_w[7495];
    signal[6] <= delay_w[7294];
    signal[7] <= delay_w[7093];
    signal[8] <= delay_w[6892];
    signal[9] <= delay_w[6691];
    signal[10] <= delay_w[6490];
    signal[11] <= delay_w[6289];
    signal[12] <= delay_w[6088];
    signal[13] <= delay_w[5887];
    signal[14] <= delay_w[5686];
    signal[15] <= delay_w[5485];
    signal[16] <= delay_w[5284];
    signal[17] <= delay_w[5083];
    signal[18] <= delay_w[4882];
    signal[19] <= delay_w[4681];

  end else if (select == 4'd5) begin 
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

  end else if (select == 4'd6) begin 
    //delay for angle -6
    signal[0] <= delay_w[8500];
    signal[1] <= delay_w[8414];
    signal[2] <= delay_w[8328];
    signal[3] <= delay_w[8242];
    signal[4] <= delay_w[8156];
    signal[5] <= delay_w[8070];
    signal[6] <= delay_w[7984];
    signal[7] <= delay_w[7898];
    signal[8] <= delay_w[7812];
    signal[9] <= delay_w[7726];
    signal[10] <= delay_w[7640];
    signal[11] <= delay_w[7554];
    signal[12] <= delay_w[7468];
    signal[13] <= delay_w[7382];
    signal[14] <= delay_w[7296];
    signal[15] <= delay_w[7210];
    signal[16] <= delay_w[7124];
    signal[17] <= delay_w[7038];
    signal[18] <= delay_w[6952];
    signal[19] <= delay_w[6866];

  end else if (select == 4'd7) begin 
    //delay for angle -2
    signal[0] <= delay_w[8500];
    signal[1] <= delay_w[8471];
    signal[2] <= delay_w[8442];
    signal[3] <= delay_w[8413];
    signal[4] <= delay_w[8384];
    signal[5] <= delay_w[8355];
    signal[6] <= delay_w[8326];
    signal[7] <= delay_w[8297];
    signal[8] <= delay_w[8268];
    signal[9] <= delay_w[8239];
    signal[10] <= delay_w[8210];
    signal[11] <= delay_w[8181];
    signal[12] <= delay_w[8152];
    signal[13] <= delay_w[8123];
    signal[14] <= delay_w[8094];
    signal[15] <= delay_w[8065];
    signal[16] <= delay_w[8036];
    signal[17] <= delay_w[8007];
    signal[18] <= delay_w[7978];
    signal[19] <= delay_w[7949];


    //delay code for positive angles

  end else if (select == 4'd8) begin 
    //delay for angle 2
    signal[0] <= delay_w[0];
    signal[1] <= delay_w[29];
    signal[2] <= delay_w[58];
    signal[3] <= delay_w[87];
    signal[4] <= delay_w[116];
    signal[5] <= delay_w[145];
    signal[6] <= delay_w[174];
    signal[7] <= delay_w[203];
    signal[8] <= delay_w[232];
    signal[9] <= delay_w[261];
    signal[10] <= delay_w[290];
    signal[11] <= delay_w[319];
    signal[12] <= delay_w[348];
    signal[13] <= delay_w[377];
    signal[14] <= delay_w[406];
    signal[15] <= delay_w[435];
    signal[16] <= delay_w[464];
    signal[17] <= delay_w[493];
    signal[18] <= delay_w[522];
    signal[19] <= delay_w[551];

  end else if (select == 4'd9) begin 
    //delay for angle 6
    signal[0] <= delay_w[0];
    signal[1] <= delay_w[86];
    signal[2] <= delay_w[172];
    signal[3] <= delay_w[258];
    signal[4] <= delay_w[344];
    signal[5] <= delay_w[430];
    signal[6] <= delay_w[516];
    signal[7] <= delay_w[602];
    signal[8] <= delay_w[688];
    signal[9] <= delay_w[774];
    signal[10] <= delay_w[860];
    signal[11] <= delay_w[946];
    signal[12] <= delay_w[1032];
    signal[13] <= delay_w[1118];
    signal[14] <= delay_w[1204];
    signal[15] <= delay_w[1290];
    signal[16] <= delay_w[1376];
    signal[17] <= delay_w[1462];
    signal[18] <= delay_w[1548];
    signal[19] <= delay_w[1634];

  end else if (select == 4'd10) begin 
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

  end else if (select == 4'd11) begin 
    //delay for angle 14
    signal[0] <= delay_w[0];
    signal[1] <= delay_w[201];
    signal[2] <= delay_w[402];
    signal[3] <= delay_w[603];
    signal[4] <= delay_w[804];
    signal[5] <= delay_w[1005];
    signal[6] <= delay_w[1206];
    signal[7] <= delay_w[1407];
    signal[8] <= delay_w[1608];
    signal[9] <= delay_w[1809];
    signal[10] <= delay_w[2010];
    signal[11] <= delay_w[2211];
    signal[12] <= delay_w[2412];
    signal[13] <= delay_w[2613];
    signal[14] <= delay_w[2814];
    signal[15] <= delay_w[3015];
    signal[16] <= delay_w[3216];
    signal[17] <= delay_w[3417];
    signal[18] <= delay_w[3618];
    signal[19] <= delay_w[3819];

  end else if (select == 4'd12) begin 
    //delay for angle 18
    signal[0] <= delay_w[0];
    signal[1] <= delay_w[258];
    signal[2] <= delay_w[516];
    signal[3] <= delay_w[774];
    signal[4] <= delay_w[1032];
    signal[5] <= delay_w[1290];
    signal[6] <= delay_w[1548];
    signal[7] <= delay_w[1806];
    signal[8] <= delay_w[2064];
    signal[9] <= delay_w[2322];
    signal[10] <= delay_w[2580];
    signal[11] <= delay_w[2838];
    signal[12] <= delay_w[3096];
    signal[13] <= delay_w[3354];
    signal[14] <= delay_w[3612];
    signal[15] <= delay_w[3870];
    signal[16] <= delay_w[4128];
    signal[17] <= delay_w[4386];
    signal[18] <= delay_w[4644];
    signal[19] <= delay_w[4902];

  end else if (select == 4'd13) begin 
    //delay for angle 22
    signal[0] <= delay_w[0];
    signal[1] <= delay_w[316];
    signal[2] <= delay_w[632];
    signal[3] <= delay_w[948];
    signal[4] <= delay_w[1264];
    signal[5] <= delay_w[1580];
    signal[6] <= delay_w[1896];
    signal[7] <= delay_w[2212];
    signal[8] <= delay_w[2528];
    signal[9] <= delay_w[2844];
    signal[10] <= delay_w[3160];
    signal[11] <= delay_w[3476];
    signal[12] <= delay_w[3792];
    signal[13] <= delay_w[4108];
    signal[14] <= delay_w[4424];
    signal[15] <= delay_w[4740];
    signal[16] <= delay_w[5056];
    signal[17] <= delay_w[5372];
    signal[18] <= delay_w[5688];
    signal[19] <= delay_w[6004];

  end else if (select == 4'd14) begin 
    //delay for angle 26
    signal[0] <= delay_w[0];
    signal[1] <= delay_w[373];
    signal[2] <= delay_w[746];
    signal[3] <= delay_w[1119];
    signal[4] <= delay_w[1492];
    signal[5] <= delay_w[1865];
    signal[6] <= delay_w[2238];
    signal[7] <= delay_w[2611];
    signal[8] <= delay_w[2984];
    signal[9] <= delay_w[3357];
    signal[10] <= delay_w[3730];
    signal[11] <= delay_w[4103];
    signal[12] <= delay_w[4476];
    signal[13] <= delay_w[4849];
    signal[14] <= delay_w[5222];
    signal[15] <= delay_w[5595];
    signal[16] <= delay_w[5968];
    signal[17] <= delay_w[6341];
    signal[18] <= delay_w[6714];
    signal[19] <= delay_w[7087];

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
