module exp_nine_vga(
clk,reset,vga_r,vga_g,vga_b,vga_sync_n,
hsync,vsync,valid,rst,clken,pclk
);
input clk;//时钟
input reset;//置位
output wire[7:0] vga_r;
output wire[7:0] vga_g;
output wire[7:0] vga_b;
output wire vga_sync_n;
output wire hsync;//行同步和列同步
output wire vsync;
output wire valid;//消隐信号
input rst;
input clken;
output wire pclk;
reg [23:0] vga_data;//上层模块提供的VGA颜色数据
wire[9:0] h_addr;//提供给上层模块的当前扫描像素点坐标
wire[9:0] v_addr;

always begin
    if(h_addr % 120 < 14)vga_data = 24'hFF0000;
    else if(h_addr % 120 <27)vga_data = 24'h0000FF;
    else vga_data = 24'h00FF00;
end
assign vga_sync_n = 0;
vga_ctrl vga_s(
    .pclk(pclk),//25MHZ时钟
    .reset(1'b0),//置位
    .vga_data(vga_data),//上层模块提供
    .h_addr(h_addr),//提供给上层模块的当前扫描像素点坐标
    .v_addr(v_addr),
    .hsync(hsync),//行同步和列同步信号
    .vsync(vsync),
    .valid(valid),//消隐信号
    .vga_r(vga_r),//红绿蓝颜色信号
    .vga_g(vga_g),
    .vga_b(vga_b)
);

clkgen #(25000000) clk_s(
    .clkin(clk),
    .rst(1'b0),
    .clken(clken),
    .clkout(pclk)
);


endmodule
