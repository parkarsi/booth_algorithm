module booth_test;
	reg [15:0] data_in;
	reg clk, start,reset;
	wire done;
	
	booth_datapath DP(LdA,LdQ,LdM,clrA,clrQ,clrff,sftA,sftQ,data_in,addsub,qm1,clk,eqz,decr,ldcnt,q0,reset);
	booth_controlpath CON(LdA,LdQ,LdM,clrA,clrQ,clrff,sftA,sftQ,data_in,addsub,qm1,clk,q0,start,done,decr,ldcnt,eqz,reset);
	
	always #5 clk = ~clk;
	
	initial begin
		clk = 1'b0;
		@(negedge clk);
		reset = 1'b1;
		repeat(2)
		@(negedge clk);
		reset = 1'b0;
		start = 1'b1;
		@(negedge clk);
		start = 1'b0;
		data_in = -2;
		@(negedge clk);
		data_in = 2;
		#1000 $finish;
	end

	
	initial begin
      $monitor($time, "%h, %b",DP.Q,done);
		$dumpvars(0,booth_test);
		$dumpfile("booth.vcd");
	end
endmodule