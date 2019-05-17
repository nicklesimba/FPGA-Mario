module wall (
            input [9:0]   DrawX, DrawY,       // Current pixel coordinates
				input [1:0]   RoomNum,				 // current "level"
            output logic  is_wall,            // Whether current pixel belongs to a wall or background
				output logic  is_brick,				 // 1 for brick, 0 for ground
				output logic [8:0] wall_address	 // address for color mapper to figure out what color the wall pixel should be
				);
	
	parameter [4:0] wall_dim = 5'd20;
	
	always_comb 
	begin
		case (RoomNum)
			2'd0: // start screen room
				begin
					// ground tiles
						if ( (DrawX - 0 >= 0) && (DrawX - 0 < 32*wall_dim) && (DrawY - 460 >= 0) && (DrawY - 460 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 0 >= 0) && (DrawX - 0 < 32*wall_dim) && (DrawY - 440 >= 0) && (DrawY - 440 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						// this is the border around the level
						else if ( (DrawX - 0 >= 0) && (DrawX - 0 < 32*wall_dim) && (DrawY - 0 >= 0) && (DrawY - 0 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 620 >= 0) && (DrawX - 620 < wall_dim) && (DrawY - 0 >= 0) && (DrawY - 0 < 18*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 0 >= 0) && (DrawX - 0 < wall_dim) && (DrawY - 0 >= 0) && (DrawY - 0 < 18*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						// end of level border code
						else
						begin
							is_wall = 1'b0;
							is_brick = 1'b0;
						end
				end
			2'd1: // first room
				begin
					// non ground tiles
						if ( (DrawX - 160 >= 0) && (DrawX - 160 < wall_dim) && (DrawY - 160 >= 0) && (DrawY - 160 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b1;
						end
						else if ( (DrawX - 80 >= 0) && (DrawX - 80 < 3*wall_dim) && (DrawY - 360 >= 0) && (DrawY - 360 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b1;
						end
						else if ( (DrawX - 200 >= 0) && (DrawX - 200 < 3*wall_dim) && (DrawY - 260 >= 0) && (DrawY - 260 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b1;
						end
					// ground tiles
						// this is the border around the level
						else if ( (DrawX - 0 >= 0) && (DrawX - 0 < 32*wall_dim) && (DrawY - 0 >= 0) && (DrawY - 0 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 620 >= 0) && (DrawX - 620 < wall_dim) && (DrawY - 0 >= 0) && (DrawY - 0 < 18*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 0 >= 0) && (DrawX - 0 < wall_dim) && (DrawY - 0 >= 0) && (DrawY - 0 < 18*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						// end of level border code
						else if ( (DrawX - 400 >= 0) && (DrawX - 400 < wall_dim) && (DrawY - 420 >= 0) && (DrawY - 420 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 520 >= 0) && (DrawX - 520 < 2*wall_dim) && (DrawY - 420 >= 0) && (DrawY - 420 < 2*wall_dim) )
						begin	
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 540 >= 0) && (DrawX - 540 < wall_dim) && (DrawY - 400 >= 0) && (DrawY - 400 < wall_dim) )
						begin	
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 0 >= 0) && (DrawX - 0 < 10*wall_dim) && (DrawY - 460 >= 0) && (DrawY - 460 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 0 >= 0) && (DrawX - 0 < 10*wall_dim) && (DrawY - 440 >= 0) && (DrawY - 440 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						// gap for testing between 
						else if ( (DrawX - 260 >= 0) && (DrawX - 260 < 21*wall_dim) && (DrawY - 460 >= 0) && (DrawY - 460 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 260 >= 0) && (DrawX - 260 < 21*wall_dim) && (DrawY - 440 >= 0) && (DrawY - 440 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else
						begin
							is_wall = 1'b0;
							is_brick = 1'b0;
						end
				end
			2'd2: //second room
				begin
					// non ground tiles
						if ( (DrawX - 100 >= 0) && (DrawX - 100 < 2*wall_dim) && (DrawY - 360 >= 0) && (DrawY - 360 < wall_dim) ) 
						begin
							is_wall = 1'b1;
							is_brick = 1'b1;
						end
						else if ( (DrawX - 180 >= 0) && (DrawX - 180 < wall_dim) && (DrawY - 340 >= 0) && (DrawY - 340 < wall_dim) ) 
						begin
							is_wall = 1'b1;
							is_brick = 1'b1;
						end
						else if ( (DrawX - 220 >= 0) && (DrawX - 220 < wall_dim) && (DrawY - 320 >= 0) && (DrawY - 320 < wall_dim) ) 
						begin
							is_wall = 1'b1;
							is_brick = 1'b1;
						end
					// ground tiles
						// this is the border around the level
						else if ( (DrawX - 0 >= 0) && (DrawX - 0 < 32*wall_dim) && (DrawY - 0 >= 0) && (DrawY - 0 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 620 >= 0) && (DrawX - 620 < wall_dim) && (DrawY - 0 >= 0) && (DrawY - 0 < 18*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 0 >= 0) && (DrawX - 0 < wall_dim) && (DrawY - 0 >= 0) && (DrawY - 0 < 18*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						// end of level border code
						else if ( (DrawX - 400 >= 0) && (DrawX - 400 < wall_dim) && (DrawY - 420 >= 0) && (DrawY - 420 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 520 >= 0) && (DrawX - 520 < wall_dim) && (DrawY - 420 >= 0) && (DrawY - 420 < wall_dim) )
						begin	
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 0 >= 0) && (DrawX - 0 < 8*wall_dim) && (DrawY - 460 >= 0) && (DrawY - 460 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 0 >= 0) && (DrawX - 0 < 8*wall_dim) && (DrawY - 440 >= 0) && (DrawY - 440 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						// hole 
						else if ( (DrawX - 320 >= 0) && (DrawX - 320 < 16*wall_dim) && (DrawY - 460 >= 0) && (DrawY - 460 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 320 >= 0) && (DrawX - 320 < 16*wall_dim) && (DrawY - 440 >= 0) && (DrawY - 440 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else
						begin
							is_wall = 1'b0;
							is_brick = 1'b0;
						end
				end
			2'd3: // third room
				begin
					// ground tiles
						// this is the border around the level
						if ( (DrawX - 0 >= 0) && (DrawX - 0 < 32*wall_dim) && (DrawY - 0 >= 0) && (DrawY - 0 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 620 >= 0) && (DrawX - 620 < wall_dim) && (DrawY - 0 >= 0) && (DrawY - 0 < 18*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 0 >= 0) && (DrawX - 0 < wall_dim) && (DrawY - 0 >= 0) && (DrawY - 0 < 18*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						// end of border code
						else if ( (DrawX - 400 >= 0) && (DrawX - 400 < wall_dim) && (DrawY - 400 >= 0) && (DrawY - 400 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 400 >= 0) && (DrawX - 400 < 2*wall_dim) && (DrawY - 420 >= 0) && (DrawY - 420 < 2*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 520 >= 0) && (DrawX - 520 < 2*wall_dim) && (DrawY - 420 >= 0) && (DrawY - 420 < 2*wall_dim) )
						begin	
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 540 >= 0) && (DrawX - 540 < wall_dim) && (DrawY - 400 >= 0) && (DrawY - 400 < wall_dim) )
						begin	
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 0 >= 0) && (DrawX - 0 < 10*wall_dim) && (DrawY - 440 >= 0) && (DrawY - 440 < 2*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						// hole 
						else if ( (DrawX - 260 >= 0) && (DrawX - 260 < wall_dim) && (DrawY - 440 >= 0) && (DrawY - 440 < 2*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 320 >= 0) && (DrawX - 320 < 16*wall_dim) && (DrawY - 440 >= 0) && (DrawY - 440 < 2*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else
						begin
							is_wall = 1'b0;
							is_brick = 1'b0;
						end
				end
			default: 
				begin
					is_wall = 1'b0; // needs to be changed
					is_brick = 1'b0;
				end
		endcase
		
		if (is_wall == 1'b1)
		begin
			wall_address = (DrawX % wall_dim) + (DrawY % wall_dim) * wall_dim;
		end
		else
		begin
			wall_address = 9'b0; // don't care
		end
	end
endmodule
