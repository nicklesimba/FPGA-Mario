/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

module  ram_coin_spin_3
(
		input [8:0] read_address,
		output logic [23:0] output_color
);

// mem has width of 4 bits and a total of 400 addresses
logic [3:0] mem [0:399];

logic [23:0] pal [5:0];
assign pal[0] = 24'h800080;
assign pal[1] = 24'hFFE7D0;
assign pal[2] = 24'hFFFFFF;
assign pal[3] = 24'hF83800;
assign pal[4] = 24'hFE933C;
assign pal[5] = 24'hFE9243;

assign output_color = pal[mem[read_address]];

initial
begin
	 $readmemh("C:/ece385/final_project/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/coin_spin_3.txt", mem);
end

endmodule
