// Copyright (C) 2017  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel FPGA IP License Agreement, or other applicable license
// agreement, including, without limitation, that your use is for
// the sole purpose of programming logic devices manufactured by
// Intel and sold by Intel or its authorized distributors.  Please
// refer to the applicable agreement for further details.

// *****************************************************************************
// This file contains a Verilog test bench template that is freely editable to  
// suit user's needs .Comments are provided in each section to help the user    
// fill out necessary details.                                                  
// *****************************************************************************
// Generated on "11/01/2020 21:16:52"
                                                                                
// Verilog Test Bench template for design : exp_eight_keyboard
// 
// Simulation tool : ModelSim-Altera (Verilog)
// 

`timescale 1 ns/ 1 ps

module ps2_keyboard_model( output reg ps2_clk, output reg ps2_data);
parameter [31:0] kbd_clk_period = 60;
initial ps2_clk = 1'b1; 

task kbd_sendcode;
    input [7:0] code; // key to be sent
    integer i;

    reg[10:0] send_buffer;
    begin
        send_buffer[0] = 1'b0; // start bit
        send_buffer[8:1] = code; // code
        send_buffer[9] = ~(^code); // odd parity bit
        send_buffer[10] = 1'b1; // stop bit
        i = 0;
        while( i < 11) begin
            // set kbd_data
            ps2_data = send_buffer[i];
            #(kbd_clk_period/2) ps2_clk = 1'b0;
            #(kbd_clk_period/2) ps2_clk = 1'b1;
            i = i + 1;
        end
    end
endtask

endmodule


module exp_eight_keyboard_vlg_tst();
// constants                                           
// general purpose registers
//reg eachvec;
// test vector input registers
reg clk;
reg clrn;
reg ps2_clk;
reg ps2_data;
// wires                                               
wire flag;
wire flag2;
wire [6:0]  seg0;
wire [6:0]  seg1;
wire [6:0]  segh0;
wire [6:0]  segh1;
wire [6:0]  segm0;
wire [6:0]  segm1;

ps2_keyboard_model model(
.ps2_clk(kbd_clk),
.ps2_data(kbd_data)
);

// assign statements (if any)                          
exp_eight_keyboard i1 (
// port map - connection between master ports and signals/registers   
	.clk(clk),
	.clrn(clrn),
	.flag(flag),
	.flag2(flag2),
	.ps2_clk(ps2_clk),
	.ps2_data(ps2_data),
	.seg0(seg0),
	.seg1(seg1),
	.segh0(segh0),
	.segh1(segh1),
	.segm0(segm0),
	.segm1(segm1)
);
initial                                                
begin 
                                                 
// code that executes only once                        
// insert code here --> begin  
	clk=0;
	clrn=1'b0;	#20;
	clrn=1'b1;	#20;
	model.kbd_sendcode(8'h1c);//press'A'
	//#20 nextdata_n=1'b0;	#20 nextdata_n=1'b1;	//read data
	model.kbd_sendcode(8'hF0);//break code
	//#20 nextdata_n=1'b0;	#20 nextdata_n=1'b1;	//read data
	model.kbd_sendcode(8'h1C);//release'A'
	//#20 nextdata_n=1'b0;	#20 nextdata_n=1'b1;	//read data
	model.kbd_sendcode(8'h1B);//press'S'
	#20  model.kbd_sendcode(8'h1B);//keep pressing 'S'
	#20  model.kbd_sendcode(8'h1B);//keep pressing 'S'
	model.kbd_sendcode(8'hF0);//break code
	model.kbd_sendcode(8'h1B);//release'S'
// --> end                                             
$display("Running testbench");                       
end                                                    
always                                                              
begin                                                                          
   #1 clk=~clk;                                                                                              
end                                                    
endmodule

