module audio3 ( CLOCK_50,						//	On Board 50 MHz
		SW,						
		KEY,								// On Board Keys
		LEDR,
//		VGA_CLK,   						//	VGA Clock
//		VGA_HS,							//	VGA H_SYNC
//		VGA_VS,							//	VGA V_SYNC
//		VGA_BLANK_N,					//	VGA BLANK
//		VGA_SYNC_N,						//	VGA SYNC
//		VGA_R,   						//	VGA Red[9:0]
//		VGA_G,	 						//	VGA Green[9:0]
//		VGA_B,   						//	VGA Blue[9:0]
//		PS2_CLK,
//		PS2_DAT,
		AUD_ADCDAT,

		// Bidirectionals
		AUD_BCLK,
		AUD_ADCLRCK,
		AUD_DACLRCK,

		FPGA_I2C_SDAT,

		// Outputs
		AUD_XCK,
		AUD_DACDAT,

		FPGA_I2C_SCLK,
//		HEX0,
//		HEX1,
//		HEX2,
//		HEX3
		);
		
		//audio to start playing in the lobby 

	input			CLOCK_50;			//	50 MHz
	input	[3:0]	KEY;					
	input [9:0] SW;
	output [9:0] LEDR; 
	
	input				AUD_ADCDAT;

	inout				AUD_BCLK;
	inout				AUD_ADCLRCK;
	inout				AUD_DACLRCK;

	inout				FPGA_I2C_SDAT;

	output				AUD_XCK;
	output				AUD_DACDAT;
	output				FPGA_I2C_SCLK;
	
	wire				audio_in_available;
	wire		[31:0]	left_channel_audio_in;
	wire		[31:0]	right_channel_audio_in;
	wire				read_audio_in;

	wire				audio_out_allowed;
	wire		[31:0]	left_channel_audio_out;
	wire		[31:0]	right_channel_audio_out;
	wire				write_audio_out;
	wire     [7:0] data_received;

	reg [18:0] delay_cnt;
	wire [18:0] delay;

	reg snd;

	reg [22:0] beatCountMario;
	reg [9:0] addressMario; 
														
	audio_rom r1(.address(addressMario), .clock(CLOCK_50), .q(delay));

	always @(posedge CLOCK_50)
		if(delay_cnt == delay) begin
			delay_cnt <= 0;
			snd <= !snd;
		end else delay_cnt <= delay_cnt + 1;

	always @(posedge CLOCK_50) begin
		if(beatCountMario == 23'd2500000)begin
			beatCountMario <= 23'b0;
			if(addressMario < 10'd999)
				addressMario <= addressMario + 1;
			else begin
				addressMario <= 0;
				beatCountMario <= 0;
			end
		end
		else 
			beatCountMario <= beatCountMario + 1;
	end

	wire [31:0] sound = snd ? 32'd100000000 : -32'd100000000;

	assign read_audio_in			= audio_in_available & audio_out_allowed;
	assign left_channel_audio_out	= left_channel_audio_in+sound;
	assign right_channel_audio_out	= left_channel_audio_in+sound;
	assign write_audio_out			= audio_in_available & audio_out_allowed;

	Audio_Controller Audio_Controller (
		// Inputs
		.CLOCK_50						(CLOCK_50),
		.reset						(~KEY[0]),

		.clear_audio_in_memory		(),
		.read_audio_in				(read_audio_in),
		
		.clear_audio_out_memory		(),
		.left_channel_audio_out		(left_channel_audio_out),
		.right_channel_audio_out	(right_channel_audio_out),
		.write_audio_out			(write_audio_out),

		.AUD_ADCDAT					(AUD_ADCDAT),

		// Bidirectionals
		.AUD_BCLK					(AUD_BCLK),
		.AUD_ADCLRCK				(AUD_ADCLRCK),
		.AUD_DACLRCK				(AUD_DACLRCK),


		// Outputs
		.audio_in_available			(audio_in_available),
		.left_channel_audio_in		(left_channel_audio_in),
		.right_channel_audio_in		(right_channel_audio_in),

		.audio_out_allowed			(audio_out_allowed),

		.AUD_XCK					(AUD_XCK),
		.AUD_DACDAT					(AUD_DACDAT)

	);

	avconf #(.USE_MIC_INPUT(1)) avc (
		.FPGA_I2C_SCLK					(FPGA_I2C_SCLK),
		.FPGA_I2C_SDAT					(FPGA_I2C_SDAT),
		.CLOCK_50					(CLOCK_50),
		.reset						(~KEY[0])
	);
endmodule