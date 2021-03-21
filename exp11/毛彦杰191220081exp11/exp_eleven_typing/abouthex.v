module abouthex(state,count,data,ascii,hex5,hex4,hex3,hex2,hex1,hex0);
input state;
input [7:0]count;
input [7:0]data;
input [7:0]ascii;
output wire [6:0]hex5;
output wire [6:0]hex4;
output reg [6:0]hex3;
output reg [6:0]hex2;
output reg [6:0]hex1;
output reg [6:0]hex0;
wire [3:0]hex5high;
wire [3:0]hex4low;
//wire [3:0]hex3high;
//wire [3:0]hex2low;
//wire [3:0]hex1high;
//wire [3:0]hex0low;
initial
begin
hex0 = 0;
hex1 = 0;
hex2 = 0;
hex3 = 0;
//hex4 = 0;
//hex5 = 0;
end
assign hex5high = count[7:4];
assign hex4low = count[3:0];
//assign hex3high = ascii[7:4];
//assign hex2low = ascii[3:0];
//assign hex1high = data[7:4];
//assign hex0low = data[3:0];
always @ (*)
begin
	if((state == 0)&&(data != 8'b11110000))
	begin
		//predata is not f0
		case (ascii[7:4])
			0 : hex3 = 7'b1000000;
			1 : hex3 = 7'b1111001;
			2 : hex3 = 7'b0100100;
			3 : hex3 = 7'b0110000;
			4 : hex3 = 7'b0011001;
			5 : hex3 = 7'b0010010;
			6 : hex3 = 7'b0000010;
			7 : hex3 = 7'b1111000;
			8 : hex3 = 7'b0000000;
			9 : hex3 = 7'b0010000;
			10 : hex3 = 7'b0001000;
			11 : hex3 = 7'b0000011;
			12 : hex3 = 7'b1000110;
			13 : hex3 = 7'b0100001;
			14 : hex3 = 7'b0000110;
			15 : hex3 = 7'b0001110;
			default: hex3 = 7'b1111111;
		endcase 
		case (ascii[3:0])
			0 : hex2 = 7'b1000000;
			1 : hex2 = 7'b1111001;
			2 : hex2 = 7'b0100100;
			3 : hex2 = 7'b0110000;
			4 : hex2 = 7'b0011001;
			5 : hex2 = 7'b0010010;
			6 : hex2 = 7'b0000010;
			7 : hex2 = 7'b1111000;
			8 : hex2 = 7'b0000000;
			9 : hex2 = 7'b0010000;
			10 : hex2 = 7'b0001000;
			11 : hex2 = 7'b0000011;
			12 : hex2 = 7'b1000110;
			13 : hex2 = 7'b0100001;
			14 : hex2 = 7'b0000110;
			15 : hex2 = 7'b0001110;
			default: hex2 = 7'b1111111;
		endcase   
		case (data[7:4])
			0 : hex1 = 7'b1000000;
			1 : hex1 = 7'b1111001;
			2 : hex1 = 7'b0100100;
			3 : hex1 = 7'b0110000;
			4 : hex1 = 7'b0011001;
			5 : hex1 = 7'b0010010;
			6 : hex1 = 7'b0000010;
			7 : hex1 = 7'b1111000;
			8 : hex1 = 7'b0000000;
			9 : hex1 = 7'b0010000;
			10 : hex1 = 7'b0001000;
			11 : hex1 = 7'b0000011;
			12 : hex1 = 7'b1000110;
			13 : hex1 = 7'b0100001;
			14 : hex1 = 7'b0000110;
			15 : hex1 = 7'b0001110;
			default: hex1 = 7'b1111111;
		endcase   
		case (data[3:0])
			0 : hex0 = 7'b1000000;
			1 : hex0 = 7'b1111001;
			2 : hex0 = 7'b0100100;
			3 : hex0 = 7'b0110000;
			4 : hex0 = 7'b0011001;
			5 : hex0 = 7'b0010010;
			6 : hex0 = 7'b0000010;
			7 : hex0 = 7'b1111000;
			8 : hex0 = 7'b0000000;
			9 : hex0 = 7'b0010000;
			10 : hex0 = 7'b0001000;
			11 : hex0 = 7'b0000011;
			12 : hex0 = 7'b1000110;
			13 : hex0 = 7'b0100001;
			14 : hex0 = 7'b0000110;
			15 : hex0 = 7'b0001110;
			default: hex0 = 7'b1111111;
		endcase   
	end
	else//state == 1 || data == f0
	begin
		//hex turn off
		hex3 = 7'b1111111;
		hex2 = 7'b1111111;
		hex1 = 7'b1111111;
		hex0 = 7'b1111111;
	end
end
seqment sq5(hex5high,hex5);
seqment sq4(hex4low,hex4);


endmodule 