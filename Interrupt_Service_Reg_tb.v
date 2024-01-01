`timescale 1ns/10ps

module Interrupt_Service_Reg_tb;
  
  reg   clk;
  reg   rst;

  reg   [2:0]   priority_rotate;
  reg   [7:0]   interrupt;
  reg   [7:0]   end_of_interrupt;

 
  wire   [7:0]   in_service_register;
  wire   [7:0]   highest_level_in_service;
  
  
Interrupt_Service_Reg dut (
        // Bus
        .clk                              (clk),
        .rst                              (rst),

        // Inputs
        .priority_rotate                    (priority_rotate),
        .interrupt                          (interrupt),
        .end_of_interrupt                   (end_of_interrupt),

        // Outputs
        .in_service_register                (in_service_register),
        .highest_level_in_service           (highest_level_in_service)
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
        priority_rotate  = 3'b111;
        interrupt        = 8'b00000000;
        end_of_interrupt = 8'b00000000;
        #15;
    
    
    $display("********************************");
    $display("***** Test Rotate  **********");
    $display("********************************");
    
        $display("***** Test Rotate 111 *****");
        priority_rotate = 3'b111;
        #10;
        // interrupt 8'b10000000
        interrupt        = 8'b10000000;
        #10;
        interrupt        = 8'b00000000;
        #10;
        // interrupt 8'b01000000
        interrupt        = 8'b01000000;
        #10;
        interrupt        = 8'b00000000;
        #10;
        // interrupt 8'b00100000
        interrupt        = 8'b00100000;
        #10;
        interrupt        = 8'b00000000;
        #10;
        // interrupt 8'b00010000
        interrupt        = 8'b00010000;
        #10;
        interrupt        = 8'b00000000;
        #10;
        // interrupt 8'b00001000
        interrupt        = 8'b00001000;
        #10;
        interrupt        = 8'b00000000;
        #10;
        // interrupt 8'b00000100
        interrupt        = 8'b00000100;
        #10;
        interrupt        = 8'b00000000;
        #10;
        // interrupt 8'b00000010
        interrupt        = 8'b00000010;
        #10;
        interrupt        = 8'b00000000;
        #10;
        // interrupt 8'b00000001
        interrupt        = 8'b00000001;
        #10;
        interrupt        = 8'b00000000;
        #10;
  
        #10;
        // end of interrupt 8'b00000001
        end_of_interrupt = 8'b00000001;
        #10;
        end_of_interrupt = 8'b00000000;
        #10;
        // end of interrupt 8'b00000010
        end_of_interrupt = 8'b00000010;
        #10;
        end_of_interrupt = 8'b00000000;
        #10;
        // end of interrupt 8'b00000100
        end_of_interrupt = 8'b00000100;
        #10;
        end_of_interrupt = 8'b00000000;
        #10;
        // end of interrupt 8'b00001000
        end_of_interrupt = 8'b00001000;
        #10;
        end_of_interrupt = 8'b00000000;
        #10;
        // end of interrupt 8'b00010000
        end_of_interrupt = 8'b00010000;
        #10;
        end_of_interrupt = 8'b00000000;
        #10;
        // end of interrupt 8'b00100000
        end_of_interrupt = 8'b00100000;
        #10;
        end_of_interrupt = 8'b00000000;
        #10;
        // end of interrupt 8'b01000000
        end_of_interrupt = 8'b01000000;
        #10;
        end_of_interrupt = 8'b00000000;
        #10;
        // end of interrupt 8'b10000000
        end_of_interrupt = 8'b10000000;
        #10;
        end_of_interrupt = 8'b00000000;
        #10;
        
        #10;

        $display("***** Test Rotate 100 *****");
        priority_rotate = 3'b100;
        #10;
        // interrupt 8'b10000000
        interrupt        = 8'b10000000;
        #10;
        interrupt        = 8'b00000000;
        #10;
        // interrupt 8'b01000000
        interrupt        = 8'b01000000;
        #10;
        interrupt        = 8'b00000000;
        #10;
        // interrupt 8'b00100000
        interrupt        = 8'b00100000;
        #10;
        interrupt        = 8'b00000000;
        #10;
        // interrupt 8'b00010000
        interrupt        = 8'b00010000;
        #10;
        interrupt        = 8'b00000000;
        #10;
        // interrupt 8'b00001000
        interrupt        = 8'b00001000;
        #10;
        interrupt        = 8'b00000000;
        #10;
        // interrupt 8'b00000100
        interrupt        = 8'b00000100;
        #10;
        interrupt        = 8'b00000000;
        #10;
        // interrupt 8'b00000010
        interrupt        = 8'b00000010;
        #10;
        interrupt        = 8'b00000000;
        #10;
        // interrupt 8'b00000001
        interrupt        = 8'b00000001;
        #10;
        interrupt        = 8'b00000000;
        #10;
  
        #10;
        // end of interrupt 8'b00000001
        end_of_interrupt = 8'b00000001;
        #10;
        end_of_interrupt = 8'b00000000;
        #10;
        // end of interrupt 8'b00000010
        end_of_interrupt = 8'b00000010;
        #10;
        end_of_interrupt = 8'b00000000;
        #10;
        // end of interrupt 8'b00000100
        end_of_interrupt = 8'b00000100;
        #10;
        end_of_interrupt = 8'b00000000;
        #10;
        // end of interrupt 8'b00001000
        end_of_interrupt = 8'b00001000;
        #10;
        end_of_interrupt = 8'b00000000;
        #10;
        // end of interrupt 8'b00010000
        end_of_interrupt = 8'b00010000;
        #10;
        end_of_interrupt = 8'b00000000;
        #10;
        // end of interrupt 8'b00100000
        end_of_interrupt = 8'b00100000;
        #10;
        end_of_interrupt = 8'b00000000;
        #10;
        // end of interrupt 8'b01000000
        end_of_interrupt = 8'b01000000;
        #10;
        end_of_interrupt = 8'b00000000;
        #10;
        // end of interrupt 8'b10000000
        end_of_interrupt = 8'b10000000;
        #10;
        end_of_interrupt = 8'b00000000;
        #10;
        
        #10;
  
  #20 $finish;
end

endmodule