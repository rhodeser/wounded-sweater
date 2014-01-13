// bot1.v - Reference design for ECE 540 Rojobot Getting Started project
//
// Copyright John Lynch and Roy Kravitz, 2006-2013, 2014
// 
// Created By:		John Lynch
// Last Modified:	31-Dec-2014 (RK)
//
// Revision History:
// -----------------
// Dec-2006		JL		Created this module for ECE 540
// Dec-2014		RK		Cleaned up the formatting.  No functional changes
//
// Description:
// ------------
// This module is the reference design for the ECE 540 Getting Started project.  It
// emulates a simple two-wheeled robot.  Each wheel is controlled independently by
// pushbuttons.  The "forward" buttons increase 8-bit wheel counters (one per wheel)
// The "reverse" buttons decrease the wheel counters.  The wheel counters are 
// incremented at 5Hz by dividing the 100MHz Nexys 3 system clock down to 5Hz.
// The "simulate" parameter should be set to 1'b1 if the design is being
// simulated to keep the simulation time reasonable
// 
///////////////////////////////////////////////////////////////////////////
`timescale  1 ns / 1 ns
module RojoBot1(
    input clk, reset, left_fwd, left_rev, right_fwd, right_rev,
    output reg [7:0] left_pos = 0, right_pos = 0
    );
    
    parameter  simulate = 0;
    localparam rojobot_cnt = simulate ? 26'd5			// rojobot clock when simulating
                                      : 26'd19_999_999; // rojobot count when running on HW (5Hz)

	//internal registers	
	reg [25:0]	ck_count = 0;	//clock divider counter
	reg 		tick5hz;		// 5 Hz clock enable
	
	// generate 5Hz clock enable
	always @(posedge clk)
		if (ck_count == rojobot_cnt) begin
		    tick5hz <= 1'b1;
		    ck_count <= 0;
		end
		else begin
		    ck_count <= ck_count + 1'b1;
		    tick5hz <= 0;
      end
    
    // inc/dec wheel position counters    
	always @(posedge clk or posedge reset) begin
		if (reset) begin
			left_pos <= 0;
			right_pos <= 0;
		end
		else begin
			if (tick5hz) begin
				case ({left_fwd, left_rev})
					2'b10: left_pos  <= left_pos + 1'b1;
					2'b01: left_pos  <= left_pos - 1'b1;
				endcase
				case ({right_fwd, right_rev})
						2'b10: right_pos <= right_pos + 1'b1;
						2'b01: right_pos <= right_pos - 1'b1;
				endcase
			end
		end
	end
        
endmodule