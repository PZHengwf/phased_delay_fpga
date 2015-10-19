module shift_register(
  input clk,
  input rst,
  input d,
  output q
    );

reg q_reg;
assign q = q_reg;

always@(posedge clk or posedge rst) begin
  if (rst) begin
    q_reg <= 1'b0;
  end else begin
    q_reg <= d;
  end
end

endmodule
