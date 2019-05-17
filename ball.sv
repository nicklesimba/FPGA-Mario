// will be transformed into player logic

// final project version

//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  12-08-2017                               --
//    Spring 2018 Distribution                                           --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  ball ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
					input 		  w_on, a_on, d_on,	 // Keyboard inputs
					input	[9:0]   goomba_r1_1_x,		 // Goomba r1_1 coordinates
									  goomba_r1_1_y,
					input	[9:0]   goomba_r1_2_x,		 // Goomba r1_2 coordinates
									  goomba_r1_2_y,
					input	[9:0]   goomba_r2_1_x,		 // Goomba r2_1 coordinates
									  goomba_r2_1_y,
					input [9:0]   goomba_r3_1_x,		 // Goomba r3_1 coordinates
									  goomba_r3_1_y,
					input [9:0]	  fball_r3_1_x,		 // Fball r3_1 coordinates
									  fball_r3_1_y,
					input [9:0]   coin_r1_1_x,			 // Coin r1_1 coordinates
									  coin_r1_1_y,
					input [9:0]   coin_r2_1_x,			 // Coin r2_1 coordinates
									  coin_r2_1_y,
					input [9:0]   mush_r1_1_x,        // Mush r1_1 coordinates
									  mush_r1_1_y,
					output logic  [9:0] Ball_X_Pos,	 // Mario's coordinates
											  Ball_Y_Pos,
					output logic  [9:0] Ball_Size_Y,	 // Mario's Y size for collisions
               output logic  is_ball,            // Whether current pixel belongs to ball or background
					output logic  on_ground_hex,      // for hex display (debugging)
					output logic  [9:0] mario_address,// outputs mario's address for sprite drawing
					output logic  on_ground,
					output logic  is_walking,
					output logic  [1:0]  walk_num,
					output logic  [1:0]  is_alive,    // mario's health
					output logic  [9:0] scoreCnt,
					output logic  [1:0] roomNum
              );

	// start pos coordinates
	parameter [9:0] Ball_X_Center = 10'd40;  // Center position on the X axis
   parameter [9:0] Ball_Y_Center = 10'd400;  // Center position on the Y axis

	parameter [9:0] Ball_X_Min = 10'd0;       // Leftmost point on the X axis
   parameter [9:0] Ball_X_Max = 10'd639;     // Rightmost point on the X axis
   parameter [9:0] Ball_Y_Min = 10'd0;       // Topmost point on the Y axis
   parameter [9:0] Ball_Y_Max = 10'd479;     // Bottommost point on the Y axis
   parameter [9:0] Ball_X_Step = 10'd2;      // Step size on the X axis
