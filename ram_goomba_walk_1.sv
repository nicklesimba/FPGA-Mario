/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

module  ram_goomba_walk_1
(
		input [8:0] read_address,
		output logic [23:0] output_color
);

// mem has width of 3 bits and a total of 400 addresses
logic [3:0] mem [0:440];

logic [23:0] pal [3:0];
assign pal[0] = 24'h800080;
assign pal[1] = 24'h202020;
assign pal[2] = 24'hE45810;
assign pal[3] = 24'hF4D4B4;

assign output_color = pal[mem[read_address]];

initial
begin
	 $readmemh("C:/ece385/final_project/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/goomba_walk_1.txt", mem);
end

endmodule
