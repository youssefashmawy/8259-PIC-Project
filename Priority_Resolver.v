
module Priority_Resolver (
    // Inputs from control logic
    input   wire   [2:0]   priority_rotate, // for rotation property
    input   wire   [7:0]   interrupt_mask, // when set disable the corresponding pin or irr

    // Inputs
    input   reg   [7:0]   interrupt_request_register, //IRR
    input   reg   [7:0]   in_service_register, // can contain more than one bit set if there is higher priority come

    // Outputs
    output  reg   [7:0]   interrupt //output of priority resolver go to ISR and control unit
);
    

    //
    // Masked flags
    //
    wire   [7:0]   masked_IRR;
    assign masked_IRR = interrupt_request_register & ~interrupt_mask;

    //
    // Resolve priority
    //
    reg   [7:0]   rotate_right_IRR;
    reg   [7:0]   rotate_right_ISR;
    reg   [7:0]   priority_mask;
    reg  [7:0]    highest_priority_rotate;

    //rotate right masked_interrupt_request
    always @(masked_IRR or priority_rotate) begin
      case (priority_rotate)
            3'b000:  rotate_right_IRR = { masked_IRR[0],   masked_IRR[7:1] };
            3'b001:  rotate_right_IRR = { masked_IRR[1:0], masked_IRR[7:2] };
            3'b010:  rotate_right_IRR = { masked_IRR[2:0], masked_IRR[7:3] };
            3'b011:  rotate_right_IRR = { masked_IRR[3:0], masked_IRR[7:4] };
            3'b100:  rotate_right_IRR = { masked_IRR[4:0], masked_IRR[7:5] };
            3'b101:  rotate_right_IRR = { masked_IRR[5:0], masked_IRR[7:6] };
            3'b110:  rotate_right_IRR = { masked_IRR[6:0], masked_IRR[7]   };
            3'b111:  rotate_right_IRR = masked_IRR;
            default: rotate_right_IRR = masked_IRR;
      endcase
    end
    
    //rotate right in_service_register  
    always @(in_service_register or priority_rotate) begin
        case (priority_rotate)
            3'b000:  rotate_right_ISR = { in_service_register[0],   in_service_register[7:1] };
            3'b001:  rotate_right_ISR = { in_service_register[1:0], in_service_register[7:2] };
            3'b010:  rotate_right_ISR = { in_service_register[2:0], in_service_register[7:3] };
            3'b011:  rotate_right_ISR = { in_service_register[3:0], in_service_register[7:4] };
            3'b100:  rotate_right_ISR = { in_service_register[4:0], in_service_register[7:5] };
            3'b101:  rotate_right_ISR = { in_service_register[5:0], in_service_register[7:6] };
            3'b110:  rotate_right_ISR = { in_service_register[6:0], in_service_register[7]   };
            3'b111:  rotate_right_ISR = in_service_register;
            default: rotate_right_ISR = in_service_register;
        endcase
    end
    
    always @(rotate_right_ISR) begin
        if      (rotate_right_ISR[0] == 1'b1) priority_mask = 8'b00000000;
        else if (rotate_right_ISR[1] == 1'b1) priority_mask = 8'b00000001;
        else if (rotate_right_ISR[2] == 1'b1) priority_mask = 8'b00000011;
        else if (rotate_right_ISR[3] == 1'b1) priority_mask = 8'b00000111;
        else if (rotate_right_ISR[4] == 1'b1) priority_mask = 8'b00001111;
        else if (rotate_right_ISR[5] == 1'b1) priority_mask = 8'b00011111;
        else if (rotate_right_ISR[6] == 1'b1) priority_mask = 8'b00111111;
        else if (rotate_right_ISR[7] == 1'b1) priority_mask = 8'b01111111;
        else                                  priority_mask = 8'b11111111;
    end

    always @(rotate_right_IRR or priority_mask) begin
      if      (rotate_right_IRR[0] == 1'b1)    highest_priority_rotate = 8'b00000001;
      else if (rotate_right_IRR[1] == 1'b1)    highest_priority_rotate = 8'b00000010;
      else if (rotate_right_IRR[2] == 1'b1)    highest_priority_rotate = 8'b00000100;
      else if (rotate_right_IRR[3] == 1'b1)    highest_priority_rotate = 8'b00001000;
      else if (rotate_right_IRR[4] == 1'b1)    highest_priority_rotate = 8'b00010000;
      else if (rotate_right_IRR[5] == 1'b1)    highest_priority_rotate = 8'b00100000;
      else if (rotate_right_IRR[6] == 1'b1)    highest_priority_rotate = 8'b01000000;
      else if (rotate_right_IRR[7] == 1'b1)    highest_priority_rotate = 8'b10000000;
      else                                     highest_priority_rotate = 8'b00000000;
      
      highest_priority_rotate = highest_priority_rotate & priority_mask;
    end

    always @(priority_rotate or highest_priority_rotate) begin
       case (priority_rotate)
            3'b000:  interrupt = { highest_priority_rotate[6:0], highest_priority_rotate[7]   };
            3'b001:  interrupt = { highest_priority_rotate[5:0], highest_priority_rotate[7:6] };
            3'b010:  interrupt = { highest_priority_rotate[4:0], highest_priority_rotate[7:5] };
            3'b011:  interrupt = { highest_priority_rotate[3:0], highest_priority_rotate[7:4] };
            3'b100:  interrupt = { highest_priority_rotate[2:0], highest_priority_rotate[7:3] };
            3'b101:  interrupt = { highest_priority_rotate[1:0], highest_priority_rotate[7:2] };
            3'b110:  interrupt = { highest_priority_rotate[0],   highest_priority_rotate[7:1] };
            3'b111:  interrupt = highest_priority_rotate;
            default: interrupt = highest_priority_rotate;
        endcase
      
      
    end

endmodule
