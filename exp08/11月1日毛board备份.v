module exp_eight_keyboard(clk, clrn, ps2_clk, ps2_data, seg0, seg1, segm0, segm1, segh0, segh1, flag, flag2);

	input clk, clrn, ps2_clk, ps2_data;
	wire [7:0] data_asc;
	wire [7:0] data_code;
	wire ready;
	wire overflow;

	reg [7:0] data_p;
	reg [7:0] count = 0; // the times that you type
	
	output reg flag = 1;   // judge keyboard-button is valid or not
	output reg flag2 = 1;

	output [6:0] seg0;
	output [6:0] seg1;
	output [6:0] segm0;
	output [6:0] segm1;
	output [6:0] segh0;
	output [6:0] segh1;

	reg all = 1;

	reg [6:0] count_clk = 0;
	reg clk_b = 0;
	always @(posedge clk)
	begin
		if(count_clk == 100)
		begin
			count_clk <= 0;
			clk_b <= ~clk_b;
		end
		else
			count_clk <= count_clk + 1;
	end


	reg nextdata_n2;
	ps2_keyboard S(.clk(clk), .clrn(clrn), .ps2_clk(ps2_clk), .ps2_data(ps2_data), .data(data_code), .ready(ready), .nextdata_n(nextdata_n2), .overflow(overflow));

	light L1(.h(count[7:4]), .l(count[3:0]), .flag(all), .segh(segh1), .segl(segh0));
	light L2(.h(data_asc[7:4]), .l(data_asc[3:0]), .flag(flag), .segh(segm1), .segl(segm0));//flag还是flag2??????
	light L3(.h(data_p[7:4]), .l(data_p[3:0]), .flag(flag), .segh(seg1), .segl(seg0));

	ram R(.code(data_code),.addr(data_asc));
	
	always @(posedge clk_b)
	begin
		if (ready)//ready的情况下将扫描码data读出
		begin
			if(data_code != 8'hf0 && flag2)//没有断码，读取扫描码
			begin
				data_p <= data_code;
				flag2 <= 1;//此时数码管显示
				flag <= 1;//flag=1表示新的按键按下了
			end
			else if (data_code == 8'hf0)//遇到了断码,count++并且继续读取
			begin
				data_p <= data_code;
				count <= count + 1;
				flag <= 0;
				flag2 <= 0;//此时数码管不显示
			end
			else if(!flag2)//出现了非断码，将flag2置为1
			begin
				data_p <= data_code;
				flag2 <= 1;
				flag <= 0;
			end

			nextdata_n2 <= 0;
		end
		else
		begin
			nextdata_n2 <= 1;
		end
	end
endmodule


