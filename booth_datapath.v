module booth_datapath(LdA,LdQ,LdM,clrA,clrQ,clrff,sftA,sftQ,data_in,addsub,qm1,clk,eqz,decr,ldcnt,q0,reset);
	input [15:0] data_in;
	input clk,LdA,LdM,LdQ,sftA,sftQ,clrA,clrQ,clrff,addsub,decr,ldcnt,reset;
	output qm1,eqz,q0;
	
	wire [15:0] Z,A,M,Q;
	wire [4:0] count;
	
	assign eqz = ~|count; //reduction operator(nor) to check whether the output is zero
	assign q0 = Q[0];
	
	PIPO MR(M,data_in,LdM,clk,reset);
  shiftreg AR(A,A[15],Z,LdA,clrA,sftA,clk,reset);
	shiftreg QR(Q,A[0],data_in,LdQ,clrQ,sftQ,clk,reset);
	dff QM1(qm1,Q[0],clrff,clk,reset);
	ALU AS(Z,A,M,addsub);
	counter CN(count,decr,ldcnt,clk,reset);
endmodule

module PIPO(dout,din,ld,clk,reset);
	input [15:0] din;
	input clk,ld,reset;
	output reg [15:0] dout;
	
	always@(posedge clk)
	begin
	  if(reset) dout <= 0;
		if(ld) dout <= din;
	end
endmodule

module shiftreg(dout,s_in,din,ld,clr,sft,clk,reset);
  input [15:0] din;
	input s_in,ld,clr,sft,clk,reset;
	output reg [15:0] dout;
	
	always@(posedge clk)
	begin
	  if(reset) dout <= 0;
		else if(clr) dout <= 0;
		else if(ld) dout <= din;
		else if(sft) dout <= {s_in,dout[15:1]};
	end
endmodule

module dff(dout,s_in,clr,clk,reset);
	input s_in,clr,clk,reset;
	output reg dout;
	
	always@(posedge clk)
	begin
	  if(reset) dout <= 0;
		else if(clr) dout <= 0;
		else dout <= s_in;
	end
endmodule

module ALU(dout,in1,in2,addsub);
	input [15:0] in1,in2;
	input addsub;
	output reg [15:0] dout;
	
	always@(*)
	begin
		if(addsub ==1) dout = in1+in2;
		else dout = in1-in2;
	end
endmodule

module counter(cnt,dec,ld,clk,reset);
	input dec,ld,clk,reset;
	output reg [4:0] cnt;
	
	always@(posedge clk)
	begin
	  if(reset) cnt <= 0;
		else if(ld) cnt <= 5'b10000;
		else if(dec) cnt <= cnt-1;
	end
endmodule