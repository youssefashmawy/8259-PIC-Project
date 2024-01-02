module Control_Logic(
  input clk,
  input rst,
  input reg [7:0] internalDataBus,
  input writeICW1,
  input writeICW2to4,
  input writeOCW1,
  input writeOCW2,
  input writeOCW3,
  input read,
  input INTA,
  input [7:0]IRR_after_priority_resolver,
  input SP,
  input   wire   [2:0]   cascade_in,
  output  reg    [2:0]   cascade_out,
  output  wire            cascade_io,
  /*output reg cascade,*/
  input [7:0] highest_level_in_service,
  output reg [7:0] IMR,
  output reg [2:0] priority_rotate,
  output reg [7:0] clear_IRR,
  output reg [7:0] end_of_interrupt,
  output  reg  out_control_logic_data,
  output  reg  [7:0] control_logic_data,
  output reg level_edge_triggered,
  output reg [1:0]RR_RIS,
  output reg INT,
  output reg freeze
  );
  reg IC4_bit;
  reg single_or_cascade_bit;
  reg auto_rotate;
  reg [7:0] master_or_slave_config;
  reg AEOI;
  reg [7:0] outAddress;
  
  reg [7:0] acknowledge_interrupt;
  reg cascade_slave;
  reg cascade_slave_enable;
  wire interrupt_from_slave_device;
  reg cascade_output_ack_2; 
  reg [7:0] interrupt_when_ack1;
  
  wire writeICW2 , writeICW3 , writeICW4 , writeOCW1afterInit , writeOCW2afterInit , writeOCW3afterInit;
  parameter CMD_ENDED_STATE = 2'b00, ICW2_STATE = 2'b01 , ICW3_STATE = 2'b10 , ICW4_STATE = 2'b11; 
  reg [1:0] initialization_state,initialization_nextState;
  
  //separate the icw2->4 to three separate registers
  assign writeICW2 = (initialization_state == ICW2_STATE) & writeICW2to4;
  assign writeICW3 = (initialization_state == ICW3_STATE) & writeICW2to4;
  assign writeICW4 = (initialization_state == ICW4_STATE) & writeICW2to4;
  
  //to identify that initialization is done
  assign writeOCW1afterInit = (initialization_state == CMD_ENDED_STATE) & writeOCW1;
  assign writeOCW2afterInit = (initialization_state == CMD_ENDED_STATE) & writeOCW2; // as writeOCW2 same as writeICW2to4
  assign writeOCW3afterInit = (initialization_state == CMD_ENDED_STATE) & writeOCW3;
  
  //initialization state
  always @(posedge clk or negedge rst) begin
    if(~rst)begin
      initialization_state<=CMD_ENDED_STATE;
    end
    else begin
      initialization_state<=initialization_nextState;  
    end
    
  end
  //FSM
   always @(initialization_state or writeICW1 or writeICW2to4 or single_or_cascade_bit or IC4_bit) begin
        if (writeICW1 == 1'b1)
            initialization_nextState = ICW2_STATE;//go from CMD_ENDED_STATE to ICW2
        else if (writeICW2to4 == 1'b1) begin
            case(initialization_state)
                ICW2_STATE: begin
                    if (single_or_cascade_bit == 1'b0)// 0 cascade need to write icw3
                        initialization_nextState = ICW3_STATE;
                    else if (IC4_bit == 1'b1)
                        initialization_nextState = ICW4_STATE;//no going to 3
                    else
                        initialization_nextState = CMD_ENDED_STATE;
                end
                ICW3_STATE: begin
                    if (IC4_bit == 1'b1)
                        initialization_nextState = ICW4_STATE;
                    else
                        initialization_nextState = CMD_ENDED_STATE;
                end
                ICW4_STATE: begin
                    initialization_nextState = CMD_ENDED_STATE;
                end
                default: begin
                    initialization_nextState = CMD_ENDED_STATE;
                end
            endcase
        end
        else
            initialization_nextState = initialization_state;
    end
    
    parameter CTRL_ENDED_STATE = 2'b00, ACK1_STATE = 2'b01 , ACK2_STATE = 2'b10; 
    reg [1:0] control_state,next_controlState;
    
    reg  delay_INTA;
    wire posedge_INTA,negedge_INTA,end_of_INTA_sequence;
    
    
    always @(posedge clk or negedge rst) begin
        if (~rst)
            delay_INTA <= 1'b1;
        else
            delay_INTA <= INTA;
    end
    assign posedge_INTA = ~delay_INTA &  INTA;
    assign negedge_INTA =  delay_INTA & ~INTA;
    //control state for ack1 and ack2
    always @(posedge clk or negedge rst) begin
        if (~rst)
            control_state <= CTRL_ENDED_STATE;
        else if (writeICW1 == 1'b1)
            control_state <= CTRL_ENDED_STATE;
        else
            control_state <= next_controlState;
    end
    
    always @(control_state or writeOCW2afterInit or negedge_INTA or posedge_INTA) begin
        case (control_state)
            CTRL_ENDED_STATE: begin
                if (writeOCW2afterInit == 1'b1)
                    next_controlState = CTRL_ENDED_STATE;
                else if (negedge_INTA == 1'b1)
                    next_controlState = ACK1_STATE;
                else
                    next_controlState = CTRL_ENDED_STATE;
            end
            ACK1_STATE: begin
                if (negedge_INTA == 1'b1)
                    next_controlState = ACK2_STATE;
                else
                    next_controlState = ACK1_STATE;
            end
            ACK2_STATE: begin
                if (posedge_INTA == 1'b1)
                    next_controlState = CTRL_ENDED_STATE;
                else
                    next_controlState = ACK2_STATE;
            end
            default: begin
                next_controlState = CTRL_ENDED_STATE;
            end
        endcase
    end
    
    assign end_of_INTA_sequence =  (control_state != CTRL_ENDED_STATE) & (next_controlState == CTRL_ENDED_STATE);
    
    // Initialization Command Word 1 (ICW1)
    // Egde level Config and single or cascade and IC4
    always @(posedge clk or negedge rst) begin
      if (~rst) begin
         level_edge_triggered <= 1'b0;
         single_or_cascade_bit <= 1'b0;
         IC4_bit <= 1'b0;
      end
      else if (writeICW1 == 1'b1) begin
          level_edge_triggered <= internalDataBus[3];
          single_or_cascade_bit <= internalDataBus[1];
          IC4_bit <= internalDataBus[0];
      end
      else begin
          level_edge_triggered <= level_edge_triggered;
          single_or_cascade_bit <= single_or_cascade_bit;
          IC4_bit <= IC4_bit;
      end
    end
    
    // Initialization Command Word 2 (ICW2)
    // A15-A8 
    always @(posedge clk or negedge rst) begin
        if (~rst)
            outAddress <= 8'b00000000;
        else if (writeICW1 == 1'b1) 
            outAddress <= 8'b00000000;//found in datasheet
        else if (writeICW2 == 1'b1) 
            outAddress <= internalDataBus;
        else
            outAddress <= outAddress;
    end
    
    // Initialization Command Word 3 (ICW3)
    // S7-S0 (MASTER) or ID2-ID0 (SLAVE)
    always @(posedge clk or negedge rst) begin
        if (~rst)
            master_or_slave_config <= 8'b00000000;// belong to slave or master known from sp
        else if (writeICW1 == 1'b1)
            master_or_slave_config <= 8'b00000000;
        else if (writeICW3 == 1'b1)
            master_or_slave_config <= internalDataBus;
        else
            master_or_slave_config <= master_or_slave_config;
    end
    
    // Initialization Command Word 4 (ICW4)
    // Automatic End of Interrupt (AEOI) signal
    always @(posedge clk or negedge rst) begin
        if (~rst)
            AEOI <= 1'b0;
        else if (writeICW1 == 1'b1)
            AEOI <= 1'b0;
        else if (writeICW4 == 1'b1)
            AEOI <= internalDataBus[1];
        else
            AEOI <= AEOI;
    end
    
    // Operation Control Word 1 (OCW1)
    // interrupt Mask Register (IMR) M7-M0
    always @(posedge clk or negedge rst) begin
        if (~rst)
            IMR <= 8'b11111111;
        else if (writeICW1 == 1'b1)//clear 
            IMR <= 8'b11111111;
        else if (writeOCW1afterInit == 1'b1)
            IMR <= internalDataBus;
        else
            IMR <= IMR;
    end
      
    // End of interrupt
    //OCW2 take from it EOI and automatic rotation mode
    always @(writeICW1 or AEOI or end_of_INTA_sequence or writeOCW2afterInit 
            or internalDataBus or highest_level_in_service) begin
        if (writeICW1 == 1'b1)
            end_of_interrupt = 8'b11111111;// used to clear isr bit after end of operation to determine which bit to clear
        else if ((AEOI == 1'b1) && (end_of_INTA_sequence == 1'b1))//after end of ack 2 endofInterrupt specify which bit to be cleared which was in service
            end_of_interrupt = highest_level_in_service;
        else if (writeOCW2afterInit == 1'b1) begin
            case (internalDataBus[6:5])
                2'b01:   end_of_interrupt = highest_level_in_service;
                2'b11: begin  //end_of_interrupt = num2bit(internalDataBus[2:0]);
                case (internalDataBus[2:0])
                    3'b000:  end_of_interrupt = 8'b00000001;
                    3'b001:  end_of_interrupt = 8'b00000010;
                    3'b010:  end_of_interrupt = 8'b00000100;
                    3'b011:  end_of_interrupt = 8'b00001000;
                    3'b100:  end_of_interrupt = 8'b00010000;
                    3'b101:  end_of_interrupt = 8'b00100000;
                    3'b110:  end_of_interrupt = 8'b01000000;
                    3'b111:  end_of_interrupt = 8'b10000000;
                    default: end_of_interrupt = 8'b00000000;
                endcase
                end
                default: end_of_interrupt = 8'b00000000;
            endcase
        end
        else
            end_of_interrupt = 8'b00000000;
    end
    
    // Automatic Rotation mode(Equal Priority Devices)
    always @(posedge clk or negedge rst) begin
        if (~rst)
            auto_rotate <= 1'b0;
        else if (writeICW1 == 1'b1)
            auto_rotate <= 1'b0;
        else if (writeOCW2afterInit == 1'b1) begin
            case (internalDataBus[7:5])
                3'b100:  auto_rotate <= 1'b1;
                3'b000:  auto_rotate <= 1'b0;
                default: auto_rotate <= auto_rotate;
            endcase
        end
        else
            auto_rotate <= auto_rotate;
    end
    
    
    // Rotate
    always @(posedge clk or negedge rst) begin
        if (~rst)
            priority_rotate <= 3'b111;
        else if (writeICW1 == 1'b1)
            priority_rotate <= 3'b111;
        else if ((auto_rotate == 1'b1) && (end_of_INTA_sequence == 1'b1)) begin
            if (highest_level_in_service[0] == 1'b1) priority_rotate <= 3'b000;
            else if (highest_level_in_service[1] == 1'b1) priority_rotate <= 3'b001;
            else if (highest_level_in_service[2] == 1'b1) priority_rotate <= 3'b010;
            else if (highest_level_in_service[3] == 1'b1) priority_rotate <= 3'b011;
            else if (highest_level_in_service[4] == 1'b1) priority_rotate <= 3'b100;
            else if (highest_level_in_service[5] == 1'b1) priority_rotate <= 3'b101;
            else if (highest_level_in_service[6] == 1'b1) priority_rotate <= 3'b110;
            else if (highest_level_in_service[7] == 1'b1) priority_rotate <= 3'b111;
            else  priority_rotate <= 3'b111;
        end
        else if (writeOCW2afterInit == 1'b1) begin
            case (internalDataBus[7:5])
                3'b101:begin 
                        if (highest_level_in_service[0] == 1'b1) priority_rotate <= 3'b000;
                        else if (highest_level_in_service[1] == 1'b1) priority_rotate <= 3'b001;
                        else if (highest_level_in_service[2] == 1'b1) priority_rotate <= 3'b010;
                        else if (highest_level_in_service[3] == 1'b1) priority_rotate <= 3'b011;
                        else if (highest_level_in_service[4] == 1'b1) priority_rotate <= 3'b100;
                        else if (highest_level_in_service[5] == 1'b1) priority_rotate <= 3'b101;
                        else if (highest_level_in_service[6] == 1'b1) priority_rotate <= 3'b110;
                        else if (highest_level_in_service[7] == 1'b1) priority_rotate <= 3'b111;
                        else  priority_rotate <= 3'b111;
                end
                default: priority_rotate <= priority_rotate;
            endcase
        end
        else
            priority_rotate <= priority_rotate;
    end
    
    //
    // Operation control word 3 (OCW3)
    // RR/RIS
    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            RR_RIS[1:0] <= 2'b10;
        end
        else if (writeICW1 == 1'b1) begin
            RR_RIS[1:0] <= 2'b10;
        end
        else if (writeOCW3afterInit == 1'b1) begin
            RR_RIS[1:0] <= internalDataBus[1:0];
        end
        else begin
            RR_RIS <= RR_RIS;
        end
    end
    
    // Cascade signals
    // Select master/slave
    always @(single_or_cascade_bit or SP) begin
        if (single_or_cascade_bit == 1'b1)
            cascade_slave = 1'b0;
        else
            cascade_slave = ~SP;
    end
    
    assign cascade_io = cascade_slave;
    
    //
    // Cascade signals (slave)
    //
    always @(cascade_slave or master_or_slave_config or cascade_in) begin
        if (cascade_slave == 1'b0)
            cascade_slave_enable = 1'b0;
        else if (master_or_slave_config[2:0] != cascade_in)
            cascade_slave_enable = 1'b0;
        else
            cascade_slave_enable = 1'b1;
    end
    
    // Cascade signals (master)
    assign interrupt_from_slave_device = (acknowledge_interrupt & master_or_slave_config) != 8'b00000000;

    // output ACK2 and ACK3
    always @(single_or_cascade_bit or cascade_slave or cascade_slave_enable or interrupt_from_slave_device) begin
        if (single_or_cascade_bit == 1'b1)
            cascade_output_ack_2 = 1'b1;
        else if (cascade_slave_enable == 1'b1)
            cascade_output_ack_2 = 1'b1;
        else if ((cascade_slave == 1'b0) && (interrupt_from_slave_device == 1'b0))
            cascade_output_ack_2 = 1'b1;
        else
            cascade_output_ack_2 = 1'b0;
    end
    
    // Output slave id
    always @(cascade_slave or control_state or interrupt_from_slave_device) begin
        if (cascade_slave == 1'b1)
            cascade_out <= 3'b000;
        else if ((control_state != ACK1_STATE) && (control_state != ACK2_STATE))
            cascade_out <= 3'b000;
        else if (interrupt_from_slave_device == 1'b0)
            cascade_out <= 3'b000;
        else begin
            if      (acknowledge_interrupt[0] == 1'b1) cascade_out <= 3'b000;
            else if (acknowledge_interrupt[1] == 1'b1) cascade_out <= 3'b001;
            else if (acknowledge_interrupt[2] == 1'b1) cascade_out <= 3'b010;
            else if (acknowledge_interrupt[3] == 1'b1) cascade_out <= 3'b011;
            else if (acknowledge_interrupt[4] == 1'b1) cascade_out <= 3'b100;
            else if (acknowledge_interrupt[5] == 1'b1) cascade_out <= 3'b101;
            else if (acknowledge_interrupt[6] == 1'b1) cascade_out <= 3'b110;
            else if (acknowledge_interrupt[7] == 1'b1) cascade_out <= 3'b111;
            else  cascade_out <= 3'b111;
        end
         
    end
    
    // Interrupt control signals
    // INT
    always @(posedge clk or negedge rst) begin
        if (~rst)
            INT <= 1'b0;
        else if (writeICW1 == 1'b1)
            INT <= 1'b0;
        else if (IRR_after_priority_resolver != 8'b00000000)
            INT <= 1'b1;
        else if (end_of_INTA_sequence == 1'b1)
            INT <= 1'b0;
        else
            INT <= INT;
    end
    
    // freeze
    always @(posedge clk or negedge rst) begin
        if (~rst)
            freeze <= 1'b1;
        else if (next_controlState == CTRL_ENDED_STATE)
            freeze <= 1'b0;
        else
            freeze <= freeze;
    end  
    
    // clear_interrupt_request
    always @(writeICW1 or IRR_after_priority_resolver)begin
        if (writeICW1 == 1'b1)
            clear_IRR = 8'b11111111;
        else
            clear_IRR = IRR_after_priority_resolver;
    end
    
    // interrupt buffer
    always @(posedge clk or negedge rst) begin
        if (~rst)
            acknowledge_interrupt <= 8'b00000000;
        else if (writeICW1 == 1'b1)
            acknowledge_interrupt <= 8'b00000000;
        else if (end_of_INTA_sequence)
            acknowledge_interrupt <= 8'b00000000;
        else if(IRR_after_priority_resolver != 8'b00000000)
            acknowledge_interrupt <= IRR_after_priority_resolver;
        else
            acknowledge_interrupt <= acknowledge_interrupt;
    end
    
    

    always @(posedge clk or negedge rst) begin
        if (~rst)
            interrupt_when_ack1 <= 8'b00000000;
        else if (writeICW1 == 1'b1)
            interrupt_when_ack1 <= 8'b00000000;
        else if (control_state == ACK1_STATE)
            interrupt_when_ack1 <= IRR_after_priority_resolver;
        else
            interrupt_when_ack1 <= interrupt_when_ack1;
    end
    
        always @(INTA or control_state or cascade_output_ack_2 or cascade_slave or interrupt_when_ack1 
                or highest_level_in_service or outAddress) begin
        if (INTA == 1'b0) begin
            // Acknowledge
            if(control_state == ACK2_STATE) begin
                    if (cascade_output_ack_2 == 1'b1) begin
                        out_control_logic_data = 1'b1;

                        if (cascade_slave == 1'b1) begin
                            if      (interrupt_when_ack1[0] == 1'b1) control_logic_data[2:0] = 3'b000;
                            else if (interrupt_when_ack1[1] == 1'b1) control_logic_data[2:0] = 3'b001;
                            else if (interrupt_when_ack1[2] == 1'b1) control_logic_data[2:0] = 3'b010;
                            else if (interrupt_when_ack1[3] == 1'b1) control_logic_data[2:0] = 3'b011;
                            else if (interrupt_when_ack1[4] == 1'b1) control_logic_data[2:0] = 3'b100;
                            else if (interrupt_when_ack1[5] == 1'b1) control_logic_data[2:0] = 3'b101;
                            else if (interrupt_when_ack1[6] == 1'b1) control_logic_data[2:0] = 3'b110;
                            else if (interrupt_when_ack1[7] == 1'b1) control_logic_data[2:0] = 3'b111;
                            else  control_logic_data[2:0] = 3'b111;
                        end
                        else begin
                            if      (highest_level_in_service[0] == 1'b1) control_logic_data[2:0] = 3'b000;
                            else if (highest_level_in_service[1] == 1'b1) control_logic_data[2:0] = 3'b001;
                            else if (highest_level_in_service[2] == 1'b1) control_logic_data[2:0] = 3'b010;
                            else if (highest_level_in_service[3] == 1'b1) control_logic_data[2:0] = 3'b011;
                            else if (highest_level_in_service[4] == 1'b1) control_logic_data[2:0] = 3'b100;
                            else if (highest_level_in_service[5] == 1'b1) control_logic_data[2:0] = 3'b101;
                            else if (highest_level_in_service[6] == 1'b1) control_logic_data[2:0] = 3'b110;
                            else if (highest_level_in_service[7] == 1'b1) control_logic_data[2:0] = 3'b111;
                            else  control_logic_data[2:0] = 3'b111;
                        end
                        control_logic_data = {outAddress[7:3], control_logic_data[2:0]};
                    end
                    else begin
                        out_control_logic_data = 1'b0;
                        control_logic_data     = 8'b00000000;
                    end
                end
        end
        else begin
            out_control_logic_data = 1'b0;
            control_logic_data     = 8'b00000000;
        end
    end
endmodule


