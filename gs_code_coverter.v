// getting started project 
// code converter block

`timescale  1 ns / 1 ns
module code_converter(
    input clk, reset, left_fwd, left_rev, right_fwd, right_rev,
    output reg [2:0] motor_mode
    );
  // motor mode parameters
  parameter  STOP = 3'b000;
  parameter  R_1X = 3'b001;
  parameter  R_2X = 3'b010;
  parameter  L_1X = 3'b011;
  parameter  L_2X = 3'b100;
  parameter  FWD  = 3'b101;
  parameter  REV  = 3'b110;
  
  
  parameter  simulate = 0;
  localparam rojobot_cnt = simulate ? 26'd5			// rojobot clock when simulating
                                      : 26'd19_999_999; // rojobot count when running on HW (5Hz)
                                      
  	//internal registers	
	reg [25:0]	ck_count = 0;	//clock divider counter
	reg 		tick5hz;		// 5 Hz clock enable
	
	// generate 5Hz clock enable
	always @(posedge clk) begin
		if (ck_count == rojobot_cnt) begin
		    tick5hz <= 1'b1;
		    ck_count <= 0;
		end
		else begin
		    ck_count <= ck_count + 1'b1;
		    tick5hz <= 0;
    end
  end    
                                      
      // motion modes   
	always @(posedge clk or posedge reset) begin
		if (reset) begin
			motor_mode <= 3'b000;
		end
		else begin
			if (tick5hz) 
			begin
			  case ({left_fwd, left_rev, right_fwd, right_rev})					
						4'b0000: motor_mode <= STOP; 
						4'b1000: motor_mode <= R_1X;
						4'b0001: motor_mode <= R_1X;
						4'b1001: motor_mode <= R_2X;
						4'b0010: motor_mode <= L_1X;
						4'b0100: motor_mode <= L_1X;
						4'b0110: motor_mode <= L_2X;
						4'b1010: motor_mode <= FWD;
						4'b0101: motor_mode <= REV;
						default: motor_mode <= STOP;
				endcase
			end	//if tick5hz			
	  end 
  end // always
        
endmodule
  
