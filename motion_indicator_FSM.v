module motion_FSM(
    input [2:0] motion_mode,
    input clk, reset,
	output reg [4:0] LED
    );

  // motor mode parameters
  parameter  STOP = 3'b000;
  parameter  RIGHT_1x = 3'b001;
  parameter  RIGHT_2x = 3'b010;
  parameter  LEFT_1x = 3'b011;
  parameter  LEFT_2x = 3'b100;
  parameter  FORWARD  = 3'b101;
  parameter  REVERSE  = 3'b110;
  parameter simulate = 0;

	//internal registers	
	reg [25:0]	ck_count   = 0;	//clock divider counter
	reg [26:0] ck_count_2 = 0;
	reg 		tick5hz;		// 5 Hz clock enable
	reg 		tick2hz;		// 2 Hz enable
	reg [7:0] State, NextState;

localparam bot_cnt_5 = simulate ? 26'd5					// rojobot clock when simulating
                                  : 26'd19_999_999;		// rojobot count when running on HW (5Hz)
localparam bot_cnt_2 = simulate ? 26'd5					
                                  : 26'd49_999_999;		// rojobot count when running on HW (2Hz)

								  
parameter 

		A 		= 5'd16,
		B 		= 5'd17,
		C 		= 5'd18,
		D 		= 5'd19,
		E 		= 5'd20,
		F 		= 5'd21,
		G 		= 5'd22,								  
		BLANK 	= 5'd23,
		
		segment_a 	=	8'b00000001,
		segment_b 	=	8'b00000010,
		segment_c 	=	8'b00000100,
		segment_d 	=	8'b00001000,
		segment_e 	=	8'b00010000,
		segment_f 	=	8'b00100000,
		segment_g 	=	8'b01000000,
		no_segment =	8'b10000000;
		
		
	
always @(posedge clk)
begin
if (reset)
	State <= no_segment;
else
	State <= NextState;
end	
//if reset

//need to have forward and back blink at 1hz, 

//define initial state

	// generate 5Hz clock enable
	always @(posedge clk)
		if (ck_count == bot_cnt_5) begin
		    tick5hz <= 1'b1;
		    ck_count <= 0;
		end
		else 
		begin
		    ck_count <= ck_count + 1'b1;
		    tick5hz <= 0;
      end
	  
	  	// generate 2Hz clock enable
	always @(posedge clk)
		if (ck_count_2 == bot_cnt_2) begin
		    tick2hz <= 1'b1;
		    ck_count_2 <= 0;
		end
		else begin
		    ck_count_2 <= ck_count_2 + 1'b1;
		    tick2hz <= 0;
      end


//current state logic

//if 10hz, LED = A, LED = A + 1

	always @*
	begin
		case (State)
			segment_a: 	LED = A;
			segment_b: 	LED = B;
			segment_c: 	LED = C;
			segment_d: 	LED = D;
			segment_e: 	LED = E;
			segment_f: 	LED = F;
			segment_g: 	LED = G;
			no_segment: LED = BLANK;
	  endcase
	end
		
