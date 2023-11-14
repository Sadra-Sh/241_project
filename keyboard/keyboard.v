//////////////////////////////////
/// keyboard interface to DE2  ///
/// Jan 2016                   ///
/// ps2 interface              ///
/// part 1 introducing signals ///
//////////////////////////////////

module keyboard (
clk		, // input 50 MHz clk
ps_clk 	, // ps2 clock
ps_data	, // ps2 data

gpio);     // 40 pin header

input clk;
input ps_clk;
input ps_data;

output[2:0] gpio;
	
assign gpio[0] = clk;
assign gpio[1] = ps_clk;
assign gpio[2] = ps_data;


endmodule
