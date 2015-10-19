module input_capture(
  input clk,
  input rst,
  output [3:0] channel,
  input new_sample,
  input [9:0] sample, 
  input [3:0] sample_channel
 );
 
 //capture input from pin A0
 assign channel = 4'd0;
 
 endmodule