module logo (
					input [9:0]   DrawX, DrawY,       // Current pixel coordinates
					input [1:0]   RoomNum,				 // current "level"
					output logic  is_logo,				 // Whether current pixel belongs to logo or background
					output logic  [15:0] logo_address // address for color mapper to figure out what color the logo pixel should be
				);
	always_comb
	begin
		case (RoomNum)
				2'd0: // start screen room
					begin
						if ( (DrawX >= 144) && (DrawX < 496) && (DrawY >= 40) && (DrawY < 216) )
							is_logo = 1'b1;
						else
							is_logo = 1'b0;
					end
				default:
					is_logo = 1'b0;
		endcase
		
		if (is_logo == 1'b1)
			logo_address = (DrawX - 144) + (DrawY - 40) * 352;
		else
			logo_address = 14'd0; // don't care
	end
			
endmodule
