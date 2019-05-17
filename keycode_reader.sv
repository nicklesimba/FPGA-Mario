
module keycode_reader(
							input [31:0] keycode,
							output logic w_on, a_on, d_on 
							);
	assign w_on = (keycode[31:24] == 8'h1A || keycode[23:16] == 8'h1A || keycode[15: 8] == 8'h1A || keycode[ 7: 0] == 8'h1A);
	assign a_on = (keycode[31:24] == 8'h04 || keycode[23:16] == 8'h04 || keycode[15: 8] == 8'h04 || keycode[ 7: 0] == 8'h04);
	assign d_on = (keycode[31:24] == 8'h07 || keycode[23:16] == 8'h07 || keycode[15: 8] == 8'h07 || keycode[ 7: 0] == 8'h07);
endmodule