//   parameter [9:0] Ball_Y_Step = 10'd2;      // Step size on the Y axis
   logic [9:0] Ball_Size_X;						// Ball x size
	assign Ball_Size_X = 10'd10;    
   
	// States
	logic [9:0] Ball_X_Vel, Ball_Y_Vel;
	logic is_right; // 1 if facing right, 0 if facing left.
	logic normal_functionality;
	logic [1:0] DamageCount;
   
	// Next States
	logic [9:0] Ball_X_Pos_in, Ball_X_Vel_in, Ball_Y_Pos_in, Ball_Y_Vel_in;
	logic is_right_in;
	logic on_ground_in;
	logic is_walking_in;
	logic [2:0] walk_num_in;
	logic [1:0] is_alive_in;
	logic [9:0] scoreCnt_in;
	logic [1:0] roomNum_in;
	logic normal_functionality_in;
	logic [9:0] Ball_Size_Y_in;
	logic [1:0] DamageCount_in;
	
	// Misc.
	logic [9:0] Ball_X_Pos_in_temp, Ball_Y_Pos_in_temp;
	logic [9:0] Clk_counter;
	
	// hex display
	assign on_ground_hex = on_ground;
	
	// Collisions
		// collision - gravity
		wall down_collision(.DrawX(Ball_X_Pos_in), .DrawY(Ball_Y_Pos_in + Ball_Size_Y + 1), .RoomNum(roomNum), .is_wall(is_wall_down));
		wall down_right_collision(.DrawX(Ball_X_Pos_in + 7*Ball_Size_X/10 + 1), .DrawY(Ball_Y_Pos_in + Ball_Size_Y + 1), .RoomNum(roomNum), .is_wall(is_wall_down_right));
		wall down_left_collision(.DrawX(Ball_X_Pos_in - 7*Ball_Size_X/10 - 1), .DrawY(Ball_Y_Pos_in + Ball_Size_Y + 1), .RoomNum(roomNum), .is_wall(is_wall_down_left));
		
		// collision checks - gravity 
		logic is_wall_down, is_wall_down_left, is_wall_down_right;
		
		// collision checks - pushing back out
		wall right_collision_pushback(.DrawX(Ball_X_Pos_in_temp + Ball_Size_X), .DrawY(Ball_Y_Pos), .RoomNum(roomNum), .is_wall(is_wall_right_pushback));
		wall left_collision_pushback(.DrawX(Ball_X_Pos_in_temp - Ball_Size_X), .DrawY(Ball_Y_Pos), .RoomNum(roomNum), .is_wall(is_wall_left_pushback));
		wall up_collision_pushback(.DrawX(Ball_X_Pos), .DrawY(Ball_Y_Pos_in_temp - Ball_Size_Y), .RoomNum(roomNum), .is_wall(is_wall_up_pushback));
		wall down_collision_pushback(.DrawX(Ball_X_Pos), .DrawY(Ball_Y_Pos_in_temp + Ball_Size_Y), .RoomNum(roomNum), .is_wall(is_wall_down_pushback));
		wall up_left_collision_pushback(.DrawX(Ball_X_Pos_in_temp - Ball_Size_X), .DrawY(Ball_Y_Pos_in_temp - Ball_Size_Y), .RoomNum(roomNum), .is_wall(is_wall_up_left_pushback));
		wall down_left_collision_pushback(.DrawX(Ball_X_Pos_in_temp - Ball_Size_X), .DrawY(Ball_Y_Pos_in_temp + Ball_Size_Y), .RoomNum(roomNum), .is_wall(is_wall_down_left_pushback));
		wall up_right_collision_pushback(.DrawX(Ball_X_Pos_in_temp + Ball_Size_X), .DrawY(Ball_Y_Pos_in_temp - Ball_Size_Y), .RoomNum(roomNum), .is_wall(is_wall_up_right_pushback));
		wall down_right_collision_pushback(.DrawX(Ball_X_Pos_in_temp + Ball_Size_X), .DrawY(Ball_Y_Pos_in_temp + Ball_Size_Y), .RoomNum(roomNum), .is_wall(is_wall_down_right_pushback));
		
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
		if (Reset)
      begin
			Ball_Size_Y <= 10'd10;
			Ball_X_Pos <= Ball_X_Center;
         Ball_Y_Pos <= Ball_Y_Center;
         Ball_Y_Vel <= 10'd0;
			Clk_counter <= 10'd0;
			is_right <= 1'b1;
			on_ground <= on_ground_in;
			is_alive <= 2'd1;
			DamageCount <= 2'd0;
			is_walking <= 1'b0;
			walk_num <= 3'b0;
			scoreCnt <= 10'd0;
			roomNum <= 2'd0;
			normal_functionality <= 1'b1;
		end
		else if (normal_functionality == 1'b0) // level transition
		begin
			Ball_Size_Y <= Ball_Size_Y_in;
			Ball_X_Pos <= Ball_X_Center;
         Ball_Y_Pos <= Ball_Y_Center;
         Ball_Y_Vel <= 10'd0;
			Clk_counter <= 10'd0;
			is_right <= 1'b1;
			on_ground <= on_ground_in;
			is_alive <= is_alive_in;
			DamageCount <= DamageCount_in;
			is_walking <= 1'b0;
			walk_num <= 3'b0;
			scoreCnt <= scoreCnt_in;
			roomNum <= roomNum_in;
			normal_functionality <= 1'b1;
		end
      else // normal functionality!
      begin
			Ball_Size_Y <= Ball_Size_Y_in;
			Ball_X_Pos <= Ball_X_Pos_in;
         Ball_Y_Pos <= Ball_Y_Pos_in;
			Ball_Y_Vel <= Ball_Y_Vel_in;
			is_right <= is_right_in;
			on_ground <= on_ground_in;
			is_alive <= is_alive_in;
			DamageCount <= DamageCount_in;
			is_walking <= is_walking_in;
			walk_num <= walk_num_in;
			scoreCnt <= scoreCnt_in;
			roomNum <= roomNum_in;
			normal_functionality <= normal_functionality_in;
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
      Ball_Size_Y_in = Ball_Size_Y;
		Ball_X_Pos_in = Ball_X_Pos;
      Ball_Y_Pos_in = Ball_Y_Pos;
		Ball_X_Pos_in_temp = Ball_X_Pos;
		Ball_Y_Pos_in_temp = Ball_Y_Pos;
//      Ball_X_Vel_in = 10'd0;
		Ball_Y_Vel_in = Ball_Y_Vel;
		is_right_in = is_right;
		on_ground_in = on_ground;
		is_walking_in = is_walking;
		walk_num_in = walk_num;
		is_alive_in = is_alive;
		DamageCount_in = DamageCount;
		scoreCnt_in = scoreCnt;
		roomNum_in = roomNum;
		normal_functionality_in = normal_functionality;
		
		// Update position and motion only at rising edge of frame clock
      if (frame_clk_rising_edge)
      begin
			Ball_Size_Y_in = Ball_Size_Y;
			Ball_X_Pos_in = Ball_X_Pos;
			Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Vel;
			Ball_X_Pos_in_temp = Ball_X_Pos;
			Ball_Y_Pos_in_temp = Ball_Y_Pos;
			is_right_in = is_right;
			on_ground_in = on_ground;
			is_walking_in = 1'b0;
			walk_num_in = walk_num;
			is_alive_in = is_alive;
			DamageCount_in = DamageCount;
			scoreCnt_in = scoreCnt;
			roomNum_in = roomNum;
			normal_functionality_in = 1'b1;

			if (is_alive == 2'd0)
			begin
				if (Clk_counter % 5 == 0)
				begin
					if (Ball_Y_Vel == 10'd0)
						Ball_Y_Vel_in = -10'd5;
					else if (Ball_Y_Vel == -10'd5) // the reason gravity here is so jank is probably because of some 2's complement shenanigans
						Ball_Y_Vel_in = -10'd3; // where adding 1 alone won't fix it so i need these shits (probably bc 
					else if (Ball_Y_Vel == -10'd3)
						Ball_Y_Vel_in = -10'd1;
					else if (Ball_Y_Vel == -10'd1)
						Ball_Y_Vel_in = 10'd1;
					else if (Ball_Y_Vel < 10'd4 && Ball_Y_Vel != 10'd0)
					begin
						Ball_Y_Vel_in = Ball_Y_Vel + 10'd2; // we aren't touching the ground, let gravity run its course
					end
					else
						Ball_Y_Vel_in = Ball_Y_Vel;
				end
				else
				begin
					Ball_Y_Vel_in = Ball_Y_Vel;
				end
				
				if (Ball_Y_Pos - Ball_Size_Y - 1 > 479)
				begin
					Ball_X_Pos_in = 10'd1023;
					Ball_Y_Pos_in = 10'd1023;
					Ball_X_Vel_in = 10'd0;
					Ball_Y_Vel_in = 10'd0;
				end
			end
			
			else if (is_alive != 2'd0) // mario's health is above 0
			begin
				// counter for invinciblity
				if (Clk_counter % 50 == 0)
				begin
					if (DamageCount < 2'd3 && DamageCount != 2'd0)
						DamageCount_in = DamageCount + 1'b1;
					else
						DamageCount_in = 2'd0;
				end
				
				// walking animation counter
				if (Clk_counter % 4 == 0)
				begin
					if (is_walking == 1'b1)
					begin
						if (walk_num < 3'd2)
							walk_num_in = walk_num + 3'd1;
						else if (walk_num == 3'd2)
							walk_num_in = 3'd0;
					end
					else
						walk_num_in = 3'd0;
				end
				
				// jump/fall velocity
				if (Clk_counter % 10 == 0)
				begin
					if (Ball_Y_Vel == -10'd5) // the reason gravity here is so jank is probably because of some 2's complement shenanigans
						Ball_Y_Vel_in = -10'd3; // where adding 1 alone won't fix it so i need these shits (probably bc of negative nums)
					else if (Ball_Y_Vel == -10'd3)
						Ball_Y_Vel_in = -10'd1;
					else if (Ball_Y_Vel == -10'd1)
						Ball_Y_Vel_in = 10'd0;
					else if (Ball_Y_Vel < 10'd4)
					begin
						Ball_Y_Vel_in = Ball_Y_Vel + 10'd2; // we aren't touching the ground, let gravity run its course
						on_ground_in = 1'b0;
					end
					else
						Ball_Y_Vel_in = Ball_Y_Vel;
				end
				else
				begin
					Ball_Y_Vel_in = Ball_Y_Vel;
				end
				
				// gravity logic here					
				// jumping
				if (is_wall_down == 1'b1 || is_wall_down_left == 1'b1 || is_wall_down_right == 1'b1) // this means we are touching the ground and we're allowed to jump
				begin
					Ball_Y_Vel_in = 10'd0; // we are allowed to jump but W hasn't been pressed, velocity is 0
					on_ground_in = 1'b1;
					if (a_on == 1'b1 || d_on == 1'b1)
						is_walking_in = 1'b1;
				end
									
				// pushback
				Ball_Y_Pos_in_temp = Ball_Y_Pos + Ball_Y_Vel;
				if (is_wall_up_pushback == 1'b1 || is_wall_up_left_pushback == 1'b1 || is_wall_up_right_pushback == 1'b1)
				begin
					Ball_Y_Pos_in = (Ball_Y_Pos_in_temp + (20 - (Ball_Y_Pos_in_temp % 20)) + Ball_Size_Y) - 20;
					Ball_Y_Vel_in = 10'd0;
				end
				else if (is_wall_down_pushback == 1'b1 || is_wall_down_left_pushback == 1'b1 || is_wall_down_right_pushback == 1'b1)
				begin
					Ball_Y_Pos_in = (Ball_Y_Pos_in_temp - (Ball_Y_Pos_in_temp % 20) - 1 - Ball_Size_Y) + 20;
				end
				
				// hole death logic
				if (Ball_Y_Pos > 479)
				begin
					Ball_Y_Vel_in = -10'd5;
					is_alive_in = 2'd0; // instantly lower health to 0
					Ball_Size_Y_in = 10'd10;
				end
				
				
				// BEGINNING OF SECTION FOR COLLISIONS WITH GOOMBAS, COINS, MUSHROOMS, FIREBALLS --------------------------------
				
				// I'm legit gonna do collision logic for each individual goomba cuz fk this -- goomba logic here
				// goomba bounce logic for all goombas
				if (on_ground == 1'b0)
				begin
					if ( ( ((Ball_X_Pos_in + Ball_Size_X) > (goomba_r1_1_x - 10) && (Ball_X_Pos_in + Ball_Size_X) < (goomba_r1_1_x + 10)) || 
							 ((Ball_X_Pos_in - Ball_Size_X) > (goomba_r1_1_x - 10) && (Ball_X_Pos_in - Ball_Size_X) < (goomba_r1_1_x + 10))   ) 
							 &&  (Ball_Y_Pos_in + Ball_Size_Y) > (goomba_r1_1_y - 11) && (Ball_Y_Pos_in + Ball_Size_Y) < goomba_r1_1_y )
						begin
							Ball_Y_Vel_in = -10'd3;
							scoreCnt_in = scoreCnt + 1'd1;
						end
					if ( ( ((Ball_X_Pos_in + Ball_Size_X) > (goomba_r1_2_x - 10) && (Ball_X_Pos_in + Ball_Size_X) < (goomba_r1_2_x + 10)) || 
							 ((Ball_X_Pos_in - Ball_Size_X) > (goomba_r1_2_x - 10) && (Ball_X_Pos_in - Ball_Size_X) < (goomba_r1_2_x + 10))   ) 
							 &&  (Ball_Y_Pos_in + Ball_Size_Y) > (goomba_r1_2_y - 11) && (Ball_Y_Pos_in + Ball_Size_Y) < goomba_r1_2_y )
						begin
							Ball_Y_Vel_in = -10'd3;
							scoreCnt_in = scoreCnt + 1'd1;
						end
					if ( ( ((Ball_X_Pos_in + Ball_Size_X) > (goomba_r2_1_x - 10) && (Ball_X_Pos_in + Ball_Size_X) < (goomba_r2_1_x + 10)) || 
							 ((Ball_X_Pos_in - Ball_Size_X) > (goomba_r2_1_x - 10) && (Ball_X_Pos_in - Ball_Size_X) < (goomba_r2_1_x + 10))   ) 
							 &&  (Ball_Y_Pos_in + Ball_Size_Y) > (goomba_r2_1_y - 11) && (Ball_Y_Pos_in + Ball_Size_Y) < goomba_r2_1_y )
						begin
							Ball_Y_Vel_in = -10'd3;
							scoreCnt_in = scoreCnt + 1'd1;
						end
					if ( ( ((Ball_X_Pos_in + Ball_Size_X) > (goomba_r3_1_x - 10) && (Ball_X_Pos_in + Ball_Size_X) < (goomba_r3_1_x + 10)) || 
							 ((Ball_X_Pos_in - Ball_Size_X) > (goomba_r3_1_x - 10) && (Ball_X_Pos_in - Ball_Size_X) < (goomba_r3_1_x + 10))   ) 
							 &&  (Ball_Y_Pos_in + Ball_Size_Y) > (goomba_r3_1_y - 11) && (Ball_Y_Pos_in + Ball_Size_Y) < goomba_r3_1_y )
						begin
							Ball_Y_Vel_in = -10'd3;
							scoreCnt_in = scoreCnt + 1'd1;
						end
				end
				// goomba death logic for all goombas
				if (on_ground == 1'b1)
				begin
					if (  ( ((Ball_X_Pos_in + Ball_Size_X) > (goomba_r1_1_x - 10) && (Ball_X_Pos_in + Ball_Size_X) < (goomba_r1_1_x + 10)) || 
							 ((Ball_X_Pos_in - Ball_Size_X) > (goomba_r1_1_x - 10) && (Ball_X_Pos_in - Ball_Size_X) < (goomba_r1_1_x + 10)) )
							 &&
							( ((Ball_Y_Pos_in + Ball_Size_Y) >= (goomba_r1_1_y) && (Ball_Y_Pos_in + Ball_Size_Y) <= (goomba_r1_1_y + 10)) || 
							 ((Ball_Y_Pos_in - Ball_Size_Y) >= (goomba_r1_1_y) && (Ball_Y_Pos_in - Ball_Size_Y) <= (goomba_r1_1_y + 10)) )
						)
						begin
							if (DamageCount == 2'd0)
							begin
								DamageCount_in = 2'd1;
								is_alive_in = is_alive - 1'b1;
								Ball_Size_Y_in = 10'd10;
							end
						end
					if (  ( ((Ball_X_Pos_in + Ball_Size_X) > (goomba_r1_2_x - 10) && (Ball_X_Pos_in + Ball_Size_X) < (goomba_r1_2_x + 10)) || 
							 ((Ball_X_Pos_in - Ball_Size_X) > (goomba_r1_2_x - 10) && (Ball_X_Pos_in - Ball_Size_X) < (goomba_r1_2_x + 10)) )
							 &&
							( ((Ball_Y_Pos_in + Ball_Size_Y) >= (goomba_r1_2_y) && (Ball_Y_Pos_in + Ball_Size_Y) <= (goomba_r1_2_y + 10)) || 
							 ((Ball_Y_Pos_in - Ball_Size_Y) >= (goomba_r1_2_y) && (Ball_Y_Pos_in - Ball_Size_Y) <= (goomba_r1_2_y + 10)) )
						)
						begin
							if (DamageCount == 2'd0)
							begin
								DamageCount_in = 2'd1;
								is_alive_in = is_alive - 1'b1;
								Ball_Size_Y_in = 10'd10;
							end
						end
					if (  ( ((Ball_X_Pos_in + Ball_Size_X) > (goomba_r2_1_x - 10) && (Ball_X_Pos_in + Ball_Size_X) < (goomba_r2_1_x + 10)) || 
							 ((Ball_X_Pos_in - Ball_Size_X) > (goomba_r2_1_x - 10) && (Ball_X_Pos_in - Ball_Size_X) < (goomba_r2_1_x + 10)) )
							 &&
							( ((Ball_Y_Pos_in + Ball_Size_Y) >= (goomba_r2_1_y) && (Ball_Y_Pos_in + Ball_Size_Y) <= (goomba_r2_1_y + 10)) || 
							 ((Ball_Y_Pos_in - Ball_Size_Y) >= (goomba_r2_1_y) && (Ball_Y_Pos_in - Ball_Size_Y) <= (goomba_r2_1_y + 10)) )
						)
						begin
							if (DamageCount == 2'd0)
							begin
								DamageCount_in = 2'd1;
								is_alive_in = is_alive - 1'b1;
								Ball_Size_Y_in = 10'd10;
							end
						end
					if (  ( ((Ball_X_Pos_in + Ball_Size_X) > (goomba_r3_1_x - 10) && (Ball_X_Pos_in + Ball_Size_X) < (goomba_r3_1_x + 10)) || 
							 ((Ball_X_Pos_in - Ball_Size_X) > (goomba_r3_1_x - 10) && (Ball_X_Pos_in - Ball_Size_X) < (goomba_r3_1_x + 10)) )
							 &&
							( ((Ball_Y_Pos_in + Ball_Size_Y) >= (goomba_r3_1_y) && (Ball_Y_Pos_in + Ball_Size_Y) <= (goomba_r3_1_y + 10)) || 
							 ((Ball_Y_Pos_in - Ball_Size_Y) >= (goomba_r3_1_y) && (Ball_Y_Pos_in - Ball_Size_Y) <= (goomba_r3_1_y + 10)) )
						)
						begin
							if (DamageCount == 2'd0)
							begin
								DamageCount_in = 2'd1;
								is_alive_in = is_alive - 1'b1;
								Ball_Size_Y_in = 10'd10;
							end
						end
				end
				
				// coin collection logic for all coins
				if ( ((Ball_X_Pos_in + 10 >= coin_r1_1_x && Ball_X_Pos_in + 10 <= coin_r1_1_x + 19) || (Ball_X_Pos_in - 10 >= coin_r1_1_x && Ball_X_Pos_in - 10 <= coin_r1_1_x + 19)) 
						&&
					  ((Ball_Y_Pos_in + Ball_Size_Y <= coin_r1_1_y + 19 + 1) && (Ball_Y_Pos_in + Ball_Size_Y >= coin_r1_1_y))
					   &&
						is_alive != 2'd0
					)
					begin
						scoreCnt_in = scoreCnt + 1'd1;
					end
				if ( ((Ball_X_Pos_in + 10 >= coin_r2_1_x && Ball_X_Pos_in + 10 <= coin_r2_1_x + 19) || (Ball_X_Pos_in - 10 >= coin_r2_1_x && Ball_X_Pos_in - 10 <= coin_r2_1_x + 19)) 
						&&
					  ((Ball_Y_Pos_in + Ball_Size_Y <= coin_r2_1_y + 19 + 1) && (Ball_Y_Pos_in + Ball_Size_Y >= coin_r2_1_y))
					   &&
						is_alive != 2'd0
					)
					begin
						scoreCnt_in = scoreCnt + 1'd1;
					end
				
				// mushroom collection logic
				if ( ( ((Ball_X_Pos + 10) > (mush_r1_1_x - 10) && (Ball_X_Pos + 10) < (mush_r1_1_x + 10)) || 
						 ((Ball_X_Pos - 10) > (mush_r1_1_x - 10) && (Ball_X_Pos - 10) < (mush_r1_1_x + 10))   ) 
						 &&
					  ( ((Ball_Y_Pos + Ball_Size_Y) >= (mush_r1_1_y - 10) && (Ball_Y_Pos + Ball_Size_Y) <= (mush_r1_1_y + 10)) || 
						 ((Ball_Y_Pos - Ball_Size_Y) >= (mush_r1_1_y - 10) && (Ball_Y_Pos - Ball_Size_Y) <= (mush_r1_1_y + 10))   )
						 && is_alive != 2'd0 )
					begin
						Ball_Size_Y_in = 10'd20;
						is_alive_in = 2'd2;
						scoreCnt_in = scoreCnt + 1'd1;
					end
				
				// fireball death logic
				if ( ( ((Ball_X_Pos + 10) > (fball_r3_1_x - 10) && (Ball_X_Pos + 10) < (fball_r3_1_x + 10)) || 
						 ((Ball_X_Pos - 10) > (fball_r3_1_x - 10) && (Ball_X_Pos - 10) < (fball_r3_1_x + 10))   ) 
						 &&
					  ( ((Ball_Y_Pos + Ball_Size_Y) >= (fball_r3_1_y - 10) && (Ball_Y_Pos + Ball_Size_Y) <= (fball_r3_1_y + 10)) || 
						 ((Ball_Y_Pos - Ball_Size_Y) >= (fball_r3_1_y - 10) && (Ball_Y_Pos - Ball_Size_Y) <= (fball_r3_1_y + 10))   )
						 && is_alive != 2'd0 )
					begin
						if (DamageCount == 2'd0)
						begin
							DamageCount_in = 2'd1;
							is_alive_in = is_alive - 1'b1;
							Ball_Size_Y_in = 10'd10;
						end
					end
				
				// END OF SECTION FOR COLLISIONS WITH GOOMBAS, COINS, MUSHROOMS, FIREBALLS --------------------------------
				
				// level transition logic
				if (on_ground == 1'b1)
				begin
					if (Ball_X_Pos_in >= 600)
					begin
						roomNum_in = roomNum + 1'b1;
						normal_functionality_in = 1'b0;
					end
				end
				
				// key logic - WASD :D
				if (w_on == 1'b1)
				begin
					// jumping
					on_ground_in = 1'b0;
					
					if (is_wall_down == 1'b1 || is_wall_down_left == 1'b1 || is_wall_down_right == 1'b1) // this means we are touching the ground and we're allowed to jump
					begin
						Ball_Y_Vel_in = -10'd5; // set an initial jump velocity
					end
					
					// pushback
					Ball_Y_Pos_in_temp = Ball_Y_Pos + Ball_Y_Vel;
					if (is_wall_up_pushback == 1'b1 || is_wall_up_left_pushback == 1'b1 || is_wall_up_right_pushback == 1'b1)
					begin
						Ball_Y_Pos_in = (Ball_Y_Pos_in_temp + (20 - (Ball_Y_Pos_in_temp % 20)) + Ball_Size_Y) - 20;
						Ball_Y_Vel_in = 10'd0;	
					end
					else if (is_wall_down_pushback == 1'b1 || is_wall_down_left_pushback == 1'b1 || is_wall_down_right_pushback == 1'b1)
					begin
						Ball_Y_Pos_in = (Ball_Y_Pos_in_temp - (Ball_Y_Pos_in_temp % 20) - 1 - Ball_Size_Y) + 20;
					end
				end
				if (a_on == 1'b1)
				begin
					is_right_in = 1'b0;
					Ball_X_Pos_in_temp = Ball_X_Pos - Ball_X_Step;
					if (is_wall_left_pushback == 1'b1 || is_wall_up_left_pushback == 1'b1 || is_wall_down_left_pushback == 1'b1)
					begin
						Ball_X_Pos_in = (Ball_X_Pos_in_temp + (20 - (Ball_X_Pos_in_temp % 20)) + Ball_Size_X) - 20;
					end
					else
					begin
						Ball_X_Pos_in = Ball_X_Pos - Ball_X_Step;
					end
					
					// gravity logic here
					
					// pushback
					Ball_Y_Pos_in_temp = Ball_Y_Pos + Ball_Y_Vel;
					if (is_wall_up_pushback == 1'b1 || is_wall_up_left_pushback == 1'b1 || is_wall_up_right_pushback == 1'b1)
					begin
						Ball_Y_Pos_in = (Ball_Y_Pos_in_temp + (20 - (Ball_Y_Pos_in_temp % 20)) + Ball_Size_Y) - 20;
						Ball_Y_Vel_in = 10'd0;
					end
					else if (is_wall_down_pushback == 1'b1 || is_wall_down_left_pushback == 1'b1 || is_wall_down_right_pushback == 1'b1)
					begin
						Ball_Y_Pos_in = (Ball_Y_Pos_in_temp - (Ball_Y_Pos_in_temp % 20) - 1 - Ball_Size_Y) + 20;
					end
				end
				/*8'h16: //S
				begin
					Ball_Y_Pos_in_temp = Ball_Y_Pos + Ball_Y_Step;
					if (is_wall_down_pushback == 1'b1 || is_wall_down_left_pushback == 1'b1 || is_wall_down_right_pushback == 1'b1)
					begin
						Ball_Y_Pos_in = (Ball_Y_Pos_in_temp - (Ball_Y_Pos_in_temp % 20) - 1 - Ball_Size) + 20;
					end
					else
					begin
						Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Step;
					end
				end*/
				if (d_on == 1'b1)
				begin
					is_right_in = 1'b1;
					Ball_X_Pos_in_temp = Ball_X_Pos + Ball_X_Step;
					if (is_wall_right_pushback == 1'b1 || is_wall_up_right_pushback == 1'b1 || is_wall_down_right_pushback == 1'b1)
					begin
						Ball_X_Pos_in = (Ball_X_Pos_in_temp - (Ball_X_Pos_in_temp % 20) - 1 - Ball_Size_X) + 20;
					end
					else
					begin
						Ball_X_Pos_in = Ball_X_Pos + Ball_X_Step;
					end
					// gravity logic here
					
					// pushback
					Ball_Y_Pos_in_temp = Ball_Y_Pos + Ball_Y_Vel;
					if (is_wall_up_pushback == 1'b1 || is_wall_up_left_pushback == 1'b1 || is_wall_up_right_pushback == 1'b1)
					begin
						Ball_Y_Pos_in = (Ball_Y_Pos_in_temp + (20 - (Ball_Y_Pos_in_temp % 20)) + Ball_Size_Y) - 20; 
						Ball_Y_Vel_in = 10'd0;
					end
					else if (is_wall_down_pushback == 1'b1 || is_wall_down_left_pushback == 1'b1 || is_wall_down_right_pushback == 1'b1)
					begin
						Ball_Y_Pos_in = (Ball_Y_Pos_in_temp - (Ball_Y_Pos_in_temp % 20) - 1 - Ball_Size_Y) + 20;
					end
				end
			end
			
		end
	end
    
   // Compute whether the pixel corresponds to ball or background
   /* Since the multiplicants are required to be signed, we have to first cast them
      from logic to int (signed by default) before they are multiplied. */
   int DistX, DistY;
   assign DistX = DrawX - Ball_X_Pos + Ball_Size_X;
   assign DistY = DrawY - Ball_Y_Pos + Ball_Size_Y;
	
   always_comb begin
		if (DistX <= (Ball_Size_X*2) && DistY <= (Ball_Size_Y*2) && DistX >= 10'd0 && DistY >= 10'd0)
			is_ball = 1'b1;
		else
			is_ball = 1'b0;
		if (is_ball == 1'b1)
		begin
			if (is_right == 1'b1)
				mario_address = DistX + DistY * 21;
			else
				if (DistX < Ball_Size_X) // addition
					mario_address = (Ball_Size_X - DistX + Ball_Size_X) + DistY * 21;
				else if (DistX > Ball_Size_X) // subtraction
					mario_address = (Ball_Size_X - DistX - Ball_Size_X) + DistY * 21;
				else
					mario_address = DistX + DistY * 21;
		end
		else
			mario_address = 9'b0; // don't care
	end 
	
endmodule
