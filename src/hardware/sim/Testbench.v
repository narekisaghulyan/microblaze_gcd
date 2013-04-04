`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   01:00:30 02/19/2013
// Design Name:   gcd_coprocessor
// Module Name:   /home/cc/cs150/sp13/staff/cs150-tb/labs/edklab_stu/runThroughAddHdGCD/pcores/gcd_coprocessor_v1_00_a/devl/projnav/Testbench.v
// Project Name:  gcd_coprocessor
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: gcd_coprocessor
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Testbench;
	
	parameter N1 = 15;
	parameter N2 = 45;
	parameter gcd = 15;
	
	// Inputs
	reg FSL_Clk;
	reg FSL_Rst;
	reg FSL_S_Clk;
	wire [0:31] FSL_S_Data;
	reg FSL_S_Control;
	wire FSL_S_Exists;
	reg FSL_M_Clk;
	reg FSL_M_Full;

	// Outputs
	wire FSL_S_Read;
	wire FSL_M_Write;
	wire [0:31] FSL_M_Data;
	wire FSL_M_Control;


	// Instantiate the Unit Under Test (UUT)
	gcd_coprocessor uut (
		.FSL_Clk(FSL_Clk), 
		.FSL_Rst(FSL_Rst), 
		.FSL_S_Clk(FSL_S_Clk), 
		.FSL_S_Read(FSL_S_Read), 
		.FSL_S_Data(FSL_S_Data), 
		.FSL_S_Control(FSL_S_Control), 
		.FSL_S_Exists(FSL_S_Exists), 
		.FSL_M_Clk(FSL_M_Clk), 
		.FSL_M_Write(FSL_M_Write), 
		.FSL_M_Data(FSL_M_Data), 
		.FSL_M_Control(FSL_M_Control), 
		.FSL_M_Full(FSL_M_Full)
	);
	// clock period 20;
	parameter CYCLE = 20;
	always#(10)
		FSL_Clk = ~FSL_Clk;
	
	// make a state machine to feed the module
	localparam FirstNum = 3'b001;
	localparam SecondNum = 3'b010;
	localparam Done = 3'b100;
	
	reg [2:0] state;
	assign FSL_S_Data = (state == FirstNum)? N1:N2;
	assign FSL_S_Exists = (state == FirstNum) || (state == SecondNum);
	always@(posedge FSL_Clk)
		begin
			if(FSL_Rst)
				state <= FirstNum;
			else
				case(state)
					FirstNum:						
						if(FSL_S_Read)
							state <= SecondNum;
						else
							state <= FirstNum;
					SecondNum:
						if(FSL_S_Read)
							state <= Done;
						else
							state <= Done;
					Done:
						state <= Done;
				endcase
		end
	// read out the final result 			
	reg [31:0] finalResult;
	always@(posedge FSL_Clk)
		begin
			if(FSL_Rst == 1)
				finalResult <=0;
			else
				if(FSL_M_Write);
					finalResult <= FSL_M_Data;
		end
	initial begin
		// Initialize Inputs
		FSL_Clk = 0;
		FSL_Rst = 1;
		FSL_M_Full = 0;

		// Wait 100 ns for global reset to finish
		#90;
		// Add stimulus here
		FSL_Rst = 0;
		while(!FSL_M_Write)
			begin
				#(CYCLE);
				if($time() > 100000)
					$display("simulation timeout, you might want to change your testcase");
			end
		
		#(CYCLE);
		if(finalResult != gcd)
			$display("gcd is not found");
		else
			$display("test passed");
		$finish();
		
	end
      
endmodule

