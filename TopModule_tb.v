
`timescale 1ns/10ps


module TopModule_tb;
  
  reg           clk;
  reg           rst;
  
  reg           chipSelect;
  reg           read_in;
  reg           write_in;
  reg           A0In;
  reg   [7:0]   inDataBus;
  wire  [7:0]   outDataBus;
  wire          ioDataBus;
  reg   [2:0]   cascade_in;
  wire  [2:0]   cascade_out;
  wire          cascade_io;
  reg           SP;

  reg           interrupt_acknowledge_n;
  wire           interrupt_to_cpu;
  reg   [7:0]   interrupt_request;
  
  TopModule duti (
  .clk                      (clk),
  .rst                      (rst),
  
  .chipSelect            (chipSelect),
  .read_in            (read_in),
  .write_in           (write_in),
  .A0In                  (A0In),
  
  .inDataBus                (inDataBus),
  .outDataBus             (outDataBus),   
  .ioDataBus              (ioDataBus),
  
  .cascade_in               (cascade_in),
  .cascade_out              (cascade_out),
  .cascade_io               (cascade_io),
  .SP                       (SP),  
  
  .interrupt_acknowledge_n  (interrupt_acknowledge_n),
  .interrupt_to_cpu         (interrupt_to_cpu),
  .interrupt_request        (interrupt_request)
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
        chipSelect           = 1'b1;
        read_in           = 1'b1;
        write_in          = 1'b1;
        A0In                 = 1'b0;
        inDataBus             = 8'b00000000;
        cascade_in              = 3'b000;
        SP         = 1'b0;
        interrupt_acknowledge_n = 1'b1;
        interrupt_request       = 8'b00000000;
    #95;
    
    
    $display("******************************** ");
    $display("***** Test Interrupt  *****");
    $display("******************************** ");
            $display("***** T7-T3=5b'10000 *****");
        // ICW1
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b00011111;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;

        // ICW2
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b1;
        inDataBus     = 8'b10000000;
        #10
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10

        // ICW4
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b1;
        inDataBus     = 8'b00001101;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;

        // OCW1
	      chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b1;
        inDataBus     = 8'b00000000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;
        
        // OCW3
	      chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b00001000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;


        // Interrupt
        interrupt_request = 8'b00000001;
        #10;
        interrupt_request = 8'b00000000;
        // Send_ACK
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
	      // send specific EOI (OCW2)
	      chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b01100000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;

	  

	      interrupt_request = 8'b00000010;
        #10;
        interrupt_request = 8'b00000000;
        // Send_ACK
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
	      // send specific EOI (OCW2)
	      chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b01100001;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;

	  

	      interrupt_request = 8'b00000100;
        #10;
        interrupt_request = 8'b00000000;
        // Send_ACK
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
	      // send specific EOI (OCW2)
	      chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b01100010;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;
	  

	      interrupt_request = 8'b00001000;
        #10;
        interrupt_request = 8'b00000000;
        // Send_ACK
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
	      // send specific EOI (OCW2)
	      chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b01100011;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;


	      interrupt_request = 8'b00010000;
        #10;
        interrupt_request = 8'b00000000;
        // Send_ACK
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
	      // send specific EOI (OCW2)
	      chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b01100100;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;


	      interrupt_request = 8'b00100000;
        #10;
        interrupt_request = 8'b00000000;
        // Send_ACK
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
	      // send specific EOI (OCW2)
	      chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b01100101;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;

        $display("***** T7-T3=0b'00001 *****");
        // ICW1
	      chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b00011111;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;
        // ICW2
	      chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b1;
        inDataBus     = 8'b00001000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;
        // ICW4
	      chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b1;
        inDataBus     = 8'b00001101;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;
        // OCW1
	      chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b1;
        inDataBus     = 8'b00000000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;
        // OCW3
	      chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b00001000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;

        // Interrupt
	      interrupt_request = 8'b00000001;
        #10;
        interrupt_request = 8'b00000000;
        // Send_ACK
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        // send specific EOI (OCW2)
	      chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b01100000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;
        
        rst = 0;
        #5 rst = 1;	
        #5;

        #100;
    
    
    $display("********************************");
    $display("***** Test Level Trigger *******");
    $display("********************************");
    
        // ICW1
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b00011111;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;

        // ICW2
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b1;
        inDataBus     = 8'b10000000;
        #10
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10

        // ICW4
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b1;
        inDataBus     = 8'b00001101;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;

        // OCW1
	      chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b1;
        inDataBus     = 8'b00000000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;
        
        // OCW3
	      chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b00001000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;


        // Interrupt
        interrupt_request = 8'b00000001;
        #10;
        interrupt_request = 8'b00000000;
        // Send_ACK
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
	      // send specific EOI (OCW2)
	      chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b01100000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;


        // Interrupt
        interrupt_request = 8'b00000010;
        #10;
        interrupt_request = 8'b00000000;
        // Send_ACK
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
	      // send specific EOI (OCW2)
	      chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b01100001;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;	

  
        rst = 0;
        #5 rst = 1;	
        #5;     
	  
	  #100;
    
    $display("********************************");
    $display("***** Test Edge Trigger *******");
    $display("********************************");
    
    
        // ICW1
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b00010111;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;

        // ICW2
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b1;
        inDataBus     = 8'b10000000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;
        
        // ICW4
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b1;
        inDataBus     = 8'b00001101;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;

        // OCW1
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b1;
        inDataBus     = 8'b00000000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;

        // OCW3
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b00001000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;
        

        interrupt_request = 8'b00000001;
        #10;
        // Send_ACK
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
	      // send specific EOI (OCW2)
	      chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b01100000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;        
        #20;

        interrupt_request = 8'b00000010;
        #10;
        // Send_ACK
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
	      // send specific EOI (OCW2)
	      chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b01100001;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;        
        #20;

        interrupt_request = 8'b00000100;
        #10;
        // Send_ACK
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
	      // send specific EOI (OCW2)
	      chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b01100010;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;        
        #20;
        
        rst = 0;
        #5 rst = 1;	
        #5;
        
    #100;
     
    $display("********************************");
    $display("***** Test Interrupt Mask *******");
    $display("********************************");
      

        // ICW1
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b00011111;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;
       
        // ICW2
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b1;
        inDataBus     = 8'b10000000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;

        // ICW4
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b1;
        inDataBus     = 8'b00001101;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;

        // OCW3
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b00001000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;


        

        // OCW1
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b1;
        inDataBus     = 8'b11111110;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;

        // Interrupt
        interrupt_request = 8'b11111111;
        #10;
        interrupt_request = 8'b00000000;
        // Send_ACK
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
	      // send specific EOI (OCW2)
	      chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b01100000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;        
        

        // OCW1
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b1;
        inDataBus     = 8'b11111101;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;
        // Interrupt
        interrupt_request = 8'b11111111;
        #10;
        interrupt_request = 8'b00000000;
        // Send_ACK
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
	      // send specific EOI (OCW2)
	      chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b01100001;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10; 

        // OCW1
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b1;
        inDataBus     = 8'b11111011;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;
        // Interrupt
        interrupt_request = 8'b11111111;
        #10;
        interrupt_request = 8'b00000000;
        // Send_ACK
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
	      // send specific EOI (OCW2)
	      chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b01100010;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10; 
        
        
        rst = 0;
        #5 rst = 1;	
        #5;
        
      #100;
      
    $display("********************************");
    $display("***** Test Auto EOI *******");
    $display("********************************");
    
        // ICW1
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b00011111;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10; 

        // ICW2
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b1;
        inDataBus     = 8'b10000000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10; 

        // ICW4
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b1;
        inDataBus     = 8'b00001111;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10; 

        // OCW1
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b1;
        inDataBus     = 8'b00000000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10; 

        // OCW3
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b00001000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10; 

        // Interrupt
        interrupt_request = 8'b11111111;
        #10;
        // Send_ACK
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        #10;

        // Send_ACK
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        #10;

        // Send_ACK
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        #10;
        
        interrupt_request = 8'b00000000;
        
        rst = 0;
        #5 rst = 1;	
        #5;
        
     #100;
     
    $display("********************************");
    $display("***** Test Non Specific EOI *******");
    $display("********************************");   
        

        // ICW1
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b00011111;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10; 
        
        // ICW2
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b1;
        inDataBus     = 8'b10000000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;

        // ICW4
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b1;
        inDataBus     = 8'b00001101;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;

        // OCW1
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b1;
        inDataBus     = 8'b00000000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;

        // OCW3
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b00001000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;

        // interrupt 8'b10000000
        interrupt_request        = 8'b10000000;
        #10;
        interrupt_request        = 8'b00000000;
        #10;
        // interrupt 8'b01000000
        interrupt_request        = 8'b01000000;
        #10;
        interrupt_request        = 8'b00000000;
        #10;
        // interrupt 8'b00100000
        interrupt_request        = 8'b00100000;
        #10;
        interrupt_request        = 8'b00000000;
        #10;
        // interrupt 8'b00010000
        interrupt_request        = 8'b00010000;
        #10;
        interrupt_request        = 8'b00000000;
        #10;
        // Send_ACK
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        // Send Non Specific EOI (OCW2)
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b00100000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;

        // Send_ACK
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        // Send Non Specific EOI (OCW2)
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b00100000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;

        // Send_ACK
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        // Send Non Specific EOI (OCW2)
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b00100000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;
        
        interrupt_request = 8'b00000000;
        
        rst = 0;
        #5 rst = 1;	
        #5;
        
     #100;
     
    $display("********************************");
    $display("***** Test Fully Nested Mode *******");
    $display("********************************");   
    
          // ICW1
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b00011111;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10; 
        
        // ICW2
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b1;
        inDataBus     = 8'b10000000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;

        // ICW4
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b1;
        inDataBus     = 8'b00001101;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;

        // OCW1
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b1;
        inDataBus     = 8'b00000000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;

        // OCW3
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b00001000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;
        
        
        // Interrupt
        interrupt_request = 8'b00010000;
        #10;
        interrupt_request = 8'b00000000;
        // Send_ACK
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        #10;
        // Interrupt
        interrupt_request = 8'b01000000;
        #10;  
        interrupt_request = 8'b00000000;
        // Interrupt
        interrupt_request = 8'b00001000;
        #10;
        interrupt_request = 8'b00000000;
        // Send_ACK
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        // Send Specific EOI (OCW2)
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b01100011;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;
        
        // Send_ACK
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        // Send Non Specific EOI (OCW2)
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b00100000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;
        
        // Send_ACK
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        // Send Non Specific EOI (OCW2)
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b00100000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;
        
        rst = 0;
        #5 rst = 1;	
        #5;
        
     #100;
     
     
    $display("********************************");
    $display("***** Test Rotation *******");
    $display("********************************");    
    
        // ICW1
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b00011111;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10

        // ICW2
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b1;
        inDataBus     = 8'b10000000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10

        // ICW4
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b1;
        inDataBus     = 8'b00000010;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10

        // OCW1
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b1;
        inDataBus     = 8'b00000000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10

        // OCW3
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b00001000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10

        
        // OCW2
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b10000000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10


        // Interrupt
        interrupt_request = 8'b11110000;
        #10
        interrupt_request = 8'b00000000;
        // Send_ACK
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        // Send Non Specific EOI (OCW2)
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b00100000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;
        
        
        // Interrupt
        interrupt_request = 8'b11100010;
        #10
        interrupt_request = 8'b00000000;
        // Send_ACK
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        // Send Non Specific EOI (OCW2)
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b00100000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;
        
        // OCW2
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10
       

        rst = 0;
        #5 rst = 1;	
        #5;
      
    #100;
    $display("********************************");
    $display("***** Test Register Reading Status *******");
    $display("********************************");
    
        // ICW1
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b00011111;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10

        // ICW2
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b1;
        inDataBus     = 8'b10000000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10

        // ICW4
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b1;
        inDataBus     = 8'b00001101;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10

        // OCW1
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b1;
        inDataBus     = 8'b00000000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10

        // OCW3
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b00001000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10

        
        $display("***** READ IRR ***** ");
        // OCW3
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b00001010;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10

        // Read Data
        chipSelect   = 1'b0;
        read_in   = 1'b0;
        A0In         = 1'b0;
        #10;
        chipSelect   = 1'b1;
        read_in   = 1'b1;
        #10;
        
        // Interrupt
        interrupt_request = 8'b00000001;
        #10;
        interrupt_request = 8'b00000000;
        // Send_ACK
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        #10;
        // Send Non Specific EOI (OCW2)
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b00100000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;
        
        // Interrupt
        interrupt_request = 8'b00010000;
        #10;
        interrupt_request = 8'b00000000;
        // Read Data
        chipSelect   = 1'b0;
        read_in   = 1'b0;
        A0In         = 1'b0;
        #10;
        chipSelect   = 1'b1;
        read_in   = 1'b1;
        #10;
        
        // Send_ACK
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        #10;
        // Send Non Specific EOI (OCW2)
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b00100000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;

        // Interrupt
        interrupt_request = 8'b00000010;
        #10;
        interrupt_request = 8'b00000000;
        // Read Data
        chipSelect   = 1'b0;
        read_in   = 1'b0;
        A0In         = 1'b0;
        #10;
        chipSelect   = 1'b1;
        read_in   = 1'b1;
        #10;
        
        // Send_ACK
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        #10;
        // Send Non Specific EOI (OCW2)
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b00100000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;
        
        
        $display("***** read isr ***** ");
        // OCW3
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b00001011;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10

        // interrupt 8'b10000000
        interrupt_request = 8'b10000000;
        #10;
        interrupt_request = 8'b00000000;
        #10;
        // interrupt 8'b01000000
        interrupt_request = 8'b01000000;
        #10;
        interrupt_request = 8'b00000000;
        #10;
        // interrupt 8'b00100000
        interrupt_request = 8'b00100000;
        #10;
        interrupt_request = 8'b00000000;
        #10;
        // interrupt 8'b00010000
        interrupt_request = 8'b00010000;
        #10;
        interrupt_request = 8'b00000000;
        #10;
        // Read Data
        chipSelect   = 1'b0;
        read_in   = 1'b0;
        A0In         = 1'b0;
        #10;
        chipSelect   = 1'b1;
        read_in   = 1'b1;
        #10;

        
        // Send_ACK
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        #10;
        // Send Non Specific EOI (OCW2)
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b00100000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;
        // Read Data
        chipSelect   = 1'b0;
        read_in   = 1'b0;
        A0In         = 1'b0;
        #10;
        chipSelect   = 1'b1;
        read_in   = 1'b1;
        #10; 
        
        // Send_ACK
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        #10;
        // Send Non Specific EOI (OCW2)
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b00100000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;
        // Read Data
        chipSelect   = 1'b0;
        read_in   = 1'b0;
        A0In         = 1'b0;
        #10;
        chipSelect   = 1'b1;
        read_in   = 1'b1;
        #10;
        
        // Send_ACK
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        #10;
        // Read Data
        chipSelect   = 1'b0;
        read_in   = 1'b0;
        A0In         = 1'b0;
        #10;
        chipSelect   = 1'b1;
        read_in   = 1'b1;
        #10;
        
        $display("***** read imr ***** ");
        // OCW1
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b1;
        inDataBus     = 8'b00000000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10

        // Read Data
        chipSelect   = 1'b0;
        read_in   = 1'b0;
        A0In         = 1'b1;
        #10;
        chipSelect   = 1'b1;
        read_in   = 1'b1;
        #10;

        // OCW1
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b1;
        inDataBus     = 8'b00000001;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10
        
        // Read Data
        chipSelect   = 1'b0;
        read_in   = 1'b0;
        A0In         = 1'b1;
        #10;
        chipSelect   = 1'b1;
        read_in   = 1'b1;
        #10;
        
        
        rst = 0;
        #5 rst = 1;	
        #5;
        
    #100;
    
    $display("********************************");
    $display("***** Test Cascade Mode *******");
    $display("********************************");
            
        $display("***** cascade mode (master) *****");
        // ICW1
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b00011101;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10

        // ICW2
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b1;
        inDataBus     = 8'b00000000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10

        // ICW3
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b1;
        inDataBus     = 8'b00000111;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10

        // ICW4
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b1;
        inDataBus     = 8'b00000001;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10

        // OCW1
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b1;
        inDataBus     = 8'b00000000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10

        // OCW3
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b00001000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10

        SP = 1'b1;

        // interrupt
        interrupt_request = 8'b00000111;
        #10;
        interrupt_request = 8'b00000000;  
  
        // Send_ACK
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        // Send Non Specific EOI (OCW2)
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b00100000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;
        
        // interrupt
        interrupt_request = 8'b00000110;
        #10;
        interrupt_request = 8'b00000000;
        // Send_ACK
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        // Send Non Specific EOI (OCW2)
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b00100000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;
        
        // interrupt
        interrupt_request = 8'b00000100;
        #10;
        interrupt_request = 8'b00000000;
        // Send_ACK
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        // Send Non Specific EOI (OCW2)
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b00100000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;
        
        
        
        $display("***** cascade mode (slave) ***** ");

        SP         = 1'b0;


        // interrupt
        interrupt_request = 8'b01000000;
        #10;
        interrupt_request = 8'b00000000;
        
        // Send ACK to Slave 000
        interrupt_acknowledge_n = 1'b1;
        cascade_in = 3'b000;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #5;
        cascade_in = 3'b000;
        #5;
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        cascade_in = 3'b000;
        // Send ACK to Slave 001
        interrupt_acknowledge_n = 1'b1;
        cascade_in = 3'b000;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #5;
        cascade_in = 3'b001;
        #5;
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        cascade_in = 3'b000;
        // Send ACK to Slave 010
        interrupt_acknowledge_n = 1'b1;
        cascade_in = 3'b000;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #5;
        cascade_in = 3'b010;
        #5;
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        cascade_in = 3'b000;
        // Send ACK to Slave 110
        interrupt_acknowledge_n = 1'b1;
        cascade_in = 3'b000;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #5;
        cascade_in = 3'b110;
        #5;
        interrupt_acknowledge_n = 1'b1;
        #10;
        interrupt_acknowledge_n = 1'b0;
        #10;
        interrupt_acknowledge_n = 1'b1;
        cascade_in = 3'b000;



        // Send Non Specific EOI (OCW2)
        chipSelect   = 1'b0;
        write_in  = 1'b0;
        A0In         = 1'b0;
        inDataBus     = 8'b00100000;
        #10;
        chipSelect   = 1'b1;
        write_in  = 1'b1;
        A0In         = 1'b0;
        inDataBus     = 8'b00000000;
        #10;
        
        rst = 0;
        #5 rst = 1;
    
        
     #101  $finish;
  
  end
  
  
endmodule


