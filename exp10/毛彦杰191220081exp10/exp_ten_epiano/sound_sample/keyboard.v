module keyboard(clk,clrn,ps2_data,ps2_clk,hex0,hex1,hex2,hex3,hex4,hex5,frequency);
	input clk,clrn,ps2_clk,ps2_data;
	output reg [6:0] hex0,hex1,hex2,hex3,hex4,hex5;
	output reg [15:0] frequency;//mypart
	
	function [6:0] int_to_seven;
		input [3:0] n;
		begin
			case(n)
				0: int_to_seven = 7'b1000000;
				1: int_to_seven = 7'b1111001;
				2: int_to_seven = 7'b0100100;
				3: int_to_seven = 7'b0110000;
				4: int_to_seven = 7'b0011001;
				5: int_to_seven = 7'b0010010;
				6: int_to_seven = 7'b0000010;
				7: int_to_seven = 7'b1111000;
				8: int_to_seven = 7'b0000000;
				9: int_to_seven = 7'b0010000;
				10:int_to_seven = 7'b0001000;
				11:int_to_seven = 7'b0000011;
				12:int_to_seven = 7'b1000110;
				13:int_to_seven = 7'b0100001;
				14:int_to_seven = 7'b0000110;
				15:int_to_seven = 7'b0001110;
				default: int_to_seven = 7'b1111111;
			endcase
		end
	endfunction
	
	reg myclk = 0;
	reg [6:0] count_clk = 0;
	always @ (posedge clk) begin
		if(count_clk == 100) begin
			count_clk <= 0;
			myclk <= ~myclk;
		end
		else count_clk <= count_clk + 1;
	end
	
	wire ready,overflow;
	reg nextdata_n;
	wire [7:0] data;
	wire [7:0] asc;
	reg [7:0] dout;
	reg [7:0] count = 0;
	reg is_have = 0;
	reg is_break = 0;
	
	ps2_keyboard k(
		.clk(clk),
		.clrn(clrn),
		.ps2_clk(ps2_clk),
		.ps2_data(ps2_data),
		.data(data),
		.ready(ready),
		.overflow(overflow),
		.nextdata_n(nextdata_n));
		
	/*ram r(
		.addr(dout),
		.code(asc));*/
		
	initial begin
		is_have = 0;//flag2为is_have
		is_break = 1;//flag为is_break
	end
	
	always @ (posedge myclk) begin
		if(ready) begin
			if(data != 8'hf0 && is_have) begin
				dout = data;
				is_have <= 1;
				is_break <= 0;
			end
			else if(data == 8'hf0) begin
				dout = data;
				count <= count + 1;
				is_have <= 0;
				is_break <= 1;
			end
			else if(!is_have) begin
				dout = data;
				is_have <= 1;
				is_break <= 1;
			end
			nextdata_n <= 0;
		end
		else 
			begin
			nextdata_n <= 1;
			end
		
		if(is_break) begin
			hex0 <= 7'b1111111;
			hex1 <= 7'b1111111;
			hex2 <= 7'b1111111;
			hex3 <= 7'b1111111;
			//mypart
			frequency = 0;
		end
		else begin
			hex0 <= int_to_seven(dout[3:0]);
			hex1 <= int_to_seven(dout[7:4]);
			//hex2 <= int_to_seven(asc[3:0]);
			//hex3 <= int_to_seven(asc[7:4]);
			//mypart
				case(dout)
				8'h1c: frequency = 179;
				8'h1b: frequency = 714;
				8'h23: frequency = 802;
				8'h2b: frequency = 900;
				8'h34: frequency = 954;
				8'h33: frequency = 1070;
				8'h3b: frequency = 1201;
				8'h42: frequency = 1349;
				default: frequency = 0;
				endcase
		end
		
		hex4 <= int_to_seven(count[3:0]);
		hex5 <= int_to_seven(count[7:4]);
		
	end
endmodule

//lala