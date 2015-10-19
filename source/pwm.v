module pwm #(parameter CTR_LEN = 11) (
  input clk,
  input rst, 
  input [CTR_LEN-1 : 0] compare,
  output pwm
  );
  
  reg pwm_d, pwm_q;
  reg [CTR_LEN-1:0] ctr_d, ctr_q;
  
  assign pwm = pwm_q;
  
  always @(*) begin
  
    //reset counter at 40kHz with 50MHz clk
    ctr_d = (ctr_q == 11'd1250) ? 11'b0 : ctr_q + 1; 
    
    pwm_d = (compare > ctr_q) ? 1'b1 : 1'b0;
   
  end
  
  always @(posedge clk) begin
    ctr_q <= (rst == 1) ? 11'b0 : ctr_d; 
    
    pwm_q <= pwm_d;
    
  end
  
endmodule