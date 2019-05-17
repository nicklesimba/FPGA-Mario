//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//                                                                       --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapper ( 
							  input 			 		is_logo,				  // if this is a 0 we're gonna draw the logo, otherwise nah lol
							  input		  [15:0] logo_address,		  // if there is a logo, gotta decide its sprite colors with this address.
							  input		  [1:0]	is_alive,			  // Mario's health - 0 if dead
																				  //	(calculated in ball.sv)
							  input					is_alive_goomba,	  // Whether goomba at current DrawX/Y is alive or not
							  input              is_ball,            // Whether current pixel belongs to ball 
                                                              //   or background (computed in ball.sv)
							  input					is_wall,				  // Whether current pixel is a collision wall or not
																				  // 	 (calculated in wall.sv)
							  input					is_brick,			  // Whether current pixel belongs to brick
																				  // 	 or ground	(computed in wall.sv)
							  input					is_qblock,			  // Whether current pixel belongs to qblock
																				  //   or background (computed in qblock.sv)
							  input					blink_num,			  // Blink # for qblock animation - calculated in qblock.sv
							  input					is_coin,				  // Whether current pixel belongs to coin
																				  // 	 or background (computed in coin.sv)
							  input					is_mush,				  // Whether current pixel belongs to mushroom
																				  //   or background (computed in mush.sv)
							  input			[1:0] spin_num,			  // Spin # for coin spin animation - calculated in coin.sv
							  input					is_empty,			  // Whether block is empty or not - calculated in qblock.sv
							  input					is_goomba,			  // Whether current pixel belongs to goomba
																				  // 	 or background (computed in goomba.sv)
							  input					is_fball,			  // Whether current pixel belongs to fball
																				  // 	 or background (computed in fball.sv)
							  input					up_num,				  // Whether fireball is oriented up or down - calculated in fball.sv
							  input					on_ground,			  // Whether mario is on the ground or not (computed in ball.sv)
							  input					is_walking,			  // Whether mario is moving left/right on the ground or not.
							  input 			[1:0] walk_num,			  // walk animation of mario walking
							  input					walk_num_goomba,	  // walk animation of goomba
							  input			[9:0] mario_address,		  // if mario is here, gotta decide its sprite colors with this address
							  input			[8:0]	goomba_address,	  // if a goomba is here, gotta decide its sprite colors with this address
							  input			[8:0] wall_address,		  // if there is a wall, gotta decide its sprite colors with this address
							  input			[8:0] qblock_address,	  // if there is a qblock, gotta decide its sprite colors with this address
							  input			[8:0] coin_address,		  // if there is a coin, gotta decide its sprite colors with this address
							  input			[8:0] mush_address,		  // if there is a mush, gotta decide its sprite colors with this address
							  input			[8:0]	fball_address,		  // if there is a fball, gotta decide its sprite colors with this address
                       input        [9:0] DrawX, DrawY,       // Current pixel coordinates
                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                     );
    
    logic [7:0] Red, Green, Blue;
	 logic [23:0] output_color_logo,
					  output_color_ground,
					  output_color_brick,
					  output_color_mario_still, 
					  output_color_mario_jump, 
					  output_color_mario_walk_1, 
					  output_color_mario_walk_2,
					  output_color_mario_walk_3,
					  output_color_mario_big_still,
					  output_color_mario_big_jump,
					  output_color_mario_big_walk_1,
					  output_color_mario_big_walk_2,
					  output_color_mario_big_walk_3,
					  output_color_mario_dead,
					  output_color_goomba_walk_1,
					  output_color_goomba_walk_2,
					  output_color_goomba_squished,
					  output_color_qblock_blink_1,
					  output_color_qblock_blink_2,
					  output_color_qblock_empty,
					  output_color_coin_spin_1,
					  output_color_coin_spin_2,
					  output_color_coin_spin_3,
					  output_color_coin_spin_4,
					  output_color_mush,
					  output_color_fball_up,
					  output_color_fball_down;
    
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
    
	 // sprite modules
		 // logo sprite
		 ram_logo logo(.read_address(logo_address), .output_color(output_color_logo));
		 
		 // ground tiles
		 ram_tile_ground ground_tiles(.read_address(wall_address), .output_color(output_color_ground));
		 ram_tile_brick  brick_tiles(.read_address(wall_address), .output_color(output_color_brick));
	 
		 // mario sprites
		 ram_mario_still_right mario_still(.read_address(mario_address), .output_color(output_color_mario_still));
		 ram_mario_jump_right mario_jump(.read_address(mario_address), .output_color(output_color_mario_jump));
		 ram_mario_walk_right_1 mario_walk_1(.read_address(mario_address), .output_color(output_color_mario_walk_1));
		 ram_mario_walk_right_2 mario_walk_2(.read_address(mario_address), .output_color(output_color_mario_walk_2));
		 ram_mario_walk_right_3 mario_walk_3(.read_address(mario_address), .output_color(output_color_mario_walk_3));
		 
		 ram_mario_big_still_right mario_big_still(.read_address(mario_address), .output_color(output_color_mario_big_still));
		 ram_mario_big_jump_right mario_big_jump(.read_address(mario_address), .output_color(output_color_mario_big_jump));
		 ram_mario_big_walk_right_1 mario_big_walk_1(.read_address(mario_address), .output_color(output_color_mario_big_walk_1));
		 ram_mario_big_walk_right_2 mario_big_walk_2(.read_address(mario_address), .output_color(output_color_mario_big_walk_2));
		 ram_mario_big_walk_right_3 mario_big_walk_3(.read_address(mario_address), .output_color(output_color_mario_big_walk_3));
		 
		 ram_mario_dead mario_dead(.read_address(mario_address), .output_color(output_color_mario_dead));
		 
		 // goomba sprites
		 ram_goomba_walk_1 goomba_walk_1(.read_address(goomba_address), .output_color(output_color_goomba_walk_1));
		 ram_goomba_walk_2 goomba_walk_2(.read_address(goomba_address), .output_color(output_color_goomba_walk_2));
		 ram_goomba_squished goomba_squished(.read_address(goomba_address), .output_color(output_color_goomba_squished));
		 
		 // qblock sprites
		 ram_qblock_blink_1 qblock_blink_1(.read_address(qblock_address), .output_color(output_color_qblock_blink_1));
		 ram_qblock_blink_2 qblock_blink_2(.read_address(qblock_address), .output_color(output_color_qblock_blink_2));
		 ram_qblock_empty qblock_empty(.read_address(qblock_address), .output_color(output_color_qblock_empty));
		 
		 // coin sprites
		 ram_coin_spin_1 coin_spin_1(.read_address(coin_address), .output_color(output_color_coin_spin_1));
		 ram_coin_spin_2 coin_spin_2(.read_address(coin_address), .output_color(output_color_coin_spin_2));
		 ram_coin_spin_3 coin_spin_3(.read_address(coin_address), .output_color(output_color_coin_spin_3));
		 ram_coin_spin_4 coin_spin_4(.read_address(coin_address), .output_color(output_color_coin_spin_4));
	 
		 // mush sprites
		 ram_mush mush(.read_address(mush_address), .output_color(output_color_mush));
		 
		 // fball sprites
		 ram_fball_up fball_up(.read_address(fball_address), .output_color(output_color_fball_up));
		 ram_fball_down fball_down(.read_address(fball_address), .output_color(output_color_fball_down));
	 
    // Assign color based on is_ball signal
    always_comb
    begin
        if (is_logo == 1'b1)
		  begin
				Red = output_color_logo[23:16];
				Green = output_color_logo[15:8];
				Blue = output_color_logo[7:0];
		  end
		  else if (is_ball == 1'b1) 
        begin
		      if (is_alive == 2'd0)
				begin
					if (output_color_mario_dead == 24'h800080)
					begin
						Red = 8'h00; 
						Green = 8'h8A;
						Blue = 8'hC5;
					end
					else 
					begin
						Red = output_color_mario_dead[23:16];
						Green = output_color_mario_dead[15:8];
						Blue = output_color_mario_dead[7:0];
					end
				end
				else if (is_alive == 2'd2) // 2 health
				begin
					if (on_ground == 1'b1) // mario is on the ground					
					begin
						//draw mario moving
						if (is_walking == 1'b1)
						begin
							if (walk_num == 3'd1)
							begin
								if (output_color_mario_big_walk_1 == 24'h800080)
								begin
									Red = 8'h00; 
									Green = 8'h8A;
									Blue = 8'hC5;
								end
								else 
								begin
									Red = output_color_mario_big_walk_1[23:16];
									Green = output_color_mario_big_walk_1[15:8];
									Blue = output_color_mario_big_walk_1[7:0];
								end
							end
							else if (walk_num == 3'd2)
							begin
								if (output_color_mario_big_walk_2 == 24'h800080)
								begin
									Red = 8'h00; 
									Green = 8'h8A;
									Blue = 8'hC5;
								end
								else 
								begin
									Red = output_color_mario_big_walk_2[23:16];
									Green = output_color_mario_big_walk_2[15:8];
									Blue = output_color_mario_big_walk_2[7:0];
								end
							end
							else
							begin
								if (output_color_mario_big_walk_3 == 24'h800080)
								begin
									Red = 8'h00; 
									Green = 8'h8A;
									Blue = 8'hC5;
								end
								else 
								begin
									Red = output_color_mario_big_walk_3[23:16];
									Green = output_color_mario_big_walk_3[15:8];
									Blue = output_color_mario_big_walk_3[7:0];
								end
							end
						end
						// draw mario still
						else
						begin
							if (output_color_mario_big_still == 24'h800080)
							begin
								Red = 8'h00; 
								Green = 8'h8A;
								Blue = 8'hC5;
							end
							else 
							begin
								Red = output_color_mario_big_still[23:16];
								Green = output_color_mario_big_still[15:8];
								Blue = output_color_mario_big_still[7:0];
							end
						end
					end
					else // mario is not on the ground (in the air)
					begin
						// draw mario jumping
						if (output_color_mario_big_jump == 24'h800080)
						begin
							Red = 8'h00; 
							Green = 8'h8A;
							Blue = 8'hC5;
						end
						else 
						begin
							Red = output_color_mario_big_jump[23:16];
							Green = output_color_mario_big_jump[15:8];
							Blue = output_color_mario_big_jump[7:0];
						end
					end
				end
				else // one health
				begin
					if (on_ground == 1'b1) // mario is on the ground					
					begin
						//draw mario moving
						if (is_walking == 1'b1)
						begin
							if (walk_num == 3'd1)
							begin
								if (output_color_mario_walk_1 == 24'h800080)
								begin
									Red = 8'h00; 
									Green = 8'h8A;
									Blue = 8'hC5;
								end
								else 
								begin
									Red = output_color_mario_walk_1[23:16];
									Green = output_color_mario_walk_1[15:8];
									Blue = output_color_mario_walk_1[7:0];
								end
							end
							else if (walk_num == 3'd2)
							begin
								if (output_color_mario_walk_2 == 24'h800080)
								begin
									Red = 8'h00; 
									Green = 8'h8A;
									Blue = 8'hC5;
								end
								else 
								begin
									Red = output_color_mario_walk_2[23:16];
									Green = output_color_mario_walk_2[15:8];
									Blue = output_color_mario_walk_2[7:0];
								end
							end
							else
							begin
								if (output_color_mario_walk_3 == 24'h800080)
								begin
									Red = 8'h00; 
									Green = 8'h8A;
									Blue = 8'hC5;
								end
								else 
								begin
									Red = output_color_mario_walk_3[23:16];
									Green = output_color_mario_walk_3[15:8];
									Blue = output_color_mario_walk_3[7:0];
								end
							end
						end
						// draw mario still
						else
						begin
							if (output_color_mario_still == 24'h800080)
							begin
								Red = 8'h00; 
								Green = 8'h8A;
								Blue = 8'hC5;
							end
							else 
							begin
								Red = output_color_mario_still[23:16];
								Green = output_color_mario_still[15:8];
								Blue = output_color_mario_still[7:0];
							end
						end
					end
					else // mario is not on the ground (in the air)
					begin
						// draw mario jumping
						if (output_color_mario_jump == 24'h800080)
						begin
							Red = 8'h00; 
							Green = 8'h8A;
							Blue = 8'hC5;
						end
						else 
						begin
							Red = output_color_mario_jump[23:16];
							Green = output_color_mario_jump[15:8];
							Blue = output_color_mario_jump[7:0];
						end
					end
				end
		  end
		  else if (is_mush == 1'b1)
		  begin
				if (output_color_mush == 24'h800080)
				begin
					Red = 8'h00; 
					Green = 8'h8A;
					Blue = 8'hC5;
				end
				else
				begin
					Red = output_color_mush[23:16];
					Green = output_color_mush[15:8];
					Blue = output_color_mush[7:0]; 
				end
		  end
		  else if (is_fball == 1'b1)
		  begin
				if (up_num == 1'b1)
				begin
					if (output_color_fball_up == 24'h800080)
					begin
						Red = 8'h00; 
						Green = 8'h8A;
						Blue = 8'hC5;
					end
					else
					begin
						Red = output_color_fball_up[23:16];
						Green = output_color_fball_up[15:8];
						Blue = output_color_fball_up[7:0];
					end
				end
				else
				begin
					if (output_color_fball_down == 24'h800080)
					begin
						Red = 8'h00; 
						Green = 8'h8A;
						Blue = 8'hC5;
					end
					else
					begin
						Red = output_color_fball_down[23:16];
						Green = output_color_fball_down[15:8];
						Blue = output_color_fball_down[7:0];
					end
				end
		  end
		  else if (is_goomba == 1'b1)
		  begin
				if (is_alive_goomba == 1'b0)
				begin
					if (output_color_goomba_squished == 24'h800080)
					begin
						Red = 8'h00; 
						Green = 8'h8A;
						Blue = 8'hC5;
					end
					else
					begin
						Red = output_color_goomba_squished[23:16];
						Green = output_color_goomba_squished[15:8];
						Blue = output_color_goomba_squished[7:0]; 
					end
				end
				else
				begin
					if (walk_num_goomba == 1'b0)
					begin
						if (output_color_goomba_walk_1 == 24'h800080)
						begin
							Red = 8'h00; 
							Green = 8'h8A;
							Blue = 8'hC5;
						end
						else
						begin
							Red = output_color_goomba_walk_1[23:16];
							Green = output_color_goomba_walk_1[15:8];
							Blue = output_color_goomba_walk_1[7:0]; 
						end
					end
					else
					begin
						if (output_color_goomba_walk_2 == 24'h800080)
						begin
							Red = 8'h00; 
							Green = 8'h8A;
							Blue = 8'hC5;
						end
						else
						begin
							Red = output_color_goomba_walk_2[23:16];
							Green = output_color_goomba_walk_2[15:8];
							Blue = output_color_goomba_walk_2[7:0]; 
						end
					end
				end
		  end
		  else if (is_coin == 1'b1)
		  begin
				if (spin_num == 2'd0)
				begin
					if (output_color_coin_spin_1 == 24'h800080)
					begin
						Red = 8'h00; 
						Green = 8'h8A;
						Blue = 8'hC5;
					end
					else
					begin
						Red = output_color_coin_spin_1[23:16];
						Green = output_color_coin_spin_1[15:8];
						Blue = output_color_coin_spin_1[7:0]; 
					end
				end
				else if (spin_num == 2'd1)
				begin
					if (output_color_coin_spin_2 == 24'h800080)
					begin
						Red = 8'h00; 
						Green = 8'h8A;
						Blue = 8'hC5;
					end
					else
					begin
						Red = output_color_coin_spin_2[23:16];
						Green = output_color_coin_spin_2[15:8];
						Blue = output_color_coin_spin_2[7:0]; 
					end
				end
				else if (spin_num == 2'd2)
				begin
					if (output_color_coin_spin_3 == 24'h800080)
					begin
						Red = 8'h00; 
						Green = 8'h8A;
						Blue = 8'hC5;
					end
					else
					begin
						Red = output_color_coin_spin_3[23:16];
						Green = output_color_coin_spin_3[15:8];
						Blue = output_color_coin_spin_3[7:0]; 
					end
				end
				else
				begin
					if (output_color_coin_spin_4 == 24'h800080)
					begin
						Red = 8'h00; 
						Green = 8'h8A;
						Blue = 8'hC5;
					end
					else
					begin
						Red = output_color_coin_spin_4[23:16];
						Green = output_color_coin_spin_4[15:8];
						Blue = output_color_coin_spin_4[7:0]; 
					end
				end
		  end
		  else if (is_qblock == 1'b1)
		  begin
				if (is_empty == 1'b0)
				begin
					if (blink_num == 1'b1)
					begin
						// draw sprite
						Red = output_color_qblock_blink_1[23:16];
						Green = output_color_qblock_blink_1[15:8];
						Blue = output_color_qblock_blink_1[7:0];
					end
					else 
					begin
						// draw sprite
						Red = output_color_qblock_blink_2[23:16];
						Green = output_color_qblock_blink_2[15:8];
						Blue = output_color_qblock_blink_2[7:0];
					end
				end
				else
				begin
					// draw sprite
					Red = output_color_qblock_empty[23:16];
					Green = output_color_qblock_empty[15:8];
					Blue = output_color_qblock_empty[7:0];
				end
		  end
		  else if (is_wall == 1'b1)
		  begin
				if (is_brick == 1'b0)
				begin
					// draw sprite
					Red = output_color_ground[23:16];
					Green = output_color_ground[15:8];
					Blue = output_color_ground[7:0];
				end
				else
				begin
					// draw sprite
					Red = output_color_brick[23:16];
					Green = output_color_brick[15:8];
					Blue = output_color_brick[7:0];
				end
        end
		  else 
        begin
            // Mario blue background
            Red = 8'h00; 
            Green = 8'h8A;
            Blue = 8'hC5;
        end
    end 
    
endmodule
