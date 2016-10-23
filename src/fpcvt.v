`timescale 1ns / 1ps

module fpcvt(
    input [11:0] D,
    output reg S,
    output reg [2:0] E,
    output reg [3:0] F
    );
    
    reg [3:0] leading_zeroes;
    reg [11:0] magnitude;
    reg bit5;
	reg is_2048;
    
    always @*
    begin
		// calculate sign bit
        S = D[11];
		
		// convert to sign magnitude
        if (S)
            magnitude = (~D) + 1;
        else
            magnitude = D;  
        
		// -2048 case
		is_2048 = 0;
        if (magnitude == 2048)
            is_2048 = 1;
		
        // counting leading zeroes, up to 8
        leading_zeroes = 0;
        while ((magnitude[11] == 1'b0) && (leading_zeroes < 8))
        begin
            magnitude = magnitude << 1;
            leading_zeroes = leading_zeroes + 1;
        end
		
		// Calculate E and F
        if (leading_zeroes == 0)
            E = 7;
        else
            E = 8 - leading_zeroes;
        F = magnitude[11:8];
        bit5 = magnitude[7];
        
        // rounding
        if (bit5)
		begin
			if (F == 'b1111)		// 'b1111 case, round up
			begin
				if (E < 7)
				begin
					F = 'b1000;
					E = E + 1;
				end
			end
			else
				F = F + 1;
		end
			
        // -2048 case
        if (is_2048)
            begin
                E = 7;
                F = 'b1111;
            end
         
    end
   
endmodule
