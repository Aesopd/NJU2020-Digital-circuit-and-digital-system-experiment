module exp_nine_picture(clk,reset,VGA_R,VGA_G,VGA_B,VGA_HS,VGA_VS,VGA_CLK,VGA_SYNC_N,VGA_BLANK_N);
   input clk;
	input reset;
	output [7:0] VGA_R;
	output [7:0] VGA_G;
	output [7:0] VGA_B;
	output VGA_HS,VGA_VS;
	output VGA_CLK;
	output VGA_BLANK_N;
	output VGA_SYNC_N;

assign VGA_SYNC_N = 0;
		
				
clkgen #(25000000) vgaclks(clk,reset,1'b1,VGA_CLK);

wire [9:0] h_addr;
wire [9:0] v_addr;
wire [3:0] r,g,b;

ram ram(
	.addr({h_addr,v_addr[8:0]}),
	.clk(VGA_CLK),
	.r(r),
	.g(g),
	.b(b));
	
	
vga_ctrl VGA(
 .pclk(VGA_CLK), //25MHz 时 钟
 .reset(reset), //置位
 .vga_data({r,4'b0000,g,4'b0000,b,4'b0000}), //上层模块提供的VGA颜色数据
 .h_addr(h_addr), //提供给上层模块的当前扫描像素点坐标 
 .v_addr(v_addr),
 .hsync(VGA_HS), //行同步和列同步信号 
 .vsync(VGA_VS),
 .valid(VGA_BLANK_N), //消隐信号
 .vga_r(VGA_R), //红绿蓝颜色信号 
 .vga_g(VGA_G),
 .vga_b(VGA_B)
 );	


endmodule 