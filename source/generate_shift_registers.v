module generate_shift_registers #(parameter N = 1000) (
  input clk,
  input rst,
  inout[N-1:0] delay_w
 );
 
 genvar i;
 generate
   for (i = 0; i < N-1; i = i+1) begin: for_gen
     shift_register sr(
       .clk(clk),
       .rst(rst),
       .d(delay_w[i]),
       .q(delay_w[i+1])
      );
   end
 endgenerate 
  
endmodule
  