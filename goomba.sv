module goomba ( input        Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
					input [1:0]   roomNum, myRoomNum, // game and goomba's roomNum
					input [9:0]   startX, startY,	    // initial location
					input [9:0]	  marioX, marioY,		 // mario's coordinates
					input [9:0]	  mario_size_y,		 // mario's y size for collisions
					input [1:0]	  is_alive_mario,		 // is mario alive?
               output logic  is_goomba,            // Whether current pixel belongs to Goomba or background
					output logic  walk_num_goomba,			// walk number for goomba
					output logic  [8:0] goomba_address,  // outputs goomba's address for sprite drawing
					output logic  [9:0] Goomba_X_Pos, Goomba_Y_Pos, // current position
					output logic  is_alive_goomba
              );

	parameter [9:0] Goomba_X_Min = 10'd0;       // Leftmost point on the X axis
   parameter [9:0] Goomba_X_Max = 10'd639;     // Rightmost point on the X axis
   parameter [9:0] Goomba_Y_Min = 10'd0;       // Topmost point on the Y axis
   parameter [9:0] Goomba_Y_Max = 10'd479;     // Bottommost point on the Y axis
//   parameter [9:0] Goomba_Y_Step = 10'd2;      // Step size on the Y axis
   logic [9:0] Goomba_Size_X;						  // Goomba x size
	assign Goomba_Size_X = 10'd10;
	logic [9:0] Goomba_Size_Y;						  // Goomba y size
	assign Goomba_Size_Y = 10'd10;
    
   
	// States
	logic [9:0] Goomba_X_Vel, Goomba_Y_Vel;
   logic [1:0] death_anim_count;
	logic normal_functionality;
	
	// Next States
	logic [9:0] Goomba_X_Pos_in, Goomba_Y_Pos_in, Goomba_X_Vel_in, Goomba_Y_Vel_in;
	logic	walk_num_goomba_in;
	logic is_alive_goomba_in;
	logic [1:0] death_anim_count_in;
	
	// Misc.
	logic [9:0] Goomba_X_Pos_in_temp, Goomba_Y_Pos_in_temp;
	logic [9:0] Clk_counter;
	

		
	// collision - gravity
	wall down_collision(.DrawX(Goomba_X_Pos_in), .DrawY(Goomba_Y_Pos_in + Goomba_Size_Y + 1), .RoomNum(myRoomNum), .is_wall(is_wall_down));
	wall down_right_collision(.DrawX(Goomba_X_Pos_in + 7*Goomba_Size_X/10 + 1), .DrawY(Goomba_Y_Pos_in + Goomba_Size_Y + 1), .RoomNum(myRoomNum), .is_wall(is_wall_down_right));
	wall down_left_collision(.DrawX(Goomba_X_Pos_in - 7*Goomba_Size_X/10 - 1), .DrawY(Goomba_Y_Pos_in + Goomba_Size_Y + 1), .RoomNum(myRoomNum), .is_wall(is_wall_down_left));
	
	// collision checks - gravity 
	logic is_wall_down, is_wall_down_left, is_wall_down_right;
	
	// collision checks - pushing back out
	wall right_collision_pushback(.DrawX(Goomba_X_Pos_in_temp + Goomba_Size_X), .DrawY(Goomba_Y_Pos), .RoomNum(myRoomNum), .is_wall(is_wall_right_pushback));
	wall left_collision_pushback(.DrawX(Goomba_X_Pos_in_temp - Goomba_Size_X), .DrawY(Goomba_Y_Pos), .RoomNum(myRoomNum), .is_wall(is_wall_left_pushback));
	wall up_collision_pushback(.DrawX(Goomba_X_Pos), .DrawY(Goomba_Y_Pos_in_temp - Goomba_Size_Y), .RoomNum(myRoomNum), .is_wall(is_wall_up_pushback));
	wall down_collision_pushback(.DrawX(Goomba_X_Pos), .DrawY(Goomba_Y_Pos_in_temp + Goomba_Size_Y), .RoomNum(myRoomNum), .is_wall(is_wall_down_pushback));
	wall up_left_collision_pushback(.DrawX(Goomba_X_Pos_in_temp - Goomba_Size_X), .DrawY(Goomba_Y_Pos_in_temp - Goomba_Size_Y), .RoomNum(myRoomNum), .is_wall(is_wall_up_left_pushback));
	wall down_left_collision_pushback(.DrawX(Goomba_X_Pos_in_temp - Goomba_Size_X), .DrawY(Goomba_Y_Pos_in_temp + Goomba_Size_Y), .RoomNum(myRoomNum), .is_wall(is_wall_down_left_pushback));
	wall up_right_collision_pushback(.DrawX(Goomba_X_Pos_in_temp + Goomba_Size_X), .DrawY(Goomba_Y_Pos_in_temp - Goomba_Size_Y), .RoomNum(myRoomNum), .is_wall(is_wall_up_right_pushback));
	wall down_right_collision_pushback(.DrawX(Goomba_X_Pos_in_temp + Goomba_Size_X), .DrawY(Goomba_Y_Pos_in_temp + Goomba_Size_Y), .RoomNum(myRoomNum), .is_wall(is_wall_down_right_pushback));
	
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
			Goomba_X_Pos <= 800;
         Goomba_Y_Pos <= 10'd0;
			Goomba_X_Vel <= 10'd0;
         Goomba_Y_Vel <= 10'd0;
			walk_num_goomba <= 1'b0;
			Clk_counter <= 10'd0;
			is_alive_goomba <= 1'b1;
			death_anim_count <= 2'b00;
			normal_functionality <= 1'b0;
		end
		else if (roomNum == myRoomNum && normal_functionality == 1'b1) // normal goomba functionality now
		begin
			Goomba_X_Pos <= Goomba_X_Pos_in;
         Goomba_Y_Pos <= Goomba_Y_Pos_in;
			Goomba_Y_Vel <= Goomba_Y_Vel_in;
			Goomba_X_Vel <= Goomba_X_Vel_in;
			walk_num_goomba <= walk_num_goomba_in;
			is_alive_goomba <= is_alive_goomba_in;
			death_anim_count <= death_anim_count_in;
			normal_functionality <= 1'b1;
			if (Clk_counter > 1000)
				Clk_counter <= 0;
			else
			begin
				if (frame_clk_rising_edge)
					Clk_counter++;
			end
		end
		else if (roomNum == myRoomNum) // move goomba to its start position cuz it's in the right room - setup
		begin
			Goomba_X_Pos <= startX;
         Goomba_Y_Pos <= startY;
			Goomba_X_Vel <= -10'b1;
         Goomba_Y_Vel <= 10'd0;
			walk_num_goomba <= 1'b0;
			Clk_counter <= 10'd0;
			is_alive_goomba <= 1'b1;
			death_anim_count <= 2'b00;
			normal_functionality <= 1'b1;
		end
      else									// move goomba back to storage place
      begin
			Goomba_X_Pos <= 800;
         Goomba_Y_Pos <= 10'd0;
			Goomba_X_Vel <= 10'd0;
			Goomba_Y_Vel <= 10'd0;
			walk_num_goomba <= walk_num_goomba_in;
			is_alive_goomba <= is_alive_goomba_in;
			death_anim_count <= death_anim_count_in;
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
      Goomba_X_Pos_in = Goomba_X_Pos;
      Goomba_Y_Pos_in = Goomba_Y_Pos;
		Goomba_X_Pos_in_temp = Goomba_X_Pos;
		Goomba_Y_Pos_in_temp = Goomba_Y_Pos;
		Goomba_Y_Vel_in = Goomba_Y_Vel;
		Goomba_X_Vel_in = Goomba_X_Vel;
		walk_num_goomba_in = walk_num_goomba;
		is_alive_goomba_in = is_alive_goomba;
		death_anim_count_in = death_anim_count;
		
		// Update position and motion only at rising edge of frame clock
      if (frame_clk_rising_edge)
      begin
			Goomba_X_Pos_in = Goomba_X_Pos + Goomba_X_Vel;
			Goomba_Y_Pos_in = Goomba_Y_Pos + Goomba_Y_Vel;
			Goomba_X_Pos_in_temp = Goomba_X_Pos;
			Goomba_Y_Pos_in_temp = Goomba_Y_Pos;
			Goomba_X_Vel_in = Goomba_X_Vel;
			walk_num_goomba_in = walk_num_goomba;
			is_alive_goomba_in = is_alive_goomba;
			death_anim_count_in = death_anim_count;
			
			if (is_alive_goomba == 1'b0)
			begin
				if (Clk_counter % 3 == 0)
				begin
					if (death_anim_count < 2'd2)
						death_anim_count_in = death_anim_count + 1'b1;
					else
					begin
						Goomba_X_Pos_in = 10'd1023;
						Goomba_Y_Pos_in = 10'd1023;
						Goomba_X_Vel_in = 10'd0;
						Goomba_Y_Vel_in = 10'd0;
					end
				end
			end
			
			else if (is_alive_goomba == 1'b1)
			begin
				if (Clk_counter % 10 == 0)
				begin
					if (walk_num_goomba == 3'd0)
						walk_num_goomba_in = 3'd1;
					else
						walk_num_goomba_in = 3'd0;
				end
				
				if (Clk_counter % 10 == 0)
				begin
					if (Goomba_Y_Vel < 10'd4)
					begin
						Goomba_Y_Vel_in = Goomba_Y_Vel + 10'd2; // we aren't touching the ground, let gravity run its course
					end
					else
						Goomba_Y_Vel_in = Goomba_Y_Vel;
				end
				else
				begin
					Goomba_Y_Vel_in = Goomba_Y_Vel;
				end
				
				// gravity logic here					
				// jumping
				if (is_wall_down == 1'b1 || is_wall_down_left == 1'b1 || is_wall_down_right == 1'b1) // this means goomba is touching ground
				begin
					Goomba_Y_Vel_in = 10'd0; // velocity is 0
				end
									
				// pushback
				Goomba_Y_Pos_in_temp = Goomba_Y_Pos + Goomba_Y_Vel;
				if (is_wall_up_pushback == 1'b1 || is_wall_up_left_pushback == 1'b1 || is_wall_up_right_pushback == 1'b1)
				begin
					Goomba_Y_Pos_in = (Goomba_Y_Pos_in_temp + (20 - (Goomba_Y_Pos_in_temp % 20)) + Goomba_Size_Y) - 20;
					Goomba_Y_Vel_in = 10'd0;
				end
				else if (is_wall_down_pushback == 1'b1 || is_wall_down_left_pushback == 1'b1 || is_wall_down_right_pushback == 1'b1)
				begin
					Goomba_Y_Pos_in = (Goomba_Y_Pos_in_temp - (Goomba_Y_Pos_in_temp % 20) - 1 - Goomba_Size_Y) + 20;
				end
				
				// goomba death logic
				// death - from mario
				if ( ( ((marioX + 10) > (Goomba_X_Pos_in - Goomba_Size_X) && (marioX + 10) < (Goomba_X_Pos_in + Goomba_Size_X)) || 
						 ((marioX - 10) > (Goomba_X_Pos_in - Goomba_Size_X) && (marioX - 10) < (Goomba_X_Pos_in + Goomba_Size_X))   ) 
						 &&  (marioY + mario_size_y) > (Goomba_Y_Pos_in - 11) && (marioY + mario_size_y) < Goomba_Y_Pos_in 
						 && is_alive_mario != 2'd0)
					begin
						Goomba_X_Vel_in = 10'd0;
						is_alive_goomba_in = 1'b0;
					end
					
				// death - from a hole
				if (Goomba_Y_Pos > 479)
				begin
					is_alive_goomba_in = 1'b0;
				end
				
				// horizontal movement logic
				if (Goomba_X_Vel == -10'd1);
				begin
					Goomba_X_Pos_in_temp = Goomba_X_Pos + Goomba_X_Vel;
					if (is_wall_left_pushback == 1'b1 || is_wall_up_left_pushback == 1'b1 || is_wall_down_left_pushback == 1'b1)
					begin
						Goomba_X_Pos_in = (Goomba_X_Pos_in_temp + (20 - (Goomba_X_Pos_in_temp % 20)) + Goomba_Size_X) - 20;
						Goomba_X_Vel_in = (~(Goomba_X_Vel) + 1'b1);
					end
					else
					begin
						Goomba_X_Pos_in = Goomba_X_Pos + Goomba_X_Vel;
					end
				end
				if (Goomba_X_Vel == 10'd1)
				begin
					Goomba_X_Pos_in_temp = Goomba_X_Pos + Goomba_X_Vel;
					if (is_wall_right_pushback == 1'b1 || is_wall_up_right_pushback == 1'b1 || is_wall_down_right_pushback == 1'b1)
					begin
						Goomba_X_Pos_in = (Goomba_X_Pos_in_temp - (Goomba_X_Pos_in_temp % 20) - 1 - Goomba_Size_X) + 20;
						Goomba_X_Vel_in = (~(Goomba_X_Vel) + 1'b1);
					end
					else
					begin
						Goomba_X_Pos_in = Goomba_X_Pos + Goomba_X_Vel;
					end
				end
			end
		end
	end
    
   // Compute whether the pixel corresponds to Goomba or background
   /* Since the multiplicants are required to be signed, we have to first cast them
      from logic to int (signed by default) before they are multiplied. */
   int DistX, DistY;
   assign DistX = DrawX - Goomba_X_Pos + Goomba_Size_X;
   assign DistY = DrawY - Goomba_Y_Pos + Goomba_Size_Y;
	
   always_comb begin
		if (DistX <= (Goomba_Size_X*2) && DistY <= (Goomba_Size_Y*2) && DistX >= 10'd0 && DistY >= 10'd0)
			is_goomba = 1'b1;
		else
			is_goomba = 1'b0;
		if (is_goomba == 1'b1)
		begin
			goomba_address = DistX + DistY * 21;
		end
		else
			goomba_address = 9'b0; // don't care
	end 
	
endmodule
