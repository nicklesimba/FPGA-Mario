module audio_interface_wrapper (
											input [15:0] LDATA, // matters
															 RDATA, // matters
											input        clk,
											input			 Reset,
											input			 INIT, // matters
//											output logic INIT_FINISH, // matters
//											output logic adc_full, // matters
//											output logic data_over, // doesn't matter
											output logic AUD_MCLK,
											inout wire	 AUD_BCLK,
											input    	 AUD_ADCDAT,
											output logic AUD_DACDAT,
											inout	wire	 AUD_DACLRCK,
															 AUD_ADCLRCK,
											output logic I2C_SDAT,
											output logic I2C_SCLK,
//											output logic ADCDATA // doesn't matter
											output logic [19:0] SRAM_ADDR
										 );

	logic INIT_FINISH, adc_full;
	
	audio_interface audio (
									.LDATA(LDATA),
									.RDATA(RDATA),
									.clk(clk),
									.Reset(Reset),
									.INIT(INIT),
									.INIT_FINISH(INIT_FINISH), // matters
									.adc_full(adc_full), // matters
									.data_over(),
									.AUD_MCLK(AUD_MCLK),
									.AUD_BCLK(AUD_BCLK),
									.AUD_ADCDAT(AUD_ADCDAT),
									.AUD_DACDAT(AUD_DACDAT),
									.AUD_DACLRCK(AUD_DACLRCK),
									.AUD_ADCLRCK(AUD_ADCLRCK),
									.I2C_SDAT(I2C_SDAT),
									.I2C_SCLK(I2C_SCLK),
									.ADCDATA()
								  );
	
	always_ff @ (posedge adc_full) begin // we are using adc_full as the clock for incrementing through notes of the song
		if (Reset)
			SRAM_ADDR <= 20'b0;
		if (INIT_FINISH == 1'b1) // we are ready to read through this song and increment through the addresses!
		begin
			SRAM_ADDR <= SRAM_ADDR + 1'b1;
		end
	end
	
endmodule
