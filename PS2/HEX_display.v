module HEX_display (
    CLOCK_50,
	KEY,

	// Bidirectionals
	PS2_CLK,
	PS2_DAT,
	
	// Outputs
	HEX0,
	HEX1,
	HEX2,
	HEX3,
	HEX4,
	HEX5,
	HEX6,
	HEX7)


endmodule

module HEX0 (input SW[3:0], SW[9:8], LEDR [7:0], output HEX0 [6:0], HEX1 [6:0], HEX4[6:0], HEX5[6:0]);

    assign HEX0[0] = ~(SW[0] | SW[2] ) & (~ SW[0] | ~ SW[3]);
    assign HEX0[1] = ~(SW[0] | ~ SW[3]) & (~ SW[0] | ~ SW[2]) & (~ SW[0] | ~ SW[1]) & (SW[0] | ~ SW[1] | ~ SW[2] | SW[3]);
    assign HEX0[2] = ~(~SW[0]|SW[1]|~SW[2]|~SW[3]) & (~SW[0]|~SW[1]|SW[2]|SW[3]) & (~SW[0]|SW[1]|SW[2]|SW[3]) & (SW[0]|SW[1]|SW[2]|SW[3]);
    assign HEX0[3] = ~(SW[0]|~SW[1]|~SW[2]|~SW[3]) & (~SW[0]|~SW[1]|SW[2]|~SW[3]) & (~SW[0]|SW[1]|SW[2]|~SW[3]) & (~SW[0]|SW[1]|~SW[2]|SW[3]) & (SW[0]|SW[1]|SW[2]|SW[3]);
    assign HEX0[4] = ~(~SW[0]|SW[1]|SW[2]|SW[3]) & (SW[0]|SW[1]|~SW[2]|~SW[3]) & (~SW[0]|~SW[1]|SW[2]|~SW[3]) & (SW[0]|~SW[1]|SW[2]|~SW[3]) & (SW[0]|SW[1]|SW[2]|~SW[3]) & (SW[0]|~SW[1]|~SW[2]|SW[3]);
    assign HEX0[5] = ~(SW[0]|~SW[1]|~SW[2]|~SW[3]) & (~SW[0]|SW[1]|~SW[2]|~SW[3]) & (SW[0]|SW[1]|~SW[2]|~SW[3]) & (SW[0]|SW[1]|SW[2]|~SW[3]) & (SW[0]|~SW[1]|SW[2]|SW[3]);
    assign HEX0[6] = ~(~SW[0]|~SW[1]|~SW[2]|~SW[3]) & (SW[0]|~SW[1]|~SW[2]|~SW[3]) & (SW[0]|SW[1]|SW[2]|~SW[3]) & (~SW[0]|~SW[1]|SW[2]|SW[3]);

    assign HEX1[0] = SW[8] 

endmodule

module HEX1 (input SW[3:0], SW[9:8], LEDR [7:0], output HEX0 [6:0], HEX1 [6:0], HEX4[6:0], HEX5[6:0]);

end
