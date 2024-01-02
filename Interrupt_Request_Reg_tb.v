`timescale 1ns/10ps

module Interrupt_Request_Reg_tb;
  
  reg           clk;
  reg           rst;
 
  reg           level_or_edge_toriggered_config;
  reg           freeze;
  reg   [7:0]   clear_IRR;
 
  reg   [7:0]   interrupt_request_pin;

  wire   [7:0]   interrupt_request_register;

  Interrupt_Request_Reg duttt (
        // Bus
        .clk                              (clk),
        .rst                              (rst),

        // Inputs from control 
        .level_or_edge_toriggered_config    (level_or_edge_toriggered_config),
        .freeze                             (freeze),
        .clear_IRR                          (clear_IRR),

        // External inputs
        .interrupt_request_pin              (interrupt_request_pin),

        // Outputs
        .interrupt_request_register         (interrupt_request_register)
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
        level_or_edge_toriggered_config = 1'b0;
        freeze                  = 1'b0;
        interrupt_request_pin   = 8'b00000000;
        clear_IRR = 8'b00000000;
        #15;
    
    $display("********************************");
    $display("***** Test Level Trigger  **********");
    $display("********************************");
        // level trigger 8'b00000001
        level_or_edge_toriggered_config = 1'b1;
        #10;
        interrupt_request_pin   = 8'b00000001;
        #10;
        clear_IRR = 8'b00000001;
        #10;
        clear_IRR = 8'b00000000;
        #10;
        // level trigger 8'b00000010
        level_or_edge_toriggered_config = 1'b1;
        #10;
        interrupt_request_pin   = 8'b00000010;
        #10;
        clear_IRR = 8'b00000010;
        #10;
        clear_IRR = 8'b00000000;
        #10;
        // level trigger 8'b00000100
        level_or_edge_toriggered_config = 1'b1;
        #10;
        interrupt_request_pin   = 8'b00000100;
        #10;
        clear_IRR = 8'b00000100;
        #10;
        clear_IRR = 8'b00000000;
        #10;
       
        clear_IRR = 8'b11111111;
        #10;
        clear_IRR = 8'b00000000;
        #10;
        
        
    $display("********************************");
    $display("***** Test Edge Trigger  **********");
    $display("********************************"); 
        // Edge trigger 8'b00000001
        level_or_edge_toriggered_config = 1'b0;
        #10;
        interrupt_request_pin   = 8'b00000000;
        #10;
        interrupt_request_pin   = 8'b00000001;
        #10;
        clear_IRR = 8'b00000001;
        #10;
        clear_IRR = 8'b00000000;
        #10;
        // Edge trigger 8'b00000010
        level_or_edge_toriggered_config = 1'b0;
        #10;
        interrupt_request_pin   = 8'b00000000;
        #10;
        interrupt_request_pin   = 8'b00000010;
        #10;
        clear_IRR = 8'b00000010;
        #10;
        clear_IRR = 8'b00000000;
        #10;
        // Edge trigger 8'b00000100
        level_or_edge_toriggered_config = 1'b0;
        #10;
        interrupt_request_pin   = 8'b00000000;
        #10;
        interrupt_request_pin   = 8'b00000100;
        #10;
        clear_IRR = 8'b00000100;
        #10;
        clear_IRR = 8'b00000000;
        #10;
        
        clear_IRR = 8'b11111111;
        #10;
        clear_IRR = 8'b00000000;
        #10;
        
    // Freeze = 1'b1
    freeze = 1'b1;

    $display("********************************");
    $display("***** Test Level Trigger  **********");
    $display("********************************");
        // level trigger 8'b00000001
        level_or_edge_toriggered_config = 1'b1;
        #10;
        interrupt_request_pin   = 8'b00000001;
        #10;
        clear_IRR = 8'b00000001;
        #10;
        clear_IRR = 8'b00000000;
        #10;
        // level trigger 8'b00000010
        level_or_edge_toriggered_config = 1'b1;
        #10;
        interrupt_request_pin   = 8'b00000010;
        #10;
        clear_IRR = 8'b00000010;
        #10;
        clear_IRR = 8'b00000000;
        #10;
        // level trigger 8'b00000100
        level_or_edge_toriggered_config = 1'b1;
        #10;
        interrupt_request_pin   = 8'b00000100;
        #10;
        clear_IRR = 8'b00000100;
        #10;
        clear_IRR = 8'b00000000;
        #10;
       
        clear_IRR = 8'b11111111;
        #10;
        clear_IRR = 8'b00000000;
        #10;
        
    $display("********************************");
    $display("***** Test Edge Trigger  **********");
    $display("********************************"); 
        // Edge trigger 8'b00000001
        level_or_edge_toriggered_config = 1'b0;
        #10;
        interrupt_request_pin   = 8'b00000000;
        #10;
        interrupt_request_pin   = 8'b00000001;
        #10;
        clear_IRR = 8'b00000001;
        #10;
        clear_IRR = 8'b00000000;
        #10;
        // Edge trigger 8'b00000010
        level_or_edge_toriggered_config = 1'b0;
        #10;
        interrupt_request_pin   = 8'b00000000;
        #10;
        interrupt_request_pin   = 8'b00000010;
        #10;
        clear_IRR = 8'b00000010;
        #10;
        clear_IRR = 8'b00000000;
        #10;
        // Edge trigger 8'b00000100
        level_or_edge_toriggered_config = 1'b0;
        #10;
        interrupt_request_pin   = 8'b00000000;
        #10;
        interrupt_request_pin   = 8'b00000100;
        #10;
        clear_IRR = 8'b00000100;
        #10;
        clear_IRR = 8'b00000000;
        #10;
        
        clear_IRR = 8'b11111111;
        #10;
        clear_IRR = 8'b00000000;
        #10;
        
   #20 $finish;
end
endmodule