/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

module  ram_tile_brick
(
		input [8:0] read_address,
		output logic [23:0] output_color
);

// mem has width of 4 bits and a total of 400 addresses
logic [3:0] mem [0:399];

logic [23:0] pal [6:0];
assign pal[0] = 24'h800080;
assign pal[1] = 24'h000000;
assign pal[2] = 24'h6E2601;
assign pal[3] = 24'hB24204;
assign pal[4] = 24'hE85C0C;
assign pal[5] = 24'hFF6F0B;
assign pal[6] = 24'hFFE7C8;

assign output_color = pal[mem[read_address]];

initial
begin
	 $readmemh("C:/ece385/final_project/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/tile_brick.txt", mem);
end

endmodule
