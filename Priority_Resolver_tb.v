`timescale 1ns/10ps

module Priority_Resolver_tb;
  reg clk;
  reg rst;
  reg   [2:0]   priority_rotate;
  reg   [7:0]   interrupt_mask;

  reg   [7:0]   interrupt_request_register;
  reg   [7:0]   in_service_register;

  wire   [7:0]   interrupt;
  
  Priority_Resolver dut (
  .priority_rotate(priority_rotate),
  .interrupt_mask(interrupt_mask),

  .interrupt_request_register(interrupt_request_register),
  .in_service_register(in_service_register),
  
  .interrupt(interrupt)
  );
  
  initial begin
    clk = 1'b1;
    rst = 1'b0;
    #2 rst = 1'b1;
  end

  always #5 clk = ~clk;
  
  initial begin
    $display("********************************");
    $display("***** initialization  **********");
    $display("********************************");

        priority_rotate            = 3'b111;
        interrupt_mask             = 8'b11111111;
        interrupt_request_register = 8'b00000000;
        in_service_register        = 8'b00000000;
        #15;
    
    $display("********************************");
    $display("***** TEST INTERRUPT MASK  **********");
    $display("********************************");
        
        $display("***** TEST Mask 8'b11111111 ***** ");
        interrupt_request_register = 8'b10000000;
        #10;
        interrupt_request_register = 8'b11000000;
        #10;
        interrupt_request_register = 8'b11100000;
        #10;
        interrupt_request_register = 8'b11110000;
        #10;
        interrupt_request_register = 8'b11111000;
        #10;
        interrupt_request_register = 8'b11111100;
        #10;
        interrupt_request_register = 8'b11111110;
        #10;
        interrupt_request_register = 8'b11111111;
        #10;
        interrupt_request_register = 8'b00000000;
        #10;

        $display("***** TEST Mask 8'b00000000 ***** ");
        interrupt_mask = 8'b00000000;
        #10;
        interrupt_request_register = 8'b10000000;
        #10;
        interrupt_request_register = 8'b11000000;
        #10;
        interrupt_request_register = 8'b11100000;
        #10;
        interrupt_request_register = 8'b11110000;
        #10;
        interrupt_request_register = 8'b11111000;
        #10;
        interrupt_request_register = 8'b11111100;
        #10;
        interrupt_request_register = 8'b11111110;
        #10;
        interrupt_request_register = 8'b11111111;
        #10;
        interrupt_request_register = 8'b00000000;
        #10;

        $display("***** TEST Mask 8'b00000001 ***** ");
        interrupt_mask = 8'b00000001;
        #10;
        interrupt_request_register = 8'b10000000;
        #10;
        interrupt_request_register = 8'b11000000;
        #10;
        interrupt_request_register = 8'b11100000;
        #10;
        interrupt_request_register = 8'b11110000;
        #10;
        interrupt_request_register = 8'b11111000;
        #10;
        interrupt_request_register = 8'b11111100;
        #10;
        interrupt_request_register = 8'b11111110;
        #10;
        interrupt_request_register = 8'b11111111;
        #10;
        interrupt_request_register = 8'b00000000;
        #10;

        $display("***** TEST Mask 8'b00000100 ***** ");
        interrupt_mask = 8'b00000100;
        #10;
        interrupt_request_register = 8'b10000000;
        #10;
        interrupt_request_register = 8'b11000000;
        #10;
        interrupt_request_register = 8'b11100000;
        #10;
        interrupt_request_register = 8'b11110000;
        #10;
        interrupt_request_register = 8'b11111000;
        #10;
        interrupt_request_register = 8'b11111100;
        #10;
        interrupt_request_register = 8'b11111110;
        #10;
        interrupt_request_register = 8'b11111111;
        #10;
        interrupt_request_register = 8'b00000000;
        #10;

        interrupt_mask = 8'b00000000;

        #100;
        
        
    $display("********************************");
    $display("***** TEST IN-SERVICE INTERRUPT  **********");
    $display("********************************");

        $display("***** TEST In service 8'b00000000 ***** ");
        in_service_register = 8'b00000001;
        #10;
        interrupt_request_register = 8'b10000000;
        #10;
        interrupt_request_register = 8'b11000000;
        #10;
        interrupt_request_register = 8'b11100000;
        #10;
        interrupt_request_register = 8'b11110000;
        #10;
        interrupt_request_register = 8'b11111000;
        #10;
        interrupt_request_register = 8'b11111100;
        #10;
        interrupt_request_register = 8'b11111110;
        #10;
        interrupt_request_register = 8'b11111111;
        #10;
        interrupt_request_register = 8'b00000000;
        #10;

        $display("***** TEST In service 8'b00000010 ***** ");
        in_service_register = 8'b00000010;
        #10;
        interrupt_request_register = 8'b10000000;
        #10;
        interrupt_request_register = 8'b11000000;
        #10;
        interrupt_request_register = 8'b11100000;
        #10;
        interrupt_request_register = 8'b11110000;
        #10;
        interrupt_request_register = 8'b11111000;
        #10;
        interrupt_request_register = 8'b11111100;
        #10;
        interrupt_request_register = 8'b11111110;
        #10;
        interrupt_request_register = 8'b11111111;
        #10;
        interrupt_request_register = 8'b00000000;
        #10;


        $display("***** TEST In service 8'b10000000 ***** ");
        in_service_register = 8'b10000000;
        #10;
        interrupt_request_register = 8'b10000000;
        #10;
        interrupt_request_register = 8'b11000000;
        #10;
        interrupt_request_register = 8'b11100000;
        #10;
        interrupt_request_register = 8'b11110000;
        #10;
        interrupt_request_register = 8'b11111000;
        #10;
        interrupt_request_register = 8'b11111100;
        #10;
        interrupt_request_register = 8'b11111110;
        #10;
        interrupt_request_register = 8'b11111111;
        #10;
        interrupt_request_register = 8'b00000000;
        #10;

        in_service_register = 8'b00000000;
        #100;   
        
    $display("********************************");
    $display("***** TEST ROTATION  **********");
    $display("********************************");
        
        $display("***** TEST Rotate 000 ***** ");
        priority_rotate = 3'b000;
        #10;
        interrupt_request_register = 8'b10000000;
        #10;
        interrupt_request_register = 8'b11000000;
        #10;
        interrupt_request_register = 8'b11100000;
        #10;
        interrupt_request_register = 8'b11110000;
        #10;
        interrupt_request_register = 8'b11111000;
        #10;
        interrupt_request_register = 8'b11111100;
        #10;
        interrupt_request_register = 8'b11111110;
        #10;
        interrupt_request_register = 8'b11111111;
        #10;
        interrupt_request_register = 8'b00000000;
        #10;
        interrupt_request_register = 8'b00000001;
        #10;
        interrupt_request_register = 8'b00000000;

        $display("***** TEST Rotate 001 ***** ");
        priority_rotate = 3'b001;
        #10;
        interrupt_request_register = 8'b10000000;
        #10;
        interrupt_request_register = 8'b11000000;
        #10;
        interrupt_request_register = 8'b11100000;
        #10;
        interrupt_request_register = 8'b11110000;
        #10;
        interrupt_request_register = 8'b11111000;
        #10;
        interrupt_request_register = 8'b11111100;
        #10;
        interrupt_request_register = 8'b11111110;
        #10;
        interrupt_request_register = 8'b11111111;
        #10;
        interrupt_request_register = 8'b00000000;
        #10;
        interrupt_request_register = 8'b00000010;
        #10;
        interrupt_request_register = 8'b00000011;
        #10;
        interrupt_request_register = 8'b00000000;

        $display("***** TEST Rotate 010 ***** ");
        priority_rotate = 3'b010;
        #10;
        interrupt_request_register = 8'b10000000;
        #10;
        interrupt_request_register = 8'b11000000;
        #10;
        interrupt_request_register = 8'b11100000;
        #10;
        interrupt_request_register = 8'b11110000;
        #10;
        interrupt_request_register = 8'b11111000;
        #10;
        interrupt_request_register = 8'b11111100;
        #10;
        interrupt_request_register = 8'b11111110;
        #10;
        interrupt_request_register = 8'b11111111;
        #10;
        interrupt_request_register = 8'b00000000;
        #10;
        interrupt_request_register = 8'b00000100;
        #10;
        interrupt_request_register = 8'b00000110;
        #10;
        interrupt_request_register = 8'b00000111;
        #10;
        interrupt_request_register = 8'b00000000;

        
        $display("***** TEST Rotate 111 ***** ");
        priority_rotate = 3'b111;
        #10;
        interrupt_request_register = 8'b10000000;
        #10;
        interrupt_request_register = 8'b11000000;
        #10;
        interrupt_request_register = 8'b11100000;
        #10;
        interrupt_request_register = 8'b11110000;
        #10;
        interrupt_request_register = 8'b11111000;
        #10;
        interrupt_request_register = 8'b11111100;
        #10;
        interrupt_request_register = 8'b11111110;
        #10;
        interrupt_request_register = 8'b11111111;
        #10;
        interrupt_request_register = 8'b00000000;
        #10;
        interrupt_request_register = 8'b00000000;
        #10;
    
        #10 $finish;
    
  end 
endmodule 