module fball ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
					input [1:0]   roomNum, myRoomNum, // game and fball's roomNum
					input [9:0]   startX, startY,	    // initial location
               output logic  is_fball,           // Whether current pixel belongs to fball or background
					output logic  up_num,				 // sprite number for fball, if 1 draw fball up, if 0 draw it downwards
					output logic  [8:0] fball_address,  // outputs fball's address for sprite drawing
					output logic  [9:0] Fball_X_Pos, Fball_Y_Pos // current position
              );
				  
	parameter [9:0] Fball_X_Min = 10'd0;       // Leftmost point on the X axis
   parameter [9:0] Fball_X_Max = 10'd639;     // Rightmost point on the X axis
   parameter [9:0] Fball_Y_Min = 10'd0;       // Topmost point on the Y axis
   parameter [9:0] Fball_Y_Max = 10'd479;     // Bottommost point on the Y axis
//   parameter [9:0] Goomba_Y_Step = 10'd2;      // Step size on the Y axis
   logic [9:0] Fball_Size_X;						  // Fball x size
	assign Fball_Size_X = 10'd10;
	logic [9:0] Fball_Size_Y;						  // Fball y size
	assign Fball_Size_Y = 10'd10;
    
	// States
	logic [9:0] Fball_Y_Vel;
	logic normal_functionality;
	
	// Next States
	logic [9:0] Fball_X_Pos_in, Fball_Y_Pos_in, Fball_Y_Vel_in;
	logic	up_num_in;
	
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
		if (Reset) // move fball to storage place
      begin
			Fball_X_Pos <= 800;
         Fball_Y_Pos <= 10'd0;
			Fball_Y_Vel <= 10'd0;
			up_num <= 1'b1;
			Clk_counter <= 10'd0;
			normal_functionality <= 1'b0;
		end
		else if (roomNum == myRoomNum && normal_functionality == 1'b1) // normal fball functionality now
		begin
			Fball_X_Pos <= Fball_X_Pos_in;
         Fball_Y_Pos <= Fball_Y_Pos_in;
			Fball_Y_Vel <= Fball_Y_Vel_in;
			up_num <= up_num_in;
			normal_functionality <= 1'b1;
			if (Clk_counter > 1000)
				Clk_counter <= 0;
			else
			begin
				if (frame_clk_rising_edge)
					Clk_counter++;
			end
		end
		else if (roomNum == myRoomNum) // move fball to its start position cuz it's in the right room - setup
		begin
			Fball_X_Pos <= startX;
         Fball_Y_Pos <= startY;
			Fball_Y_Vel <= 10'd0;
			up_num <= 1'b1;
			Clk_counter <= 10'd0;
			normal_functionality <= 1'b1;
		end
      else									// move fball back to storage place
      begin
			Fball_X_Pos <= 800;
         Fball_Y_Pos <= 10'd0;
			Fball_Y_Vel <= 10'd0;
			up_num <= up_num_in;
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
      Fball_X_Pos_in = Fball_X_Pos;
      Fball_Y_Pos_in = Fball_Y_Pos;
		Fball_Y_Vel_in = Fball_Y_Vel;
		up_num_in = up_num;
		
		// Update position and motion only at rising edge of frame clock
      if (frame_clk_rising_edge)
      begin
			Fball_X_Pos_in = Fball_X_Pos;
			Fball_Y_Pos_in = Fball_Y_Pos + Fball_Y_Vel;
			Fball_Y_Vel_in = Fball_Y_Vel;
			up_num_in = up_num;
			
			if (Clk_counter % 10 == 0)
			begin
				if (Fball_Y_Vel == -10'd10)
				begin
					up_num_in = 1'b1;
					Fball_Y_Vel_in = -10'd5;
				end
				else if (Fball_Y_Vel == -10'd5)
				begin
					up_num_in = 1'b1;
					Fball_Y_Vel_in = -10'd3;
				end
				else if (Fball_Y_Vel == -10'd3)
				begin
					up_num_in = 1'b1;
					Fball_Y_Vel_in = 10'd3;
				end
				else if (Fball_Y_Vel == 10'd3)
				begin
					up_num_in = 1'b0;
					Fball_Y_Vel_in = 10'd5;
				end
				else if (Fball_Y_Vel == 10'd5)
				begin	
					up_num_in = 1'b0;
					Fball_Y_Vel_in = 10'd10;
				end
				else if (Fball_Y_Vel == 10'd10)
				begin
					up_num_in = 1'b1;
					Fball_Y_Vel_in = 10'd0;
					Fball_Y_Pos_in = 490;
				end			
				else if (Fball_Y_Vel == 10'd0)
				begin
					up_num_in = 1'b1;
					Fball_Y_Vel_in = -10'd10;
				end
			end
		end
	end
    
   // Compute whether the pixel corresponds to Fball or background
   /* Since the multiplicants are required to be signed, we have to first cast them
      from logic to int (signed by default) before they are multiplied. */
   int DistX, DistY;
   assign DistX = DrawX - Fball_X_Pos + Fball_Size_X;
   assign DistY = DrawY - Fball_Y_Pos + Fball_Size_Y;
	
   always_comb begin
		if (DistX <= (Fball_Size_X*2) && DistY <= (Fball_Size_Y*2) && DistX >= 10'd0 && DistY >= 10'd0)
			is_fball = 1'b1;
		else
			is_fball = 1'b0;
		if (is_fball == 1'b1)
		begin
			fball_address = DistX + DistY * 21;
		end
		else
			fball_address = 9'b0; // don't care
	end 
	
endmodule
