module lock(shiftlock, capslock, out);
input shiftlock;
input capslock;
output reg out;
always @ (*)
begin
	out = shiftlock ^ capslock;
end
endmodule 