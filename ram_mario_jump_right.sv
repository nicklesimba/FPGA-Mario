/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

module  ram_mario_jump_right
(
		input [8:0] read_address,
		output logic [23:0] output_color
);

// mem has width of 3 bits and a total of 400 addresses
logic [3:0] mem [0:440];

logic [23:0] pal [6:0];
assign pal[0] = 24'h800080;
assign pal[1] = 24'hF83800;
assign pal[2] = 24'hEA9A30;
assign pal[3] = 24'hEF9D34;
assign pal[4] = 24'h227DBB;
assign pal[5] = 24'hFFA440;
assign pal[6] = 24'hAC7C00;

assign output_color = pal[mem[read_address]];

initial
begin
	 $readmemh("C:/ece385/final_project/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/mario_jump_right.txt", mem);
end

endmodule
