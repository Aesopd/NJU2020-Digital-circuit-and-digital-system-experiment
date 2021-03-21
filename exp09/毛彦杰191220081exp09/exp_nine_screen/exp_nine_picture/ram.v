module ram(addr, clk,r,g,b);
	input [18:0] addr;
	input clk;
	output [3:0] r,g,b;
	
	(* ram_init_file = "pic.mif" *) reg [11:0] ram [327679:0];
	reg [11:0] tmp;
	

	always @(posedge clk)
	begin
		tmp <= ram[addr];
	end
	
	assign r = tmp[11:8];
	assign g = tmp[7:4];
	assign b = tmp[3:0];
endmodule
