module exp_four_two_trigger(in_data,en,out_lock1,out_lock2,clk,clr_n);

input in_data,en,clk,clr_n;
output out_lock2,out_lock1;
myasynchro G(in_data,en,clk,out_lock1,clr_n);
mysynchro F(in_data,en,clk,out_lock2,clr_n);

endmodule
