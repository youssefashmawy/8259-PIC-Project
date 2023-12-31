`timescale 1ns/10ps

module Read_Write_Logic_tb;

reg clk;
reg rst;
reg read_in;
reg write;
reg chipSelect;
reg A0In;
reg [7:0] inDataBus;

wire writeICW1;
wire writeICW2to4;
wire writeOCW1;
wire writeOCW2;
wire writeOCW3;
wire read;
wire [7:0] internalDataBus;

// Instantiate the module you want to test
Readwrite_Logic dut (
    .clk(clk),
    .rst(rst),
    .read_in(read_in),
    .write_in(write),
    .chipSelect(chipSelect),
    .A0In(A0In),
    .inDataBus(inDataBus),
    .writeICW1(writeICW1),
    .writeICW2to4(writeICW2to4),
    .writeOCW1(writeOCW1),
    .writeOCW2(writeOCW2),
    .writeOCW3(writeOCW3),
    .read_flag(read),
    .internalDataBus(internalDataBus)
);

initial begin
    clk = 1'b1;
    rst = 1'b0;
    #2 rst = 1'b1;
end

always #5 clk = ~clk;

initial begin
    // Stimulus generation
    write = 1;
    chipSelect = 1;
    read_in = 1;
    A0In = 1;
    inDataBus = 8'h01;
    #5 write = 0;chipSelect = 0;inDataBus = 8'b00010000;A0In = 0;read_in = 0;
    #10 write = 1;chipSelect = 1;
    #10 write = 0;chipSelect = 0;inDataBus = 8'b00000000;A0In = 1;
    #10 write = 1;chipSelect = 1;
    #10 write = 0;chipSelect = 0;inDataBus = 8'b00000000;A0In = 0;
    #10 write = 1;chipSelect = 1;
    #10 write = 0;chipSelect = 0;inDataBus = 8'b00001000;A0In = 0;
    #10 write = 1;chipSelect = 1;inDataBus = 8'b00000000;
    #10 write = 0;chipSelect = 1;inDataBus = 8'b00010000;
    #10 write = 0;chipSelect = 1;inDataBus = 8'b00000000;A0In = 0;
    #10 write = 1;chipSelect = 1;inDataBus = 8'b00011000;
    
    #10 chipSelect = 0;read_in = 0;
    #10 chipSelect = 1;read_in = 1;
    #10 chipSelect = 1;read_in = 0;
    #10 chipSelect = 0;read_in = 0;
    
    #5 $finish;
end

endmodule




