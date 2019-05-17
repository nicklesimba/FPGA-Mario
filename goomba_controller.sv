module goomba_controller (
									input        Clk,                // 50 MHz clock
												    Reset,              // Active-high reset signal
													 frame_clk,          // The clock indicating a new frame (~60Hz)
									input [1:0]	 roomNum,				// current "level"
									input [9:0]  DrawX, DrawY,       // Current pixel coordinates
									input [9:0]  mario_x, mario_y,	// mario's coordinates
									input [9:0]  mario_size_y,			// mario's y size for collisions
									input [1:0]	 is_alive_mario,		// is mario alive?
									output logic is_goomba,   			// signal for checking to see if a coordinate is a goomba
									output logic walk_num_goomba,		// signal for the walk num of the current goomba (animation)
									output logic is_alive_goomba,		// is the goomba alive?
									output logic [8:0] goomba_address,		// index of goomba for sprite drawing
									output logic [9:0] goomba_r1_1_x,      // goomba r1_1 coordinates
															 goomba_r1_1_y,
									output logic [9:0] goomba_r1_2_x,      // goomba r1_2 coordinates
															 goomba_r1_2_y,
									output logic [9:0] goomba_r2_1_x,      // goomba r2_1 coordinates
															 goomba_r2_1_y,
									output logic [9:0] goomba_r3_1_x,		// goomba r3_1 coordinates
															 goomba_r3_1_y
								 );
	
	logic is_goomba_r1_1, is_goomba_r1_2, is_goomba_r2_1, is_goomba_r3_1;
	logic [8:0] goomba_address_r1_1, goomba_address_r1_2, goomba_address_r2_1, goomba_address_r3_1;
	logic walk_num_goomba_r1_1, walk_num_goomba_r1_2, walk_num_goomba_r2_1, walk_num_goomba_r3_1;
	logic isAlive_r1_1, isAlive_r1_2, isAlive_r2_1, isAlive_r3_1;
	
	
	//enemy placements
		//room 1
		goomba r1_1(.Clk, .Reset, .frame_clk, .DrawX, .DrawY, .roomNum, .myRoomNum(2'd1), .startX(10'd260), .startY(10'd220), .marioX(mario_x), .marioY(mario_y), .mario_size_y, .is_alive_mario, .is_goomba(is_goomba_r1_1), .walk_num_goomba(walk_num_goomba_r1_1), .goomba_address(goomba_address_r1_1), .Goomba_X_Pos(goomba_r1_1_x), .Goomba_Y_Pos(goomba_r1_1_y), .is_alive_goomba(isAlive_r1_1));
		goomba r1_2(.Clk, .Reset, .frame_clk, .DrawX, .DrawY, .roomNum, .myRoomNum(2'd1), .startX(10'd460), .startY(10'd380), .marioX(mario_x), .marioY(mario_y), .mario_size_y, .is_alive_mario, .is_goomba(is_goomba_r1_2), .walk_num_goomba(walk_num_goomba_r1_2), .goomba_address(goomba_address_r1_2), .Goomba_X_Pos(goomba_r1_2_x), .Goomba_Y_Pos(goomba_r1_2_y), .is_alive_goomba(isAlive_r1_2));
		//room 2
		goomba r2_1(.Clk, .Reset, .frame_clk, .DrawX, .DrawY, .roomNum, .myRoomNum(2'd2), .startX(10'd460), .startY(10'd380), .marioX(mario_x), .marioY(mario_y), .mario_size_y, .is_alive_mario, .is_goomba(is_goomba_r2_1), .walk_num_goomba(walk_num_goomba_r2_1), .goomba_address(goomba_address_r2_1), .Goomba_X_Pos(goomba_r2_1_x), .Goomba_Y_Pos(goomba_r2_1_y), .is_alive_goomba(isAlive_r2_1));
		//room 3
		goomba r3_1(.Clk, .Reset, .frame_clk, .DrawX, .DrawY, .roomNum, .myRoomNum(2'd3), .startX(10'd480), .startY(10'd400), .marioX(mario_x), .marioY(mario_y), .mario_size_y, .is_alive_mario, .is_goomba(is_goomba_r3_1), .walk_num_goomba(walk_num_goomba_r3_1), .goomba_address(goomba_address_r3_1), .Goomba_X_Pos(goomba_r3_1_x), .Goomba_Y_Pos(goomba_r3_1_y), .is_alive_goomba(isAlive_r3_1));
		
	always_comb
	begin
		case(roomNum)
			2'd1:
				begin
					if (is_goomba_r1_1 == 1'b1)
					begin
						is_goomba = 1'b1;
						goomba_address = goomba_address_r1_1;
						walk_num_goomba = walk_num_goomba_r1_1;
						is_alive_goomba = isAlive_r1_1;
					end
					else if (is_goomba_r1_2 == 1'b1)
					begin
						is_goomba = 1'b1;
						goomba_address = goomba_address_r1_2;
						walk_num_goomba = walk_num_goomba_r1_2;
						is_alive_goomba = isAlive_r1_2;
					end
					else
					begin
						is_goomba = 1'b0;
						goomba_address = 9'b0;
						walk_num_goomba = 1'b0;
						is_alive_goomba = 1'b0;
					end
				end
			2'd2:
				begin
					if (is_goomba_r2_1 == 1'b1)
					begin
						is_goomba = 1'b1;
						goomba_address = goomba_address_r2_1;
						walk_num_goomba = walk_num_goomba_r2_1;
						is_alive_goomba = isAlive_r2_1;
					end
					else
					begin
						is_goomba = 1'b0;
						goomba_address = 9'b0;
						walk_num_goomba = 1'b0;
						is_alive_goomba = 1'b0;
					end
				end
			2'd3:
				begin
					if (is_goomba_r3_1 == 1'b1)
					begin
						is_goomba = 1'b1;
						goomba_address = goomba_address_r3_1;
						walk_num_goomba = walk_num_goomba_r3_1;
						is_alive_goomba = isAlive_r3_1;
					end
					else
					begin
						is_goomba = 1'b0;
						goomba_address = 9'b0;
						walk_num_goomba = 1'b0;
						is_alive_goomba = 1'b0;
					end
				end
			default:
				begin
					is_goomba = 1'b0;
					goomba_address = 9'b0;
					walk_num_goomba = 1'b0;
					is_alive_goomba = 1'b0;
				end
		endcase
	end
							 
endmodule
