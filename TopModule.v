module TopModule (
    // Bus
    input              clk,
    input              rst,
    input              chipSelect,
    input              read_in,
    input              write_in,
    input              A0In,
    input      [7:0]   inDataBus,
    output reg [7:0]   outDataBus,
    output reg         ioDataBus,// to tell the processor that iam sending

    // I/O
    input      [2:0]   cascade_in,
    output     [2:0]   cascade_out,
    output             cascade_io,
    input              SP,
    input              interrupt_acknowledge_n,
    output             interrupt_to_cpu,
    input      [7:0]   interrupt_request
);

    
     wire [7:0]internal_data_bus;
     wire      writeICW1;
     wire      writeICW2to4;
     wire      writeOCW1;
     wire      writeOCW2;
     wire      write_operation_control_word_3;
     wire      read;

    Readwrite_Logic readwrite_Logic (
        
        .clk                              (clk),
        .rst                              (rst),
        .chipSelect                       (chipSelect),
        .read_in                          (read_in),
        .write_in                         (write_in),
        .A0In                             (A0In),
        .inDataBus                        (inDataBus),
        // Control signals
        .internalDataBus                  (internal_data_bus),
        .writeICW1                        (writeICW1),
        .writeICW2to4                     (writeICW2to4),
        .writeOCW1                        (writeOCW1),
        .writeOCW2                        (writeOCW2),
        .writeOCW3                        (writeOCW3),
        .read_flag                        (read)
    );

    
    wire        out_control_data;
    wire        [7:0]control_data;
    wire        level_or_edge_toriggered_config;
    wire        enable_read_register;
    wire        read_register_isr_or_irr;
    wire[7:0]   interrupt;
    wire[7:0]   highest_level_in_service;
    wire[7:0]   interrupt_mask;
    wire[7:0]   end_of_interrupt;
    wire[2:0]   priority_rotate;
    wire        freeze;
    wire[7:0]   clear_IRR;
    
    wire [1:0]RR_RIS;
    
    Control_Logic control_Logic (

        .clk                              (clk),
        .rst                              (rst),

        .cascade_in                       (cascade_in),
        .cascade_out                      (cascade_out),
        .cascade_io                       (cascade_io),

        .SP                               (SP),


        .INTA                             (interrupt_acknowledge_n),
        .INT                              (interrupt_to_cpu),

        .internalDataBus                  (internal_data_bus),
        .writeICW1                        (writeICW1),
        .writeICW2to4                     (writeICW2to4),
        .writeOCW1                        (writeOCW1),
        .writeOCW2                        (writeOCW2),
        .writeOCW3                        (writeOCW3),
        .read                             (read),
        .out_control_logic_data           (out_control_data),
        .control_logic_data               (control_data),

        .level_edge_triggered             (level_or_edge_toriggered_config),



        .RR_RIS                           (RR_RIS),



        .IRR_after_priority_resolver      (interrupt),
        .highest_level_in_service         (highest_level_in_service),


        .IMR                              (interrupt_mask),

        .end_of_interrupt                 (end_of_interrupt),
        .priority_rotate                  (priority_rotate),
        .freeze                           (freeze),
        .clear_IRR                        (clear_IRR)
    );

    // Interrupt Request
    wire [7:0]   interrupt_request_register; 

    Interrupt_Request_Reg interrupt_request_reg (
        // Bus
        .clk                                (clk),
        .rst                                (rst),

        // Inputs from control 
        .level_or_edge_toriggered_config    (level_or_edge_toriggered_config),
        .freeze                             (freeze),
        .clear_IRR                          (clear_IRR),

        // External inputs
        .interrupt_request_pin              (interrupt_request),

        // Outputs
        .interrupt_request_register         (interrupt_request_register)
    );
    
    // Priority Resolver
    wire [7:0]   in_service_register;// reg is put

    Priority_Resolver priority_resolver (
        // Inputs from control 
        .priority_rotate                    (priority_rotate),
        .interrupt_mask                     (interrupt_mask),

        // Inputs
        .interrupt_request_register         (interrupt_request_register),
        .in_service_register                (in_service_register),

        // Outputs
        .interrupt                          (interrupt)
    );

    // In Service
    Interrupt_Service_Reg interrupt_service_reg (
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

    always @(out_control_data or control_data or  read or A0In or interrupt_mask or RR_RIS or
    interrupt_request_register or in_service_register ) begin
        if (out_control_data == 1'b1) begin //During ACK2 state out the vector to the cpu
            ioDataBus  = 1'b0;//default 1 when 0 tell processor that iam sending vector (not in datasheet but added to simplify the implementation)
            outDataBus = control_data;
        end
        else if (read == 1'b0) begin
            ioDataBus  = 1'b1;
            outDataBus = 8'b00000000;
        end
        else if (A0In == 1'b1) begin // read = 1 and ioDatabus =0 imr to cpu
            ioDataBus  = 1'b0;
            outDataBus = interrupt_mask;
        end
        else if (RR_RIS == 2'b10) begin // read the IRR found in ocw3 bit 0,1
            ioDataBus  = 1'b0;
            outDataBus = interrupt_request_register;
        end
        else if (RR_RIS == 2'b11) begin //read isr to the cpu
            ioDataBus  = 1'b0;
            outDataBus = in_service_register;
        end
        else begin
            ioDataBus  = 1'b1;
            outDataBus = 8'b00000000;
        end
    end
endmodule

