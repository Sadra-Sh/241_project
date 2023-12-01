
module DE1_SoC_Audio_Example (
	// Inputs
	CLOCK_50,
	KEY,

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
	SW
);

/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/


/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/
// Inputs
input				CLOCK_50; /* 50 M hz clock serviing as the reference clock for the entire system */
input		[3:0]	KEY; /* input press keys and swtiches*/
input		[3:0]	SW; 

input				AUD_ADCDAT; /* input carrying audio data form an analog to digital converter carrying the digitized audio signals */
input [3:0] mif_audio_data;

// Bidirectionals
inout				AUD_BCLK; /* audio bit clock - clock for audio data transmission used to synchronize the sending receiving of data*/ 
inout				AUD_ADCLRCK; /* audio left/right channel clock - helps with synchornization between the 2 channels */
inout				AUD_DACLRCK;  

inout				FPGA_I2C_SDAT; /* I2C dataline - tansfering data between the FPGA and the speakers */

// Outputs
output				AUD_XCK; /* audio tansmit clock - */
output				AUD_DACDAT; /* audio DAC clock - carrying data to digital to analog converter */

output				FPGA_I2C_SCLK; /* the output clock signal for the I2C communication */

/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
// Internal Wires
wire				audio_in_available;
wire		[31:0]	left_channel_audio_in;
wire		[31:0]	right_channel_audio_in;
wire				read_audio_in;

wire				audio_out_allowed;
wire		[31:0]	left_channel_audio_out;
wire		[31:0]	right_channel_audio_out;
wire				write_audio_out;
reg [3:0] mif_audio_wire;
wire delay_clock;

// Internal Registers

reg [18:0] delay_cnt;
wire [18:0] delay;

wire rate_divider_clock; // out of rate divider

reg sound_enable <= 1; //enables the sound to be played

reg snd;

// State Machine Registers

/*****************************************************************************
 *                         Finite State Machine(s)                           *
 *****************************************************************************/


/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/

rateDivider rate_divider (.clock(CLOCK_50), .reset(~KEY[0]), rate_divider_clock)

always@(posedge rate_divider_clock) begin
	mem_addr <= mem_addr + 1;
	if(mem_addr == 4) begin
		sound_enable <= 0;
	end
end

always @(posedge CLOCK_50) begin
	if(delay_cnt == delay) begin # 
		delay_cnt <= 0;
		snd <= !snd;
	end  else delay_cnt <= delay_cnt + 1; 
end

reg [8:0] mif_data [0:3]; 
reg [3:0] mif_adder;

initial begin
	$readmemb ("test.mif", mif_data);
end

always @(posedge CLOCK_50)begin 
	if (KEY[0]) mif_adder <= 0;
	else begin
		mif_adder <= mif_adder + 1;
		mif_audio_wire <= mif_data[mif_adder];
	end
end 

/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/

assign delay = mif_audio_wire[8:0];

wire [31:0] sound = (!snd_enable) ? 0 : snd ? 32'd10000000 : -32'd10000000; //the level of sound


assign read_audio_in			= audio_in_available & audio_out_allowed;

assign left_channel_audio_out	= left_channel_audio_in+sound; 
assign right_channel_audio_out	= right_channel_audio_in+sound;
assign write_audio_out			= audio_in_available & audio_out_allowed;

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/

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

	.AUD_ADCDAT					(mif_audio_data),

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

module rateDivider (
	input clock,
	input reset,
	output out_clock,
)
	reg [$clog2(CLOCK_FREQUENCY*4)-1, 0] downcount;

	always @(posedge clock) begin
		if (reset || downcount == 28'd0) 
			downcount = (CLOCK_FREQUENCY*0.1) - 1 //every 1/10 seconds

		else begin
			downcount <= downcount -1;
		end
	end

	assign out_clock = (downcount = 0) ? 1b'1:1b'0;

endmodule
