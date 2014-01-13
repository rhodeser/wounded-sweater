// tb.v - testbench for the Xilinx S6 FPGA on Digilent Nexys3 board
//
// Copyright Roy Kravitz, 2008-2013, 2014
// 
// Created By:		John Lynch
// Last Modified:	31-Dec-2014 (RK)
//
// Revision History:
// -----------------
// Jan-2006		JL		Created this module for the Digilent S3E Starter Board
// Dec-2008		RK		Modified module for Rojobot Project 1
// Oct-2009		RK		Fixed bugs and added special characters to 7-segment emulator
// Sep-2012		RK		Modified for Nexys 3 board
// Dec-2014		RK		Cleaned up the formatting.  No functional changes
//
// Description:
// ------------
// This module can be used as a basis for a simulation testbench for the
// ECE 540 Getting Started project
// 
///////////////////////////////////////////////////////////////////////////
`timescale  1 ns / 1 ns
module tb;
 
    wire	[7:0] 	led;
    wire	[39:0]	digits_out = {FPGA.digits_out[31:16], 8'h2E, FPGA.digits_out[15:0]};
 
    reg       		clock = 0;
    reg		 		reset = 0;
    reg 	[3:0]	btn   = 0;
    reg 	[7:0] 	sw    = 0;
    
    // set simulation mode
    defparam    FPGA.RB.simulate = 1,
   		        FPGA.SSB.simulate = 1,
                FPGA.DB.simulate = 1;
   
    // define stimulus interval
    parameter IVL = 5000;
 
	 // instantiate FPGA 
	Nexys3fpga FPGA (
		.clk100(clock),
		.btnr(btn[1]),
		.btnl(btn[3]),
		.btnu(btn[2]),
		.btnd(btn[0]),
		.btns(reset),
		.sw(4'b0000),
	
		.led(led),
		.seg(),
		.an()
	);    

 
    // Generate 100MHz clock
    always #5 clock = ~clock;
    
    // apply stimulus sequence
    // left fwd  = btn[3]
    // left rev  = btn[2]
    // right fwd = btn[1]
    // right rev = btn[0]

    initial begin
    
    	#10 reset = 1'b1;	// reset the system
    	#500 reset = 1'b0;	
    	
                            // no buttons pushed - stopped
        #IVL btn = 4'b0010; // push right fwd    - turn left 1x
        #IVL btn = 4'b1010; // push left fwd     - move forward
        #IVL btn = 4'b1000; // release right fwd - turn right 1x
        #IVL btn = 4'b1001; // push right rev    - turn right 2x
        #IVL btn = 4'b0001; // release left fwd  - turn right 1x 
        #IVL btn = 4'b0101; // push left rev     - move in reverse 
        #IVL btn = 4'b0100; // release right rev - turn left 1x
        #IVL btn = 4'b0110; // push right fwd    - turn left 2x
        #IVL btn = 4'b0000; // release all       - stopped
        #IVL btn = 4'b0011; // right fwd and rev cancel - stopped         
        #IVL btn = 4'b1100; // left fwd and rev cancel  - stopped  
        #IVL btn = 4'b1111; // push all cancels         - stopped   
        #IVL $stop;
    end
          
endmodule // tb




//	SEVEN SEGMENT DISPLAY FOR SIMULATION
//	Created: 23 Dec 2008
// By: Roy Kravitz, Instructor
module sevensegment (
	// Display digits and decimal points
    input	[4:0] 	d0, 				// digit 0 (righmost) value 
    input	[4:0]	d1,					// digit 1 (2nd from right) value
    input	[4:0]	d2,					// digit 2 (2nd from left) value
    input	[4:0]	d3,					// digit 3 (leftmost) value
    input	[3:0]	dp,					// decimal point[dp3, dp2, dp1, dp0]
	
 
    // Nexys3 FPGA Board Seven Segment display
	output	reg [7:0]	seg,					// output to seven segment display cathode
	output	reg [3:0]	an,						// output to seven segment display anode
   
		
	// System inputs and outputs
	input			clk,				// 100MHz clock from on-board oscillator
	input			reset,				// system reset signal - asserted high to reset
	
	   // SIMULATION ONLY - ASCII character output    
	output reg	[31:0] digits_out		// ASCII digits  d3d2d1d0  (decimal points are not simulated)
);

	// internal variables	
	reg [7:0]	a0, a1, a2, a3;			// ASCII digits

	// code conversion	
	   function [7:0] DigToASCII( input [4:0] digit ) ;
      begin
         case(digit)  
         5'h00: DigToASCII = 8'h30;	// hex digits 0 - 9
         5'h01: DigToASCII = 8'h31;
         5'h02: DigToASCII = 8'h32;
         5'h03: DigToASCII = 8'h33;
         5'h04: DigToASCII = 8'h34;
         5'h05: DigToASCII = 8'h35;
         5'h06: DigToASCII = 8'h36;
         5'h07: DigToASCII = 8'h37;
         5'h08: DigToASCII = 8'h38;
         5'h09: DigToASCII = 8'h39;
         
         5'h0a: DigToASCII = 8'h41;	// hex digits A - F
         5'h0b: DigToASCII = 8'h42;
         5'h0c: DigToASCII = 8'h43;
         5'h0d: DigToASCII = 8'h44;
         5'h0e: DigToASCII = 8'h45;
         5'h0f: DigToASCII = 8'h46;
         
         5'h10: DigToASCII = 8'h61;	// segment a
         5'h11: DigToASCII = 8'h62;	// segment b
         5'h12: DigToASCII = 8'h63;	// segment c
         5'h13: DigToASCII = 8'h64;	// segment d
         5'h14: DigToASCII = 8'h65;	// segment e
         5'h15: DigToASCII = 8'h66;	// segment f
         5'h16: DigToASCII = 8'h67;	// segment g
         5'h17: DigToASCII = 8'h2e;	// decimal point
         
         5'h18: DigToASCII = 8'h48; // Special characters for Lab 2 and 3 - Upper case H
         5'h19: DigToASCII = 8'h4C; // upper case L       
         5'h1a: DigToASCII = 8'h52; // upper case R
         5'h1b: DigToASCII = 8'h6C; // lower case L (l)
         5'h1c: DigToASCII = 8'h72; // lower case R (r)
         
         5'h1d: DigToASCII = 8'h20; // *RESERVED* Spaces
         5'h1e: DigToASCII = 8'h20;
         5'h1f: DigToASCII = 8'h20;
         endcase
     end
   endfunction
	
	
	// Tie the outputs for simulation.  They are not used
	assign seg = 8'b0;
	assign an = 4'b0;
	

	// convert digits to ASCII
	always @* begin
		a0 = DigToASCII(d0);
		a1 = DigToASCII(d1);
		a2 = DigToASCII(d2);
		a3 = DigToASCII(d3);
	end // always convert to ASCII
	
	// format output digits
	always @* begin
		digits_out = {a3, a2, a1, a0};
	end  // always format output digits
	
endmodule  // seven_segment
	
