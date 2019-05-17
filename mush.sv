module mush (  input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
					input [1:0]   roomNum, myRoomNum, // game and goomba's roomNum
					input 		  qblock_empty,		 // is the qblock this guy originates from empty? aka should we spawn the mush
					input [9:0]   startX, startY,	    // initial location
					input [9:0]	  marioX, marioY,		 // mario's coordinates
					input [9:0]	  mario_size_y,		 // mario's y size for collisions
					input [1:0]	  is_alive_mario,		 // is mario alive?
               output logic  is_mush,            // Whether current pixel belongs to mushroom or background
					output logic  [9:0] Mush_X_Pos, Mush_Y_Pos, // current position
					output logic  [8:0] mush_address  // outputs goomba's address for sprite drawing   
              );
				  
	parameter [9:0] Mush_X_Min = 10'd0;       // Leftmost point on the X axis
   parameter [9:0] Mush_X_Max = 10'd639;     // Rightmost point on the X axis
   parameter [9:0] Mush_Y_Min = 10'd0;       // Topmost point on the Y axis
   parameter [9:0] Mush_Y_Max = 10'd479;     // Bottommost point on the Y axis
//   parameter [9:0] Goomba_Y_Step = 10'd2;      // Step size on the Y axis
   logic [9:0] Mush_Size_X;						  // Goomba x size
	assign Mush_Size_X = 10'd10;
	logic [9:0] Mush_Size_Y;						  // Goomba y size
	assign Mush_Size_Y = 10'd10;
    
   
	// States
	logic [9:0] Mush_X_Vel, Mush_Y_Vel;
	logic normal_functionality;
	logic collected;
	
	// Next States
	logic [9:0] Mush_X_Pos_in, Mush_Y_Pos_in, Mush_X_Vel_in, Mush_Y_Vel_in;
	logic collected_in;
	
	// Misc.
	logic [9:0] Mush_X_Pos_in_temp, Mush_Y_Pos_in_temp;
	logic [9:0] Clk_counter;
	

		
	// collision - gravity
	wall down_collision(.DrawX(Mush_X_Pos_in), .DrawY(Mush_Y_Pos_in + Mush_Size_Y + 1), .RoomNum(myRoomNum), .is_wall(is_wall_down));
	wall down_right_collision(.DrawX(Mush_X_Pos_in + 7*Mush_Size_X/10 + 1), .DrawY(Mush_Y_Pos_in + Mush_Size_Y + 1), .RoomNum(myRoomNum), .is_wall(is_wall_down_right));
	wall down_left_collision(.DrawX(Mush_X_Pos_in - 7*Mush_Size_X/10 - 1), .DrawY(Mush_Y_Pos_in + Mush_Size_Y + 1), .RoomNum(myRoomNum), .is_wall(is_wall_down_left));
	
	// collision checks - gravity 
	logic is_wall_down, is_wall_down_left, is_wall_down_right;
	
	// collision checks - pushing back out
	wall right_collision_pushback(.DrawX(Mush_X_Pos_in_temp + Mush_Size_X), .DrawY(Mush_Y_Pos), .RoomNum(myRoomNum), .is_wall(is_wall_right_pushback));
	wall left_collision_pushback(.DrawX(Mush_X_Pos_in_temp - Mush_Size_X), .DrawY(Mush_Y_Pos), .RoomNum(myRoomNum), .is_wall(is_wall_left_pushback));
	wall up_collision_pushback(.DrawX(Mush_X_Pos), .DrawY(Mush_Y_Pos_in_temp - Mush_Size_Y), .RoomNum(myRoomNum), .is_wall(is_wall_up_pushback));
	wall down_collision_pushback(.DrawX(Mush_X_Pos), .DrawY(Mush_Y_Pos_in_temp + Mush_Size_Y), .RoomNum(myRoomNum), .is_wall(is_wall_down_pushback));
	wall up_left_collision_pushback(.DrawX(Mush_X_Pos_in_temp - Mush_Size_X), .DrawY(Mush_Y_Pos_in_temp - Mush_Size_Y), .RoomNum(myRoomNum), .is_wall(is_wall_up_left_pushback));
	wall down_left_collision_pushback(.DrawX(Mush_X_Pos_in_temp - Mush_Size_X), .DrawY(Mush_Y_Pos_in_temp + Mush_Size_Y), .RoomNum(myRoomNum), .is_wall(is_wall_down_left_pushback));
	wall up_right_collision_pushback(.DrawX(Mush_X_Pos_in_temp + Mush_Size_X), .DrawY(Mush_Y_Pos_in_temp - Mush_Size_Y), .RoomNum(myRoomNum), .is_wall(is_wall_up_right_pushback));
	wall down_right_collision_pushback(.DrawX(Mush_X_Pos_in_temp + Mush_Size_X), .DrawY(Mush_Y_Pos_in_temp + Mush_Size_Y), .RoomNum(myRoomNum), .is_wall(is_wall_down_right_pushback));
	
	// collision checks - pushback variables
	logic is_wall_right_pushback, is_wall_left_pushback, is_wall_down_pushback, is_wall_up_pushback, is_wall_up_left_pushback, is_wall_up_right_pushback, is_wall_down_left_pushback, is_wall_down_right_pushback;

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
		if (Reset) // move goomba to storage place
      begin
			Mush_X_Pos <= 800;
         Mush_Y_Pos <= 10'd0;
			Mush_X_Vel <= 10'd0;
         Mush_Y_Vel <= 10'd0;
			Clk_counter <= 10'd0;
			collected <= 1'b0;
			normal_functionality <= 1'b0;
		end
		else if (roomNum == myRoomNum && qblock_empty && normal_functionality == 1'b1 && collected != 1'b1) // normal mushroom functionality now
		begin
			Mush_X_Pos <= Mush_X_Pos_in;
         Mush_Y_Pos <= Mush_Y_Pos_in;
			Mush_Y_Vel <= Mush_Y_Vel_in;
			Mush_X_Vel <= Mush_X_Vel_in;
			collected <= collected_in;
			normal_functionality <= 1'b1;
			if (Clk_counter > 1000)
				Clk_counter <= 0;
			else
			begin
				if (frame_clk_rising_edge)
					Clk_counter++;
			end
		end
		else if (roomNum == myRoomNum && qblock_empty && collected != 1'b1) // move mush to its start position cuz it's in the right room - setup
		begin
			Mush_X_Pos <= startX;
         Mush_Y_Pos <= startY;
			Mush_X_Vel <= -10'b1;
         Mush_Y_Vel <= 10'd0;
			Clk_counter <= 10'd0;
			collected <= 1'b0;
			normal_functionality <= 1'b1;
		end
      else									// move mush back to storage place
      begin
			Mush_X_Pos <= 800;
         Mush_Y_Pos <= 10'd0;
			Mush_X_Vel <= 10'd0;
			Mush_Y_Vel <= 10'd0;
			collected <= collected_in;
			normal_functionality <= 1'b0;
			if (Clk_counter > 1000)
				Clk_counter <= 0;
			else
			begin
				if (frame_clk_rising_edge)
					Clk_counter++;
			end
		end
	end
   //////// Do not modify the always_ff blocks. ////////
    
   // You need to modify always_comb block.
   always_comb
   begin
		// By default, position unchanged and velocity at 0
      Mush_X_Pos_in = Mush_X_Pos;
      Mush_Y_Pos_in = Mush_Y_Pos;
		Mush_X_Pos_in_temp = Mush_X_Pos;
		Mush_Y_Pos_in_temp = Mush_Y_Pos;
		Mush_Y_Vel_in = Mush_Y_Vel;
		Mush_X_Vel_in = Mush_X_Vel;
		collected_in = collected;
		
		// Update position and motion only at rising edge of frame clock
      if (frame_clk_rising_edge)
      begin
			Mush_X_Pos_in = Mush_X_Pos + Mush_X_Vel;
			Mush_Y_Pos_in = Mush_Y_Pos + Mush_Y_Vel;
			Mush_X_Pos_in_temp = Mush_X_Pos;
			Mush_Y_Pos_in_temp = Mush_Y_Pos;
			Mush_X_Vel_in = Mush_X_Vel;
			collected_in = collected;
			
			if (collected == 1'b0)
			begin
				
				if (Clk_counter % 10 == 0)
				begin
					if (Mush_Y_Vel < 10'd4)
					begin
						Mush_Y_Vel_in = Mush_Y_Vel + 10'd2; // we aren't touching the ground, let gravity run its course
					end
					else
						Mush_Y_Vel_in = Mush_Y_Vel;
				end
				else
				begin
					Mush_Y_Vel_in = Mush_Y_Vel;
				end
				
				// mushroom collection logic
				// collection - from mario
				if ( ( ((marioX + 10) > (Mush_X_Pos - Mush_Size_X) && (marioX + 10) < (Mush_X_Pos + Mush_Size_X)) || 
						 ((marioX - 10) > (Mush_X_Pos - Mush_Size_X) && (marioX - 10) < (Mush_X_Pos + Mush_Size_X))   ) 
						 &&
					  ( ((marioY + mario_size_y) >= (Mush_Y_Pos - Mush_Size_Y) && (marioY + mario_size_y) <= (Mush_Y_Pos + Mush_Size_Y)) || 
						 ((marioY - mario_size_y) >= (Mush_Y_Pos - Mush_Size_Y) && (marioY - mario_size_y) <= (Mush_Y_Pos + Mush_Size_Y))   ) 
						 && is_alive_mario != 2'd0 )
					begin
						Mush_X_Vel_in = 10'd0;
						collected_in = 1'b1;
					end
				
				// gravity logic here					
				// jumping
				if (is_wall_down == 1'b1 || is_wall_down_left == 1'b1 || is_wall_down_right == 1'b1) // this means goomba is touching ground
				begin
					Mush_Y_Vel_in = 10'd0; // velocity is 0
				end
									
				// pushback
				Mush_Y_Pos_in_temp = Mush_Y_Pos + Mush_Y_Vel;
				if (is_wall_up_pushback == 1'b1 || is_wall_up_left_pushback == 1'b1 || is_wall_up_right_pushback == 1'b1)
				begin
					Mush_Y_Pos_in = (Mush_Y_Pos_in_temp + (20 - (Mush_Y_Pos_in_temp % 20)) + Mush_Size_Y) - 20;
					Mush_Y_Vel_in = 10'd0;
				end
				else if (is_wall_down_pushback == 1'b1 || is_wall_down_left_pushback == 1'b1 || is_wall_down_right_pushback == 1'b1)
				begin
					Mush_Y_Pos_in = (Mush_Y_Pos_in_temp - (Mush_Y_Pos_in_temp % 20) - 1 - Mush_Size_Y) + 20;
				end
					
				// collection - from hell's grips
				if (Mush_Y_Pos > 479)
				begin
					collected_in = 1'b1;
				end
				
				// horizontal movement logic
				if (Mush_X_Vel == -10'd1);
				begin
					Mush_X_Pos_in_temp = Mush_X_Pos + Mush_X_Vel;
					if (is_wall_left_pushback == 1'b1 || is_wall_up_left_pushback == 1'b1 || is_wall_down_left_pushback == 1'b1)
					begin
						Mush_X_Pos_in = (Mush_X_Pos_in_temp + (20 - (Mush_X_Pos_in_temp % 20)) + Mush_Size_X) - 20;
						Mush_X_Vel_in = (~(Mush_X_Vel) + 1'b1);
					end
					else
					begin
						Mush_X_Pos_in = Mush_X_Pos + Mush_X_Vel;
					end
				end
				if (Mush_X_Vel == 10'd1)
				begin
					Mush_X_Pos_in_temp = Mush_X_Pos + Mush_X_Vel;
					if (is_wall_right_pushback == 1'b1 || is_wall_up_right_pushback == 1'b1 || is_wall_down_right_pushback == 1'b1)
					begin
						Mush_X_Pos_in = (Mush_X_Pos_in_temp - (Mush_X_Pos_in_temp % 20) - 1 - Mush_Size_X) + 20;
						Mush_X_Vel_in = (~(Mush_X_Vel) + 1'b1);
					end
					else
					begin
						Mush_X_Pos_in = Mush_X_Pos + Mush_X_Vel;
					end
				end
			end
		end
	end
    
   // Compute whether the pixel corresponds to Goomba or background
   /* Since the multiplicants are required to be signed, we have to first cast them
      from logic to int (signed by default) before they are multiplied. */
   int DistX, DistY;
   assign DistX = DrawX - Mush_X_Pos + Mush_Size_X;
   assign DistY = DrawY - Mush_Y_Pos + Mush_Size_Y;
	
   always_comb begin
		if (DistX <= (Mush_Size_X*2) && DistY <= (Mush_Size_Y*2) && DistX >= 10'd0 && DistY >= 10'd0)
			is_mush = 1'b1;
		else
			is_mush = 1'b0;
		if (is_mush == 1'b1)
		begin
			mush_address = DistX + DistY * 21;
		end
		else
			mush_address = 9'b0; // don't care
	end 
	
endmodule
