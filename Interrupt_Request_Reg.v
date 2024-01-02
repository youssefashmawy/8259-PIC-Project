module Interrupt_Request_Reg (
    input   wire           clk,
    input   wire           rst,

    // Inputs from control logic
    input   wire           level_or_edge_toriggered_config, //  1:level - 0:edge
    input   wire           freeze, //when set doesn't accept any of the out interrupts
    input   wire   [7:0]   clear_IRR, // come from the control unit

    // External inputs
    input   wire   [7:0]   interrupt_request_pin, // input from the i/o devices

    // Outputs
    output  reg   [7:0]   interrupt_request_register // Internal IRR of the module
);
    reg     [7:0]   delay_request; // used for the edge trigger
    wire    [7:0]   posedge_edge_request; // IRR assigned to it in case of edge triggered is chosed
    genvar index;
    generate
    for (index = 0; index <= 7; index = index + 1) begin
        // Edge Sense
        always @(posedge clk or negedge rst) begin
        if (~rst)
            delay_request[index] <= 1'b0;
        else if (clear_IRR[index])
            delay_request[index] <= 1'b0;
        else if (~interrupt_request_pin[index])
            delay_request[index] <= 1'b1;
        else
            delay_request[index] <= delay_request[index];
        end

	      //low edge before & high edge of input
        assign posedge_edge_request[index] = (delay_request[index] == 1'b1) & (interrupt_request_pin[index] == 1'b1);
        
        always @(posedge clk or negedge rst) begin
            if (~rst)
                interrupt_request_register[index] <= 1'b0;
            else if (clear_IRR[index])
                interrupt_request_register[index] <= 1'b0;
            else if (freeze)
                interrupt_request_register[index] <= interrupt_request_register[index];
            else if (level_or_edge_toriggered_config)
                interrupt_request_register[index] <= interrupt_request_pin[index]; // level sense
            else
                interrupt_request_register[index] <= posedge_edge_request[index]; // edge sense
        end
    end
    endgenerate

endmodule