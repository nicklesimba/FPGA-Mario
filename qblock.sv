module qblock(
					input        Clk,                // 50 MHz clock
                            Reset,              // Active-high reset signal
                            frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]  DrawX, DrawY,       // Current pixel coordinates
					input [1:0]  roomNum,				// game's roomNum
					input	[1:0]	 myRoomNum,				// block's roomNum
					input [9:0]  posX, posY,	      // location of qblock - will never change - ORIGIN BASED POSITION COORDINATES!!!
					input [9:0]	 mario_x, mario_y,		// mario's coordinates for collision with qblock
					input [9:0]	 mario_size_y,		 // mario's y size for collisions
					input [1:0]	 is_alive_mario,		// is mario alive? - if mario bumps a qblock while dead nothing should happen
               output logic is_qblock,          // Whether current pixel belongs to qblock or background
					output logic blink_num,	   		// animation for qblock blinking
					output logic is_empty,				// is qblock empty? - used for animation and for qblock logic
					output logic [8:0] qblock_address  // outputs qblock's address for sprite drawing
				 );
				 
	parameter [9:0] Qblock_Size_X = 10'd19;	  // Qblock x size
	parameter [9:0] Qblock_Size_Y = 10'd19;	  // Qblock y size
	parameter [4:0] wall_dim = 5'd20;
	
	// States
	logic [9:0] Qblock_X_Pos, Qblock_Y_Pos;
	
	// Next States
	logic	blink_num_in, is_empty_in;
	logic [9:0] Qblock_X_Pos_in, Qblock_Y_Pos_in;
	
	// Misc.
	logic [9:0] Clk_counter;
	
	//////// Do not modify the always_ff blocks. ////////
   // Detect rising edge of frame_clk
   logic frame_clk_delayed, frame_clk_rising_edge;
   always_ff @ (posedge Clk) begin
      frame_clk_delayed <= frame_clk;
		frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
   end
	 
    // Update registers
   always_ff @ (posedge Clk)
   begin
		if (Reset) // move qblock to storage place
      begin
			Qblock_X_Pos <= 10'd800;
			Qblock_Y_Pos <= 10'd0;
			blink_num <= 1'b1;
			is_empty <= 1'b0;
			Clk_counter <= 10'd0;
		end
		else if (roomNum == myRoomNum) // move qblock to the right position and carry on as a qblock must
		begin
			Qblock_X_Pos <= posX;
         Qblock_Y_Pos <= posY;
			blink_num <= blink_num_in;
			is_empty <= is_empty_in;
			if (Clk_counter > 1000)
				Clk_counter <= 0;
			else
			begin
				if (frame_clk_rising_edge)
					Clk_counter++;
			end
		end
      else									// move qblock back to storage place
      begin
			Qblock_X_Pos <= 10'd800;
         Qblock_Y_Pos <= 10'd0;
			blink_num <= blink_num_in;
			is_empty <= is_empty_in;
			Clk_counter <= 0;
		end
	end
   //////// Do not modify the always_ff blocks. ////////
	
	// You need to modify always_comb block.
   always_comb
   begin
		// By default, position unchanged and velocity at 0
      Qblock_X_Pos_in = Qblock_X_Pos;
      Qblock_Y_Pos_in = Qblock_Y_Pos;
		blink_num_in = blink_num;
		is_empty_in = is_empty;
		
		// Update position and motion only at rising edge of frame clock
      if (frame_clk_rising_edge)
      begin
			Qblock_X_Pos_in = Qblock_X_Pos;
			Qblock_Y_Pos_in = Qblock_Y_Pos;
			blink_num_in = blink_num;
			is_empty_in = is_empty;
			
			if (is_empty == 1'b0)
			begin
				if (Clk_counter % 10 == 0)
				begin
					if (blink_num == 1'b1)
						blink_num_in = 1'b0;
					else
						blink_num_in = 1'b1;
				end
					
				if ( ((mario_x + 7 >= Qblock_X_Pos && mario_x + 7 <= Qblock_X_Pos + Qblock_Size_X) || (mario_x - 7 >= Qblock_X_Pos && mario_x - 7 <= Qblock_X_Pos + Qblock_Size_X)) 
						&&
					  ((mario_y - mario_size_y <= Qblock_Y_Pos + Qblock_Size_Y + 1) && (mario_y - mario_size_y > Qblock_Y_Pos + 9))
					   &&
						is_alive_mario != 2'd0
					)
					begin
						is_empty_in = 1'b1;
					end
			end
		end
	end
	
   // Compute whether the pixel corresponds to Qblock or background
   /* Since the multiplicants are required to be signed, we have to first cast them
      from logic to int (signed by default) before they are multiplied. */	
   always_comb begin
		if (DrawX >= Qblock_X_Pos && DrawY >= Qblock_Y_Pos && DrawX <= (Qblock_X_Pos + Qblock_Size_X) && DrawY <= (Qblock_Y_Pos + Qblock_Size_Y))
			is_qblock = 1'b1;
		else
			is_qblock = 1'b0;
		if (is_qblock == 1'b1)
		begin
			qblock_address = (DrawX % wall_dim) + (DrawY % wall_dim) * wall_dim;
		end
		else
			qblock_address = 9'b0; // don't care
	end
	
endmodule
