module clk_divider#(parameter N=1) (

  input clk,
  input rst,
  output clk_d
  );
  reg clk_div;
  reg[31:0] counter;
  assign clk_d = clk_div;
  
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      clk_div <= 1'b0;
		counter <= 32'b0;
    end else if (counter == N-1) begin
      clk_div <= ~clk_div;
      counter <= 32'b0;
    end else begin
      clk_div <= clk_div;
      counter <= counter + 1;
    end
    
  end
  
endmodule