module Readwrite_Logic(
  input clk,
  input rst,
  input read_in,
  input write_in,
  input chipSelect,
  input A0In,
  input reg[7:0] inDataBus,
  output writeICW1,
  output writeICW2to4,
  output writeOCW1,
  output writeOCW2,
  output writeOCW3,
  output read_flag,
  output reg[7:0] internalDataBus
  );
reg A0Out;
reg delay_write;
wire posedge_write;

//positive edge detection for write
always @(posedge clk or negedge rst) begin
  if (!rst)
    delay_write <= 1'b1;
  else if (chipSelect)
    delay_write <= 1'b1;
  else
    delay_write <= write_in;
end
assign posedge_write = (~delay_write) & write_in;


assign read_flag = ~read_in & ~chipSelect;

always @(posedge clk or negedge rst) begin
  if (!rst)
    A0Out <= 1'b0;
  else
    A0Out <= A0In;
end

always @(posedge clk or negedge rst) begin
  if (~rst) begin
    internalDataBus <= 8'b00000000;
  end
  else if ( (~write_in) & (~chipSelect) ) begin
    internalDataBus <= inDataBus;
  end
  else begin
    internalDataBus <= internalDataBus;
  end     
end

//write from the processor
assign writeICW1 = posedge_write & ~A0Out & internalDataBus[4] ;
assign writeICW2to4 = posedge_write & A0Out;
assign writeOCW1 = posedge_write & A0Out;
assign writeOCW2 = posedge_write & ~A0Out & ~internalDataBus[4] & ~internalDataBus[3];
assign writeOCW3 = posedge_write & ~A0Out & ~internalDataBus[4] & internalDataBus[3];

endmodule
      
  
  
  
  
  