//next state logic

	always @ (posedge clk)
	begin
		case (State)
			segment_a:
			begin
				if		(STOP) 					NextState = segment_g;
				else if (RIGHT_1x && tick5hz) 	NextState = segment_b;
				else if (RIGHT_2x)				NextState = segment_b;
				else if (LEFT_1x  && tick5hz) 	NextState = segment_f;			
				else if (LEFT_2x)				NextState = segment_f;
				else if (FORWARD) begin
					 if (tick2hz)    	NextState = no_segment;
                     else                    	NextState = segment_a;
            end
				else if (REVERSE) begin
                     if (tick2hz)  		NextState = no_segment;
                     else                  		NextState = segment_d;
                     end
				else 							NextState = no_segment;	
				   
			end
			
			segment_b:
			begin
				if		(STOP) 					NextState = segment_g;
				else if (RIGHT_1x && tick5hz) 	NextState = segment_c;
				else if (RIGHT_2x)				NextState = segment_c;
				else if (LEFT_1x  && tick5hz) 	NextState = segment_a;			
				else if (LEFT_2x)				NextState = segment_a;
				else if (FORWARD) begin
					 if (tick2hz)    	NextState = no_segment;
                     else                    	NextState = segment_a;
              end
				else if (REVERSE) begin
                     if (tick2hz)  		NextState = no_segment;
                     else                  		NextState = segment_d;
                     end
				else 							NextState = no_segment;	
				 
			end
			
			segment_c:
			begin
				if		(STOP) 					NextState = segment_g;
				else if (RIGHT_1x && tick5hz) 	NextState = segment_d;
				else if (RIGHT_2x)				NextState = segment_d;
				else if (LEFT_1x  && tick5hz) 	NextState = segment_b;			
				else if (LEFT_2x)				NextState = segment_b;
				else if (FORWARD) begin
					 if (tick2hz)    	NextState = no_segment;
                     else                    	NextState = segment_a;
              end
				else if (REVERSE) begin
                     if (tick2hz)  		NextState = no_segment;
                     else                  		NextState = segment_d;
                       end
				else 							NextState = no_segment;	
				  
			end
			
			segment_d:
			begin
				if		(STOP) 					NextState = segment_g;
				else if (RIGHT_1x && tick5hz) 	NextState = segment_e;
				else if (RIGHT_2x)				NextState = segment_e;
				else if (LEFT_1x  && tick5hz) 	NextState = segment_c;			
				else if (LEFT_2x)				NextState = segment_c;
				else if (FORWARD) begin
					 if (tick2hz)    	NextState = no_segment;
                     else                    	NextState = segment_a;
              end
				else if (REVERSE) begin
                     if (tick2hz)  		NextState = no_segment;
                     else                  		NextState = segment_d;
                       end
				else 							NextState = no_segment;
					
			end
			
			segment_e:
			begin
				if		(STOP) 					NextState = segment_g;
				else if (RIGHT_1x && tick5hz) 	NextState = segment_f;
				else if (RIGHT_2x)				NextState = segment_f;
				else if (LEFT_1x  && tick5hz) 	NextState = segment_d;			
				else if (LEFT_2x)				NextState = segment_d;
				else if (FORWARD) begin
					 if (tick2hz)    	NextState = no_segment;
                     else                    	NextState = segment_a;
              end
				else if (REVERSE) begin
                     if (tick2hz)  		NextState = no_segment;
                     else                  		NextState = segment_d;
                       end
				else 							NextState = no_segment;	
				  
			end
			
			segment_f:
			begin
				if		(STOP) 					NextState = segment_g;
				else if (RIGHT_1x && tick5hz) 	NextState = segment_a;
				else if (RIGHT_2x)				NextState = segment_a;
				else if (LEFT_1x  && tick5hz) 	NextState = segment_e;			
				else if (LEFT_2x)				NextState = segment_e;
				else if (FORWARD) begin
					 if (tick2hz)    	NextState = no_segment;
                     else                    	NextState = segment_a;
              end
				else if (REVERSE) begin
                     if (tick2hz)  		NextState = no_segment;
                     else                  		NextState = segment_d;
                       end
				else 							NextState = no_segment;	
				  
			end
			
			segment_g:
			begin
				if		(STOP) 					NextState = segment_g;
				else if (RIGHT_1x && tick5hz) 	NextState = segment_b;
				else if (RIGHT_2x)				NextState = segment_b;
				else if (LEFT_1x  && tick5hz) 	NextState = segment_f;			
				else if (LEFT_2x)				NextState = segment_f;
				else if (FORWARD) begin
					 if (tick2hz)    	NextState = no_segment;
                     else                    	NextState = segment_a;
              end
				else if (REVERSE) begin
                     if (tick2hz)  		NextState = no_segment;
                     else                  		NextState = segment_d;
                       end
				else 							NextState = no_segment;	
				  
			end
			
			no_segment:
			begin
				if		(STOP) 					NextState = segment_g;
				else if (RIGHT_1x && tick5hz) 	NextState = segment_a;
				else if (RIGHT_2x)				NextState = segment_a;
				else if (LEFT_1x  && tick5hz) 	NextState = segment_f;			
				else if (LEFT_2x)				NextState = segment_f;
				else if (FORWARD) begin
					 if (tick2hz)    	NextState = no_segment;
                     else                    	NextState = segment_a;
            end
				else if (REVERSE) begin
                     if (tick2hz)  		NextState = no_segment;
                     else                  		NextState = segment_d;
                     end
				else 							NextState = no_segment;	
				   
			end
			
	endcase
	end
endmodule	
//need asynchronous reset if diividing clock?
