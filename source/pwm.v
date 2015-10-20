module pwm (
  input clk,
  input rst, 
  input [10:0] compare,
  output pwm
  );
  
  reg pwm_d, pwm_q;
  reg [10:0] ctr_d, ctr_q;
  
  assign pwm = pwm_q;
  
  always @(*) begin
  
    //reset counter at 40kHz with 50MHz clk
    if (ctr_q >= 11'd1250) begin
      ctr_d = 11'b0;
    end else begin 
      ctr_d = ctr_q + 1;
    end
     
    if (compare > ctr_q) begin
      pwm_d = 1'b1;
    end else begin
      pwm_d = 1'b0; 
    end
   
  end
  
  always @(posedge clk) begin
    if (rst == 1) begin
      ctr_q <= 11'b0;
    end else begin
      ctr_q <= ctr_d;
    end
    
    pwm_q <= pwm_d;
    
  end
  
endmodule