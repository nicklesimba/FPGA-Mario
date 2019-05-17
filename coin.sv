module coin(
					input        Clk,                // 50 MHz clock
                            Reset,              // Active-high reset signal
                            frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]  DrawX, DrawY,       // Current pixel coordinates
					input [1:0]  roomNum,				// game's roomNum
					input	[1:0]	 myRoomNum,				// block's roomNum
					input 		 qblock_empty,			// is the qblock this guy originates from empty? aka should we spawn the coin
					input [9:0]  startX, startY,	      // location of qblock - will never change - ORIGIN BASED POSITION COORDINATES!!!
					input [9:0]	 mario_x, mario_y,		// mario's coordinates for collision with qblock
					input [9:0]	 mario_size_y,		 // mario's y size for collisions
					input [1:0]	 is_alive_mario,		// is mario alive? - if mario bumps a qblock while dead nothing should happen
               output logic is_coin,          // Whether current pixel belongs to coin or background
					output logic [1:0] spin_num,	 // animation for coin spinning
					output logic [9:0] Coin_X_Pos, Coin_Y_Pos,	 // coin's current x and y position
					output logic [8:0] coin_address  // outputs qblock's address for sprite drawing
				 );
				 
	parameter [9:0] Coin_Size_X = 10'd19;	  // Coin x size
	parameter [9:0] Coin_Size_Y = 10'd19;	  // Coin y size
	parameter [4:0] wall_dim = 5'd20;
	
	// States
	logic collected;
	
	// Next States
	logic [1:0] spin_num_in;
	logic collected_in;
	logic [9:0] Coin_X_Pos_in, Coin_Y_Pos_in;
	
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
			Coin_X_Pos <= 10'd800;
			Coin_Y_Pos <= 10'd0;
			spin_num <= 2'd0;
			collected <= 1'b0;
			Clk_counter <= 10'd0;
		end
		else if (roomNum == myRoomNum && qblock_empty && collected != 1'b1) // move coin to the right position and carry on as a coin must
		begin
			Coin_X_Pos <= startX;
         Coin_Y_Pos <= startY;
			spin_num <= spin_num_in;
			collected <= collected_in;
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
			Coin_X_Pos <= 10'd800;
         Coin_Y_Pos <= 10'd0;
			spin_num <= spin_num_in;
			collected <= collected_in;
			Clk_counter <= 0;
		end
	end
   //////// Do not modify the always_ff blocks. ////////
	
	// You need to modify always_comb block.
   always_comb
   begin
		// By default, position unchanged and velocity at 0
      Coin_X_Pos_in = Coin_X_Pos;
      Coin_Y_Pos_in = Coin_Y_Pos;
		spin_num_in = spin_num;
		collected_in = collected;
		
		// Update position and motion only at rising edge of frame clock
      if (frame_clk_rising_edge)
      begin
			Coin_X_Pos_in = Coin_X_Pos;
			Coin_Y_Pos_in = Coin_Y_Pos;
			spin_num_in = spin_num;
			collected_in = collected;
			
			if (collected == 1'b0)
			begin
				if (Clk_counter % 5 == 0)
				begin
					if (spin_num < 2'd3)
						spin_num_in = spin_num + 1'b1;
					else
						spin_num_in = 2'd0;
				end
					
				if ( ((mario_x + 10 >= Coin_X_Pos && mario_x + 10 <= Coin_X_Pos + 19) || (mario_x - 10 >= Coin_X_Pos && mario_x - 10 <= Coin_X_Pos + 19)) 
						&&
					  ((mario_y + mario_size_y <= Coin_Y_Pos + 19 + 1) && (mario_y + mario_size_y >= Coin_Y_Pos))
					   &&
						is_alive_mario != 2'd0
					)
					begin
						collected_in = 1'b1;
					end
			end
		end
	end
	
   // Compute whether the pixel corresponds to Coin or background
   /* Since the multiplicants are required to be signed, we have to first cast them
      from logic to int (signed by default) before they are multiplied. */	
   always_comb begin
		if (DrawX >= Coin_X_Pos && DrawY >= Coin_Y_Pos && DrawX <= (Coin_X_Pos + Coin_Size_X) && DrawY <= (Coin_Y_Pos + Coin_Size_Y))
			is_coin = 1'b1;
		else
			is_coin = 1'b0;
		if (is_coin == 1'b1)
		begin
			coin_address = (DrawX % wall_dim) + (DrawY % wall_dim) * wall_dim;
		end
		else
			coin_address = 9'b0; // don't care
	end
	
endmodule
