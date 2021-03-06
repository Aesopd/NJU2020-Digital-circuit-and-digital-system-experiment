module unobstructive(clk,in_en,out_lock1,in_data,out_lock2);
input clk;
input in_en;
input in_data;
output reg out_lock1,out_lock2;
always@(posedge clk)
	if(in_en)
		begin
			out_lock1<=in_data;
			out_lock2<=out_lock1;
		end
	else
		begin
			out_lock1<=out_lock1;
			out_lock2<=out_lock2;
		end
endmodule
