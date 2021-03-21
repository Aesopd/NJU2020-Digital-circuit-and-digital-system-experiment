module myasynchro(in_data,en,clk,out_lock1,clr_n);
input in_data,en,clk,clr_n;
output reg out_lock1;

initial out_lock1=0;
always @(posedge clk or negedge clr_n) 
begin
	if(!clr_n)
		begin
		if(en)
		out_lock1<=0;
		else
		out_lock1<=out_lock1;
		end
	else
	
		begin
		if(en)
		out_lock1<=in_data;
		else
		out_lock1<=out_lock1;
		end

end
endmodule
