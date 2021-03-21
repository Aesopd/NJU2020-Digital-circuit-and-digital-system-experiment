module exp_seven_ram(clk,we,inaddr,outaddr,din,dout1,dout2);

input clk;
input we;
input [3:0]	inaddr;
input [3:0]	outaddr;
input [7:0] din;
output [7:0] dout1,dout2;

ram1 G(clk,we,inaddr,outaddr,din,dout1);
memo F(.clock(clk),.data(din),.rdaddress(outaddr),.wraddress(inaddr),.wren(we),.q(dout2));

endmodule
