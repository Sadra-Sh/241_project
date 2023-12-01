module PS2 (CLOCK_50, KEY, ps2_clk, ps2_data, HEX0, HEX1, HEX2, HEX3)
    input CLOCK_50; //50 MHz clock
    input KEY;

    inout ps2_clk; //pin names for the ps2 clock and data
    inout ps2_data;

    output HEX0;
    output HEX1;
    output HEX2;
    output HEX3; // display of information on different hex displays 



endmodule

module controlpath (
    input clock,  
    input clr, 
    input ps2clock, //standard logic
    input ps2data, 

    output keyVal1 [7:0],
    output keyVal2 [7:0],
    output keyVal3 [7:0]
)

    localparam start 

    if clr = '1' then 
         ps2c_filter <= (others => '0');
         ps2d_filter <= (others => '0');
         ps2cf <= '1';
         ps2df <= '1';

    elseif clk25'event and clk25 = '1' then
        ps2c_filter (7) <= ps2c;
        ps2c_filter (6 downto 0) <= ps2c_filter (7 downto 1);
        ps2c_filter (7) <= ps2d;
        ps2d_filter (6 downto 0) <= ps2d_filter (7 downto 1);

    if ps2d_filter = X"FF" then 
        ps2cf <= '0';
    elseif ps2d_filter = X"00" then 
        ps2cf <= '0';
    end if;

    if ps2d_filter = X"FF" then 
        ps2df <= '1';
    elseif ps2d_filter = X"00" then 
        ps2df <= '0';
    end if;

    end if;
endmodule 

module shiftregister (
    input CLOCK_50, 
    input clear,
    input ps2_data, 

    output reg [10:0] ps2D,
    )

    always@ (posedge CLOCK_50)begin 
        if (clear == 1'b1) begin
            ps2D <= 10'b0;
        end

        else begin
            ps2D <= {ps2D, }

        end

    end 



endmodule 
