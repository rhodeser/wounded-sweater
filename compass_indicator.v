// Compass Indicator for getting started project


`timescale  1 ns / 1 ns
module compass_indicator(
    input clk, reset, 
    input [2:0] motion_mode , 
    output reg [4:0] d1,d2,d3   //digit to be displayed 
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
  localparam rojobot_cnt_5 = simulate ? 26'd5			// rojobot clock when simulating
                                      : 26'd19_999_999; // rojobot count when running on HW (5Hz)
  
  localparam rojobot_cnt_10 = simulate ? 26'd10			// rojobot clock when simulating
                                      : 26'd9_999_999; // rojobot count when running on HW (10Hz)     
                                                                 
  localparam rojobot_cnt_1 = simulate ? 26'd10			// rojobot clock when simulating
                                      : 26'd99_999_995; // rojobot count when running on HW (1Hz)     
                                                                       
  	//internal registers	
	reg [25:0]	ck_count = 0;	//clock divider counter
	reg 		tick5hz;		// 5 Hz clock enable
	reg 		tick10hz;		// 10 Hz clock enable
	
	
	// generate 5Hz clock enable
	always @(posedge clk) begin
		if (ck_count == rojobot_cnt_5) begin
		    tick5hz <= 1'b1;
		    ck_count <= 0;
		end
		else begin
		    ck_count <= ck_count + 1'b1;
		    tick5hz <= 0;
    end
  end
   
   	// generate 10Hz clock enable
	always @(posedge clk) begin
		if (ck_count == rojobot_cnt_10) begin
		    tick10hz <= 1'b1;
		    ck_count <= 0;
		end
		else begin
		    ck_count <= ck_count + 1'b1;
		    tick10hz <= 0;
    end 
  end
    
  // inc/dec compass indication counter    
	always @(posedge clk or posedge reset) begin
		if (reset) begin
			d1 <= 3'b000;
			d2 <= 3'b000;
			d3 <= 3'b000;
		end
		else begin			
				case (motion_mode)
					STOP | FWD | REV : begin
					      d1 <= d1;
					      d2 <= d2;
					      d3 <= d3;  
					  end
					R_1X : begin 
					   if (tick5hz) begin  
					     if (d1 == 0 && d2 == 0 && d3 == 0) begin
				           d3 <= 5'd3;
				           d2 <= 5'd5;
				           d1 <= 5'd9;
					       end
					      else begin
					         if (d1 == 0 && d2 == 0) begin
					           d3 <= d3 - 1'b1;
					           d2 <= 5'd9;
					           d1 <= 5'd9;
					         end
					         else begin
					           if(d1 == 0) begin
					             d3 <= d3;
					             d2 <= d2 - 1'b1;
					             d1 <= 5'd9;
					           end
					           else begin
					             d3 <= d3;
					             d2 <= d2;
					             d1<= d1 - 1'b1;
					           end
					          end
					      end
					   end
					end
					L_1X : begin
					  if (tick5hz) begin
					     if (d1 == 9 && d2 == 5 && d3 == 3) begin
				           d3 <= 5'd0;
				           d2 <= 5'd0;
				           d1 <= 5'd0;
					       end
					     else begin
					         if (d1 == 9 && d2 == 9) begin
					           d3 <= d3 + 1'b1;
					           d2 <= 5'd0;
					           d1 <= 5'd0;
					         end
					         else begin
					           if(d1 == 9) begin
					             d3 <= d3;
					             d2 <= d2 + 1'b1;
					             d1 <= 5'd0;
					           end
					           else begin
					             d3 <= d3;
					             d2 <= d2;
					             d1<= d1 + 1'b1;
					           end
					         end
					     end
					  end
					end				  
					R_2X : begin
					   if (tick10hz) begin   
					     if (d1 == 0 && d2 == 0 && d3 == 0) begin
				           d3 <= 5'd3;
				           d2 <= 5'd5;
				           d1 <= 5'd9;
					      end
					      else begin
					         if (d1 == 0 && d2 == 0) begin
					           d3 <= d3 - 1'b1;
					           d2 <= 5'd9;
					           d1 <= 5'd9;
					         end
					         else begin
					           if(d1 == 0) begin
					             d3 <= d3;
					             d2 <= d2 - 1'b1;
					             d1 <= 5'd9;
					           end
					           else begin
					             d3 <= d3;
					             d2 <= d2;
					             d1<= d1 - 1'b1;
					           end
					         end
					      end
					   end
					end
					L_2X : begin
					  if (tick10hz) begin
					     if (d1 == 9 && d2 == 5 && d3 == 3) begin
				           d3 <= 5'd0;
				           d2 <= 5'd0;
				           d1 <= 5'd0;
					       end
					     else begin
					         if (d1 == 9 && d2 == 9) begin
					           d3 <= d3 + 1'b1;
					           d2 <= 5'd0;
					           d1 <= 5'd0;
					         end
					         else begin
					           if(d1 == 9) begin
					             d3 <= d3;
					             d2 <= d2 + 1'b1;
					             d1 <= 5'd0;
					           end
					           else begin
					             d3 <= d3;
					             d2 <= d2;
					             d1<= d1 + 1'b1;
					           end
					         end
					     end
					  end
					end			  
				endcase				  
   	end
	end
	endmodule
	