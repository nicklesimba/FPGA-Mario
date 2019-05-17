/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

module  ram_tile_ground
(
		input [8:0] read_address,
		output logic [23:0] output_color
);

// mem has width of 4 bits and a total of 400 addresses
logic [3:0] mem [0:399];

logic [23:0] pal [8:0];
assign pal[0] = 24'h800080;
assign pal[1] = 24'h888173;
assign pal[2] = 24'h0A0000;
assign pal[3] = 24'hFFFFEF;
assign pal[4] = 24'hFFC89C;
assign pal[5] = 24'hE6570C;
assign pal[6] = 24'hAB3A00;
assign pal[7] = 24'h756C5F;
assign pal[8] = 24'hE33F00;

assign output_color = pal[mem[read_address]];

initial
begin
	 $readmemh("C:/ece385/final_project/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/tile_ground.txt", mem);
end

endmodule
