module roms(VGA_BLANK_N, clk, ps2_clk, ps2_data, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0, LEDR, vga_clk, vga_data,h_addr,v_addr);
input clk;
input ps2_clk;
input ps2_data;
input vga_clk;
input VGA_BLANK_N;
input [9:0]h_addr;
input [9:0]v_addr;

output reg [23:0] vga_data;
output reg [6:0]HEX5;
output reg [6:0]HEX4;
output reg [6:0]HEX3;
output reg [6:0]HEX2;
output reg [6:0]HEX1;
output reg [6:0]HEX0;
output reg LEDR;

integer x;
integer y;
integer xnei;
integer ynei;
integer index;
integer asc;

wire ovfl;
wire [7:0] data;
wire ready;

(* ram_init_file = "dianzhen.mif" *) reg [11:0] dianzhen [4095:0];//存课程网站给的点阵
reg [7:0] xiancun [1919: 0];//存屏幕上能显示的30*64个字符位置每个位置对应的ASCII码
reg [7:0] ram [255:0];
reg [7:0] rambig [255:0];
reg [5:0] line [29:0];

reg [7:0] count;
reg [7:0] effdata;
reg nextdata_n;
reg state;
reg capslock;
reg shiftlock;
reg [9:0] counth;
reg [9:0] countv;
reg [6:0] countx;
reg [10:0] county;
reg [7:0] ascii;
reg [11:0] dianzhen_line;

initial 
begin
vga_data = 0;
x = 0;
y = 0;
xnei = 0;
ynei = 0;
index = 0;
asc = 0;
counth = 0;
countv = 0;
countx = 0;
county = 0;
ascii = 0;
dianzhen_line = 0;
effdata = 0;
capslock = 0;
shiftlock = 0;
state = 0;
count = 0;
counth = 0;
countv = 0;
end

initial
begin
	$readmemh("D:/exp/exp11/ascii.txt", ram, 0, 255);
	$readmemh("D:/exp/exp11/ascii_big.txt", rambig, 0, 255);
end

always @ (posedge clk)
begin
	if(ready==1)
	begin
	//todo
		if(data == 8'h58)
		begin
			//caps lock
			if(state == 0 && capslock == 0)
			begin
				//lock is eff, from 0 to 1
				capslock = 1;
			end
			else if(state == 1 && capslock == 0)
			begin
				//pre data is f0, this data is not eff
				capslock = 0;
			end
			else if(state == 1 && capslock == 1)
			begin
				capslock = 1;
			end
			else if(state == 0 && capslock == 1)
			begin
				//lock is eff, from 1 to 0
				capslock = 0;
			end
		end
		if(data == 8'h12 || data == 8'h59)
		begin
			//shift lock
			if(state == 0 && shiftlock == 0)
			begin
				//lock is eff, from 0 to 1
				shiftlock = 1;
			end
			else if(state == 1 && shiftlock == 0)
			begin
				//pre data is f0, this data is not eff
				shiftlock = 1;
			end
			else if(state == 1 && shiftlock == 1)
			begin
				shiftlock = 0;
			end
			else if(state == 0 && shiftlock == 1)
			begin
				//lock is eff, from 1 to 0
				shiftlock = 0;
			end
		end
		if((data != 8'b11110000)&&(state == 0))
		begin
			//no f0 before this data
			//so this data is eff
			if(data == 8'h58||data==8'h12||data==8'h59||data==8'h66||data==8'h5a)
			begin
				if(data == 8'h66)
				begin
					xiancun[(county<<6) + countx] = 0;
					if(countx > 0)
					 countx = countx - 1;
					else
					begin
						county =  county - 1;
						countx = line[county];
					end
				end
				else if(data == 8'h5a)
				begin
					line[county] = countx;
					county = county + 1;	
					countx = 0;
				end
			end
			else
			begin
			effdata = data;
			count = count + 1;
			if(counth<576)
			begin 
				countx = countx + 1;
				counth = counth + 9;
			end
			else
			begin
				line[county] = countx;
				counth = 0;
				countx = 0;
				if(countv < 480)
				begin
					county = county + 1;
					countv = countv + 16;
				end
			end
			if(capslock^shiftlock == 0)
			begin
				ascii = ram[data];
			end
			else
			begin
				ascii = rambig[data];
			end
			xiancun[(county<<6) + countx] = ascii;
			end
		end
		else if((data == 8'b11110000)&&(state == 0))
		begin
			//this data is f0
			//so this data is eff
			//and let the count ++
			//and let the state become 1 to show this f0
			effdata = data;
			//count = count + 1;
			state = 1;
		end
		else if((data != 8'b11110000)&&(state == 1))
		begin
			//this data is not f0 and predata is f0
			//so this data is not eff
			//and let the state become 0 to show this is not f0
			state = 0;
			effdata = 8'b11110000;
		end
	//done
		nextdata_n=0;
		end
	end
	

ps2_keyboard pk(clk, 1, ps2_clk, ps2_data, data, ready, nextdata_n, ovfl);
abouthex ah(state, count, effdata, ascii, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);
lock lk(shiftlock, capslock, LEDR);

always @ (posedge vga_clk)
begin
	
	if(h_addr >= 0 && h_addr < 576)
	begin
		y =  v_addr[8:4];
		ynei =  v_addr[3:0];
		asc = xiancun[(y << 6) + x];
		index = (asc << 4) + ynei;
		dianzhen_line = dianzhen[index];
	end
	else
		vga_data = 24'h000000;
		
	if(dianzhen_line[xnei])
		vga_data = 24'hffffff;
	else
		vga_data = 24'h000000;
		
	if(VGA_BLANK_N)
	begin
		if(xnei == 8)
		begin
			x = x + 1;
			xnei = 0;
		end
		else
			xnei = xnei + 1;
		if(x == 64)
			x = 0;
		else
			x = x;
	end
	else 
	begin
		x=0;
		xnei=0;
	end
end
endmodule
