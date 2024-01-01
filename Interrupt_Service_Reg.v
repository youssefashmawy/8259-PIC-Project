module Interrupt_Service_Reg (
    input   wire           clk,
    input   wire           rst,

    // Inputs
    input   wire   [2:0]   priority_rotate,
    input   wire   [7:0]   interrupt,
    input   wire   [7:0]   end_of_interrupt,

    // Outputs
    output  reg   [7:0]   in_service_register,
    output  reg   [7:0]   highest_level_in_service
);
    
    // In service register
    wire   [7:0]   next_ISR;

    assign next_ISR = (in_service_register & ~end_of_interrupt)
                                     | (interrupt);

    always @(posedge clk or negedge rst) begin
        if (~rst)
            in_service_register <= 8'b00000000;
        else
            in_service_register <= next_ISR;
    end
    // Get Highst level in service
    reg   [7:0]   next_chosen_level_ISR;

    always @(next_ISR or priority_rotate) begin
        next_chosen_level_ISR = next_ISR;
        
        case (priority_rotate)
            3'b000:  next_chosen_level_ISR = { next_chosen_level_ISR[0],   next_chosen_level_ISR[7:1] };
            3'b001:  next_chosen_level_ISR = { next_chosen_level_ISR[1:0], next_chosen_level_ISR[7:2] };
            3'b010:  next_chosen_level_ISR = { next_chosen_level_ISR[2:0], next_chosen_level_ISR[7:3] };
            3'b011:  next_chosen_level_ISR = { next_chosen_level_ISR[3:0], next_chosen_level_ISR[7:4] };
            3'b100:  next_chosen_level_ISR = { next_chosen_level_ISR[4:0], next_chosen_level_ISR[7:5] };
            3'b101:  next_chosen_level_ISR = { next_chosen_level_ISR[5:0], next_chosen_level_ISR[7:6] };
            3'b110:  next_chosen_level_ISR = { next_chosen_level_ISR[6:0], next_chosen_level_ISR[7]   };
            3'b111:  next_chosen_level_ISR = next_chosen_level_ISR;
            default: next_chosen_level_ISR = next_chosen_level_ISR;
        endcase
        
        if      (next_chosen_level_ISR[0] == 1'b1)    next_chosen_level_ISR = 8'b00000001;
        else if (next_chosen_level_ISR[1] == 1'b1)    next_chosen_level_ISR = 8'b00000010;
        else if (next_chosen_level_ISR[2] == 1'b1)    next_chosen_level_ISR = 8'b00000100;
        else if (next_chosen_level_ISR[3] == 1'b1)    next_chosen_level_ISR = 8'b00001000;
        else if (next_chosen_level_ISR[4] == 1'b1)    next_chosen_level_ISR = 8'b00010000;
        else if (next_chosen_level_ISR[5] == 1'b1)    next_chosen_level_ISR = 8'b00100000;
        else if (next_chosen_level_ISR[6] == 1'b1)    next_chosen_level_ISR = 8'b01000000;
        else if (next_chosen_level_ISR[7] == 1'b1)    next_chosen_level_ISR = 8'b10000000;
        else                                          next_chosen_level_ISR = 8'b00000000;
        
        case (priority_rotate)
            3'b000:  next_chosen_level_ISR = { next_chosen_level_ISR[6:0], next_chosen_level_ISR[7]   };
            3'b001:  next_chosen_level_ISR = { next_chosen_level_ISR[5:0], next_chosen_level_ISR[7:6] };
            3'b010:  next_chosen_level_ISR = { next_chosen_level_ISR[4:0], next_chosen_level_ISR[7:5] };
            3'b011:  next_chosen_level_ISR = { next_chosen_level_ISR[3:0], next_chosen_level_ISR[7:4] };
            3'b100:  next_chosen_level_ISR = { next_chosen_level_ISR[2:0], next_chosen_level_ISR[7:3] };
            3'b101:  next_chosen_level_ISR = { next_chosen_level_ISR[1:0], next_chosen_level_ISR[7:2] };
            3'b110:  next_chosen_level_ISR = { next_chosen_level_ISR[0],   next_chosen_level_ISR[7:1] };
            3'b111:  next_chosen_level_ISR = next_chosen_level_ISR;
            default: next_chosen_level_ISR = next_chosen_level_ISR;
        endcase

    end

    always @(posedge clk or negedge rst) begin
        if (~rst)
            highest_level_in_service <= 8'b00000000;
        else
            highest_level_in_service <= next_chosen_level_ISR;
    end

endmodule
